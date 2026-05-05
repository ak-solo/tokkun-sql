-- 問題 9-2: CTE
-- CTE を使い、部署ごとの平均給与と全体平均給与の差額を求めてください。
-- 部署名、部署平均、全体平均、差額 を取得し、部署平均の降順で並べてください。
-- （平均は ROUND() で四捨五入。dept_id が NULL の行は除外）

-- ここに SQL を書いてください
WITH
    dept_avg AS (
        SELECT
            d.name,
            ROUND(AVG(e.salary)) avg_salary
        FROM
            employees e
            INNER JOIN
                departments d
                ON e.dept_id = d.id
        GROUP BY
            d.name
    ),
    total_avg AS (
        SELECT
            ROUND(AVG(e.salary)) AS avg_salary
        FROM
            employees e
    )
SELECT
    d.name AS 部署名,
    d.avg_salary AS 部署平均,
    t.avg_salary AS 全体平均,
    d.avg_salary - t.avg_salary AS 差額
FROM
    dept_avg d
    CROSS JOIN total_avg t
ORDER BY
    d.avg_salary DESC;