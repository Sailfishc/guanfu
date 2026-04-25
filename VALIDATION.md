# Validation

Validated package: GuanFu v0.4.1

Commands:

```bash
bash scripts/gf-validate.sh
```

The validation script checks:

- every skill has portable `name` and trigger description frontmatter
- runtime resources are self-contained in `skills/<name>/`
- `gf-init` owns `scripts/gf-init.sh` and `assets/templates/*.md`
- package-root runtime `templates/`, `scripts/gf-init.sh`, and `bin/` are absent
- skill-only install simulation succeeds
- generated `docs/guanfu/` templates match `gf-init` assets
- stale names are absent
- human-loop and automated-stage boundaries are preserved

Expected result:

```text
PASS: GuanFu package validation complete.
```
