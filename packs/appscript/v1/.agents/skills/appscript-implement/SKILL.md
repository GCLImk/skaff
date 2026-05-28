---
name: appscript-implement
description: Write Google Apps Script JavaScript or TypeScript for Workspace automation. Activate for any GAS function, trigger, Sheets batch operation, or clasp-managed script change.
---

# AppScript Implement

Write Google Apps Script JavaScript or TypeScript for Workspace automation.

## Read First

Before coding, read:

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
- In plan-only work, write only the `## Plan` and `## Plan Hash` sections in the active REQ.
- In implement work, leave commits, branch management, and PRs to `git-workflow`.
- No em dashes in code comments, docs, summaries, or commit text. Use " - " instead.
- When working through `do-work`, write an implementation summary to `do-work/summaries/REQ-NNN-implement.md`.

## Verification

- Use `execute` for `npm run lint`
- Use `execute` for `npm run test`
- If TypeScript is present, use `execute` for the repo's existing type-check command

## Definition of Done

- [ ] Requested code and tests are implemented
- [ ] Lint and test checks pass
- [ ] GAS safety, batching, locking, and config rules are satisfied
- [ ] No commit or PR created by this agent
- [ ] Summary written to `do-work/summaries/` when a REQ is involved
