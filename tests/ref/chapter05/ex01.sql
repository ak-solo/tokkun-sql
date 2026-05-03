SELECT e.id, e.name, d.name AS 部署名, e.salary
FROM employees e
INNER JOIN departments d ON e.dept_id = d.id
ORDER BY e.id;
