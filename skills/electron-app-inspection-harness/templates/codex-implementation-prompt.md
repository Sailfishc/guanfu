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
06-codex-tasks/task-contract.json
06-codex-tasks/acceptance-checklist.md
```

Rules:

1. Build from documented behavior and component specs.
2. Use provenance. Treat screenshot-only values as approximate.
3. Preserve unknowns as TODOs or capture tasks.
4. Implement vertical slices. Each slice must produce a visible, reviewable result.
5. Add stories/examples for observed states.
6. Add accessibility basics for roles, names, focus, keyboard paths.
7. Add visual checks when screenshots exist.
8. Do not copy proprietary assets unless the task contract explicitly grants rights.

Start with the first slice in `task-contract.json`.
