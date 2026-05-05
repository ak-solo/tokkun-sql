-- 問題 11-3: プロジェクト未参加の社員
-- employee_projects に一件も記録がない社員の「社員名」「部署名」「給与」を取得してください。
-- 部署が NULL の社員も含めてください。

-- ここに SQL を書いてください
SELECT
    e.name,
    d.name AS 部署名,
    e.salary
FROM
    employees e
    LEFT JOIN departments d ON e.dept_id = d.id
WHERE
    NOT EXISTS (
        SELECT
            1
        FROM
            employee_projects ep
        WHERE
            ep.employee_id = e.id
    );