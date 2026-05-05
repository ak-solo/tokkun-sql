SELECT m.name AS マネージャー名, d.name AS 部署名,
       COUNT(*) AS 部下人数,
       ROUND(AVG(e.salary)) AS 部下平均給与,
       MAX(e.salary) AS 部下最高給与
FROM employees e
INNER JOIN employees m ON e.manager_id = m.id
INNER JOIN departments d ON m.dept_id = d.id
GROUP BY m.id, m.name, d.name
ORDER BY 部下人数 DESC, マネージャー名;
