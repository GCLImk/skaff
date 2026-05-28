# appscript pack

Google Apps Script pack for standalone Workspace automation using the V8 runtime, clasp CLI, optional TypeScript, and GAS-aware linting and testing. Targets Sheets, Docs, Drive, Gmail, Forms, and Calendar automation.

## Versions

| Version | Status | Target runtime / tool baseline | Changelog |
| ------- | ------ | ------------------------------ | --------- |
| v1 | maintained | Apps Script V8, clasp, ESLint, jest-gas-mock | Initial cut |

**Latest:** v1

## Notes

- This pack is for standalone Google Apps Script only. For AppSheet platform work, use the `appsheet` pack.
- GAS service calls can fail transiently. All calls should be wrapped in try-catch.
- Batch spreadsheet reads and writes are required - never cell-by-cell in loops.
- clasp is the deployment tool. Push with `clasp push`.
- Test coverage threshold is lower (0.3) because GAS mocking is inherently harder than browser or server testing.
