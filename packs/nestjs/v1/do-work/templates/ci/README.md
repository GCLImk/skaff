# CI Templates

GitHub Actions workflow templates that enforce ratchet-adjacent quality gates outside the agent
loop. Copy into `.github/workflows/` to activate.

## `ratchet-gate.yml.template`

Blocks PRs on objective regressions: type-check failure, lint failure, format drift, unit or e2e
test failure, build failure, a high-severity dependency advisory, a leaked secret, or a baseline
composite below the project floor.

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
   - `ratchet-gate / Type check, lint, test, build`
   - `ratchet-gate / Dependency advisories`
   - `ratchet-gate / Secret scan (gitleaks)`
   - `ratchet-gate / Ratchet baseline regression`
4. Enable **Require pull request reviews before merging** (human review stays required)
5. Disable any auto-merge settings

### What this workflow does NOT do

- It does not re-score all eight ratchet dimensions. That is agent-owned.
- It does not auto-merge. Human review remains required.
- It does not gate on `structure`, `dead_code`, or `complexity` - those dimensions are hard to
  score deterministically without an LLM in the loop. The ratchet agent scores them; this
  workflow handles the objective, deterministic gates.
- It gates only the deterministic half of `security` (advisories and secret scanning). Guard
  coverage on new routes, DTO validation, and query parameterisation are still scored by the
  ratchet agent from the diff.

### Tuning

- **Composite floor** - edit `RATCHET_COMPOSITE_FLOOR` in the workflow env (default 0.75). Raise
  it once the project has stable baselines above the floor.
- **Node version** - edit `node-version` if the project is not on 22.x. Node 20 LTS is also
  supported by this pack.
- **Package manager** - the workflow uses yarn activated through corepack, matching the pack's
  agent tool allowlists. If the project uses npm or pnpm, swap the `corepack enable` and
  `yarn install --immutable` steps and update every `yarn <script>` command, and edit the
  `Bash(yarn ...)` grants in `.claude/agents/*.md` to match.
- **Audit severity** - `yarn npm audit --severity high` is the starting floor. Raise to
  `moderate` once the existing advisory backlog is clear.
- **e2e tests** - remove the "End-to-end tests" step if the project has no `test:e2e` script yet,
  and add it back in the same REQ that introduces the harness.
- **Gitleaks license** - only required for GitHub organisations, not personal accounts. Remove the
  env line if not applicable.

### Compatibility

- GitHub Actions runner (ubuntu-latest). Adapt to self-hosted runners by changing `runs-on`.
- For GitLab CI / Bitbucket Pipelines / Jenkins, use the job structure as a reference but
  translate syntax.
- Services that need a live database for their e2e specs should add a `services:` block to the
  `build-and-test` job rather than pointing the suite at a shared database.

### Troubleshooting

- **"This project's package.json defines packageManager"** - the workflow runs `corepack enable`
  before `setup-node` so the pinned yarn version is available. Do not add a global
  `npm i -g yarn` step; it fights corepack.
- **"The lockfile would have been modified by this install"** - `--immutable` is doing its job.
  Run `yarn install` locally, commit the updated `yarn.lock`, and push.
- **"gitleaks-action failed with license error"** - add or remove the `GITLEAKS_LICENSE` secret
  depending on whether you are in an organisation.
- **"No ratchet baselines yet"** - expected on the first few PRs. The regression job returns
  success until `baselines.jsonl` has at least one entry.
- **Type errors** - run `yarn tsc --noEmit` locally to reproduce. The CI job uses the same
  command.
- **Lint failures** - run `yarn lint` locally; the CI job uses the project's own ESLint config
  and the `--max-warnings 0` flag from the `lint` script.
