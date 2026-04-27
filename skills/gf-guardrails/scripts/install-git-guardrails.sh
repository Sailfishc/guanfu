#!/usr/bin/env bash
set -euo pipefail

SCOPE=""
MODE="install"

usage() {
  cat <<'HELP'
Usage: install-git-guardrails.sh (--project|--global) [--audit|--test]

Installs, audits, or tests the GuanFu dangerous-git PreToolUse hook.
HELP
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project) SCOPE="project"; shift ;;
    --global) SCOPE="global"; shift ;;
    --audit) MODE="audit"; shift ;;
    --test) MODE="test"; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage >&2; exit 2 ;;
  esac
done

if [[ -z "$SCOPE" ]]; then
  echo "ERROR: choose --project or --global" >&2
  usage >&2
  exit 2
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BLOCK_SRC="$SCRIPT_DIR/block-dangerous-git.sh"
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

if [[ "$SCOPE" == "project" ]]; then
  HOOK_DIR="$ROOT/.claude/hooks"
  HOOK_PATH="$HOOK_DIR/block-dangerous-git.sh"
  SETTINGS="$ROOT/.claude/settings.json"
  COMMAND='"$CLAUDE_PROJECT_DIR"/.claude/hooks/block-dangerous-git.sh'
else
  HOOK_DIR="$HOME/.claude/hooks"
  HOOK_PATH="$HOOK_DIR/block-dangerous-git.sh"
  SETTINGS="$HOME/.claude/settings.json"
  COMMAND="$HOOK_PATH"
fi

say() { printf '%s\n' "$*"; }

run_test() {
  set +e
  echo '{"tool_input":{"command":"git push origin main"}}' | "$HOOK_PATH" >/tmp/gf_guardrails_test_stdout 2>/tmp/gf_guardrails_test_stderr
  code=$?
  set -e
  if [[ "$code" == "2" ]] && grep -q 'BLOCKED' /tmp/gf_guardrails_test_stderr; then
    say "TEST: PASS"
    return 0
  fi
  say "TEST: FAIL"
  say "exit=$code"
  cat /tmp/gf_guardrails_test_stderr >&2 || true
  return 1
}

if [[ "$MODE" == "audit" ]]; then
  [[ -x "$HOOK_PATH" ]] && say "OK hook: $HOOK_PATH" || say "MISSING hook: $HOOK_PATH"
  if [[ -f "$SETTINGS" ]] && grep -q 'block-dangerous-git.sh' "$SETTINGS"; then
    say "OK settings: $SETTINGS"
  else
    say "MISSING settings hook: $SETTINGS"
  fi
  if [[ -x "$HOOK_PATH" ]]; then
    run_test || exit 1
  fi
  exit 0
fi

if [[ ! -f "$BLOCK_SRC" ]]; then
  echo "ERROR: missing $BLOCK_SRC" >&2
  exit 1
fi

mkdir -p "$HOOK_DIR" "$(dirname "$SETTINGS")"
cp "$BLOCK_SRC" "$HOOK_PATH"
chmod +x "$HOOK_PATH"

SETTINGS_PATH="$SETTINGS" COMMAND_VALUE="$COMMAND" python3 - <<'PY'
import json, os
path=os.environ['SETTINGS_PATH']
command=os.environ['COMMAND_VALUE']
try:
    with open(path) as f:
        data=json.load(f)
except FileNotFoundError:
    data={}
except json.JSONDecodeError:
    backup=path+'.guanfu-backup'
    with open(path) as f: raw=f.read()
    with open(backup,'w') as f: f.write(raw)
    data={}

hooks=data.setdefault('hooks', {})
pre=hooks.setdefault('PreToolUse', [])
entry={'matcher':'Bash','hooks':[{'type':'command','command':command}]}

def has_command(node):
    if isinstance(node, dict):
        if node.get('command') == command or 'block-dangerous-git.sh' in str(node.get('command','')):
            return True
        return any(has_command(v) for v in node.values())
    if isinstance(node, list):
        return any(has_command(v) for v in node)
    return False

if not has_command(pre):
    pre.append(entry)

with open(path,'w') as f:
    json.dump(data, f, indent=2)
    f.write('\n')
PY

say "INSTALLED hook: $HOOK_PATH"
say "UPDATED settings: $SETTINGS"

if [[ "$MODE" == "test" ]]; then
  run_test
fi
