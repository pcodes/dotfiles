# Chezmoi Reference

Sourced from <https://www.chezmoi.io/reference/>. Items marked **(verified)** were
confirmed empirically against the installed chezmoi rather than taken from the docs.

## File Naming Conventions

Source directory prefixes map to target attributes:

| Prefix | Effect |
|--------|--------|
| `dot_` | Replaced with `.` |
| `literal_` | Rest of the name is taken literally; no further attributes parsed (verified: `literal_dot_x` -> `dot_x`) |
| `create_` | Only create if target doesn't exist; never overwrite |
| `modify_` | Script that modifies existing target |
| `remove_` | Remove target |
| `run_` | Run as script (not installed) |
| `run_once_` | Run script only once |
| `run_onchange_` | Run script when contents change |
| `before_` | Run script before files/dirs/symlinks are updated |
| `after_` | Run script after files/dirs/symlinks are updated |
| `private_` | Clear group and world permissions |
| `readonly_` | Clear all write permission bits |
| `executable_` | Set executable bits |
| `exact_` | Remove files in target dir not in source |
| `empty_` | Ensure file exists, even if empty |
| `encrypted_` | Encrypted file |
| `symlink_` | File contents are the symlink target |

Suffix `.tmpl` marks Go template files processed with `text/template`.

### Attribute order is strict (verified)

Prefixes must appear in this order:

```
exact_  ->  private_ / readonly_  ->  executable_ / create_ / modify_ /
            remove_ / run_ / symlink_ / empty_ / encrypted_  ->  dot_
```

Out-of-order prefixes are **not** an error. Parsing stops at the first prefix that appears
out of sequence, and everything after it becomes part of the literal filename — so the file
is silently created with a mangled name and the wrong permissions:

| Source name | Target | |
|---|---|---|
| `private_dot_alpha` | `.alpha` | correct |
| `dot_private_beta` | `.private_beta` | `private_` taken literally |
| `exact_readonly_dot_e` | `.e` | correct |
| `readonly_exact_dot_f` | `exact_dot_f` | `exact_` taken literally, `dot_` never applied |

Example of a correct combination: `private_dot_config` -> `.config` with 0o700.

**Exception — `run_` script modifiers are order-independent (verified).** Both
`run_once_before_x.sh` and `run_before_once_x.sh` are valid, as are `run_onchange_after_x.sh`
and `run_after_onchange_x.sh`.

Apply order: "chezmoi deterministically performs actions in ASCII order of their target
name" — this is about *execution* sequencing, and is unrelated to the prefix-parsing order
above.

## Template System

Templates use Go `text/template` syntax with sprig functions.

### Missing keys are a hard error

> "chezmoi executes templates using `text/template`'s `missingkey=error` option, which means
> that misspelled or missing keys will raise an error."

This aborts the whole apply. It bites hardest on optional fields — most commonly
`.chezmoi.osRelease.idLike`, which does not exist on distros that omit `ID_LIKE` (plain Arch,
plain Fedora). `| default ""` does **not** help: the error fires at map access, before
`default` is ever reached.

Use sprig's `dig` for any key that may be absent:

```
{{ $id   := dig "id" "" .chezmoi.osRelease }}
{{ $like := dig "idLike" "" .chezmoi.osRelease }}
{{ if or (eq $id "arch") (contains "arch" $like) }}...{{ end }}
```

`missingkey=zero` can be set in the config file to soften this globally, but per-access
`dig` is safer than changing behaviour repo-wide.

### Template variables

Access via `.chezmoi`:

- `.chezmoi.os` - "darwin", "linux", "windows"
- `.chezmoi.arch` - "amd64", "arm64"
- `.chezmoi.hostname`, `.chezmoi.fqdnHostname`
- `.chezmoi.homeDir`, `.chezmoi.rawHomeDir`, `.chezmoi.destDir`
- `.chezmoi.sourceDir`, `.chezmoi.sourceFile`, `.chezmoi.targetFile`
- `.chezmoi.username`, `.chezmoi.uid`, `.chezmoi.gid`, `.chezmoi.group`
- `.chezmoi.cacheDir`, `.chezmoi.configFile`, `.chezmoi.executable`, `.chezmoi.workingTree`
- `.chezmoi.pathSeparator`, `.chezmoi.pathListSeparator`
- `.chezmoi.version.*` - builtBy, commit, date, version

Platform-specific — **populated only on their own platform** (verified):

- `.chezmoi.osRelease` - fields from `/etc/os-release` (`id`, `idLike`, ...). Linux.
- `.chezmoi.kernel` - from `/proc/sys/kernel`. Linux; useful for detecting WSL.
- `.chezmoi.windowsVersion` - Windows.

Each of these keys **exists on every platform**; off its own platform it holds an
empty map, not nothing. On darwin/v2.72.0 all three render as `{}`, so
`{{ if .chezmoi.osRelease }}` is a valid emptiness test and does not error.

What *does* error anywhere is reaching for a sub-key: `.chezmoi.osRelease.id`
hits `missingkey=error` both on macOS (empty map) and on a distro that omits the
field. Use `dig` for sub-keys regardless of platform — it handles both cases, so
an outer `.chezmoi.os` guard is about intent, not about avoiding a crash.

