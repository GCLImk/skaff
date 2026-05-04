# python pack

Targets Python 3.12+ projects using `uv` + `pyproject.toml` for packaging, `ruff` for lint and format, `pytest` + `coverage` for tests, `interrogate` for docstring coverage, and optional `pyright` or `mypy` for type checking. Ships specialist agents (`python-scout`, `python-implement`, `python-doc-writer`) plus the shared reviewer, ratchet, and git-workflow agents. Orchestration lives in a main-session slash command (`/do-work-run`).

## Versions

| Version | Status     | Target tool baseline                                                            | Changelog                                                          |
| ------- | ---------- | ------------------------------------------------------------------------------- | ------------------------------------------------------------------ |
| v1      | maintained | Python 3.12+, uv, ruff, pytest, coverage, interrogate, pyright (optional)       | Initial cut, parity with csharp/v2 and appsheet/v2 topology        |

**Latest:** v1

## Notes

### Toolchain choices

- **Packaging:** default `uv` with `pyproject.toml`. Acceptable alternatives the convention names: `pip`, `poetry`, `pdm`. Pick one per project; do not mix.
- **Lint + format:** `ruff` exclusively. `ruff` replaces `black`, `isort`, `flake8`, and `pylint` for this pack's purposes.
- **Type checking:** `pyright` recommended (faster, growing adoption). `mypy` is the documented fallback.
- **Docstrings:** Google style. Enforced for public symbols via `interrogate`.
- **Layout:** src layout (`src/<package>/` + `tests/`) preferred. Flat layout acceptable but documented as a deviation.

### Ratchet tuning rationale

- `test_coverage_weight = 1.5` - Python projects typically have strong test culture; emphasised.
- `threshold_doc_quality = 0.70` - tuned slightly lower than C# since not every internal helper warrants a docstring. Public symbols are still gated.
- `threshold_test_coverage = 0.60` - pytest-cov target. Raise per project as the suite matures.
- `na_dimensions` empty - all seven dimensions measurable from day one in a typical Python project.

### Divergence from shared

None declared. Protocol-level conventions track the csharp pack with agent-name and tool-name substitutions.

### Upgrading from a different pack

Re-run the installer with `--force --pack python@v1`. Review the diff in the target's git history. Mixing packs in one repo is not supported.
