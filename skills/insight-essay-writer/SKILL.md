---
name: insight-essay-writer
description: Use when turning articles, transcripts, documents, events, releases, meeting notes, customer materials, research clippings, or polished reference essays into a publishable high-insight Chinese longform article, or when reviewing such drafts.
---

# Insight Essay Writer

## Core principle

Produce a publishable Chinese essay with a real argument. Keep the research workbench internal. The article should give readers a portable insight, a felt payoff, and one usable decision tool.

Insight remains first. Reader gain converts insight into value. Publication cleanliness keeps the final article ready to publish.

## Default deliverable

For drafting requests, return a public article only:

1. Natural title.
2. Publishable Chinese article body.
3. Short `资料来源` only when the user asks, citations are required, or factual traceability matters.

Keep source maps, thesis tournaments, internal cost tables, scorecards, roadmap, prompt notes, and generation notes out of the public article. If the user requests process transparency, return two outputs: `article.md` and `analysis_pack.md`.

For review requests, return verdict, score, diagnosis, and concrete revision plan. Rewrite only when asked.

## Priority order

1. Deep insight. The essay must change how the reader understands the material.
2. Source transformation. The essay must add a new angle, mechanism, or decision frame.
3. Reader gain. The reader should know what they learned and what they can do differently.
4. Publication cleanliness. The final article should read like a finished article.
5. Natural title and headings. Internal analysis labels stay internal.

## Internal workflow

Track this checklist internally:

```text
Insight Essay Progress
- [ ] Read all materials
- [ ] Classify sources: raw material / polished reference / target style
- [ ] Build source map
- [ ] Identify old assumptions
- [ ] Build internal cost-change table
- [ ] Run thesis tournament
- [ ] Choose reader and reader gain
- [ ] Choose one spine
- [ ] Run source-relative originality gate
- [ ] Choose mechanism name
- [ ] Generate title candidates
- [ ] Select reader-gain artifact
- [ ] Draft outline with natural headings
- [ ] Run pre-draft gates
- [ ] Write publishable article
- [ ] Run quality gate
- [ ] Rewrite once if score < 90 or a hard gate fails
```

## 1. Classify the input sources

Before choosing a thesis, classify each source:

| Type | Definition | How to use |
|---|---|---|
| Raw material | Transcript, interview, release note, meeting note, event list, customer notes | Mine for facts, scenes, tensions, details |
| Polished reference | A finished essay already interpreting the same material | Treat as a competitor or style reference, avoid copying its opening, title pattern, structure, main metaphor |
| Target style | An essay supplied mainly to show desired style | Learn rhythm and quality bar, avoid duplicating specific claims or scenes |

If one source is a polished reference essay about the same raw material, run the originality gate before drafting. See [originality-gate.md](references/originality-gate.md).

## 2. Build the internal source map

Use this internally:

| Field | Capture |
|---|---|
| Key fact | Specific event, number, quote, tool, actor, workflow, or failure |
| Source | File, link, speaker, timestamp, or document title |
| Surface topic | What the material appears to discuss |
| Old assumption | Hidden premise that made the old workflow sensible |
| Changed cost | Time, money, execution, verification, trust, coordination, compliance, attention |
| New scarcity | What becomes more valuable after the cost changes |
| Reader relevance | Why the target reader should care |
| Evidence | Concrete supporting detail |
| Underused detail | Strong material not emphasized by polished references |
| Boundary | Where the claim breaks or becomes risky |

Density target: at least 12 concrete details for one long source, or at least 5 details per source for multi-source inputs. When a polished reference exists, at least 30% of public examples should come from underused details.

## 3. Identify old assumptions

Find 3 to 7 old assumptions, then pick one dominant assumption.

```text
Old assumption:
Why it used to be rational:
What changed in the material:
New scarcity:
Reader decision that should change:
```

The old workflow should feel historically rational. Good essays reprice old behavior instead of mocking it.

## 4. Build the internal cost-change table

Use this internally:

| Old cost condition | New cost condition | New bottleneck | Who feels it | Decision change |
|---|---|---|---|---|

This is an analysis tool. In the public article, translate it into natural prose or a reader-facing table. Avoid internal labels like `旧价格表`, `新价格表`, `成本结构`, `cost table`, `quality gate`, and `roadmap` as titles or section headings.

## 5. Run the thesis tournament

Generate 10 candidate theses. Score each 1-5 on:

