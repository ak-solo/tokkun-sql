-- 問題 4-5: HAVING
-- dept_id ごとに集計し、社員数が 2 人以上の部署の dept_id と社員数を取得してください。
-- dept_id の昇順で並べてください。

-- ここに SQL を書いてください
SELECT
    dept_id,
    COUNT(*) AS 社員数
FROM
    employees
GROUP BY
    dept_id
HAVING
    COUNT(*) >= 2
ORDER BY
    dept_id ASC;