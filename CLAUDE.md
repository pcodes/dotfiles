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
- `.chezmoi.osRelease` - Linux distro info (`id`, `idLike`); absent on macOS.
  Read it with `dig "id" "" .chezmoi.osRelease` — chezmoi runs templates with
  `missingkey=error`, so a plain `.chezmoi.osRelease.idLike` fails hard on any
  distro that omits `ID_LIKE`.

### Shell Config Layout
Split by which shells zsh sources each file for:
- `dot_zshenv.tmpl` - every zsh, including non-interactive. `PATH`, `EDITOR`,
  `LANG`, `GOPATH`, Homebrew.
- `dot_zprofile` - login shells. Re-prepends `$my_path` to undo macOS
  `path_helper` reordering. Skipped off macOS via `.chezmoiignore`.
- `dot_zshrc.tmpl` - interactive shells. Oh My Zsh, prompt, aliases, completions.
  Plugin list is gated per platform.

### Local Customization Pattern
Several configs use a "local" file pattern for machine-specific settings that shouldn't be committed:
- `dot_zshrc.tmpl` sources `~/.zshrc.local`
- `dot_config/wezterm/create_local.lua` - Wezterm local settings module
- `dot_config/nvim/lua/plugins/create_local.lua` - Neovim local plugins

The `create_` prefix ensures these files are created once but never overwritten.

### External Dependencies
`.chezmoiexternal.toml` defines git repos and files fetched automatically:
- Oh My ZSH and plugins (zsh-syntax-highlighting, zsh-autosuggestions, autoupdate)
- Powerlevel10k theme
- Tokyo Night theme file for bat

Every entry sets `refreshPeriod`; without it chezmoi re-fetches on every apply.

### Scripts
`run_onchange_after_build-bat-cache.sh.tmpl` runs `bat cache --build`, which is
what makes the externally-fetched theme selectable. It re-runs when the hash of
`dot_config/bat/config` embedded in it changes.

### Conditional Ignore
`.chezmoiignore` excludes repo docs (`README.md`, `CLAUDE.md`) from being applied to `$HOME`.

## Linters/Formatters

- Lua: LuaFormatter
- Bash: Shellcheck + Bashfmt
