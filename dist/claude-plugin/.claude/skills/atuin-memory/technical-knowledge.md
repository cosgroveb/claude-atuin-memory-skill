# Technical Knowledge

Use `technical-knowledge` for cross-project priming memory.

This namespace is read-mostly. It is not task-state memory.

Good fits:

- Reusable technical references
- Curated summaries of docs and books
- Grounded notes that improve later in-context behavior
- Language, framework, and tool notes used across many projects

Use it when language, framework, or documentation context would help:

```bash
atuin kv list --namespace "technical-knowledge"
atuin kv get --namespace "technical-knowledge" "go-mistakes"
```

Practically, this supports knowledge priming and lightweight retrieval-augmented prompting. It is not fine-tuning.
