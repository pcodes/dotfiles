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

Plugins and the theme are fetched by chezmoi as externals rather than vendored,
each cloned at depth 1:

- zsh-autosuggestions
- zsh-syntax-highlighting
- autoupdate
- Powerlevel10k

`zsh-syntax-highlighting` is sourced from the bottom of `zshrc` rather than
listed in `plugins`, so that it loads after everything else that binds a ZLE
widget. The Powerlevel10k prompt itself is in `dot_p10k.zsh`.

## Terminal

kitty and WezTerm, both on Tokyo Night Moon and set up to look the same. Tmux
and `bat` are themed to match.

kitty's theme is fetched as an external from tokyonight.nvim. Matching WezTerm
takes more than the same font name; `kitty.conf.tmpl` explains each setting.
The row-height tuning was measured on macOS and is skipped on Linux.

kitty's icon is "Outrun (Neue)" from
[k0nserv/kitty-icon](https://github.com/k0nserv/kitty-icon) (CC BY 4.0), fetched
as `~/.config/kitty/kitty.app.png`, which kitty applies at startup on both
macOS and Linux. On macOS the Dock keeps its cached icon until it's cleared:

```sh
rm /var/folders/*/*/*/com.apple.dock.iconcache; killall Dock
```

## Tmux

`tmux.conf` installs TPM on first run and loads plugins from there.

## Neovim

[LazyVim](https://www.lazyvim.org/) as the base; the files here are
customizations on top of it.

## bat

Themed with Tokyo Night Moon, fetched as an external. `bat` only discovers
themes in its config directory after a cache rebuild, so
`.chezmoiscripts/run_onchange_after_build-bat-cache.sh` runs `bat cache --build`
whenever the requested theme changes.

## Claude Code

Tracked: `~/.claude/CLAUDE.md`, the statusline script, and the `chezmoi` skill.
Everything else under `~/.claude` is state the tool owns — transcripts, history,
caches, `plugins/` — and stays out.

`settings.json` is deliberately untracked. Claude Code rewrites it whenever the
model, effort level or plugin set changes, so a managed copy would sit in
permanent conflict; and its `autoMode` block caches per-project infrastructure
detail that has no business in a public repo. Nothing here reinstalls plugins as
a result — the tables below are the runbook.

### Status line

`chezmoi apply` installs the script, but only `settings.json` decides whether
anything runs it, and that file is untracked. On a new machine the status line
stays blank until this key is added by hand:

```json
"statusLine": { "type": "command", "command": "~/.claude/statusline-command.sh" }
```

The script is a template. Its OS glyph branches on `.chezmoi.os` — Apple on
macOS, the Arch logo on Arch and Arch-derived distros, Tux on other Linux — and
comes from the Nerd Font the terminal is set to, so a machine without one shows
a placeholder box.

### Marketplaces

| Name | Repo |
| --- | --- |
| `claude-plugins-official` | [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) |
| `anthropic-agent-skills` | [anthropics/skills](https://github.com/anthropics/skills) |
| `obsidian-skills` | [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills) |
| `i-have-adhd` | [ayghri/i-have-adhd](https://github.com/ayghri/i-have-adhd) |

The first is built in. The rest need `/plugin marketplace add <repo>` before
their plugins resolve.

### Enabled plugins

| Plugin | Marketplace | For |
| --- | --- | --- |
| `superpowers` | `claude-plugins-official` | brainstorming, TDD, systematic debugging |
| `vercel` | `claude-plugins-official` | Next.js, AI SDK, deploys |
| `supabase` | `claude-plugins-official` | Postgres, auth, storage |
| `lua-lsp` | `claude-plugins-official` | Lua language server |
| `pyright-lsp` | `claude-plugins-official` | Python language server |
| `rust-analyzer-lsp` | `claude-plugins-official` | Rust language server |
| `swift-lsp` | `claude-plugins-official` | Swift language server |
| `example-skills` | `anthropic-agent-skills` | design, art, docs, skill authoring |
| `obsidian` | `obsidian-skills` | vaults, Bases, Canvas |
| `i-have-adhd` | `i-have-adhd` | action-first output shaping |

Install each with `/plugin install <plugin>@<marketplace>`.

### ADHD always-on

`dot_claude/empty_dot_i-have-adhd-always` is the opt-in flag for the
`i-have-adhd` plugin. Only its existence is checked, never its contents, which
is why it is tracked with `empty_` — chezmoi drops zero-length files that lack
the attribute.

The plugin reads the flag from a SessionStart hook that runs `node -e ...`, so
the `nodejs` package is a hard requirement. Claude Code here is the Arch
`claude-code` package, a native binary that keeps its runtime to itself and
exposes no `node` of its own. Without one the hook exits 127, and it is written
never to block session start, so it fails without saying so and the flag injects
nothing.

`fnm` does not cover this. Hooks run under a non-interactive `/bin/sh`, which
never sources the `fnm env` line in `.zshrc`, so a per-project Node stays
invisible to them. Hooks want `node` on the system PATH: `pacman -S nodejs`.

The `vercel` plugin needs it for the same reason — its three SessionStart hooks
are Node scripts too, and they fail the same silent way. `superpowers` is
unaffected; it shells through `hooks/run-hook.cmd` instead.

### Skills

`exact_skills` holds only skills written here, so removing one from this repo
removes it from the machine. Project-specific skills live with their project
instead — `ha-dashboards` in [pcodes/ha-cli](https://github.com/pcodes/ha-cli),
the Ansible ones in
[pcodes/homelab_ansible](https://github.com/pcodes/homelab_ansible).

`npx skills` is a separate, cross-agent package manager: it installs into a
shared `~/.agents/skills/` store and symlinks into each agent's skill directory,
so chezmoi leaves it alone. `~/.agents/.skill-lock.json` records what's there.

```
npx skills add vercel-labs/skills@find-skills -g -y
```

## Machine config

Three places for a setting, depending on how far it should travel:

| Where | In git | For |
| --- | --- | --- |
| inline in `dot_zshrc.tmpl` behind an OS guard | yes | per-OS settings |
| `~/.config/zsh/hosts/<host>.zsh` | yes | one machine, worth syncing |
| `~/.zshrc.local` | no | one machine, must stay off GitHub |

`zshrc` is a chezmoi template, so per-OS differences don't need a file of their
own — the plugin list already works this way. The other two load after the
aliases, late enough to override anything `zshrc` defines.

Nothing loads before Oh My Zsh, so `plugins`, `ZSH_THEME` and `zstyle` have to
be set in the template itself.

`<host>` is `LocalHostName` on macOS rather than `hostname`, because `hostname`
follows DHCP and drifts between names on the same machine. It's resolved when
chezmoi applies, so renaming a machine means renaming its `hosts/` file and
re-applying.

Files prefixed `create_` are written once and never overwritten:

- `~/.zshrc.local`
- `~/.config/kitty/local.conf` — kitty settings, included last
- `~/.config/wezterm/local.lua` — WezTerm settings module
- `~/.config/nvim/lua/plugins/local.lua` — extra Neovim plugins

## Linters + Formatters

- Lua: LuaFormatter
- Bash: Shellcheck + Bashfmt
