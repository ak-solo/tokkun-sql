-- 問題 8-2: CREATE TABLE（制約付き）
-- 以下の定義で orders テーブルを作成してください。
--   id         SERIAL       PRIMARY KEY
--   product_id INTEGER      NOT NULL、products.id を参照（外部キー）
--   quantity   INTEGER      NOT NULL、1以上であること（CHECK 制約）
--   status     VARCHAR(20)  NOT NULL、デフォルト 'pending'
--   created_at TIMESTAMP    NOT NULL、デフォルト NOW()
--
-- ※ ex01.sql で products テーブルを作成済みであること

-- CREATE TABLE 文をここに書いてください
CREATE TABLE
    orders (
        id SERIAL PRIMARY KEY,
        product_id INTEGER NOT NULL REFERENCES products (id),
        quantity INTEGER NOT NULL CHECK (quantity >= 1),
        status VARCHAR(20) NOT NULL DEFAULT 'pending',
        created_at TIMESTAMP NOT NULL DEFAULT NOW ()
    );

-- 確認: \d orders