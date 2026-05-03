SELECT id, name
FROM employees e
WHERE EXISTS (
    SELECT 1 FROM employee_projects ep
    WHERE ep.employee_id = e.id AND ep.role = 'リーダー'
)
ORDER BY id;
