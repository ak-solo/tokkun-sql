-- 問題 11-4: マネージャー別の部下給与統計
-- 直属の部下を持つ社員について、
-- 「マネージャー名」「部署名」「部下人数」「部下の平均給与（小数点以下四捨五入）」「部下の最高給与」
-- を取得してください。
-- 部下人数の降順、同数の場合はマネージャー名の昇順で並べてください。

-- ここに SQL を書いてください
SELECT
    m.name AS マネージャー名,
    d.name AS 部署名,
    COUNT(*) AS 部下人数,
    ROUND(AVG(e.salary)) AS 部下平均給与,
    MAX(e.salary) AS 部下最高給与
FROM
    employees m
    INNER JOIN employees e ON m.id = e.manager_id
    LEFT JOIN departments d ON m.dept_id = d.id
GROUP BY
    m.id,
    m.name,
    m.dept_id,
    d.name
ORDER BY
    COUNT(*) DESC,
    m.name ASC;