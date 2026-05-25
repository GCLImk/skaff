# Skills

Markdown files Gemini loads as additional guidance when you activate them
in the CLI with `/skill <name>`.

## File layout

Each skill is one `.md` file. Filename is the skill name (without the
extension). Optional YAML-style frontmatter:

```markdown
---
name: pytest-style
description: Test patterns: fixtures, parametrize, asserts.
---

# pytest style

When writing tests:
- Prefer `assert` over `unittest.TestCase` methods.
- Use fixtures for setup; never inline.
- Parametrize edge cases instead of duplicating test bodies.
```

Skills are searched in two places, project first:

1. `<repo>/skills/<name>.md`
2. `~/.geminicode/skills/<name>.md`

## In the CLI

| Command | Effect |
|---------|--------|
| `/skills` | List available + show which are active |
| `/skill <name>` | Activate. Full body injected on the next prompt; a short reminder line on every prompt after that until deactivated |
| `/skill-off <name>` | Deactivate one |
| `/skill-clear` | Deactivate all |

## When to use

Skills shine for:
- **House style** (naming, file layout, error-handling patterns)
- **Domain primers** (this codebase's models, what each module does)
- **Recipe books** (how we usually wire X to Y)
- **Don'ts** ("never do X here, we tried it, it didn't work")

For one-off task instructions, just put them in your prompt. Skills are
worth the file when you'd otherwise paste the same thing every session.
