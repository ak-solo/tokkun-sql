-- 問題 10-2: ビューへの SELECT
-- emp_dept_view（問題 10-1 と同じ定義）から、
-- salary が 60000 以上の社員を salary の降順で取得してください。
-- ヒント: まず CREATE OR REPLACE VIEW で emp_dept_view を定義し、その後 SELECT してください。

-- ここに SQL を書いてください
CREATE
OR REPLACE VIEW emp_dept_view AS (
    SELECT
        e.id,
        e.name AS 社員名,
        d.name AS 部署名,
        e.salary
    FROM
        employees e
        LEFT JOIN departments d ON e.dept_id = d.id
);

SELECT
    *
FROM
    emp_dept_view
WHERE
    salary >= 60000
ORDER BY
    salary DESC;