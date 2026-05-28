---
name: gcli-implement
description: >
  Write Python agentic CLI code, Chrome MV3 extension JavaScript, or Gemini skill/persona definitions. Activate for CLI features, extension updates, or Gemini skill work.
---

# gcli Implement

Write production gcli Python, extension, and persona or skill changes.

## Read First

Before coding, read:

- `.claude/conventions/gcli-style.md`
- `.claude/conventions/markdown-style.md`
- `.claude/conventions/do-work-protocol.md`

## Directives

- Re-read the full task or REQ from disk before changing files. Read neighboring Python modules, extension files, personas, and skills before creating new ones.
- Match existing CLI dispatcher, extension, host, and Gemini skill patterns. Confirm the target surface before adding files.
- Public Python APIs need type hints and `from __future__ import annotations`. Tool file paths go through `_resolve_safe(cwd, path)`.
- For extension work, keep `manifest.json` aligned with permissions and entrypoints, and note manual reload needs when JavaScript changes.
- In plan-only work, write only the `## Plan` and `## Plan Hash` sections in the active REQ.
- In implement work, leave commits, branch management, and PRs to `git-workflow`.
- No em dashes in code comments, docs, summaries, or commit text. Use " - " instead.
- When working through `do-work`, write an implementation summary to `do-work/summaries/REQ-NNN-implement.md`.

## Verification

- Compile passes: `python -m py_compile` on changed `.py` files
- Lint passes: `ruff check`
- Format passes: `ruff format --check`
- Tests pass: `python -m pytest`
- Dispatcher smoke import passes after Python changes

## Definition of Done

- [ ] Requested code and tests are implemented
- [ ] `python -m py_compile` passes on changed Python files
- [ ] `ruff check` passes
- [ ] `ruff format --check` passes
- [ ] `python -m pytest` passes, or skipping is justified
- [ ] Dispatcher safety and extension manifest rules are satisfied
- [ ] Summary written to `do-work/summaries/` when a REQ is involved
- [ ] Changes left ready for reviewer and `git-workflow`
