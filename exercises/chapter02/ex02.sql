-- 問題 2-2: AND
-- dept_id が 1 かつ salary が 70000 以上の社員の name と salary を取得してください。

-- ここに SQL を書いてください
SELECT
    name,
    salary
FROM
    employees
WHERE
    dept_id = 1
    AND salary >= 70000;