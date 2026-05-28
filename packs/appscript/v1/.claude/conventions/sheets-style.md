# Sheets Style

## 1. Batch reads

- Read ranges in one call: `sheet.getDataRange().getValues()` or a specific range.
- Never call `range.getValue()` inside a loop over rows or columns.
- Store values in a 2D array, process in memory, then write once.

## 2. Batch writes

- Accumulate changes in a 2D array.
- Write once with `range.setValues(data)`.
- Never call `cell.setValue()` inside a loop.

## 3. Named ranges

- Prefer named ranges over A1 notation for business-logic ranges.
- A1 notation is acceptable for fixed structural references (headers, metadata rows).

## 4. Sheet references

- Prefer `spreadsheet.getSheetByName()` over index-based access.
- Check for null when getting a sheet by name; throw a clear error if not found.

## 5. Header row

- Treat row 1 as a header. Use `getValues()` starting from row 2 for data.
- Resolve column indices from the header row rather than hardcoding column numbers.

## 6. Flushes

- Call `SpreadsheetApp.flush()` only when you need the UI to update mid-execution.
- Flushing inside a loop is an anti-pattern.

## 7. Locking

- Before batch writes that concurrent triggers could overlap, acquire a `LockService` lock.
- Release in a finally block.
