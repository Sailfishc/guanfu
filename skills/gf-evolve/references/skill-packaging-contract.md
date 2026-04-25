# GuanFu Skill Packaging Contract

## Directory shape

Every runtime skill is self-contained:

```text
skills/<skill-name>/
  SKILL.md
  scripts/      # executable helpers owned by this skill
  assets/       # templates or static resources used by this skill
  references/   # detailed docs loaded only when needed
```

## Frontmatter

Use portable minimum frontmatter:

```yaml
---
name: gf-example
description: Use when <trigger conditions only>.
---
```

Description rules:

- start with `Use when`
- trigger conditions only
- front-load likely search words
- avoid summarizing the workflow

## Runtime resources

A skill that needs scripts or templates owns them inside its directory.

`gf-init` owns:

```text
skills/gf-init/scripts/gf-init.sh
skills/gf-init/assets/templates/*.md
```

The init script resolves its directory from `${BASH_SOURCE[0]}` and copies assets from `../assets/templates`.

## Install simulation

A valid GuanFu package works after copying only `skills/gf-*`:

```bash
mkdir -p ~/.agents/skills
cp -R skills/gf-* ~/.agents/skills/
bash ~/.agents/skills/gf-init/scripts/gf-init.sh --new
```

Same principle for Claude Code:

```bash
mkdir -p ~/.claude/skills
cp -R skills/gf-* ~/.claude/skills/
bash ~/.claude/skills/gf-init/scripts/gf-init.sh --new
```

## Drift checks

Validation should catch:

- package-root runtime templates
- legacy package names
- missing `gf-init/assets/templates`
- `gf-init` script outside `skills/gf-init/scripts/`
- skill descriptions that summarize workflow instead of trigger conditions
- scripts that embed copied templates instead of reading assets
