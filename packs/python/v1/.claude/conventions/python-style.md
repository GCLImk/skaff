# Python Conventions

All agents read this file before writing or reviewing Python code.

## Project Layout

- src layout preferred: `src/<package>/` with `tests/` as a sibling, `pyproject.toml` at the repo root.
- Flat layout (`<package>/` at the root) is acceptable for small projects but src is the default.
- One distribution package per repo unless there is a stated reason otherwise.

## Packaging Tool

- Default: `uv` with `pyproject.toml`.
- Acceptable alternatives: `pip` + `pyproject.toml`, `poetry`, `pdm`.
- The chosen tool is documented in the project's own README. Do not mix tools in one project.

## Naming

- Functions, methods, modules, packages: `snake_case`
- Classes, exceptions, type aliases: `PascalCase`
- Module-level constants: `SCREAMING_SNAKE_CASE`
- Module-private: leading underscore (`_helper`)
- Name-mangled: double leading underscore (`__field`), used rarely and deliberately

## Type Hints

- Required on all public function and method signatures, parameters and return type.
- Use PEP 604 union syntax: `int | None`, not `Optional[int]`. `X | Y`, not `Union[X, Y]`.
- `from __future__ import annotations` at the top of every module that uses forward references.
- Prefer `collections.abc` (`Iterable`, `Mapping`) over `typing` equivalents for runtime types.

## Docstrings

- Google style. Renders cleanly under mkdocs and Sphinx + napoleon.
- Every public function, method, and class gets a docstring.
- Required: one-line summary. Then `Args:`, `Returns:`, `Raises:` as applicable.
- No placeholder text ("TODO", "Does the thing").

## Async

- Use `async def` and `await`. Fan-out with `asyncio.gather`.
- Do not mix sync and async in one call chain. If a sync API must be wrapped, document the wrapper explicitly.
- Never `time.sleep` inside async code. Use `asyncio.sleep`.
- Never call `asyncio.run` from inside an already-running loop.

## Error Handling

- Define typed exceptions for domain errors, inheriting from a single project base exception.
- No bare `except:`. No `except Exception:` unless you re-raise or log-and-reraise at a boundary.
- Catch only what you can handle. Let the rest propagate.
- Preserve context: `raise NewError(...) from original`.

## Imports

- Absolute imports only. No relative imports across package boundaries.
- Order: standard library, third-party, first-party. Blank line between groups. Ruff's isort rules enforce this.
- No wildcard imports (`from x import *`).

## Lint and Format

- `ruff check` and `ruff format`. Configured under `[tool.ruff]` in `pyproject.toml`.
- Ruff replaces black, isort, flake8, and pylint for this project. Do not add the others.
- Line length: 100.

## Type Checking

- `pyright` recommended. `mypy` acceptable. The project picks one and runs it in CI.
- Strict mode for first-party code under `src/`.
- Relaxed for `tests/` where mocks make strict typing noisy.

## Tests

- `pytest`.
- Tests live under `tests/` mirroring `src/<package>/` structure.
- Test files: `test_<module>.py`. Test functions: `test_<thing>_<condition>_<expectation>`.
- Use fixtures over `setUp` / `tearDown`. No `unittest.TestCase` subclasses in new code.

## Coverage

- `coverage`, run via `coverage run -m pytest && coverage report` or via `pytest-cov`.
- Configured under `[tool.coverage.run]` and `[tool.coverage.report]` in `pyproject.toml`.
- `fail_under` set in CI. Do not lower it without a stated reason.

## Build and Verification

Canonical commands a contributor runs locally and CI runs in order:

- `uv sync`
- `uv run ruff check`
- `uv run ruff format --check`
- `uv run pyright`
- `uv run pytest`
- `uv run coverage report`

`pip` equivalents (when uv is not in use):

- `pip install -e ".[dev]"`
- `ruff check`
- `ruff format --check`
- `pyright`
- `pytest`
- `coverage report`

## Secrets

- Read from environment via `os.environ` or `python-dotenv` for local development.
- Never hard-code secrets, tokens, or keys.
- `.env` is gitignored. Provide `.env.example` with empty values and inline comments naming each variable.

## Starter pyproject.toml

```toml
[project]
name = "your-package"
version = "0.1.0"
requires-python = ">=3.11"
dependencies = []

[project.optional-dependencies]
dev = [
    "pytest",
    "pytest-cov",
    "ruff",
    "pyright",
    "coverage",
]

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[tool.ruff]
line-length = 100
src = ["src", "tests"]

[tool.ruff.lint]
select = ["E", "F", "I", "B", "UP", "N", "SIM"]

[tool.pyright]
include = ["src"]
strict = ["src"]
pythonVersion = "3.11"

[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "-ra"

[tool.coverage.run]
source = ["src"]
branch = true

[tool.coverage.report]
fail_under = 80
show_missing = true
```
