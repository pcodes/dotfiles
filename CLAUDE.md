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
- Chassis detection logic in `.chezmoiignore` determines laptop vs desktop

### Local Customization Pattern
Several configs use a "local" file pattern for machine-specific settings that shouldn't be committed:
- `dot_zshrc.tmpl` sources `~/.zshrc.local`
- `dot_config/wezterm/create_local.lua` - Wezterm local settings module
- `dot_config/nvim/lua/plugins/create_local.lua` - Neovim local plugins

The `create_` prefix ensures these files are created once but never overwritten.

### External Dependencies
`.chezmoiexternal.toml.tmpl` defines git repos and files fetched automatically:
- Oh My ZSH and plugins (zsh-syntax-highlighting, zsh-autosuggestions, autoupdate)
- Powerlevel10k theme
- Tokyo Night theme files for bat and kitty

### Conditional Ignore
`.chezmoiignore` uses chassis detection to skip configs irrelevant to the current machine type (e.g., i3/hypr/waybar only on Linux laptops).

## Linters/Formatters

- Lua: LuaFormatter
- Bash: Shellcheck + Bashfmt
