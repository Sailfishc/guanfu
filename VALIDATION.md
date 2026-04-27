# GuanFu v0.5 Validation

Date: 2026-04-27
Package: GuanFu v0.5.0

## Decision

STATUS: PASS

## Validation commands run

```bash
bash scripts/gf-validate.sh
bash -n skills/gf-init/scripts/gf-init.sh
bash -n skills/gf-guardrails/scripts/block-dangerous-git.sh
bash -n skills/gf-guardrails/scripts/install-git-guardrails.sh
bash -n scripts/gf-validate.sh
unzip -q /mnt/data/guanfu-v0.5-direct-replace.zip && bash scripts/gf-validate.sh
```

## Covered checks

- Every `skills/gf-*` directory has `SKILL.md` with frontmatter, name, and description.
- `gf-init` bundled templates exist, including backlog, QA, architecture, doc lifecycle, work-item, and best-practices templates.
- P0 gates are still present: Vertical Slice Gate, Re-run Check, RED gate.
- v0.5 skills are present: `gf-backlog`, `gf-qa`, `gf-architecture-review`, `gf-guardrails`.
- Dangerous git guardrail blocks `git push origin main` with exit code 2 and permits `git status --short`.
- `gf-init` skill-only install simulation passes `--new` and `--audit`.
- Bash syntax checks pass for runtime scripts.
- The final direct-replace zip extracts and validates successfully.

## Package validation output

```text
GuanFu validation root: /mnt/data/guanfu-v0.5
OK file: skills/gf-architecture-review/SKILL.md
OK file: skills/gf-backlog/SKILL.md
OK file: skills/gf-brainstorm/SKILL.md
OK file: skills/gf-code-review/SKILL.md
OK file: skills/gf-compound/SKILL.md
OK file: skills/gf-doc-review/SKILL.md
OK file: skills/gf-evolve/SKILL.md
OK file: skills/gf-guardrails/SKILL.md
OK file: skills/gf-init/SKILL.md
OK file: skills/gf-plan/SKILL.md
OK file: skills/gf-qa/SKILL.md
OK file: skills/gf-work/SKILL.md
OK file: skills/gf-init/scripts/gf-init.sh
OK file: skills/gf-guardrails/scripts/block-dangerous-git.sh
OK file: skills/gf-guardrails/scripts/install-git-guardrails.sh
OK file: skills/gf-init/assets/templates/AGENTS.guanfu.md
OK file: skills/gf-init/assets/templates/docs-readme.md
OK file: skills/gf-init/assets/templates/context-readme.md
OK file: skills/gf-init/assets/templates/compound-index.md
OK file: skills/gf-init/assets/templates/taste.md
OK file: skills/gf-init/assets/templates/review-rubric.md
OK file: skills/gf-init/assets/templates/brainstorm.md
OK file: skills/gf-init/assets/templates/plan.md
OK file: skills/gf-init/assets/templates/code-review.md
OK file: skills/gf-init/assets/templates/doc-review.md
OK file: skills/gf-init/assets/templates/qa-review.md
OK file: skills/gf-init/assets/templates/architecture-review.md
OK file: skills/gf-init/assets/templates/adr.md
OK file: skills/gf-init/assets/templates/compound-note.md
OK file: skills/gf-init/assets/templates/skill-evolution.md
OK file: skills/gf-init/assets/templates/code-explore.md
OK file: skills/gf-init/assets/templates/backlog-readme.md
OK file: skills/gf-init/assets/templates/work-item.md
OK guardrails block dangerous git
OK guardrails allow safe git
OK gf-init skill-only install simulation
STATUS: PASS
```

## Zip extraction validation output

```text
GuanFu validation root: /mnt/data/guanfu-v0.5-ziptest-final
OK file: skills/gf-architecture-review/SKILL.md
OK file: skills/gf-backlog/SKILL.md
OK file: skills/gf-brainstorm/SKILL.md
OK file: skills/gf-code-review/SKILL.md
OK file: skills/gf-compound/SKILL.md
OK file: skills/gf-doc-review/SKILL.md
OK file: skills/gf-evolve/SKILL.md
OK file: skills/gf-guardrails/SKILL.md
OK file: skills/gf-init/SKILL.md
OK file: skills/gf-plan/SKILL.md
OK file: skills/gf-qa/SKILL.md
OK file: skills/gf-work/SKILL.md
OK file: skills/gf-init/scripts/gf-init.sh
OK file: skills/gf-guardrails/scripts/block-dangerous-git.sh
OK file: skills/gf-guardrails/scripts/install-git-guardrails.sh
OK file: skills/gf-init/assets/templates/AGENTS.guanfu.md
OK file: skills/gf-init/assets/templates/docs-readme.md
OK file: skills/gf-init/assets/templates/context-readme.md
OK file: skills/gf-init/assets/templates/compound-index.md
OK file: skills/gf-init/assets/templates/taste.md
OK file: skills/gf-init/assets/templates/review-rubric.md
OK file: skills/gf-init/assets/templates/brainstorm.md
OK file: skills/gf-init/assets/templates/plan.md
OK file: skills/gf-init/assets/templates/code-review.md
OK file: skills/gf-init/assets/templates/doc-review.md
OK file: skills/gf-init/assets/templates/qa-review.md
OK file: skills/gf-init/assets/templates/architecture-review.md
OK file: skills/gf-init/assets/templates/adr.md
OK file: skills/gf-init/assets/templates/compound-note.md
OK file: skills/gf-init/assets/templates/skill-evolution.md
OK file: skills/gf-init/assets/templates/code-explore.md
OK file: skills/gf-init/assets/templates/backlog-readme.md
OK file: skills/gf-init/assets/templates/work-item.md
OK guardrails block dangerous git
OK guardrails allow safe git
OK gf-init skill-only install simulation
STATUS: PASS
```

## Remaining risk

Fresh agent behavior has not been validated in a live multi-turn project run. The package includes pressure scenarios for that next validation layer.
