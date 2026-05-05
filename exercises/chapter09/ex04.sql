-- 問題 9-4: ROW_NUMBER()
-- 部署内での給与ランキング（高い順）を ROW_NUMBER() で求めてください。
-- name、dept_id、salary、部署内順位 を取得してください。
-- dept_id が NULL の行は除外し、dept_id の昇順、同じ部署なら部署内順位の昇順で並べてください。

-- ここに SQL を書いてください
SELECT
    name,
    dept_id,
    salary,
    ROW_NUMBER() OVER (
        PARTITION BY
            dept_id
        ORDER BY
            salary DESC
    ) AS 部署内順位
FROM
    employees
WHERE
    dept_id IS NOt NULL
ORDER BY
    dept_id ASC,
    ROW_NUMBER() OVER (
        PARTITION BY
            dept_id
        ORDER BY
            salary DESC
    ) ASC