Go templates evaluate all arguments to `and`/`or`, so guard by nesting rather than relying
on short-circuiting:

```
{{ if eq .chezmoi.os "linux" }}
{{-   if eq (dig "id" "" .chezmoi.osRelease) "arch" }}
# Arch only
{{-   end }}
{{ end }}
```

### Verifying templates

Render before applying, including for platforms you are not on:

```bash
chezmoi execute-template < dot_zshrc.tmpl    # render source file as this machine
chezmoi cat ~/.zshrc                         # render by target path
chezmoi data                                 # dump all template data
sed 's/\.chezmoi\.os/"linux"/g' f.tmpl | chezmoi execute-template   # force another branch
```

## External Sources (.chezmoiexternal.toml)

Define external git repos and files. Name it `.chezmoiexternal.toml` unless it genuinely
contains template syntax, in which case add `.tmpl`.

```toml
[".oh-my-zsh"]
    type = "git-repo"
    url = "https://github.com/ohmyzsh/ohmyzsh.git"
    refreshPeriod = "168h"

[".config/bat/themes/theme.tmTheme"]
    type = "file"
    url = "https://example.com/theme.tmTheme"
    refreshPeriod = "168h"
```

Types: `git-repo`, `archive`, `archive-file`, `file`.
`git-repo` also accepts `clone.args` and `pull.args`.

**Set `refreshPeriod` on every entry.** It defaults to `0`. For `git-repo` entries chezmoi
otherwise runs `git pull` on each one on every `apply`, which makes apply slow and
network-dependent.

The docs state git-repo entries pull on every apply *regardless* of `refreshPeriod`. This is
not true as of v2.72.0 (verified): with `refreshPeriod = "168h"` set, `FETCH_HEAD` was
unchanged across a subsequent apply. Force a refresh with
`chezmoi apply --refresh-externals always` (`-R`); it defaults to `auto`, which honours
`refreshPeriod`.

## Special Files

| File | Purpose |
|---|---|
| `.chezmoiignore` | Targets to skip |
| `.chezmoiremove` | Targets to **delete** from the destination |
| `.chezmoiexternal.<format>` | Externally-fetched files and repos |
| `.chezmoidata.<format>` | Static template data |
| `.chezmoitemplates/` | Shared template partials |
| `.chezmoiroot` | Relocate the source root |
| `.chezmoiversion` | Minimum required chezmoi version |

### .chezmoiignore

Lists targets chezmoi should not manage.

> ".chezmoiignore is interpreted as a template, whether or not it has a .tmpl extension."

- Patterns use `doublestar.Match` and **match the target path, not the source path**
- `!` excludes take priority over all includes
- A `.chezmoiignore` in a source subdirectory applies only to that subdirectory
- `#` starts a comment; mid-line it needs preceding whitespace

**Trap: a commented-out block is silently inert.** Because the file is both a template and
`#`-commented, wrapping template logic in `#` produces output lines that are all comments.
Nothing errors and nothing is ignored. Verify what it actually resolves to:

```bash
chezmoi execute-template < .chezmoiignore
```

**Ignoring is not removing.** Adding a path here stops chezmoi managing it; it does not
delete an already-applied file. Use `.chezmoiremove` or `chezmoi destroy` for that.

### .chezmoiremove

A list of targets to remove from the destination, also always interpreted as a template.
Use it to propagate a deletion to other machines, which will act on it at their next
`apply`. Drop the entry once every machine has caught up.

## Scripts

`run_` scripts are executed, never installed into the target. They still appear in
`chezmoi diff` as though they were new files — that is display only.

`run_onchange_` re-runs when the script's *contents* change. To trigger on some other file's
contents, embed that file's hash in a comment:

```sh
#!/bin/sh
# config hash: {{ include "dot_config/bat/config" | sha256sum }}
bat cache --build
```

Combine with `after_` when the script depends on files or externals already being in place:
`run_onchange_after_build-bat-cache.sh.tmpl`.

## Key Commands

```bash
chezmoi add <file>           # Add file to source state
chezmoi add --template <f>   # Add as template
chezmoi apply                # Apply source state to home
chezmoi apply -n             # Dry-run apply
chezmoi apply -R always      # Apply, forcing external refresh (always|auto|never, default auto)
chezmoi diff                 # Show pending changes
chezmoi edit <file>          # Edit source version of managed file
chezmoi forget <file>        # Stop managing a file (does NOT delete target)
chezmoi destroy <file>       # Remove target AND source entry
chezmoi re-add               # Update source from modified targets
chezmoi managed              # List all managed files
chezmoi unmanaged            # List unmanaged files in home
chezmoi cat <file>           # Show what target would contain after templating
chezmoi execute-template     # Render a template from stdin or an argument
chezmoi data                 # Print template data
chezmoi status               # Show status of all targets
chezmoi verify               # Check if destination matches target state
chezmoi doctor               # Diagnose common problems
chezmoi chattr +template <f> # Convert existing managed file to template
chezmoi source-path <file>   # Print source path for a target file
chezmoi target-path <source> # Print target path for a source file
chezmoi git -- <args>        # Run git in source directory
```
