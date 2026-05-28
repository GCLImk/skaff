# do-work Run

Drain the do-work queue for this SvelteKit project.

1. Read `.claude/conventions/do-work-protocol.md`
2. Acquire the queue lock at `do-work/.lock`
3. List all `do-work/REQ-*-pending.md` files
4. For each pending REQ:
   a. Move to `do-work/working/REQ-NNN-in-progress.md`
   b. Triage complexity (simple/medium/complex)
   c. For medium/complex: spawn svelte-scout
   d. Spawn svelte-implement in plan-only mode
   e. Spawn svelte-implement in implement mode
   f. Run `npx svelte-check --tsconfig ./tsconfig.json`, `npm run test`, `npm run build`, and `npm run lint` - fix failures
   g. Spawn reviewer
   h. Spawn ratchet
   i. Spawn git-workflow
   j. Move to `do-work/archive/REQ-NNN-done.md`
5. Release the lock
6. Write loop summary to `do-work/summaries/`
