(SELECT name, salary FROM employees WHERE dept_id = 1)
UNION
(SELECT name, salary FROM employees WHERE salary >= 60000 AND dept_id IS NOT NULL)
ORDER BY salary DESC;
