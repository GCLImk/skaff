# Claude Agent Scaffold - Install

Installs a `CLAUDE.md`, agent roster, convention files, and `do-work/` runtime skeleton into a target project. The agent roster and conventions are pulled from a **pack** you pick at install time.

## Packs

A pack is a language or platform bundle. Each pack ships one or more versions.

| Pack       | Versions (latest)                   | What it targets                                                     |
| ---------- | ----------------------------------- | ------------------------------------------------------------------- |
| `csharp`   | v2 (maintained), v1 (frozen)        | .NET 9+ projects using `dotnet` CLI, CS1591 docs gate               |
| `appsheet` | v2 (maintained), v1 (frozen)        | Google AppSheet + Apps Script + Sheets schema governance projects   |
| `python`   | v1 (maintained)                     | Python 3.12+ projects with uv, ruff, pytest, coverage, interrogate  |
| `nextjs`   | v1 (maintained)                     | Next.js 14 + TypeScript on Cloud Run, NextAuth Google OAuth, Sheets v4 |
| `gcli`     | v1 (maintained)                     | Python 3.9+ agentic CLI with Chrome MV3 extension and Gemini Gem persona/skill system |

v1 packs carried an orchestrator-as-sub-agent topology that cannot spawn specialists via the Agent tool. v2 moves orchestration to a `/do-work-run` slash command executed by the main session. See each pack's `PACK.md` for the upgrade path.

Full list and manifests under [packs/](./packs/). Pack contract and version bumping rules in [packs/README.md](./packs/README.md).

## Install

### Windows / PowerShell

```powershell
.\install.ps1 -NewProjectDir C:\repos\MyService
.\install.ps1 -NewProjectDir C:\repos\MyApp -Pack appsheet
.\install.ps1 -NewProjectDir C:\repos\MyApp -Pack csharp@v1 -Force
```

### Linux / macOS / Git Bash

```bash
./install.sh /path/to/my-project
./install.sh /path/to/my-app --pack appsheet
./install.sh /path/to/my-app --pack csharp@v1 --force
```

Default pack is `csharp`. Default version is the latest numeric `v<N>` directory in the pack. Pinning: `<pack>@<version>` (e.g. `appsheet@v1`).

## What gets installed

The installer copies two source trees into the target, in order:

1. **`common/`** - the shared tree: language-agnostic conventions (`commit-style.md`), generic REQ/UR templates, and `do-work/` runtime dir skeletons.
2. **`packs/<pack>/<version>/`** - the pack overlay: agent roster, pack-specific conventions, `CLAUDE.md.template`, `ratchet.conf.template`, `.gitleaks.toml.template`, optional `ci/` workflows.

The pack overlay wins on any file collision with `common/`. The `CLAUDE.md.template` is special-cased: it installs to `<target>/CLAUDE.md` and is not preserved under `do-work/templates/` in the target.

## Pack identity sentinel

After copy, the installer writes `<target>/.claude/.pack`:

```text
pack: csharp
version: v1
installed_at: 2026-04-24T13:42:40Z
scaffold_commit: abc1234
```

Future tooling reads this to detect pack mismatches on upgrade. Do not edit by hand.

## Behaviour

- Idempotent. Re-running on an already-installed project is safe.
- Existing target files are preserved by default. Use `-Force` or `--force` to overwrite.
- The target directory is created if it does not exist.
- `.gitkeep` sentinels preserve empty runtime directories so they survive a clean checkout.
- Repo-root files (`install.*`, `README.md`, `INSTALL.md`, `CLAUDE.md`, `packs/README.md`, `packs/SHARED-NOTES.md`, `packs/*/PACK.md`) are not copied to the target by construction - the installers only walk `common/` and `packs/<pack>/<version>/`.

## Upgrading an installed project

There is no in-place upgrade. To move a target from one pack or version to another:

```bash
./install.sh /path/to/project --force --pack <pack>@<new-version>
```

Review the diff in the target's git history, keep what you want, discard what you do not.

## After install

1. Review `CLAUDE.md` and `.claude/conventions/` before first use.
2. Confirm the agent roster in `.claude/agents/` matches your project's stack.
3. Optional: copy `do-work/templates/ratchet.conf.template` to `ratchet.conf` at the repo root and tune weights, thresholds, and N/A overrides.
4. Optional: copy `do-work/templates/.gitleaks.toml.template` to `.gitleaks.toml` at the repo root.
5. Optional (packs that ship one): copy `do-work/templates/ci/ratchet-gate.yml.template` to `.github/workflows/ratchet-gate.yml`.
6. Commit the scaffold:

   ```bash
   git add .
   git commit -m "chore: bootstrap claude agent scaffold"
   ```

## Running the queue

Only one orchestrator may drain the queue at a time. `do work run` acquires `do-work/.lock`. Concurrent invocations refuse to start. See `.claude/conventions/do-work-protocol.md` in the installed pack for lock semantics.

## Dispatch budget

Sub-agents receive at most 2000 tokens of verbatim content per dispatch brief. Over that, the orchestrator passes file paths and the sub-agent re-reads from disk inside its isolated context window. See the installed pack's `do-work-protocol.md`.
