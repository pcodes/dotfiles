-- Homelab databases for vim-dadbod-ui (LazyVim's lang.sql extra; <leader>D).
-- No passwords here: psql reads them from ~/.pgpass, which is written from
-- the homelab vault (homelab_ansible docs/control-node.md, "Database access").
--
-- Set at load time rather than in an `init`: lazy.nvim keeps only the last
-- `init` of a plugin, and the lang.sql extra configures dadbod-ui in its own.

-- dockerbox publishes immich-db on its loopback only, so resolving this URL
-- forwards a local port to it over SSH, unless a tunnel already listens
-- there. dadbod-ui resolves it when it builds its connection list, that is,
-- when DBUI opens.
local immich_local_port = 15433
local immich_remote = "127.0.0.1:5433"

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
      "dockerbox.home.patcody.io",
    }, { stdout = false, stderr = false }):wait()
    if result.code ~= 0 then
      vim.notify("immich-db: SSH tunnel to dockerbox failed (ssh exit " .. result.code .. ")", vim.log.levels.ERROR)
    end
  end
  return "postgresql://immich@localhost:" .. immich_local_port .. "/immich"
end

vim.g.dbs = {
  { name = "homelab-postgres", url = "postgresql://postgres@dockerbox.home.patcody.io:5432/postgres" },
  { name = "homelab-immich", url = immich_url },
}

return {}
