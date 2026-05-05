-- 問題 7-4: 条件付き UPDATE
-- dept_id = 4（営業部署）の社員全員の給与を 5% 増やしてください。
-- 更新後、SELECT で確認してください。

BEGIN;

-- ステップ 1: UPDATE 文をここに書いてください


-- ステップ 2: 確認クエリ（変更不要）
SELECT id, name, salary FROM employees WHERE dept_id = 4 ORDER BY id;

ROLLBACK;