- Explanatory power
- Surprise
- Transferability
- Actionability
- Evidence strength
- Reader gain
- Shareability
- Originality against any polished reference
- Naming potential

Candidate template:

```text
Title promise:
One-sentence thesis:
Explains these materials:
Old assumption it revises:
Changed cost:
New scarcity:
Target reader:
Reader gain:
Action framework:
Boundary case:
Source-relative originality:
Scores:
```

Pick one main thesis. Pick up to two supporting ideas. Move extra good ideas to future-article notes so the article stays focused.

## 6. Choose the reader and gain

Before outlining, define:

```text
Primary reader:
Their current confusion:
What they will understand after reading:
What decision they make differently:
Sentence they can repeat to someone else:
Highest-gain paragraph:
Reader-gain artifact:
```

Every article must include one reader-gain artifact: a decision table, checklist, operating model, failure-mode list, before/after workflow, field guide, or action framework. See [reader-gain-artifacts.md](references/reader-gain-artifacts.md).

## 7. Choose one spine

Choose exactly one spine:

- Career transition
- Team operating system
- Business model shift
- Technical architecture
- Trust or safety change
- Market structure
- Product workflow
- Tool-selection decision
- Work process change

Every section must support this spine. Competing concepts go to future-article ideas.

## 8. Run source-relative originality gate

Run this gate whenever the input includes a polished reference essay, or when the user compares your output to a known author.

Pass conditions:

| Gate | Pass condition |
|---|---|
| Opening | Uses a different opening scene or a materially different angle |
| Title | Avoids the reference title pattern and key phrasing |
| Structure | Section order visibly differs from the reference |
| Examples | At least 30% of examples come from underused source material |
| Thesis | Either improves the same thesis with a new decision tool, picks an adjacent thesis, or writes from a missing angle |
| Artifact | Adds a reader-gain artifact not present in the reference |
| Metaphor | Avoids copying the reference's central metaphor unless the raw source itself requires it |

If any row fails, revise the thesis, opening, or outline before drafting.

## 9. Name the mechanism

Create 10 mechanism names. Pick one that is short, memorable, and natural.

Mechanism name test:

1. Reader can understand it from surrounding prose.
2. Reader can repeat it in conversation.
3. The name clarifies the article more than plain description.
4. It organizes 3 to 6 sub-mechanisms.

If the name feels like an internal framework, use it inside the article after explanation. Use a more natural title.

## 10. Generate title candidates

Generate at least 20 titles in four groups:

1. Problem titles: reader pain, mistake, or surprising scene.
2. Mechanism titles: the hidden force in natural language.
3. Decision titles: what judgment changes.
4. Reader-gain titles: what the reader can now do or see.

Title hard rules:

- Keep internal labels out of H1 and usually H2: `旧价格表`, `新价格表`, `成本结构`, `source map`, `thesis tournament`, `quality gate`, `roadmap`, `scorecard`, `分析框架`.
- Avoid repeated patterns across drafts, especially `X 的新 Y`.
- Avoid copying a polished reference title's syntax.
- Prefer concrete subject + changed decision.

See [title-guide.md](references/title-guide.md).

## 11. Draft the outline

Use this as a starting point, then adapt for natural reading:

1. Concrete scene, failure, or decision point.
2. Reader's familiar intuition.
3. Why that intuition used to work.
4. What changed.
5. New bottleneck or scarcity.
6. Mechanism introduced in prose.
7. 3 to 6 sections, each advancing one causal step.
8. Multi-case validation.
9. Boundary and failure modes.
10. Reader-gain artifact.
11. Ending that compresses the insight into one reusable sentence.

Reader-facing headings should sound like public article headings, not internal process labels.

## 12. Pre-draft gates

Score before writing:

| Gate | Pass condition |
|---|---|
| Main thesis | One sentence, specific, decision-changing |
| Reader gain | Reader sees relevance in first 300 words |
| One spine | One dominant article path |
| Old assumption | Explicit and historically rational |
| Cost change | Drives the article under the surface |
| Originality | Clearly differs from polished references |
| Title | Natural, specific, curiosity-creating |
| Evidence | At least 12 concrete details available |
| Artifact | One useful reader-facing decision tool planned |
| Boundaries | At least 2 failure modes or edge cases |
| Publication hygiene | No internal process sections in final article |

Weak rows require outline revision before drafting.

