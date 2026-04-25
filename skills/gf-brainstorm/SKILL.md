---
name: gf-brainstorm
version: 0.3.0
description: Use when a user has an early product or engineering idea, fuzzy requirement, unclear problem statement, agent workflow concept, skill concept, or wants to explore options before planning or implementation.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Write
  - Edit
  - Bash
  - AskUserQuestion
  - WebSearch
  - Agent
triggers:
  - /gf-brainstorm
  - brainstorm
  - idea
  - help me think through
  - unclear requirement
  - product idea
  - engineering idea
  - skill idea
  - agent workflow
---

# GuanFu Brainstorm

## Overview

Turn a fuzzy idea into a clear problem frame, explicit assumptions, alternatives, and a written brainstorm artifact.

Core principle: the first human framing is usually incomplete. The job of this stage is to help the human think more clearly before planning starts.

The brainstorm stage uses multi-turn questioning, coverage scoring, and a visible readiness gate. A draft begins only after the idea is plan-ready or the user explicitly chooses a partial draft.

## GuanFu Values

- Eliminate AI collaboration failures: context decay, goal drift, premature coding, skipped verification, repeated mistakes, shallow questioning, and unstable taste.
- Use AI leverage: expand the option space, compress synthesis, expose assumptions, calibrate judgment, preserve durable memory, and improve the next run.
- Aim at amplified AI potential: every brainstorm should make the next agent more capable than the current chat transcript alone.
- Treat documents as durable memory. Treat chat as working context.


## Harness Position

`gf-brainstorm` is a human-loop stage. Use multiple AskUserQuestion turns to align the goal, constraints, success criteria, failure modes, and taste before planning.

This is the right place to slow down. Later stages execute automatically from the approved plan and use review, compound, and evolve to absorb first-pass failures.

## Stage Boundary

This stage produces a brainstorm document. Implementation planning belongs to `/gf-plan`. Implementation belongs to `/gf-work`.

Writing code, scaffolding feature files, changing product behavior, or committing implementation work is outside this stage.

## Required Artifact

```text
docs/guanfu/brainstorms/YYYY-MM-DD-HHMM-<slug>.md
```

Use these status fields:

```markdown
Status: DRAFT | APPROVED | SUPERSEDED
Readiness: COMPLETE | PARTIAL
```

`DRAFT` means the artifact exists. `APPROVED` means the user accepted it as input for `/gf-plan`. `PARTIAL` means the user chose speed while gaps remain.

---

# Mandatory Operating Rule: Multi-Turn Exploration

“One question at a time” means **one main question per user turn**. It also means **multiple turns by default**.

Count only assistant-asked questions that the user answered. The initial user prompt can satisfy coverage fields, and the fast path handles complete briefs.

Default cadence:

| Situation | Question-turn floor before draft | Normal range |
|---|---:|---:|
| User gives a fully specified brief with concrete outcome, actor, constraints, success criteria, tradeoffs, and non-goals | 0 | 0-1 |
| Clear, narrow feature or workflow | 2 | 2-4 |
| Normal product, engineering, or agent workflow idea | 3 | 3-6 |
| Vague, high-leverage, architectural, or skill-design idea | 5 | 5-8 |
| High-risk data, security, migration, cross-system, or AI behavior change | 6 | 6-10 |
| User is still discovering what they mean | Use convergence checks until the coverage gate passes or the user chooses a partial draft | variable |

The agent must judge coverage after every answer. The agent may draft only after the Readiness Gate passes.

---

# Workflow

## 1. Recover context

Run lightweight context recovery before asking questions:

```bash
find docs/guanfu -maxdepth 3 -type f -name '*.md' 2>/dev/null | sort | tail -80
[ -f AGENTS.md ] && sed -n '1,220p' AGENTS.md
[ -f agents.md ] && sed -n '1,220p' agents.md
git log --oneline -20 2>/dev/null || true
```

Read related brainstorms, plans, reviews, ADRs, compound notes, and evolution notes when they exist.

Summarize relevant context in two to five bullets:

```markdown
## Context Recovered
- <relevant prior artifact or repo signal>
- <relevant constraint or pattern>
- <relevant lesson from compound/evolution notes>
```

If no context exists, state: `No prior GuanFu context found.`

### Code explore for repo-bound ideas

For engineering, architecture, agent workflow, and skill-design ideas inside a repo, dispatch a read-only code explore subagent before final alternatives.

Subagent prompt:

