-- 問題 8-4: CREATE INDEX
-- 以下の2つのインデックスを作成してください。
--   1. orders.product_id に「idx_orders_product_id」という名前のインデックス
--   2. orders.status     に「idx_orders_status」という名前のインデックス

-- CREATE INDEX 文をここに書いてください（2つ）
CREATE INDEX idx_orders_product_id ON orders (product_id);

CREATE INDEX idx_orders_status ON orders (status);

-- 確認: \di