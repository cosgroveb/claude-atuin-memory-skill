# claude-atuin-memory-skill

A Claude Code skill that persists project context across machines using [atuin](https://atuin.sh)'s key-value store with sync. It keeps project state in `project-metadata` and supports optional cross-project priming memory in `technical-knowledge`, without polluting your working directory with random markdown files.

## Installation

### Manual

```bash
git clone https://github.com/cosgroveb/claude-atuin-memory-skill.git ~/.claude/skills/atuin-memory
```

### Via chezmoi

Add to your `.chezmoiexternal.toml`:

```toml
[".claude/skills/atuin-memory"]
    type = "git-repo"
    url = "https://github.com/cosgroveb/claude-atuin-memory-skill.git"
    refreshPeriod = "168h"
```

Then run `chezmoi apply`.

## Prerequisites

- [atuin](https://atuin.sh) with sync enabled
- Git

## What It Does

This skill activates when you start work on a project or mention "memory", "atuin", or "project context" and helps Claude:

- Store and retrieve project roadmaps, plans, specs, todos, and session summaries
- Resume work from where you left off across machines
- Validate stored context against current git state
- Surface blockers or stale assumptions before proceeding

## Namespaces

### `project-metadata`

Project work-state memory:

- `{project}-roadmap`
- `{project}-{feature}-plan`
- `{project}-{feature}-spec`
- `{project}-{feature}-todo`
- `{project}-{feature}-session-YYYY-MM-DD`

The skill treats `main` and `master` as invalid feature names. If the feature is unclear, it should ask instead of inventing one from the current branch.

### `technical-knowledge`

Optional cross-project priming memory:

- Reusable technical references
- Curated summaries of documentation and books
- Grounded notes that improve later in-context behavior across projects

This is not task-state memory. It is read-mostly reference memory. Practically, this supports knowledge priming and lightweight retrieval-augmented prompting, not fine-tuning.

## License

MIT
