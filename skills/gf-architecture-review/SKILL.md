---
name: gf-architecture-review
description: Use when a GuanFu plan, diff, QA finding, or repeated review pattern suggests architecture friction, shallow modules, unclear seams, hard-to-test code, cross-module coupling, or deep-module opportunities.
---

# gf-architecture-review

## Purpose

Screen codebase health and propose architecture candidates before the system drifts.

This is a prevention skill. It finds structural friction and deepening opportunities. It does not refactor directly.

## Vocabulary

Use these terms consistently:

- **Module**: anything with an interface and implementation.
- **Interface**: everything a caller must know to use the module: types, invariants, error modes, ordering, configuration, and semantics.
- **Implementation**: code inside the module.
- **Depth**: leverage behind the interface. Deep modules hide meaningful behavior behind a small interface.
- **Seam**: where an interface lives and behavior can change without editing callers in place.
- **Adapter**: a concrete implementation satisfying an interface at a seam.
- **Leverage**: what callers gain from module depth.
- **Locality**: how much change, bugs, and knowledge stay concentrated.

Rules:

- The interface is the test surface.
- **Deletion test**: apply the deletion test. If deleting a module only removes pass-through ceremony, it was shallow. If deleting it spreads complexity across callers, it was earning its keep.
- One adapter is a hypothetical seam. Two adapters make a real seam.

## Triggers

Use this skill when:

- a plan touches three or more modules
- a slice changes data model, public API, or a core interface
- tests are hard to write or require excessive mocks
- code review finds unclear boundaries, high coupling, or ADR drift
- QA reveals behavior that crosses many areas
- compound notes repeat the same boundary or locality failure
- the user asks to improve architecture or make the codebase more AI-navigable

## Inputs

Read:

- active plan and relevant slices
- `docs/guanfu/context/*.md`
- `docs/guanfu/adr/*.md`
- `docs/guanfu/backlog/*.md`
- `docs/guanfu/compound/index.md` and relevant notes
- recent code/doc reviews
- current code using read-only exploration

## Output artifact

```text
docs/guanfu/reviews/architecture/YYYY-MM-DD-HHMM-<slug>-architecture-review.md
```

Also create or update `ARCHITECTURE_CANDIDATE` work items through `/gf-backlog` when a candidate should be tracked.

## Review process

### 1. Architecture scope check

```markdown
## Architecture Scope Check
Source: <plan/review/QA/user request>
Reason Triggered: <trigger>
Modules Involved:
- <module>
Relevant ADRs:
- <path or none>
Decision: REVIEW | NEED_CONTEXT | ROUTE_TO_PLAN | NO_ACTION
```

### 2. Read-only exploration

Look for:

- shallow pass-through modules
- concepts split across many files with low locality
- modules whose interface is nearly as complex as the implementation
- seams with only one adapter that add ceremony but no leverage
- hard-to-test behavior hidden behind the wrong interface
- extracted pure functions that lose the real behavior boundary
- ADR conflicts where real friction warrants revisiting a decision

### 3. Present candidates, not implementation

For each candidate:

```markdown
### Candidate A: <name>

Kind: DEEPEN_MODULE | REMOVE_PASS_THROUGH | CREATE_SEAM | MERGE_SHALLOW_MODULES | TEST_SURFACE_REDESIGN | ADR_REVISIT
Risk: LOW | MEDIUM | HIGH
Mode: HITL | AFK
Route: gf-brainstorm | gf-plan | gf-backlog | ADR | no-action

#### Files / Modules
#### Current Friction
#### Interface Burden
#### Deletion Test
#### Proposed Direction
#### Test Surface After Change
#### Locality Gain
#### Leverage Gain
#### ADR Conflict
#### Why Now / Why Not Now
```

Do not propose final interface details until the user selects a candidate or an approved plan asks for that design.

### 4. Route selected candidates

- Needs human design judgment -> `mode: HITL`, route to `/gf-brainstorm` or `/gf-plan`.
- Clear, low-risk deepening that serves an approved plan -> create `ARCHITECTURE_CANDIDATE` work item and route to `/gf-plan`.
- Contradicts ADR but friction is real -> propose ADR revisit.
- Not worth doing now -> record `no-action` with reason so future reviews do not re-suggest casually.

## Output

```text
STATUS: CLEAR | CANDIDATES_FOUND | ADR_REVISIT | ROUTE_TO_PLAN | NO_ACTION
CANDIDATES: <count>
WORK_ITEMS_CREATED: <count>
NEXT: /gf-backlog | /gf-plan | /gf-brainstorm | /gf-doc-review | none
```
