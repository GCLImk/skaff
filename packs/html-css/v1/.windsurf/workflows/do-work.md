# do-work Run

Drain the do-work queue, processing pending REQs through the skaff pipeline.

1. Read `.claude/conventions/do-work-protocol.md` for queue semantics
2. Acquire the queue lock at `do-work/.lock` (write JSON with pid, started_at, host)
3. List all `do-work/REQ-*-pending.md` files
4. For each pending REQ:
   a. Move to `do-work/working/REQ-NNN-in-progress.md`
   b. Read the REQ and triage complexity (simple/medium/complex)
   c. For medium/complex: scout the codebase before planning
   d. Write a `## Plan` section into the REQ (`html-css-implement` in plan-only mode)
   e. Implement the HTML, CSS, and JavaScript changes per the plan
   f. Run `npm run build`, `npm run lint`, `npx stylelint`, and `npx playwright test` - fix failures
   g. Review the diff for correctness, accessibility, and style
   h. Score the ratchet dimensions; append `## Ratchet` section
   i. Commit with `git-workflow` conventions
   j. Move REQ to `do-work/archive/REQ-NNN-done.md`
5. Release the lock (delete `do-work/.lock`)
6. Write loop summary to `do-work/summaries/do-work-run-<date>.md`
