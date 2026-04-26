# insight-essay-writer v5 publish-polish

Turns source materials, polished reference essays, and multiple model drafts into publishable Chinese longform essays with deep insight and high reader gain.

## What's new in v5

- Section Heading Naturalization Gate: public headings no longer leak internal analysis labels.
- Reader Artifact QA Gate: every decision table, checklist, or field guide must actually help the reader decide.
- Reference Distance Gate: strong reference essays must differ by opening, reader, mechanism, artifact, ending, structure, or evidence mix.
- Claim Calibration Gate: sharp claims get scope, source anchors, and boundary cases.
- Best-of-N Mode: compare multiple model drafts, pick a champion, then salvage the best parts from the others.
- Direct Positive Claim Pass: rewrite contrastive negative constructions into direct positive claims.

## Install

Claude Code:

```bash
mkdir -p ~/.claude/skills
unzip insight-essay-writer-v5-publish-polish.zip -d ~/.claude/skills
```

Codex:

```bash
mkdir -p ~/.agents/skills
unzip insight-essay-writer-v5-publish-polish.zip -d ~/.agents/skills
```

Claude.ai: upload the zip as a custom Skill.
