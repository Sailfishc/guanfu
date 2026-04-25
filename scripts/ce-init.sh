#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=0
FORCE=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    --force) FORCE=1; shift ;;
    -h|--help)
      cat <<'EOF'
Usage: ce-init.sh [--dry-run] [--force]

Creates the compound engineering docs contract:
  AGENTS.md / agents.md router section
  docs/context, docs/brainstorm, docs/plans, docs/reviews, docs/adr, docs/compound, docs/standards
  templates for brainstorm, plan/work, reviews, ADR, compound notes

No product code is changed.
EOF
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

say "Compound engineering init root: $ROOT"

for d in \
  docs/context \
  docs/brainstorm \
  docs/plans \
  docs/reviews \
  docs/adr \
  docs/compound \
  docs/standards; do
  run "mkdir -p '$d'"
done

AGENTS_FILE="AGENTS.md"
if [[ -f agents.md && ! -f AGENTS.md ]]; then
  AGENTS_FILE="agents.md"
fi

if [[ ! -f "$AGENTS_FILE" ]]; then
  write_file "$AGENTS_FILE" "# Agent Instructions

This repository uses compound engineering. Documents under docs/ are source of truth for AI work."
fi

append_if_missing "$AGENTS_FILE" "## Compound Engineering Router" "## Compound Engineering Router

Use these skills before answering directly when the request matches:

- New idea, unclear requirement, feature concept, product thought, or \"help me think\" -> \`/ce-brainstorm\`
- Approved brainstorm, user asks for implementation plan, architecture, slices, milestones -> \`/ce-plan\`
- Active plan exists and user asks to implement, continue, build, fix, or work -> \`/ce-work\`
- Code changed or user asks for review -> \`/ce-code-review\`
- Brainstorm, plan, ADR, review, or compound docs need checking -> \`/ce-doc-review\`
- A mistake, repeated failure, bad assumption, missed edge case, flaky workflow, or review pattern appears -> \`/ce-compound\`

Default rule: if there is no current document for the stage, create or update the document before coding."

append_if_missing "$AGENTS_FILE" "## Compound Engineering Taste" "## Compound Engineering Taste

- 80% planning and review, 20% execution.
- Brainstorm before plan. Plan before work. Review before ship. Compound after mistakes.
- Documents are source of truth. Chat memory is not source of truth.
- Prefer small verifiable slices over large vague milestones.
- Plan and Work share one plan document. Work updates slice status and verification evidence.
- A slice is not complete until tests or explicit verification evidence are recorded.
- Architecture decisions that are hard to reverse need an ADR in \`docs/adr/\`.
- Code review must name the pattern, not only the bug.
- Mistakes must become guardrails: tests, checklist changes, AGENTS.md updates, ADRs, or skill patches.
- Keep quality high so future changes stay cheap."

write_file "docs/README.md" "# Compound Engineering Docs

AI work in this repository is organized as durable documents.

## Directory Contract

- \`context/\` records code exploration and project maps.
- \`brainstorm/\` records idea clarification before planning.
- \`plans/\` stores plan/work documents. Each active plan has one active slice.
- \`reviews/\` stores code and document review outputs.
- \`adr/\` stores architecture decisions that are hard to reverse.
- \`compound/\` stores lessons, mistakes, guardrails, and reusable knowledge.
- \`standards/\` stores review rubrics and taste constraints.

Documents are source of truth. Chat history is not."

write_file "docs/context/README.md" "# Code Context

Store baseline and targeted code exploration reports here.

Naming:

\`code-explore-YYYY-MM-DD.md\`

Each report should include repo purpose, architecture, test commands, key directories, risk areas, patterns to reuse, and documentation gaps."

write_file "docs/brainstorm/BRAINSTORM_TEMPLATE.md" "# Brainstorm: <title>

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

Next skill: /ce-plan
"

write_file "docs/plans/PLAN_TEMPLATE.md" "# Plan: <title>

Plan Status: ACTIVE
Active Slice: S1
Date: <YYYY-MM-DD>
Source Brainstorm: <path>
Related ADRs: <paths>

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

Append entries during /ce-work.

## Review Log

Append links to /ce-code-review and /ce-doc-review outputs.
"

write_file "docs/adr/0000-template.md" "# ADR: <decision>

Status: DRAFT
Date: <YYYY-MM-DD>
Plan: <path>

## Context

## Decision

## Alternatives Considered

| Alternative | Pros | Cons | Why not |
|---|---|---|---|

## Consequences

## Reversal Cost

## Follow-up Work
"

write_file "docs/reviews/CODE_REVIEW_TEMPLATE.md" "# Code Review: <title>

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

## Follow-up Compound Notes
"

write_file "docs/reviews/DOC_REVIEW_TEMPLATE.md" "# Document Review: <title>

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
| No TBD / vague language | | |
| Verification commands present | | |

## Findings

## Required Edits
"

write_file "docs/compound/COMPOUND_NOTE_TEMPLATE.md" "# Compound Note: <lesson>

Date: <YYYY-MM-DD>
Source: <plan/review/test/failure>
Type: mistake | pattern | preference | architecture | testing | process | tool | docs | taste
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
- Skill patch proposed:
- Review rubric updated:

## How Future Agents Should Use This

## Links
"

write_file "docs/compound/index.md" "# Compound Engineering Index

Append links to compound notes here.

| Date | Type | Lesson | Guardrail | Source |
|---|---|---|---|---|
"

write_file "docs/standards/review-rubric.md" "# Review Rubric

Use this during /ce-code-review and /ce-doc-review.

## Code Review

- Spec compliance: does the implementation match the active plan slice?
- Correctness: edge cases, errors, retries, empty states, concurrency, data loss.
- Tests: RED witnessed, meaningful assertions, failure modes covered, no brittle mocks.
- Architecture: clear boundaries, no unnecessary coupling, no hidden global state.
- Security and trust: auth, permissions, injection, secrets, unsafe output, data exposure.
- Taste: smaller API, simpler names, fewer moving parts, readable future diffs.

## Document Review

- Documents are enough for a fresh agent to continue without chat context.
- Active and completed states are explicit.
- Slices have tests and verification commands.
- ADR exists for hard-to-reverse choices.
- Open questions are real blockers, not vague placeholders.
"

say "DONE: compound engineering docs initialized."
say "NEXT: run /ce-init code explore step and save docs/context/code-explore-YYYY-MM-DD.md"
