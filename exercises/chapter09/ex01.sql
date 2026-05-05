-- 問題 9-1: UNION / UNION ALL
-- 以下の2つのクエリを UNION で結合し、name、salary を取得してください。
--   1. dept_id = 1 の社員
--   2. salary >= 60000 かつ dept_id IS NOT NULL の社員
-- salary の降順で並べてください。

-- ここに SQL を書いてください
(
    SELECT
        name,
        salary
    FROM
        employees
    WHERE
        dept_id = 1
)
UNION
(
    SELECT
        name,
        salary
    FROM
        employees
    WHERE
        salary >= 60000
        AND dept_id IS NOT NULL
)
ORDER BY
    salary DESC;