#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

printf 'Validating GuanFu package at %s\n' "$ROOT"

expected=(
  gf-init
  gf-brainstorm
  gf-plan
  gf-work
  gf-code-review
  gf-doc-review
  gf-compound
  gf-evolve
)

for skill in "${expected[@]}"; do
  file="skills/$skill/SKILL.md"
  [[ -f "$file" ]] || fail "missing $file"
  grep -q "^name: $skill$" "$file" || fail "$file name mismatch"
  grep -q '^description: Use when' "$file" || fail "$file description must start with Use when"
  grep -q '^version: ' "$file" || fail "$file missing version"
done

for dir in skills/gf-*; do
  [[ -d "$dir" ]] || continue
  name="$(basename "$dir")"
  found=0
  for skill in "${expected[@]}"; do [[ "$name" == "$skill" ]] && found=1; done
  [[ "$found" == "1" ]] || fail "unexpected skill directory $dir"
done

legacy_prefix="c""e-"
if grep -RIn --exclude='gf-validate.sh' "$legacy_prefix" README.md README.guanfu.md skills templates tests scripts bin VALIDATION.md MANIFEST.md CHANGELOG.md >/tmp/guanfu-legacy-prefix.txt 2>/dev/null; then
  cat /tmp/guanfu-legacy-prefix.txt >&2
  fail "legacy ce-* prefix found"
fi

if grep -RIn --exclude=gf-validate.sh "gf-improve\|docs/ce\|compound-engineering" README.md README.guanfu.md skills templates tests scripts bin VALIDATION.md MANIFEST.md CHANGELOG.md >/tmp/guanfu-stale.txt 2>/dev/null; then
  cat /tmp/guanfu-stale.txt >&2
  fail "stale package naming found"
fi

grep -RIn "docs/guanfu" README.md skills templates scripts tests >/dev/null || fail "docs/guanfu path missing from package docs"

grep -RIn "AUTOMATED_AFTER_PLAN" README.md skills templates scripts >/dev/null || fail "automated execution contract missing"

grep -RIn "First failure\|first failure\|第一次失败" README.md skills templates scripts >/dev/null || fail "failure budget principle missing"

# Only human-loop skills should be allowed to ask questions.
for skill in gf-work gf-code-review gf-doc-review gf-compound gf-evolve gf-init; do
  if grep -q 'AskUserQuestion' "skills/$skill/SKILL.md"; then
    fail "$skill should not use AskUserQuestion in automated stages"
  fi
done

grep -q 'AskUserQuestion' skills/gf-brainstorm/SKILL.md || fail "gf-brainstorm must support AskUserQuestion"
grep -q 'AskUserQuestion' skills/gf-plan/SKILL.md || fail "gf-plan must support AskUserQuestion"

# Any skill containing bash fences should allow Bash.
for file in skills/gf-*/SKILL.md; do
  if grep -q '```bash' "$file" && ! awk '/allowed-tools:/,/triggers:/' "$file" | grep -q '  - Bash'; then
    fail "$file contains bash blocks but allowed-tools lacks Bash"
  fi
done

# Package-level required files.
for file in \
  README.md README.guanfu.md MANIFEST.md VALIDATION.md CHANGELOG.md VERSION \
  scripts/gf-init.sh scripts/gf-validate.sh bin/gf-init.sh \
  templates/AGENTS.guanfu.md templates/brainstorm.md templates/plan.md \
  templates/review.md templates/doc-review.md templates/compound-note.md templates/skill-evolution.md \
  tests/pressure-scenarios.md; do
  [[ -f "$file" ]] || fail "missing $file"
done

bash -n scripts/gf-init.sh
bash -n scripts/gf-validate.sh
bash scripts/gf-init.sh --dry-run >/tmp/guanfu-init-dry-run.txt
bash scripts/gf-init.sh --audit >/tmp/guanfu-init-audit.txt 2>/tmp/guanfu-init-audit.err || true

printf 'PASS: GuanFu package validation complete.\n'
