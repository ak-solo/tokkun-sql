-- 問題 6-3: 相関サブクエリ
-- 自分の部署の平均給与より高い給与を持つ社員の name、dept_id、salary を取得してください。
-- dept_id の昇順、同じ部署なら salary の降順で並べてください。
-- （dept_id が NULL の社員は除外されます）

-- ここに SQL を書いてください
SELECT
    name,
    dept_id,
    salary
FROM
    employees e
WHERE
    salary > (
        SELECT
            AVG(salary)
        FROM
            employees e2
        WHERE
            e2.dept_id = e.dept_id
    )
ORDER BY
    dept_id ASC,
    salary DESC;