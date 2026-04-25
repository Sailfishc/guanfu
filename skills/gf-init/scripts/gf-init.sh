#!/usr/bin/env bash
set -euo pipefail

MODE="new"
DRY_RUN=0
FORCE=0

usage() {
  cat <<'HELP'
Usage: gf-init.sh [--new|--refresh|--audit] [--dry-run] [--force]

Creates, refreshes, or audits the GuanFu repository harness.

Modes:
  --new       Create missing GuanFu harness files. Default.
  --refresh   Refresh generated router and templates from this skill's bundled assets.
  --audit     Read-only report of missing or stale GuanFu pieces.

Options:
  --dry-run   Print planned writes without changing files.
  --force     Overwrite generated files during --new or --refresh.

Product code stays untouched.
HELP
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --new) MODE="new"; shift ;;
    --refresh) MODE="refresh"; shift ;;
    --audit) MODE="audit"; shift ;;
    --dry-run) DRY_RUN=1; shift ;;
    --force) FORCE=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage >&2; exit 2 ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ASSETS_DIR="$SKILL_DIR/assets/templates"
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

say() { printf '%s\n' "$*"; }
err() { printf 'ERROR: %s\n' "$*" >&2; }

require_file() {
  local path="$1"
  if [[ ! -f "$path" ]]; then
    err "Missing bundled asset: $path"
    err "Install the full gf-init skill directory, including scripts/ and assets/."
    exit 1
  fi
}

require_assets() {
  for name in \
    AGENTS.guanfu docs-readme context-readme compound-index taste review-rubric \
    brainstorm plan code-review doc-review adr compound-note skill-evolution code-explore; do
    require_file "$ASSETS_DIR/$name.md"
  done
}

should_overwrite_generated() {
  local generated="${1:-0}"
  [[ "$FORCE" == "1" ]] && return 0
  [[ "$MODE" == "refresh" && "$generated" == "1" ]] && return 0
  return 1
}

write_or_skip() {
  local src="$1"
  local dest="$2"
  local generated="${3:-0}"

  if [[ "$MODE" == "audit" ]]; then
    if [[ -f "$dest" ]]; then
      say "OK file: $dest"
    else
      say "MISSING file: $dest"
      return 1
    fi
    return 0
  fi

  if [[ -f "$dest" ]] && ! should_overwrite_generated "$generated"; then
    say "SKIP existing: $dest"
    return 0
  fi

  if [[ "$DRY_RUN" == "1" ]]; then
    say "DRY-RUN: copy $src -> $dest"
    return 0
  fi

  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
  say "WROTE: $dest"
}

ensure_dir() {
  local dir="$1"
  if [[ "$MODE" == "audit" ]]; then
    if [[ -d "$dir" ]]; then
      say "OK dir: $dir"
    else
      say "MISSING dir: $dir"
      return 1
    fi
    return 0
  fi
  if [[ "$DRY_RUN" == "1" ]]; then
    say "DRY-RUN: mkdir -p $dir"
  else
    mkdir -p "$dir"
    say "OK dir: $dir"
  fi
}

upsert_block() {
  local dest="$1"
  local block_name="$2"
  local src="$3"
  local begin="<!-- GUANFU:${block_name}:BEGIN -->"
  local end="<!-- GUANFU:${block_name}:END -->"

  if [[ "$MODE" == "audit" ]]; then
    if [[ -f "$dest" ]] && grep -qF "$begin" "$dest" && grep -qF "$end" "$dest"; then
      say "OK block: $block_name in $dest"
    else
      say "MISSING block: $block_name in $dest"
      return 1
    fi
    return 0
  fi

  if [[ "$DRY_RUN" == "1" ]]; then
    if [[ -f "$dest" ]] && grep -qF "$begin" "$dest"; then
      say "DRY-RUN: refresh $block_name block in $dest"
    else
      say "DRY-RUN: append $block_name block to $dest"
    fi
    return 0
  fi

  mkdir -p "$(dirname "$dest")"
  [[ -f "$dest" ]] || printf '# Agent Instructions\n\n' > "$dest"

  local tmp block
  tmp="$(mktemp)"
  block="$(mktemp)"
  {
    printf '%s\n' "$begin"
    cat "$src"
    printf '%s\n' "$end"
  } > "$block"

  if grep -qF "$begin" "$dest"; then
    awk -v begin="$begin" -v end="$end" -v repl="$block" '
      BEGIN {
        while ((getline line < repl) > 0) replacement = replacement line "\n"
        close(repl)
      }
      index($0, begin) { printf "%s", replacement; skipping=1; next }
      index($0, end) { skipping=0; next }
      !skipping { print }
    ' "$dest" > "$tmp"
    mv "$tmp" "$dest"
    say "REFRESHED block: $block_name in $dest"
  else
    {
      cat "$dest"
      printf '\n%s\n' "$begin"
      cat "$src"
      printf '%s\n' "$end"
    } > "$tmp"
    mv "$tmp" "$dest"
    say "ADDED block: $block_name in $dest"
  fi
  rm -f "$block"
}

