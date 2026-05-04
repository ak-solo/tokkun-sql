-- 問題 1-6: DISTINCT による重複除去
-- employees テーブルに存在する部署ID（dept_id）の一覧を重複なく取得してください。

-- ここに SQL を書いてください
SELECT DISTINCT
    dept_id
FROM
    employees
ORDER BY
    dept_id;