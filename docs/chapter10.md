# Chapter 10: ビュー（VIEW）

## このチャプターで学ぶこと

- `CREATE VIEW` によるビューの定義
- ビューを使った `SELECT`
- `CREATE OR REPLACE VIEW` によるビューの再定義
- `DROP VIEW` によるビューの削除

---

## 使用するテーブル

employees, departments

---

## 基礎知識

### 1. VIEW とは

ビューは **`SELECT` クエリに名前をつけた仮想テーブル**です。
実データを持たず、参照されるたびに定義の `SELECT` が実行されます。

**ビューの利点:**

- よく使うクエリに名前をつけて再利用できる
- 複雑な JOIN や集計を隠蔽してシンプルに見せられる
- 特定のカラムだけ公開するアクセス制御に使える

### 2. CREATE VIEW

> **例で使うテーブルについて:** 以下の例では架空の `books`（書籍）・`genres`（ジャンル）テーブルを使います。演習問題で使うテーブルとは異なりますが、VIEW の書き方は同じです。

```sql
CREATE VIEW book_genre_view AS
SELECT b.title, g.name AS ジャンル名, b.price
FROM books b
LEFT JOIN genres g ON b.genre_id = g.id;
```

作成後は通常のテーブルと同様に `SELECT` できます。

```sql
SELECT * FROM book_genre_view;
SELECT * FROM book_genre_view WHERE price > 3000;
```

> `\dv` でビューの一覧、`\d ビュー名` でビューの定義を確認できます。

### 3. CREATE OR REPLACE VIEW

既存のビューを再定義します。ビューが存在しなければ新規作成されます。
同じスクリプトを何度でも実行できるよう、演習では `CREATE OR REPLACE VIEW` を使います。

```sql
CREATE OR REPLACE VIEW book_genre_view AS
SELECT b.id, b.title, g.name AS ジャンル名, b.price  -- id カラムを追加
FROM books b
LEFT JOIN genres g ON b.genre_id = g.id;
```

> **注意:** PostgreSQL では既存カラムの削除・順序変更を伴う変更は `CREATE OR REPLACE VIEW` では行えません。そのような場合は `DROP VIEW` してから `CREATE VIEW` し直します。

### 4. DROP VIEW

```sql
DROP VIEW book_genre_view;
DROP VIEW IF EXISTS book_genre_view;                          -- 存在しない場合もエラーにしない
DROP VIEW IF EXISTS book_genre_view, genre_stats_view;        -- 複数まとめて削除
```

---

## 演習

> 各問題のSQLファイルには `CREATE OR REPLACE VIEW` と `SELECT` をセットで記述します。
> `CREATE OR REPLACE VIEW` にすることで、何度実行しても同じ結果になります。

---

### 問題 10-1: CREATE VIEW（JOIN）

**ファイル:** `exercises/chapter10/ex01.sql`

`employees` と `departments` を LEFT JOIN したビュー `emp_dept_view` を定義してください。
取得するカラム: `employees.id`、`employees.name`（社員名）、`departments.name`（部署名）、`salary`

定義後、`emp_dept_view` から全行を `id` の昇順で取得してください。

**期待される結果（10行）:**

| id | name   | 部署名         | salary |
|----|--------|---------------|--------|
| 1  | 花子   | 開発           | 75000  |
| 2  | 一郎   | 開発           | 60000  |
| 3  | 美子   | マーケティング  | 55000  |
| 4  | 悠介   | マーケティング  | 50000  |
| 5  | 由子   | 人事           | 65000  |
| 6  | 健太   | 開発           | 80000  |
| 7  | あかね | 営業           | 48000  |
| 8  | 昭二   | NULL           | 45000  |
| 9  | 京子   | 人事           | 58000  |
| 10 | 翔太   | 営業           | 52000  |

---

### 問題 10-2: ビューへの SELECT

**ファイル:** `exercises/chapter10/ex02.sql`

`emp_dept_view`（問題 10-1 と同じ定義）から、**`salary` が 60000 以上の社員**を `salary` の降順で取得してください。

> ビューを参照する前に `CREATE OR REPLACE VIEW` で定義し直してください。

**期待される結果（4行）:**

| id | name | 部署名 | salary |
|----|------|-------|--------|
| 6  | 健太 | 開発  | 80000  |
| 1  | 花子 | 開発  | 75000  |
| 5  | 由子 | 人事  | 65000  |
| 2  | 一郎 | 開発  | 60000  |

---

### 問題 10-3: CREATE VIEW（集計）

**ファイル:** `exercises/chapter10/ex03.sql`

部署ごとの**社員数**と**平均給与**（`ROUND` で小数点以下四捨五入）を持つビュー `dept_stats_view` を定義してください。
取得するカラム: `部署名`、`人数`、`平均給与`

`dept_id` が NULL の社員は除外し、`departments` テーブルの部署名を使ってください。

定義後、`dept_stats_view` から全行を `平均給与` の降順で取得してください。

**期待される結果（4行）:**

| 部署名         | 人数 | 平均給与 |
|---------------|------|---------|
| 開発           | 3    | 71667   |
| 人事           | 2    | 61500   |
| マーケティング  | 2    | 52500   |
| 営業           | 2    | 50000   |

---

### 問題 10-4: DROP VIEW

**ファイル:** `exercises/chapter10/ex04.sql`

`emp_dept_view` と `dept_stats_view` の 2 つのビューを削除してください。
ビューが存在しない場合でもエラーにならないよう `IF EXISTS` を使ってください。

削除後、`\dv` でビューが消えていることを確認してください。
