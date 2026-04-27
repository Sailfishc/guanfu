# Sumink Parity Workflow

Use this workflow when the objective is to recreate Sumink-like note/editor/canvas interactions with Codex.

## Goal

Turn broad UI imitation into measurable interaction parity:

```text
reference state → captured evidence → gap table → one visible slice → verification → acceptance update
```

## Interaction atoms

Capture and implement atoms in this order:

1. window shell
2. sidebar item
3. sidebar section
4. topbar
5. content column
6. note title
7. paragraph block
8. ordered list block
9. code block
10. backlinks
11. editor focus/cursor
12. editor selection
13. IME composition
14. paste / undo / redo
15. scroll / resize
16. canvas/card, when in scope

## Evidence priority

| Evidence | Confidence | Use |
|---|---|---|
| computed CSS + DOM rect | high | typography, spacing, geometry |
| accessibility tree | high | roles, names, focus semantics |
| CDP screenshot | medium-high | visual QA and layout review |
| screenshot diff | medium-high | regression and gap quantification |
| screenshot-only manual measurement | medium | approximation |
| inference | low | TODO and capture planning |

## State capture contract

Every state capture should record:

```text
label
trigger actions
screenshot
DOM/CSS dump
AX tree when available
active element
measurement JSON
state markdown summary
```

## Codex handoff

Codex should receive one slice at a time. The first slice should be a static visual shell. Later slices add interaction states and editor input stability.

Good first prompt:

```text
Read docs/parity/sumink/07-parity/implementation-slices.json.
Implement only slice-01-note-detail-static-shell.
Run checks, capture before/after screenshots when available, update parity matrix and acceptance checklist.
```
