# Chapter 09: 応用（CTE・ウィンドウ関数）

## このチャプターで学ぶこと

- `UNION` / `UNION ALL` による結果セットの結合
- CTE（`WITH` 句）による可読性の向上
- 再帰 CTE による階層データの処理
- ウィンドウ関数の基本（`OVER`, `PARTITION BY`, `ORDER BY`）
- `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`
- `SUM() OVER`, `AVG() OVER`
- `LAG()`, `LEAD()`

---

## 使用するテーブル

全テーブル（employees, departments, projects, employee_projects）

---

## 基礎知識

### 1. UNION / UNION ALL

複数の `SELECT` 結果を縦に結合します。

```sql
-- dept_id=1 の社員 と salary >= 60000 の社員 を重複なしでまとめる
(SELECT name, salary FROM employees WHERE dept_id = 1)
UNION
(SELECT name, salary FROM employees WHERE salary >= 60000 AND dept_id IS NOT NULL)
ORDER BY salary DESC;
```

| 演算子       | 説明                              |
|-------------|-----------------------------------|
| `UNION`     | 2つのクエリ結果を結合し重複を除く  |
| `UNION ALL` | 重複を除かずすべての行を返す       |

> **注意:** 両クエリのカラム数・データ型が一致していること。`ORDER BY` は末尾に1つだけ書きます。

### 2. CTE（Common Table Expression）

`WITH` 句で一時的な名前付きクエリを定義します。複雑なクエリを分解して読みやすくできます。

```sql
WITH high_salary AS (
    SELECT id, name, salary
    FROM employees
    WHERE salary > 60000
)
SELECT * FROM high_salary ORDER BY salary DESC;
```

複数の CTE を定義することもできます。

```sql
WITH
dept_avg AS (
    SELECT dept_id, AVG(salary) AS avg_sal FROM employees GROUP BY dept_id
),
total_avg AS (
    SELECT AVG(salary) AS avg_sal FROM employees
)
SELECT ...
FROM dept_avg, total_avg;
```

### 3. 再帰 CTE

`WITH RECURSIVE` を使うと、階層構造（組織ツリーなど）を処理できます。
アンカー部分と再帰部分を `UNION ALL` でつなぎます。

```sql
WITH RECURSIVE org AS (
    -- アンカー: 最上位（上司がいない社員）
    SELECT id, name, manager_id, 1 AS level
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    -- 再帰: 部下を追加
    SELECT e.id, e.name, e.manager_id, org.level + 1
    FROM employees e
    INNER JOIN org ON e.manager_id = org.id
)
SELECT * FROM org ORDER BY level, id;
```

### 4. ウィンドウ関数

`OVER()` 句を使い、グループ化せずに行ごとに集計・順位付けができます。
`GROUP BY` と違い、元の行がそのまま残ります。

```sql
SELECT name, dept_id, salary,
       ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS 順位
FROM employees;
```

### 5. 順位付け関数

| 関数           | 同順位の扱い                        |
|----------------|-------------------------------------|
| `ROW_NUMBER()` | 同順位でも連番（1, 2, 3, ...）      |
| `RANK()`       | 同順位は同じ番号、次は飛ぶ（1,1,3） |
| `DENSE_RANK()` | 同順位は同じ番号、次は続く（1,1,2） |

### 6. 集計ウィンドウ関数

`SUM()`, `AVG()` なども `OVER()` と組み合わせられます。

```sql
-- 部署ごとの給与合計を各行に付加する
SELECT name, dept_id, salary,
       SUM(salary) OVER (PARTITION BY dept_id) AS 部署給与合計
FROM employees;
```

### 7. LAG / LEAD

前の行・次の行の値を参照します。

```sql
-- 前の行の salary を取得
SELECT name, salary,
       LAG(salary)  OVER (ORDER BY hire_date) AS 前の社員の給与,
       LEAD(salary) OVER (ORDER BY hire_date) AS 次の社員の給与
FROM employees;
```

---

## 演習

---

### 問題 9-1: UNION / UNION ALL

**ファイル:** `exercises/chapter09/ex01.sql`

以下の2つのクエリを `UNION` で結合し、`name`、`salary` を取得してください。

1. `dept_id = 1` の社員
2. `salary >= 60000` かつ `dept_id IS NOT NULL` の社員

`salary` の降順で並べてください。

**期待される結果（4行）:**

| name | salary |
|------|--------|
| 健太 | 80000  |
| 花子 | 75000  |
| 由子 | 65000  |
| 一郎 | 60000  |

> `UNION` を `UNION ALL` に変えると 7 行になります（花子・一郎・健太が両クエリに含まれるため）。確認してみましょう。

---

### 問題 9-2: CTE

**ファイル:** `exercises/chapter09/ex02.sql`

CTE を使い、**部署ごとの平均給与と全体平均給与の差額**を求めてください。
`部署名`、`部署平均`、`全体平均`、`差額` を取得し、`部署平均` の降順で並べてください。
（平均給与は `ROUND()` で小数点以下を四捨五入してください。`dept_id` が NULL の行は除外。）

