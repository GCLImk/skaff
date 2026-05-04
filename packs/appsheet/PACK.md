# appsheet pack

Targets Google AppSheet governance and workflow apps built on Google Sheets, backed by Google Apps Script (GAS) for integrations. Ships specialist agents (`appsheet-scout`, `appsheet-implement`, `appsheet-doc-writer`) plus the shared reviewer, ratchet, and git-workflow agents. Orchestration lives in a main-session slash command (`/do-work-run`) from v2 onward.

## The three-surface model

This pack assumes a project with three artefact surfaces, each with a different source-of-truth model:

| Surface              | In-repo source of truth            | Production application                  |
| -------------------- | ---------------------------------- | --------------------------------------- |
| Google Apps Script   | `apps-script/<project>/*.gs,.js,.ts` | Human runs `clasp push` at release time |
| Google Sheets schema | `docs/sheets/<sheet>.md` spec      | Human applies changes in Sheet UI       |
| AppSheet config      | `docs/appsheet/<area>.md` spec     | Human applies changes in AppSheet editor|

Agents produce specs. Humans apply them. The spec is the handover artefact.

## Versions

| Version | Status     | Target tool baseline                                | Changelog                                                               |
| ------- | ---------- | --------------------------------------------------- | ----------------------------------------------------------------------- |
| v2      | maintained | Node 20+, eslint, prettier, clasp, optional GasT    | Orchestrator moved from sub-agent to `/do-work-run` slash command       |
| v1      | frozen     | Node 20+, eslint, prettier, clasp, optional GasT    | Initial cut derived from iswg-os. **Topology bug:** orchestrator was defined as a sub-agent but sub-agents cannot spawn sibling sub-agents via the Agent tool. Frozen; do not install on new projects. |

**Latest:** v2

## Notes

### v1 → v2 break

See the equivalent note in `packs/csharp/PACK.md`. The fix is identical: orchestrator moves from sub-agent to slash command. Specialists unchanged.

### Other open items (unchanged from v1)

- No CI workflow template ships yet. The ratchet-gate CI gate is premature while the three-surface model is still stabilising. Expect a `ci/ratchet-gate.yml.template` in a later version once a GAS test harness is chosen.
- `ratchet.conf.template` starts `test_coverage` as N/A. Remove from `na_dimensions` once a GAS test harness lands.
- `doc_quality` weight is raised to 1.5 because the spec docs are the operator handover artefact.

### Divergence from shared

None declared. Protocol-level conventions track the csharp pack aside from agent-name substitutions and the note about orchestrator being the main session.

### Upgrading an installed project from v1 to v2

```bash
./install.sh /path/to/project --force --pack appsheet@v2
```

Notable diff: `.claude/agents/orchestrator.md` deleted, `.claude/commands/do-work-run.md` added, `do-work-protocol.md` gets the clarifying note. In-flight REQs under `do-work/working/` survive unchanged.
