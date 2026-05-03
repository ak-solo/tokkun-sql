SELECT dept_id, COUNT(*) AS 社員数 FROM employees GROUP BY dept_id HAVING COUNT(*) >= 2 ORDER BY dept_id ASC;
