-- 問題 3-3: 複数カラムでの並び替え
-- name、dept_id、salary を取得し、dept_id の昇順（NULL は末尾）、
-- 同じ dept_id の中では salary の降順で並べてください。

-- ここに SQL を書いてください
SELECT
    name,
    dept_id,
    salary
FROM
    employees
ORDER BY
    dept_id ASC,
    salary DESC;