# tokkun-sql — SQL ハンズオン学習教材

## プロジェクト概要

PostgreSQL を使った初学者向け SQL 学習教材。
「基礎説明 → playground で実験 → exercises/ に回答を書く → 期待結果と見比べて自己検証」
というサイクルで、手を動かしながら学べることを目指す。

### 学習の流れ

```
1. docs/ の README（基礎説明 + 問題文）を読む
2. playground/scratch.sql で自由にクエリを試す
3. exercises/chapterXX/exYY.sql に回答を書く
4. bin/check.sh で自動テストを実行して正誤を確認する
```

---

## ディレクトリ構成

```
tokkun-sql/
├── docs/
│   ├── chapter01.md        # 基礎説明 + 問題文 + 期待結果（章ごと）
│   ├── chapter02.md
│   └── ...
├── exercises/
│   ├── chapter01/
│   │   ├── ex01.sql        # 学習者が回答を書くファイル
│   │   ├── ex02.sql
│   │   └── ...
│   └── ...
├── init/
│   ├── 00_schema.sql       # テーブル定義（devcontainer 起動時に自動実行）
│   └── 01_seed.sql         # テストデータ（devcontainer 起動時に自動実行）
├── playground/
│   └── scratch.sql         # 自由に試せるスクラッチ領域
├── bin/
│   └── check.sh            # 自動テストランナー
├── tests/
│   ├── ref/chapterXX/      # 正解SQL（SELECT系チャプター）
│   ├── verify/chapter07/   # DML後の状態確認クエリ
│   └── expected/chapter07/ # DML後の期待値CSV
├── .devcontainer/
│   ├── devcontainer.json
│   ├── docker-compose.yml  # app コンテナ + PostgreSQL コンテナ
│   └── Dockerfile
└── CLAUDE.md
```

---

## データベース接続

### ターミナルから psql を使う

```bash
# DATABASE_URL 環境変数が設定済みなので、これだけで接続できる
psql "$DATABASE_URL"

# SQL ファイルを実行する
psql "$DATABASE_URL" -f exercises/chapter01/ex01.sql

# 1行クエリを実行する
psql "$DATABASE_URL" -c "SELECT * FROM employees;"
```

### VSCode SQLTools 拡張を使う

サイドバーの「SQLTools」アイコン → `tokkun-sql` 接続 → SQL ファイルを開いて実行ボタン

---

## データシナリオ（全章共通）

架空の会社の社内システムを題材にしています。

### テーブル関係

```
departments          employees
───────────          ─────────────────────────────────
id                   id
name        1──┐     name
location       └──< dept_id        (NULL = 未配属)
                     salary
                     hire_date
                     manager_id ──┐ (自己参照: 上司)
                              ┌──┘
                              └──> id

employee_projects >──┤          projects
────────────────      │          ────────
employee_id ──────────┘          id
project_id  ────────────────────> id          name
role                              start_date
                                  end_date   (NULL = 進行中)
                                  budget
```

### 各テーブルのデータ概要

| テーブル            | 行数 | 概要                     |
|---------------------|------|--------------------------|
| `departments`       | 5    | 部署（Engineering 等）    |
| `employees`         | 10   | 社員（NULL dept_id あり） |
| `projects`          | 4    | プロジェクト（NULL end_date あり） |
| `employee_projects` | 12   | 社員とプロジェクトの中間テーブル |

---

## 章の構成

| 章 | タイトル | 主なトピック |
|----|----------|--------------|
| 01 | SELECT 基本 | `*`、カラム指定、エイリアス、文字列結合、計算式、`DISTINCT` |
| 02 | WHERE | 比較演算子、`AND`/`OR`/`NOT`、`LIKE`、`BETWEEN`、`IN`、`IS NULL` |
| 03 | 並び替え・絞り込み | `ORDER BY`、`LIMIT`、`OFFSET` |
| 04 | 集計 | `COUNT`/`SUM`/`AVG`/`MIN`/`MAX`、`GROUP BY`、`HAVING` |
| 05 | JOIN | `INNER JOIN`、`LEFT JOIN`、複数テーブル結合、自己結合 |
| 06 | サブクエリ | スカラーサブクエリ、`IN`/`EXISTS`、`FROM` 句サブクエリ |
| 07 | DML | `INSERT`、`UPDATE`、`DELETE`、`RETURNING` |
| 08 | DDL | `CREATE TABLE`、制約、`ALTER TABLE` |
| 09 | 応用 | CTE（`WITH`）、ウィンドウ関数 |
| 10 | ビュー | `CREATE VIEW`、`CREATE OR REPLACE VIEW`、`DROP VIEW` |
| 11 | 総合演習 | JOIN・サブクエリ・ウィンドウ関数・CTE の複合問題 |

---

## 便利な psql コマンド

```sql
\dt             -- テーブル一覧を表示
\d employees    -- employees テーブルの定義を表示
\x              -- 縦表示モードの切り替え（wide な結果を見やすくする）
\q              -- psql を終了
```

---

## 確認コマンド

```bash
# クエリを実行する
psql "$DATABASE_URL" -f exercises/chapter01/ex01.sql

# playground で自由に試す
psql "$DATABASE_URL" -f playground/scratch.sql

# 対話モードで接続する
psql "$DATABASE_URL"
```

## 自動テスト

```bash
# 全チャプターをテスト
bin/check.sh

# 1チャプターだけテスト
bin/check.sh chapter01

# 1問だけテスト
bin/check.sh chapter01/ex01
```

### テストの仕組み

| チャプター | テスト方式 |
|-----------|----------|
| 01〜06, 09, 10, 11 | 学習者SQLと正解SQLの出力を比較（行の順序は問わない） |
| 07 (DML)       | DBリセット → 学習者SQL実行 → 状態確認クエリで検証 |
| 08 (DDL)       | 自動テスト対象外。`\d テーブル名` で手動確認 |

> **注意:** chapter03 の ORDER BY（並び順）は自動テストで検証されません。出力の行セットが正しいかのみ確認します。

## Git コミット方針

- コミットは **変更理由（目的）ごとに分割**すること
- 1コミット = 1つの論理的な変更（機能追加・バグ修正・リファクタリングを混在させない）
- コミット前に変更内容を確認し、複数の目的が混在していれば必ず分割する
- ファイルをまとめて `git add .` せず、目的ごとに `git add <ファイル>` で個別にステージングすること
- コミットメッセージは「何をしたか」ではなく「**なぜ**その変更をしたか」を書く

### 分割の例

| 悪い例（1コミット） | 良い例（分割） |
|---------------------|----------------|
| 問題追加 + テスト追加 + CLAUDE.md 更新 | ① 問題ファイル追加 ② テスト追加 ③ CLAUDE.md 更新 |
| バグ修正 + 新機能追加 | ① バグ修正 ② 新機能追加 |
