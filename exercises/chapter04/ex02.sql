-- 問題 4-2: GROUP BY による集計
-- dept_id ごとに集計し、各部署の社員数を取得してください。
-- dept_id の昇順（NULL は末尾）で並べてください。
-- カラム名は「dept_id」と「社員数」としてください。

-- ここに SQL を書いてください
SELECT
    dept_id,
    COUNT(*) AS 社員数
FROM
    employees
GROUP BY
    dept_id
ORDER BY
    dept_id ASC;