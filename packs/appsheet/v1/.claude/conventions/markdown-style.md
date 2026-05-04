# Markdown Conventions

All agents read this file before writing or editing markdown (`.md`) files.

## Heading Hierarchy

- One `#` (H1) per file - the document title.
- `##` for top-level sections.
- `###` for subsections.
- No heading skips. Do not jump from `##` to `####`.
- Do not re-use the H1 elsewhere in the document.

## Code Fences

- Always fence code blocks with triple backticks.
- Always tag the language: ` ```javascript `, ` ```bash `, ` ```json `, ` ```text `.
- Close every fence. Unclosed fences break rendering.
- Indented (four-space) code blocks are not permitted.

## Lists

- Hyphen `-` for unordered lists. No `*` or `+`.
- Numeric `1.` for ordered lists.
- Indent nested list items with two spaces.
- Blank line before and after a list block.

## Tables

- Use pipe tables for structured comparisons.
- Header row required. Alignment row required.
- Do not wrap long cells - prefer a bullet list below the table for detail.

Example:

```text
| Column | Meaning     |
| ------ | ----------- |
| id     | unique key  |
```

## Admonitions

Use blockquote admonitions for callouts:

- `> **Note:**` - non-critical clarification
- `> **Warning:**` - risk or footgun
- `> **Tip:**` - optional guidance

No custom admonition syntax, no HTML `<div>` blocks.

## Links

- Inline links: `[text](url)`.
- Reference-style links permitted for repeated URLs in long documents.
- Relative links for intra-repo references: `[appsheet style](./appsheet-style.md)`.

## Style

- No em dashes. Use " - " instead.
- No trailing whitespace.
- End every file with a single trailing newline.
- Line length is not enforced - prefer semantic line breaks (one sentence per line) in long prose.
