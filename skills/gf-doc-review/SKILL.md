---
name: gf-doc-review
version: 0.2.0
description: Use when GuanFu brainstorms, plans, ADRs, reviews, compound notes, AGENTS routing, or project docs need quality review before another agent depends on them.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Write
  - Edit
  - AskUserQuestion
  - Agent
triggers:
  - /gf-doc-review
  - doc review
  - review plan
  - review ADR
  - review docs
---

# gf-doc-review

## Overview

Review documents as handoff artifacts. A fresh agent should be able to continue without reading the original chat.

Core principle: documents are AI memory. Weak documents create weak execution.

## Required Artifact

```text
docs/guanfu/reviews/docs/YYYY-MM-DD-<slug>-doc-review.md
```

## Workflow

### 1. Choose target docs

Common targets:

```text
docs/guanfu/brainstorms/*.md
docs/guanfu/plans/*.md
docs/guanfu/adr/*.md
docs/guanfu/reviews/code/*.md
docs/guanfu/compound/*.md
docs/guanfu/evolution/*.md
AGENTS.md or agents.md
```

### 2. Review for handoff quality

| Check | Standard |
|---|---|
| Source of truth | The document states what input it came from. |
| State | ACTIVE, COMPLETED, BLOCKED, or DRAFT is explicit. |
| Slices | Each slice has scope, verification, and exit criteria. |
| ADR | Hard-to-reverse decisions are recorded. |
| Verification | Commands or observable checks are present. |
| Handoff | A fresh agent knows next skill and next action. |
| Compound | Repeated lessons are linked or flagged. |
| Evolution | Repeated process gaps are routed to `gf-evolve`. |

### 3. Fix small document issues

Allowed direct edits:

- broken links
- missing status line
- missing next skill line
- obvious typo in path
- template heading mismatch

For substantive changes, record a required edit and ask the user or route to the relevant skill.

### 4. Write review document

Use `templates/doc-review.md`.

### 5. Handoff

If the document blocks implementation, route to `gf-plan` or `gf-work`.

If the document reveals a recurring weakness, route to `gf-compound` or `gf-evolve`.

## Common Mistakes

| Mistake | Fix |
|---|---|
| Treating docs as decoration | Review them as executable handoff context. |
| Passing vague plans | Require verification and exit criteria. |
| Ignoring AGENTS router drift | Check router names and paths. |
| Editing meaning silently | Ask or record required edit for substantive changes. |

## Completion

Report:

```text
STATUS: DONE | DONE_WITH_CONCERNS | BLOCKED
REVIEW: docs/guanfu/reviews/docs/YYYY-MM-DD-<slug>-doc-review.md
VERDICT: CLEAR | CLEAR_WITH_FOLLOWUPS | BLOCKED
NEXT: gf-work | gf-code-review | gf-compound | gf-evolve | stop
```
