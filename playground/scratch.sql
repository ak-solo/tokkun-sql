-- playground/scratch.sql
-- 自由にクエリを試すためのファイルです。
-- 実行: psql "$DATABASE_URL" -f playground/scratch.sql

-- テーブル一覧を確認する
\dt

-- データを確認する
SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM projects;
SELECT * FROM employee_projects;

-- ここに自由にクエリを書いてください
