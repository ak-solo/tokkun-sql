SELECT name, dept_id, salary,
       SUM(salary) OVER (PARTITION BY dept_id) AS 部署給与合計,
       ROUND(salary * 100.0 / SUM(salary) OVER (PARTITION BY dept_id), 1) AS 割合
FROM employees
WHERE dept_id IS NOT NULL
ORDER BY dept_id ASC, salary DESC;
