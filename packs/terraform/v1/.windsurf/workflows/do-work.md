# do-work Run

Drain the do-work work queue, processing pending REQs through the skaff pipeline for Terraform work.

1. Read `.claude/conventions/do-work-protocol.md` for queue semantics
2. Acquire the queue lock at `do-work/.lock` (write JSON with pid, started_at, host)
3. List all `do-work/REQ-*-pending.md` files
4. For each pending REQ:
   a. Move to `do-work/working/REQ-NNN-in-progress.md`
   b. Read the REQ and triage complexity (simple/medium/complex)
   c. For medium/complex: scout the codebase with `tf-scout`
   d. Write a `## Plan` section into the REQ with `tf-implement`
   e. Run plan verification and confirm the REQ has `## Plan Verification` at 100% coverage before implementation
   f. Implement the Terraform changes with `tf-implement`
   g. If docs are in scope, audit descriptions and READMEs with `tf-doc-writer`
   h. Run `terraform fmt -check -recursive`, `terraform validate`, `tflint --recursive`, `terraform test`, and `checkov -d . --compact --quiet` - fix failures
   i. Review the diff for correctness, tests, docs, and security with `reviewer`
   j. Score the ratchet dimensions; append `## Ratchet` section
   k. Commit with `git-workflow` conventions
   l. Move REQ to `do-work/archive/REQ-NNN-done.md`
5. Release the lock (delete `do-work/.lock`)
6. Write loop summary to `do-work/summaries/do-work-run-<date>.md`
