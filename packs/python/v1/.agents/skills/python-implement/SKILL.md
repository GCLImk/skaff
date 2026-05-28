---
name: python-implement
description: >
  Write Python code and tests using uv, ruff, pytest, and type hints. Activate for any Python feature implementation, bug fix, or refactor.
---

# Python Implement

Write production Python code and tests.

## Read First

Before coding, read:

- `.claude/conventions/python-style.md`
- `.claude/conventions/markdown-style.md`
- `.claude/conventions/do-work-protocol.md`

## Directives

- Re-read the full task or REQ from disk before changing code. Read neighboring files before creating new ones.
- Match existing package layout, module organization, and import style. Confirm the target package or module before adding files.
- Type hints are required on public APIs. Use `from __future__ import annotations` when forward references are needed.
- Use Google-style docstrings on public functions, methods, and classes.
- In plan-only work, write only the `## Plan` and `## Plan Hash` sections in the active REQ.
- In implement work, leave commits, branch management, and PRs to `git-workflow`.
- No em dashes in code comments, docs, summaries, or commit text. Use " - " instead.
- When working through `do-work`, write an implementation summary to `do-work/summaries/REQ-NNN-implement.md`.

## Verification

- Lint passes: `uv run ruff check`
- Format passes: `uv run ruff format --check`
- Type check passes: `uv run mypy`
- Tests pass: `uv run pytest`

## Definition of Done

- [ ] Requested code and tests are implemented
- [ ] `uv run ruff check` passes
- [ ] `uv run ruff format --check` passes
- [ ] `uv run mypy` passes, or skipping is justified
- [ ] `uv run pytest` passes, or skipping is justified
- [ ] Type hint and docstring rules are satisfied
- [ ] Summary written to `do-work/summaries/` when a REQ is involved
- [ ] Changes left ready for reviewer and `git-workflow`
