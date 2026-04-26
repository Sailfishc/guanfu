#!/usr/bin/env bash
set -euo pipefail

APP_INPUT=""
APP_NAME=""
ASAR_PATH=""
OUT_ROOT="electron-ui-doc"
SCOPE="unknown"
TARGET_STACK="unknown"

usage() {
  cat <<'USAGE'
Usage:
  check-electron-ui-env.sh --app /Applications/Example.app [--out-root electron-ui-doc]
  check-electron-ui-env.sh --app Example [--out-root electron-ui-doc]
  check-electron-ui-env.sh --app-name Example --asar ./app.asar [--out-root electron-ui-doc]

Required: explicit app identity. A bare app.asar requires --app-name.
USAGE
}

while [ $# -gt 0 ]; do
  case "$1" in
    --app) APP_INPUT="${2:-}"; shift 2 ;;
    --app-name|--name) APP_NAME="${2:-}"; shift 2 ;;
    --asar) ASAR_PATH="${2:-}"; shift 2 ;;
    --out-root|--output-root|--out) OUT_ROOT="${2:-}"; shift 2 ;;
    --scope) SCOPE="${2:-}"; shift 2 ;;
    --target-stack) TARGET_STACK="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "ERROR: unknown argument: $1" >&2; usage >&2; exit 64 ;;
  esac
done

if [ -z "$APP_INPUT" ] && [ -z "$APP_NAME" ]; then
  echo "NEEDS_APP_IDENTITY" >&2
  usage >&2
  exit 64
fi
if [ -n "$ASAR_PATH" ] && [ -z "$APP_NAME" ] && [ -z "$APP_INPUT" ]; then
  echo "NEEDS_APP_NAME_FOR_ASAR" >&2
  exit 64
fi

have() { command -v "$1" >/dev/null 2>&1; }
yesno() { if [ "$1" = "1" ]; then echo "yes"; else echo "no"; fi; }
cmd_flag() { have "$1" && echo 1 || echo 0; }
exists_flag() { [ -e "$1" ] && echo 1 || echo 0; }
plist_value() { local plist="$1" key="$2"; [ -f "$plist" ] && /usr/libexec/PlistBuddy -c "Print :$key" "$plist" 2>/dev/null || true; }
json_escape() { printf '"%s"' "$(printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g')"; }
slugify() {
  local s
  s=$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//; s/-+/-/g' | cut -c1-64)
  if [ -z "$s" ]; then
    s="app-$(printf '%s' "$1" | cksum | awk '{print $1}')"
  fi
  printf '%s' "$s"
}
resolve_app_by_name() {
  local name="$1"
  local candidates=()
  [ -d "/Applications/$name.app" ] && candidates+=("/Applications/$name.app")
  [ -d "$HOME/Applications/$name.app" ] && candidates+=("$HOME/Applications/$name.app")
  while IFS= read -r p; do [ -n "$p" ] && candidates+=("$p"); done < <(find /Applications "$HOME/Applications" -maxdepth 1 -iname "*$name*.app" 2>/dev/null | sort -u || true)
  if [ "${#candidates[@]}" -eq 1 ]; then printf '%s\n' "${candidates[0]}"; return 0; fi
  if [ "${#candidates[@]}" -gt 1 ]; then echo "AMBIGUOUS_APP" >&2; printf '%s\n' "${candidates[@]}" >&2; exit 65; fi
  return 1
}

