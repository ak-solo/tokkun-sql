SELECT name, dept_id, salary,
       ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS 部署内順位
FROM employees
WHERE dept_id IS NOT NULL
ORDER BY dept_id ASC, 部署内順位 ASC;
