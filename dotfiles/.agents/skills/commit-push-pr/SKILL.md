---
name: commit-push-pr
description: Commit the requested changes, push a branch, and open a GitHub pull request. Use when the user explicitly asks to commit, push, and create a PR as one workflow.
---

# Commit, Push, and Open a PR

Inspect the repository status and diff before making changes. Preserve unrelated user changes and stage only files that belong to the requested work.

If the current branch is the default branch, create a descriptive feature branch. Do not rewrite history or force-push.

Before committing, inspect the staged diff for credential-like values. Stop and report the affected path if one is found; do not commit it.

Create one focused commit using the repository's commit conventions. Push the branch to `origin` with an upstream tracking ref, then create a GitHub pull request with `gh pr create`.

Use the repository's PR conventions for the title and body. Determine the correct base branch from repository metadata when it is not already clear. Report the PR URL and any commands that could not be completed because of authentication, remote configuration, or a GitHub error.
