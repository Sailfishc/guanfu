# Changelog

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
- Updated templates, AGENTS router, validation script, and pressure scenarios to match the new harness contract.

## 0.2.0 - 2026-04-25

- Renamed the public package surface to `gf-*`.
- Added `gf-init` as a first-class skill.
- Added `gf-code-review` and `gf-doc-review` as separate review skills.
- Added `gf-evolve` for validated skill iteration.
- Standardized generated project docs under `docs/guanfu/`.
- Added value statements for reducing AI collaboration failure modes and amplifying AI leverage.

## 0.1.0 - 2026-04-25

- Initial compound engineering skills package.
