-- 問題 1-5: 計算式の使用
-- employees テーブルから name、salary、そして salary を 10% 増やした値を取得してください。
-- 10% 増の給与カラムは「昇給後の給与」という別名で表示してください。

-- ここに SQL を書いてください
SELECT
    name,
    salary,
    salary * 1.1 AS 昇給後の給与
FROM
    employees;