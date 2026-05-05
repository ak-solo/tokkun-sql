-- 問題 11-1: 各部署の最高給与者
-- 各部署で最も給与が高い社員の「部署名」「社員名」「給与」を取得してください。
-- dept_id が NULL の社員は除外します。同率最高給与の場合は全員含めてください。
-- salary の降順で並べてください。

-- ここに SQL を書いてください
WITH
    ranked AS (
        SELECT
            dept_id,
            name,
            salary,
            RANK() OVER (
                PARTITION BY
                    dept_id
                ORDER BY
                    salary DESC
            ) AS salary_rank
        FROM
            employees
        WHERE
            dept_id IS NOT NULL
    )
SELECT
    d.name AS 部署名,
    r.name,
    r.salary
FROM
    ranked r
    INNER JOIN departments d ON r.dept_id = d.id
WHERE
    r.salary_rank = 1
ORDER BY
    r.salary DESC;