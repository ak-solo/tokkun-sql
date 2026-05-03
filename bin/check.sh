#!/usr/bin/env bash
# 使い方:
#   bin/check.sh                  # 全チャプターをテスト
#   bin/check.sh chapter01        # 1チャプターをテスト
#   bin/check.sh chapter01/ex01   # 1問だけテスト

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$SCRIPT_DIR/.."
PASS=0
FAIL=0
SKIP=0

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

if [ -z "${DATABASE_URL:-}" ]; then
  echo "エラー: DATABASE_URL が設定されていません。"
  echo "  例: export DATABASE_URL=postgresql://postgres:postgres@db:5432/tokkun_sql"
  exit 1
fi

# ヘッダー行を除いたデータ行をソートして返す（行順序に依存しない比較のため）
data_rows_sorted() {
  tail -n +2 | sort
}

# 学習者SQLファイルが未回答（コメントと空白のみ）かどうか確認
is_empty() {
  local file="$1"
  local content
  content=$(grep -v '^\s*--' "$file" | tr -d '[:space:]')
  [ -z "$content" ]
}

# SELECT系テスト: 学習者SQL vs ref SQL の出力を比較
test_select() {
  local exercise_file="$1"
  local ref_file="$2"
  local label="$3"

  if [ ! -f "$exercise_file" ]; then
    echo -e "${YELLOW}SKIP${RESET} $label (ファイルなし)"
    SKIP=$((SKIP + 1))
    return
  fi

  if is_empty "$exercise_file"; then
    echo -e "${YELLOW}SKIP${RESET} $label (未回答)"
    SKIP=$((SKIP + 1))
    return
  fi

  local actual expected err_actual
  actual=$(psql "$DATABASE_URL" --csv -q -f "$exercise_file" 2>/tmp/tokkun_sql_err || true)
  err_actual=$(cat /tmp/tokkun_sql_err 2>/dev/null || true)

  if [ -n "$err_actual" ]; then
    echo -e "${RED}FAIL${RESET} $label"
    echo "  SQLエラー: $(echo "$err_actual" | head -3 | sed 's/^/    /')"
    FAIL=$((FAIL + 1))
    return
  fi

  expected=$(psql "$DATABASE_URL" --csv -q -f "$ref_file" 2>/dev/null || true)

  local actual_sorted expected_sorted
  actual_sorted=$(printf '%s\n' "$actual" | data_rows_sorted)
  expected_sorted=$(printf '%s\n' "$expected" | data_rows_sorted)

  if [ "$actual_sorted" = "$expected_sorted" ]; then
    echo -e "${GREEN}PASS${RESET} $label"
    PASS=$((PASS + 1))
  else
    echo -e "${RED}FAIL${RESET} $label"
    echo "  期待される出力:"
    printf '%s\n' "$expected" | head -6 | sed 's/^/    /'
    echo "  あなたの出力:"
    printf '%s\n' "$actual" | head -6 | sed 's/^/    /'
    local expected_header actual_header
    expected_header=$(printf '%s\n' "$expected" | head -1)
    actual_header=$(printf '%s\n' "$actual" | head -1)
    if [ "$actual_header" != "$expected_header" ]; then
      echo "  ※ カラム名が違います → 期待: '$expected_header'  実際: '$actual_header'"
    fi
    FAIL=$((FAIL + 1))
  fi
}

