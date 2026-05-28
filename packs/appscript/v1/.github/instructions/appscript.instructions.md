---
applyTo: "**/*.js,**/*.ts,**/*.gs"
---

# Apps Script Instructions

- Wrap every GAS service call in try-catch.
- Batch Sheets reads and writes with `getValues()` and `setValues()`. Do not call `getValue()` or `setValue()` inside loops.
- Use `PropertiesService.getScriptProperties()` for configuration. Do not hard-code IDs or credentials.
- Use `LockService.getScriptLock()` before shared-resource writes that concurrent triggers could overlap.
- Add JSDoc to public functions and `@trigger` on trigger entry points.
- No em dashes in comments or docs. Use " - " instead.
- Read `.claude/conventions/appscript-style.md` and `.claude/conventions/sheets-style.md` for the complete guides.
