-- 問題 9-3: 再帰 CTE
-- 再帰 CTE を使い、組織階層を表示してください。
-- id、name、level（最上位=1）を取得し、level の昇順、同じ level なら id の昇順で並べてください。

-- ここに SQL を書いてください
WITH RECURSIVE
    org AS (
        SELECT
            e.id,
            e.name,
            1 AS level
        FROM
            employees e
        WHERE
            e.manager_id IS NULL
        UNION ALL
        SELECT
            e.id,
            e.name,
            o.level + 1 AS level
        FROM
            employees e
            INNER JOIN org o ON e.manager_id = o.id
    )
SELECT
    id,
    name,
    level
FROM
    org
ORDER BY
    level ASC,
    id ASC;