---
name: gf-brainstorm
description: Use when a user has an early product or engineering idea, fuzzy requirement, unclear problem statement, agent workflow concept, skill concept, or wants to explore options before planning or implementation.
---


# gf-brainstorm

## Purpose

Turn a fuzzy idea into a clear problem frame, explicit assumptions, alternatives, and a written brainstorm artifact.

This is a human-loop stage. Ask questions, challenge assumptions, compare options, and wait for approval before handing off to `gf-plan`.

## Boundary

Produce a brainstorm document. Planning belongs to `/gf-plan`. Implementation belongs to `/gf-work`.

Required artifact:

```text
docs/guanfu/brainstorms/YYYY-MM-DD-HHMM-<slug>.md
```

Use:

```markdown
Status: DRAFT | APPROVED | SUPERSEDED
Readiness: COMPLETE | PARTIAL
```

`APPROVED` means the user accepted the brainstorm as input for `/gf-plan`.

## Multi-turn exploration

One question at a time means one main question per user turn. The stage usually takes multiple turns.

Count only assistant-asked questions that the user answered. The initial prompt can satisfy coverage fields.

| Situation | Question-turn floor before draft | Normal range |
|---|---:|---:|
| Fully specified brief with concrete outcome, actor, constraints, success criteria, tradeoffs, and non-goals | 0 | 0-1 |
| Clear, narrow feature or workflow | 2 | 2-4 |
| Normal product, engineering, or agent workflow idea | 3 | 3-6 |
| Vague, high-leverage, architectural, or skill-design idea | 5 | 5-8 |
| High-risk data, security, migration, cross-system, or AI behavior change | 6 | 6-10 |
| User is discovering what they mean | Use convergence checks until the coverage gate passes or the user chooses a partial draft | variable |

The agent judges coverage after every answer. Drafting starts after the readiness gate passes.

## Recover context

Run lightweight context recovery before questions:

```bash
find docs/guanfu -maxdepth 3 -type f -name '*.md' 2>/dev/null | sort | tail -80
[ -f AGENTS.md ] && sed -n '1,220p' AGENTS.md
[ -f agents.md ] && sed -n '1,220p' agents.md
git log --oneline -20 2>/dev/null || true
```

Read related brainstorms, plans, reviews, ADRs, compound notes, and evolution notes.

For engineering, architecture, agent workflow, and skill-design ideas inside a repo, dispatch a read-only code explore before final alternatives.

## Classify the idea

| Idea type | Primary risk | Strong question bias |
|---|---|---|
| Product idea | Building for an imaginary user | user, demand, status quo, success |
| Engineering feature | Scope drift or hidden edge cases | constraints, interfaces, verification |
| Architecture | Premature commitment | tradeoffs, reversibility, migration risk |
| Agent workflow / skill | Shallow process that agents misread | failure modes, gates, artifacts, pressure scenarios |
| Internal process | Ceremony with weak leverage | decision points, documents, feedback loops |
| Research / exploration | Vague success criteria | learning goal, stopping rule, evidence |

## Coverage matrix

Keep this matrix during the session. Scores update after every user answer.

| Score | Meaning |
|---:|---|
| 0 | Missing |
| 1 | Vague or slogan-level |
| 2 | Concrete enough to guide planning |
| 3 | Concrete, evidenced, and includes boundaries or examples |

Coverage fields:

| Field | Critical? |
|---|---|
| Outcome | Yes |
| Actor | Yes |
| Pain / Job | Yes |
| Status Quo | Yes for product/process, optional for narrow code changes |
| Constraints | Yes |
| AI Failure Eliminated | Yes for GuanFu, agent, process, and skill work |
| AI Leverage Amplified | Yes for GuanFu, agent, process, and skill work |
| Failure Modes | Yes for agent/process/skill work |
| Success Criteria | Yes |
| Taste Bar | Yes |
| Alternatives | Yes |
| Scope Boundary | Yes |
| Artifact / Memory | Yes for GuanFu workflows |
| Evolution Signal | Yes for skill/process work |
| Plan Handoff | Yes |

Treat inferred facts as `Assumption`. Ask when an assumption drives a plan-level decision.

## Ask loop

Ask one main question through AskUserQuestion. Use multiple-choice questions when the user is stuck or the domain is broad.

Select the next question by this priority:

1. A critical field has score 0.
2. A critical field has score 1 and would cause a weak plan.
3. A hidden assumption could change architecture, slice order, review criteria, or future skill behavior.
4. The user used a vague quality word such as “better,” “smart,” “simple,” “automatic,” “robust,” or “AI-native.”
5. The next stage lacks enough information to create slices.
6. The AI failure eliminated or AI leverage amplified is unclear.
7. The taste bar is unclear.

After each user answer, update the coverage matrix and decide whether to continue asking, present alternatives, run code explore, or run readiness check.

After every 3 answered question turns, provide:

```markdown
## Convergence Check
Clear now:
- <field>: <summary>

Still weak:
- <field>: <why it matters>

Coverage snapshot:
| Field | Score | Note |
|---|---:|---|

Next highest-leverage question:
<one question>
```

## Readiness gate

Before writing a draft, output:

```markdown
## Brainstorm Coverage Check
Question turns answered: <N>
Question-turn floor for this scope: <N>
Idea type: <type>
Fast path used: yes/no

| Field | Score | Evidence | Gap |
|---|---:|---|---|

Decision: CONTINUE_ASKING | RUN_CODE_EXPLORE | PRESENT_ALTERNATIVES | WRITE_DRAFT | WRITE_PARTIAL_DRAFT
```

Rules:

- `WRITE_DRAFT`: every critical field is at least 2 and question-turn floor is met.
- `WRITE_PARTIAL_DRAFT`: user explicitly accepts partial readiness, with planning risks recorded.
- `CONTINUE_ASKING`: any plan-changing critical field is 0 or 1.
- `RUN_CODE_EXPLORE`: repo-bound idea with weak context.
- `PRESENT_ALTERNATIVES`: coverage is enough to compare paths.

## Alternatives

Before the final artifact, present 2-3 approaches:

```markdown
## Options

### Approach A: <name>
Summary:
Best for:
Tradeoff:
Risk:

### Approach B: <name>
...

Recommendation: <approach> because <reason>
```

Ask the user to approve, revise, or choose another option.

## Write artifact

Use `docs/guanfu/brainstorms/BRAINSTORM_TEMPLATE.md` when available. If the repo has not run `gf-init`, create the same sections from the skill instructions.

The artifact must include:

- Question Trace
- Coverage Report
- GuanFu Value Mapping
- Options Considered
- Recommended Direction
- Scope Boundary
- Planning Risks
- Handoff to Plan
- Skill Feedback when the process felt too shallow, too long, or miscalibrated

## Approval

Ask the user:

```text
A) Approve brainstorm and continue to /gf-plan
B) Revise the brainstorm
C) Keep as partial and continue with explicit planning risks
```

When approved, set `Status: APPROVED`, then continue to `/gf-plan`.

