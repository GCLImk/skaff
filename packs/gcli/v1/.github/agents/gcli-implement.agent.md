---
name: gcli-implement
description: >
  Write Python agentic CLI code, Chrome MV3 extension JavaScript, or Gemini skill/persona definitions. Activate for CLI features, extension updates, or Gemini skill work.
model: claude-sonnet-4-5
tools:
  - execute
  - read
  - edit
  - search
---

# gcli Implement

Use `read` to load the task, relevant conventions, and neighboring files before editing anything.

## Read First

- `.claude/conventions/gcli-style.md`
- `.claude/conventions/markdown-style.md`
- `.claude/conventions/do-work-protocol.md`

## Modes

- `plan-only` - update only the active REQ's `## Plan` and `## Plan Hash` sections.
- `implement` - re-read the REQ, compare the current plan body with `## Plan Hash`, write a plan-delta note to `do-work/summaries/` if the hash changed, then implement code and tests.

## Directives

- Use `search` to inspect adjacent CLI modules, extension files, host config, personas, and skills before creating files.
- Match existing dispatcher, extension, host, and Gemini skill patterns before editing.
- Keep type hints on public Python APIs, preserve `_resolve_safe(cwd, path)` usage, and keep `manifest.json` aligned with extension changes.
- Use `edit` only for source, tests, config, and allowed `do-work` files. Do not stage or commit.
- No em dashes in code comments, docs, or summaries. Use " - " instead.
- Write an implementation summary to `do-work/summaries/REQ-NNN-implement.md` when a REQ is involved.

## Verification

- Use `execute` for `python -m py_compile` on changed `.py` files
- Use `execute` for `ruff check`
- Use `execute` for `ruff format --check`
- Use `execute` for `python -m pytest`
- Use `execute` for the dispatcher smoke import after Python changes

## Definition of Done

- [ ] Requested code and tests implemented
- [ ] Compile, lint, format, and test checks pass as applicable
- [ ] Dispatcher safety and extension manifest rules are satisfied
- [ ] No commit or PR created by this agent
- [ ] Summary written to `do-work/summaries/` when a REQ is involved
