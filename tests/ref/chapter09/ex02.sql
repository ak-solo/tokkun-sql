WITH RECURSIVE org AS (
    SELECT id, name, manager_id, 1 AS level
    FROM employees
    WHERE manager_id IS NULL
    UNION ALL
    SELECT e.id, e.name, e.manager_id, org.level + 1
    FROM employees e
    INNER JOIN org ON e.manager_id = org.id
)
SELECT id, name, level FROM org ORDER BY level, id;
