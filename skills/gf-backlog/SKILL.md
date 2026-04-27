---
name: gf-backlog
description: Use when GuanFu plans, QA reports, review findings, architecture candidates, compound lessons, or follow-ups need local work items, HITL/AFK task state, blockers, or non-GitHub backlog tracking.
---

# gf-backlog

## Purpose

Own GuanFu work-item state.

This skill turns slices, QA findings, review repairs, architecture candidates, guardrails, and evolution follow-ups into local-first durable work items. GitHub, Linear, Jira, or other trackers are optional adapters, not the GuanFu core.

Core rule: local markdown is the source of truth; external trackers are adapters.

## Boundary

- `/gf-plan` owns execution intent and slice order.
- `/gf-backlog` owns task state, blockers, local work-item files, and optional external tracker references.
- `/gf-work` owns implementation evidence for one active plan slice or ready AFK work item.
- `/gf-qa` owns behavior-first bug capture.
- `/gf-architecture-review` owns architecture candidates.

Do not run `gh`, `linear`, `jira`, or network-backed tracker commands unless the user explicitly asks for external export or sync.

## Artifacts

```text
docs/guanfu/backlog/WI-YYYYMMDD-HHMM-<slug>.md
docs/guanfu/backlog/README.md
```

Use `docs/guanfu/backlog/WORK_ITEM_TEMPLATE.md` when available.

## Work-item schema

Each item must include this frontmatter:

```yaml
id: WI-YYYYMMDD-HHMM-<slug>
title: <short title>
status: TODO | READY | ACTIVE | BLOCKED | DONE | SUPERSEDED | ARCHIVED
kind: FEATURE_SLICE | QA_BUG | QA_FOLLOWUP | REVIEW_REPAIR | ARCHITECTURE_CANDIDATE | DOC_FIX | GUARDRAIL | EVOLUTION | FOLLOW_UP
mode: HITL | AFK
risk: LOW | MEDIUM | HIGH
source_skill: gf-plan | gf-qa | gf-code-review | gf-doc-review | gf-architecture-review | gf-guardrails | gf-compound | gf-evolve | user
source_artifact: <path or none>
parent: <plan path, work item id, or none>
blocked_by:
  - <work item id or none>
backend: local | github | linear | jira | none
backend_ref: <url/id or none>
lifecycle: CURRENT | HISTORICAL | SUPERSEDED | ARCHIVED
created: <ISO timestamp>
updated: <ISO timestamp>
```

Body sections:

```markdown
## User / System Outcome
## What to Build or Fix
## Acceptance Criteria
## End-to-End Path
## Verification
## Blocked By
## Notes for Implementer
## Notes for Reviewer
## Lifecycle
```

## Create or update work items

1. Read active plans, QA notes, review artifacts, architecture candidates, compound notes, and existing `docs/guanfu/backlog/*.md`.
2. Decide whether the source maps to one item or multiple thin items.
3. Prefer vertical tracer-bullet items: each AFK implementation item should be independently verifiable or demoable.
4. Record `mode: HITL` only when human judgment remains. Prefer `AFK` for implementable, approved work.
5. Record blockers by work-item id when a task cannot start until another item is complete.
6. If the item already exists, update status/evidence instead of creating duplicates.
7. Keep external tracker fields empty unless export/sync is requested.

## Status rules

```text
TODO -> READY -> ACTIVE -> DONE
TODO/READY/ACTIVE -> BLOCKED
DONE -> HISTORICAL | ARCHIVED
any -> SUPERSEDED
```

Rules:

- `READY` means blockers are satisfied and acceptance criteria are clear.
- `ACTIVE` means exactly one agent/human currently owns it.
- `DONE` requires verification evidence or an explicit `DONE_WITH_CONCERNS` note.
- `SUPERSEDED` must name the successor item or artifact.
- `ARCHIVED` items are retained for audit, not current instruction.

## Relationship to plans

A plan may still contain one active slice. Work items make the larger backlog visible across QA, review, architecture, and evolution.

When creating plan-derived items, add this line to both sides:

```markdown
Related Plan: <path>
Related Work Item: <id/path>
```

## External export adapter

External issue export is optional and user-triggered.

Before export, ask which backend to use. Then map local work-item fields to the backend. Do not delete or replace local work items after export; write only `backend` and `backend_ref`.

## Output

```text
STATUS: CREATED | UPDATED | NO_CHANGE | BLOCKED
ITEMS:
- <id>: <status> <mode> <kind> <path>
EXTERNAL_BACKEND: local | github | linear | jira | none
NEXT: /gf-plan | /gf-work | /gf-qa | /gf-architecture-review | /gf-doc-review | none
```
