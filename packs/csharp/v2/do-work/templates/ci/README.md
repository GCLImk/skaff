# CI Templates

GitHub Actions workflow templates that enforce ratchet-adjacent quality gates outside the agent loop. Copy into `.github/workflows/` to activate.

## `ratchet-gate.yml.template`

Blocks PRs on objective regressions: build failure, test failure, format drift, CS1591 missing-doc warnings, leaked secrets, or a baseline composite below the project floor.

### Install

```bash
cp do-work/templates/ci/ratchet-gate.yml.template .github/workflows/ratchet-gate.yml
git add .github/workflows/ratchet-gate.yml
git commit -m "ci: add ratchet-gate workflow"
git push
```

### Required repo settings

After pushing the workflow file, configure branch protection on `main`:

1. Repo Settings → Branches → Branch protection rules → Add rule for `main`
2. Enable **Require status checks to pass before merging**
3. Add these required checks:
   - `ratchet-gate / Build, test, format`
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
- **.NET version** - edit `dotnet-version` in the setup step if you are not on 9.x.
- **Gitleaks license** - only required for GitHub organisations, not personal accounts. Remove the env line if not applicable.

### Compatibility

- GitHub Actions runner (ubuntu-latest). Adapt to self-hosted runners by changing `runs-on`.
- For GitLab CI / Bitbucket Pipelines / Jenkins, use the job structure as a reference but translate syntax.

### Troubleshooting

- **"gitleaks-action failed with license error"** - add or remove the `GITLEAKS_LICENSE` secret depending on whether you are in an organisation.
- **"No ratchet baselines yet"** - expected on the first few PRs. The regression job returns success until `baselines.jsonl` has at least one entry.
- **CS1591 warnings** - run `dotnet build /warnaserror:CS1591` locally to reproduce, then add XML docs to the flagged members.
