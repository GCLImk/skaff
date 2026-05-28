---
applyTo: "**/*.svelte,**/*.ts,**/*.js"
---

# SvelteKit Instructions

- Use Svelte 5 runes only. No legacy `$:` or `export let`.
- Use `<script lang="ts">`, `$props()`, `$state`, `$derived`, and `$effect`.
- Keep browser APIs out of server files such as `+page.server.ts`, `+layout.server.ts`, `+server.ts`, and `src/lib/server/**`.
- Prefer load functions and form actions over client fetch when the flow fits SvelteKit's data model.
- Read `.claude/conventions/svelte-style.md` for the full guide.
