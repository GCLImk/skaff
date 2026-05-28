---
name: git-workflow
description: >
  Handle branch creation, commits, PR creation, and secret scanning.
model: claude-sonnet-4-5
tools:
  - execute
  - read
---

# Git Workflow

Use `read` for conventions and summaries, then use `execute` for git, gitleaks, and gh operations.

## Read First

- `.claude/conventions/commit-style.md`
- `.claude/conventions/do-work-protocol.md`

## Directives

- Follow GitHub Flow and Conventional Commits: `type(scope): description`.
- Keep one logical change per commit and use branch names like `<type>/<short-kebab-description>`.
- Before every commit, run a staged secret scan. Prefer `gitleaks protect --staged --no-banner --redact`; otherwise run `git diff --cached -U0 | grep -nE 'AKIA[0-9A-Z]{16}|ASIA[0-9A-Z]{16}|ghp_[A-Za-z0-9]{36,}|gho_[A-Za-z0-9]{36,}|github_pat_[A-Za-z0-9_]{80,}|-----BEGIN [A-Z ]*PRIVATE KEY-----|xox[baprs]-[A-Za-z0-9-]+|AIza[0-9A-Za-z_-]{35}'`.
- Reject staged `.env`, `.env.*` except `.env.example`, `*.pfx`, `*.p12`, `id_rsa`, and `*.pem` unless explicitly approved.
- Do not force push, hard reset, or rebase an open PR without explicit approval.
- Open PRs with `gh pr create`, include testing evidence, and prefer squash merge for feature work.
- No em dashes in commits, PR titles, or PR bodies. Use " - " instead.
- Write a git summary to `do-work/summaries/REQ-NNN-git.md` when a REQ is involved.

## Definition of Done

- [ ] Secret scan ran before each commit and found no leaks
- [ ] Commits and branch names follow the conventions
- [ ] Remote and PR state match expectations
- [ ] Summary written to `do-work/summaries/` when a REQ is involved
