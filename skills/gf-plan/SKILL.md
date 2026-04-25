---
name: gf-plan
version: 0.3.0
description: Use when an approved brainstorm, design, or product decision exists and the user wants implementation slices, architecture decisions, ADRs, or an active engineering plan before coding.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Write
  - Edit
  - Bash
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

Convert an approved brainstorm into a living implementation plan with small slices, explicit verification, ADRs, and an execution chain.

Core principle: this is the second human-loop stage. Align the target here. After approval, execution should proceed automatically through work, review, compound, and evolve when needed.

## Harness Position

`gf-plan` is a human-loop stage. Use AskUserQuestion to resolve plan-changing ambiguity, select tradeoffs, and approve the final plan.

After the plan is approved, downstream stages should avoid human prompts. They record deviations, execute the slice, review the result, compound lessons, and evolve the harness from evidence.

## Hard Gate

Do not implement code in this skill. The output is a plan document. `gf-work` updates that same document during implementation.

## Required Artifacts

Primary artifact:

```text
docs/guanfu/plans/YYYY-MM-DD-HHMM-<slug>-plan.md
```

Create ADRs when needed:

```text
docs/guanfu/adr/YYYY-MM-DD-HHMM-<decision>.md
```

## Workflow

### 1. Load source of truth

Read:

```bash
find docs/guanfu/brainstorms docs/guanfu/context docs/guanfu/compound docs/guanfu/adr docs/guanfu/plans -type f -name '*.md' 2>/dev/null | sort | tail -120
[ -f AGENTS.md ] && sed -n '1,240p' AGENTS.md
[ -f agents.md ] && sed -n '1,240p' agents.md
git log --oneline -20 2>/dev/null || true
```

Choose the latest relevant approved brainstorm or design. If multiple candidates exist, ask the user to choose.

### 2. Input Readiness Gate

Before writing the plan, print:

```markdown
## Plan Input Check

Source: <brainstorm path>
Source Status: APPROVED | DRAFT | PARTIAL | UNKNOWN
Readiness: COMPLETE | PARTIAL | UNKNOWN
Open Questions Blocking Plan: yes/no
Decision: PLAN | RETURN_TO_BRAINSTORM | PLAN_WITH_RISKS
Reason: <one sentence>
```

Gate rules:

- `APPROVED + COMPLETE` -> `PLAN`.
- `APPROVED + PARTIAL` -> ask the user whether to plan with explicit risks or return to `gf-brainstorm`.
- `DRAFT` or `UNKNOWN` -> return to `gf-brainstorm` unless the user explicitly approves planning with risks.

### 3. Run targeted code explore

For repo-bound work, dispatch a read-only code explore agent before slicing.

Prompt:

```text
You are exploring repository context for a GuanFu plan. Read only. Identify files likely touched, existing patterns, tests, commands, integration points, risk areas, ADR candidates, and compound notes relevant to the approved brainstorm. Return concise findings and recommended slice boundaries.
```

Save or reference the findings in the plan. If code explore is unavailable, inspect directly and record the limitation under `Planning Risks`.

### 4. Create ADR decision matrix

For each architectural decision, fill:

```markdown
| Decision | Reversible? | Affects data? | Affects public API? | Cross-module? | New dependency? | ADR needed? |
|---|---|---|---|---|---|---|
```

ADR is required when a decision affects data, public API, cross-module boundaries, new dependencies, routing, persistent state, security, or has high reversal cost.

### 5. Slice the work

A valid slice has one user-visible or test-visible outcome and can be reviewed independently.

Required slice schema:

```markdown
### Slice S<n>: <name>

Status: TODO | ACTIVE | COMPLETED | BLOCKED | DEFERRED
Risk: LOW | MEDIUM | HIGH

#### Outcome
<visible or test-visible result>

#### Entry Conditions
<what must be true before work starts>

#### Scope
<work allowed in this slice>

#### Out of Scope
<work deferred or forbidden>

#### Files / APIs Expected To Change
<paths, modules, commands, APIs>

#### Test-First Plan
<tests to write or update, including expected RED behavior when applicable>

#### Verification Commands
`<command>`

#### Rollback / Revert Path
<how to back out safely>

#### Review Focus
<what gf-code-review should inspect hardest>

#### Compound Triggers
<what kind of failure should become a compound note>

#### Exit Criteria
<observable proof of completion>

#### Completion Evidence
<left blank for gf-work>
```

Exactly one slice starts as `ACTIVE`. Others start as `TODO`.

### 6. Write living plan

The plan must include:

```markdown
Plan Status: ACTIVE | PAUSED | COMPLETED | ABANDONED
Active Slice: S1 | none
Source:
Previous Artifact:
Next Artifact: /gf-work
Related Compound Notes:
Related ADRs:
Supersedes:
```

Include:

- goal
- constraints
- code explore summary
- ADR decision matrix
- slice index
- full slice details
- execution chain
- planning risks
- open questions
- implementation log placeholder
- review log placeholders
- compound/evolution hooks

### 7. Plan Review Gate

Before approval, print:

```markdown
## Plan Review Check

| Check | Result | Evidence |
|---|---|---|
| Source approved | PASS/PARTIAL/FAIL | <path> |
| Exactly one active slice | PASS/PARTIAL/FAIL | <slice> |
| Every slice has verification | PASS/PARTIAL/FAIL | <summary> |
| ADR matrix complete | PASS/PARTIAL/FAIL | <summary> |
| Rollback path exists | PASS/PARTIAL/FAIL | <summary> |
| Execution chain clear | PASS/PARTIAL/FAIL | <summary> |
| Can fresh agent execute | PASS/PARTIAL/FAIL | <summary> |
```

### 8. Approval gate

Ask the user to approve before execution.

Options:

```text
A) Approve plan and start /gf-work automatically
B) Revise specific sections
C) Return to /gf-brainstorm
D) Keep as draft
```

If approved, set:

```markdown
Plan Status: ACTIVE
Active Slice: S1
Approved By: <user>
Approved At: <timestamp>
Execution Mode: AUTOMATED_AFTER_PLAN
```

Then hand off directly:

```text
NEXT: /gf-work S1
```

## Common Mistakes

| Mistake | Fix |
|---|---|
| Planning from a draft brainstorm | Run the Input Readiness Gate. |
| Creating vague milestones | Use slices with entry conditions, verification, and exit criteria. |
| Leaving all slices TODO | Mark exactly one active slice. |
| Hiding architecture decisions | Fill the ADR matrix and write ADRs. |
| Missing rollback | Every slice needs a revert or rollback path. |
| Treating execution as another discussion phase | Get approval here, then downstream stages execute and review. |

## Completion

Report:

```text
STATUS: DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT
PLAN: docs/guanfu/plans/YYYY-MM-DD-HHMM-<slug>-plan.md
ACTIVE_SLICE: S1
EXECUTION_MODE: AUTOMATED_AFTER_PLAN
NEXT: /gf-work S1
```
