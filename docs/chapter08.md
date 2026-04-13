# Chapter 08: DDL（データ定義）

## このチャプターで学ぶこと

- `CREATE TABLE` によるテーブルの作成
- 制約（`PRIMARY KEY`, `NOT NULL`, `UNIQUE`, `CHECK`, `FOREIGN KEY`, `DEFAULT`）
- `ALTER TABLE` によるテーブルの変更
- `CREATE INDEX` によるインデックスの作成
- `DROP TABLE` によるテーブルの削除

---

## 基礎知識

### 1. CREATE TABLE

```sql
CREATE TABLE products (
    id    SERIAL      PRIMARY KEY,
    name  VARCHAR(100) NOT NULL,
    price INTEGER
);
```

### 2. 主な制約

| 制約           | 説明                                   |
|----------------|----------------------------------------|
| `PRIMARY KEY`  | 主キー（NOT NULL + UNIQUE）             |
| `NOT NULL`     | NULL を禁止                            |
| `UNIQUE`       | 値の重複を禁止                          |
| `CHECK`        | 条件を満たす値のみ許可                  |
| `DEFAULT`      | 省略時のデフォルト値                    |
| `REFERENCES`   | 外部キー（参照整合性）                  |

```sql
CREATE TABLE orders (
    id          SERIAL       PRIMARY KEY,
    customer_id INTEGER      NOT NULL,
    amount      INTEGER      NOT NULL CHECK (amount > 0),
    status      VARCHAR(20)  NOT NULL DEFAULT 'pending',
    created_at  TIMESTAMP    NOT NULL DEFAULT NOW(),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);
```

### 3. ALTER TABLE

既存のテーブルを変更します。

```sql
-- カラムを追加
ALTER TABLE employees ADD COLUMN email VARCHAR(100);

-- カラムの型を変更
ALTER TABLE employees ALTER COLUMN email TYPE TEXT;

-- カラムを削除
ALTER TABLE employees DROP COLUMN email;

-- 制約を追加
ALTER TABLE employees ADD CONSTRAINT chk_salary CHECK (salary > 0);
```

### 4. CREATE INDEX

検索を高速化するためのインデックスを作成します。

```sql
CREATE INDEX idx_employees_dept_id ON employees(dept_id);
CREATE UNIQUE INDEX idx_employees_email ON employees(email);
```

### 5. DROP TABLE

テーブルを削除します。

```sql
DROP TABLE products;
DROP TABLE IF EXISTS products;   -- テーブルが存在する場合のみ削除
```

> **注意:** `DROP TABLE` は取り消せません。練習では `IF EXISTS` をつけておくと安全です。

---

## 演習

> このチャプターの演習はスキーマを変更します。
> 既存テーブルに影響を与えないよう、新しいテーブルを作成・削除する形で進めます。
> `\d テーブル名` コマンドでテーブル定義を確認できます。

---

### 問題 8-1: CREATE TABLE（基本）

**ファイル:** `exercises/chapter08/ex01.sql`

以下の定義で `products` テーブルを作成してください。

| カラム名 | 型           | 制約           |
|---------|--------------|----------------|
| id      | SERIAL       | PRIMARY KEY    |
| name    | VARCHAR(100) | NOT NULL       |
| price   | INTEGER      | —（任意）       |

作成後、`\d products` で確認してください。

---

### 問題 8-2: CREATE TABLE（制約付き）

**ファイル:** `exercises/chapter08/ex02.sql`

以下の定義で `orders` テーブルを作成してください。

| カラム名    | 型          | 制約                        |
|------------|-------------|----------------------------|
| id         | SERIAL      | PRIMARY KEY                 |
| product_id | INTEGER     | NOT NULL、products.id を参照 |
| quantity   | INTEGER     | NOT NULL、1以上であること     |
| status     | VARCHAR(20) | NOT NULL、デフォルト 'pending' |
| created_at | TIMESTAMP   | NOT NULL、デフォルト NOW()    |

作成後、`\d orders` で確認してください。

---

### 問題 8-3: ALTER TABLE

**ファイル:** `exercises/chapter08/ex03.sql`

`employees` テーブルに以下のカラムを追加してください。

| カラム名 | 型           | 制約   |
|---------|--------------|--------|
| email   | VARCHAR(100) | —      |

追加後、`\d employees` でカラムが追加されていることを確認してください。
確認後は `ALTER TABLE employees DROP COLUMN email;` で元に戻してください。

---

### 問題 8-4: CREATE INDEX

**ファイル:** `exercises/chapter08/ex04.sql`

以下の2つのインデックスを作成してください。

1. `employees` テーブルの `dept_id` カラムに `idx_employees_dept_id` という名前のインデックス
2. `employees` テーブルの `salary` カラムに `idx_employees_salary` という名前のインデックス

作成後、`\di` でインデックスの一覧を確認してください。
