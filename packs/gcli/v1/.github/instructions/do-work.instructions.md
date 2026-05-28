---
applyTo: "do-work/**"
---

# do-work Instructions

- REQs move through pending, working, and archive states via file moves only.
- Only the main session acquires `do-work/.lock` and moves REQs between queue states. The lock file stores `pid`, `started_at`, and `host`.
- Respect write ownership. Do not rewrite REQ bodies or specialist-owned sections unless your role owns them.
- Treat files in `do-work/working/` and `do-work/archive/` as immutable. Create an addendum REQ for follow-up work.
- Keep dispatch briefs within the 2000 token verbatim-content budget and prefer file paths plus short summaries when over budget.
- Read `.claude/conventions/do-work-protocol.md` for the full protocol.
