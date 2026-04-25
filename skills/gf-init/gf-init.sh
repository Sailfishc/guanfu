#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=0
FORCE=0
MODE="new"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    --force) FORCE=1; shift ;;
    --new) MODE="new"; shift ;;
    --refresh) MODE="refresh"; shift ;;
    --audit) MODE="audit"; shift ;;
    -h|--help)
      cat <<'HELP'
Usage: gf-init.sh [--new|--refresh|--audit] [--dry-run] [--force]

Creates or refreshes the GuanFu AI engineering harness:
  AGENTS.md / agents.md router and taste contract
  docs/guanfu/ context, brainstorms, plans, reviews, ADRs, compound, standards, evolution
  templates aligned with the current GuanFu skill package

Modes:
  --new       first-time initialization, default
  --refresh   refresh router/templates/docs contract, preserving existing files unless --force
  --audit     print missing or stale harness elements only

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

audit() {
  local missing=0
  local required_dirs=(
    docs/guanfu/context
    docs/guanfu/brainstorms
    docs/guanfu/plans
    docs/guanfu/reviews/code
    docs/guanfu/reviews/docs
    docs/guanfu/adr
    docs/guanfu/compound
    docs/guanfu/standards
    docs/guanfu/evolution
  )
  for d in "${required_dirs[@]}"; do
    if [[ -d "$d" ]]; then
      say "OK dir: $d"
    else
      say "MISSING dir: $d"
      missing=1
    fi
  done
  local agents="AGENTS.md"
  [[ -f agents.md && ! -f AGENTS.md ]] && agents="agents.md"
  if [[ -f "$agents" ]] && grep -q "## GuanFu Router" "$agents"; then
    say "OK router: $agents"
  else
    say "MISSING router: $agents"
    missing=1
  fi
  if [[ -f "$agents" ]] && grep -q "AUTOMATED_AFTER_PLAN" "$agents"; then
    say "OK harness contract: $agents"
  else
    say "MISSING harness contract: $agents"
    missing=1
  fi
  if [[ -f docs/guanfu/compound/index.md ]]; then
    say "OK compound index: docs/guanfu/compound/index.md"
  else
    say "MISSING compound index: docs/guanfu/compound/index.md"
    missing=1
  fi
  return "$missing"
}

if [[ "$MODE" == "audit" ]]; then
  audit
  exit $?
fi

