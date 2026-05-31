# Chapter 03: ORDER BY / LIMIT

## このチャプターで学ぶこと

- `ORDER BY` による並び替え（昇順・降順）
- 複数カラムでの並び替え
- `LIMIT` による件数の絞り込み
- `OFFSET` によるページネーション

---

## 使用するテーブル

`employees` テーブル（Chapter 01 と同じデータ）

---

## 基礎知識

> **例で使うテーブルについて:** 以下の例では架空の `books`（書籍）テーブルを使います。演習問題で使う `employees` テーブルとは異なりますが、SQL の書き方は同じです。

### 1. ORDER BY

`ORDER BY` で結果を並び替えます。デフォルトは昇順（`ASC`）です。

```sql
SELECT title, price FROM books ORDER BY price;        -- 昇順（安い順）
SELECT title, price FROM books ORDER BY price DESC;   -- 降順（高い順）
SELECT title, price FROM books ORDER BY price ASC;    -- 明示的に昇順
```

昇順（`ORDER BY price`）の場合:

| title          | price |
|----------------|-------|
| 料理の基礎     | 1500  |
| 英語文法       | 1800  |
| イラスト技法   | 2200  |
| …              | …     |

降順（`ORDER BY price DESC`）の場合:

| title          | price |
|----------------|-------|
| データ分析実践 | 3800  |
| Python基礎     | 3200  |
| 写真撮影術     | 2900  |
| …              | …     |

### 2. 複数カラムでの並び替え

カンマ区切りで優先順位を指定します。

```sql
-- genre_id 昇順、同じ genre_id なら price 降順
SELECT title, genre_id, price
FROM books
ORDER BY genre_id ASC, price DESC;
```

| title          | genre_id | price |
|----------------|----------|-------|
| データ分析実践 | 1        | 3800  |
| Python基礎     | 1        | 3200  |
| SQL入門        | 1        | 2800  |
| デザイン入門   | 2        | 2500  |
| …              | …        | …     |

### 3. NULL の扱い

PostgreSQL では、`ORDER BY ... ASC` のとき NULL は末尾に来ます（`NULLS LAST` がデフォルト）。
`ORDER BY ... DESC` のとき NULL は先頭に来ます（`NULLS FIRST` がデフォルト）。

明示的に指定することもできます。

```sql
ORDER BY genre_id ASC NULLS LAST    -- NULL を末尾に（デフォルト）
ORDER BY genre_id ASC NULLS FIRST   -- NULL を先頭に
```

### 4. LIMIT

取得する行数の上限を指定します。

```sql
-- 価格が高い上位3冊だけを取得
SELECT title, price FROM books ORDER BY price DESC LIMIT 3;
```

| title          | price |
|----------------|-------|
| データ分析実践 | 3800  |
| Python基礎     | 3200  |
| 写真撮影術     | 2900  |

### 5. OFFSET

先頭から何行スキップするかを指定します。`LIMIT` と組み合わせてページネーションに使います。

```sql
-- 4番目〜6番目に価格が高い書籍（先頭3件をスキップ）
SELECT title, price FROM books ORDER BY price DESC LIMIT 3 OFFSET 3;
```

| title          | price |
|----------------|-------|
| SQL入門        | 2800  |
| デザイン入門   | 2500  |
| イラスト技法   | 2200  |

---

## 演習

---

### 問題 3-1: 降順ソート

**ファイル:** `exercises/chapter03/ex01.sql`

`employees` テーブルから `id`、`name`、`salary` を取得し、`salary` の **高い順** に並べてください。

**期待される結果（10行）:**

| id | name  | salary |
|----|-------|--------|
| 6  | 健太  | 80000  |
| 1  | 花子  | 75000  |
| 5  | 由子  | 65000  |
| 2  | 一郎  | 60000  |
| 9  | 京子  | 58000  |
| 3  | 美子  | 55000  |
| 10 | 翔太  | 52000  |
| 4  | 悠介  | 50000  |
| 7  | あかね | 48000 |
| 8  | 昭二  | 45000  |

---

### 問題 3-2: 昇順ソート（日付）

**ファイル:** `exercises/chapter03/ex02.sql`

`employees` テーブルから `name` と `hire_date` を取得し、**入社日が古い順**（昇順）に並べてください。

**期待される結果（10行）:**

| name  | hire_date  |
|-------|------------|
| 健太  | 2017-05-20 |
| 由子  | 2018-09-01 |
| 美子  | 2019-03-01 |
| 花子  | 2020-04-01 |
| 翔太  | 2020-08-15 |
| 一郎  | 2021-06-15 |
| 京子  | 2021-11-30 |
| 悠介  | 2022-01-10 |
| あかね | 2023-02-14 |
| 昭二  | 2023-07-01 |

---

### 問題 3-3: 複数カラムでの並び替え

**ファイル:** `exercises/chapter03/ex03.sql`

`employees` テーブルから `name`、`dept_id`、`salary` を取得し、
**`dept_id` の昇順**（NULL は末尾）で並べ、同じ `dept_id` の中では **`salary` の降順** で並べてください。

**期待される結果（10行）:**

| name  | dept_id | salary |
|-------|---------|--------|
| 健太  | 1       | 80000  |
| 花子  | 1       | 75000  |
| 一郎  | 1       | 60000  |
| 美子  | 2       | 55000  |
| 悠介  | 2       | 50000  |
| 由子  | 3       | 65000  |
| 京子  | 3       | 58000  |
| 翔太  | 4       | 52000  |
| あかね | 4      | 48000  |
| 昭二  | NULL    | 45000  |

---

### 問題 3-4: LIMIT

**ファイル:** `exercises/chapter03/ex04.sql`

`employees` テーブルから `name` と `salary` を取得し、**給与が高い上位 3 名** だけを取得してください。

**期待される結果（3行）:**

| name | salary |
|------|--------|
| 健太 | 80000  |
| 花子 | 75000  |
| 由子 | 65000  |

---

### 問題 3-5: LIMIT + OFFSET

**ファイル:** `exercises/chapter03/ex05.sql`

`employees` テーブルを `salary` の高い順に並べ、**4番目から6番目**（給与ランク 4〜6位）の社員の `name` と `salary` を取得してください。

**期待される結果（3行）:**

| name | salary |
|------|--------|
| 一郎 | 60000  |
| 京子 | 58000  |
| 美子 | 55000  |
