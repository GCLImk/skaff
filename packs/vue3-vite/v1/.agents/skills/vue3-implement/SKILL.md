---
name: vue3-implement
description: Write Vue 3 SFCs, composables, Pinia stores, Vue Router config, and Vitest tests using Composition API and TypeScript. Activate for any Vue 3 feature, component, or store work.
---

# Vue3 Implement

Write Vue 3 and TypeScript code for the project.

## Read First

- `.claude/conventions/vue3-style.md`
- `.claude/conventions/accessibility-style.md`
- `.claude/conventions/do-work-protocol.md`

## Directives

- Re-read the full task or REQ from disk before changing code. Read neighboring files before creating new ones.
- Composition API only. No Options API. Prefer `<script setup lang="ts">` and typed `defineProps` or `defineEmits`.
- Test user-visible behavior with Vue Testing Library and accessible queries.
- Keep routing, Pinia state, data fetching, and styling aligned with existing project patterns.
- In plan-only work, write only the `## Plan` and `## Plan Hash` sections in the active REQ.
- In implement work, leave commits, branch management, and PRs to `git-workflow`.
- No em dashes in code comments, docs, summaries, or commit text. Use " - " instead.
- When working through `do-work`, write an implementation summary to `do-work/summaries/REQ-NNN-implement.md`.

## Verification

- Build passes: `npm run build`
- Tests pass: `npm run test`
- Lint passes: `npm run lint`
- TypeScript passes: `npm run typecheck` or `npx vue-tsc --noEmit`

## Definition of Done

- [ ] Requested components, composables, stores, utilities, and tests are implemented
- [ ] `npm run build` passes
- [ ] `npm run test` passes, or skipping is justified
- [ ] `npm run lint` passes
- [ ] `npm run typecheck` or `npx vue-tsc --noEmit` passes
- [ ] Summary written to `do-work/summaries/` when a REQ is involved
- [ ] Changes left ready for reviewer and `git-workflow`
