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

### 1. ORDER BY

`ORDER BY` で結果を並び替えます。デフォルトは昇順（`ASC`）です。

```sql
SELECT name, salary FROM employees ORDER BY salary;        -- 昇順（安い順）
SELECT name, salary FROM employees ORDER BY salary DESC;   -- 降順（高い順）
SELECT name, salary FROM employees ORDER BY salary ASC;    -- 明示的に昇順
```

### 2. 複数カラムでの並び替え

カンマ区切りで優先順位を指定します。

```sql
-- dept_id 昇順、同じ dept_id なら salary 降順
SELECT name, dept_id, salary
FROM employees
ORDER BY dept_id ASC, salary DESC;
```

### 3. NULL の扱い

PostgreSQL では、`ORDER BY ... ASC` のとき NULL は末尾に来ます（`NULLS LAST` がデフォルト）。
`ORDER BY ... DESC` のとき NULL は先頭に来ます（`NULLS FIRST` がデフォルト）。

明示的に指定することもできます。

```sql
ORDER BY dept_id ASC NULLS LAST    -- NULL を末尾に（デフォルト）
ORDER BY dept_id ASC NULLS FIRST   -- NULL を先頭に
```

### 4. LIMIT

取得する行数の上限を指定します。

```sql
-- 給与トップ3だけを取得
SELECT name, salary FROM employees ORDER BY salary DESC LIMIT 3;
```

### 5. OFFSET

先頭から何行スキップするかを指定します。`LIMIT` と組み合わせてページネーションに使います。

```sql
-- 4番目〜6番目に給与が高い社員（先頭3件をスキップ）
SELECT name, salary FROM employees ORDER BY salary DESC LIMIT 3 OFFSET 3;
```

---

## 演習

---

### 問題 3-1: 降順ソート

**ファイル:** `exercises/chapter03/ex01.sql`

`employees` テーブルから `id`、`name`、`salary` を取得し、`salary` の **高い順** に並べてください。

**期待される結果（10行）:**

| id | name  | salary |
|----|-------|--------|
| 6  | Frank | 80000  |
| 1  | Alice | 75000  |
| 5  | Eve   | 65000  |
| 2  | Bob   | 60000  |
| 9  | Iris  | 58000  |
| 3  | Carol | 55000  |
| 10 | Jack  | 52000  |
| 4  | Dave  | 50000  |
| 7  | Grace | 48000  |
| 8  | Henry | 45000  |

---

### 問題 3-2: 昇順ソート（日付）

**ファイル:** `exercises/chapter03/ex02.sql`

`employees` テーブルから `name` と `hire_date` を取得し、**入社日が古い順**（昇順）に並べてください。

**期待される結果（10行）:**

| name  | hire_date  |
|-------|------------|
| Frank | 2017-05-20 |
| Eve   | 2018-09-01 |
| Carol | 2019-03-01 |
| Alice | 2020-04-01 |
| Jack  | 2020-08-15 |
| Bob   | 2021-06-15 |
| Iris  | 2021-11-30 |
| Dave  | 2022-01-10 |
| Grace | 2023-02-14 |
| Henry | 2023-07-01 |

---

### 問題 3-3: 複数カラムでの並び替え

**ファイル:** `exercises/chapter03/ex03.sql`

`employees` テーブルから `name`、`dept_id`、`salary` を取得し、
**`dept_id` の昇順**（NULL は末尾）で並べ、同じ `dept_id` の中では **`salary` の降順** で並べてください。

**期待される結果（10行）:**

| name  | dept_id | salary |
|-------|---------|--------|
| Frank | 1       | 80000  |
| Alice | 1       | 75000  |
| Bob   | 1       | 60000  |
| Carol | 2       | 55000  |
| Dave  | 2       | 50000  |
| Eve   | 3       | 65000  |
| Iris  | 3       | 58000  |
| Jack  | 4       | 52000  |
| Grace | 4       | 48000  |
| Henry | NULL    | 45000  |

---

### 問題 3-4: LIMIT

**ファイル:** `exercises/chapter03/ex04.sql`

`employees` テーブルから `name` と `salary` を取得し、**給与が高い上位 3 名** だけを取得してください。

**期待される結果（3行）:**

| name  | salary |
|-------|--------|
| Frank | 80000  |
| Alice | 75000  |
| Eve   | 65000  |

---

### 問題 3-5: LIMIT + OFFSET

**ファイル:** `exercises/chapter03/ex05.sql`

`employees` テーブルを `salary` の高い順に並べ、**4番目から6番目**（給与ランク 4〜6位）の社員の `name` と `salary` を取得してください。

**期待される結果（3行）:**

| name  | salary |
|-------|--------|
| Bob   | 60000  |
| Iris  | 58000  |
| Carol | 55000  |
