# Personal CLAUDE.md

## Development Environment

- **Neovim** is the primary editor, managed by the LazyVim distribution
- **Mason** (Neovim plugin) manages LSPs, linters, and formatters — installed to `~/.local/share/nvim/mason/bin/`. Check there before installing tools via pip/npm/brew.
- **Firefox** is my browser. Automated previews, screenshots and tests use **Chromium** through Playwright (`uv tool install playwright`), plus WebKit for anything I read on the iPad. If I flag a Gecko-specific problem, capture that page with `playwright screenshot -b firefox`.

```
playwright screenshot --full-page file:///abs/page.html page.png
playwright screenshot --full-page --color-scheme dark file:///abs/page.html dark.png
playwright screenshot -b webkit --device "iPad Pro 11" --full-page file:///abs/page.html ipad.png
```

To open a page in my running Firefox: `open -a Firefox <url-or-file>` on the Mac, `firefox <url-or-file>` on Linux.

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

## Time estimates

- **Don't give clock-time estimates unless I ask.** Give size instead: number of steps, files touched, and the main unknown. This overrides the i-have-adhd skill's rule to always give one.
- **When I ask, give two numbers:** your working time, and wall time including stops for me (1Password unlocks, approvals, questions). On multi-hour plans your working-time estimates land close, but wall time runs 1.7–5× longer because of those stops.
- **Base them on measured durations, not guesses.** A turn with 1–3 tool calls takes about 30 s, 4–10 calls 1–4 min, 11–30 calls 5–9 min. Writing runs at about 90 tokens/s, so a large file write costs minutes.
