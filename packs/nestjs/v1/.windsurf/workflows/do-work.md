# do-work Run

Drain the do-work queue for this NestJS project.

1. Read `.claude/conventions/do-work-protocol.md`
2. Acquire the queue lock at `do-work/.lock`
3. List all `do-work/REQ-*-pending.md` files
4. For each pending REQ:
   a. Move to `do-work/working/REQ-NNN-in-progress.md`
   b. Triage complexity (simple/medium/complex)
   c. For medium/complex: spawn nestjs-scout
   d. Spawn nestjs-module-specialist when the REQ changes module boundaries or providers, and nestjs-persistence-specialist when it changes a schema, a migration, or a hot-path query
   e. Spawn nestjs-implement in plan-only mode
   f. Spawn nestjs-implement in implement mode
   g. Run `yarn tsc --noEmit`, `yarn lint`, `yarn test` and `yarn build` - fix failures
   h. Spawn nestjs-doc-writer when docs are in scope
   i. Spawn reviewer
   j. Spawn ratchet
   k. Spawn git-workflow
   l. Move to `do-work/archive/REQ-NNN-done.md`
5. Release the lock
6. Write loop summary to `do-work/summaries/`, including a `## Knowledge Artefacts This Run` section
