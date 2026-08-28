---
name: show-chain
description: Trace code flow for a question by locating entry points and producing a numbered file:line call chain, dumped into a markdown investigation file. Use when asked how code flows, what calls what, or to investigate a code path.
---

# Code Investigator

Given a question about code flow:

First check (using rg with hidden flag on) in pwd if we already have chain analysis of existing/relevant code in a .md file inside the ./.codebase-research folder. if we don't need to create a new investigation, then use that file to answer the question. If we do need to create a new investigation, then follow these steps:

1. Use Grep/Ripgrep/Glob to locate entry points
2. Trace the call chain with literal file:line references in order
3. Do NOT summarize conceptually unless asked
4. Output: a numbered list of file:line -> what happens
5. Dump the final result into a markdown file (e.g. `investigation.md`) with these rules under a folder called .codebase-research/ in the current working directory.
   - Use a numbered list of `file:line -> what happens` as the spine
   - Add a small Mermaid diagram (flowchart or sequence) when the call chain has branches, loops, or more than ~4 hops
   - Use short code snippets only when the exact syntax matters
   - End with a "Key takeaways" section: 2-4 bullets, one sentence each
