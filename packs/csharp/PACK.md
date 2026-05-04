# csharp pack

Targets .NET 9+ projects using the standard `dotnet` CLI for build, test, format, and coverage. Ships specialist agents (`csharp-scout`, `csharp-implement`, `csharp-doc-writer`) plus the shared reviewer, ratchet, and git-workflow agents. Orchestration lives in a main-session slash command (`/do-work-run`) from v2 onward.

## Versions

| Version | Status     | Target runtime / tool baseline                      | Changelog                                                               |
| ------- | ---------- | --------------------------------------------------- | ----------------------------------------------------------------------- |
| v2      | maintained | .NET 9.x, `dotnet build/test/format`, CS1591 gate   | Orchestrator moved from sub-agent to `/do-work-run` slash command       |
| v1      | frozen     | .NET 9.x, `dotnet build/test/format`, CS1591 gate   | Initial cut extracted from Skaff. **Topology bug:** orchestrator was defined as a sub-agent but sub-agents cannot spawn sibling sub-agents via the Agent tool. Frozen; do not install on new projects. |

**Latest:** v2

## Notes

### v1 → v2 break

v1's orchestrator was `.claude/agents/orchestrator.md` - a sub-agent declared with `Agent(csharp-scout, csharp-implement, ...)` in frontmatter. At runtime the main session's sub-agent roster is not in scope for a running sub-agent, so the Agent tool cannot spawn siblings. Every delegation step escalated instead.

v2 replaces the sub-agent with a slash command at `.claude/commands/do-work-run.md`. The main interactive Claude Code session reads the command and drives the processing loop, spawning specialists directly. Specialists retain their isolated contexts; only the routing layer (REQ metadata, verdicts, loop counters) accumulates in main-session context. The command includes an explicit pause-and-hand-off rule at ~80% main-session context to avoid auto-compaction mid-loop.

### Upgrading an installed project from v1 to v2

```bash
./install.sh /path/to/project --force --pack csharp@v2
```

Review the diff in the target's git history. The notable changes: `.claude/agents/orchestrator.md` is deleted, `.claude/commands/do-work-run.md` is added, and `do-work-protocol.md` carries a clarifying note at the top. Any in-flight REQ in `do-work/working/` survives the upgrade unchanged.
