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
├── .claude/
│   └── rules/
│       ├── database.md     # DB接続・psqlコマンド
│       ├── testing.md      # 自動テストの仕組み
│       └── git.md          # Gitコミット方針
├── .devcontainer/
│   ├── devcontainer.json
│   ├── docker-compose.yml  # app コンテナ + PostgreSQL コンテナ
│   └── Dockerfile
└── CLAUDE.md
```

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
| 00 | はじめに | データベース・テーブル・SQL・NULL の基礎概念、使用テーブルの紹介 |
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
