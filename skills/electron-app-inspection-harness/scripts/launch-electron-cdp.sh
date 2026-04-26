#!/usr/bin/env bash
set -euo pipefail
DOC_ROOT="${1:-}"; [ -n "$DOC_ROOT" ] || { echo "Usage: launch-electron-cdp.sh <doc-root> --app-path /Applications/App.app [--port 9222] [--strategy open-new-instance|quit-and-open]" >&2; exit 64; }
shift || true
APP_PATH=""; PORT="9222"; STRATEGY="open-new-instance"
while [ $# -gt 0 ]; do
  case "$1" in
    --app-path) APP_PATH="${2:-}"; shift 2 ;;
    --port) PORT="${2:-}"; shift 2 ;;
    --strategy) STRATEGY="${2:-}"; shift 2 ;;
    *) echo "UNKNOWN_ARG: $1" >&2; exit 64 ;;
  esac
done
[ -d "$APP_PATH" ] || { echo "APP_PATH_NOT_FOUND: $APP_PATH" >&2; exit 66; }
mkdir -p "$DOC_ROOT/01-runtime"
LOG="$DOC_ROOT/01-runtime/cdp-launch.log"
case "$STRATEGY" in open-new-instance|quit-and-open) ;; *) echo "INVALID_STRATEGY: $STRATEGY" >&2; exit 64 ;; esac
if [ "$STRATEGY" = "quit-and-open" ]; then osascript -e "tell application \"$(basename "$APP_PATH" .app)\" to quit" >> "$LOG" 2>&1 || true; sleep 2; fi
{
  echo "Generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "Strategy: $STRATEGY"
  echo "App path: $APP_PATH"
  echo "Port: $PORT"
  echo "Command: open -na '$APP_PATH' --args --remote-debugging-port=$PORT --enable-logging"
} >> "$LOG"
open -na "$APP_PATH" --args --remote-debugging-port="$PORT" --enable-logging >> "$LOG" 2>&1 || true
for i in $(seq 1 20); do
  if curl -sf "http://127.0.0.1:$PORT/json/list" >/dev/null 2>&1; then echo "CDP_READY port=$PORT" | tee -a "$LOG"; exit 0; fi
  sleep 0.5
done
echo "CDP_NOT_READY port=$PORT" | tee -a "$LOG"
exit 1
