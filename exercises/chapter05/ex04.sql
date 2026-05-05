-- 問題 5-4: 自己結合
-- employees テーブルを自己結合し、上司がいる社員の「社員名」と「上司名」を取得してください。
-- 社員名の昇順で並べてください。

-- ここに SQL を書いてください
SELECT
    e.name AS 社員名,
    m.name AS 上司名
FROM
    employees e
    INNER JOIN employees m ON e.manager_id = m.id
ORDER BY
    e.name ASC;