# DML系テスト: DB リセット → 学習者SQL実行 → verify SQL で状態確認
test_dml() {
  local exercise_file="$1"
  local verify_file="$2"
  local expected_file="$3"
  local label="$4"

  if [ ! -f "$exercise_file" ]; then
    echo -e "${YELLOW}SKIP${RESET} $label (ファイルなし)"
    SKIP=$((SKIP + 1))
    return
  fi

  if is_empty "$exercise_file"; then
    echo -e "${YELLOW}SKIP${RESET} $label (未回答)"
    SKIP=$((SKIP + 1))
    return
  fi

  # DBリセット
  psql "$DATABASE_URL" -q -f "$ROOT/init/reset.sql" > /dev/null 2>&1

  # 学習者のDMLを実行
  local err_dml
  psql "$DATABASE_URL" -q -f "$exercise_file" > /dev/null 2>/tmp/tokkun_sql_err || true
  err_dml=$(cat /tmp/tokkun_sql_err 2>/dev/null || true)
  if [ -n "$err_dml" ]; then
    echo -e "${RED}FAIL${RESET} $label"
    echo "  SQLエラー: $(echo "$err_dml" | head -3 | sed 's/^/    /')"
    FAIL=$((FAIL + 1))
    return
  fi

  # verify クエリでDB状態を確認し、期待値と比較
  local actual expected_content actual_sorted expected_sorted
  actual=$(psql "$DATABASE_URL" --csv -q -f "$verify_file" 2>/dev/null || true)
  expected_content=$(cat "$expected_file")

  actual_sorted=$(printf '%s\n' "$actual" | data_rows_sorted)
  expected_sorted=$(printf '%s\n' "$expected_content" | data_rows_sorted)

  if [ "$actual_sorted" = "$expected_sorted" ]; then
    echo -e "${GREEN}PASS${RESET} $label"
    PASS=$((PASS + 1))
  else
    echo -e "${RED}FAIL${RESET} $label"
    echo "  期待される出力:"
    printf '%s\n' "$expected_content" | head -6 | sed 's/^/    /'
    echo "  あなたの出力:"
    printf '%s\n' "$actual" | head -6 | sed 's/^/    /'
    FAIL=$((FAIL + 1))
  fi
}

run_chapter() {
  local chapter="$1"
  echo ""
  echo "=== $chapter ==="

  case "$chapter" in
    chapter07)
      for ex in 01 02 03 04 05 06; do
        local verify="$ROOT/tests/verify/$chapter/ex${ex}.sql"
        local expected="$ROOT/tests/expected/$chapter/ex${ex}.csv"
        local exercise="$ROOT/exercises/$chapter/ex${ex}.sql"
        if [ -f "$verify" ] && [ -f "$expected" ]; then
          test_dml "$exercise" "$verify" "$expected" "$chapter/ex${ex}"
        fi
      done
      ;;
    chapter08)
      echo -e "${YELLOW}SKIP${RESET} $chapter は DDL のため自動テスト対象外です"
      echo "  psql で '\\d テーブル名' を使って手動確認してください"
      ;;
    chapter03)
      echo "  ※ ORDER BY の順序は自動テストで検証されません。出力内容（行のセット）のみ確認します"
      for ex_file in "$ROOT/exercises/$chapter"/ex*.sql; do
        [ -f "$ex_file" ] || continue
        local ex
        ex=$(basename "$ex_file" .sql)
        local ref="$ROOT/tests/ref/$chapter/${ex}.sql"
        if [ -f "$ref" ]; then
          test_select "$ex_file" "$ref" "$chapter/$ex"
        fi
      done
      ;;
    *)
      for ex_file in "$ROOT/exercises/$chapter"/ex*.sql; do
        [ -f "$ex_file" ] || continue
        local ex
        ex=$(basename "$ex_file" .sql)
        local ref="$ROOT/tests/ref/$chapter/${ex}.sql"
        if [ -f "$ref" ]; then
          test_select "$ex_file" "$ref" "$chapter/$ex"
        fi
      done
      ;;
  esac
}

# 引数を解析して実行
TARGET="${1:-}"

if [ -z "$TARGET" ]; then
  for ch in chapter01 chapter02 chapter03 chapter04 chapter05 chapter06 chapter07 chapter08 chapter09; do
    run_chapter "$ch"
  done
elif [[ "$TARGET" == *"/"* ]]; then
  chapter="${TARGET%%/*}"
  ex="${TARGET##*/}"
  echo ""
  echo "=== $chapter/$ex ==="
  local_exercise="$ROOT/exercises/$chapter/${ex}.sql"
  case "$chapter" in
    chapter07)
      test_dml "$local_exercise" \
               "$ROOT/tests/verify/$chapter/${ex}.sql" \
               "$ROOT/tests/expected/$chapter/${ex}.csv" \
               "$chapter/$ex"
      ;;
    chapter08)
      echo -e "${YELLOW}SKIP${RESET} DDL は手動確認してください"
      ;;
    *)
      test_select "$local_exercise" \
                  "$ROOT/tests/ref/$chapter/${ex}.sql" \
                  "$chapter/$ex"
      ;;
  esac
else
  run_chapter "$TARGET"
fi

echo ""
echo "結果: ${GREEN}${PASS} PASS${RESET} / ${RED}${FAIL} FAIL${RESET} / ${YELLOW}${SKIP} SKIP${RESET}"

[ "$FAIL" -eq 0 ]
