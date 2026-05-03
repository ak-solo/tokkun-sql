SELECT name, hire_date, salary,
       LAG(salary) OVER (ORDER BY hire_date) AS 前の社員の給与,
       salary - LAG(salary) OVER (ORDER BY hire_date) AS 給与差
FROM employees
ORDER BY hire_date;
