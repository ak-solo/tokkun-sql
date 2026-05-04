-- 問題 2-6: IS NULL
-- dept_id が未設定（NULL）の社員の全カラムを取得してください。

-- ここに SQL を書いてください
SELECT
    *
FROM
    employees
WHERE
    dept_id IS NULL;