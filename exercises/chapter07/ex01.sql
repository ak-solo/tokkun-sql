-- 問題 7-1: INSERT
-- employees テーブルに以下の社員を追加してください。
--   name='健一', dept_id=2, salary=53000, hire_date='2024-04-01'
-- 追加後、SELECT で確認してください。

BEGIN;

-- ステップ 1: INSERT 文をここに書いてください


-- ステップ 2: 確認クエリ（変更不要）
SELECT * FROM employees WHERE name = '健一';

ROLLBACK;  -- 練習後は ROLLBACK して元に戻す（本番に使う場合は COMMIT に変更）
