-- 問題 5-1: INNER JOIN
-- employees と departments を結合し、部署に所属している社員の
-- id、name（社員名）、departments.name（部署名）、salary を取得してください。
-- id の昇順で並べてください。

-- ここに SQL を書いてください
SELECT
    e.id,
    e.name AS 社員名,
    d.name AS 部署名,
    e.salary
FROM
    employees e
    INNER JOIN departments d ON e.dept_id = d.id
ORDER BY
    e.id ASC;