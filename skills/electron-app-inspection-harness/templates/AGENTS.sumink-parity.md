# AGENTS.md — Sumink Parity Workflow

## Read order for Sumink parity work

When a task mentions Sumink parity, note/editor/canvas recreation, sidebar states, editor blocks, backlinks, selection, cursor, hover/focus/active, or visual screenshot matching, read:

```text
docs/parity/sumink/00-meta/manifest.json
docs/parity/sumink/05-ui-ux-report/inspection-report.md
docs/parity/sumink/05-ui-ux-report/design-tokens.json
docs/parity/sumink/05-ui-ux-report/component-inventory.md
docs/parity/sumink/05-ui-ux-report/interaction-matrix.md
docs/parity/sumink/07-parity/parity-matrix.md
docs/parity/sumink/07-parity/implementation-slices.json
docs/parity/sumink/06-codex-tasks/task-contract.json
docs/parity/sumink/06-codex-tasks/acceptance-checklist.md
```

## Work loop

Work one visible slice at a time:

```text
plan → inspect current code → implement smallest gap → run checks → capture screenshot → compare/gap table → update parity docs
```

## Implementation rules

- Centralize visual tokens.
- Prefer measured values from computed CSS and DOM rects.
- Treat screenshot-only values as approximate.
- Keep unobserved states as TODOs with capture tasks.
- Add examples/stories for each observed state.
- Preserve keyboard focus and accessibility semantics.
- Avoid copying proprietary assets; use replacement assets with provenance notes.
