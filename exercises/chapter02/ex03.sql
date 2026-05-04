-- 問題 2-3: OR と IN
-- dept_id が 2 または 4 の社員の id、name、dept_id を取得してください。

-- ここに SQL を書いてください
SELECT
    id,
    name,
    dept_id
FROM
    employees
WHERE
    dept_id IN (2, 4);