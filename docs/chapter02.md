# Chapter 02: WHERE

## このチャプターで学ぶこと

- `WHERE` 句による行の絞り込み
- 比較演算子（`=`, `<>`, `<`, `>`, `<=`, `>=`）
- 論理演算子（`AND`, `OR`, `NOT`）
- パターンマッチング（`LIKE`）
- 範囲指定（`BETWEEN`）
- リスト指定（`IN`）
- NULL の判定（`IS NULL`, `IS NOT NULL`）

---

## 使用するテーブル

`employees` テーブル（Chapter 01 と同じデータ）

| id | name  | dept_id | salary | hire_date  | manager_id |
|----|-------|---------|--------|------------|------------|
| 1  | 花子  | 1       | 75000  | 2020-04-01 | NULL       |
| 2  | 一郎  | 1       | 60000  | 2021-06-15 | 1          |
| 3  | 美子  | 2       | 55000  | 2019-03-01 | NULL       |
| 4  | 悠介  | 2       | 50000  | 2022-01-10 | 3          |
| 5  | 由子  | 3       | 65000  | 2018-09-01 | NULL       |
| 6  | 健太  | 1       | 80000  | 2017-05-20 | 1          |
| 7  | あかね | 4      | 48000  | 2023-02-14 | NULL       |
| 8  | 昭二  | NULL    | 45000  | 2023-07-01 | NULL       |
| 9  | 京子  | 3       | 58000  | 2021-11-30 | 5          |
| 10 | 翔太  | 4       | 52000  | 2020-08-15 | 7          |

---

## 基礎知識

### 1. 比較演算子

```sql
SELECT name, salary FROM employees WHERE salary > 60000;
```

| 演算子 | 意味             |
|--------|-----------------|
| `=`    | 等しい           |
| `<>`   | 等しくない（`!=` も使える） |
| `<`    | より小さい        |
| `>`    | より大きい        |
| `<=`   | 以下             |
| `>=`   | 以上             |

### 2. 論理演算子（AND / OR / NOT）

複数の条件を組み合わせます。

```sql
-- dept_id が 1 かつ salary が 70000 以上
SELECT name FROM employees WHERE dept_id = 1 AND salary >= 70000;

-- dept_id が 2 または 4
SELECT name FROM employees WHERE dept_id = 2 OR dept_id = 4;

-- salary が 60000 超でない（= 60000 以下）
SELECT name FROM employees WHERE NOT salary > 60000;
```

### 3. LIKE によるパターンマッチング

`%` は0文字以上の任意の文字列、`_` は1文字を表します。

```sql
SELECT name FROM employees WHERE name LIKE '花%';   -- '花' で始まる → 花子
SELECT name FROM employees WHERE name LIKE '%子';   -- '子' で終わる → 花子, 美子, 由子, 京子
SELECT name FROM employees WHERE name LIKE '%介%';  -- '介' を含む → 悠介
SELECT name FROM employees WHERE name LIKE '_子';   -- ちょうど2文字で '子' で終わる
```

> `LIKE` は大文字小文字を区別します。区別しない場合は `ILIKE` を使います。

### 4. BETWEEN による範囲指定

`BETWEEN a AND b` は `>= a AND <= b` と同じです（両端を含む）。

```sql
SELECT name, salary FROM employees WHERE salary BETWEEN 50000 AND 65000;
```

### 5. IN によるリスト指定

`OR` を複数書く代わりに `IN` でまとめられます。

```sql
-- この2つは同じ結果
SELECT name FROM employees WHERE dept_id = 2 OR dept_id = 4;
SELECT name FROM employees WHERE dept_id IN (2, 4);
```

### 6. IS NULL / IS NOT NULL

#### NULL とは

NULL は「値が存在しない」ことを表す特別な状態です。`0`（ゼロ）や `''`（空文字）とは異なります。

| 値 | 意味 |
|----|------|
| `0` | 数値のゼロ（値は存在する） |
| `''` | 空の文字列（値は存在する） |
| `NULL` | 値が存在しない・不明 |

`employees` テーブルでは、昭二（id=8）の `dept_id` が NULL です。これは「どの部署にも属していない」ことを意味します。

#### NULL の判定

NULL かどうかの判定には `=` が使えません。必ず `IS NULL` / `IS NOT NULL` を使います。

```sql
-- NG: dept_id = NULL は常に偽になる
SELECT name FROM employees WHERE dept_id = NULL;

-- OK
SELECT name FROM employees WHERE dept_id IS NULL;
SELECT name FROM employees WHERE dept_id IS NOT NULL;
```

---

## 演習

---

### 問題 2-1: 比較演算子

**ファイル:** `exercises/chapter02/ex01.sql`

`employees` テーブルから、`salary` が **60000 より高い** 社員の `id`、`name`、`salary` を取得してください。

**期待される結果（3行）:**

| id | name | salary |
|----|------|--------|
| 1  | 花子 | 75000  |
| 5  | 由子 | 65000  |
| 6  | 健太 | 80000  |

> ※ 行の順序は問いません。

---

### 問題 2-2: AND

**ファイル:** `exercises/chapter02/ex02.sql`

`employees` テーブルから、**`dept_id` が 1** かつ **`salary` が 70000 以上** の社員の `name` と `salary` を取得してください。

**期待される結果（2行）:**

| name | salary |
|------|--------|
| 花子 | 75000  |
| 健太 | 80000  |

---

### 問題 2-3: OR と IN

**ファイル:** `exercises/chapter02/ex03.sql`

`employees` テーブルから、**`dept_id` が 2 または 4** の社員の `id`、`name`、`dept_id` を取得してください。

**期待される結果（4行）:**

| id | name  | dept_id |
|----|-------|---------|
| 3  | 美子  | 2       |
| 4  | 悠介  | 2       |
| 7  | あかね | 4      |
| 10 | 翔太  | 4       |

> **ヒント:** `OR` を2つ書く方法と `IN` を使う方法、どちらでも書けます。

---

### 問題 2-4: LIKE

**ファイル:** `exercises/chapter02/ex04.sql`

`employees` テーブルから、`name` に **`'子'` が含まれる** 社員の `id` と `name` を取得してください。

**期待される結果（4行）:**

| id | name |
|----|------|
| 1  | 花子 |
| 3  | 美子 |
| 5  | 由子 |
| 9  | 京子 |

---

### 問題 2-5: BETWEEN

**ファイル:** `exercises/chapter02/ex05.sql`

`employees` テーブルから、`salary` が **50000 以上 65000 以下** の社員の `name` と `salary` を取得してください。

**期待される結果（6行）:**

| name  | salary |
|-------|--------|
| 一郎  | 60000  |
| 美子  | 55000  |
| 悠介  | 50000  |
| 由子  | 65000  |
| 京子  | 58000  |
| 翔太  | 52000  |

---

### 問題 2-6: IS NULL

**ファイル:** `exercises/chapter02/ex06.sql`

`employees` テーブルから、**`dept_id` が未設定（NULL）** の社員の全カラムを取得してください。

**期待される結果（1行）:**

| id | name | dept_id | salary | hire_date  | manager_id |
|----|------|---------|--------|------------|------------|
| 8  | 昭二 | NULL    | 45000  | 2023-07-01 | NULL       |
