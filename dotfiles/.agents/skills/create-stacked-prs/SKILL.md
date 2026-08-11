---
name: create-stacked-prs
description: Plan, create, validate, and publish a chain of small dependent GitHub pull requests with the GitHub CLI `gh stack` extension. Use when Codex needs to split one change into stacked PRs, turn an existing branch or working tree into a reviewable stack, set each PR's base branch, or draft and apply stack-aware PR titles and descriptions.
---

# Create Stacked PRs

Create a bottom-up chain in which every PR targets the branch immediately below it and contains one focused, reviewable layer.

## Gather Direction

Read the repository's `AGENTS.md` and relevant component instructions first. Treat the user's requested split, ordering, titles, and description format as authoritative.

If the split is not fully specified, inspect the diff and propose a stack before changing branches or creating remote PRs. For every proposed layer, state:

- its purpose and dependency on the layer below;
- the files or hunks it owns;
- its branch, base branch, and PR title;
- the focused validation that should pass at that layer.

Do not publish an inferred stack until the user approves it. A direct request with an explicit stack plan counts as approval to implement and publish that plan.

## Inspect Safely

Run read-only checks before changing Git state:

```bash
git status --short --branch
git branch --show-current
git log --oneline --decorate -20
git diff --stat
git diff --cached --stat
git remote -v
git --version
gh --version
gh auth status
gh stack --help
```

Require Git 2.20 or later and GitHub CLI 2.90.0 or later. If `gh stack` is unavailable, ask before installing the public-preview extension with `gh extension install github/gh-stack`. Re-check `gh stack --help` because preview commands and flags can change.

Preserve unrelated changes and existing commits. Never use destructive resets, broad checkout restoration, or an unreviewed `git add -A`. Never add Codex as a commit coauthor.

## Design the Stack

Order layers from foundational to dependent. Prefer layers that are independently understandable and, where practical, buildable and testable. Keep implementation and its focused coverage together unless the user requests another split.

Before implementation, present the intended chain in this shape:

```text
main <- branch-1 <- branch-2 <- branch-3
```

Each PR must target the branch immediately to its left. Confirm that a layer's three-dot diff contains only that layer:

```bash
git diff --stat BASE...BRANCH
git log --oneline BASE..BRANCH
```

## Build the Stack

Initialize the first layer from the intended trunk:

```bash
gh stack init
```

Stage only the paths or hunks belonging to that layer, review the staged diff, and commit. Add each next branch from the current top of the stack:

```bash
gh stack add BRANCH-NAME
```

Then stage, review, and commit that layer. Avoid `gh stack add -Am` when the working tree contains unrelated or not-yet-partitioned changes because it stages everything.

After each layer:

1. Inspect the layer's base-relative diff and commit list.
2. Run the smallest meaningful validation for that layer.
3. Verify that no later-layer code leaked downward.
4. Record any validation limitation honestly.

Use `gh stack view` to verify branch order before publishing. If restructuring would rewrite already-published commits or require a force push, explain the exact branches affected and obtain approval first.

## Write PR Metadata

Follow explicit user and repository conventions. Otherwise:

- use a concise title that names the layer's outcome;
- keep the body to two or three short sentences or points;
- lead with **why** the layer exists, then state the focused change;
- mention the immediately preceding PR with `Depends on #NUMBER` when useful;
- use **bold title case** text instead of Markdown `#` headings;
- omit file-by-file changelogs, test instructions, exhaustive bullet lists, and AI attribution.

Keep each body about its own three-dot diff, not the aggregate stack. When the user supplies a reason, query, incorrect output, expected output, or fix narrative, preserve that order and keep each item short.

## Publish and Verify

Review `gh stack submit --help`, then publish only after the local stack and metadata are ready:

```bash
gh stack submit
```

If the extension does not support the required metadata directly, update each PR with `gh pr edit` after submission. Do not rely on branch-name inference when editing; resolve and verify each PR number first.

Finish by checking:

```bash
gh stack view
gh pr view PR-NUMBER --json number,title,body,baseRefName,headRefName,url
```

Verify every base/head pair, title, body, and URL. Report the stack bottom-up with PR links, validation results, and any remaining caveat. Do not claim completion if submission or metadata verification was not observed.
