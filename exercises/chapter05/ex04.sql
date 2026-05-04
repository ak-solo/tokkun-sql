-- 問題 5-4: 自己結合
-- employees テーブルを自己結合し、上司がいる社員の「社員名」と「上司名」を取得してください。
-- 社員名の昇順で並べてください。

-- ここに SQL を書いてください
SELECT
    e1.name AS 社員名,
    e2.name AS 上司名
FROM
    employees e1
    INNER JOIN employees e2 ON e1.manager_id = e2.id
ORDER BY
    e1.name ASC;