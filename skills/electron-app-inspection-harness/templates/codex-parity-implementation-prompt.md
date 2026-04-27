# Codex Parity Implementation Prompt

Use this prompt inside the implementation repository after the inspection pack has been copied into `docs/parity/<app-slug>/`.

```text
Read docs/parity/<app-slug>/07-parity/implementation-slices.json and implement only the first ready slice.

Process:
1. Read the slice inputs.
2. Inspect the current implementation.
3. Identify the smallest visible gap.
4. Make the minimal implementation change.
5. Run lint/typecheck/tests when available.
6. Capture before/after screenshots when the local app supports it.
7. Compare with the reference screenshot when available.
8. Update docs/parity/<app-slug>/07-parity/parity-matrix.md and docs/parity/<app-slug>/06-codex-tasks/acceptance-checklist.md.

Report:
- files changed
- checks run
- visual gap closed
- remaining concrete gaps
- next slice
```
