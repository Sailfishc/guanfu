# Validation Notes

What was checked in this package:

- YAML frontmatter includes `name` and `description` for every skill.
- Descriptions start with `Use when...` and avoid summarizing the workflow.
- `ce-init.sh` passes `bash -n`.
- `ce-init.sh --dry-run` runs without creating files.
- `ce-init.sh` was executed in a temporary git repo and created the expected docs contract.
- A second run is idempotent: existing files are skipped and router sections are not duplicated.

What still needs project-local validation:

- Run the pressure scenarios in `tests/pressure-scenarios.md` with actual subagents before deploying broadly.
- Run `/ce-init` inside the target repo and confirm the code-explore report is useful.
- Run one full cycle on a small feature: `/ce-brainstorm -> /ce-plan -> /ce-work -> /ce-code-review -> /ce-compound`.
