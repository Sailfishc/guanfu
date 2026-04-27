# Changelog

## Unreleased

- Removed the stale `gf-init` runtime surface from package docs and validation.
- Reframed the remaining `skills/gf-init/assets/templates/{plan,skill-evolution}.md` files as shared template examples instead of an installable skill.
- Updated package pressure scenarios so `gf-evolve` now guards against doc and validator drift after package-surface changes.

## 0.4.1 - 2026-04-25

- Kept the Agent Skills standard packaging from v0.4.0 and fixed validation around standard frontmatter.
- Standardized `gf-init` runtime assets under `skills/gf-init/assets/templates/`.
- Standardized generated project templates back to stage-specific paths such as `docs/guanfu/brainstorms/BRAINSTORM_TEMPLATE.md` and `docs/guanfu/plans/PLAN_TEMPLATE.md`.
- Added skill-only install simulation that copies only `skills/gf-*` and verifies `gf-init` still creates the full docs harness.
- Removed dependency on package-root runtime templates, duplicate init scripts, and wrapper bins.

## 0.4.0 - 2026-04-25

- Repackaged GuanFu to match Agent Skills directory conventions: each runtime skill is self-contained under `skills/<name>/` with `SKILL.md` plus optional `scripts/`, `assets/`, and `references/`.
- Moved all runtime templates into `skills/gf-init/assets/`. Installing only `skills/gf-*` into Codex or Claude now preserves the same templates used by `gf-init`.
- Moved the init script into `skills/gf-init/scripts/gf-init.sh` and made it copy assets from its own skill directory. The script no longer embeds template text or depends on package-root `templates/`.
- Simplified every skill frontmatter to the portable minimum: `name` and trigger-only `description`.
- Added `skills/gf-evolve/references/skill-packaging-contract.md` and `skills/gf-evolve/references/pressure-scenarios.md` so future skill evolution can validate packaging, template drift, and Codex/Claude install behavior.
- Updated validation to simulate a skill-only Codex/Claude install and verify that `gf-init` can initialize a repository from its internal assets.

## 0.3.0 - 2026-04-25

- Added the GuanFu harness contract: `gf-brainstorm` and `gf-plan` are human-loop stages; `gf-work`, `gf-code-review`, `gf-doc-review`, `gf-compound`, and `gf-evolve` run as the automated post-plan chain.
- Added the failure budget principle: first failure is a signal; repeated failure is a harness gap.
- Strengthened `gf-brainstorm` with multi-turn coverage scoring, question-turn floors, readiness gate, value mapping, and evolution hook.
- Strengthened `gf-plan` with Input Readiness Gate, ADR decision matrix, full slice schema, rollback paths, and approval gate that sets `Execution Mode: AUTOMATED_AFTER_PLAN`.
- Strengthened `gf-work` with Work Entry Check, Anomaly Log, Fresh Verification Check, automated next-step routing, and relevant compound retrieval.
- Strengthened `gf-code-review` with Review Scope Check, diff/base detection, verification freshness audit, pattern extraction, and automated routing.
- Strengthened `gf-doc-review` with Artifact Lineage Check, Fresh Agent Handoff Test, safe doc fixes, and automated routing.
- Strengthened `gf-compound` with Failure Budget Status, mandatory Guardrail Decision, retrieval metadata, supersedes/related notes, and repeated-failure escalation.
- Strengthened `gf-evolve` with RED → PATCH → RETEST, baseline agent behavior, pressure scenarios, validation, and status lifecycle.
- Added `gf-init.sh --new`, `--refresh`, and `--audit` modes.

## 0.2.0 - 2026-04-25

- Renamed the public package surface to `gf-*`.
- Added `gf-init` as a first-class skill.
- Added `gf-code-review` and `gf-doc-review` as separate review skills.
- Added `gf-evolve` for validated skill iteration.
- Standardized generated project docs under `docs/guanfu/`.
- Added value statements for reducing AI collaboration failure modes and amplifying AI leverage.

## 0.1.0 - 2026-04-25

- Initial compound engineering skills package.
