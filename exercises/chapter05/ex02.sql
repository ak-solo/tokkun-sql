-- 問題 5-2: LEFT JOIN
-- employees と departments を LEFT JOIN で結合し、全社員の
-- id、name（社員名）、departments.name（部署名）、salary を取得してください。
-- id の昇順で並べてください。

-- ここに SQL を書いてください
SELECT
    e.id,
    e.name,
    d.name AS 部署名,
    e.salary
FROM
    employees e
    LEFT JOIN departments d ON e.dept_id = d.id
ORDER BY
    e.id ASC;