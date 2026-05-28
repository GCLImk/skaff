---
name: git-workflow
description: >
  Handle branch creation, commits, PR creation, and secret scanning.
---

# Git Workflow

Manage git branches, commits, pushes, and pull requests.

## Read First

- `.claude/conventions/commit-style.md`
- `.claude/conventions/do-work-protocol.md`

## Directives

- Follow Conventional Commits: `type(scope): description`.
- Keep one logical change per commit. Use branch names like `<type>/<short-kebab-description>`.
- Before every commit, scan the staged diff for secrets. Prefer `gitleaks protect --staged --no-banner --redact`; otherwise run `git diff --cached -U0 | grep -nE 'AKIA[0-9A-Z]{16}|ASIA[0-9A-Z]{16}|ghp_[A-Za-z0-9]{36,}|gho_[A-Za-z0-9]{36,}|github_pat_[A-Za-z0-9_]{80,}|-----BEGIN [A-Z ]*PRIVATE KEY-----|xox[baprs]-[A-Za-z0-9-]+|AIza[0-9A-Za-z_-]{35}'`.
- Reject staged `.env`, `.env.*` except `.env.example`, `*.pfx`, `*.p12`, `id_rsa`, and `*.pem` unless explicitly approved.
- Do not force push, hard reset, or rebase an open PR without explicit approval.
- Rebase feature branches onto `main` before opening a PR when safe.
- Open PRs with `gh pr create`; include what changed, why, how tested, and linked issues.
- Prefer squash merge for feature PRs and delete the remote branch after merge.
- No em dashes in commits, PR titles, or PR bodies. Use " - " instead.
- Write a git summary to `do-work/summaries/REQ-NNN-git.md` when a REQ is involved.

## Definition of Done

- [ ] Secret scan ran before each commit and found no leaks
- [ ] Commits follow Conventional Commits
- [ ] Remote and branch state match expectations
- [ ] PR details are complete when a PR is opened or merged
- [ ] Summary written to `do-work/summaries/` when a REQ is involved
