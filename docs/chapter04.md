# Chapter 04: 集計

## このチャプターで学ぶこと

- 集計関数（`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`）
- `GROUP BY` によるグループ集計
- `HAVING` によるグループ条件の絞り込み
- `WHERE` と `HAVING` の使い分け

---

## 使用するテーブル

`employees` テーブル（Chapter 01 と同じデータ）

---

## 基礎知識

> **例で使うテーブルについて:** 以下の例では架空の `books`（書籍）テーブルを使います。演習問題で使う `employees` テーブルとは異なりますが、SQL の書き方は同じです。

### 1. 集計関数

| 関数          | 意味                         |
|---------------|------------------------------|
| `COUNT(*)`    | 行数（NULL を含む）           |
| `COUNT(col)`  | NULL でない値の件数           |
| `SUM(col)`    | 合計                         |
| `AVG(col)`    | 平均（NULL を除いて計算）     |
| `MIN(col)`    | 最小値                       |
| `MAX(col)`    | 最大値                       |

```sql
SELECT COUNT(*), SUM(price), ROUND(AVG(price)) FROM books;
```

| count | sum   | round |
|-------|-------|-------|
| 8     | 18800 | 2686  |

### 2. GROUP BY

指定したカラムの値ごとにグループ化して集計します。

```sql
-- ジャンルごとの冊数
SELECT genre_id, COUNT(*) AS 冊数
FROM books
GROUP BY genre_id;
```

| genre_id | 冊数 |
|----------|------|
| 1        | 3    |
| 2        | 2    |
| 3        | 2    |
| NULL     | 1    |

> `GROUP BY` を使うと、`SELECT` に書けるのは **グループ化したカラム** か **集計関数** だけです。

### 3. HAVING

`GROUP BY` 後のグループに条件を付けるときに使います。

```sql
-- 冊数が 2 冊以上のジャンルだけを表示
SELECT genre_id, COUNT(*) AS 冊数
FROM books
GROUP BY genre_id
HAVING COUNT(*) >= 2;
```

| genre_id | 冊数 |
|----------|------|
| 1        | 3    |
| 2        | 2    |
| 3        | 2    |

### 4. WHERE と HAVING の違い

| 句       | タイミング              | 対象          |
|----------|------------------------|---------------|
| `WHERE`  | GROUP BY の**前**に適用 | 個々の行      |
| `HAVING` | GROUP BY の**後**に適用 | グループ単位  |

```sql
-- WHERE で先に NULL を除外し、その後グループ化
SELECT genre_id, COUNT(*) AS 冊数, SUM(price) AS 合計金額
FROM books
WHERE genre_id IS NOT NULL
GROUP BY genre_id
HAVING COUNT(*) >= 2
ORDER BY genre_id;
```

| genre_id | 冊数 | 合計金額 |
|----------|------|---------|
| 1        | 3    | 9800    |
| 2        | 2    | 4700    |
| 3        | 2    | 4700    |

---

## 演習

---

### 問題 4-1: 全体の件数

**ファイル:** `exercises/chapter04/ex01.sql`

`employees` テーブルの**全社員数**を取得してください。カラム名は `社員数` としてください。

**期待される結果（1行）:**

| 社員数 |
|--------|
| 10     |

---

### 問題 4-2: GROUP BY による集計

**ファイル:** `exercises/chapter04/ex02.sql`

`employees` テーブルを **`dept_id` ごと** に集計し、各部署の社員数を取得してください。
`dept_id` の昇順（NULL は末尾）で並べてください。

**期待される結果（5行）:**

| dept_id | 社員数 |
|---------|--------|
| 1       | 3      |
| 2       | 2      |
| 3       | 2      |
| 4       | 2      |
| NULL    | 1      |

---

### 問題 4-3: 平均の集計

**ファイル:** `exercises/chapter04/ex03.sql`

`employees` テーブルを **`dept_id` ごと** に集計し、各部署の **平均給与**（小数点以下を四捨五入）を取得してください。
`dept_id` の昇順（NULL は末尾）で並べてください。

**期待される結果（5行）:**

| dept_id | 平均給与 |
|---------|---------|
| 1       | 71667   |
| 2       | 52500   |
| 3       | 61500   |
| 4       | 50000   |
| NULL    | 45000   |

> **ヒント:** `ROUND(AVG(salary))` で四捨五入できます。

---

### 問題 4-4: 最大・最小・平均

**ファイル:** `exercises/chapter04/ex04.sql`

`employees` テーブル全体の **最高給与**・**最低給与**・**平均給与**（小数点以下を四捨五入）を
1行で取得してください。

**期待される結果（1行）:**

| 最高給与 | 最低給与 | 平均給与 |
|---------|---------|---------|
| 80000   | 45000   | 58800   |

---

### 問題 4-5: HAVING

**ファイル:** `exercises/chapter04/ex05.sql`

`employees` テーブルを `dept_id` ごとに集計し、**社員数が 2 人以上**の部署のみ
`dept_id` と社員数を取得してください。`dept_id` の昇順で並べてください。

**期待される結果（4行）:**

| dept_id | 社員数 |
|---------|--------|
| 1       | 3      |
| 2       | 2      |
| 3       | 2      |
| 4       | 2      |

---

### 問題 4-6: WHERE + GROUP BY + SUM

**ファイル:** `exercises/chapter04/ex06.sql`

`employees` テーブルから **`dept_id` が NULL でない社員** だけを対象に、
`dept_id` ごとの **給与合計** を取得してください。`dept_id` の昇順で並べてください。

**期待される結果（4行）:**

| dept_id | 給与合計 |
|---------|---------|
| 1       | 215000  |
| 2       | 105000  |
| 3       | 123000  |
| 4       | 100000  |
