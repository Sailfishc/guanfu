# Validation Notes

Package version: 0.2.0

Checked locally:

- Every skill directory uses the `gf-*` prefix.
- Every skill frontmatter includes `name` and `description`.
- Every skill description starts with `Use when...`.
- Every expected skill exists: `gf-init`, `gf-brainstorm`, `gf-plan`, `gf-work`, `gf-code-review`, `gf-doc-review`, `gf-compound`, `gf-evolve`.
- Generated project docs use `docs/guanfu/`.
- `scripts/gf-init.sh` passes `bash -n`.
- `scripts/gf-init.sh --dry-run` runs without writing project files.
- `scripts/gf-validate.sh` passes on this package.

Recommended project-local validation:

1. Install the skills into `~/.claude/skills/` or `~/.agents/skills/`.
2. Run `/gf-init` in a small real repo.
3. Confirm `docs/guanfu/context/code-explore-YYYY-MM-DD.md` captures useful repo context.
4. Run one complete feature cycle:

```text
/gf-brainstorm
/gf-plan
/gf-work
/gf-code-review
/gf-doc-review
/gf-compound
/gf-evolve
```

5. Trigger `/gf-evolve` from a real failure and verify the skill/template/test changes improve future behavior.
