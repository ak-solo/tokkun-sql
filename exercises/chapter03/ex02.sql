-- 問題 3-2: 昇順ソート（日付）
-- name と hire_date を取得し、入社日が古い順（昇順）に並べてください。

-- ここに SQL を書いてください
SELECT
    name,
    hire_date
FROM
    employees
ORDER BY
    hire_date ASC;