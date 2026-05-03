SELECT e.name AS 社員名, ep.role
FROM employees e
INNER JOIN employee_projects ep ON e.id = ep.employee_id
INNER JOIN projects p ON ep.project_id = p.id
WHERE p.end_date IS NULL
ORDER BY ep.role, e.name;
