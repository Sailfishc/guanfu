#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() { printf 'FAIL: %s\n' "$1" >&2; exit 1; }

printf 'Validating GuanFu package at %s\n' "$ROOT"

expected=(gf-init gf-brainstorm gf-plan gf-work gf-code-review gf-doc-review gf-compound gf-evolve)

for skill in "${expected[@]}"; do
  file="skills/$skill/SKILL.md"
  [[ -f "$file" ]] || fail "missing $file"
  grep -q "^name: $skill$" "$file" || fail "$file name mismatch"
  grep -q '^description: Use when' "$file" || fail "$file description must start with Use when"
  frontmatter="$(awk 'BEGIN{n=0} /^---$/{n++; next} n==1{print}' "$file")"
  echo "$frontmatter" | grep -q '^name: ' || fail "$file missing name in frontmatter"
  echo "$frontmatter" | grep -q '^description: ' || fail "$file missing description in frontmatter"
  if echo "$frontmatter" | grep -qE '^(version|allowed-tools|triggers|preamble-tier|sensitive):'; then
    fail "$file has non-portable frontmatter fields"
  fi
  lines=$(wc -l < "$file" | tr -d ' ')
  [[ "$lines" -le 500 ]] || fail "$file exceeds 500 lines"
done

for dir in skills/gf-*; do
  [[ -d "$dir" ]] || continue
  name="$(basename "$dir")"
  found=0
  for skill in "${expected[@]}"; do [[ "$name" == "$skill" ]] && found=1; done
  [[ "$found" == "1" ]] || fail "unexpected skill directory $dir"
done

[[ -f skills/gf-init/scripts/gf-init.sh ]] || fail "missing skills/gf-init/scripts/gf-init.sh"
[[ -d skills/gf-init/assets/templates ]] || fail "missing skills/gf-init/assets/templates"
[[ -f skills/gf-evolve/references/skill-packaging-contract.md ]] || fail "missing packaging contract reference"
[[ -f skills/gf-evolve/references/pressure-scenarios.md ]] || fail "missing pressure scenarios reference"

for template in AGENTS.guanfu docs-readme context-readme compound-index taste review-rubric brainstorm plan code-review doc-review adr compound-note skill-evolution code-explore; do
  [[ -s "skills/gf-init/assets/templates/$template.md" ]] || fail "missing gf-init asset $template.md"
done

[[ ! -d templates ]] || fail "runtime templates directory must live under skills/gf-init/assets/templates/, not package root"
[[ ! -f scripts/gf-init.sh ]] || fail "runtime gf-init script must live under skills/gf-init/scripts/, not package root scripts/"
[[ ! -d bin ]] || fail "runtime gf-init wrapper must not live in package root bin/"

legacy_prefix="c""e-"
if grep -RIn --exclude='gf-validate.sh' "$legacy_prefix" README.md skills tests scripts VALIDATION.md MANIFEST.md CHANGELOG.md >/tmp/guanfu-legacy-prefix.txt 2>/dev/null; then
  cat /tmp/guanfu-legacy-prefix.txt >&2
  fail "legacy ce-* prefix found"
fi

if grep -RIn --exclude='gf-validate.sh' "gf-improve\|docs/ce\|compound-engineering" README.md skills tests scripts VALIDATION.md MANIFEST.md CHANGELOG.md >/tmp/guanfu-stale.txt 2>/dev/null; then
  cat /tmp/guanfu-stale.txt >&2
  fail "stale package naming found"
fi

grep -RIn "docs/guanfu" README.md skills scripts tests >/dev/null || fail "docs/guanfu path missing"
grep -RIn "AUTOMATED_AFTER_PLAN" README.md skills scripts >/dev/null || fail "automated execution contract missing"
grep -RIn "First failure\|first failure" README.md skills scripts >/dev/null || fail "failure budget principle missing"

for skill in gf-work gf-code-review gf-doc-review gf-compound gf-evolve gf-init; do
  if grep -q 'AskUserQuestion' "skills/$skill/SKILL.md"; then
    fail "$skill should not use AskUserQuestion in automated stages"
  fi
done
grep -q 'human-loop' skills/gf-brainstorm/SKILL.md || fail "gf-brainstorm must be marked as human-loop"
grep -q 'human-loop' skills/gf-plan/SKILL.md || fail "gf-plan must be marked as human-loop"

bash -n skills/gf-init/scripts/gf-init.sh
bash -n scripts/gf-validate.sh
bash skills/gf-init/scripts/gf-init.sh --dry-run >/tmp/guanfu-init-dry-run.txt

grep -q 'Assets dir: .*skills/gf-init/assets/templates' /tmp/guanfu-init-dry-run.txt || fail "gf-init dry run must report skill-local assets dir"

SIM="$(mktemp -d)"
trap 'rm -rf "$SIM"' EXIT
mkdir -p "$SIM/skills" "$SIM/repo"
cp -R skills/gf-* "$SIM/skills/"
(
  cd "$SIM/repo"
  bash "$SIM/skills/gf-init/scripts/gf-init.sh" --new >/tmp/guanfu-sim-init.txt
  bash "$SIM/skills/gf-init/scripts/gf-init.sh" --audit >/tmp/guanfu-sim-audit.txt
)

for f in \
  "$SIM/repo/AGENTS.md" \
  "$SIM/repo/docs/guanfu/context/CODE_EXPLORE_TEMPLATE.md" \
  "$SIM/repo/docs/guanfu/brainstorms/BRAINSTORM_TEMPLATE.md" \
  "$SIM/repo/docs/guanfu/plans/PLAN_TEMPLATE.md" \
  "$SIM/repo/docs/guanfu/reviews/code/CODE_REVIEW_TEMPLATE.md" \
  "$SIM/repo/docs/guanfu/reviews/docs/DOC_REVIEW_TEMPLATE.md" \
  "$SIM/repo/docs/guanfu/compound/COMPOUND_NOTE_TEMPLATE.md" \
  "$SIM/repo/docs/guanfu/evolution/EVOLUTION_TEMPLATE.md"; do
  [[ -f "$f" ]] || fail "skill-only simulation missing $f"
done

grep -q "## GuanFu Router" "$SIM/repo/AGENTS.md" || fail "generated AGENTS lacks router"
grep -q "## GuanFu Harness Contract" "$SIM/repo/AGENTS.md" || fail "generated AGENTS lacks harness contract"
cmp -s skills/gf-init/assets/templates/brainstorm.md "$SIM/repo/docs/guanfu/brainstorms/BRAINSTORM_TEMPLATE.md" || fail "brainstorm template drift"
cmp -s skills/gf-init/assets/templates/plan.md "$SIM/repo/docs/guanfu/plans/PLAN_TEMPLATE.md" || fail "plan template drift"

grep -q "STATUS: OK" /tmp/guanfu-sim-audit.txt || fail "audit did not pass after new init"

printf 'PASS: GuanFu package validation complete.\n'
