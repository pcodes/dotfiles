# Personal CLAUDE.md

## Development Environment

- **Neovim** is the primary editor, managed by the LazyVim distribution
- **Mason** (Neovim plugin) manages LSPs, linters, and formatters — installed to `~/.local/share/nvim/mason/bin/`. Check there before installing tools via pip/npm/brew.
- **Firefox** is the default browser. Preview, screenshot, and verify **all** web work in Firefox first. Gecko and Blink differ on exactly the things web work breaks on (flex/grid gaps, SVG text metrics, `color-mix()`, scrollbar layout), so a Chrome-only check proves little about what I'll actually see. Chromium and WebKit are fine for automated work as *second* engines. WebKit is the one that matters for anything I read on the iPad, since every iPad browser runs it.

**Use `ffshot` for headless Firefox captures** (`~/Code/scripts/ffshot`, on PATH). Don't hand-roll `firefox --headless --screenshot` — it has five failure modes that produce a wrong or empty image, and the script already handles all of them. See `~/Code/scripts/README.md` for what they are.

```
ffshot page.html                          # full page, system theme
ffshot -t both -o out/page.png page.html  # light + dark, two files
ffshot --slice 2000 http://localhost:3000 # sliced into readable bands
```

Three things it does that are easy to get wrong by hand: full-page capture needs `--window-size=<width>` with **no** height; forcing `prefers-color-scheme` needs `ui.systemUsesDarkTheme` — *not* `layout.css.prefers-color-scheme.content-override`, which Firefox 153 ignores entirely; and macOS blocks a Firefox launched from a terminal from reading its own data folder, so it exits with "Could not find profile folder." unless `HOME` points at a private directory.

**Use Playwright for the second engines** (`uv tool install playwright`, then `playwright install webkit chromium`). It takes a URL, so a local file needs an absolute `file://` path:

```
playwright screenshot -b webkit --device "iPad Pro 11" --full-page file:///abs/page.html ipad.png
playwright screenshot -b chromium --full-page --color-scheme dark file:///abs/page.html dark.png
```

Playwright's own Firefox build fails on this Mac with "Could not find profile folder", even with a private `HOME`, so Firefox captures stay with `ffshot`.

To open a URL as a tab in my **running** instance instead: `open -a Firefox <url-or-file>`.

## Working in git repos

- Organize work into commits **as you go**, not at the end. When you finish a cohesive unit of work (new subcommand, schema, refactor), commit it before starting the next one.
- If the user hasn't asked for commits yet, still plan the work as a sequence of logical commits and pause at natural boundaries to ask whether to commit.
- Reconstructing commit history after the fact (via `git stash` + rebuilding intermediate file states) wastes significant effort. Avoid it by committing incrementally.

## Comments describe the present, not the past

- **Comments must describe only what the code currently does.** Never leave a comment recording what was deleted, moved, renamed, or changed, and never date-stamp one (`# Moved out of this file (2026-08): ...`, `# Removed the old fallback`, `# was: foo()`).
- **That history goes in the commit message**, where git records it with the author, date, full diff, and rationale attached. A comment about a past change is stale the moment it's written, duplicates what git already has, and misleads whoever reads it next.
- **This does not mean fewer comments.** Explaining *why the current code is shaped the way it is* is valuable and should be kept — "this must run before X, because X invokes path_helper internally" is current-state rationale, not history.
- Same rule for docs and config files, not just source.

## Show me the work, don't describe it

- **Bias hard toward putting the actual artifact in front of me.** If you built or tested something I could look at — a page, a chart, a UI, a rendered document, a diff of real output — open it in Firefox or screenshot it and show it inline. Don't summarize what it looks like and wait for me to ask.
- **Show intermediate results too**, not just the finished thing. A half-built render, the first five rows of a transform, the shape of a response — these are worth more than a paragraph predicting them. Show them as you go rather than batching everything into a final reveal.
- **Look at it yourself before calling it done.** Render it and actually inspect the output. Whole classes of bug — colliding labels, clipped axes, dead whitespace, a chart taller than its container — are invisible in source and obvious in a screenshot.
- **Same discipline for data.** Print a real sample of the rows, the computed figures, the join rate. Evidence, not the assertion that it worked.
- When something can't be shown (a background job, an external service), say what you checked and paste the actual output.

## Bootstrapping a project's Claude settings

- Once a project grows past a couple of files, or has commands that get **re-run** (a test suite, build or pipeline scripts, a dev server, a preview command), create `.claude/settings.json` with a permission allowlist so I'm not re-approving the same commands over and over.
- Do this **proactively** when the project crosses that line — don't wait for me to ask, and don't wait until the prompts get annoying. Mention it, then do it.
- Scope the allowlist to the project's real commands (its runner, its scripts, read-only inspection). Prefer narrow prefixes over blanket wildcards, and keep anything destructive or outward-facing out of it.
- `/fewer-permission-prompts` derives the list from what has actually been run, which beats guessing.
