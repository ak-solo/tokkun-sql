-- 問題 11-5: 部署内給与ランキングと部署平均との差額
-- 全社員（dept_id が NULL の社員は除外）について、
-- 「社員名」「部署名」「給与」「部署内給与順位（RANK()）」
-- 「部署平均給与（小数点以下四捨五入）」「差額（給与 − 部署平均）」を取得してください。
-- dept_id の昇順、同じ部署なら部署内順位の昇順で並べてください。

-- ここに SQL を書いてください
WITH
    ranked AS (
        SELECT
            name,
            dept_id,
            salary,
            RANK() OVER (
                PARTITION BY
                    dept_id
                ORDER BY
                    salary DESC
            ) AS salary_rank,
            ROUND(
                AVG(salary) OVER (
                    PARTITION BY
                        dept_id
                )
            ) AS avg_salary
        FROM
            employees
        WHERE
            dept_id IS NOT NULL
    )
SELECT
    r.name,
    d.name AS 部署名,
    r.salary,
    r.salary_rank AS 部署内順位,
    r.avg_salary AS 部署平均,
    r.salary - r.avg_salary AS 差額
FROM
    ranked r
    INNER JOIN departments d ON r.dept_id = d.id
ORDER BY
    r.dept_id ASC,
    r.salary_rank ASC;