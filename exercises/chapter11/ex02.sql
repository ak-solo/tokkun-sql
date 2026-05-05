-- 問題 11-2: 自部署の平均給与を上回る社員
-- 自分が所属する部署の平均給与（小数点以下四捨五入）よりも給与が高い社員の
-- 「社員名」「部署名」「給与」「部署平均給与」を取得してください。
-- dept_id が NULL の社員は除外します。salary の降順で並べてください。

-- ここに SQL を書いてください
SELECT
    e.name,
    d.name AS 部署名,
    e.salary,
    e.avg_salary AS 部署平均
FROM
    (
        SELECT
            name,
            dept_id,
            salary,
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
    ) e
    INNER JOIN departments d ON e.dept_id = d.id
WHERE
    e.salary > e.avg_salary
ORDER BY
    e.salary DESC;