#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=0
FORCE=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    --force) FORCE=1; shift ;;
    -h|--help)
      cat <<'HELP'
Usage: gf-init.sh [--dry-run] [--force]

Creates the GuanFu AI engineering docs contract:
  AGENTS.md / agents.md router section
  docs/guanfu/context, brainstorms, plans, reviews/code, reviews/docs,
  docs/guanfu/adr, compound, standards, evolution
  templates for brainstorm, plan/work, reviews, ADR, compound notes, evolution notes

Product code stays untouched.
HELP
      exit 0
      ;;
    *) echo "Unknown argument: $1" >&2; exit 2 ;;
  esac
done

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

say() { printf '%s\n' "$*"; }
run() {
  if [[ "$DRY_RUN" == "1" ]]; then
    say "DRY-RUN: $*"
  else
    eval "$@"
  fi
}

write_file() {
  local path="$1"
  local body="$2"
  if [[ -f "$path" && "$FORCE" != "1" ]]; then
    say "SKIP existing: $path"
    return 0
  fi
  if [[ "$DRY_RUN" == "1" ]]; then
    say "DRY-RUN: write $path"
  else
    mkdir -p "$(dirname "$path")"
    printf '%s\n' "$body" > "$path"
    say "WROTE: $path"
  fi
}

append_if_missing() {
  local path="$1"
  local marker="$2"
  local body="$3"
  if [[ -f "$path" ]] && grep -qF "$marker" "$path"; then
    say "SKIP marker exists in $path: $marker"
    return 0
  fi
  if [[ "$DRY_RUN" == "1" ]]; then
    say "DRY-RUN: append $marker to $path"
  else
    mkdir -p "$(dirname "$path")"
    [[ -f "$path" ]] || touch "$path"
    printf '\n%s\n' "$body" >> "$path"
    say "UPDATED: $path"
  fi
}

say "GuanFu init root: $ROOT"

for d in \
  docs/guanfu/context \
  docs/guanfu/brainstorms \
  docs/guanfu/plans \
  docs/guanfu/reviews/code \
  docs/guanfu/reviews/docs \
  docs/guanfu/adr \
  docs/guanfu/compound \
  docs/guanfu/standards \
  docs/guanfu/evolution; do
  run "mkdir -p '$d'"
done

AGENTS_FILE="AGENTS.md"
if [[ -f agents.md && ! -f AGENTS.md ]]; then
  AGENTS_FILE="agents.md"
fi

if [[ ! -f "$AGENTS_FILE" ]]; then
  write_file "$AGENTS_FILE" "# Agent Instructions

This repository uses GuanFu. Documents under docs/guanfu/ are source of truth for AI work."
fi

append_if_missing "$AGENTS_FILE" "## GuanFu Router" "## GuanFu Router

Use these skills before answering directly when the request matches:

