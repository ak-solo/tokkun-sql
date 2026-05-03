SELECT e.name AS 社員名, p.name AS プロジェクト名, ep.role
FROM employees e
INNER JOIN employee_projects ep ON e.id = ep.employee_id
INNER JOIN projects p ON ep.project_id = p.id
ORDER BY e.name, p.name;
