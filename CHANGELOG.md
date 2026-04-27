# CHANGELOG

## v0.5.0 - 2026-04-27

Release theme: Prevention + Backlog Layer.

### Added

- `gf-backlog`: local-first, backend-agnostic work item layer.
- `gf-qa`: behavior-first manual QA capture into durable work items.
- `gf-architecture-review`: architecture prevention layer using deep-module vocabulary and deletion test.
- `gf-guardrails`: executable dangerous-git hook and installer/auditor.
- Backlog templates: `backlog-readme.md`, `work-item.md`.
- QA and architecture review templates.
- Best practices document at `docs/guanfu/best-practices/GUANFU_WORKFLOW_BEST_PRACTICES.md`.
- v0.5 pressure scenarios for backlog, QA, architecture, doc lifecycle, and guardrails.

### Changed

- `gf-plan` now reads backlog/QA/architecture inputs and links slices to local work items.
- `gf-work` now updates linked work items and treats backlog status as evidence to verify, not truth to trust.
- `gf-code-review` now routes persistent follow-ups to `gf-backlog` and structural friction to `gf-architecture-review`.
- `gf-doc-review` now includes Doc Lifecycle Audit to prevent stale docs from becoming current instructions.
- `gf-compound` owner skills now include backlog, QA, architecture review, and guardrails.
- `gf-init` version updated to `0.5.0`; init templates and audit include backlog, QA, architecture, and optional guardrail status.
- Router template updated for v0.5 skills.

### Preserved

- P0 Vertical Slice Gate in `gf-plan`.
- P0 Re-run Behavior in `gf-work`.
- P0 RED Gate in `gf-evolve`.
