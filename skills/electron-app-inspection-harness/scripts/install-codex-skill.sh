#!/usr/bin/env bash
set -euo pipefail
SCOPE="user"
TARGET_REPO=""
while [ $# -gt 0 ]; do
  case "$1" in
    --scope) SCOPE="${2:-}"; shift 2 ;;
    --repo) TARGET_REPO="${2:-}"; shift 2 ;;
    -h|--help) echo "Usage: install-codex-skill.sh [--scope user|repo] [--repo /path/to/repo]"; exit 0 ;;
    *) echo "UNKNOWN_ARG: $1" >&2; exit 64 ;;
  esac
done
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
case "$SCOPE" in
  user)
    DEST="$HOME/.agents/skills/$(basename "$SKILL_DIR")"
    ;;
  repo)
    [ -n "$TARGET_REPO" ] || TARGET_REPO="$(pwd)"
    DEST="$TARGET_REPO/.agents/skills/$(basename "$SKILL_DIR")"
    ;;
  *) echo "INVALID_SCOPE: $SCOPE" >&2; exit 64 ;;
esac
mkdir -p "$(dirname "$DEST")"
rm -rf "$DEST"
cp -R "$SKILL_DIR" "$DEST"
find "$DEST/scripts" -type f \( -name "*.sh" -o -name "*.js" -o -name "*.mjs" \) -exec chmod +x {} +
printf 'INSTALLED_SKILL=%s\n' "$DEST"
printf 'NEXT=restart Codex or run /skills to verify availability\n'
