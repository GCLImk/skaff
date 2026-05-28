# Next.js Style

- App Router and server-first React components are the default. Keep server-only code on the server.
- Validate external input, keep types strict, and declare env vars in `lib/env.ts`.
- Use `import "server-only"` for server-only modules and do not leak secrets into client bundles.
- No em dashes in code comments or docs. Use " - " instead.
- Read `.claude/conventions/nextjs-style.md` for the complete style guide.
