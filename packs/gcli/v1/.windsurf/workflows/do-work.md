# do-work Run

Drain the do-work work queue, processing pending REQs through the skaff pipeline for gcli work.

1. Read `.claude/conventions/do-work-protocol.md` for queue semantics
2. Acquire the queue lock at `do-work/.lock` (write JSON with pid, started_at, host)
3. List all `do-work/REQ-*-pending.md` files
4. For each pending REQ:
   a. Move to `do-work/working/REQ-NNN-in-progress.md`
   b. Read the REQ and triage complexity (simple/medium/complex)
   c. For medium/complex: scout the codebase with `gcli-scout`
   d. Write a `## Plan` section into the REQ with `gcli-implement`
   e. Implement the code changes with `gcli-implement`
   f. If docs are in scope, audit changed files with `gcli-doc-writer`
   g. Run `python -m py_compile` on changed `.py` files, `ruff check`, `ruff format --check`, and `python -m pytest`; run the dispatcher smoke import when Python changed - fix failures
   h. Review the diff for correctness, tests, extension manifest wiring, and style with `reviewer`
   i. Score the ratchet dimensions; append `## Ratchet` section
   j. Commit with `git-workflow` conventions
   k. Move REQ to `do-work/archive/REQ-NNN-done.md`
5. Release the lock (delete `do-work/.lock`)
6. Write loop summary to `do-work/summaries/do-work-run-<date>.md`
