#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail=0
say() { printf '%s\n' "$*"; }
check_file() { [[ -f "$1" ]] && say "OK file: $1" || { say "MISSING file: $1"; fail=1; }; }
check_dir() { [[ -d "$1" ]] && say "OK dir: $1" || { say "MISSING dir: $1"; fail=1; }; }

say "GuanFu validation root: $ROOT"

for skill in skills/gf-*; do
  [[ -d "$skill" ]] || continue
  check_file "$skill/SKILL.md"
  if [[ -f "$skill/SKILL.md" ]]; then
    grep -q '^---$' "$skill/SKILL.md" || { say "BAD frontmatter fence: $skill/SKILL.md"; fail=1; }
    grep -q '^name: ' "$skill/SKILL.md" || { say "BAD missing name: $skill/SKILL.md"; fail=1; }
    grep -q '^description: ' "$skill/SKILL.md" || { say "BAD missing description: $skill/SKILL.md"; fail=1; }
  fi
done

for f in \
  skills/gf-init/scripts/gf-init.sh \
  skills/gf-guardrails/scripts/block-dangerous-git.sh \
  skills/gf-guardrails/scripts/install-git-guardrails.sh; do
  check_file "$f"
  [[ -x "$f" ]] || { say "NOT executable: $f"; fail=1; }
done

for f in \
  AGENTS.guanfu docs-readme context-readme compound-index taste review-rubric \
  brainstorm plan code-review doc-review qa-review architecture-review adr compound-note \
  skill-evolution code-explore backlog-readme work-item best-practices; do
  check_file "skills/gf-init/assets/templates/$f.md"
done

for needle in \
  'Vertical Slice Gate' \
  'Re-run Check' \
  'RED gate' \
  'Doc Lifecycle Audit' \
  'gf-backlog' \
  'gf-qa' \
  'gf-architecture-review' \
  'gf-guardrails'; do
  grep -R -q "$needle" skills/gf-* || { say "MISSING required text: $needle"; fail=1; }
done

set +e
echo '{"tool_input":{"command":"git push origin main"}}' | skills/gf-guardrails/scripts/block-dangerous-git.sh >/tmp/gf_validate_guardrails.out 2>/tmp/gf_validate_guardrails.err
danger=$?
echo '{"tool_input":{"command":"git status --short"}}' | skills/gf-guardrails/scripts/block-dangerous-git.sh >/tmp/gf_validate_guardrails_safe.out 2>/tmp/gf_validate_guardrails_safe.err
safe=$?
set -e
[[ "$danger" == "2" ]] && grep -q BLOCKED /tmp/gf_validate_guardrails.err && say "OK guardrails block dangerous git" || { say "BAD guardrails did not block dangerous git"; fail=1; }
[[ "$safe" == "0" ]] && say "OK guardrails allow safe git" || { say "BAD guardrails blocked safe git"; fail=1; }

tmp="$(mktemp -d)"
mkdir -p "$tmp/skills" "$tmp/repo"
cp -R skills/gf-* "$tmp/skills/"
(
  cd "$tmp/repo"
  bash "$tmp/skills/gf-init/scripts/gf-init.sh" --new >/tmp/gf_validate_init_new.out
  bash "$tmp/skills/gf-init/scripts/gf-init.sh" --audit >/tmp/gf_validate_init_audit.out
)
say "OK gf-init skill-only install simulation"

if [[ "$fail" == "0" ]]; then
  say "STATUS: PASS"
else
  say "STATUS: FAIL"
fi
exit "$fail"
