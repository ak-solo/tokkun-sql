-- 問題 3-5: LIMIT + OFFSET
-- salary の高い順に並べ、4番目から6番目の社員の name と salary を取得してください。

-- ここに SQL を書いてください
SELECT
    name,
    salary
FROM
    employees
ORDER BY
    salary DESC
LIMIT
    3
OFFSET
    3;