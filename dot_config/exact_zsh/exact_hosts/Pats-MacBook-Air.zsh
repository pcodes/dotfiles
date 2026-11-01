# Settings for this machine only, tracked in git.
#
# The filename must match the host key ~/.zshrc computes: LocalHostName on
# macOS, the short hostname elsewhere. Renaming the machine means renaming this
# file -- nothing warns when a host file stops matching, it just silently stops
# being sourced.
#
# Sourced last of the tracked files, after <os>.zsh, so it wins over that.
# Work-machine settings do not go here; they go in ~/.zshrc.local.post, which is
# never committed.

# Runs a command (default: claude) as the homelab-laptop 1Password service
# account, which can read only the Homelab vault. The token is read from
# Private with one Touch ID prompt and exported to that command alone, so the
# session keeps working when the desktop app locks. env -u keeps an inherited
# token from hiding Private from the op read.
homelab() {
  local token
  token=$(env -u OP_SERVICE_ACCOUNT_TOKEN op read 'op://Private/Homelab Service Account Token/password') || return
  (( $# )) || set -- claude
  OP_SERVICE_ACCOUNT_TOKEN=$token "$@"
}
