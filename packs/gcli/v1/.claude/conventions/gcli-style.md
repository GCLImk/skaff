# GCLI Conventions

All agents read this file before writing or reviewing gcli-style project code, prompts, or extension files.

## Project Layout

- `cli/` - CLI entrypoints, tool implementations, dispatcher, skills loader, and shared Python logic.
- `extension/` - Chrome MV3 extension files. Edit JavaScript, JSON, and CSS directly. No build output directory.
- `host/` - native messaging host bridge between Chrome and the local CLI transport.
- `adk/` - Google ADK package exposing the same tool surface.
- `personas/` - Gemini Gem persona overlays layered on top of `gem-instructions.md`.
- `skills/` - markdown skill overlays activated with `/skill <name>`.
- `smoke/` - smoke and end-to-end verification, including DOM-drift checks such as `smoke/smoke.py`.

## Python Toolchain

- Python 3.9+.
- No packaging tool is assumed by default. Direct `python` invocation is the baseline.
- `from __future__ import annotations` is mandatory at the top of every Python module.
- Four-space indentation.
- Type hints on all public functions.

## Naming Conventions

- Python modules, functions, methods, variables, and packages: `snake_case`
- Python classes, exceptions, and type aliases: `PascalCase`
- Module-level constants: `SCREAMING_SNAKE_CASE`
- Tool function names should match the names registered in the dispatch table.
- Chrome extension JavaScript follows MV3-friendly `camelCase` naming for functions and variables.

## Error Handling

- Tool functions return `"Error: ..."` strings on failure and never raise.
- Use `try/except` at the dispatch boundary only.
- Never swallow exceptions silently. Convert them to explicit error strings or re-raise at the boundary.

## Path Safety

- All file paths in tool implementations go through `_resolve_safe(cwd, path)`.
- `_resolve_safe` lives in `cli/tools.py` and is the path-traversal guard.
- Never bypass `_resolve_safe` for reads, writes, deletes, or directory walks exposed to the model.

## Imports / Module Hygiene

- `from __future__ import annotations` sits at the top of every module.
- Import order: standard library, third-party, first-party.
- No circular imports between CLI modules.
- Prefer small, explicit modules over wide utility dumping grounds.

## Chrome Extension (MV3)

- No build step. Edit the JavaScript directly and reload the unpacked extension in Chrome.
- Typical pattern: `background.js` service worker plus content scripts declared in `manifest.json`.
- Keepalive alarms are allowed when needed to reduce MV3 service-worker sleep.
- Every permission, host permission, content script, and background entrypoint must be declared in `manifest.json`.

## Native Messaging Host

- Windows transport uses TCP loopback on `127.0.0.1:53127`.
- POSIX transport uses an AF_UNIX socket at `~/.geminicode/sock`.
- The host bridges Chrome Native Messaging stdio to the local socket or loopback transport.

## Gemini Personas

- Personas live at `personas/<name>.md`.
- A persona should include posture, output discipline, and forbidden-patterns sections.
- `/gem-sync` combines `gem-instructions.md` with the selected persona file.

## Gemini Skills

- Skills live at `skills/<name>.md`.
- Optional YAML frontmatter may define `name` and `description`.
- Skills load via `/skill <name>`.
- Search order is project scope first, then user scope.

## Async / Long Content

- For files over 800 chars, use chunked `write_file` with `append=true`.
- Verify and repair after each chunk when necessary.
- `content_b64` corruption on long payloads is a real failure mode past roughly 1 KB.

## Lint and Format

- `ruff check` and `ruff format`.
- Zero errors is the floor.
- McCabe complexity is gated through `ruff` rule `C901`.

## Test Framework

- `pytest` for unit tests.
- The dispatcher smoke import check is mandatory after any import or module-structure change:
  `python -c "import sys; sys.path.insert(0,'cli'); from tools import dispatch; print('OK')"`
- End-to-end or DOM smoke coverage can live at `smoke/smoke.py`.

## Build / Verification Commands

Canonical commands a contributor runs locally and CI runs in order:

- `python -m py_compile <changed files>`
- `ruff check`
- `ruff format --check`
- `pytest`
- `python -c "import sys; sys.path.insert(0,'cli'); from tools import dispatch; print('OK')"`
- Reload the unpacked Chrome extension and inspect the Chrome extension console when `extension/` changed.

## Secrets Handling

- Never commit `.env` files, API keys, or Chrome extension IDs.
- Keep example values in `*.example` files or sanctioned fixtures only.
- Use `.gitleaks.toml` allowlists for approved test fixtures and examples.
