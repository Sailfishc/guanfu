# Eval Method for Skills

## What to measure

Skill evals measure two things:

| Metric | Meaning |
|---|---|
| Activation recall | The skill appears when it should |
| Activation precision | The skill stays out of related tasks that route elsewhere |
| Behavior score | The loaded skill follows its workflow |
| Boundary score | The skill avoids forbidden tools, files, or side effects |
| Output score | The final artifact matches the expected contract |
| Package score | The package installs and exposes visible/discoverable paths |

## Case format

Use JSONL:

```jsonl
{"id":"positive_create_skill","prompt":"Create a Codex skill for reviewing API contracts with evals.","should_trigger":true,"expected_sections":["SKILL BRIEF","EVAL CASES"],"expected_files":["skills/reviewing-api-contracts/SKILL.md","evals/cases.jsonl"],"category":"positive"}
{"id":"negative_use_existing","prompt":"Use the reviewing-api-contracts skill to review this OpenAPI diff.","should_trigger":false,"category":"route-away"}
```

## Minimum eval set

- 3 positive trigger cases
- 3 route-away cases
- 2 pressure cases
- 1 explicit invocation case
- 1 package layout case

## Baseline and candidate

Run both when possible:

```bash
node evals/scripts/run-evals.mjs --mode both --agent codex
```

Baseline removes the candidate skill from the fixture. Candidate installs it. Compare activation, output sections, forbidden behavior, and package layout.

## Static grading

Static checks are deterministic:

- frontmatter exists and parses
- `name` matches path
- description length and trigger words
- `SKILL.md` under the configured line limit
- references are one level deep
- scripts are local-only by default
- package includes visible `skills/`
- Codex/Claude mirrors are byte-identical

## Dynamic grading

Dynamic checks run the target agent CLI when available:

- Prompt the agent with each case
- Capture final output and JSON event stream when available
- Check expected sections, files, and forbidden phrases/actions
- Generate `evals/reports/latest.json` and `latest.md`

Dynamic evals can be expensive. Keep smoke suites small and run full suites before release.

## Scoring

Recommended gate:

```text
activation_recall >= 0.80
activation_precision >= 0.90
behavior_score >= 0.75
boundary_score >= 0.90
package_score = 1.00
```

Optimize for correct routing. Raw trigger count is a vanity metric.
