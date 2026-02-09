---
name: atuin-memory
description: Store and retrieve project context via atuin kv. Use at session start, when storing plans/specs, or when user mentions memory or atuin.
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
BRANCH=${BRANCH:-main}
```

## Before Starting Work

```bash
echo "=== $PROJECT ($BRANCH) ==="

# List all memories for this project
atuin kv list --namespace "project-metadata" | grep -F "$PROJECT-" || echo "(no memories found)"

# Retrieve specific memories (empty output means memory doesn't exist)
atuin kv get --namespace "project-metadata" "$PROJECT-$BRANCH-plan"
atuin kv get --namespace "project-metadata" "$PROJECT-$BRANCH-spec"
atuin kv get --namespace "project-metadata" "$PROJECT-$BRANCH-todo"
```

## Acting on Retrieved Memories

<memory-actions>
  <action id="validate" phase="on-retrieval">
    Check if stored plan/spec/todo still matches git state and current goals.
  </action>
  <action id="announce" phase="on-retrieval">
    Briefly summarize what you found so user can correct misunderstandings.
  </action>
  <action id="surface-issues" phase="on-retrieval">
    Raise blockers, gaps, or open questions before proceeding.
    Don't assume—ask.
  </action>
  <action id="resume" phase="on-retrieval">
    Pick up from first incomplete todo item. If none exist, start fresh.
  </action>
  <action id="persist" phase="on-completion">
    Update stored state after completing work so next session can resume cleanly.
  </action>
</memory-actions>

## Storing Memories

For multi-line content, write to a temp file first to avoid shell escaping issues:

```bash
# 1. Write content to temp file
# 2. Store from temp file
atuin kv set --namespace "project-metadata" --key "$PROJECT-$BRANCH-plan" "$(cat /tmp/plan.md)"

# 3. Verify storage succeeded
atuin kv get --namespace "project-metadata" "$PROJECT-$BRANCH-plan" | head -5
```

For short single-line values, store directly:

```bash
atuin kv set --namespace "project-metadata" --key "$PROJECT-$BRANCH-status" "in-progress"
```

## Key Naming

| Key Pattern | Purpose |
|-------------|---------|
| `{project}-{branch}-plan` | Implementation plans |
| `{project}-{branch}-spec` | Specifications/designs |
| `{project}-{branch}-todo` | Task state |
| `{project}-{branch}-session-YYYY-MM-DD` | Session summaries |

## Quick Reference

| Operation | Command |
|-----------|---------|
| List all | `atuin kv list --namespace "project-metadata"` |
| Get | `atuin kv get --namespace "project-metadata" "key"` |
| Set | `atuin kv set --namespace "project-metadata" --key "key" "value"` |
| Delete | `atuin kv delete --namespace "project-metadata" "key"` |

<constraints>
  <constraint id="no-local-files">
    Store artifacts in atuin, not local markdown files
  </constraint>
  <constraint id="temp-location">
    Use /tmp for any temporary files needed during storage
  </constraint>
  <constraint id="no-git-metadata">
    Never commit metadata files to git
  </constraint>
</constraints>