require_assets
cd "$ROOT"

say "GuanFu init root: $ROOT"
say "Mode: $MODE"
say "Skill dir: $SKILL_DIR"
say "Assets dir: $ASSETS_DIR"

status=0

for dir in \
  docs/guanfu/context \
  docs/guanfu/brainstorms \
  docs/guanfu/plans \
  docs/guanfu/reviews/code \
  docs/guanfu/reviews/docs \
  docs/guanfu/adr \
  docs/guanfu/compound \
  docs/guanfu/standards \
  docs/guanfu/evolution; do
  ensure_dir "$dir" || status=1
done

AGENTS_FILE="AGENTS.md"
if [[ -f agents.md && ! -f AGENTS.md ]]; then
  AGENTS_FILE="agents.md"
fi
upsert_block "$AGENTS_FILE" "ROUTER" "$ASSETS_DIR/AGENTS.guanfu.md" || status=1

write_or_skip "$ASSETS_DIR/docs-readme.md" "docs/guanfu/README.md" 1 || status=1
write_or_skip "$ASSETS_DIR/context-readme.md" "docs/guanfu/context/README.md" 1 || status=1
write_or_skip "$ASSETS_DIR/compound-index.md" "docs/guanfu/compound/index.md" 0 || status=1
write_or_skip "$ASSETS_DIR/taste.md" "docs/guanfu/standards/taste.md" 1 || status=1
write_or_skip "$ASSETS_DIR/review-rubric.md" "docs/guanfu/standards/review-rubric.md" 1 || status=1
write_or_skip "$ASSETS_DIR/code-explore.md" "docs/guanfu/context/CODE_EXPLORE_TEMPLATE.md" 1 || status=1
write_or_skip "$ASSETS_DIR/brainstorm.md" "docs/guanfu/brainstorms/BRAINSTORM_TEMPLATE.md" 1 || status=1
write_or_skip "$ASSETS_DIR/plan.md" "docs/guanfu/plans/PLAN_TEMPLATE.md" 1 || status=1
write_or_skip "$ASSETS_DIR/adr.md" "docs/guanfu/adr/0000-template.md" 1 || status=1
write_or_skip "$ASSETS_DIR/code-review.md" "docs/guanfu/reviews/code/CODE_REVIEW_TEMPLATE.md" 1 || status=1
write_or_skip "$ASSETS_DIR/doc-review.md" "docs/guanfu/reviews/docs/DOC_REVIEW_TEMPLATE.md" 1 || status=1
write_or_skip "$ASSETS_DIR/compound-note.md" "docs/guanfu/compound/COMPOUND_NOTE_TEMPLATE.md" 1 || status=1
write_or_skip "$ASSETS_DIR/skill-evolution.md" "docs/guanfu/evolution/EVOLUTION_TEMPLATE.md" 1 || status=1

if [[ "$MODE" == "audit" ]]; then
  if [[ "$status" == "0" ]]; then
    say "STATUS: OK"
  else
    say "STATUS: NEEDS_REFRESH"
  fi
  exit "$status"
fi

say "STATUS: DONE"
say "ROUTER: $AGENTS_FILE"
say "TEMPLATES: docs/guanfu stage template files"
say "NEXT: run /gf-init code explore step, then /gf-brainstorm or /gf-plan"
