-- tokkun-sql: テーブル定義
-- 全チャプターで共通して使用するテーブル群

CREATE TABLE departments (
    id       SERIAL PRIMARY KEY,
    name     VARCHAR(50)  NOT NULL,
    location VARCHAR(50)  NOT NULL
);

CREATE TABLE employees (
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(50)  NOT NULL,
    dept_id    INTEGER      REFERENCES departments(id),
    salary     INTEGER      NOT NULL,
    hire_date  DATE         NOT NULL,
    manager_id INTEGER      REFERENCES employees(id)
);

CREATE TABLE projects (
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(50)  NOT NULL,
    start_date DATE         NOT NULL,
    end_date   DATE,                    -- NULL = 進行中
    budget     INTEGER      NOT NULL
);

CREATE TABLE employee_projects (
    employee_id INTEGER     NOT NULL REFERENCES employees(id),
    project_id  INTEGER     NOT NULL REFERENCES projects(id),
    role        VARCHAR(20) NOT NULL,
    PRIMARY KEY (employee_id, project_id)
);
