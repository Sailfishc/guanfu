# Best-of-N Mode

Use when the user provides two or more model outputs from the same source material or same skill.

## Goal

Do not force all models into the same style. Let models surface different angles, then choose the champion and salvage the best parts from the others.

## Workflow

1. Score each article.
2. Pick a champion.
3. Extract salvageable strengths from non-champions.
4. Recommend a merged publication version.
5. Identify skill defects exposed by model variance.

## Scoring dimensions

| Dimension | Question |
|---|---|
| Insight | Does it reveal a mechanism beyond summary? |
| Reader gain | Does the reader know what changed and what to do? |
| Source transformation | Does it use source material deeply? |
| Originality | Does it avoid copying a polished reference or sibling draft? |
| Narrative smoothness | Does it read like an article? |
| Publishability | Could this ship with light editing? |
| Title and headings | Are they natural and reader-facing? |
| Artifact quality | Is the decision tool usable? |
| Claim calibration | Are bold claims scoped and credible? |

## Output format

```text
Verdict:
Champion:
Scores:
Why the champion wins:
What to salvage from other drafts:
Merged publication direction:
Skill issues exposed:
Skill updates recommended:
```

## Merge rule

Use the champion as the base. Add only parts that improve the chosen spine.

Salvageable parts include:

- sharper title
- stronger opening
- better mechanism
- better reader artifact
- better boundary section
- better ending
- underused source detail

Do not merge every good paragraph. Too many good ideas can weaken the spine.
