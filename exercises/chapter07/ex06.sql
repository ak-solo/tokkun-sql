-- 問題 7-6: DELETE ... RETURNING
-- employee_projects テーブルから employee_id = 10（翔太）のレコードを削除し、
-- RETURNING * で削除した行を確認してください。
BEGIN;

-- DELETE ... RETURNING 文をここに書いてください
DELETE FROM employee_projects
WHERE
    employee_id = 10 RETURNING *;

ROLLBACK;