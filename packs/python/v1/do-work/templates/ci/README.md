# CI Templates

GitHub Actions workflow templates that enforce ratchet-adjacent quality gates outside the agent loop. Copy into `.github/workflows/` to activate.

## `ratchet-gate.yml.template`

Blocks PRs on objective regressions: ruff lint failure, ruff format drift, pytest failure, interrogate docstring shortfall, leaked secrets, or a baseline composite below the project floor.

### Install

```bash
cp do-work/templates/ci/ratchet-gate.yml.template .github/workflows/ratchet-gate.yml
git add .github/workflows/ratchet-gate.yml
git commit -m "ci: add ratchet-gate workflow"
git push
```

### Required repo settings

After pushing the workflow file, configure branch protection on `main`:

1. Repo Settings -> Branches -> Branch protection rules -> Add rule for `main`
2. Enable **Require status checks to pass before merging**
3. Add these required checks:
   - `ratchet-gate / Lint, test, docs`
   - `ratchet-gate / Secret scan (gitleaks)`
   - `ratchet-gate / Ratchet baseline regression`
4. Enable **Require pull request reviews before merging** (human review stays required)
5. Disable any auto-merge settings

### What this workflow does NOT do

- It does not re-score all seven ratchet dimensions. That is agent-owned.
- It does not auto-merge. Human review remains required.
- It does not gate on `structure`, `dead_code`, or `complexity` - those dimensions are hard to score deterministically without an LLM in the loop. The ratchet agent scores them; this workflow handles the objective, deterministic gates.

### Tuning

- **Composite floor** - edit `RATCHET_COMPOSITE_FLOOR` in the workflow env (default 0.75). Raise it once the project has stable baselines above the floor.
- **Python version** - edit `python-version` in the setup step if the project pins a different minor (e.g. 3.11, 3.13).
- **Package manager** - the template assumes `uv`. For pip / poetry / pdm projects, swap the `Setup uv` and `Install dependencies` steps for the equivalent install commands and prefix runs with the project's runner (`poetry run`, `pdm run`, or bare `python -m`).
- **Coverage source** - the template runs `pytest --cov=src`. Change `src` to the project's package directory.
- **Pyright** - the type check step uses `continue-on-error: true` so a fresh project with type drift does not block PRs. Flip to a hard gate once the project is type-clean.
- **Gitleaks license** - only required for GitHub organisations, not personal accounts. Remove the env line if not applicable.

### Compatibility

- GitHub Actions runner (ubuntu-latest). Adapt to self-hosted runners by changing `runs-on`.
- For GitLab CI / Bitbucket Pipelines / Jenkins, use the job structure as a reference but translate syntax.

### Troubleshooting

- **"gitleaks-action failed with license error"** - add or remove the `GITLEAKS_LICENSE` secret depending on whether you are in an organisation.
- **"No ratchet baselines yet"** - expected on the first few PRs. The regression job returns success until `baselines.jsonl` has at least one entry.
- **Interrogate fails on missing docstrings** - run `uv run interrogate -v src/` locally to see flagged members, then add docstrings or tune `interrogate` config in `pyproject.toml`.
- **Ruff format check fails** - run `uv run ruff format` locally and commit the result.
