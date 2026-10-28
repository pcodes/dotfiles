# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository managed with [Chezmoi](https://www.chezmoi.io/). Chezmoi handles all installation and synchronization of configuration files to their target locations.

## Chezmoi Commands

```bash
chezmoi apply          # Apply changes from source to home directory
chezmoi diff           # Preview what changes would be applied
chezmoi edit <file>    # Edit a managed file (opens in editor)
chezmoi add <file>     # Add a new file to chezmoi management
chezmoi re-add         # Re-add modified files
chezmoi cd             # Change to chezmoi source directory
```

## File Naming Conventions

Chezmoi uses special prefixes in the source directory:
- `dot_` → `.` (e.g., `dot_zshrc` becomes `.zshrc`)
- `create_` → Only create if file doesn't exist (used for local-only config)
- `.tmpl` suffix → Template file processed with Go templates

## Architecture

### Template System
Files ending in `.tmpl` are processed with Go templates. Key template variables:
- `.chezmoi.os` - Operating system (darwin, linux, windows)
- `.chezmoi.osRelease` - Linux distro info (`id`, `idLike`). On macOS the key
  exists but holds an empty map, so it is falsy rather than missing.
  Read it with `dig "id" "" .chezmoi.osRelease` — chezmoi runs templates with
  `missingkey=error`, so a plain `.chezmoi.osRelease.idLike` fails hard on any
  distro that omits `ID_LIKE`. `dig` covers both that and the empty macOS map.

### Shell Config Layout
Split by which shells zsh sources each file for:
- `dot_zshenv.tmpl` - every zsh, including non-interactive. `PATH`, `EDITOR`,
  `LANG`, `GOPATH`, Homebrew.
- `dot_zprofile` - login shells. Re-prepends `$my_path` to undo macOS
  `path_helper` reordering. Skipped off macOS via `.chezmoiignore`.
- `dot_zshrc.tmpl` - interactive shells. Oh My Zsh, prompt, aliases, completions.
  Plugin list is gated per platform.

### Machine Config
Three places for a setting, in the order `.zshrc` reaches them:

| Where | Tracked? | For |
| --- | --- | --- |
| inline in `dot_zshrc.tmpl`, behind `eq .chezmoi.os` | yes | per-OS settings |
| `~/.config/zsh/hosts/<host>.zsh` | yes | one machine, worth syncing |
| `~/.zshrc.local` | no | one machine, must stay off GitHub |

The last two load after the aliases, so both can override what `.zshrc` itself
defines. Nothing loads before Oh My Zsh any more — settings OMZ reads as it
loads (`plugins`, `ZSH_THEME`, `zstyle`) are set in the template, which is the
only thing that runs early enough.

`<host>` is baked in at apply time: `LocalHostName` on macOS, `.chezmoi.hostname`
elsewhere. Not `hostname` — that follows DHCP and drifts between names on one
machine. Renaming a machine means renaming its `hosts/` file and re-applying;
nothing warns when a host file stops matching, it just stops being sourced.

### Local Customization Pattern
`create_` files are created once and never overwritten, so machine-local edits
survive `chezmoi apply`:
- `create_dot_zshrc.local`
- `dot_config/exact_kitty/create_local.conf` - kitty local settings, included last
- `dot_config/exact_wezterm/create_local.lua` - Wezterm local settings module
- `dot_config/nvim/lua/plugins/create_local.lua` - Neovim local plugins

### Exact Directories
`exact_` directories delete anything in the target that isn't in the source, so
removing a file from this repo actually removes it from the machine: `exact_bat`,
`exact_kitty`, `exact_wezterm`, `exact_zsh`, `exact_hosts`, `nvim/lua/exact_config`, and
`claude/exact_skills` down through `exact_chezmoi/exact_references`.

`exact_` applies per directory and does not descend, which is why the skill tree
repeats the prefix at every level.

Verified: `exact_` does **not** touch files supplied by `.chezmoiexternal.toml`
(the bat theme survives), and does **not** touch `create_` files or their local
edits. `nvim/lua/plugins` is deliberately left inexact — plugin files get dropped
in there by hand.

Scoping a diff to a path hides `exact_` deletions: `chezmoi diff ~/.claude`
prints nothing while bare `chezmoi diff` prints the deletion (v2.72.0).
`chezmoi status` reports them as ` D` rows either way, so use status before
applying a change that adds or narrows an `exact_` directory.

### Claude Code config
`dot_claude` tracks three things: `CLAUDE.md`, `executable_statusline-command.sh`,
and `exact_skills/`. It is **not** an `exact_` directory — the rest of `~/.claude`
is transcripts, history, caches and a 99 MB `plugins/` tree that chezmoi must
leave alone.

`settings.json` is untracked on purpose. Claude Code rewrites it, and its
`autoMode` block caches per-project infrastructure detail that this repo is too
public for. The plugin and marketplace set is documented in README.md instead, as
a manual runbook.

Skills here are only the ones that apply everywhere. Project-specific skills
belong in that project's own `.claude/skills/`.

### External Dependencies
`.chezmoiexternal.toml` defines git repos and files fetched automatically:
- Oh My ZSH and plugins (zsh-syntax-highlighting, zsh-autosuggestions, autoupdate)
- Powerlevel10k theme
- Tokyo Night theme files for bat and kitty
- kitty's app icon, `kitty.app.png`

Every entry sets `refreshPeriod`; without it chezmoi re-fetches on every apply.
Every `git-repo` entry clones at depth 1 and pulls `--ff-only`, which keeps it
shallow.

### Scripts
Scripts live in `.chezmoiscripts/`, which runs them without also registering a
target path under `$HOME`.

`run_onchange_after_build-bat-cache.sh.tmpl` runs `bat cache --build`, which is
what makes the externally-fetched theme selectable. It re-runs when the hash of
`dot_config/exact_bat/config` embedded in it changes.

### Conditional Ignore
`.chezmoiignore` excludes repo docs (`README.md`, `CLAUDE.md`) from being applied to `$HOME`.

## Linters/Formatters

- Lua: LuaFormatter
- Bash: Shellcheck + Bashfmt
