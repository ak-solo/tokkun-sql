SELECT dept_id, SUM(salary) AS 給与合計 FROM employees WHERE dept_id IS NOT NULL GROUP BY dept_id ORDER BY dept_id ASC;
