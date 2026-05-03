SELECT dept_id, ROUND(AVG(salary)) AS 平均給与 FROM employees GROUP BY dept_id ORDER BY dept_id ASC NULLS LAST;
