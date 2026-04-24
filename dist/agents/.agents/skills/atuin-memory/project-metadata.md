# Project Metadata

Use `project-metadata` for project work-state memory.

## Read before work

```bash
echo "=== $PROJECT (${FEATURE:-unset}) ==="

atuin kv list --namespace "project-metadata" | grep -F "$PROJECT-" || echo "(no memories found)"
atuin kv get --namespace "project-metadata" "$PROJECT-roadmap"
atuin kv get --namespace "project-metadata" "$PROJECT-$FEATURE-plan"
atuin kv get --namespace "project-metadata" "$PROJECT-$FEATURE-spec"
atuin kv get --namespace "project-metadata" "$PROJECT-$FEATURE-todo"
```

Check whether the stored roadmap, plan, spec, and todo still match the current goal and git state. Summarize what you found. Raise gaps or stale assumptions before proceeding.

## Key naming

| Key Pattern | Purpose |
|-------------|---------|
| `{project}-roadmap` | Canonical project roadmap |
| `{project}-{feature}-plan` | Implementation plans |
| `{project}-{feature}-spec` | Specifications and designs |
| `{project}-{feature}-todo` | Feature task state |
| `{project}-{feature}-session-YYYY-MM-DD` | Session summaries |

Feature memories should begin with:

- `Status: planned|in-progress|done|abandoned`
- `Shipped in: <sha|tag>` when done
- `Follow-ups:` when relevant
