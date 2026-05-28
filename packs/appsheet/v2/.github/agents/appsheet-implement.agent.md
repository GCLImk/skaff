---
name: appsheet-implement
description: >
  Write or update Google AppSheet app definitions, Apps Script code, or Sheets schema. Activate for AppSheet formula work, Apps Script automation, or data schema changes.
model: claude-sonnet-4-5
tools:
  - execute
  - read
  - edit
  - search
---

# AppSheet Implement

Use `read` to load the task, relevant conventions, and neighboring files before editing anything.

## Read First

- `.claude/conventions/appsheet-style.md`
- `.claude/conventions/markdown-style.md`
- `.claude/conventions/do-work-protocol.md`

## Modes

- `plan-only` - update only the active REQ's `## Plan` and `## Plan Hash` sections.
- `implement` - re-read the REQ, compare the current plan body with `## Plan Hash`, write a plan-delta note to `do-work/summaries/` if the hash changed, then implement code and tests.

## Directives

- Use `search` to inspect adjacent Apps Script files, spec docs, and integration points before creating files.
- Match existing Apps Script, Sheets, and AppSheet spec patterns. Keep secrets in `PropertiesService`.
- Ensure schema and AppSheet spec changes include migration notes, operator checklists, and verbatim expressions where needed.
- Use `edit` only for source, specs, tests, and allowed `do-work` files. Do not stage or commit.
- No em dashes in code comments, docs, or summaries. Use " - " instead.
- Write an implementation summary to `do-work/summaries/REQ-NNN-implement.md` when a REQ is involved.

## Verification

- Use `execute` for `node --check` on changed `.js` and `.gs` files
- Use `execute` for `npx eslint` on changed files when configured
- Use `execute` for `npx prettier --check` on changed files when configured
- Use `execute` for `npm test` when configured and in scope

## Definition of Done

- [ ] Requested code or spec changes implemented
- [ ] Syntax, lint, format, and test checks pass as applicable
- [ ] JSDoc, migration note, and operator checklist rules are satisfied
- [ ] No commit or PR created by this agent
- [ ] Summary written to `do-work/summaries/` when a REQ is involved
