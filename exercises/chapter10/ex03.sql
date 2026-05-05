-- 問題 10-3: CREATE VIEW（集計）
-- 部署ごとの社員数と平均給与（ROUND で小数点以下四捨五入）を持つビュー dept_stats_view を定義してください。
-- 取得するカラム: 部署名、人数、平均給与
-- dept_id が NULL の社員は除外し、departments テーブルの部署名を使ってください。
-- 定義後、dept_stats_view から全行を平均給与の降順で取得してください。

-- ここに SQL を書いてください
CREATE OR REPLACE VIEW dept_stats_view AS
SELECT
    d.name AS 部署名,
    COUNT(*) AS 人数,
    ROUND(AVG(e.salary)) AS 平均給与
FROM
    employees e
    INNER JOIN departments d ON e.dept_id = d.id
GROUP BY
    d.id,
    d.name;

SELECT
    *
FROM
    dept_stats_view
ORDER BY
    平均給与 DESC;