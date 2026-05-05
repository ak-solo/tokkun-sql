-- 問題 7-2: INSERT ... RETURNING
-- employees テーブルに以下の社員を追加し、RETURNING で id、name、salary を取得してください。
--   name='麻衣', dept_id=3, salary=62000, hire_date='2024-07-01'
BEGIN;

-- INSERT ... RETURNING 文をここに書いてください
INSERT INtO
    employees (name, dept_id, salary, hire_date)
VALUES
    ('麻衣', 3, 62000, '2024-07-01') RETURNING id,
    name,
    salary;

ROLLBACK;