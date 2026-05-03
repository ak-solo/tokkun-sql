SELECT d.name AS 部署名, sub.平均給与
FROM departments d
INNER JOIN (
    SELECT dept_id, ROUND(AVG(salary)) AS 平均給与
    FROM employees
    WHERE dept_id IS NOT NULL
    GROUP BY dept_id
) sub ON d.id = sub.dept_id
WHERE sub.平均給与 >= 60000
ORDER BY sub.平均給与 DESC;
