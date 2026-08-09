# Dotfiles for @pcodes

Managed with [Chezmoi](https://www.chezmoi.io/), which handles all installation
and syncing. Nothing in this repo does that itself.

System bootstrap lives separately, in
[pcodes/bootstrap_scripts](https://github.com/pcodes/bootstrap_scripts) — see
that repo for how a new machine gets set up.

## ZSH

Shell config is split across three files, because zsh reads each one for a
different kind of shell. Putting something in the wrong file is how it ends up
invisible to scripts, or how a prompt tries to render inside a cron job.

| File | Read by | Holds |
| --- | --- | --- |
| `zshenv` | **every** zsh — scripts, `ssh host cmd`, cron, git hooks | `PATH`, `EDITOR`, `LANG`, `GOPATH`, Homebrew |
| `zprofile` | login shells, after `/etc/zprofile` | PATH order repair (macOS only) |
| `zshrc` | interactive shells | Oh My Zsh, prompt, aliases, keybindings, completions |

`zprofile` exists for one reason: macOS's `/etc/zprofile` runs `path_helper`,
which rebuilds `PATH` with the system directories first. That demotes everything
`zshenv` prepended, so a login shell would resolve `~/.bin` scripts and Homebrew
binaries *below* `/usr/bin`. Re-prepending the same array afterwards restores the
intended order. No other platform runs `path_helper`, so chezmoi skips this file
off macOS.

Oh My Zsh plugins are selected per platform in `dot_zshrc.tmpl` — `docker`,
`archlinux` and `dnf` only load on the systems that actually have those tools.

Plugins and the theme are fetched by chezmoi as externals rather than vendored:

- zsh-autosuggestions
- zsh-syntax-highlighting
- autoupdate
- Powerlevel10k

## Terminal

WezTerm, on Tokyo Night Moon. Tmux and `bat` are themed to match.

## Tmux

`tmux.conf` installs TPM on first run and loads plugins from there.

## Neovim

[LazyVim](https://www.lazyvim.org/) as the base; the files here are
customizations on top of it.

## bat

Themed with Tokyo Night Moon, fetched as an external. `bat` only discovers
themes in its config directory after a cache rebuild, so
`run_onchange_after_build-bat-cache.sh` runs `bat cache --build` whenever the
requested theme changes.

## Machine-local overrides

Files prefixed `create_` are written once and never overwritten, so per-machine
settings stay out of git:

- `~/.zshrc.local` — sourced by `zshrc` before Oh My Zsh loads
- `~/.config/wezterm/local.lua` — WezTerm settings module
- `~/.config/nvim/lua/plugins/local.lua` — extra Neovim plugins

## Linters + Formatters

- Lua: LuaFormatter
- Bash: Shellcheck + Bashfmt
