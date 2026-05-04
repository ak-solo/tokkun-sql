-- 問題 3-4: LIMIT
-- name と salary を取得し、給与が高い上位 3 名だけを取得してください。

-- ここに SQL を書いてください
SELECT
    name,
    salary
FROM
    employees
ORDER BY
    salary DESC
LIMIT
    3;