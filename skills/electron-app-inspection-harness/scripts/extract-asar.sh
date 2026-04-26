#!/usr/bin/env bash
set -euo pipefail
DOC_ROOT="${1:-}"; ASAR_PATH="${2:-}"
[ -n "$DOC_ROOT" ] && [ -n "$ASAR_PATH" ] || { echo "Usage: extract-asar.sh <doc-root> <app.asar>" >&2; exit 64; }
[ -f "$ASAR_PATH" ] || { echo "APP_ASAR_NOT_FOUND: $ASAR_PATH" >&2; exit 66; }
mkdir -p "$DOC_ROOT/02-static-asar"
OUT="$DOC_ROOT/02-static-asar/extracted"; LOG="$DOC_ROOT/02-static-asar/asar-extract.log"
rm -rf "$OUT"; mkdir -p "$OUT"
ASAR_BIN=""
if [ -x "$DOC_ROOT/.tooling/node_modules/.bin/asar" ]; then ASAR_BIN="$DOC_ROOT/.tooling/node_modules/.bin/asar";
elif command -v asar >/dev/null 2>&1; then ASAR_BIN="$(command -v asar)";
elif command -v npx >/dev/null 2>&1; then ASAR_BIN="npx -y @electron/asar"; fi
[ -n "$ASAR_BIN" ] || { echo "NEEDS_ASAR_TOOL" >&2; exit 69; }
set +e
# shellcheck disable=SC2086
$ASAR_BIN extract "$ASAR_PATH" "$OUT" >"$LOG" 2>&1
STATUS=$?
set -e
cat > "$DOC_ROOT/02-static-asar/static-map.md" <<MD
# Static ASAR Map

Extraction status: $STATUS

| Item | Value |
|---|---|
| app.asar | $ASAR_PATH |
| extracted | 02-static-asar/extracted |
| extractor | $ASAR_BIN |
| log | 02-static-asar/asar-extract.log |

Run \`scripts/static-map.sh\` to generate search maps.
MD
exit "$STATUS"
