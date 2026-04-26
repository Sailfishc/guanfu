#!/usr/bin/env bash
set -euo pipefail
OUT_DIR="${1:-}"
if [[ -z "$OUT_DIR" || ! -d "$OUT_DIR" ]]; then
  echo "VALIDATION: fail"
  echo "Reason: doc root missing: ${OUT_DIR:-<empty>}"
  exit 64
fi
fail=0
check_file() {
  local f="$1"
  if [[ -f "$OUT_DIR/$f" ]]; then
    echo "OK: $f"
  else
    echo "MISSING: $f"
    fail=1
  fi
}
check_file ".app-context.json"
check_file "manifest.json"
check_file "00-environment-report.md"
check_file "01-route-decision.md"
check_file "02-app-map.md"
check_file "03-screen-inventory.md"
check_file "04-user-flows.md"
check_file "05-design-tokens.json"
check_file "06-assets-inventory.md"
check_file "handoff/frontend-implementation.md"
check_file "handoff/codex-implementation-prompt.md"
check_file "handoff/task-contract.json"
check_file "handoff/acceptance-checklist.md"
check_file "handoff/verification-report.md"

if [[ -f "$OUT_DIR/.app-context.json" ]]; then
  app_slug=$(grep -m1 '"slug"' "$OUT_DIR/.app-context.json" | sed -E 's/.*"slug"[[:space:]]*:[[:space:]]*"([^"]*)".*/\1/' || true)
  if [[ -n "$app_slug" && "$OUT_DIR" == *"/$app_slug" ]]; then
    echo "OK: output path includes app slug ($app_slug)"
  else
    echo "MISSING: output path does not end with app slug ($app_slug)"
    fail=1
  fi
fi

component_count=$(find "$OUT_DIR/components" -maxdepth 1 -name '*.md' -type f 2>/dev/null | wc -l | tr -d ' ')
if [[ "$component_count" -ge 1 ]]; then
  echo "OK: component specs: $component_count"
else
  echo "MISSING: at least one component spec in components/*.md"
  fail=1
fi

if [[ "$fail" -eq 0 ]]; then
  echo "VALIDATION: pass"
else
  echo "VALIDATION: fail"
  exit 1
fi
