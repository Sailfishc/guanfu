#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

printf 'Validating GuanFu package at %s\n' "$ROOT"

for dir in skills/gf-*; do
  [[ -d "$dir" ]] || continue
  [[ -f "$dir/SKILL.md" ]] || fail "$dir missing SKILL.md"
  grep -q '^name: gf-' "$dir/SKILL.md" || fail "$dir SKILL.md name must use gf-*"
  grep -q '^description: Use when' "$dir/SKILL.md" || fail "$dir description must start with Use when"
done

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
  [[ -f "skills/$skill/SKILL.md" ]] || fail "missing skills/$skill/SKILL.md"
done

legacy_prefix="c""e-"
if grep -RIn --exclude='gf-validate.sh' "$legacy_prefix" README.md README.guanfu.md skills templates tests scripts bin VALIDATION.md MANIFEST.md CHANGELOG.md >/tmp/guanfu-legacy-prefix.txt 2>/dev/null; then
  cat /tmp/guanfu-legacy-prefix.txt >&2
  fail "legacy command prefix found"
fi

legacy_docs="docs/""ce"
if grep -RIn --exclude='gf-validate.sh' "$legacy_docs" README.md README.guanfu.md skills templates tests scripts bin VALIDATION.md MANIFEST.md CHANGELOG.md >/tmp/guanfu-legacy-docs.txt 2>/dev/null; then
  cat /tmp/guanfu-legacy-docs.txt >&2
  fail "legacy docs path found"
fi

short_docs="docs/""gf"
if grep -RIn --exclude='gf-validate.sh' "$short_docs" README.md README.guanfu.md skills templates tests scripts bin VALIDATION.md MANIFEST.md CHANGELOG.md >/tmp/guanfu-short-docs.txt 2>/dev/null; then
  cat /tmp/guanfu-short-docs.txt >&2
  fail "short docs path found; use docs/guanfu"
fi

bash -n scripts/gf-init.sh
bash scripts/gf-init.sh --dry-run >/tmp/guanfu-init-dry-run.txt

grep -q 'GuanFu init root' /tmp/guanfu-init-dry-run.txt || fail "gf-init dry run output missing marker"

printf 'PASS: GuanFu package validation succeeded.\n'
