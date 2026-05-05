-- 問題 6-2: IN サブクエリ
-- いずれかのプロジェクトに参加している社員の id と name を取得してください。
-- id の昇順で並べてください。

-- ここに SQL を書いてください
SELECT
    id,
    name
FROM
    employees
WHERE
    id IN (
        SELECT
            employee_id
        FROM
            employee_projects
    )
ORDER BY
    id ASC;