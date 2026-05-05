WITH dept_avg AS (
    SELECT dept_id, ROUND(AVG(salary)) AS 部署平均
    FROM employees
    WHERE dept_id IS NOT NULL
    GROUP BY dept_id
),
total_avg AS (
    SELECT ROUND(AVG(salary)) AS 全体平均 FROM employees
)
SELECT d.name AS 部署名, da.部署平均, ta.全体平均, (da.部署平均 - ta.全体平均) AS 差額
FROM dept_avg da
INNER JOIN departments d ON da.dept_id = d.id
CROSS JOIN total_avg ta
ORDER BY da.部署平均 DESC;
