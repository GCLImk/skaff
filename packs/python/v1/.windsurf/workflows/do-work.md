# do-work Run

Drain the do-work work queue, processing pending REQs through the skaff pipeline for Python work.

1. Read `.claude/conventions/do-work-protocol.md` for queue semantics
2. Acquire the queue lock at `do-work/.lock` (write JSON with pid, started_at, host)
3. List all `do-work/REQ-*-pending.md` files
4. For each pending REQ:
   a. Move to `do-work/working/REQ-NNN-in-progress.md`
   b. Read the REQ and triage complexity (simple/medium/complex)
   c. For medium/complex: scout the codebase with `python-scout`
   d. Write a `## Plan` section into the REQ with `python-implement`
   e. Implement the code changes with `python-implement`
   f. If docs are in scope, audit changed docstrings with `python-doc-writer`
   g. Run `uv run ruff check`, `uv run ruff format --check`, `uv run mypy`, and `uv run pytest` - fix failures
   h. Review the diff for correctness, tests, and style with `reviewer`
   i. Score the ratchet dimensions; append `## Ratchet` section
   j. Commit with `git-workflow` conventions
   k. Move REQ to `do-work/archive/REQ-NNN-done.md`
5. Release the lock (delete `do-work/.lock`)
6. Write loop summary to `do-work/summaries/do-work-run-<date>.md`