```text
You are exploring repository context for a GuanFu brainstorm.
Read only. Identify existing files, patterns, constraints, APIs, tests, docs, review artifacts, and risks related to this idea.
Return:
1. Relevant files or docs
2. Current behavior or workflow
3. Likely constraints
4. Questions the brainstorm should answer before planning
5. Risks that should appear in the brainstorm artifact
```

Use the findings to improve the coverage matrix and options.

## 2. Classify the idea type

Classify the request before asking deeper questions. This determines which gaps matter most.

| Idea type | Primary risk | Strong question bias |
|---|---|---|
| Product idea | Building for an imaginary user | user, demand, status quo, success |
| Engineering feature | Scope drift or hidden edge cases | constraints, interfaces, verification |
| Architecture | Premature commitment | tradeoffs, reversibility, migration risk |
| Agent workflow / skill | Shallow process that agents misread | failure modes, gates, artifacts, pressure scenarios |
| Internal process | Ceremony with weak leverage | decision points, documents, feedback loops |
| Research / exploration | Vague success criteria | learning goal, stopping rule, evidence |

Write the classification in the brainstorm document later.

## 3. Maintain the Brainstorm Coverage Matrix

The agent must keep this matrix during the session. Scores are updated after every user answer.

Score meanings:

| Score | Meaning |
|---:|---|
| 0 | Missing |
| 1 | Vague or slogan-level |
| 2 | Concrete enough to guide planning |
| 3 | Concrete, evidenced, and includes boundaries or examples |

Coverage fields:

| Field | Question it answers | Critical? |
|---|---|---|
| Outcome | What visible change should exist after this works? | Yes |
| Actor | Who or what uses this first? | Yes |
| Pain / Job | What current pain, job, or confusion does this solve? | Yes |
| Status Quo | What happens today? | Yes for product/process, optional for narrow code changes |
| Constraints | What must stay stable: API, UX, cost, data, latency, safety, compatibility? | Yes |
| AI Failure Eliminated | Which AI problem is this designed to reduce? | Yes for GuanFu, agent, process, and skill work |
| AI Leverage Amplified | Which AI capability or leverage point does this unlock? | Yes for GuanFu, agent, process, and skill work |
| Failure Modes | How could AI, users, or code misuse this? | Yes for agent/process/skill work |
| Success Criteria | What observable evidence proves this worked? | Yes |
| Taste Bar | What technically working result would still feel low quality? | Yes |
| Alternatives | What different paths exist, and why choose one? | Yes |
| Scope Boundary | What belongs in this version, and what moves later? | Yes |
| Artifact / Memory | What document or durable state lets the next agent continue safely? | Yes for GuanFu workflows |
| Evolution Signal | What future signal should trigger skill or process revision? | Yes for skill/process work |
| Plan Handoff | What would `/gf-plan` need to slice the work? | Yes |

Treat inferred facts as `Assumption`. Ask when an assumption drives a plan-level decision.

## 4. Ask loop

Ask one main question through AskUserQuestion. Use multiple-choice questions when the user is stuck or the domain is broad.

Select the next question by this priority order:

1. A critical field has score 0.
2. A critical field has score 1 and would cause a weak plan.
3. A hidden assumption could change the architecture, slice order, review criteria, or future skill behavior.
4. The user used a vague quality word such as “better,” “smart,” “simple,” “automatic,” “robust,” or “AI-native.”
5. The next stage lacks enough information to create slices.
6. The AI failure eliminated or AI leverage amplified is unclear.
7. The taste bar is unclear.

After each user answer:

1. Update the coverage matrix internally.
2. Decide whether to continue asking, present alternatives, run code explore, or run the readiness check.
3. Ask the next highest-leverage question when the gate has more gaps.

After every 3 answered question turns, provide a short convergence summary before the next question:

```markdown
## Convergence Check
Clear now:
- <field>: <summary>
- <field>: <summary>

Still weak:
- <field>: <why it matters>

Coverage snapshot:
| Field | Score | Note |
|---|---:|---|
| <field> | <0-3> | <note> |

Next highest-leverage question:
<one question>
```

### Fully specified input fast path

The agent may skip most questioning only when the user’s initial message already provides concrete answers for all critical fields with no plan-changing ambiguity.

Before using the fast path, print a coverage check showing every critical field at score 2 or higher.

### User speed override

If the user asks to “just draft,” “skip questions,” or move quickly:

1. Identify the two highest-risk missing fields.
2. Ask one final combined decision question with options.
3. Write a `Readiness: PARTIAL` draft if the user still chooses speed.
4. Put unresolved gaps in `## Open Questions` and `## Planning Risks`.

