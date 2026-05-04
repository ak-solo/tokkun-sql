-- 問題 4-4: 最大・最小・平均
-- 全社員の最高給与・最低給与・平均給与（小数点以下を四捨五入）を 1 行で取得してください。
-- カラム名はそれぞれ「最高給与」「最低給与」「平均給与」としてください。

-- ここに SQL を書いてください
SELECT
    MAX(salary) AS 最高給与,
    MIN(salary) AS 最低給与,
    ROUND(AVG(salary)) AS 平均給与
FROM
    employees;