---
name: appsheet-implement
description: >
  Write or update Google AppSheet app definitions, Apps Script code, or Sheets schema. Activate for AppSheet formula work, Apps Script automation, or data schema changes.
---

# AppSheet Implement

Write Apps Script code and AppSheet or Sheets specs for the project.

## Read First

Before coding, read:

- `.claude/conventions/appsheet-style.md`
- `.claude/conventions/markdown-style.md`
- `.claude/conventions/do-work-protocol.md`

## Directives

- Re-read the full task or REQ from disk before changing files. Read neighboring scripts and spec docs before creating new ones.
- Match existing Apps Script layout, Sheets schema format, and AppSheet spec structure. Confirm the target surface before adding files.
- Exported Apps Script functions get JSDoc. Triggers live in `triggers.gs`. Secrets come from `PropertiesService`.
- Sheets and AppSheet spec changes include migration notes, operator checklists, and verbatim expressions where relevant.
- In plan-only work, write only the `## Plan` and `## Plan Hash` sections in the active REQ.
- In implement work, leave commits, branch management, and PRs to `git-workflow`.
- No em dashes in code comments, docs, summaries, or commit text. Use " - " instead.
- When working through `do-work`, write an implementation summary to `do-work/summaries/REQ-NNN-implement.md`.

## Verification

- Syntax passes: `node --check` on changed `.js` and `.gs` files
- Lint passes: `npx eslint` on changed files when configured
- Format passes: `npx prettier --check` on changed files when configured
- Tests pass: `npm test` when configured and in scope
- Spec changes include migration notes and operator checklists

## Definition of Done

- [ ] Requested code or spec changes are implemented
- [ ] `node --check` passes on changed script files
- [ ] `npx eslint` passes when configured, or skipping is justified
- [ ] `npx prettier --check` passes when configured, or skipping is justified
- [ ] `npm test` passes when configured and in scope, or skipping is justified
- [ ] JSDoc, migration note, and operator checklist rules are satisfied
- [ ] Summary written to `do-work/summaries/` when a REQ is involved
- [ ] Changes left ready for reviewer and `git-workflow`
