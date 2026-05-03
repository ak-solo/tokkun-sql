SELECT name, dept_id, salary
FROM employees e
WHERE dept_id IS NOT NULL
  AND salary > (SELECT AVG(salary) FROM employees WHERE dept_id = e.dept_id)
ORDER BY dept_id ASC, salary DESC;
