# データベース接続

## ターミナルから psql を使う

```bash
# DATABASE_URL 環境変数が設定済みなので、これだけで接続できる
psql "$DATABASE_URL"

# SQL ファイルを実行する
psql "$DATABASE_URL" -f exercises/chapter01/ex01.sql

# 1行クエリを実行する
psql "$DATABASE_URL" -c "SELECT * FROM employees;"
```

## VSCode SQLTools 拡張を使う

サイドバーの「SQLTools」アイコン → `tokkun-sql` 接続 → SQL ファイルを開いて実行ボタン

## 便利な psql コマンド

```sql
\dt             -- テーブル一覧を表示
\d employees    -- employees テーブルの定義を表示
\x              -- 縦表示モードの切り替え（wide な結果を見やすくする）
\q              -- psql を終了
```

## 確認コマンド

```bash
# クエリを実行する
psql "$DATABASE_URL" -f exercises/chapter01/ex01.sql

# playground で自由に試す
psql "$DATABASE_URL" -f playground/scratch.sql

# 対話モードで接続する
psql "$DATABASE_URL"
```
