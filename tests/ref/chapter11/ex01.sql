SELECT d.name AS 部署名, e.name, e.salary
FROM employees e
INNER JOIN departments d ON e.dept_id = d.id
WHERE e.salary = (
    SELECT MAX(e2.salary) FROM employees e2 WHERE e2.dept_id = e.dept_id
)
ORDER BY e.salary DESC;
