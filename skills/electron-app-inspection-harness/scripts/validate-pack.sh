#!/usr/bin/env bash
set -euo pipefail
DOC_ROOT="${1:-}"; [ -n "$DOC_ROOT" ] || { echo "Usage: validate-pack.sh <doc-root>" >&2; exit 64; }
mkdir -p "$DOC_ROOT/05-ui-ux-report"
REPORT="$DOC_ROOT/05-ui-ux-report/pack-validation.md"
REQUIRED=(
  "00-meta/app-context.json"
  "00-meta/manifest.json"
  "00-meta/capability-ledger.json"
  "00-meta/route-decision.md"
  "05-ui-ux-report/verification-report.md"
)
OPTIONAL=(
  "05-ui-ux-report/inspection-report.md"
  "05-ui-ux-report/design-tokens.json"
  "05-ui-ux-report/component-inventory.md"
  "05-ui-ux-report/interaction-matrix.md"
  "06-codex-tasks/codex-implementation-prompt.md"
  "06-codex-tasks/task-contract.json"
  "06-codex-tasks/acceptance-checklist.md"
)
MISSING=0
{
  echo "# Pack Validation"
  echo
  echo "Generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo
  echo "## Required"
  for f in "${REQUIRED[@]}"; do
    if [ -f "$DOC_ROOT/$f" ]; then echo "- [x] $f"; else echo "- [ ] $f"; MISSING=$((MISSING+1)); fi
  done
  echo
  echo "## Optional but expected before handoff"
  for f in "${OPTIONAL[@]}"; do
    if [ -f "$DOC_ROOT/$f" ]; then echo "- [x] $f"; else echo "- [ ] $f"; fi
  done
  echo
  echo "Missing required: $MISSING"
} > "$REPORT"
cat "$REPORT"
[ "$MISSING" -eq 0 ] || exit 1
