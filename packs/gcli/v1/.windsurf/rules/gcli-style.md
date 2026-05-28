# gcli Style

- Public Python APIs need type hints and Python modules should start with `from __future__ import annotations`.
- Tool implementations route model-exposed file paths through `_resolve_safe(cwd, path)`.
- Chrome extension files are edited directly. Keep `manifest.json` aligned with permissions and entrypoints.
- No em dashes in code comments or docs. Use " - " instead.
- Read `.claude/conventions/gcli-style.md` for the complete style guide.
