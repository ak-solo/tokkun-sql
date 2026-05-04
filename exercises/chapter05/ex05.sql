-- 問題 5-5: JOIN + WHERE
-- 3テーブルを結合し、現在も進行中のプロジェクト（end_date が NULL）に
-- 参加している社員の「社員名」と「役割」を取得してください。
-- 役割の昇順、同じ役割なら社員名の昇順で並べてください。

-- ここに SQL を書いてください
SELECT
    e.name AS 社員名,
    ep.role
FROM
    employees e
    INNER JOIN employee_projects ep ON e.id = ep.employee_id
    INNER JOIN projects p ON ep.project_id = p.id
WHERE
    p.end_date IS NULL
ORDER BY
    ep.role ASC,
    e.name ASC;