-- tokkun-sql: テストデータ

INSERT INTO departments (id, name, location) VALUES
    (1, 'Engineering', 'Tokyo'),
    (2, 'Marketing',   'Osaka'),
    (3, 'HR',          'Tokyo'),
    (4, 'Sales',       'Nagoya'),
    (5, 'Finance',     'Tokyo');

INSERT INTO employees (id, name, dept_id, salary, hire_date, manager_id) VALUES
    ( 1, 'Alice', 1, 75000, '2020-04-01', NULL),
    ( 2, 'Bob',   1, 60000, '2021-06-15',    1),
    ( 3, 'Carol', 2, 55000, '2019-03-01', NULL),
    ( 4, 'Dave',  2, 50000, '2022-01-10',    3),
    ( 5, 'Eve',   3, 65000, '2018-09-01', NULL),
    ( 6, 'Frank', 1, 80000, '2017-05-20',    1),
    ( 7, 'Grace', 4, 48000, '2023-02-14', NULL),
    ( 8, 'Henry', NULL, 45000, '2023-07-01', NULL),
    ( 9, 'Iris',  3, 58000, '2021-11-30',    5),
    (10, 'Jack',  4, 52000, '2020-08-15',    7);

INSERT INTO projects (id, name, start_date, end_date, budget) VALUES
    (1, 'Alpha', '2023-01-01', '2023-12-31', 5000000),
    (2, 'Beta',  '2023-06-01', '2024-05-31', 3000000),
    (3, 'Gamma', '2024-01-01', NULL,         8000000),
    (4, 'Delta', '2022-01-01', '2022-12-31', 2000000);

INSERT INTO employee_projects (employee_id, project_id, role) VALUES
    (1, 1, 'Lead'),
    (2, 1, 'Member'),
    (6, 1, 'Member'),
    (3, 2, 'Lead'),
    (4, 2, 'Member'),
    (1, 3, 'Lead'),
    (6, 3, 'Member'),
    (2, 3, 'Member'),
    (9, 3, 'Member'),
    (5, 4, 'Lead'),
    (7, 4, 'Member'),
    (10, 4, 'Member');

-- SERIAL のシーケンスを挿入済みの最大値に合わせる
SELECT setval('departments_id_seq', (SELECT MAX(id) FROM departments));
SELECT setval('employees_id_seq',   (SELECT MAX(id) FROM employees));
SELECT setval('projects_id_seq',    (SELECT MAX(id) FROM projects));
