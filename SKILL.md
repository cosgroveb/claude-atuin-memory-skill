---
name: atuin-memory
description: Check, store, and retrieve project memories from atuin kv. Use when starting work on a project, recalling previous context, storing plans or specs, or when the user mentions memory, atuin, or project context.
allowed-tools:
  - Bash(atuin *)
  - Bash(git rev-parse *)
  - Bash(git branch *)
  - Bash(basename *)
  - Bash(pwd)
  - Bash(cat *)
  - Bash(echo *)
  - Bash(grep *)
  - Bash(head *)
  - Read
---

# Project Memory with Atuin

Store and retrieve project context using atuin kv to persist across sessions.

## Project Detection

Reuse these variables in all commands:

```bash
PROJECT=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)" 2>/dev/null || basename "$PWD")
BRANCH=$(git branch --show-current 2>/dev/null)
FEATURE=${FEATURE:-}
```

Feature selection rules:
- Prefer a user-named feature slug.
- Otherwise use the active roadmap item when it is clear.
- Do not infer `FEATURE` from git branch by default.
- If the feature is unclear, ask the user.
- `main` and `master` are never valid `FEATURE` values.
- A named branch alone is not enough. If the branch name is the only candidate, ask the user whether it maps to the memory name.
- If the derived project or feature slug looks like a temp dir, hidden scratch dir, or placeholder such as `tmp.*`, random dot-dir names, or `no-branch`, ask the user how the memory should be remembered before storing it.
- Legacy `{project}-{branch}-...` memories may still exist. Read them when relevant, but write new entries with `{feature}`.

## Before Starting Work

```bash
echo "=== $PROJECT (${FEATURE:-unset}) ==="

# Discover what memories exist for this project
atuin kv list --namespace "project-metadata" | grep -F "$PROJECT-" || echo "(no memories found)"
```

Then retrieve relevant memories:

```bash
# Empty output means memory doesn't exist
atuin kv get --namespace "project-metadata" "$PROJECT-roadmap"
atuin kv get --namespace "project-metadata" "$PROJECT-$FEATURE-plan"
atuin kv get --namespace "project-metadata" "$PROJECT-$FEATURE-spec"
atuin kv get --namespace "project-metadata" "$PROJECT-$FEATURE-todo"
```

Retrieve reusable technical references when they would help:

```bash
atuin kv list --namespace "technical-knowledge"
atuin kv get --namespace "technical-knowledge" "go-mistakes"
```

## Acting on Retrieved Memories

<memory-actions>
  <on-retrieval>
    - Check if stored roadmap/plan/spec/todo still matches git state and current goals
    - Briefly summarize what you found so user can correct misunderstandings
    - Raise blockers, gaps, or open questions before proceeding—don't assume, ask
    - Use `technical-knowledge` as cross-project priming memory when language, framework, or documentation context would help
    - Pick up from first incomplete todo item; if none exist, start fresh
  </on-retrieval>
  <on-completion>
    - Update stored state after completing work so next session can resume cleanly
  </on-completion>
</memory-actions>

## Storing Memories

For multi-line content, write to a temp file first to avoid shell escaping issues:

```bash
# 1. Write content to temp file
# 2. Store from temp file
atuin kv set --namespace "project-metadata" --key "$PROJECT-$FEATURE-plan" "$(cat /tmp/plan.md)"

# 3. Verify storage succeeded
atuin kv get --namespace "project-metadata" "$PROJECT-$FEATURE-plan" | head -5
```

For short single-line values, store directly:

```bash
atuin kv set --namespace "project-metadata" --key "$PROJECT-$FEATURE-status" "in-progress"
```

## Key Naming

| Key Pattern | Purpose |
|-------------|---------|
| `{project}-roadmap` | Canonical project roadmap |
| `{project}-{feature}-plan` | Implementation plans |
| `{project}-{feature}-spec` | Specifications/designs |
| `{project}-{feature}-todo` | Task state |
| `{project}-{feature}-session-$(date +%Y-%m-%d)` | Session summaries (use current date) |

Feature memories should begin with:
- `Status: planned|in-progress|done|abandoned`
- `Shipped in: <sha|tag>` when done
- `Follow-ups:` when relevant

## `technical-knowledge`

Use `technical-knowledge` for cross-project priming memory:

- Reusable technical references
- Curated summaries of docs and books
- Grounded notes that improve later in-context behavior

This namespace is read-mostly. It is not a task tracker.

## Deleting Memories

```bash
# Delete a specific key
atuin kv delete --namespace "project-metadata" "$PROJECT-$FEATURE-plan"

# Verify deletion (should return empty)
atuin kv get --namespace "project-metadata" "$PROJECT-$FEATURE-plan"
```

## Quick Reference

**Argument syntax is inconsistent across subcommands — pay attention to positional vs flag arguments:**

| Operation | Command | Notes |
|-----------|---------|-------|
| List all | `atuin kv list --namespace "project-metadata"` | |
| Get | `atuin kv get --namespace "project-metadata" "key"` | KEY is **positional** |
| Set | `atuin kv set --namespace "project-metadata" --key "key" "value"` | KEY is **`--key` flag**, VALUE is **positional** |
| Delete | `atuin kv delete --namespace "project-metadata" "key"` | KEY is **positional** (not `--key`) |

<constraints>
  - Store artifacts in atuin, not local markdown files
  - Use /tmp for any temporary files needed during storage
  - Never commit metadata files to git
</constraints>
