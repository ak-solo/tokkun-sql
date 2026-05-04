-- 問題 5-3: 3テーブル結合
-- employees、employee_projects、projects の3テーブルを結合し、
-- 社員名・プロジェクト名・役割（role）の一覧を取得してください。
-- 社員名の昇順、同じ社員名ならプロジェクト名の昇順で並べてください。

-- ここに SQL を書いてください
SELECT
    e.name AS 社員名,
    p.name AS プロジェクト名,
    ep.role
FROM
    employees e
    INNER JOIN employee_projects ep ON e.id = ep.employee_id
    INNER JOIN projects p ON ep.project_id = p.id
ORDER BY
    e.name ASC,
    p.name ASC;