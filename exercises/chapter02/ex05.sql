-- 問題 2-5: BETWEEN
-- salary が 50000 以上 65000 以下の社員の name と salary を取得してください。

-- ここに SQL を書いてください
SELECT
    name,
    salary
FROM
    employees
WHERE
    salary BETWEEN 50000 AND 65000;