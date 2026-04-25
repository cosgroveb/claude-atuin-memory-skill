# Project Detection

Reuse these variables in all commands:

```bash
PROJECT=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)" 2>/dev/null || basename "$PWD")
FEATURE=${FEATURE:-}
```

Feature selection:

- Prefer a user-named feature slug.
- Otherwise use the active roadmap item when it is clear.
- Do not infer `FEATURE` from git branch by default.
- If the feature is unclear, ask the user.
- `main` and `master` are never valid `FEATURE` values.
- A named branch alone is not enough. If the branch name is the only candidate, ask the user whether it maps to the memory name.
- If the derived project or feature slug looks like a temp dir, hidden scratch dir, or placeholder such as `tmp.*`, random dot-dir names, or `no-branch`, ask the user how the memory should be remembered before storing it.
