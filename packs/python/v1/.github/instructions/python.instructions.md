---
applyTo: "**/*.py,pyproject.toml,setup.cfg,requirements*.txt"
---

# Python Instructions

- Type hints are required on public APIs. Use `from __future__ import annotations` when forward references are needed.
- Use Google-style docstrings for public functions, methods, and classes.
- Prefer absolute imports, Ruff formatting, and `pytest` tests under `tests/`.
- No em dashes in code comments. Use " - " instead.
- Read `.claude/conventions/python-style.md` for the complete style guide.
