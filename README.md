# claude-atuin-memory-skill

A Claude Code skill that persists project context across machines using [atuin](https://atuin.sh)'s key-value store with sync.

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

- Store and retrieve plans, specs, todos, and session summaries
- Resume work from where you left off across machines
- Validate stored context against current git state
- Surface blockers or stale assumptions before proceeding

## License

MIT
