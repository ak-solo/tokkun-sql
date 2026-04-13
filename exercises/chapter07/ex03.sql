-- 問題 7-3: UPDATE
-- id = 2（Bob）の salary を 78000 に更新してください。
-- 更新後、SELECT で確認してください。

BEGIN;

-- ステップ 1: UPDATE 文をここに書いてください


-- ステップ 2: 確認クエリ（変更不要）
SELECT id, name, salary FROM employees WHERE id = 2;

ROLLBACK;