## 5. Readiness Gate

Before writing any brainstorm document, run this visible check:

```markdown
## Brainstorm Coverage Check
Question turns answered: <N>
Question-turn floor for this scope: <N>

| Field | Score | Evidence | Gap |
|---|---:|---|---|
| Outcome | <0-3> | <what the user said> | <gap or clear> |
| Actor | <0-3> | <what the user said> | <gap or clear> |
| Pain / Job | <0-3> | <what the user said> | <gap or clear> |
| Status Quo | <0-3> | <what the user said> | <gap or clear> |
| Constraints | <0-3> | <what the user said> | <gap or clear> |
| AI Failure Eliminated | <0-3> | <what the user said> | <gap or clear> |
| AI Leverage Amplified | <0-3> | <what the user said> | <gap or clear> |
| Failure Modes | <0-3> | <what the user said> | <gap or clear> |
| Success Criteria | <0-3> | <what the user said> | <gap or clear> |
| Taste Bar | <0-3> | <what the user said> | <gap or clear> |
| Alternatives | <0-3> | <what the user said> | <gap or clear> |
| Scope Boundary | <0-3> | <what the user said> | <gap or clear> |
| Artifact / Memory | <0-3> | <what the user said> | <gap or clear> |
| Evolution Signal | <0-3> | <what the user said> | <gap or clear> |
| Plan Handoff | <0-3> | <what the user said> | <gap or clear> |

Decision: CONTINUE_ASKING | RUN_CODE_EXPLORE | PRESENT_ALTERNATIVES | WRITE_DRAFT | WRITE_PARTIAL_DRAFT
Reason: <one sentence>
```

Gate rules:

- `CONTINUE_ASKING`: question-turn floor has not been met, any critical field is 0, or any plan-changing critical field is 1.
- `RUN_CODE_EXPLORE`: repo-bound idea needs codebase evidence before options become credible.
- `PRESENT_ALTERNATIVES`: all critical fields are at least 2, the question-turn floor is satisfied, and alternatives have not been compared yet.
- `WRITE_DRAFT`: all critical fields are at least 2, the question-turn floor is satisfied, alternatives are compared, and the agent can describe a usable handoff to `/gf-plan`.
- `WRITE_PARTIAL_DRAFT`: the user explicitly chose speed and accepted known gaps.

The readiness check prevents premature drafting after a single shallow answer.

## 6. Question families

Use these families dynamically. Pick the question that improves the weakest critical field.

| Family | Goal | Example question |
|---|---|---|
| Outcome | Name the visible result | “When this works, what becomes easier, faster, safer, or impossible to ignore?” |
| Actor | Find the first real user or system actor | “Who or what uses this first: a developer, reviewer, agent, CLI, CI job, customer, or internal operator?” |
| Pain / Job | Find the job-to-be-done | “What problem keeps recurring even when people are trying to do the right thing?” |
| Status quo | Reveal the current workaround | “What happens today before this idea exists?” |
| Evidence | Separate signal from imagination | “What have you seen that proves this matters?” |
| Constraint | Find boundaries | “What must stay stable: API, UX, data model, latency, cost, migration risk, or team workflow?” |
| AI failure | Make the AI problem explicit | “Which AI failure should this eliminate first: shallow questioning, premature draft, context loss, weak review, repeated mistake, or low taste?” |
| AI leverage | Make the upside explicit | “Which AI leverage should this amplify: option generation, synthesis, code exploration, review, memory, or iteration?” |
| Failure mode | Make misuse visible | “How would an agent likely mess this up if the skill were vague?” |
| Success | Define observable done | “What evidence would convince you this worked in a real repo or real session?” |
| Taste | Clarify quality | “What would make you reject a technically working version as low taste?” |
| Artifact | Preserve memory | “What must be written down so the next agent can continue without rediscovering context?” |
| Evolution | Keep the skill alive | “What signal should trigger a future update to this skill?” |
| Slice readiness | Prepare `/gf-plan` | “What is the smallest slice that creates real learning or value?” |

## 7. Present alternatives

Once the readiness gate reaches `PRESENT_ALTERNATIVES`, offer two or three distinct approaches.

Required format:

```text
APPROACH A: Minimal viable slice
Summary: <smallest useful version>
Best when: <condition>
Risk: <main tradeoff>

APPROACH B: Stronger long-term architecture
Summary: <more durable version>
Best when: <condition>
Risk: <main tradeoff>

APPROACH C: Lateral or stricter path
Summary: <different framing or stronger gate>
Best when: <condition>
Risk: <main tradeoff>

RECOMMENDATION: Choose <A/B/C> because <one concrete reason>.
```

