#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-}"
if [ -z "$ROOT" ]; then
  ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
fi

mkdir -p "$ROOT"
cd "$ROOT"

mkdir -p \
  docs/ce/brainstorms \
  docs/ce/plans \
  docs/ce/reviews \
  docs/ce/compound \
  docs/ce/adr

if [ ! -f docs/ce/README.md ]; then
cat > docs/ce/README.md <<'EOF'
# Compound Engineering Harness

This directory is the project memory harness for AI-assisted engineering.

## Directories

- `brainstorms/`: idea clarification and premise documents.
- `plans/`: living implementation plans. `ce-plan` creates them, `ce-work` updates them.
- `reviews/`: code, plan, doc, and ADR review artifacts.
- `compound/`: reusable lessons from mistakes, bugs, and review findings.
- `adr/`: architecture decision records.

## Operating Principle

80% planning and review. 20% execution.

A good brainstorm makes the plan sharper. A good plan makes execution smaller. A good review catches the pattern, not just the bug. A good compound note means the next agent does not learn the same lesson from scratch.
EOF
fi

if [ ! -f docs/ce/compound/index.md ]; then
cat > docs/ce/compound/index.md <<'EOF'
# Compound Engineering Notes

Reusable project lessons. Read before planning, working, or reviewing related areas.

| Date | Key | Type | Severity | Rule | Applies To |
|---|---|---|---|---|---|
EOF
fi

if [ ! -f docs/ce/adr/README.md ]; then
cat > docs/ce/adr/README.md <<'EOF'
# Architecture Decision Records

Use ADRs when a decision changes architecture, persistence, public API, integration, deployment, security boundary, or another choice that is expensive to reverse.
EOF
fi

AGENTS_FILE="AGENTS.md"
if [ ! -f "$AGENTS_FILE" ]; then
cat > "$AGENTS_FILE" <<'EOF'
# AGENTS.md

Project instructions for AI agents.
EOF
fi

if ! grep -q "## Compound Engineering Router" "$AGENTS_FILE"; then
cat >> "$AGENTS_FILE" <<'EOF'

## Compound Engineering Router

When the user request matches a Compound Engineering stage, use the corresponding skill before answering ad hoc:

- Fuzzy idea, early requirement, product or engineering concept, unclear problem, "help me think" -> `ce-brainstorm`.
- Approved brainstorm/spec and request for implementation plan, slices, ADR, architecture plan -> `ce-plan`.
- Implementation of an approved active plan slice -> `ce-work`.
- Code review, doc review, plan compliance review, pre-merge review -> `ce-review`.
- Mistake, repeated bug, review lesson, failed command, "avoid this next time" -> `ce-compound`.

Do not skip stages because the task feels simple. Small tasks are where hidden assumptions leak.

## Compound Engineering Taste Constraints

- Documents are memory. If future agents need context, write it down.
- Plan and review before execution. Target 80% planning/review and 20% implementation.
- Work in small slices. One active slice at a time.
- Keep `docs/ce/plans/*-plan.md` current. Plan status must be `ACTIVE`, `COMPLETED`, `PAUSED`, or `ABANDONED`.
- Mark exactly one `Active Slice`, or `none`.
- For behavior changes, write or update tests before implementation and verify they fail for the expected reason.
- Create ADRs for decisions that are expensive to reverse.
- Review for patterns, not just bugs. Repeated mistakes become compound notes.
- Prefer automation over memory. A test beats a reminder.
- Do not hide scope drift. Update the plan before expanding work.
EOF
fi

printf 'Compound Engineering harness initialized at %s\n' "$ROOT"
printf 'Created or verified docs/ce/* and AGENTS.md routing.\n'
