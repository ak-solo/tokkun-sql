-- 問題 7-5: DELETE
-- id = 8（昭二）を employees テーブルから削除してください。
-- 削除後、COUNT(*) で社員数が 9 になることを確認してください。

BEGIN;

-- ステップ 1: DELETE 文をここに書いてください


-- ステップ 2: 確認クエリ（変更不要）
SELECT COUNT(*) AS 社員数 FROM employees;

ROLLBACK;
