-- Roles on this server, with what each may do.
SELECT rolname AS role,
       rolcanlogin AS login,
       rolsuper AS superuser,
       rolcreatedb AS createdb,
       rolcreaterole AS createrole
FROM pg_roles
WHERE rolname NOT LIKE 'pg\_%'
ORDER BY rolname;
