#!/usr/bin/env bash
set -euo pipefail
DOC_ROOT=""; ADD=""; BROWSER_URL=""
while [ $# -gt 0 ]; do
  case "$1" in
    --doc-root) DOC_ROOT="${2:-}"; shift 2 ;;
    --add) ADD="${2:-}"; shift 2 ;;
    --browser-url) BROWSER_URL="${2:-}"; shift 2 ;;
    -h|--help) echo "Usage: configure-codex-mcp.sh --doc-root <doc-root> --add chrome-devtools|playwright [--browser-url http://127.0.0.1:9222]"; exit 0 ;;
    *) echo "UNKNOWN_ARG: $1" >&2; exit 64 ;;
  esac
done
[ -n "$DOC_ROOT" ] && [ -n "$ADD" ] || { echo "MISSING_ARGS" >&2; exit 64; }
mkdir -p "$DOC_ROOT/03-mcp"
LOG="$DOC_ROOT/03-mcp/mcp-config.md"
case "$ADD" in chrome-devtools|playwright) ;; *) echo "INVALID_MCP: $ADD" >&2; exit 64 ;; esac
{
  echo "# MCP Config Attempt"
  echo
  echo "Generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "Server: $ADD"
  echo "Browser URL: ${BROWSER_URL:-none}"
  echo
} >> "$LOG"
if ! command -v codex >/dev/null 2>&1; then
  echo "codex CLI missing. Add manually:" >> "$LOG"
  if [ "$ADD" = "chrome-devtools" ]; then
    if [ -n "$BROWSER_URL" ]; then echo '```toml' >> "$LOG"; echo '[mcp_servers.chrome-devtools]' >> "$LOG"; echo 'command = "npx"' >> "$LOG"; echo "args = [\"-y\", \"chrome-devtools-mcp@latest\", \"--browser-url=$BROWSER_URL\"]" >> "$LOG"; echo '```' >> "$LOG"; else echo 'codex mcp add chrome-devtools -- npx chrome-devtools-mcp@latest' >> "$LOG"; fi
  else echo 'codex mcp add playwright -- npx @playwright/mcp@latest' >> "$LOG"; fi
  exit 0
fi
set +e
if [ "$ADD" = "chrome-devtools" ]; then
  if [ -n "$BROWSER_URL" ]; then
    codex mcp add chrome-devtools -- npx -y chrome-devtools-mcp@latest "--browser-url=$BROWSER_URL" >> "$LOG" 2>&1
  else
    codex mcp add chrome-devtools -- npx chrome-devtools-mcp@latest >> "$LOG" 2>&1
  fi
else
  codex mcp add playwright -- npx @playwright/mcp@latest >> "$LOG" 2>&1
fi
STATUS=$?
set -e
echo "Exit status: $STATUS" >> "$LOG"
python3 - <<'PY' "$DOC_ROOT/00-meta/capability-ledger.json" "$ADD" "$STATUS"
import json,sys,time
path,name,status=sys.argv[1:]
try: data=json.load(open(path))
except Exception: data={"schemaVersion":"4.0.0","capabilities":[],"downgradeJustification":[]}
data.setdefault("capabilities",[]).append({"name":name,"status":"configured" if status=="0" else "attempted","value":"high","cost":"low","evidence":"03-mcp/mcp-config.md","notes":f"codex mcp add exit={status}","createdAt":time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime())})
open(path,'w').write(json.dumps(data,indent=2))
PY
exit 0
