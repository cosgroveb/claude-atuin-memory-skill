# claude-atuin-memory-skill

A Claude plugin and skill bundle for atuin-backed memory. It keeps roadmaps, plans, specs, todos, and session notes in `project-metadata`. It can also read shared reference notes from `technical-knowledge`. Nothing gets written into your repo just to keep state between sessions.

This repo packages the same source in two generated bundles:

- Claude plugin bundle
- `.agents` skill bundle

The source of truth is [`skills/atuin-memory`](skills/atuin-memory).

## Installation

### Claude plugin

```bash
/plugin marketplace add https://github.com/cosgroveb/claude-atuin-memory-skill.git
/plugin install atuin-memory@claude-atuin-memory-skill
```

Or clone and install locally:

```bash
git clone https://github.com/cosgroveb/claude-atuin-memory-skill.git
cd claude-atuin-memory-skill
make install
```

## Prerequisites

- [atuin](https://atuin.sh) with sync enabled
- Git

## Workflow

Use this skill when you start work on a project or mention "memory", "atuin", or saved project notes.

The workflow is simple:

1. Read the project's saved roadmap, plan, spec, todo list, and recent session notes.
2. Compare those notes to the current repo and current goal.
3. Call out stale assumptions, missing details, or blockers before doing work.
4. Write updated project notes back to atuin when the task is done.

This is session continuity, not a local note-taking system.

## Namespaces

### `project-metadata`

`project-metadata` stores the work for one project:

- `{project}-roadmap`
- `{project}-{feature}-plan`
- `{project}-{feature}-spec`
- `{project}-{feature}-todo`
- `{project}-{feature}-session-YYYY-MM-DD`

`main` and `master` are never valid feature names. If the feature name is unclear, the agent should ask instead of guessing from the current branch.

### `technical-knowledge`

`technical-knowledge` is for shared reference material that applies across projects:

- Reusable technical references
- Curated summaries of documentation and books
- Notes that help the agent start with the right commands, conventions, and failure modes

Do not use this namespace to track task state. Use it for stable reference material you want available in later sessions on other machines.

## Build

```bash
make dist
```

Run this only for a local check. CI owns `dist/`.

Build output:

- `dist/claude-plugin/.claude/skills/atuin-memory`
- `dist/claude-plugin/.claude-plugin/{plugin.json,marketplace.json}`
- `dist/agents/.agents/skills/atuin-memory`

## Editing

Edit these source files:

- `skills/atuin-memory/**`
- `.claude-plugin/**`

GitHub Actions regenerates and commits `dist/` on pushes to `main`.

## License

MIT
