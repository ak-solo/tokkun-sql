-- 問題 6-4: EXISTS
-- リーダー（role = 'リーダー'）として参加しているプロジェクトがある社員の
-- id と name を取得してください。id の昇順で並べてください。

-- ここに SQL を書いてください
SELECT
    id,
    name
FROM
    employees e
WHERE
    EXISTS (
        SELECT
            *
        FROM
            employee_projects ep
        WHERE
            ep.employee_id = e.id
            AND ep.role = 'リーダー'
    )