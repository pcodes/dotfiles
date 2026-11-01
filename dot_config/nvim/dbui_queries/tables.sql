-- Tables in this connection's database, largest first. est_rows is the
-- planner's estimate, blank until the table is first vacuumed or analyzed.
SELECT n.nspname AS schema,
       c.relname AS table,
       NULLIF(c.reltuples, -1)::bigint AS est_rows,
       pg_size_pretty(pg_total_relation_size(c.oid)) AS total_size,
       pg_size_pretty(pg_indexes_size(c.oid)) AS index_size
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE c.relkind IN ('r', 'p')
  AND n.nspname NOT IN ('pg_catalog', 'information_schema')
  AND n.nspname NOT LIKE 'pg\_toast%'
ORDER BY pg_total_relation_size(c.oid) DESC;
