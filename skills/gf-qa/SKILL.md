---
name: gf-qa
description: Use when a user is manually testing, reporting bugs, describing broken behavior, doing QA, giving product-taste feedback, or wants issues captured from user-observed behavior.
---

# gf-qa

## Purpose

Capture human QA as durable, behavior-first GuanFu work items.

QA is the human taste and real-behavior input. Do not fix during QA. Do not implement fixes during QA. Capture what happened, what was expected, reproduction steps, impact, and whether the finding blocks current work.

## Boundary

- QA capture belongs here.
- Implementation belongs to `/gf-work`.
- Slice planning belongs to `/gf-plan`.
- Work-item state belongs to `/gf-backlog`.
- Architecture friction belongs to `/gf-architecture-review`.

## For each issue

### 1. Listen and lightly clarify

Let the user describe the problem in their own words. Ask at most 2-3 short questions, focused on:

- what happened
- what they expected
- steps to reproduce
- whether it is consistent or intermittent
- whether it blocks the active slice or release

If reproduction steps are missing, ask for them before filing. If the user cannot reproduce, mark the work item as `risk: MEDIUM` or `HIGH` and state the uncertainty.

### 2. Explore read-only for domain language

Use read-only code/document exploration only to learn:

- domain terms
- user-facing behavior boundary
- likely affected feature area
- relevant plan/backlog/review context

Do not hunt for a fix during QA. Do not write product code.

### 3. Decide item shape

Create one item when there is one wrong behavior in one area.

Break down into multiple thin items when:

- symptoms are independent
- fixes can proceed in parallel
- one issue blocks another
- the report mixes behavior bug, doc gap, and architecture friction

Use dependency order for blockers.

### 4. Write local work item

Default output is a local `QA_BUG` work item through `/gf-backlog`:

```text
docs/guanfu/backlog/WI-YYYYMMDD-HHMM-<slug>.md
```

Required body:

```markdown
## User / System Outcome
The user can <expected outcome>.

## What Happened
<actual behavior in plain language>

## What I Expected
<expected behavior>

## Steps to Reproduce
1. <step>
2. <step>
3. <step>

## Acceptance Criteria
- [ ] <behavior is corrected>
- [ ] <regression or verification path exists>

## End-to-End Path
- Entry point:
- User-visible behavior:
- Data/state involved:
- Verification:

## Additional Context
<domain-language observations; no file paths unless the user explicitly asked for implementation notes>
```

Rules:

- No file paths or line numbers in the user-facing issue body unless the user requested implementation details.
- Use project domain language, not internal guesses.
- Reproduction steps are mandatory.
- Do not create GitHub issues unless the user explicitly asks for external export.

### 5. Route

- Blocking active slice -> create `QA_BUG` item, mark active plan/slice `BLOCKED` or add a repair slice, then route to `/gf-plan` or `/gf-work`.
- Non-blocking bug -> create `QA_BUG` item with `status: TODO` or `READY`.
- Taste/polish follow-up -> create `QA_FOLLOWUP` or `QA_BUG` depending on whether behavior is wrong.
- Architecture smell discovered during QA -> create `ARCHITECTURE_CANDIDATE` route to `/gf-architecture-review`.
- Doc mismatch -> create `DOC_FIX` route to `/gf-doc-review`.

## Output

```text
STATUS: CAPTURED | NEEDS_REPRO | ROUTED | BLOCKED
WORK_ITEMS:
- <id/path>: <kind> <mode> <status>
BLOCKS_ACTIVE_SLICE: yes/no
NEXT: /gf-backlog | /gf-plan | /gf-work | /gf-doc-review | /gf-architecture-review | none
```
