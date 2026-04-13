# Chapter 07: DML（データ操作）

## このチャプターで学ぶこと

- `INSERT` によるデータの追加
- `UPDATE` によるデータの更新
- `DELETE` によるデータの削除
- `RETURNING` 句による実行結果の取得
- トランザクション（`BEGIN` / `ROLLBACK` / `COMMIT`）

---

## 使用するテーブル

`employees`、`employee_projects`

---

## 基礎知識

### 1. INSERT

```sql
INSERT INTO employees (name, dept_id, salary, hire_date)
VALUES ('Ken', 2, 53000, '2024-04-01');
```

`id` は `SERIAL` なので省略します。`manager_id` を省略すると NULL が入ります。

複数行をまとめて挿入することもできます。

```sql
INSERT INTO employees (name, dept_id, salary, hire_date) VALUES
    ('Ken',  2, 53000, '2024-04-01'),
    ('Luna', 3, 62000, '2024-07-01');
```

### 2. UPDATE

```sql
UPDATE employees
SET salary = 78000
WHERE id = 2;
```

> **注意:** `WHERE` を省略すると全行が更新されます。

複数カラムを同時に更新できます。

```sql
UPDATE employees
SET salary = salary * 1.05,
    dept_id = 1
WHERE id = 4;
```

### 3. DELETE

```sql
DELETE FROM employees WHERE id = 8;
```

> **注意:** `WHERE` を省略すると全行が削除されます。

### 4. RETURNING

`INSERT` / `UPDATE` / `DELETE` の後に `RETURNING` を付けると、
変更された行のデータを返せます。

```sql
INSERT INTO employees (name, dept_id, salary, hire_date)
VALUES ('Ken', 2, 53000, '2024-04-01')
RETURNING id, name;
```

### 5. トランザクション

`BEGIN` で開始し、`COMMIT` で確定、`ROLLBACK` で取り消します。
練習中にデータを元に戻したいときは `ROLLBACK` を使います。

```sql
BEGIN;

UPDATE employees SET salary = 99999 WHERE id = 1;
SELECT id, name, salary FROM employees WHERE id = 1;  -- 確認

ROLLBACK;  -- 元に戻す（練習後はROLLBACKしておくと安心）
```

---

## 演習

> **ヒント:** 各問題は `BEGIN;` で始め、確認後に `ROLLBACK;` または `COMMIT;` で終わらせることを推奨します。

---

### 問題 7-1: INSERT

**ファイル:** `exercises/chapter07/ex01.sql`

`employees` テーブルに以下の社員を追加してください。
追加後、`SELECT` で確認する SQL も書いてください。

| カラム    | 値           |
|----------|-------------|
| name     | 'Ken'        |
| dept_id  | 2            |
| salary   | 53000        |
| hire_date | '2024-04-01' |

**確認クエリの期待される結果:**

| id | name | dept_id | salary | hire_date  | manager_id |
|----|------|---------|--------|------------|------------|
| 11 | Ken  | 2       | 53000  | 2024-04-01 | NULL       |

> `id` は自動採番なので 11 になります（他の INSERT を実行済みの場合は異なる可能性があります）。

---

### 問題 7-2: INSERT ... RETURNING

**ファイル:** `exercises/chapter07/ex02.sql`

`employees` テーブルに以下の社員を追加し、`RETURNING` で `id`、`name`、`salary` を取得してください。

| カラム    | 値           |
|----------|-------------|
| name     | 'Luna'       |
| dept_id  | 3            |
| salary   | 62000        |
| hire_date | '2024-07-01' |

**期待される結果（RETURNING の出力）:**

| id | name | salary |
|----|------|--------|
| 11 | Luna | 62000  |

---

### 問題 7-3: UPDATE

**ファイル:** `exercises/chapter07/ex03.sql`

`employees` テーブルで、`id = 2`（Bob）の `salary` を **78000** に更新してください。
更新後に `SELECT` で確認する SQL も書いてください。

**確認クエリの期待される結果:**

| id | name | salary |
|----|------|--------|
| 2  | Bob  | 78000  |

---

### 問題 7-4: 条件付き UPDATE

**ファイル:** `exercises/chapter07/ex04.sql`

`employees` テーブルで、**`dept_id = 4`（Sales 部署）の社員全員**の給与を **5% 増やして** ください。
更新後に `SELECT` で確認する SQL も書いてください。

**確認クエリの期待される結果:**

| id | name  | salary |
|----|-------|--------|
| 7  | Grace | 50400  |
| 10 | Jack  | 54600  |

> 48000 × 1.05 = 50400、52000 × 1.05 = 54600

---

### 問題 7-5: DELETE

**ファイル:** `exercises/chapter07/ex05.sql`

`employees` テーブルから、`id = 8`（Henry）を削除してください。
削除後に全社員数が 9 になることを `COUNT(*)` で確認する SQL も書いてください。

**確認クエリの期待される結果:**

| 社員数 |
|--------|
| 9      |

---

### 問題 7-6: DELETE ... RETURNING

**ファイル:** `exercises/chapter07/ex06.sql`

`employee_projects` テーブルから、`employee_id = 10`（Jack）のレコードを削除し、
`RETURNING *` で削除した行を確認してください。

**期待される結果（RETURNING の出力）:**

| employee_id | project_id | role   |
|-------------|------------|--------|
| 10          | 4          | Member |
