# SvelteKit Style

- Use Svelte 5 runes only. No legacy `$:` reactive statements or `export let`.
- Use `<script lang="ts">`, `$props()`, `$state`, `$derived`, and `$effect`.
- Prefer load functions and form actions over client fetch when the flow fits SvelteKit.
- Keep browser APIs out of server files and server-only modules.
- Test user-visible behavior with Vitest and Svelte Testing Library.
- Read `.claude/conventions/svelte-style.md` for the full guide.
