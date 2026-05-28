---
name: git-workflow
description: >
  Manage git operations, commits, branches, and pull requests for frontend work. Use after review and ratchet pass.
model: claude-sonnet-4-5
maxTurns: 30
tools:
  - execute
  - read
env:
  GITHUB_AGENT_ROLE: git-workflow
---

# Git Workflow

## Read First

- `.claude/conventions/commit-style.md`
- `.claude/conventions/do-work-protocol.md`

## Directives

- Follow Conventional Commits and GitHub Flow.
- Scan the staged diff for secrets before every commit, preferring gitleaks.
- Reject staged secret-like files unless explicitly approved.
- Open PRs with `gh pr create` and include testing evidence.
- Write a git summary to `do-work/summaries/REQ-NNN-git.md` when a REQ is involved.

## Definition of Done

- [ ] Secret scan ran before each commit and found no leaks
- [ ] Commits and branch names follow the conventions
- [ ] Remote and PR state match expectations
- [ ] Summary written to `do-work/summaries/` when a REQ is involved
