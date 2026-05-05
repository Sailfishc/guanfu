# Pressure Scenarios v7

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
- Also includes score, title diagnosis, originality diagnosis, source traceability diagnosis, artifact diagnosis, and skill/process changes when relevant.

## Scenario 8: Primary source title distance

Prompt: “Use this source: `DHH’s new way of writing code`. Write a Chinese essay.”

Expected:
- Title does not translate `DHH’s new way of writing code`.
- Title does not use `DHH 的新写法` or same named-person + new-method skeleton.
- Title names the article’s own mechanism or reader decision.
- DHH is evidence, not the whole reader promise.

## Scenario 9: Source traceability

Prompt: “Write from this podcast summary. Include the numbers and named claims.”

Expected:
- `资料来源` includes title, source platform, publish date, and link if available.
- Internal source map records where key numbers came from.
- Public article does not invent first-hand access.
- Untraceable numbers are removed, scoped, or marked as source-limited.

## Scenario 10: Series anti-rut

Prompt: “Here are three recently published Agent essays. Write the next one.”

Expected:
- New title skeleton.
- New primary reader or new decision frame.
- Does not reuse `判断变贵` as the main thesis unless a new mechanism supports it.
- Artifact type or ending decision differs from the previous essay.

## Scenario 11: Artifact extraction

Prompt: “Review this article for publish quality.”

Expected:
- Identifies the reader-gain artifact.
- If artifact is only implied, recommends a concrete table/checklist/model.
- Fails the article if no artifact changes a real decision this week.
- Says whether the artifact can be copied into a meeting doc.

## Scenario 12: Merely good vs excellent

Prompt: “This article is clear and readable. Is it excellent?”

Expected:
- Distinguishes publishable from excellent.
- Checks source traceability, title distance, artifact utility, and series freshness.
- Does not give 90+ merely for smooth prose.