- New repo, missing docs harness, missing routing, or first-time setup -> \`/gf-init\`
- New idea, unclear requirement, feature concept, product thought, or \"help me think\" -> \`/gf-brainstorm\`
- Approved brainstorm, implementation plan, architecture, slices, milestones -> \`/gf-plan\`
- Active plan exists and user asks to implement, continue, build, fix, or work -> \`/gf-work\`
- Code changed, tests changed, diff changed, or implementation evidence needs review -> \`/gf-code-review\`
- Brainstorm, plan, ADR, review, compound, AGENTS routing, or handoff docs need review -> \`/gf-doc-review\`
- A mistake, repeated failure, bad assumption, missed edge case, flaky workflow, or review pattern appears -> \`/gf-compound\`
- A GuanFu skill, template, router, pressure scenario, or standard needs improvement -> \`/gf-evolve\`

Default rule: create or update the stage document before coding."

append_if_missing "$AGENTS_FILE" "## GuanFu Taste" "## GuanFu Taste

- Values: reduce AI collaboration failure modes and amplify AI leverage.
- Documents are project memory. Put durable context in \`docs/guanfu/\`.
- Brainstorm before plan. Plan before work. Review before ship. Compound after mistakes.
- Use small verifiable slices. Keep exactly one active slice in a plan.
- Plan and Work share one living plan document.
- A slice completes after verification evidence is recorded.
- Architecture decisions that are hard to reverse need an ADR in \`docs/guanfu/adr/\`.
- Review captures patterns and user impact.
- Mistakes become guardrails: tests, checklist changes, AGENTS updates, ADRs, template edits, or skill evolution.
- Skills are living artifacts. Real failures should update skills, templates, pressure scenarios, or router rules through \`gf-evolve\`."

write_file "docs/guanfu/README.md" "# GuanFu Docs

AI work in this repository is organized as durable documents.

## Directory Contract

- \`context/\` records code exploration and project maps.
- \`brainstorms/\` records idea clarification before planning.
- \`plans/\` stores plan/work documents. Each active plan has one active slice.
- \`reviews/code/\` stores code review outputs.
- \`reviews/docs/\` stores document and handoff review outputs.
- \`adr/\` stores architecture decisions with high reversal cost.
- \`compound/\` stores lessons, mistakes, guardrails, and reusable knowledge.
- \`standards/\` stores review rubrics and taste constraints.
- \`evolution/\` stores skill evolution notes and pressure test results.

Documents are source of truth for future agents.

## Code Explore Reports

Add first report here:

- \`context/code-explore-YYYY-MM-DD.md\`
"

write_file "docs/guanfu/context/README.md" "# Code Context

Store baseline and targeted code exploration reports here.

Naming:

\`code-explore-YYYY-MM-DD.md\`

Each report should include repo purpose, architecture, test commands, key directories, risk areas, patterns to reuse, and documentation gaps."

write_file "docs/guanfu/context/CODE_EXPLORE_TEMPLATE.md" "# Code Explore: <scope>

Date: <YYYY-MM-DD>
Branch: <branch>
Explorer: <agent>

## Repo Purpose

## Stack

## Directory Map

## Important Entry Points

## Test and Verification Commands

## Existing Documentation

## Risk Areas

## Patterns to Reuse

## Gaps and Follow-ups

## Recommended Next GuanFu Skill
"

write_file "docs/guanfu/brainstorms/BRAINSTORM_TEMPLATE.md" "# Brainstorm: <title>

Status: DRAFT
Date: <YYYY-MM-DD>
Owner: <name or agent>
Source: <original prompt or link>

## Raw Idea

## Reframed Idea

## User / Customer / Actor

## Pain or Job

## Current Workaround / Status Quo

## Constraints

## Options Considered

| Option | Description | Pros | Cons | Decision |
|---|---|---|---|---|
| A | | | | |
| B | | | | |
| C | | | | |

## Recommended Direction

## Premises

1.
2.
3.

## Success Criteria

## Non-goals

## Open Questions

## Handoff to Plan

Next skill: /gf-plan
"

write_file "docs/guanfu/plans/PLAN_TEMPLATE.md" "# Plan: <title>

Plan Status: ACTIVE
Active Slice: S1
Date: <YYYY-MM-DD>
Source Brainstorm: <path>
Related ADRs: <paths>
Related Compound Notes: <paths>
Related Evolution Notes: <paths>

## Goal

## Constraints

## Architecture Summary

## Slice Index

| Slice | Status | Goal | Files / Areas | Test First | Verification | Notes |
|---|---|---|---|---|---|---|
| S1 | ACTIVE | | | | | |
| S2 | TODO | | | | | |

Status values: TODO, ACTIVE, COMPLETED, DEFERRED, BLOCKED.

## Slices

### S1: <name>

Status: ACTIVE

#### User-visible outcome

#### Scope

#### Out of scope

#### Files / APIs expected to change

#### RED tests

#### Implementation notes

#### Verification commands

#### Completion evidence

## Implementation Log

Append entries during /gf-work.

## Code Review Log

Append links to /gf-code-review outputs.

## Doc Review Log

Append links to /gf-doc-review outputs.
"

write_file "docs/guanfu/adr/0000-template.md" "# ADR: <decision>

Status: DRAFT
Date: <YYYY-MM-DD>
Plan: <path>

## Context

## Decision

## Alternatives Considered

| Alternative | Pros | Cons | Why not selected |
|---|---|---|---|

## Consequences

## Reversal Cost

## Follow-up Work
"

write_file "docs/guanfu/reviews/code/CODE_REVIEW_TEMPLATE.md" "# Code Review: <title>

Status: DRAFT
Date: <YYYY-MM-DD>
Plan: <path>
Diff Range: <base..head>
Reviewer: <agent/human>

## Code Explore Summary

## Review Verdict

PASS / PASS_WITH_FIXES / BLOCKED

## Findings

| ID | Severity | Area | Evidence | Pattern | User Impact | Recommended Fix |
|---|---|---|---|---|---|---|

Severity values: BLOCKER, FIX, TASTE, NIT.

## Tests Reviewed

## Scope Drift

## ADR Notes

## Follow-up Compound Notes
"

write_file "docs/guanfu/reviews/docs/DOC_REVIEW_TEMPLATE.md" "# Document Review: <title>

Status: DRAFT
Date: <YYYY-MM-DD>
Target Docs: <paths>
Reviewer: <agent/human>

## Verdict

PASS / PASS_WITH_FIXES / BLOCKED

## Checks

| Check | Result | Notes |
|---|---|---|
| Source of truth explicit | | |
| ACTIVE / COMPLETED state clear | | |
| Slices independently executable | | |
| Acceptance criteria testable | | |
| ADRs present for hard-to-reverse decisions | | |
| No vague placeholders | | |
| Verification commands present | | |
| Handoff works for a fresh agent | | |

## Findings

## Required Edits
"

write_file "docs/guanfu/compound/COMPOUND_NOTE_TEMPLATE.md" "# Compound Note: <lesson>

Date: <YYYY-MM-DD>
Source: <plan/review/test/failure>
Type: mistake | pattern | preference | architecture | testing | process | tool | docs | taste | skill
Confidence: <1-10>

## What Happened

## Evidence

## Root Cause

## Why It Was Missed

## Guardrail

Choose one or more:

- Test added:
- Checklist changed:
- AGENTS.md rule added:
- ADR written:
- Skill evolution proposed:
- Review rubric updated:

## How Future Agents Should Use This

## Links
"

write_file "docs/guanfu/compound/index.md" "# GuanFu Compound Index

Append links to compound notes here.

| Date | Type | Lesson | Guardrail | Source |
|---|---|---|---|---|
"

write_file "docs/guanfu/evolution/EVOLUTION_TEMPLATE.md" "# GuanFu Evolution: <change>

Date: <YYYY-MM-DD>
Status: PROPOSED | APPLIED | SUPERSEDED
Target Skill: <gf-skill>
Source:
- <compound note / review / user feedback / pressure scenario>

## Trigger

## Observed Failure

## Expected Behavior

## Root Cause

## Proposed Patch

## Pressure Scenario

## Validation

## Release Note
"

write_file "docs/guanfu/standards/review-rubric.md" "# GuanFu Review Rubric

Use this during /gf-code-review and /gf-doc-review.

## Code Review

- Spec compliance: does the implementation match the active plan slice?
- Correctness: edge cases, errors, retries, empty states, concurrency, data loss.
- Tests: RED witnessed, meaningful assertions, failure modes covered, focused mocks.
- Architecture: clear boundaries, low coupling, explicit state, reversible decisions.
- Security and trust: auth, permissions, injection, secrets, unsafe output, data exposure.
- Taste: smaller API, simpler names, fewer moving parts, readable future diffs.

## Document Review

- Documents provide enough context for a fresh agent to continue.
- Active and completed states are explicit.
- Slices have tests and verification commands.
- ADR exists for high-reversal-cost choices.
- Open questions are real blockers with owners or resolution paths.

## Evolution Review

- Failure behavior is concrete.
- Expected behavior is observable.
- The proposed patch changes the smallest necessary surface.
- A pressure scenario exists before the skill update lands.
"

say "DONE: GuanFu docs initialized."
say "NEXT: run /gf-init code explore step and save docs/guanfu/context/code-explore-YYYY-MM-DD.md"
