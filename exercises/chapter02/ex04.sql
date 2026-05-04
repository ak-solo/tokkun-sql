-- 問題 2-4: LIKE
-- name に 'r' が含まれる社員の id と name を取得してください。

-- ここに SQL を書いてください
SELECT
    id,
    name
FROM
    employees
WHERE
    name LIKE '%子%';