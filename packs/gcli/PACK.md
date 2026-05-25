# gcli pack

Targets Python 3.9+ projects that follow the gcli architecture - an agentic CLI backed by Gemini, optionally paired with a Chrome MV3 extension and a native messaging host. Ships specialist agents (`gcli-scout`, `gcli-implement`, `gcli-doc-writer`) plus the shared reviewer, ratchet, and git-workflow agents. Also installs starter Gemini Gem persona files and a skill file. Orchestration lives in the main-session `/do-work-run` slash command.

## Versions

| Version | Status     | Target tool baseline                     | Changelog   |
| ------- | ---------- | ---------------------------------------- | ----------- |
| v1      | maintained | Python 3.9+, pytest, ruff, no build step | Initial cut |

**Latest:** v1

## Notes

### Toolchain choices

- **Python execution:** direct `python` invocation is the default. This matches gcli, which runs scripts directly rather than through a packaging workflow.
- **Lint + format:** `ruff` is the single lint and formatting tool. Keep the surface small and deterministic.
- **Tests:** `pytest` for unit coverage, plus the dispatcher smoke import check after Python import or module changes.
- **Extension workflow:** no build step. Edit MV3 JavaScript directly and reload the extension in Chrome.

### Ratchet tuning rationale

- Smoke verification carries extra weight because gcli validation is often integration-shaped rather than line-coverage-shaped.
- Line-level coverage is not enforced by the pack. Many meaningful checks are dispatcher smoke tests or end-to-end DOM flows.
- Doc quality is weighted a bit lower because internal helpers are common and not every private helper needs a docstring.

### Personas and skills

- This pack installs starter Gemini Gem persona files and a generic starter skill alongside the Claude Code agents.
- Persona and skill files are part of the shipped scaffold, not post-install extras.

### Upgrading from a different pack

Re-run the installer with `--force --pack gcli@v1`. Review the diff in the target's git history. Mixing packs in one repo is not supported.
