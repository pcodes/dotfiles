-- Client sessions on this server: active ones first, then idle, each with
-- how long it has been in that state.
SELECT pid,
       datname AS database,
       usename AS role,
       application_name AS app,
       client_addr,
       state,
       date_trunc('second', now() - state_change) AS in_state_for,
       left(query, 80) AS query
FROM pg_stat_activity
WHERE backend_type = 'client backend'
  AND pid <> pg_backend_pid()
ORDER BY state <> 'active', state_change;
