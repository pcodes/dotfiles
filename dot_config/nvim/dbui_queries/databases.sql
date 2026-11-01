-- Every database on this server, largest first.
SELECT d.datname AS database,
       pg_get_userbyid(d.datdba) AS owner,
       pg_size_pretty(pg_database_size(d.datname)) AS size,
       (SELECT count(*) FROM pg_stat_activity a WHERE a.datname = d.datname) AS sessions
FROM pg_database d
WHERE NOT d.datistemplate
ORDER BY pg_database_size(d.datname) DESC;
