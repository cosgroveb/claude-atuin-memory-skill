---
name: atuin-memory
description: Check, store, and retrieve atuin memory for project roadmap, feature work, and optional cross-project priming context.
---

Use this skill for atuin-backed project memory. Keep task state in `project-metadata`. Use `technical-knowledge` as read-mostly cross-project priming memory when reusable technical context would help.

- Start with [project-detection.md](project-detection.md).
- Use [project-metadata.md](project-metadata.md) for roadmap, feature plans, specs, todos, and session notes.
- Use [technical-knowledge.md](technical-knowledge.md) for cross-project priming memory and retrieval cues.
- Use [operations.md](operations.md) for get/set/delete syntax and multiline storage.

- Prefer a user-named feature slug.
- Otherwise use the active roadmap item when it is clear.
- Do not infer the feature slug from git branch by default.
- If the feature is unclear, ask the user.
- `main` and `master` are never valid feature slugs.
- A named branch alone is not enough. If the branch name is the only candidate, ask whether it maps to the memory name.
- If the derived project or feature slug looks like a temp dir, hidden scratch dir, or placeholder such as `tmp.*`, random dot-dir names, or `no-branch`, ask the user how the memory should be remembered before storing it.
- Legacy `{project}-{branch}-...` memories may still exist. Read them when relevant, but write new entries with `{feature}`.
