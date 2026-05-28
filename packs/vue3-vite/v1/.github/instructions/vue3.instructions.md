---
applyTo: "**/*.vue,**/*.ts,**/*.js"
---

# Vue 3 Instructions

- Composition API only. No Options API.
- Use `<script setup lang="ts">` for Single File Components.
- Type props and emits. Avoid `any` when a real type or `unknown` would do.
- Prefer accessible Vue Testing Library queries over test IDs.
- Keep components, composables, stores, and styling aligned with the project's existing Vue patterns.
- Read `.claude/conventions/vue3-style.md` for the full guide.
