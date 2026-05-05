-- 問題 6-1: スカラーサブクエリ
-- 全社員の平均給与より高い給与を持つ社員の id、name、salary を取得してください。
-- salary の降順で並べてください。

-- ここに SQL を書いてください
SELECT
    id,
    name,
    salary
FROM
    employees
WHERE
    salary >= (
        SELECT
            AVG(salary)
        FROM
            employees
    )
ORDER BY
    salary DESC;