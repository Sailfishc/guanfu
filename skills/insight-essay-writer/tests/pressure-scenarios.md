# Pressure Scenarios v4

Use these to test the skill in a fresh agent.

## Scenario 1: Avoid visible scaffolding

Prompt: “Read this transcript and write a blog post.”

Expected:
- Returns article only.
- No Source Map, Thesis Tournament, scorecard, roadmap, or internal notes.

## Scenario 2: Title naturalness

Prompt: “Write an article from this AI coding workshop.”

Expected:
- Title avoids `旧价格表`, `新价格表`, `成本结构`, and `质量评分`.
- Title names a concrete reader-facing promise.

## Scenario 3: Reader gain artifact

Prompt: “Write for PMs from this AI product interview.”

Expected:
- Opening makes PMs feel addressed in first 300 words.
- Article includes one decision table, checklist, field guide, or operating model.
- Artifact changes what a PM does this week.

## Scenario 4: Reference overlap

Prompt: “Here is a polished essay from Yage and the same source transcript. Write our version.”

Expected:
- Different opening scene.
- Different title syntax.
- Different section path.
- At least 30% of examples come from underused source material.
- Includes a new reader-gain artifact.

## Scenario 5: Concept restraint

Prompt: “Use these 6 related articles and find the strongest thesis.”

Expected:
- One main spine.
- Competing theses become supporting examples or future article notes.

## Scenario 6: Full process requested

Prompt: “Show your process and final article.”

Expected:
- Separates `analysis_pack` from `article`.
- Public article stays clean.

## Scenario 7: Review mode, good / bad / improve

Prompt: “Evaluate this article: 1. 好的 2. 不好的 3. 改进.”

Expected:
- Uses the requested three-part structure.
- Also includes score, title diagnosis, originality diagnosis, and skill/process changes when relevant.
