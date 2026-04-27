#!/usr/bin/env bash
set -euo pipefail

payload="$(cat 2>/dev/null || true)"

command_from_payload() {
  if command -v python3 >/dev/null 2>&1; then
    PAYLOAD="$payload" python3 - <<'PY'
import json, os
raw=os.environ.get('PAYLOAD','')
try:
    data=json.loads(raw or '{}')
except Exception:
    print(raw)
    raise SystemExit
cmd=(data.get('tool_input') or {}).get('command') or data.get('command') or raw
print(cmd)
PY
  else
    printf '%s' "$payload" | sed -n 's/.*"command"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p'
  fi
}

cmd="$(command_from_payload | tr '\n' ' ' | sed 's/[[:space:]]\+/ /g; s/^ //; s/ $//')"

block() {
  printf 'BLOCKED: dangerous git command refused by GuanFu guardrails: %s\n' "$cmd" >&2
  printf 'Run this command manually in your own terminal only if you intend the destructive or external action.\n' >&2
  exit 2
}

normalized="$(printf '%s' "$cmd" | sed "s/[\"']//g")"

case "$normalized" in
  git\ push|git\ push\ *|git\ *\ push|git\ *\ push\ *) block ;;
  git\ reset\ --hard|git\ reset\ --hard\ *|git\ *\ reset\ --hard|git\ *\ reset\ --hard\ *) block ;;
  git\ clean\ -f|git\ clean\ -f\ *|git\ clean\ -fd|git\ clean\ -fd\ *|git\ clean\ -df|git\ clean\ -df\ *|git\ clean\ --force|git\ clean\ --force\ *|git\ *\ clean\ -f*|git\ *\ clean\ --force*) block ;;
  git\ branch\ -D|git\ branch\ -D\ *|git\ *\ branch\ -D|git\ *\ branch\ -D\ *) block ;;
  git\ checkout\ .|git\ checkout\ --\ .|git\ checkout\ .\ *|git\ *\ checkout\ .|git\ *\ checkout\ --\ .) block ;;
  git\ restore\ .|git\ restore\ --\ .|git\ restore\ .\ *|git\ *\ restore\ .|git\ *\ restore\ --\ .) block ;;
esac

exit 0
