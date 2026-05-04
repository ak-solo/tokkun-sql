-- 問題 1-3: エイリアスの使用
-- employees テーブルから name と salary を取得してください。
-- ただし、カラム名はそれぞれ「氏名」「給与」という別名で表示してください。

-- ここに SQL を書いてください
SELECT
    name AS 氏名,
    salary AS 給与
FROM
    employees;