-- DB を初期状態にリセットする
-- 使い方: psql "$DATABASE_URL" -f init/reset.sql

TRUNCATE employee_projects, employees, projects, departments RESTART IDENTITY CASCADE;

INSERT INTO departments (id, name, location) VALUES
    (1, '開発',           '東京'),
    (2, 'マーケティング',   '大阪'),
    (3, '人事',           '東京'),
    (4, '営業',           '名古屋'),
    (5, '経理',           '東京');

INSERT INTO employees (id, name, dept_id, salary, hire_date, manager_id) VALUES
    ( 1, '花子',   1, 75000, '2020-04-01', NULL),
    ( 2, '一郎',   1, 60000, '2021-06-15',    1),
    ( 3, '美子',   2, 55000, '2019-03-01', NULL),
    ( 4, '悠介',   2, 50000, '2022-01-10',    3),
    ( 5, '由子',   3, 65000, '2018-09-01', NULL),
    ( 6, '健太',   1, 80000, '2017-05-20',    1),
    ( 7, 'あかね', 4, 48000, '2023-02-14', NULL),
    ( 8, '昭二',   NULL, 45000, '2023-07-01', NULL),
    ( 9, '京子',   3, 58000, '2021-11-30',    5),
    (10, '翔太',   4, 52000, '2020-08-15',    7);

INSERT INTO projects (id, name, start_date, end_date, budget) VALUES
    (1, '基盤整備',   '2023-01-01', '2023-12-31', 5000000),
    (2, '新規開拓',   '2023-06-01', '2024-05-31', 3000000),
    (3, 'データ統合', '2024-01-01', NULL,         8000000),
    (4, '海外展開',   '2022-01-01', '2022-12-31', 2000000);

INSERT INTO employee_projects (employee_id, project_id, role) VALUES
    (1, 1, 'リーダー'),
    (2, 1, 'メンバー'),
    (6, 1, 'メンバー'),
    (3, 2, 'リーダー'),
    (4, 2, 'メンバー'),
    (1, 3, 'リーダー'),
    (6, 3, 'メンバー'),
    (2, 3, 'メンバー'),
    (9, 3, 'メンバー'),
    (5, 4, 'リーダー'),
    (7, 4, 'メンバー'),
    (10, 4, 'メンバー');

-- SERIAL のシーケンスを挿入済みの最大値に合わせる
SELECT setval('departments_id_seq', (SELECT MAX(id) FROM departments));
SELECT setval('employees_id_seq',   (SELECT MAX(id) FROM employees));
SELECT setval('projects_id_seq',    (SELECT MAX(id) FROM projects));
