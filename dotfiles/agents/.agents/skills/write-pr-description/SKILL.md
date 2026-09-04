---
name: write-pr-description
description: Draft or revise GitHub pull request titles and descriptions. Use when asked to write, improve, or update a PR body, including during PR creation; do not use for commit messages or code review.
---

# Write a PR Description

Ground the description in the actual change and the user's stated motivation. Preserve more specific user or repository conventions when they are provided.

Keep the description concise and build a clear narrative:

1. Use two or three sentences to explain **why** the change was needed.
2. Use two or three sentences to explain **what** changed and how it addresses the issue.
3. Explain the issue with concrete examples at the level of detail needed to prove the problem and the fix. Prefer one base example that develops from the old behavior into the new behavior instead of several unrelated examples.
4. if the existing PR description has some images/charts keep them there. don't remove them as you write the new description.

## Build an Evidence Chain

Before drafting a detailed example, trace the behavior through the changed code. Do not infer intermediate plans, serialized values, argument lists, or runtime output from the final result alone.

When a change crosses layers or alters a representation, show the relevant end-to-end chain. Adapt the stage names to the system, but normally include:

1. the smallest realistic user input, query, request, or API call that exposes the issue;
2. the logical plan, AST, request object, or other first internal representation;
3. each serialization or interface boundary, including exactly where values are split, reordered, flattened, wrapped, or otherwise lose information;
4. the receiving side's reconstruction, normalization, fallback, or fixup steps;
5. the final arguments, state, or output produced by the old path;
6. the same boundaries after the change, showing where the new representation removes or relocates the old work.

Use **bold, title-case phase labels** when a detailed example moves between clearly distinct states or stages. Prefer paired labels that make the contrast obvious, such as **Before: Split Representation** and **After: Ordered Representation**, or labels tailored to the system such as **Producer**, **Serialized Boundary**, and **Consumer**. Place each label immediately before the explanation and snapshots for that phase. Do not add headings to every short paragraph or simple example.

At each important boundary, show a small snapshot such as an argument list, plan fragment, serialized object, or before/after value. Make added placeholders, appended values, removed values, reordered elements, defaults, and redundant transformations visible. Explain both **what** changes and **why** that stage performs it.

Name the exact methods or symbols responsible for important transitions. When updating an existing PR, link those names to the relevant changed lines in the PR's Files view. If a stable PR line link is unavailable, use an immutable head-commit line link. When no PR exists yet, use literal `file:line` references and replace them with links after the PR is created.

Keep examples source-grounded. If a plan fragment or value snapshot is simplified rather than copied from observed output or a test, label it as schematic. Use additional examples only when they demonstrate a genuinely different behavior that the base example cannot cover.

For a simple one-layer change, do not manufacture a long pipeline. Use one or two sentences followed by a small code block when exact input, output, or syntax is useful.

Use short paragraphs. Highlight important terms with **bold**, use code blocks for examples, and use bullets only for a compact list of changes or issues.

If the body needs a heading, use **bold title-case text**, not a Markdown `#` heading.

Do not include:

- detailed file-by-file changelogs;
- test instructions;
- long or exhaustive bullet lists;
- AI attribution footers.
