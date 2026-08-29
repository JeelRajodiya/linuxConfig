Just print the tell workflow. nothing else! 

# Boris Tane Workflow — Quick Reference

## The Pipeline

```
Research → Plan → Annotate (1-6x) → Todo → Implement → Feedback
```

## Slash Commands

| Phase | Command | What it does |
|-------|---------|-------------|
| 1. Research | `/research <folder/system>` | Deep-reads code, writes `research.md` |
| 2. Plan | `/plan <feature description>` | Writes `plan.md` with approach + code snippets |
| 3. Annotate | `/annotate` | Claude reads your notes in `plan.md` and updates it |
| 4. Todo | `/todo` | Adds granular task checklist to `plan.md` |
| 5. Implement | `/implement` | Executes the full plan, marks tasks done |
| 6. Revert | `/revert <new narrowed scope>` | After `git checkout .`, rescopes work |

## How to Use

1. **`/research src/notifications`** → Review `research.md` → correct anything wrong
2. **`/plan add cursor-based pagination to the list endpoint`** → Review `plan.md`
3. **Open `plan.md` in your editor, add inline notes** like:
   - "use drizzle:generate for migrations, not raw SQL"
   - "no — this should be a PATCH, not a PUT"
   - "remove this section entirely"
4. **`/annotate`** → Review again → repeat until satisfied
5. **`/todo`** → Verify the task breakdown looks right
6. **`/implement`** → Monitor, give terse corrections as needed

## Tips

- **Single long session** — do research, plan, and implement in one conversation
- **Reference existing code** — "this should look exactly like the users table"
- **Terse feedback during implementation** — "wider", "still cropped", "2px gap"
- **Revert don't patch** — if it goes wrong, `git checkout .` + `/revert <narrowed scope>`
- **Share reference implementations** — paste good OSS code alongside plan requests