> 全体平均は 58800 円です。

**期待される結果（4行）:**

| 部署名         | 部署平均 | 全体平均 | 差額   |
|---------------|---------|---------|--------|
| 開発           | 71667   | 58800   | 12867  |
| 人事           | 61500   | 58800   | 2700   |
| マーケティング  | 52500   | 58800   | -6300  |
| 営業           | 50000   | 58800   | -8800  |

---

### 問題 9-3: 再帰 CTE

**ファイル:** `exercises/chapter09/ex03.sql`

再帰 CTE を使い、`employees` テーブルの**組織階層**を表示してください。
`id`、`name`、`level`（階層の深さ：最上位=1）を取得し、`level` の昇順、同じ `level` なら `id` の昇順で並べてください。

**期待される結果（10行）:**

| id | name  | level |
|----|-------|-------|
| 1  | 花子  | 1     |
| 3  | 美子  | 1     |
| 5  | 由子  | 1     |
| 7  | あかね | 1    |
| 8  | 昭二  | 1     |
| 2  | 一郎  | 2     |
| 4  | 悠介  | 2     |
| 6  | 健太  | 2     |
| 9  | 京子  | 2     |
| 10 | 翔太  | 2     |

---

### 問題 9-4: ROW_NUMBER()

**ファイル:** `exercises/chapter09/ex04.sql`

`employees` テーブルを使い、**部署内での給与ランキング**（高い順）を
`ROW_NUMBER()` で求めてください。`dept_id` が NULL の行は除外し、
`dept_id` の昇順、同じ部署なら `部署内順位` の昇順で並べてください。

**期待される結果（9行）:**

| name  | dept_id | salary | 部署内順位 |
|-------|---------|--------|----------|
| 健太  | 1       | 80000  | 1        |
| 花子  | 1       | 75000  | 2        |
| 一郎  | 1       | 60000  | 3        |
| 美子  | 2       | 55000  | 1        |
| 悠介  | 2       | 50000  | 2        |
| 由子  | 3       | 65000  | 1        |
| 京子  | 3       | 58000  | 2        |
| 翔太  | 4       | 52000  | 1        |
| あかね | 4      | 48000  | 2        |

---

### 問題 9-5: SUM() OVER

**ファイル:** `exercises/chapter09/ex05.sql`

`employees` テーブルを使い、各社員の給与が**部署給与合計に占める割合**（%）を求めてください。
`name`、`dept_id`、`salary`、`部署給与合計`、`割合`（小数点第1位まで）を取得してください。
`dept_id` が NULL の行は除外し、`dept_id` の昇順、同じ部署なら `salary` の降順で並べてください。

**期待される結果（9行）:**

| name  | dept_id | salary | 部署給与合計 | 割合 |
|-------|---------|--------|------------|------|
| 健太  | 1       | 80000  | 215000     | 37.2 |
| 花子  | 1       | 75000  | 215000     | 34.9 |
| 一郎  | 1       | 60000  | 215000     | 27.9 |
| 美子  | 2       | 55000  | 105000     | 52.4 |
| 悠介  | 2       | 50000  | 105000     | 47.6 |
| 由子  | 3       | 65000  | 123000     | 52.8 |
| 京子  | 3       | 58000  | 123000     | 47.2 |
| 翔太  | 4       | 52000  | 100000     | 52.0 |
| あかね | 4      | 48000  | 100000     | 48.0 |

> **ヒント:** `ROUND(salary * 100.0 / SUM(salary) OVER (PARTITION BY dept_id), 1)`

---

### 問題 9-6: LAG()

**ファイル:** `exercises/chapter09/ex06.sql`

`employees` テーブルを**入社日（`hire_date`）の昇順**に並べ、
`LAG()` を使って「1つ前に入社した社員との給与差」を求めてください。
`name`、`hire_date`、`salary`、`前の社員の給与`、`給与差` を取得してください。

**期待される結果（10行）:**

| name  | hire_date  | salary | 前の社員の給与 | 給与差  |
|-------|------------|--------|------------|---------|
| 健太  | 2017-05-20 | 80000  | NULL       | NULL    |
| 由子  | 2018-09-01 | 65000  | 80000      | -15000  |
| 美子  | 2019-03-01 | 55000  | 65000      | -10000  |
| 花子  | 2020-04-01 | 75000  | 55000      | 20000   |
| 翔太  | 2020-08-15 | 52000  | 75000      | -23000  |
| 一郎  | 2021-06-15 | 60000  | 52000      | 8000    |
| 京子  | 2021-11-30 | 58000  | 60000      | -2000   |
| 悠介  | 2022-01-10 | 50000  | 58000      | -8000   |
| あかね | 2023-02-14 | 48000  | 50000      | -2000   |
| 昭二  | 2023-07-01 | 45000  | 48000      | -3000   |
