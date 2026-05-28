# Copilot Instructions

This project uses the skaff scaffold. The scaffold installs shared workflow files so GitHub Copilot Chat, Copilot coding agent, and other tools follow the same operating rules.

## Core Behavior

### 1. Think Before Coding
- State assumptions before implementation.
- Surface ambiguity and ask instead of guessing.
- Present meaningful tradeoffs when more than one path is viable.

### 2. Simplicity First
- Prefer the smallest correct change.
- Do not add speculative features, abstractions, or configurability.
- Reduce complexity when a simpler design solves the problem.

### 3. Surgical Changes
- Touch only the files required for the request.
- Match the repository's established style and patterns.
- Clean up only the unused code created by your own change.
- Do not refactor unrelated areas unless asked.

### 4. Goal-Driven Execution
Before coding, make a short plan with explicit verification criteria. For multi-step work, think in the form `step -> verify`. Finish only after the checks pass.

### 5. House Rules
- No em dashes anywhere. Use " - " instead.
- Use AskUserQuestion for blocking ambiguity.
- Write summaries to `do-work/summaries/` when work completes.
- Use Conventional Commits for commit messages: `type(scope): description`.

## Project Layout

- `do-work/` holds the queue, plans, and summaries.
- `.claude/agents/` contains specialist agents.
- `.claude/conventions/` contains shared rules such as style, commit, coverage, ratchet, and do-work protocols.

Before coding, read the relevant file from `.claude/conventions/`. Load the language style file, `markdown-style.md`, `commit-style.md`, or workflow protocols as needed.

## Workflow Summary

Use the standard flow: capture, scout, plan, implement, review, ratchet, git. The goal is to understand the request, make the smallest correct change, verify it, and leave a short summary.

## Custom Agents

Custom agents defined in `.claude/agents/*.md` follow the same format as Claude Code agents and are compatible with Copilot's agent system. Use the `agent` tool to spawn them by name.
