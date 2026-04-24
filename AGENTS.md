## generated output
Treat `dist/` as CI-owned output.
Edit `skills/` and repo metadata, not generated bundles.
- ✗ run `make dist` after source edits and commit the result
- ✓ commit source changes only; let CI regenerate `dist/`
Run `make dist` only when the user asks for a local check.

## docs
Write user-facing docs for humans, not agents.
Cut process-speak, packaging jargon, and internal labels unless the reader needs them.
Prefer the concrete label a person would look for on screen or in the repo.
- ✗ `repo contract`
- ✓ `editing`
- ✗ `bundle families`
- ✓ `build output`
- ✗ `marketplace bundle`
- ✓ `plugin bundle`

## writing
Run requested prose review passes in order.
Apply every note from each pass before starting the next one unless the user rejects it.
- ✗ batch several passes, then apply a subset of notes at the end
- ✓ finish one pass, apply all feedback, then start the next pass
If a pass comes back clean, say so and continue.

## workflow
Check repo docs and workflow files before running build or generation commands.
Follow the repo's workflow, not generic habits from other projects.
- ✗ assume the local developer stages generated output because that is common elsewhere
- ✓ check who owns the artifact in this repo, then act
If CI owns an artifact, leave it alone unless the user says otherwise.
