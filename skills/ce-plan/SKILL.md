---
name: ce-plan
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
  - /ce-plan
  - create plan
  - implementation plan
  - plan this
  - ADR
---

# CE Plan

## Overview

Convert an approved brainstorm into a living implementation plan with small slices, explicit verification, and ADRs for architectural decisions.

Core principle: a good plan makes execution smaller. If the work cannot be sliced, the design is not clear enough.

## Hard Gate

Do not implement code in this skill.

The output is a plan document. `ce-work` updates that same document during implementation.

## Required Artifacts

Primary artifact:

```text
docs/ce/plans/YYYY-MM-DD-<slug>-plan.md
```

Optional ADR artifact when a meaningful architecture decision is made:

```text
docs/ce/adr/YYYY-MM-DD-<slug>.md
```

The plan must have:

```markdown
Status: ACTIVE | COMPLETED | PAUSED | ABANDONED
Active Slice: <slice id or none>
```

## Workflow

### 1. Find approved input

Look for the newest approved brainstorm or user-provided spec:

```bash
find docs/ce/brainstorms docs/superpowers/specs docs -type f -name '*.md' 2>/dev/null | sort | tail -50
```

If no approved input exists, ask whether to run `ce-brainstorm` first. Do not invent the missing problem statement.

### 2. Run required code explore

Before writing the plan, run a code exploration pass. Prefer an independent agent when available.

Agent prompt:

```text
You are doing code exploration for Compound Engineering planning. Do not modify files.

Goal: understand the existing codebase area relevant to this approved brainstorm/spec.

Return:
1. Relevant files and why they matter.
2. Existing patterns to follow.
3. Data models, APIs, routes, tests, docs, and commands involved.
4. Risks, hidden coupling, and likely edge cases.
5. Recommended smallest safe implementation slices.
6. ADR candidates, if any.

Do not propose implementation code. Do not edit files.
```

If an agent is unavailable, perform the same exploration inline and state that it was inline.

### 3. Decide whether an ADR is needed

Create an ADR when any of these are true:

- New data model, public API, protocol, persistence strategy, integration, migration, security boundary, or deployment path.
- Two plausible designs have different long-term consequences.
- Reversing the decision later would be expensive.

ADR template:

```markdown
# ADR: <decision title>

Date: <YYYY-MM-DD>
Status: Proposed | Accepted | Superseded
Related Plan: ../plans/<plan-file>.md

## Context
<why this decision exists>

## Decision
<the chosen decision>

## Alternatives Considered
### Option A
Pros:
Cons:
### Option B
Pros:
Cons:

## Consequences
Positive:
Negative:
Risks:

## Verification
<how future agents know this decision still holds>
```

### 4. Slice the work

Each slice must be independently reviewable and verifiable.

Good slice:

```markdown
### Slice S1: Add parser contract tests
Status: TODO
Goal: Lock expected parser behavior before implementation changes.
Files likely touched:
- test/parser.test.ts
Verification:
- npm test test/parser.test.ts
Exit criteria:
- Failing tests prove current behavior gap.
```

Bad slice:

```markdown
### Slice S1: Build the feature
```

Slice rules:

- Each slice has one user-visible or system-visible outcome.
- Each slice names likely files, verification commands, and exit criteria.
- A slice should usually fit in one focused working session.
- Put risky or unknown work early as a spike or test slice.
- Do not hide review, docs, and migration work inside vague implementation slices.

### 5. Write the living plan

Use this template:

```markdown
# Plan: <title>

Generated: <ISO timestamp>
Status: ACTIVE
Active Slice: none
Source Brainstorm: <path>
Repo: <repo or unknown>
Branch: <branch or unknown>

## Goal
<one paragraph>

## Non-Goals
<explicitly out of scope>

## Context from Code Explore
<files, patterns, risks, commands>

## Decisions
<link ADRs or inline decisions>

## Slices

### Slice S1: <name>
Status: TODO | ACTIVE | COMPLETED | DEFERRED
Goal:
Files likely touched:
Steps:
1.
2.
Verification:
- <command>
Exit criteria:
- <observable proof>
Review notes:

### Slice S2: <name>
Status: TODO
...

## Test Strategy
<unit, integration, e2e, manual checks>

## Documentation Strategy
<docs to update during or after work>

## Risks and Mitigations
| Risk | Mitigation | Owner |
|---|---|---|

## Open Questions
| Question | Blocking? | Resolution |
|---|---|---|

## Work Log
<ce-work appends entries here>

## Review Log
<ce-review appends or links entries here>

## Completion Criteria
<all conditions required to mark Status: COMPLETED>
```

### 6. Ask for plan approval

Present the plan summary and ask:

- A) Approve and start `ce-work` on S1
- B) Revise slices
- C) Add or revise ADR
- D) Stop with plan saved as draft

Do not proceed to implementation without approval.

## Common Mistakes

| Mistake | Fix |
|---|---|
| Skipping code exploration | Run the code explore pass before writing slices. |
| Making one giant slice | Split until each slice has one outcome and one verification path. |
| Avoiding ADRs because they feel ceremonial | If reversal is expensive, write the ADR. |
| Leaving plan status ambiguous | Set `Status` and `Active Slice` explicitly. |
| Planning tests at the end only | Put tests in the earliest slices that can express behavior. |

## Completion

Report:

```text
STATUS: DONE | NEEDS_CONTEXT | DONE_WITH_CONCERNS
PLAN: docs/ce/plans/YYYY-MM-DD-<slug>-plan.md
ADRS: <paths or none>
NEXT: ce-work S1
```
