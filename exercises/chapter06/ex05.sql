-- 問題 6-5: FROM 句サブクエリ
-- 部署ごとの平均給与が 60000 以上の部署について、
-- 部署名（departments.name）と平均給与を取得してください。
-- 平均給与の降順で並べてください。
-- （dept_id が NULL の行は除外してください）

-- ここに SQL を書いてください
SELECT
    d.name AS 部署名,
    e.avg_salary AS 平均給与
FROM
    (
        SELECT
            dept_id,
            ROUND(AVG(salary)) AS avg_salary
        FROM
            employees
        WHERE
            dept_id IS NOT NULL
        GROUP BY
            dept_id
        HAVING
            AVG(salary) >= 60000
    ) e
    INNER JOIN departments d ON e.dept_id = d.id
ORDER BY
    e.avg_salary DESC;