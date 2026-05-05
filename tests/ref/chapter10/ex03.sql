SELECT d.name AS 部署名, COUNT(*) AS 人数, ROUND(AVG(e.salary)) AS 平均給与
FROM employees e
INNER JOIN departments d ON e.dept_id = d.id
GROUP BY d.id, d.name
ORDER BY 平均給与 DESC;
