SELECT id, name
FROM employees
WHERE id IN (SELECT employee_id FROM employee_projects)
ORDER BY id;
