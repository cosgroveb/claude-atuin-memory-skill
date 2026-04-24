# Operations

## Multiline storage

For multi-line values, write to a temp file first:

```bash
atuin kv set --namespace "project-metadata" --key "$PROJECT-$FEATURE-plan" "$(cat /tmp/plan.md)"
atuin kv get --namespace "project-metadata" "$PROJECT-$FEATURE-plan" | head -5
```

For short single-line values:

```bash
atuin kv set --namespace "project-metadata" --key "$PROJECT-$FEATURE-status" "in-progress"
```

## Deleting

```bash
atuin kv delete --namespace "project-metadata" "$PROJECT-$FEATURE-plan"
atuin kv get --namespace "project-metadata" "$PROJECT-$FEATURE-plan"
```

## Command reference

| Operation | Command | Notes |
|-----------|---------|-------|
| List all | `atuin kv list --namespace "project-metadata"` | |
| Get | `atuin kv get --namespace "project-metadata" "key"` | KEY is positional |
| Set | `atuin kv set --namespace "project-metadata" --key "key" "value"` | KEY uses `--key`, VALUE is positional |
| Delete | `atuin kv delete --namespace "project-metadata" "key"` | KEY is positional |

Constraints:

- Store artifacts in atuin, not local markdown files.
- Use `/tmp` for temporary files needed during storage.
- Never commit metadata files to git.
