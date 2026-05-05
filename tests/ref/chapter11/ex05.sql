SELECT e.name, d.name AS 部署名, e.salary,
       RANK() OVER (PARTITION BY e.dept_id ORDER BY e.salary DESC) AS 部署内順位,
       ROUND(AVG(e.salary) OVER (PARTITION BY e.dept_id)) AS 部署平均,
       e.salary - ROUND(AVG(e.salary) OVER (PARTITION BY e.dept_id)) AS 差額
FROM employees e
INNER JOIN departments d ON e.dept_id = d.id
ORDER BY e.dept_id, 部署内順位;
