# Chapter 06: サブクエリ

## このチャプターで学ぶこと

- スカラーサブクエリ（単一値を返すサブクエリ）
- `IN` サブクエリ
- 相関サブクエリ
- `EXISTS` / `NOT EXISTS`
- `FROM` 句のサブクエリ（インラインビュー）

---

## 使用するテーブル

全テーブル（employees, departments, projects, employee_projects）

---

## 基礎知識

> **例で使うテーブルについて:** 以下の例では架空の `books`（書籍）・`reviews`（レビュー）テーブルを使います。演習問題で使うテーブルとは異なりますが、サブクエリの書き方は同じです。

### 1. スカラーサブクエリ

1行1カラムの値を返すサブクエリです。`WHERE` 句の比較値として使います。

```sql
-- 平均価格より高い書籍
SELECT title, price
FROM books
WHERE price > (SELECT AVG(price) FROM books);
```

括弧の中のクエリが先に実行され、その結果（単一の値）を外側のクエリが使います。

### 2. IN サブクエリ

サブクエリが返すリストを `IN` で参照します。

```sql
-- レビューが付いている書籍
SELECT title
FROM books
WHERE id IN (SELECT book_id FROM reviews);
```

### 3. 相関サブクエリ

外側のクエリの各行を参照するサブクエリです。行ごとに実行されます。

```sql
-- 同じジャンルの平均より価格が高い書籍
SELECT title, genre_id, price
FROM books b
WHERE price > (
    SELECT AVG(price)
    FROM books b2
    WHERE b2.genre_id = b.genre_id  -- 外側のクエリの genre_id を参照
);
```

### 4. EXISTS / NOT EXISTS

サブクエリに1行でも結果があれば真を返します。

```sql
-- 評価 5 のレビューが付いている書籍
SELECT title
FROM books b
WHERE EXISTS (
    SELECT 1
    FROM reviews r
    WHERE r.book_id = b.id AND r.rating = 5
);
```

### 5. FROM 句のサブクエリ（インラインビュー）

`FROM` 句にサブクエリを置いて、仮想のテーブルとして扱います。

```sql
SELECT * FROM (
    SELECT genre_id, ROUND(AVG(price)) AS avg_price
    FROM books
    GROUP BY genre_id
) sub
WHERE sub.avg_price >= 2500;
```

---

## 演習

---

### 問題 6-1: スカラーサブクエリ

**ファイル:** `exercises/chapter06/ex01.sql`

`employees` テーブルから、**全社員の平均給与より高い給与**を持つ社員の
`id`、`name`、`salary` を取得してください。`salary` の降順で並べてください。

> 全社員の平均給与は 58800 円です。

**期待される結果（4行）:**

| id | name | salary |
|----|------|--------|
| 6  | 健太 | 80000  |
| 1  | 花子 | 75000  |
| 5  | 由子 | 65000  |
| 2  | 一郎 | 60000  |

---

### 問題 6-2: IN サブクエリ

**ファイル:** `exercises/chapter06/ex02.sql`

`employees` テーブルから、**いずれかのプロジェクトに参加している**社員の
`id` と `name` を取得してください。`id` の昇順で並べてください。

**期待される結果（9行 — 昭二のみ参加なし）:**

| id | name  |
|----|-------|
| 1  | 花子  |
| 2  | 一郎  |
| 3  | 美子  |
| 4  | 悠介  |
| 5  | 由子  |
| 6  | 健太  |
| 7  | あかね |
| 9  | 京子  |
| 10 | 翔太  |

---

### 問題 6-3: 相関サブクエリ

**ファイル:** `exercises/chapter06/ex03.sql`

`employees` テーブルから、**自分の部署の平均給与より高い給与**を持つ社員の
`name`、`dept_id`、`salary` を取得してください。`dept_id` の昇順、同じ部署なら `salary` の降順で並べてください。

> `dept_id` が NULL の社員（昭二）は除外されます。

**期待される結果（5行）:**

| name | dept_id | salary |
|------|---------|--------|
| 健太 | 1       | 80000  |
| 花子 | 1       | 75000  |
| 美子 | 2       | 55000  |
| 由子 | 3       | 65000  |
| 翔太 | 4       | 52000  |

---

### 問題 6-4: EXISTS

**ファイル:** `exercises/chapter06/ex04.sql`

`employees` テーブルから、**リーダー（role = 'リーダー'）として参加しているプロジェクトがある**社員の
`id` と `name` を取得してください。`id` の昇順で並べてください。

**期待される結果（3行）:**

| id | name |
|----|------|
| 1  | 花子 |
| 3  | 美子 |
| 5  | 由子 |

---

### 問題 6-5: FROM 句サブクエリ

**ファイル:** `exercises/chapter06/ex05.sql`

`employees` テーブルを使い、**部署ごとの平均給与が 60000 以上**の部署について、
`departments.name`（部署名）と平均給与を取得してください。平均給与の降順で並べてください。

> `dept_id` が NULL の行は除外してください。

**期待される結果（2行）:**

| 部署名 | 平均給与 |
|--------|---------|
| 開発   | 71667   |
| 人事   | 61500   |
