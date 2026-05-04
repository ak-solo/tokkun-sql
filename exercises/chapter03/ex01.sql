-- 問題 3-1: 降順ソート
-- id、name、salary を取得し、salary の高い順に並べてください。

-- ここに SQL を書いてください
SELECT
    id,
    name,
    salary
FROM
    employees
ORDER BY
    salary DESC;