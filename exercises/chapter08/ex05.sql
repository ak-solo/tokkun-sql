-- 問題 8-5: DROP TABLE
-- 8-1、8-2 で作成した products と orders を削除してください。
-- orders は products を参照しているため、削除順に注意してください。

-- DROP TABLE 文をここに書いてください（2つ、IF EXISTS を使うこと）
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;


-- 確認: \dt
