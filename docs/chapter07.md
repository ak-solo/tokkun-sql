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
VALUES ('健一', 2, 53000, '2024-04-01');
```

`id` は `SERIAL` なので省略します。`manager_id` を省略すると NULL が入ります。

複数行をまとめて挿入することもできます。

```sql
INSERT INTO employees (name, dept_id, salary, hire_date) VALUES
    ('健一', 2, 53000, '2024-04-01'),
    ('麻衣', 3, 62000, '2024-07-01');
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

#### 別テーブルと結合して更新する（UPDATE ... FROM）

PostgreSQL では `FROM` 句で別テーブルと結合し、その値を条件や更新値に使えます。

```sql
-- 所在地が '東京' の部署に属する社員の給与を 10% 上げる
UPDATE employees
SET salary = salary * 1.1
FROM departments
WHERE employees.dept_id = departments.id
  AND departments.location = '東京';
```

`departments` テーブルを参照することで、`employees` テーブルだけでは持っていない `location` の情報を UPDATE の条件に使えます。上の例では東京にある部署（開発・人事）の社員が対象になります。

サブクエリで書くこともできます。

```sql
-- 同じ結果をサブクエリで表現
UPDATE employees
SET salary = salary * 1.1
WHERE dept_id IN (
    SELECT id FROM departments WHERE location = '東京'
);
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
VALUES ('健一', 2, 53000, '2024-04-01')
RETURNING id, name;
```

### 5. トランザクション

#### トランザクションとは

**トランザクション**は、複数の SQL 操作を「ひとかたまり」として扱う仕組みです。トランザクション内の操作はすべて成功するか、すべて取り消されるか（**原子性**）のどちらかになります。

たとえば「A さんの口座から B さんの口座へ送金する」処理は、「引き落とし」と「入金」の2つの UPDATE で構成されます。引き落としだけ成功して入金が失敗するとデータが壊れるため、2つの操作を必ず一緒に成功させる必要があります。これをトランザクションで保証します。

#### 基本的な使い方

```sql
BEGIN;      -- トランザクション開始

UPDATE employees SET salary = 99999 WHERE id = 1;
SELECT id, name, salary FROM employees WHERE id = 1;  -- 確認（まだ確定していない）

ROLLBACK;  -- すべての変更を取り消す
-- または
COMMIT;    -- すべての変更を確定する
```

`BEGIN` 〜 `COMMIT`/`ROLLBACK` の間は、自分のセッションからは変更済みのデータが見えますが、他のセッションからはまだ見えません。`COMMIT` した瞬間に全操作が確定し、他から参照できるようになります。

#### 自動コミット

`BEGIN` を使わない場合、各 SQL 文は**自動的に1つのトランザクション**として即時コミットされます。

```sql
-- これは即座に確定する（ROLLBACK で取り消せない）
DELETE FROM employees WHERE id = 8;
```

練習中にデータを壊さないために、DML を実行するときは必ず `BEGIN` から始める習慣をつけましょう。

#### 複数テーブルにまたがる操作

トランザクションが特に重要なのは、複数テーブルを操作するときです。

```sql
BEGIN;

-- 社員を追加し
INSERT INTO employees (name, dept_id, salary, hire_date)
VALUES ('健一', 2, 53000, '2024-04-01');

-- プロジェクトにも割り当てる
INSERT INTO employee_projects (employee_id, project_id, role)
VALUES (11, 3, 'メンバー');

COMMIT;  -- 両方まとめて確定
```

どちらかの INSERT が失敗した場合に `ROLLBACK` すれば、社員だけ追加されてプロジェクト未割り当て、という中途半端な状態を防げます。


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
| name     | '健一'        |
| dept_id  | 2            |
| salary   | 53000        |
| hire_date | '2024-04-01' |

**確認クエリの期待される結果:**

| id | name | dept_id | salary | hire_date  | manager_id |
|----|------|---------|--------|------------|------------|
| 11 | 健一 | 2       | 53000  | 2024-04-01 | NULL       |

> `id` は自動採番なので 11 になります（他の INSERT を実行済みの場合は異なる可能性があります）。

---

### 問題 7-2: INSERT ... RETURNING

**ファイル:** `exercises/chapter07/ex02.sql`

`employees` テーブルに以下の社員を追加し、`RETURNING` で `id`、`name`、`salary` を取得してください。

| カラム    | 値           |
|----------|-------------|
| name     | '麻衣'        |
| dept_id  | 3            |
| salary   | 62000        |
| hire_date | '2024-07-01' |

**期待される結果（RETURNING の出力）:**

| id | name | salary |
|----|------|--------|
| 11 | 麻衣 | 62000  |

---

### 問題 7-3: UPDATE

**ファイル:** `exercises/chapter07/ex03.sql`

`employees` テーブルで、`id = 2`（一郎）の `salary` を **78000** に更新してください。
更新後に `SELECT` で確認する SQL も書いてください。

**確認クエリの期待される結果:**

| id | name | salary |
|----|------|--------|
| 2  | 一郎 | 78000  |

---

### 問題 7-4: 条件付き UPDATE

**ファイル:** `exercises/chapter07/ex04.sql`

`employees` テーブルで、**`dept_id = 4`（営業部署）の社員全員**の給与を **5% 増やして** ください。
更新後に `SELECT` で確認する SQL も書いてください。

**確認クエリの期待される結果:**

| id | name  | salary |
|----|-------|--------|
| 7  | あかね | 50400 |
| 10 | 翔太  | 54600  |

> 48000 × 1.05 = 50400、52000 × 1.05 = 54600

---

### 問題 7-5: DELETE

**ファイル:** `exercises/chapter07/ex05.sql`

`employees` テーブルから、`id = 8`（昭二）を削除してください。
削除後に全社員数が 9 になることを `COUNT(*)` で確認する SQL も書いてください。

**確認クエリの期待される結果:**

| 社員数 |
|--------|
| 9      |

---

### 問題 7-6: DELETE ... RETURNING

**ファイル:** `exercises/chapter07/ex06.sql`

`employee_projects` テーブルから、`employee_id = 10`（翔太）のレコードを削除し、
`RETURNING *` で削除した行を確認してください。

**期待される結果（RETURNING の出力）:**

| employee_id | project_id | role    |
|-------------|------------|---------|
| 10          | 4          | メンバー |
