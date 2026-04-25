# Tool usages

- instead of `grep` prefer using `rg` (ripgrep) for searching through codebases, as it is faster and more efficient.

# Git Conventions

## Commits

- Never include claude as coauthor in the commit message

## Pull Requests

- Keep PR descriptions short — a 2-3 sentence, points or paragraph summary of what changed and why. keep it effective and bold important words in the description.
- In the pr decription, if you want to create a title, don't use # for titile, instead just use a bold text in title case.
- Do NOT include:
  - Detailed file-by-file changelogs
  - Test instructions
  - Long bullet point lists of every change
  - AI attribution or "Generated with Claude Code" footers

# General

## Response Style section

When the user asks a simple conceptual or 'how do I' question, answer directly first without launching codebase exploration, Agent tools, or Grep/Read sweeps. Only investigate the codebase if the question is specifically about this project's code.
Add under

## Code Investigation section

When asked to trace call chains, dependencies, or code flow, respond with literal file:line references in order. Do not substitute a high-level conceptual summary unless explicitly asked.

## Accuracy section

Never fabricate type names, terms, API names, or placeholders. If a name is unknown or invented, explicitly flag it as a placeholder.
