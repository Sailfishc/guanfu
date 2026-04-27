# GuanFu Backlog

Local work items live here. They are the source of truth for task state that may outlive one plan.

## Directory Contract

- `WI-*.md`: feature slices, QA bugs, review repairs, architecture candidates, guardrails, and evolution work.
- `WORK_ITEM_TEMPLATE.md`: canonical work item shape.
- External trackers are optional adapters. Keep local work items even when exporting to GitHub, Linear, Jira, or another backend.

## Status Rules

- `READY` means `/gf-work` can start from the item and linked artifacts.
- `ACTIVE` means currently selected. Keep it aligned with the active plan slice.
- `DONE` requires verification evidence.
- `BLOCKED` must name blockers.
- `SUPERSEDED` must point to a successor.
- `ARCHIVED` is historical evidence, not current instruction.
