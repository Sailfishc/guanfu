# Validation Notes

Package version: 0.3.0

Validated locally:

- Every expected skill exists: `gf-init`, `gf-brainstorm`, `gf-plan`, `gf-work`, `gf-code-review`, `gf-doc-review`, `gf-compound`, `gf-evolve`.
- Every skill directory uses the `gf-*` prefix.
- Every skill frontmatter includes `name`, `version`, and a `description` starting with `Use when...`.
- No stale `legacy command prefix`, `legacy evolve skill name`, `legacy docs path`, or old package naming remains.
- Generated project docs use `docs/guanfu/`.
- The harness contract appears in README, AGENTS template, init script, and skills.
- `AskUserQuestion` is limited to `gf-brainstorm` and `gf-plan`.
- Automated stages describe anomaly recording and next-step routing.
- Skills with bash blocks include `Bash` in allowed tools.
- `scripts/gf-init.sh` passes `bash -n`.
- `scripts/gf-validate.sh` passes `bash -n`.
- `scripts/gf-init.sh --dry-run` runs successfully.
- `scripts/gf-validate.sh` passes on this package.

Recommended project-local validation:

1. Install the skills into `~/.claude/skills/` or `~/.agents/skills/`.
2. Run `/gf-init` in a small real repo.
3. Confirm `AGENTS.md` contains:
   - `## GuanFu Router`
   - `## GuanFu Harness Contract`
   - `## GuanFu Taste`
   - `Execution Mode: AUTOMATED_AFTER_PLAN`
4. Confirm `docs/guanfu/` contains the expected directories and templates.
5. Run one full cycle:

```text
/gf-brainstorm
/gf-plan
/gf-work
/gf-code-review
/gf-doc-review
/gf-compound
/gf-evolve, if a skill or harness gap appears
```

6. Trigger a pressure scenario for premature brainstorm drafting or mid-execution asking, then verify the new rules change agent behavior.
