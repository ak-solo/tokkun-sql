SELECT e.name AS 社員名, m.name AS 上司名
FROM employees e
INNER JOIN employees m ON e.manager_id = m.id
ORDER BY e.name;
