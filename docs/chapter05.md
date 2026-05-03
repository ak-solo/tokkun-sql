# Chapter 05: JOIN

## このチャプターで学ぶこと

- `INNER JOIN` による内部結合
- `LEFT JOIN` による外部結合
- 複数テーブルの結合
- 自己結合（self join）

---

## 使用するテーブル

このチャプターでは全テーブルを使います。

**employees**（id, name, dept_id, salary, hire_date, manager_id）
**departments**（id, name, location）
**projects**（id, name, start_date, end_date, budget）
**employee_projects**（employee_id, project_id, role）

テーブル間の関係：

```
employees.dept_id    → departments.id
employees.manager_id → employees.id   （自己参照）
employee_projects.employee_id → employees.id
employee_projects.project_id  → projects.id
```

---

## 基礎知識

### 1. INNER JOIN

両方のテーブルに一致する行だけを結合します。

```sql
SELECT e.name, d.name AS 部署名
FROM employees e
INNER JOIN departments d ON e.dept_id = d.id;
```

> `dept_id` が NULL の社員（昭二）は結果に含まれません。

テーブルに別名（エイリアス）をつけると、カラム名の衝突を避けられます。

### 2. LEFT JOIN

左側のテーブルの全行を取得し、右側に一致する行がなければ NULL で埋めます。

```sql
SELECT e.name, d.name AS 部署名
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.id;
```

> `dept_id` が NULL の昭二も結果に含まれ、`部署名` が NULL になります。

### 3. 複数テーブルの結合

`JOIN` を連続して書くことで、3テーブル以上を結合できます。

```sql
SELECT e.name, p.name AS プロジェクト名, ep.role
FROM employees e
INNER JOIN employee_projects ep ON e.id = ep.employee_id
INNER JOIN projects p           ON ep.project_id = p.id;
```

### 4. 自己結合

同じテーブルを2回使って結合します。上司・部下の関係を取得するときに使います。
テーブルエイリアスで区別します。

```sql
SELECT e.name AS 社員名, m.name AS 上司名
FROM employees e
INNER JOIN employees m ON e.manager_id = m.id;
```

---

## 演習

---

### 問題 5-1: INNER JOIN

**ファイル:** `exercises/chapter05/ex01.sql`

`employees` と `departments` を結合し、**部署に所属している社員**の
`id`、`name`（社員名）、`departments.name`（部署名）、`salary` を取得してください。
`id` の昇順で並べてください。

**期待される結果（9行 — 昭二は部署 NULL のため除外）:**

| id | name  | 部署名         | salary |
|----|-------|---------------|--------|
| 1  | 花子  | 開発           | 75000  |
| 2  | 一郎  | 開発           | 60000  |
| 3  | 美子  | マーケティング  | 55000  |
| 4  | 悠介  | マーケティング  | 50000  |
| 5  | 由子  | 人事           | 65000  |
| 6  | 健太  | 開発           | 80000  |
| 7  | あかね | 営業          | 48000  |
| 9  | 京子  | 人事           | 58000  |
| 10 | 翔太  | 営業           | 52000  |

---

### 問題 5-2: LEFT JOIN

**ファイル:** `exercises/chapter05/ex02.sql`

`employees` と `departments` を **LEFT JOIN** で結合し、**全社員**の
`id`、`name`（社員名）、`departments.name`（部署名）、`salary` を取得してください。
`id` の昇順で並べてください。

**期待される結果（10行 — 昭二の部署名は NULL）:**

| id | name  | 部署名         | salary |
|----|-------|---------------|--------|
| 1  | 花子  | 開発           | 75000  |
| 2  | 一郎  | 開発           | 60000  |
| 3  | 美子  | マーケティング  | 55000  |
| 4  | 悠介  | マーケティング  | 50000  |
| 5  | 由子  | 人事           | 65000  |
| 6  | 健太  | 開発           | 80000  |
| 7  | あかね | 営業          | 48000  |
| 8  | 昭二  | NULL           | 45000  |
| 9  | 京子  | 人事           | 58000  |
| 10 | 翔太  | 営業           | 52000  |

---

### 問題 5-3: 3テーブル結合

**ファイル:** `exercises/chapter05/ex03.sql`

`employees`、`employee_projects`、`projects` の3テーブルを結合し、
**社員名**・**プロジェクト名**・**役割（role）** の一覧を取得してください。
社員名の昇順、同じ社員名ならプロジェクト名の昇順で並べてください。

> ※ PostgreSQL は日本語文字列をUnicodeコードポイント順で並べます。

**期待される結果（12行）:**

| 社員名 | プロジェクト名 | role     |
|--------|--------------|----------|
| あかね | 海外展開      | メンバー  |
| 一郎   | データ統合    | メンバー  |
| 一郎   | 基盤整備      | メンバー  |
| 京子   | データ統合    | メンバー  |
| 健太   | データ統合    | メンバー  |
| 健太   | 基盤整備      | メンバー  |
| 悠介   | 新規開拓      | メンバー  |
| 由子   | 海外展開      | リーダー  |
| 美子   | 新規開拓      | リーダー  |
| 翔太   | 海外展開      | メンバー  |
| 花子   | データ統合    | リーダー  |
| 花子   | 基盤整備      | リーダー  |

---

### 問題 5-4: 自己結合

**ファイル:** `exercises/chapter05/ex04.sql`

`employees` テーブルを自己結合し、**上司がいる社員**の
「社員名」と「上司名」を取得してください。社員名の昇順で並べてください。

**期待される結果（5行）:**

| 社員名 | 上司名 |
|--------|--------|
| 一郎   | 花子   |
| 京子   | 由子   |
| 健太   | 花子   |
| 悠介   | 美子   |
| 翔太   | あかね |

---

### 問題 5-5: JOIN + WHERE

**ファイル:** `exercises/chapter05/ex05.sql`

3テーブルを結合し、**現在も進行中のプロジェクト**（`end_date` が NULL）に
参加している社員の「社員名」と「役割」を取得してください。
役割の昇順、同じ役割なら社員名の昇順で並べてください。

**期待される結果（4行 — プロジェクト「データ統合」が該当）:**

| 社員名 | role    |
|--------|---------|
| 一郎   | メンバー |
| 京子   | メンバー |
| 健太   | メンバー |
| 花子   | リーダー |
