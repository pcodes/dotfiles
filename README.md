# Dotfiles for @pcodes
This is a new repo (migrated from pcodes/config-files) designed for usage with [Chezmoi](https://www.chezmoi.io/).

By using Chezmoi, all "installation"-related tasks are deferred to it, so this repo has no scripts to deal with that. I've also separated out system bootstrap scripts to [pcodes/bootstrap_scripts](https://github.com/pcodes/bootstrap_scripts). Check that out for an example on how I bootstrap new machines.

### ZSH
- `zshrc`: My ZSHRC file. It uses Oh My ZSH as well as a variety of shell plugins for enhanced functionality
- Oh My ZSH Custom Plugins:
  - ZSH Autocomplete
  - ZSH Syntax Highlighting
  - Custom Plugin Autoupdate
  - Powerlevel10k theme

### Tmux
- `tmux.conf`: Standard tmux.conf file. Will automatically download plugin manager on first install
- Tmux plugins: (coming soon)

### Neovim
I use the [LazyVim](https://www.lazyvim.org/) project as my basis for Neovim config, and the remaining files in this repo are my customizations of it.

## Linters + Formatters
- Lua: LuaFormatter
- Bash: Shellcheck + Bashfmt

