---
name: commit-unstaged
description: Group related unstaged Git changes into atomic commits named with Conventional Commits. Use when asked to commit unstaged work, split working-tree changes into focused commits, or make atomic commits. Does not push unless explicitly requested.
---

# Commit Unstaged Changes

Inspect `git status` and the complete unstaged diff, including untracked files, before staging anything. Commit only files and hunks that are clearly part of the requested code or documentation change. Leave generated logs, research notes, plan files, scratch Markdown, and other incidental or ambiguous files untracked/unstaged unless the user explicitly asks to include them. Preserve unrelated changes, and do not amend, reset, stash, rewrite history, or push unless the user explicitly requests it.

Group files and hunks by the smallest independently useful change. Use `git add -p` when a file contains changes for more than one commit. If a safe atomic grouping is ambiguous, ask the user rather than guessing.

Before each commit, inspect its staged diff and check it for credential-like values. Stop and report the affected path if one is found; do not commit it.

Create each commit with a Conventional Commits subject:

```text
<type>(optional-scope): concise imperative summary
```

Use the change to select the type (`feat`, `fix`, `docs`, `refactor`, `test`, `build`, `ci`, `chore`, and so on). Follow stricter repository conventions when present. Keep commits focused and avoid empty commits.

After committing, show the created commit hashes and any remaining unstaged or untracked files. Push only when the user explicitly asks for it.
