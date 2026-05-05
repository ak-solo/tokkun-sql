-- 問題 8-1: CREATE TABLE（基本）
-- 以下の定義で products テーブルを作成してください。
--   id    SERIAL       PRIMARY KEY
--   name  VARCHAR(100) NOT NULL
--   price INTEGER

-- CREATE TABLE 文をここに書いてください
CREATE TABLE
    products (
        id SERIAL PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        price INTEGER
    );

-- 確認: \d products