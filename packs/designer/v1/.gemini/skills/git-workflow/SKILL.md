---
name: git-workflow
description: Manage git commits, branches, and GitHub PRs. Activate when the user asks to commit, push, open a PR, or manage branches.
---

# Git Workflow

## Read First

- `.claude/conventions/commit-style.md`
- `.claude/conventions/do-work-protocol.md`

## Directives

- Follow GitHub Flow and Conventional Commits: `type(scope): description`.
- Scan the staged diff for secrets before every commit, preferring `gitleaks protect --staged --no-banner --redact`.
- Reject blocked secret-like files unless explicitly approved.
- Open PRs with `gh pr create` and include testing evidence.
- Write a git summary to `do-work/summaries/REQ-NNN-git.md` when a REQ is involved.

## Verification

- Secret scan runs before every commit

## Definition of Done

- [ ] Secret scan ran before each commit and found no leaks
- [ ] Commits and branch names follow the conventions
- [ ] Remote and PR state match expectations
- [ ] Summary written to `do-work/summaries/` when a REQ is involved
