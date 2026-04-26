#!/usr/bin/env bash
set -euo pipefail
OUT_DIR="${1:-}"
if [[ -z "$OUT_DIR" || ! -d "$OUT_DIR" ]]; then
  echo "Usage: create-codex-handoff.sh <app-doc-dir>" >&2
  exit 64
fi
APP_NAME="unknown"
APP_SLUG="unknown"
if [[ -f "$OUT_DIR/.app-context.json" ]]; then
  APP_NAME=$(grep -m1 '"name"' "$OUT_DIR/.app-context.json" | sed -E 's/.*"name"[[:space:]]*:[[:space:]]*"([^"]*)".*/\1/' || echo unknown)
  APP_SLUG=$(grep -m1 '"slug"' "$OUT_DIR/.app-context.json" | sed -E 's/.*"slug"[[:space:]]*:[[:space:]]*"([^"]*)".*/\1/' || echo unknown)
fi
mkdir -p "$OUT_DIR/handoff"
cat > "$OUT_DIR/handoff/codex-implementation-prompt.md" <<MD
# Codex Implementation Prompt: $APP_NAME

You are implementing frontend UI from an app-scoped Electron UI documentation pack.

Doc root:

\`\`\`text
$OUT_DIR
\`\`\`

Read in this order:

1. \`manifest.json\`
2. \`.app-context.json\`
3. \`handoff/frontend-implementation.md\`
4. \`components/*.md\`
5. \`components/*.spec.json\`
6. \`05-design-tokens.json\`
7. \`06-assets-inventory.md\`
8. \`handoff/task-contract.json\`
9. \`handoff/acceptance-checklist.md\`
10. \`handoff/verification-report.md\` if it exists

Implementation rules:

- Build from documented behavior and evidence.
- Treat component specs as the source of truth.
- Use tokens before component styling.
- Use semantic components rather than copied minified DOM.
- Keep unknown states as explicit TODOs.
- Use proprietary assets only as documented by provenance and rights.
- Add stories or examples for all documented states.
- Verify visually against captures when available.

Deliverables:

- token CSS or theme module
- component implementations
- state stories/examples
- visual or screenshot checks when captures exist
- implementation notes for gaps marked unknown
MD

if [[ ! -f "$OUT_DIR/handoff/task-contract.json" ]]; then
  cat > "$OUT_DIR/handoff/task-contract.json" <<JSON
{
  "schemaVersion": "2.1.0",
  "app": { "name": "$APP_NAME", "slug": "$APP_SLUG" },
  "docRoot": "$OUT_DIR",
  "workItems": []
}
JSON
fi

if [[ ! -f "$OUT_DIR/handoff/acceptance-checklist.md" ]]; then
  cat > "$OUT_DIR/handoff/acceptance-checklist.md" <<MD
# Acceptance Checklist: $APP_NAME

- [ ] App-scoped paths are used.
- [ ] Tokens come from \`05-design-tokens.json\`.
- [ ] Components match \`components/*.md\` specs.
- [ ] Documented states have stories or examples.
- [ ] Unknown states remain TODOs.
- [ ] Visual checks use captures when available.
MD
fi

echo "WROTE=$OUT_DIR/handoff/codex-implementation-prompt.md"
echo "WROTE=$OUT_DIR/handoff/task-contract.json"
echo "WROTE=$OUT_DIR/handoff/acceptance-checklist.md"
