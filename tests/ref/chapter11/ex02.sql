WITH dept_avg AS (
    SELECT dept_id, ROUND(AVG(salary)) AS avg_sal
    FROM employees
    WHERE dept_id IS NOT NULL
    GROUP BY dept_id
)
SELECT e.name, d.name AS 部署名, e.salary, da.avg_sal AS 部署平均
FROM employees e
INNER JOIN departments d ON e.dept_id = d.id
INNER JOIN dept_avg da ON e.dept_id = da.dept_id
WHERE e.salary > da.avg_sal
ORDER BY e.salary DESC;
