# Apps Script Style

- Wrap every GAS service call in try-catch.
- Batch spreadsheet reads and writes. Do not call `getValue()` or `setValue()` inside loops.
- Use `PropertiesService.getScriptProperties()` for configuration, not hardcoded IDs or secrets.
- Use `LockService.getScriptLock()` before shared-resource writes that concurrent triggers could overlap.
- Add JSDoc to all public functions and `@trigger` to trigger entry points.
- Read `.claude/conventions/appscript-style.md` and `.claude/conventions/sheets-style.md` for the complete guides.