Ask the user to choose or revise the approach. After the user chooses, run the Readiness Gate again. If the selected approach exposes a new critical gap, resume the ask loop.

## 8. Write the brainstorm document

Create the artifact only after `WRITE_DRAFT` or `WRITE_PARTIAL_DRAFT`.

Use this structure:

```markdown
# Brainstorm: <title>

Generated: <ISO timestamp>
Status: DRAFT
Readiness: COMPLETE | PARTIAL
Source: <original prompt or link>
Idea Type: <product | engineering | architecture | agent-workflow | process | research | skill>

## Raw Idea
<the user’s original framing>

## Reframed Idea
<clearer framing after questioning>

## Context Recovered
- <prior artifact / repo signal / none>

## Question Trace
| Turn | Question | User Signal | Coverage Improved |
|---:|---|---|---|

## Coverage Report
| Field | Score | Evidence | Remaining Gap |
|---|---:|---|---|

## GuanFu Value Mapping
| Value | Specific meaning in this brainstorm |
|---|---|
| AI failure eliminated | <concrete failure mode> |
| AI leverage amplified | <concrete leverage point> |
| AI potential unlocked | <what becomes possible after this is systematized> |

## Target Actor
<first user, system actor, or agent>

## Pain or Job
<actual job or problem>

## Current Workaround / Status Quo
<what happens today>

## Constraints
<technical, product, workflow, safety, cost, time, compatibility>

## Failure Modes
<how AI, users, or implementation could go wrong>

## Success Criteria
<observable evidence>

## Taste Bar
<quality threshold and rejection criteria>

## Premises
- <premise> — Evidence: <user signal or assumption>

## Options Considered
### Approach A: <name>
### Approach B: <name>
### Approach C: <name, optional>

## Recommended Direction
<chosen direction and why>

## Scope Boundary
### In scope
- <item>

### Later
- <item>

## Planning Risks
<especially important for PARTIAL drafts>

## Open Questions
<questions that remain, or “None that block planning.”>

## Handoff to Plan
Next skill: /gf-plan
Plan should produce slices around:
1. <slice area>
2. <slice area>
3. <slice area>

## Skill Feedback
<If the user corrected the brainstorm process, capture the improvement request here for /gf-evolve.>
```

## 9. Approval gate

After writing the artifact, ask whether to mark it as `APPROVED`.

Options:

```text
A) Approve and continue to /gf-plan
B) Revise specific sections
C) Keep as draft and stop
```

If approved, update `Status: APPROVED` in the artifact and recommend `/gf-plan`.

## 10. Evolution hook

If the user says the brainstorm process asked too few questions, asked weak questions, drafted too early, missed a category, or felt shallow, capture that feedback in the brainstorm artifact under `## Skill Feedback`.

If `/gf-evolve` exists, recommend evolving this skill with that concrete feedback.

---

# Common Failure Modes

| Failure | Why it hurts | Correct behavior |
|---|---|---|
| Drafting after one shallow answer | The document becomes a polished guess | Run the question-turn floor and coverage gate |
| Asking a fixed checklist mechanically | The conversation feels bureaucratic | Ask the highest-leverage next question based on coverage |
| Treating vague words as clear | Plan inherits ambiguity | Ask for examples, failure cases, or rejection criteria |
| Inferring missing facts silently | The plan appears confident while built on guesses | Mark assumptions and ask when they change scope or architecture |
| Offering only one approach | User loses useful tradeoff pressure | Present at least two distinct approaches before recommendation |
| Letting Open Questions hide weak thinking | Planning starts with unresolved basics | Critical fields need score 2+ for `COMPLETE` readiness |
| Missing GuanFu value mapping | The skill becomes ceremony | Name the AI failure eliminated and AI leverage amplified |
| Missing evolution signal | The skill stays static | Capture what future feedback should trigger `/gf-evolve` |

# Completion Report

Use this final format:

```text
STATUS: DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT
ARTIFACT: docs/guanfu/brainstorms/YYYY-MM-DD-HHMM-<slug>.md
READINESS: COMPLETE | PARTIAL
QUESTIONS_ASKED: <count>
COVERAGE: <critical fields ready>/<critical fields total>
NEXT: /gf-plan, revise, /gf-evolve, or stop
```
