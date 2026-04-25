---
name: gf-plan
version: 0.2.0
description: Use when an approved brainstorm, design, or product decision exists and the user wants implementation slices, architecture decisions, ADRs, or an active engineering plan before coding.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Write
  - Edit
  - AskUserQuestion
  - Agent
  - WebSearch
triggers:
  - /gf-plan
  - create plan
  - implementation plan
  - plan this
  - ADR
---

# gf-plan

## Overview

Convert an approved brainstorm into a living implementation plan with small slices, explicit verification, and ADRs for architectural decisions.

Core principle: a good plan makes execution smaller. If the work cannot be sliced, the design needs more clarity.

## Hard Gate

Do not implement code in this skill.

The output is a plan document. `gf-work` updates that same document during implementation.

## Required Artifacts

Primary artifact:

```text
docs/guanfu/plans/YYYY-MM-DD-<slug>-plan.md
```

Create ADRs when needed:

```text
docs/guanfu/adr/YYYY-MM-DD-<decision>.md
```

## Workflow

### 1. Load source of truth

Read:

- approved brainstorm
- `docs/guanfu/context/*.md`
- relevant `docs/guanfu/compound/*.md`
- `AGENTS.md` or `agents.md`
- existing ADRs
- related plans

If no approved input exists, ask whether to run `gf-brainstorm` first.

### 2. Run targeted code explore

Use an independent agent for code exploration when the plan touches existing code. The code explore must identify:

- files likely touched
- existing patterns to reuse
- test commands
- integration points
- risk areas
- ADR candidates

### 3. Slice the work

A slice is valid when it has:

- one user-visible or test-visible outcome
- clear scope and out-of-scope boundaries
- likely files or modules
- test-first plan
- verification command
- exit criteria
- review notes

Exactly one slice starts as `ACTIVE`. Others start as `TODO`.

### 4. Identify ADRs

Write or require an ADR for:

- data model changes
- persistence changes
- cross-module boundary changes
- new dependencies
- irreversible or expensive-to-reverse decisions
- agent routing or harness changes

### 5. Write living plan

The plan must include:

```markdown
Plan Status: ACTIVE
Active Slice: S1
```

Each slice must include:

```markdown
Status: TODO | ACTIVE | COMPLETED | DEFERRED | BLOCKED
Verification:
- `<command>`
Exit criteria:
- <observable proof>
```

### 6. Review the plan before handoff

Before completion, check:

- each slice is independently executable
- tests or verification are concrete
- open questions have owners or decisions
- ADR needs are explicit
- plan can be executed without chat context
- relevant compound notes are linked

### 7. Handoff

Ask the user to approve the plan before `gf-work`.

## Common Mistakes

| Mistake | Fix |
|---|---|
| Creating vague milestones | Use slices with verification and exit criteria. |
| Leaving all slices TODO | Mark exactly one active slice. |
| Hiding architecture decisions | Create or require ADRs. |
| Planning from memory | Read brainstorm, code explore, compound notes, and AGENTS. |
| Missing verification | Every slice gets a command or explicit check. |

## Completion

Report:

```text
STATUS: DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT
PLAN: docs/guanfu/plans/YYYY-MM-DD-<slug>-plan.md
ACTIVE_SLICE: S1
NEXT: gf-work S1
```
