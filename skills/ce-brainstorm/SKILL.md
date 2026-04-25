---
name: ce-brainstorm
description: Use when a user has an early product or engineering idea, fuzzy requirement, unclear problem statement, or wants to explore options before planning or implementation.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Write
  - Edit
  - AskUserQuestion
  - WebSearch
  - Agent
triggers:
  - /ce-brainstorm
  - brainstorm
  - idea
  - help me think through
  - unclear requirement
---

# CE Brainstorm

## Overview

Turn a fuzzy idea into a clear problem frame, explicit assumptions, alternatives, and a written brainstorm artifact.

Core principle: the first human framing is usually incomplete. Do not optimize it. Expand it, challenge it, and make the user choose.

## Hard Gate

Do not write code, scaffold files, create an implementation plan, or start implementation in this skill.

The only output is a brainstorm document and a handoff recommendation to `ce-plan`.

## Required Artifact

Write one brainstorm document:

```text
docs/ce/brainstorms/YYYY-MM-DD-<slug>.md
```

Use this status field:

```markdown
Status: DRAFT | APPROVED | SUPERSEDED
```

## Workflow

### 1. Recover context

Read project memory before asking questions:

```bash
ls docs/ce 2>/dev/null || true
find docs/ce -maxdepth 3 -type f \( -name '*.md' -o -name '*.jsonl' \) 2>/dev/null | sort | tail -40
[ -f AGENTS.md ] && sed -n '1,220p' AGENTS.md
[ -f CLAUDE.md ] && sed -n '1,220p' CLAUDE.md
git log --oneline -20 2>/dev/null || true
```

If related brainstorms, plans, reviews, ADRs, or compound notes exist, summarize them in two to five bullets.

### 2. Ask one forcing question at a time

Ask only one question per turn. Prefer options when the user is stuck.

Use these question families. Skip any already answered.

| Family | Goal | Example question |
|---|---|---|
| Outcome | Name the user-visible result | "When this works, what becomes easier, faster, safer, or impossible to ignore?" |
| User | Find the actual person | "Who is the first real person this helps? Name role, situation, and pain." |
| Status quo | Reveal current workaround | "What are they doing today, even badly? Spreadsheet, Slack thread, manual script, nothing?" |
| Evidence | Separate demand from interest | "What proof do you have that this matters beyond a nice idea?" |
| Constraint | Find boundaries | "What must not change? API, UX, data model, latency, cost, migration risk?" |
| Success | Define done | "What observable result proves this shipped correctly?" |
| Taste | Clarify what good feels like | "What would make you reject a technically working version as low taste?" |

Push vague answers once. If the user says "developer productivity", ask what exact developer, exact task, exact pain, and exact current workaround.

### 3. Detect scope shape

Before proposing solutions, classify the idea:

| Shape | Action |
|---|---|
| Single slice | Continue normally |
| Multiple independent subsystems | Decompose and pick the first slice |
| Architecture migration | Require ADR candidate in `ce-plan` |
| Pure research | Produce experiment plan, not implementation plan |
| UI-heavy | Include user flows and states in the brainstorm artifact |

If scope is too large, do not continue refining details for all of it. Decompose first.

### 4. Generate alternatives

Produce two or three options before recommending one:

```markdown
## Options

### Option A: Minimal viable slice
- What it proves:
- What it skips:
- Risk:
- Best when:

### Option B: Strong long-term path
- What it proves:
- What it enables:
- Risk:
- Best when:

### Option C: Lateral approach
- What it reframes:
- What it avoids:
- Risk:
- Best when:

Recommendation: Choose <A/B/C> because <reason>.
```

Never give only one path unless the user explicitly asks for a narrow mechanical change and no other path would be meaningfully different.

### 5. Challenge premises

Write premises as statements the user can agree or reject:

```markdown
## Premises

1. <Premise> - Evidence: <evidence or missing evidence>
2. <Premise> - Evidence: <evidence or missing evidence>
3. <Premise> - Evidence: <evidence or missing evidence>
```

If a premise has weak evidence, mark it `UNPROVEN`.

### 6. Save the brainstorm document

Use this template:

```markdown
# Brainstorm: <title>

Generated: <ISO timestamp>
Status: DRAFT
Repo: <repo or unknown>
Branch: <branch or unknown>

## Raw Idea
<the user's original idea, quoted or closely paraphrased>

## Context Recovered
<prior docs, relevant files, recent commits>

## Clarified Problem
<one paragraph>

## Target User or Operator
<specific person, role, workflow, pain>

## Status Quo
<current workaround and cost>

## Constraints
<non-negotiables>

## Success Criteria
<observable outcomes>

## Premises
<numbered premises with evidence strength>

## Options Considered
<2-3 alternatives>

## Recommendation
<recommended direction and why>

## Open Questions
<questions that remain, each marked BLOCKING or NON-BLOCKING>

## Handoff to ce-plan
<what the next skill should plan>
```

### 7. Ask for approval

Ask whether to mark the brainstorm as `APPROVED`.

Options:

- A) Approve and proceed to `ce-plan`
- B) Revise specific sections
- C) Stop here and keep as draft

Only after approval may the next stage run.

## Common Mistakes

| Mistake | Fix |
|---|---|
| Asking five questions at once | Ask one. Wait. Continue. |
| Accepting abstract categories like "users" or "developers" | Force a role, workflow, and real pain. |
| Jumping to implementation | Stop. This skill produces a brainstorm doc only. |
| Treating the first solution as the plan | Generate alternatives first. |
| Writing a brainstorm without premises | Add premises. Future agents need the assumptions. |

## Completion

Report:

```text
STATUS: DONE | NEEDS_CONTEXT | DONE_WITH_CONCERNS
ARTIFACT: docs/ce/brainstorms/YYYY-MM-DD-<slug>.md
NEXT: ce-plan, revise, or stop
```
