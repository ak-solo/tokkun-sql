SELECT e.name, d.name AS 部署名, e.salary
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.id
WHERE NOT EXISTS (
    SELECT 1 FROM employee_projects ep WHERE ep.employee_id = e.id
)
ORDER BY e.id;
