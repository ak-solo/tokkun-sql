-- 問題 4-6: WHERE + GROUP BY + SUM
-- dept_id が NULL でない社員だけを対象に、dept_id ごとの給与合計を取得してください。
-- dept_id の昇順で並べてください。
-- カラム名は「dept_id」と「給与合計」としてください。

-- ここに SQL を書いてください
SELECT
    dept_id,
    SUM(salary) AS 給与合計
FROM
    employees
WHERE
    dept_id IS NOT NULL
GROUP BY
    dept_id
ORDER BY
    dept_id ASC;