---
name: atuin-memory
description: Check, store, and retrieve project memories from atuin kv. Use when starting work on a project, recalling previous context, storing plans or specs, or when the user mentions memory, atuin, or project context.
allowed-tools:
  - Bash(atuin *)
  - Bash(git rev-parse *)
  - Bash(git branch *)
  - Bash(basename *)
  - Read
---

# Project Memory with Atuin

Store and retrieve project context using atuin kv to persist across sessions.

## Before Starting Work

```bash
PROJECT=$(basename "$(git rev-parse --show-toplevel 2>/dev/null || pwd)")
BRANCH=$(git branch --show-current 2>/dev/null)
BRANCH=${BRANCH:-main}

echo "=== $PROJECT ($BRANCH) ==="

# List all memories for this project
atuin kv list --namespace "project-metadata" | grep -F "$PROJECT-" || echo "(none)"

# Retrieve specific memories
atuin kv get --namespace "project-metadata" "$PROJECT-$BRANCH-plan"
atuin kv get --namespace "project-metadata" "$PROJECT-$BRANCH-spec"
atuin kv get --namespace "project-metadata" "$PROJECT-$BRANCH-todo"
```

## Acting on Retrieved Memories

<memory-actions>
  <action id="validate" phase="start">
    Check if stored plan/spec/todo still matches git state and current goals.
    Flag staleness (>7 days) or drift from implementation.
  </action>
  <action id="announce" phase="start">
    Briefly summarize what you found so user can correct misunderstandings.
  </action>
  <action id="surface-issues" phase="start">
    Raise blockers, gaps, or open questions before proceeding.
    Don't assume—ask.
  </action>
  <action id="resume" phase="start">
    Pick up from first incomplete todo item. If none exist, start fresh.
  </action>
  <action id="persist" phase="end">
    Update stored state after completing work so next session can resume cleanly.
  </action>
</memory-actions>

## Storing Memories

```bash
# Store a plan
atuin kv set -n "project-metadata" -k "$PROJECT-$BRANCH-plan" "content"

# Store from temp file, verify content, then delete
content="$(cat spec.md)" && \
  atuin kv set -n "project-metadata" -k "$PROJECT-$BRANCH-spec" "$content" && \
  [[ "$(atuin kv get -n "project-metadata" "$PROJECT-$BRANCH-spec")" == "$content" ]] && rm spec.md
```

## Key Naming

| Key Pattern | Purpose |
|-------------|---------|
| `{project}-{branch}-plan` | Implementation plans |
| `{project}-{branch}-spec` | Specifications/designs |
| `{project}-{branch}-todo` | Task state |
| `{project}-{branch}-session-YYYY-MM-DD` | Session summaries (last wins) |

Branch slashes preserved (e.g., `feature/foo`). Same-day sessions overwrite.

<constraints>
  <constraint id="no-local-files">
    Store artifacts in atuin, not local markdown files
  </constraint>
  <constraint id="cleanup">
    Delete temp files immediately after storing contents
  </constraint>
  <constraint id="no-git-metadata">
    Never commit metadata files to git
  </constraint>
</constraints>
