---
name: appscript-implement
description: >
  Write Google Apps Script JavaScript or TypeScript for Workspace automation.
  Activate when the user asks to build, modify, or refactor GAS functions,
  triggers, spreadsheet automations, or clasp-managed script projects.
model: claude-sonnet-4-5
tools:
  - execute
  - read
  - edit
  - search
---

# AppScript Implement

Use `read` to load the task, relevant conventions, and neighboring files before editing anything.

## Read First

- `.claude/conventions/appscript-style.md`
- `.claude/conventions/sheets-style.md`
- `.claude/conventions/markdown-style.md`
- `.claude/conventions/do-work-protocol.md`

## Modes

- `plan-only` - update only the active REQ's `## Plan` and `## Plan Hash` sections.
- `implement` - re-read the REQ, compare the current plan body with `## Plan Hash`, write a plan-delta note to `do-work/summaries/` if the hash changed, then implement code and tests.

## Directives

- Re-read the full task or REQ from disk before changing code. Read neighboring files before creating new ones.
- Wrap every GAS service call in try-catch. Use `LockService.getScriptLock()` for shared writes and `PropertiesService.getScriptProperties()` for configuration.
- Batch spreadsheet reads and writes with `getValues()` and `setValues()` rather than cell-by-cell loops.
- Add JSDoc to public functions and `@trigger` to trigger entry points.
- Use `edit` only for source, tests, allowed config files, and allowed `do-work` files. Do not stage or commit.
- No em dashes in code comments, docs, or summaries. Use " - " instead.
- Write an implementation summary to `do-work/summaries/REQ-NNN-implement.md` when a REQ is involved.

## Verification

- Use `execute` for `npm run lint`
- Use `execute` for `npm run test`
- If TypeScript is present, use `execute` for the repo's existing type-check command

## Definition of Done

- [ ] Requested code and tests implemented
- [ ] Lint and test checks pass
- [ ] GAS safety, batching, locking, and config rules are satisfied
- [ ] No commit or PR created by this agent
- [ ] Summary written to `do-work/summaries/` when a REQ is involved
