-- 問題 9-6: LAG()
-- 入社日（hire_date）の昇順に並べ、LAG() を使って
-- 「1つ前に入社した社員との給与差」を求めてください。
-- name、hire_date、salary、前の社員の給与、給与差 を取得してください。

-- ここに SQL を書いてください
SELECT
    name,
    hire_date,
    salary,
    LAG (salary) OVER (
        ORDER BY
            hire_date ASC
    ) AS 前の社員の給与,
    salary - LAG (salary) OVER (
        ORDER BY
            hire_date ASC
    ) AS 給与差
FROM
    employees
ORDER BY
    hire_date ASC;