## 13. Write the article

Writing rules:

- Start with a concrete scene, failure, or decision point.
- Move from scene to mechanism gradually.
- Each section advances one causal step.
- Every abstract claim gets a concrete example.
- Keep paragraphs short.
- Use natural Chinese syntax.
- Prefer concrete actors and verbs.
- Keep English terms when they are industry terms or source terms.
- Use tables only when they help the reader decide.
- Include exactly one major reader-gain artifact unless the article is a model or tool decision matrix.
- Cite or name sources for facts, numbers, quotes, and source-specific claims.
- End with a reusable judgment frame.

Publication hygiene rules:

- Do not include Source Map, Thesis Tournament, Old Assumptions, Cost-Structure Table, scorecards, roadmap, prompt notes, or generation notes in the public article.
- Do not expose internal headings like `旧假设`, `新价格表`, `质量评分`, `Source Notes` unless the user asked for notes.
- Use `资料来源` only when source transparency helps the reader or the user asked for citations.

Chinese style rules:

- Use direct positive claims.
- Avoid stiff framework language in public titles and headings.
- Cut explanatory repetition after the causal step is clear.
- Turn abstract nouns into actors, actions, and consequences.

## 14. Quality gate

Score the draft out of 100:

| Dimension | Points |
|---|---:|
| Thesis sharpness | 10 |
| Source transformation | 10 |
| Source-relative originality | 10 |
| Reader self-relevance | 10 |
| Reader actionability | 10 |
| Reader-gain artifact | 10 |
| Narrative smoothness | 10 |
| Concept restraint | 8 |
| Title quality | 8 |
| Evidence and boundary cases | 8 |
| Chinese naturalness | 6 |

Target: 90+. Minimum publishable score: 88.

Hard gates:

- Source-relative originality < 8: change opening, structure, or thesis mode.
- Reader self-relevance < 8: rewrite opening and reader framing.
- Reader-gain artifact < 8: add or improve the decision tool.
- Narrative smoothness < 8: reduce framework density.
- Concept restraint < 8: merge or remove secondary mechanisms.
- Title quality < 8: regenerate titles.
- Publication hygiene failure: remove internal process content before returning.

If score is below 90 or any hard gate fails, rewrite once focusing on the lowest three dimensions. If the second version remains below 88, return it with a concise concern note.

## Review mode

When reviewing an existing article, score with the 100-point gate and produce:

```text
Verdict:
Score:
Target reader:
Reader gain:
Good:
Bad:
Concrete improvements:
Title diagnosis:
Originality diagnosis:
Reader-gain artifact diagnosis:
Most important rewrite direction:
Skill/process changes needed:
```

Review the article as a reader-facing piece. Penalize visible research scaffolding, stiff titles, framework overload, copied openings, copied section order, weak reader payoff, and missing decision tools.

## Common failure modes

| Failure | Fix |
|---|---|
| Reads like a summary | Rebuild around old assumption → changed cost → new scarcity → reader decision |
| Insight is deep but dry | Add reader pain, felt stakes, and a decision payoff |
| Too close to a reference essay | Change opening, title syntax, section order, and examples; choose adjacent or missing-angle thesis |
| Internal analysis appears in final | Move maps, tournaments, scores, and notes into `analysis_pack` |
| Title feels like a framework | Generate natural problem/mechanism/decision/reader-gain titles |
| Too many concepts compete | Pick one spine and one main mechanism |
| Mechanism name feels invented | Explain it in prose or choose a plainer phrase |
| Cost table becomes the article | Convert it into narrative tension and a reader-useful artifact |
| Low evidence density | Return to source map and add concrete details |
| No edge cases | Add where the mechanism breaks, becomes risky, or needs human judgment |
| Generic AI prose | Rewrite into concrete Chinese sentences, shorter paragraphs, fewer abstract nouns |

## Reference files

- See [originality-gate.md](references/originality-gate.md) for avoiding reference-essay overlap.
- See [reader-gain-artifacts.md](references/reader-gain-artifacts.md) for decision tools and action frameworks.
- See [title-guide.md](references/title-guide.md) for title patterns and anti-patterns.
- See [publication-gates.md](references/publication-gates.md) for reader gain, one-spine, and publication hygiene.
- See [quality-rubric.md](references/quality-rubric.md) for v4 scoring.
- See [workflow-templates.md](references/workflow-templates.md) for internal tables.
