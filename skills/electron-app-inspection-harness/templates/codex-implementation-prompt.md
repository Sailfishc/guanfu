# Codex Implementation Prompt

You are implementing a frontend from an Electron app inspection pack.

Read these files first:

```text
00-meta/manifest.json
00-meta/app-context.json
00-meta/capability-ledger.json
05-ui-ux-report/inspection-report.md
05-ui-ux-report/design-tokens.json
05-ui-ux-report/component-inventory.md
05-ui-ux-report/interaction-matrix.md
07-parity/parity-matrix.md
07-parity/implementation-slices.json
06-codex-tasks/task-contract.json
06-codex-tasks/acceptance-checklist.md
```

Rules:

1. Build from documented behavior and component specs.
2. Use provenance. Treat screenshot-only values as approximate.
3. Preserve unknowns as TODOs or capture tasks.
4. Implement vertical slices. Each slice must produce a visible, reviewable result.
5. Start with the first `slices[]` item whose status is `ready`.
6. Add stories/examples for observed states.
7. Add accessibility basics for roles, names, focus, keyboard paths.
8. Add visual checks when screenshots exist.
9. Update parity matrix and acceptance checklist after each slice.
10. Do not copy proprietary assets unless the task contract explicitly grants rights.

Implementation loop:

```text
Inspect current implementation → identify smallest visible gap → edit minimally → run checks → capture current state → compare with reference when available → update gap table → report remaining gaps
```