APP_PATH=""
if [ -n "$APP_INPUT" ]; then
  if [[ "$APP_INPUT" == *.app ]] || [[ "$APP_INPUT" == /* ]] || [[ "$APP_INPUT" == ./* ]]; then
    APP_PATH="$APP_INPUT"
    if [ ! -d "$APP_PATH" ]; then echo "APP_NOT_FOUND: $APP_PATH" >&2; exit 66; fi
  else
    APP_NAME="$APP_INPUT"
    APP_PATH=$(resolve_app_by_name "$APP_NAME" || true)
    if [ -z "$APP_PATH" ]; then echo "APP_NOT_FOUND: $APP_NAME" >&2; exit 66; fi
  fi
fi

APP_BUNDLE_ID="unknown"
APP_VERSION="unknown"
if [ -n "$APP_PATH" ]; then
  PLIST="$APP_PATH/Contents/Info.plist"
  if [ -z "$APP_NAME" ]; then
    APP_NAME=$(plist_value "$PLIST" CFBundleDisplayName)
    [ -z "$APP_NAME" ] && APP_NAME=$(plist_value "$PLIST" CFBundleName)
    [ -z "$APP_NAME" ] && APP_NAME=$(plist_value "$PLIST" CFBundleExecutable)
    [ -z "$APP_NAME" ] && APP_NAME=$(basename "$APP_PATH" .app)
  fi
  APP_BUNDLE_ID=$(plist_value "$PLIST" CFBundleIdentifier); [ -z "$APP_BUNDLE_ID" ] && APP_BUNDLE_ID="unknown"
  APP_VERSION=$(plist_value "$PLIST" CFBundleShortVersionString); [ -z "$APP_VERSION" ] && APP_VERSION="unknown"
  [ -z "$ASAR_PATH" ] && [ -f "$APP_PATH/Contents/Resources/app.asar" ] && ASAR_PATH="$APP_PATH/Contents/Resources/app.asar"
fi
if [ -n "$ASAR_PATH" ] && [ ! -f "$ASAR_PATH" ]; then echo "APP_ASAR_NOT_FOUND: $ASAR_PATH" >&2; exit 66; fi

APP_SLUG=$(slugify "$APP_NAME")
OUTPUT_DIR="$OUT_ROOT/$APP_SLUG"
mkdir -p "$OUTPUT_DIR/components" "$OUTPUT_DIR/captures/screenshots" "$OUTPUT_DIR/captures/dom" "$OUTPUT_DIR/captures/accessibility" "$OUTPUT_DIR/handoff"
CONTEXT="$OUTPUT_DIR/.app-context.json"
MANIFEST="$OUTPUT_DIR/manifest.json"
REPORT="$OUTPUT_DIR/00-environment-report.md"

cat > "$CONTEXT" <<JSON
{
  "schemaVersion": "2.1.0",
  "app": {
    "name": $(json_escape "$APP_NAME"),
    "slug": $(json_escape "$APP_SLUG"),
    "path": $(json_escape "${APP_PATH:-}"),
    "asar": $(json_escape "${ASAR_PATH:-}"),
    "bundleId": $(json_escape "$APP_BUNDLE_ID"),
    "version": $(json_escape "$APP_VERSION")
  },
  "outputDir": $(json_escape "$OUTPUT_DIR"),
  "createdAt": $(json_escape "$(date -u +%Y-%m-%dT%H:%M:%SZ)")
}
JSON

cat > "$MANIFEST" <<JSON
{
  "schemaVersion": "2.1.0",
  "app": { "name": $(json_escape "$APP_NAME"), "slug": $(json_escape "$APP_SLUG") },
  "docRoot": $(json_escape "$OUTPUT_DIR"),
  "canonical": {
    "frontendHandoff": "handoff/frontend-implementation.md",
    "codexPrompt": "handoff/codex-implementation-prompt.md",
    "taskContract": "handoff/task-contract.json",
    "acceptanceChecklist": "handoff/acceptance-checklist.md",
    "verificationReport": "handoff/verification-report.md"
  },
  "requiredFiles": [
    ".app-context.json",
    "00-environment-report.md",
    "01-route-decision.md",
    "02-app-map.md",
    "03-screen-inventory.md",
    "04-user-flows.md",
    "05-design-tokens.json",
    "06-assets-inventory.md",
    "handoff/frontend-implementation.md",
    "handoff/codex-implementation-prompt.md",
    "handoff/task-contract.json",
    "handoff/acceptance-checklist.md",
    "handoff/verification-report.md"
  ]
}
JSON

cat > "$OUTPUT_DIR/README.md" <<MD
# Electron UI Doc Pack: $APP_NAME

Doc root: \`$OUTPUT_DIR\`

Primary files:

- \`handoff/frontend-implementation.md\`
- \`handoff/codex-implementation-prompt.md\`
- \`handoff/task-contract.json\`
- \`manifest.json\`

This pack is scoped to app slug \`$APP_SLUG\`.
MD

NODE=$(cmd_flag node); NPM=$(cmd_flag npm); NPX=$(cmd_flag npx); RG=$(cmd_flag rg); JQ=$(cmd_flag jq); PYTHON3=$(cmd_flag python3); ASAR=$(cmd_flag asar); CURL=$(cmd_flag curl); PLUTIL=$(cmd_flag plutil); SCREENCAPTURE=$(cmd_flag screencapture)
CHROME=$(exists_flag "/Applications/Google Chrome.app"); FIGMA=$(exists_flag "/Applications/Figma.app")
APP_EXISTS=$([ -n "$APP_PATH" ] && [ -d "$APP_PATH" ] && echo 1 || echo 0); ASAR_EXISTS=$([ -n "$ASAR_PATH" ] && [ -f "$ASAR_PATH" ] && echo 1 || echo 0)
ASAR_UNPACKED_EXISTS=0; [ -n "$ASAR_PATH" ] && [ -d "$(dirname "$ASAR_PATH")/app.asar.unpacked" ] && ASAR_UNPACKED_EXISTS=1
PLAYWRIGHT=0
if [ -d node_modules/playwright ] || [ -d ./node_modules/@playwright/test ]; then PLAYWRIGHT=1; fi

cat > "$REPORT" <<MD
# Electron UI Environment Report

Generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)

## Target App

| Item | Value |
|---|---|
| App name | $APP_NAME |
| App slug | $APP_SLUG |
| Output folder | $OUTPUT_DIR |
| App path | ${APP_PATH:-not provided} |
| App exists | $(yesno "$APP_EXISTS") |
| Bundle id | $APP_BUNDLE_ID |
| Version | $APP_VERSION |
| app.asar | ${ASAR_PATH:-not provided} |
| app.asar exists | $(yesno "$ASAR_EXISTS") |
| app.asar.unpacked exists | $(yesno "$ASAR_UNPACKED_EXISTS") |
| Scope | $SCOPE |
| Target stack | $TARGET_STACK |

## Local tools

| Tool | Available |
|---|---:|
| node | $(yesno "$NODE") |
| npm | $(yesno "$NPM") |
| npx | $(yesno "$NPX") |
| asar | $(yesno "$ASAR") |
| rg | $(yesno "$RG") |
| jq | $(yesno "$JQ") |
| python3 | $(yesno "$PYTHON3") |
| curl | $(yesno "$CURL") |
| plutil | $(yesno "$PLUTIL") |
| screencapture | $(yesno "$SCREENCAPTURE") |
| playwright package | $(yesno "$PLAYWRIGHT") |
| Google Chrome.app | $(yesno "$CHROME") |
| Figma.app | $(yesno "$FIGMA") |

## Recommended next commands

Static mapping when app.asar is available:

\`\`\`bash
bash scripts/extract-asar.sh "$OUTPUT_DIR" "${ASAR_PATH:-/path/to/app.asar}"
\`\`\`

Runtime capture after user approval:

\`\`\`bash
open -a "$APP_NAME" --args --remote-debugging-port=9222
curl -s http://127.0.0.1:9222/json/list | jq .
node scripts/cdp-capture.js http://127.0.0.1:9222 "$OUTPUT_DIR/captures"
\`\`\`
MD

bash "$(dirname "$0")/create-codex-handoff.sh" "$OUTPUT_DIR" >/dev/null 2>&1 || true
printf 'APP_NAME=%s\n' "$APP_NAME"
printf 'APP_SLUG=%s\n' "$APP_SLUG"
printf 'APP_PATH=%s\n' "${APP_PATH:-}"
printf 'APP_ASAR=%s\n' "${ASAR_PATH:-}"
printf 'OUTPUT_DIR=%s\n' "$OUTPUT_DIR"
printf 'CONTEXT=%s\n' "$CONTEXT"
