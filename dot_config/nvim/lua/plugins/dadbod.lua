-- Homelab databases for vim-dadbod-ui (LazyVim's lang.sql extra; <leader>D).
-- No passwords here: psql reads them from ~/.pgpass, which is written from
-- the homelab vault (homelab_ansible docs/control-node.md, "Database access").
--
-- A dadbod connection opens one database, so the shared Postgres gets one
-- connection per database, `homelab-<db>`. Its database list is read from
-- the server when DBUI first loads, so it is current as of that load.

local postgres_host = "dockerbox.home.patcody.io"

-- dockerbox publishes immich-db on its loopback only, so resolving this URL
-- forwards a local port to it over SSH, unless a tunnel already listens
-- there. dadbod-ui resolves it when it builds its connection list, that is,
-- when DBUI opens.
local immich_local_port = 15433
local immich_remote = "127.0.0.1:5433"

-- Every connection lists these under "Saved queries", as symlinks in its
-- save directory, so editing a file here changes it for all of them.
local shared_queries_dir = vim.fn.stdpath("config") .. "/dbui_queries"

local function immich_url()
  local listening = vim.system({ "nc", "-z", "127.0.0.1", tostring(immich_local_port) }):wait().code == 0
  if not listening then
    -- No pipes: `ssh -f` keeps running in the background after it exits, and
    -- a captured stdout or stderr would hold wait() open until the tunnel dies.
    local result = vim.system({
      "ssh",
      "-fN",
      "-o",
      "ExitOnForwardFailure=yes",
      "-o",
      "ServerAliveInterval=30",
      "-L",
      immich_local_port .. ":" .. immich_remote,
      postgres_host,
    }, { stdout = false, stderr = false }):wait()
    if result.code ~= 0 then
      vim.notify("immich-db: SSH tunnel to dockerbox failed (ssh exit " .. result.code .. ")", vim.log.levels.ERROR)
    end
  end
  return "postgresql://immich@localhost:" .. immich_local_port .. "/immich"
end

local function shared_postgres_databases()
  local result = vim.system({
    "psql",
    "-X",
    "-At",
    "-h",
    postgres_host,
    "-U",
    "postgres",
    "-d",
    "postgres",
    "-c",
    "SELECT datname FROM pg_database WHERE NOT datistemplate AND datallowconn ORDER BY datname",
  }, { text = true, env = { PGCONNECT_TIMEOUT = "3" } }):wait()
  if result.code ~= 0 then
    vim.notify(
      "homelab-postgres: couldn't list databases, so only the postgres one is shown\n" .. vim.trim(result.stderr),
      vim.log.levels.WARN
    )
    return { "postgres" }
  end
  return vim.split(vim.trim(result.stdout), "\n")
end

local function link_shared_queries(connection_names)
  local queries = vim.fn.glob(shared_queries_dir .. "/*.sql", false, true)
  for _, name in ipairs(connection_names) do
    local dir = vim.g.db_ui_save_location .. "/" .. name
    vim.fn.mkdir(dir, "p")
    -- A link whose shared query was deleted would otherwise linger; glob's
    -- fourth argument includes the broken links that dadbod-ui's own glob skips.
    for _, path in ipairs(vim.fn.glob(dir .. "/*", false, true, true)) do
      local target = vim.uv.fs_readlink(path)
      if target and vim.startswith(target, shared_queries_dir .. "/") and not vim.uv.fs_stat(target) then
        os.remove(path)
      end
    end
    for _, query in ipairs(queries) do
      local link = dir .. "/" .. vim.fs.basename(query)
      if not vim.uv.fs_lstat(link) then
        vim.uv.fs_symlink(query, link)
      end
    end
  end
end

return {
  {
    "kristijanhusak/vim-dadbod-ui",
    -- `config`, not `init`: lazy.nvim keeps only the last `init` of a plugin,
    -- and the lang.sql extra sets dadbod-ui's options in its own. `config` runs
    -- once, when DBUI first loads, which is also what keeps the psql call
    -- below off Neovim's startup.
    config = function()
      vim.g.db_ui_table_helpers = {
        postgresql = { Count = 'SELECT count(*) FROM {optional_schema}"{table}"' },
      }

      local dbs = { { name = "homelab-immich", url = immich_url } }
      for _, db in ipairs(shared_postgres_databases()) do
        table.insert(dbs, {
          name = "homelab-" .. db,
          url = "postgresql://postgres@" .. postgres_host .. ":5432/" .. db,
        })
      end
      table.sort(dbs, function(a, b)
        return a.name < b.name
      end)
      vim.g.dbs = dbs

      link_shared_queries(vim.tbl_map(function(db)
        return db.name
      end, dbs))
    end,
  },
}
