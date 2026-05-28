# Apps Script Style

## 0. Project Layout

- Preferred layout: `appsscript.json` at the repo root, source under `src/`, tests under `tests/`, and local tooling (`package.json`, `tsconfig.json`, ESLint config) alongside them.
- Flat layouts with root-level `.gs`, `.js`, or `.ts` files are acceptable when the existing project already uses them.
- Keep GAS service boundaries thin. Put business logic in pure helpers where possible so tests do not depend on live services.

## 1. Runtime

- Target V8 runtime. Set `runtimeVersion: "V8"` in `appsscript.json`.
- Use ES2019+ syntax: `const`, `let`, arrow functions, destructuring, async/await where the tooling supports it.
- No ES modules (`import` or `export`) in deployed GAS files. Apps Script uses global scope. Use namespace objects or IIFE patterns to avoid collisions when needed.

## 2. Error handling

- Wrap every GAS service call in try-catch.
- Log the error before re-throwing or returning a safe default.
- Do not let transient GAS service failures propagate as unhandled exceptions.
- Example:

  ```js
  try {
    const ss = SpreadsheetApp.openById(id);
  } catch (err) {
    Logger.log('Failed to open spreadsheet: ' + err.message);
    throw err;
  }
  ```

## 3. Configuration

- Use `PropertiesService.getScriptProperties()` for all configuration values.
- No hardcoded IDs, names, or credentials in source files.
- Use a helper to get required properties and throw clearly if they are missing.

## 4. Concurrency

- Use `LockService.getScriptLock()` before modifying shared resources that concurrent executions could conflict on.
- Always release the lock in a finally block.

## 5. Quotas

- Be aware of the execution time limit (6 minutes for standard Apps Script executions).
- Avoid long-running loops. Prefer batch operations.
- Use `CacheService` for repeated reads that do not change within a session.
- Log a warning when approaching time limits if measurable.

## 6. Triggers

- Document every trigger with a JSDoc `@trigger` annotation.
- Time-driven triggers should avoid side effects on external state without idempotency.
- `onEdit` triggers must check the event object's range before acting.
- Group trigger entry points in one obvious location when the repo layout allows it.

## 7. Testing

- Use `jest-gas-mock`, `gas-mock-globals`, or the repo's existing GAS mock layer to mock global services.
- Keep business logic in pure functions. Keep GAS service calls at the boundary.
- Tests must not call live GAS services.

## 8. Logging

- Use `Logger.log()` for GAS-side logs visible in the Apps Script editor.
- Use `console.log()` for clasp-compatible local logging.
- Log at entry and exit of significant operations.

## 9. JSDoc

- Required on all public functions: `@param`, `@return` or `@returns`, and `@throws` when applicable.
- Add `@trigger` for functions registered as triggers.
- Use concrete names in docs. Avoid placeholder descriptions.

## 10. clasp workflow

- Push with `npx clasp push`.
- Pull remote changes with `npx clasp pull` before editing when the remote project may have drifted.
- Use `.claspignore` to exclude `node_modules`, tests, and local config from push.
- If using TypeScript, compile with `npx tsc` before pushing to catch type errors.
