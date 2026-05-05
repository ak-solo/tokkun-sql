-- 問題 10-1: CREATE VIEW（JOIN）
-- employees と departments を LEFT JOIN したビュー emp_dept_view を定義してください。
-- 取得するカラム: employees.id、employees.name（社員名）、departments.name（部署名）、salary
-- 定義後、emp_dept_view から全行を id の昇順で取得してください。

-- ここに SQL を書いてください
CREATE OR REPLACE VIEW emp_dept_view AS
SELECT
    e.id,
    e.name,
    d.name AS 部署名,
    e.salary
FROM
    employees e
    LEFT JOIN departments d ON e.dept_id = d.id;

SELECT
    *
FROM
    emp_dept_view
ORDER BY
    id ASC;