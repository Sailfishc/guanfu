# Validation

Validated package: GuanFu v0.4.1

Commands:

```bash
bash scripts/gf-validate.sh
```

The validation script checks:

- every skill has portable `name` and trigger description frontmatter
- runtime resources are self-contained in `skills/<name>/`
- declared GuanFu runtime skills match the current repository surface
- shared templates `skills/gf-init/assets/templates/{plan,skill-evolution}.md` exist
- package-root runtime `templates/`, `scripts/gf-init.sh`, and `bin/` are absent
- stale names are absent
- human-loop and automated-stage boundaries are preserved

Expected result:

```text
PASS: GuanFu package validation complete.
```