say "GuanFu init root: $ROOT"
say "Mode: $MODE"

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
- A GuanFu skill, template, router, pressure scenario, validation script, or standard needs improvement -> \`/gf-evolve\`

Default sequence:

\`gf-init -> gf-brainstorm -> gf-plan -> gf-work -> gf-code-review -> gf-doc-review -> gf-compound -> gf-evolve when needed\`"

append_if_missing "$AGENTS_FILE" "## GuanFu Harness Contract" "## GuanFu Harness Contract

- Human loop stages: \`gf-brainstorm\` and \`gf-plan\`. Use these stages to align goal, constraints, success criteria, failure modes, and taste.
- Automated stages: \`gf-work\`, \`gf-code-review\`, \`gf-doc-review\`, \`gf-compound\`, and \`gf-evolve\`. After plan approval, proceed through the chain without mid-execution user prompts.
- Approved plans should include \`Execution Mode: AUTOMATED_AFTER_PLAN\`.
- During automated execution, record anomalies, make the smallest safe decision, and let review/compound/evolve calibrate afterward.
- First failure is a signal. Repeated failure is a harness gap. Record both."

append_if_missing "$AGENTS_FILE" "## GuanFu Taste" "## GuanFu Taste

- Values: reduce AI collaboration failure modes and amplify AI leverage.
- Documents are project memory. Put durable context in \`docs/guanfu/\`.
- Brainstorm before plan. Plan before work. Review after work. Compound after mistakes. Evolve after repeated or process-level failure.
- Use small verifiable slices. Keep exactly one active slice in a plan.
- Plan and Work share one living plan document.
- A slice completes after fresh verification evidence is recorded after the final code change.
- Architecture decisions that are hard to reverse need an ADR in \`docs/guanfu/adr/\`.
- Review captures patterns, user impact, and future guardrails.
- Mistakes become guardrails: tests, scripts, checklist changes, AGENTS updates, ADRs, template edits, or skill evolution.
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

## Harness Contract

Human loop: \`gf-brainstorm\` and \`gf-plan\`.

Automated chain after approved plan: \`gf-work -> gf-code-review -> gf-doc-review -> gf-compound -> gf-evolve when needed\`.

First failure creates signal. Repeated failure triggers evolution."

write_file "docs/guanfu/context/README.md" "# Code Context

Store baseline and targeted code exploration reports here.

Naming:

\`code-explore-YYYY-MM-DD-HHMM.md\`

Each report should include repo purpose, architecture, test commands, key directories, risk areas, patterns to reuse, and documentation gaps."

write_file "docs/guanfu/context/CODE_EXPLORE_TEMPLATE.md" "# Code Explore: <scope>

Date: <ISO timestamp>
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

Generated: <ISO timestamp>
Status: DRAFT | APPROVED | SUPERSEDED
Readiness: COMPLETE | PARTIAL
Source: <original prompt or link>
Idea Type: <product | engineering | architecture | agent-workflow | process | research | skill>

## Raw Idea

## Reframed Idea

## Context Recovered

## Question Trace

| Turn | Question | User Signal | Coverage Improved |
|---:|---|---|---|

## Coverage Report

| Field | Score | Evidence | Remaining Gap |
|---|---:|---|---|

## GuanFu Value Mapping

| Value | Specific meaning in this brainstorm |
|---|---|
| AI failure eliminated | |
| AI leverage amplified | |
| AI potential unlocked | |

## Target Actor

## Pain or Job

## Current Workaround / Status Quo

## Constraints

## Failure Modes

## Success Criteria

## Taste Bar

## Premises

## Options Considered

## Recommended Direction

## Scope Boundary

### In scope

### Later

## Planning Risks

## Open Questions

## Handoff to Plan

Next skill: /gf-plan

## Skill Feedback
"

write_file "docs/guanfu/plans/PLAN_TEMPLATE.md" "# Plan: <title>

Generated: <ISO timestamp>
Plan Status: ACTIVE | PAUSED | COMPLETED | ABANDONED
Active Slice: S1 | none
Execution Mode: AUTOMATED_AFTER_PLAN
Source: <brainstorm path>
Previous Artifact: <path>
Next Artifact: /gf-work
Related ADRs: <paths>
Related Compound Notes: <paths>
Supersedes: <path or none>

## Goal

## Constraints

## Code Explore Summary

## ADR Decision Matrix

| Decision | Reversible? | Affects data? | Affects public API? | Cross-module? | New dependency? | ADR needed? |
|---|---|---|---|---|---|---|

## Slice Index

| Slice | Status | Risk | Outcome | Verification | Review Focus |
|---|---|---|---|---|---|
| S1 | ACTIVE | | | | |

## Slices

### Slice S1: <name>

Status: ACTIVE
Risk: LOW | MEDIUM | HIGH

#### Outcome

#### Entry Conditions

#### Scope

#### Out of Scope

#### Files / APIs Expected To Change

#### Test-First Plan

#### Verification Commands

#### Rollback / Revert Path

#### Review Focus

#### Compound Triggers

#### Exit Criteria

#### Completion Evidence

## Implementation Log

## Anomaly Log

## Code Review Log

## Doc Review Log

## Compound / Evolution Log
"

write_file "docs/guanfu/adr/0000-template.md" "# ADR: <decision>

Status: DRAFT | ACCEPTED | SUPERSEDED
Date: <ISO timestamp>
Plan: <path>
Supersedes: <path or none>

## Context

## Decision

## Alternatives Considered

| Alternative | Pros | Cons | Reversal Cost | Decision |
|---|---|---|---|---|

## Consequences

## Reversal Cost

## Verification

## Follow-up Work
"

write_file "docs/guanfu/reviews/code/CODE_REVIEW_TEMPLATE.md" "# Code Review: <title>

Status: DRAFT
Date: <ISO timestamp>
Plan: <path>
Slice: <slice>
Diff Range: <base..head or WORKTREE>
Reviewer: <agent>

## Review Scope Check

## Verification Freshness

| Evidence | Command | Claimed Result | Fresh After Last Code Change | Covers Exit Criteria | Verdict |
|---|---|---|---|---|---|

## Verdict

CLEAR | CLEAR_WITH_FOLLOWUPS | RETURN_TO_WORK | RETURN_TO_PLAN | COMPOUND_REQUIRED | EVOLVE_REQUIRED | BLOCKED

## Findings

## Scope Drift

## ADR Notes

## Compound Candidates

## Evolution Candidates

## Next Step
"

write_file "docs/guanfu/reviews/docs/DOC_REVIEW_TEMPLATE.md" "# Document Review: <title>

Status: DRAFT
Date: <ISO timestamp>
Target Docs: <paths>
Reviewer: <agent>

## Artifact Lineage

| Artifact | Links to previous stage | Links to next action | Status clear | Issue |
|---|---|---|---|---|

## Fresh Agent Handoff Test

| Question | Answerable? | Evidence |
|---|---|---|
| What is the current goal? | | |
| What is active? | | |
| What is completed? | | |
| What is blocked? | | |
| What files matter? | | |
| What verification evidence exists? | | |
| What should happen next? | | |

Verdict: PASS | PARTIAL | FAIL

## Safe Edits Applied

## Findings

## Required Edits

## Compound Candidates

## Evolution Candidates

## Next Step
"

write_file "docs/guanfu/compound/COMPOUND_NOTE_TEMPLATE.md" "# Compound Note: <lesson>

Date: <ISO timestamp>
Source: <plan/review/test/failure>
Type: mistake | pattern | preference | architecture | testing | process | tool | docs | taste | skill
Confidence: <1-10>

## What Happened

## Evidence

## Root Cause

## Why It Was Missed

## Failure Budget Status

Occurrence: FIRST_SEEN | REPEATED | UNKNOWN
Decision: RECORD_LESSON | STRENGTHEN_GUARDRAIL | ROUTE_TO_EVOLVE

## Reusable Rule

## Guardrail Decision

Chosen guardrail:
- [ ] Test
- [ ] Script
- [ ] Review checklist
- [ ] AGENTS rule
- [ ] ADR
- [ ] Template update
- [ ] Skill patch
- [ ] No guardrail, reason: <explicit reason>

Owner skill: <gf-skill or project-only>
Applied now: yes/no
Follow-up: <path or next skill>
Verification: <how future agents know this guardrail worked>

## Retrieval Metadata

Applies To:
- Skill:
- Stage:
- Files / Areas:
- Keywords:
- Trigger:

Supersedes: <path or none>
Related Notes:
- <path>

## How Future Agents Should Use This
"

write_file "docs/guanfu/compound/index.md" "# GuanFu Compound Index

| Date | Type | Lesson | Guardrail | Owner Skill | Trigger | Source |
|---|---|---|---|---|---|---|
"

write_file "docs/guanfu/evolution/EVOLUTION_TEMPLATE.md" "# GuanFu Evolution: <title>

Date: <ISO timestamp>
Status: PROPOSED | RED_RECORDED | APPLIED | VALIDATED | NEEDS_MORE_WORK | SUPERSEDED
Target Skill: <gf-skill>
Source Failure: <path or quote>
Source Compound Note: <path or none>
Supersedes: <path or none>

## Real Failure

## Baseline Pressure Scenario

## Baseline Agent Behavior

## Failure Pattern

## Patch

## Exact Text Changed

## Re-test Result

## Remaining Risk

## Changelog Entry

## Rollback Plan
"

write_file "docs/guanfu/standards/review-rubric.md" "# GuanFu Review Rubric

## Harness Principle

Before execution: discuss deeply through brainstorm and plan. During execution: follow the approved plan automatically. After execution: review, compound, and evolve.

## Code Review

- Spec compliance: implementation matches the active plan slice.
- Correctness: edge cases, errors, retries, empty states, concurrency, data loss.
- Verification freshness: commands ran after final code changes.
- Tests: meaningful assertions, failure modes covered, focused mocks.
- Architecture: clear boundaries, low coupling, explicit state, reversible decisions.
- Security and trust: auth, permissions, injection, secrets, unsafe output, data exposure.
- Taste: smaller API, simpler names, fewer moving parts, readable future diffs.

## Document Review

- Documents provide enough context for a fresh agent to continue.
- Active and completed states are explicit.
- Slices have tests, verification commands, rollback, and exit criteria.
- ADR exists for high-reversal-cost choices.
- Open questions are real blockers with owners or resolution paths.

## Evolution Review

- Failure behavior is concrete.
- Expected behavior is observable.
- The proposed patch changes the smallest necessary surface.
- A pressure scenario exists before the skill update lands.
- Retest result is recorded.
"

say "DONE: GuanFu docs initialized or refreshed."
say "NEXT: run /gf-init code explore step and save docs/guanfu/context/code-explore-YYYY-MM-DD-HHMM.md"
