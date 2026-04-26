#!/usr/bin/env bash
set -euo pipefail
DOC_DIR="${1:-}"
ASAR_PATH="${2:-}"
if [ -z "$DOC_DIR" ] || [ -z "$ASAR_PATH" ]; then
  echo "Usage: extract-asar.sh <doc-dir> <app.asar>" >&2
  exit 64
fi
if [ ! -d "$DOC_DIR" ]; then
  echo "ERROR: doc dir not found: $DOC_DIR" >&2
  exit 65
fi
if [ ! -f "$ASAR_PATH" ]; then
  echo "ERROR: app.asar not found: $ASAR_PATH" >&2
  exit 65
fi
EXTRACTED="$DOC_DIR/evidence/extracted"
mkdir -p "$EXTRACTED"
if command -v asar >/dev/null 2>&1; then
  asar extract "$ASAR_PATH" "$EXTRACTED"
elif command -v npx >/dev/null 2>&1; then
  npx --yes @electron/asar extract "$ASAR_PATH" "$EXTRACTED"
else
  echo "ERROR: install asar or make npx available for extraction." >&2
  exit 66
fi
cat > "$EXTRACTED/README.md" <<MD
# Extracted ASAR Evidence

Source: \`$ASAR_PATH\`

This folder is evidence for documentation. Use summarized docs first, then inspect targeted files here.
MD
echo "EXTRACTED_DIR=$EXTRACTED"
