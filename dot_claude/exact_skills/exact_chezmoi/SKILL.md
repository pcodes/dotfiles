---
name: chezmoi
description: >
  Manage dotfiles using the chezmoi CLI tool. Use this skill whenever making changes to
  dotfiles, shell configuration, editor config, terminal config, or any user configuration
  files managed by chezmoi. Triggers include: (1) Adding, editing, or removing dotfiles,
  (2) Creating or modifying config files for tools like zsh, nvim, tmux, git, wezterm,
  (3) Managing machine-specific or OS-specific configuration, (4) Working with chezmoi
  templates, externals, or ignore rules, (5) Any task involving ~/.local/share/chezmoi source directory.
---

# Chezmoi Dotfiles Management

## Source directory

All managed dotfiles live in `~/.local/share/chezmoi/`. Edit source files and apply —
with one exception, below.

**Exception — `create_` files.** For a `create_` source file, the target is authoritative:
chezmoi writes it once and never touches it again. Editing the source has no effect on a
machine where the target already exists. To change one, edit the target in `~` directly.
`~/.zshrc.local` works this way.

## Workflow

### Adding a new config file

1. Create the file in the source directory using chezmoi naming conventions (`dot_` prefix
   for dotfiles, `.tmpl` suffix for templates)
2. `chezmoi diff` to preview
3. `chezmoi apply` to deploy

### Modifying an existing managed file

1. `chezmoi source-path <target>` to find the source file (e.g. `chezmoi source-path ~/.zshrc`)
2. Edit the source file
3. `chezmoi diff`, then `chezmoi apply`

### Removing a file from management

Deleting a source file does **not** delete the target. It only stops managing it — the file
stays in `~` as an orphan, and `chezmoi diff` shows nothing. Pick one:

- `chezmoi destroy <target>` — removes both the target and the source entry
- Delete the source file, then remove the target by hand
- Add the path to `.chezmoiremove` — needed when other machines have the file applied and
  must also clean it up on their next `apply`. Remove the entry once every machine has
  caught up.

### Adding OS-specific logic

Use a `.tmpl` suffix and Go template conditionals:
```
{{ if eq .chezmoi.os "darwin" }}
# macOS only
{{ end }}
```

**Always verify a template renders before applying**, including for platforms you are not
on. Templates fail hard — see the `missingkey=error` warning in the reference.

```bash
chezmoi execute-template < dot_zshrc.tmpl        # render as this machine
chezmoi cat ~/.zshrc                             # same, by target path
```

To exercise another platform's branch, substitute the variable and render:
```bash
sed 's/\.chezmoi\.os/"linux"/g' dot_zshrc.tmpl | chezmoi execute-template
```

### Local customization pattern

For machine-specific settings that shouldn't be committed, use `create_` prefix files.
These are created once and never overwritten:
- `create_dot_zshrc.local` — sourced by `.zshrc` for local shell config
- `create_local.lua` — local plugin/settings files for nvim or wezterm

### External dependencies

Define in `.chezmoiexternal.toml` for git repos, archives, or remote files that chezmoi
fetches automatically. **Set `refreshPeriod` on every entry**, including `git-repo` ones —
without it chezmoi re-fetches on every apply.

Only add a `.tmpl` suffix if the file actually contains template syntax.

## Key rules

- Work in the source directory (`~/.local/share/chezmoi/`), not the home directory —
  except for `create_` targets
- `chezmoi diff` before `chezmoi apply`
- Verify templates with `chezmoi execute-template` before applying
- Use `create_` for files that should only be created once (local overrides)
- Add `.tmpl` only when the file contains template syntax; an unused suffix costs parsing
  and breaks on a literal `{{`
- After editing, commit in the source directory

## Reference

For naming conventions and attribute ordering, template syntax and pitfalls, CLI commands,
special files, and `.chezmoiexternal` format, see
[references/chezmoi-guide.md](references/chezmoi-guide.md).
