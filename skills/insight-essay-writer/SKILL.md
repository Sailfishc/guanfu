---
name: insight-essay-writer
description: Use when turning articles, transcripts, documents, events, releases, meeting notes, customer materials, research clippings, polished reference essays, or multiple model drafts into a publishable high-insight Chinese longform article, or when reviewing such drafts.
---

# Insight Essay Writer

## Core principle

Write a publishable Chinese essay with a real argument. Keep the research workbench internal. The article must give readers a portable insight, felt payoff, and one usable decision tool.

Insight comes first. Reader gain turns insight into value. Publication polish makes the article feel finished. Source voice must stay honest: use the true relationship to the material and never invent first-hand access. For technical, current, podcast, interview, report, release, or public-source essays, source traceability is part of publication quality.

## Default deliverable

For drafting requests, return the public article only:

1. Natural title.
2. Publishable Chinese article body.
3. Compact `资料来源` when sources are public, current, technical, interview/podcast/report-based, or when factual traceability matters. Include source title, platform/publication, publish date if known, and link when available. Never invent unavailable links.

Keep source maps, thesis tournaments, internal cost tables, scorecards, roadmaps, prompt notes, and generation notes out of the public article. If the user requests process transparency, return two outputs: `article.md` and `analysis_pack.md`.

For review requests, return verdict, score, diagnosis, and concrete revision plan. Rewrite only when asked.

For multiple model drafts from the same materials, use Best-of-N mode: pick one champion draft, preserve its spine, salvage the strongest modules from the others, and recommend a merged publication version. Do not average drafts.

## Priority order

1. Deep insight. The essay must change how the reader understands the material.
2. Source transformation. The essay must add a new angle, mechanism, or decision frame.
3. Reader gain. The reader should know what they learned and what decision changes.
4. Publication polish. The article should read like a finished article, not a research memo.
5. Natural title and headings. Internal analysis labels stay internal.
6. Source-relative originality. A polished reference is a comparison target.
7. Source traceability. Important facts, numbers, roles, timelines, and quotes remain findable.
8. Source voice integrity. The article preserves whether material came from an interview, transcript, podcast, report, draft, clipping, or the author’s own work.

## Internal workflow

Track this checklist internally:

```text
Insight Essay Progress
- [ ] Read all materials
- [ ] Classify sources: raw material / polished reference / target style / model draft
- [ ] Build source map with traceability pointers
- [ ] Identify old assumptions
- [ ] Build internal cost-change table
- [ ] Run thesis tournament
- [ ] Choose reader and reader gain
- [ ] Choose one spine
- [ ] Run source-relative originality gate
- [ ] Run primary source title distance gate
- [ ] Run series anti-rut gate when prior published articles or drafts are available
- [ ] Choose mechanism name
- [ ] Generate title candidates
- [ ] Select reader-gain artifact
- [ ] Run artifact extraction gate
- [ ] Draft outline with natural headings
- [ ] Run pre-draft gates
- [ ] Write publishable article
- [ ] Run source traceability gate
- [ ] Run source voice integrity gate
- [ ] Re-run primary source title distance gate
- [ ] Run direct positive title and prose passes
- [ ] Run claim calibration gate
- [ ] Upgrade reader artifact if needed
- [ ] Run quality gate
- [ ] Rewrite once if score < 90 or a hard gate fails
```

## 1. Classify the input sources

Before choosing a thesis, classify each source:

| Type | Definition | How to use |
|---|---|---|
| Raw material | Transcript, interview, release note, meeting note, event list, customer notes | Mine for facts, scenes, tensions, details |
| Polished reference | A finished essay already interpreting the same material | Treat as competitor or style target, avoid its opening, title pattern, structure, main metaphor |
| Target style | Essay supplied mainly to show desired style | Learn rhythm and quality bar, avoid duplicating specific claims or scenes |
| Model draft | Another generated article from the same sources | Compare as a candidate, salvage strong angles or reader tools |

If one source is a polished reference essay about the same raw material, run the originality gate before drafting. See [originality-gate.md](references/originality-gate.md).

## 2. Build the internal source map

Use this internally:

| Field | Capture |
|---|---|
| Key fact | Specific event, number, quote, tool, actor, workflow, or failure |
| Source | File, link, speaker, timestamp, or document title |
| Source date | Publish date, recording date, event date, or unknown |
| Public link | URL when available; never invent if unavailable |
| Timestamp or locator | Timestamp, page, line range, section, or note ID for key claims when available |
| Source relationship | First-hand interview, podcast transcript, report, draft, clipping, secondary note, or private material |
| Surface topic | What the material appears to discuss |
| Old assumption | Hidden premise that made the old workflow sensible |
| Changed cost | Time, money, execution, verification, trust, coordination, compliance, attention |
| New scarcity | What becomes more valuable after the cost changes |
| Reader relevance | Why the target reader should care |
| Evidence | Concrete supporting detail |
| Traceability status | linked / named only / private / needs verification / unavailable |
| Underused detail | Strong material not emphasized by polished references |
| Boundary | Where the claim breaks or becomes risky |

Density target: at least 12 concrete details for one long source, or at least 5 details per source for multi-source inputs. When a polished reference exists, at least 30% of public examples should come from underused details.

For every named number, role, timeline, quote, or source-specific claim, keep an internal source pointer. If a public link is available, include it in `资料来源`. If no link is available, name the source and type rather than inventing a URL.

## 3. Identify old assumptions

Find 3 to 7 old assumptions, then pick one dominant assumption.

```text
Old assumption:
Why it used to be rational:
What changed in the material:
New scarcity:
Reader decision that should change:
```

The old workflow should feel historically rational. Strong essays reprice old behavior instead of dismissing it.

## 4. Build the internal cost-change table

Use this internally:

| Old cost condition | New cost condition | New bottleneck | Who feels it | Decision change |
|---|---|---|---|---|

This is an analysis tool. In the public article, translate it into natural prose or a reader-facing table. Keep these internal labels out of public titles and headings: `旧价格表`, `新价格表`, `旧成本结构`, `新稀缺`, `成本结构`, `cost table`, `quality gate`, `roadmap`, `scorecard`, `source map`, `thesis tournament`, `分析框架`.

## 5. Run the thesis tournament

Generate 10 candidate theses. Score each 1-5 on:

- Explanatory power
- Surprise
- Transferability
- Actionability
- Evidence strength
- Reader gain
- Shareability
- Originality against polished references and primary source titles
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
Source traceability risks:
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

Every article must include one reader-gain artifact: a decision table, checklist, operating model, failure-mode list, before/after workflow, field guide, diagnostic question set, or demand-routing table. See [reader-gain-artifacts.md](references/reader-gain-artifacts.md).

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

Run this gate whenever the input includes a polished reference essay, when the user compares output to a known author, or when the primary source title already frames the thesis.

Pass conditions:

| Gate | Pass condition |
|---|---|
| Opening | Uses a different opening scene or materially different reader pain |
| Title | Avoids the reference or primary-source title pattern and key phrasing |
| Structure | Section order visibly differs from the reference |
| Examples | At least 30% of public examples come from underused source material |
| Thesis | Improves the same thesis with a new decision tool, chooses an adjacent thesis, or writes from a missing angle |
| Artifact | Adds a reader-gain artifact not present in the reference |
| Ending | Lands on a different reader decision or operational consequence |

The new article must differ from a polished reference on at least two of: opening scene, primary reader, main mechanism, reader artifact, ending decision, section order, emphasized source details. If fewer than two differ, switch to adjacent-thesis or missing-angle mode. If the article title preserves the primary source title skeleton, reject it even when the body is original. See [reference-distance.md](references/reference-distance.md).

## 9. Run primary source title distance gate

A primary source can already have a strong title. Do not translate or lightly paraphrase it.

Internal check:

```text
Primary source title:
Source title skeleton:
Candidate title:
Candidate skeleton:
Same named actor + same novelty phrase? yes/no
Same key verb or metaphor? yes/no
Article-owned mechanism named? yes/no
Reader decision named? yes/no
Pass / reject:
```

Reject titles that keep the same named actor plus `新写法`, `新方式`, `new way`, `new method`, `未来`, `方法`, or the source's main metaphor unless the article adds a clearly different mechanism and reader promise.

Preferred replacements name:

- Changed bottleneck.
- Reader decision.
- Article-owned mechanism.
- Failure mode.
- Operational consequence.

See [primary-source-title-distance.md](references/primary-source-title-distance.md).

## 10. Run series anti-rut gate when applicable

Run when the user supplies recent essays, prior drafts, or site context. If no prior articles are available, skip silently.

Compare against the last 5 related pieces:

```text
Title skeleton:
Primary reader:
Main mechanism:
New scarcity:
Source details emphasized:
Artifact type:
Ending decision:
```

Reject if the draft repeats the same title skeleton, resolves again to the same scarcity without a new mechanism, or uses the same artifact type and ending decision as the immediately previous article. Pass only if at least two change: primary reader, mechanism, source detail mix, artifact type, ending decision, or boundary case. See [series-anti-rut.md](references/series-anti-rut.md).

## 11. Name the mechanism

Create 10 mechanism names. Pick one that is short, memorable, and natural.

Mechanism name test:

1. Reader can understand it from surrounding prose.
2. Reader can repeat it in conversation.
3. The name clarifies the article more than plain description.
4. It organizes 3 to 6 sub-mechanisms.

If the name feels like an internal framework, explain it in prose after the reader already feels the problem. Use a more natural title.

## 12. Generate title candidates

Generate at least 20 titles in four groups:

1. Problem titles: reader pain, mistake, or surprising scene.
2. Mechanism titles: the hidden force in natural language.
3. Decision titles: what judgment changes.
4. Reader-gain titles: what the reader can now do or see.

Title hard rules:

- Keep internal labels out of H1 and usually H2: `旧价格表`, `新价格表`, `旧成本结构`, `新稀缺`, `成本结构`, `source map`, `thesis tournament`, `quality gate`, `roadmap`, `scorecard`, `分析框架`, `读者决策表`.
- Avoid repeated title skeletons across drafts, especially `X 的新 Y` and `当 X，Y 该 Z` when recently used.
- Avoid copying a polished reference title's syntax.
- Avoid translating or lightly paraphrasing a primary source title.
- Prefer concrete subject + changed decision.
- Run the Direct Positive Title Gate: reject `不是 A，而是 B`, `A 没有消失，只是 B`, `不再是 A，是 B`, `真正的 X 不是 Y`.

See [title-guide.md](references/title-guide.md) and [direct-positive-title.md](references/direct-positive-title.md).

## 13. Select and extract the reader artifact

Select one major reader-facing artifact before drafting. Then run this internal check:

```text
Artifact title:
Artifact type:
Primary reader:
Decision it changes this week:
Can it be copied into a meeting doc? yes/no
Rows/checks are distinct? yes/no
Setup paragraph before artifact? yes/no
Interpretation after artifact? yes/no
```

If the changed decision is vague or the artifact cannot be copied into a meeting doc, upgrade it before drafting. Add one of: owner, default path, exit condition, escalation trigger, review cadence, or what to avoid. See [artifact-extraction-gate.md](references/artifact-extraction-gate.md) and [reader-artifact-qa.md](references/reader-artifact-qa.md).

## 14. Draft the outline

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

Reader-facing headings should sound like public article headings, not internal process labels. Run the Section Heading Naturalization Gate before drafting.

## 15. Pre-draft gates

Score before writing:

| Gate | Pass condition |
|---|---|
| Main thesis | One sentence, specific, decision-changing |
| Reader gain | Reader sees relevance in first 300 words |
| One spine | One dominant article path |
| Old assumption | Explicit and historically rational |
| Cost change | Drives the article under the surface |
| Originality | Clearly differs from polished references and primary source titles |
| Series distance | If recent essays are available, changes at least two of reader, mechanism, artifact, or ending decision |
| Source traceability | Key numbers, roles, timelines, quotes, and source-specific claims have source pointers |
| Source voice | Source relationship is known and safe to state |
| Title | Natural, specific, curiosity-creating, directly positive |
| Headings | Natural, causal, reader-facing |
| Evidence | At least 12 concrete details available |
| Artifact | One useful reader-facing decision tool planned and extractable into a meeting doc |
| Boundaries | At least 2 failure modes or edge cases |
| Publication hygiene | No internal process sections in final article |

Weak rows require outline revision before drafting.

## 16. Write the article

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
- Introduce the artifact before showing it and interpret it after showing it.
- Cite, link, or name sources for facts, numbers, quotes, and source-specific claims. If public source links are available, include them in a compact `资料来源` section unless the user explicitly requests no public source notes.
- If the user explicitly asks for no public citations, still keep traceability internal and remove unsupported precision.
- End with a reusable judgment frame.

Publication hygiene rules:

- Do not include Source Map, Thesis Tournament, Old Assumptions, Cost-Structure Table, scorecards, roadmap, prompt notes, or generation notes in the public article.
- Do not expose internal headings like `旧假设`, `新价格表`, `旧成本结构`, `新稀缺`, `质量评分`, `读者决策表`, `Source Notes` unless the user asked for notes.
- Use `资料来源` when sources are public, current, technical, interview/podcast/report-based, or when source transparency helps the reader. Keep it compact.

Chinese style rules:

- Use direct positive claims.
- Avoid contrastive negative constructions in titles, headings, and key claims.
- Avoid stiff framework language in public titles and headings.
- Cut explanatory repetition after the causal step is clear.
- Turn abstract nouns into actors, actions, and consequences.

## 17. Publication polish passes

Run these passes before final output:

### Source Traceability Gate

Run this for technical, current, podcast, interview, report, release, named-person, named-company, or public-source essays.

Hard requirements:

1. Public `资料来源` includes source title, platform/publication, publish date if known, and link when available.
2. Named numbers, timelines, roles, quotes, and source-specific claims have internal source pointers.
3. Timestamped sources keep timestamps internally for load-bearing claims when available.
4. If public links are unavailable, say source title/type rather than inventing a URL.
5. If citations are deliberately omitted, the article must still avoid unverifiable precision.

Failure means not publishable for technical/current essays. See [source-traceability.md](references/source-traceability.md).

### Section Heading Naturalization Gate

Review every section heading. A heading passes only if it sounds like a public article heading, advances curiosity or causality, and avoids internal analysis labels.

Convert internal headings into reader-facing headings:

| Internal heading | Reader-facing heading |
|---|---|
| 旧成本结构 | 以前，PM 的价值来自降低执行浪费 |
| 新稀缺 | 代码变快以后，判断开始变贵 |
| 边界案例 | 快起来以后，团队会欠下什么债 |
| 读者决策表 | AI 产品需求该怎么处理 |

### Reader Artifact QA and Upgrade Gate

The reader-gain artifact must pass:

1. Title matches rows or checks.
2. Rows are mutually distinct.
3. Each row changes a real decision.
4. Language is for the primary reader.
5. The article explains how to use it.
6. It can be copied into a meeting doc.

If a table only has `type / signal / action`, consider adding one of: owner, exit condition, review cadence, default path, escalation trigger, or what to avoid. A strong artifact can guide a real meeting tomorrow.

### Primary Source Title Distance Gate

Recheck the final H1 against all source titles and recent published titles. Reject title candidates that preserve the primary source's title skeleton, especially named-person + `new way/new method/new writing` patterns. The title should name the article's own mechanism, reader decision, or changed bottleneck. See [primary-source-title-distance.md](references/primary-source-title-distance.md).

### Series Anti-Rut Gate

Run when the user supplies recent essays, prior drafts, or site context. Compare against the last 5 related pieces. Reject if the new article repeats the same title skeleton, resolves again to the same scarcity without a new mechanism, or uses the same artifact type and ending decision as the immediately previous article. Pass only if at least two change: primary reader, mechanism, source detail, artifact type, ending decision. See [series-anti-rut.md](references/series-anti-rut.md).

### Source Voice Integrity Gate

Scan for first-person source claims. Unless the author personally conducted the interview or experiment, remove phrases like `当我问`, `我采访了`, `他告诉我`, `我们聊到`, `在我的访谈里`.

Safe patterns:

```text
Cat Wu 在访谈里说...
Lenny 问到...
材料显示...
这段访谈给出的信号是...
```

See [source-voice-integrity.md](references/source-voice-integrity.md).

### Claim Calibration Gate

Scan for overbroad phrases: `趋近于零`, `消失`, `完全替代`, `彻底改变`, `唯一`, `必然`, `所有团队`, `所有人`, `已经结束`, `不再需要`, `取代`.

For each, add a scope condition, replace with cost-shift language, add a boundary case, or anchor it to a concrete source example.

Preferred patterns:

```text
在 [specific context] 里，[old cost] 下降后，[new bottleneck] 更显性。
对这类任务来说，[old action] 已经便宜到可以先试。
当 [workflow] 进入高频循环，[new bottleneck] 成为主要瓶颈。
```

See [claim-calibration.md](references/claim-calibration.md).

### Direct Positive Claim Pass

Rewrite contrastive negative constructions into direct positive claims.

Convert:

```text
不是 A，而是 B
A 不是重点，B 才是重点
不是因为 X，而是因为 Y
A 没有消失，只是 B
```

Into:

```text
B 是重点。
Y 解释了这件事。
真正变化发生在 B。
A 的价值迁移到 B。
```

See [direct-positive-claims.md](references/direct-positive-claims.md).

## 18. Quality gate

Score the draft out of 100:

| Dimension | Points |
|---|---:|
| Thesis sharpness | 10 |
| Source transformation | 10 |
| Source-relative originality | 9 |
| Reader self-relevance | 9 |
| Reader actionability | 9 |
| Reader-gain artifact quality | 10 |
| Narrative smoothness | 8 |
| Title and heading quality | 9 |
| Evidence and boundary cases | 8 |
| Chinese naturalness and direct positive style | 4 |
| Claim calibration | 4 |
| Source traceability | 5 |
| Source voice integrity | 5 |

Target: 90+. Minimum publishable score: 88.

Hard gates:

- Source traceability failure on technical/current essays: add source title, platform/date, link if available, and remove unsupported precision.
- Source voice integrity failure: rewrite source claims before returning.
- Primary source title distance failure: regenerate titles around mechanism, reader decision, or changed bottleneck.
- Series anti-rut failure when prior essays are available: change at least two of reader, mechanism, artifact, source details, or ending decision.
- Source-relative originality < 8: change opening, structure, thesis mode, or example mix.
- Reader self-relevance < 8: rewrite opening and reader framing.
- Reader-gain artifact quality < 8: improve the decision tool.
- Narrative smoothness < 8: reduce framework density.
- Title and heading quality < 8: regenerate titles and headings.
- Claim calibration < 8: scope or soften overbroad claims.
- Publication hygiene failure: remove internal process content before returning.

If score is below 90 or any hard gate fails, rewrite once focusing on the lowest three dimensions. If the second version remains below 88, return it with a concise concern note.

## Best-of-N mode

When the user provides multiple drafts from different models using the same skill:

1. Score each draft on insight, reader gain, source transformation, originality, narrative smoothness, publishability, source traceability, source voice, artifact quality, and claim calibration.
2. Pick one champion draft.
3. Preserve the champion's spine.
4. Extract salvageable modules from other drafts: title, opening, core metaphor, decision table, boundary section, underused source detail, ending sentence.
5. Recommend a merged publication version: champion plus selected upgrades.
6. Identify skill defects exposed by model variance.

Do not average drafts. Do not merge every good paragraph. Model variance is useful for discovering angles; publication quality comes from one strong spine.

See [best-of-n.md](references/best-of-n.md).

## Review mode

When reviewing an existing article, score with the 100-point gate and produce:

```text
Verdict:
Score:
Target reader:
Reader gain:
好的:
不好的:
改进:
Title diagnosis:
Heading diagnosis:
Originality diagnosis:
Primary source title distance diagnosis:
Series anti-rut diagnosis when prior essays are available:
Source traceability diagnosis:
Source voice diagnosis:
Reader-gain artifact diagnosis:
Claim calibration diagnosis:
Most important rewrite direction:
Skill/process changes needed:
```

Review the article as a reader-facing piece. Penalize visible research scaffolding, stiff titles or headings, framework overload, copied openings, copied section order, weak reader payoff, missing or broken decision tools, invented source access, vague source notes, cloned source titles, and overbroad claims.

## Common failure modes

| Failure | Fix |
|---|---|
| Reads like a summary | Rebuild around old assumption → changed cost → new scarcity → reader decision |
| Insight is deep but dry | Add reader pain, felt stakes, and a decision payoff |
| Too close to a reference essay | Change opening, title syntax, section order, examples; choose adjacent or missing-angle thesis |
| Title clones primary source title | Regenerate around mechanism, reader decision, or changed bottleneck |
| Series repeats the same Agent argument | Change reader, mechanism, artifact type, or ending decision |
| Internal analysis appears in final | Move maps, tournaments, scores, and notes into `analysis_pack` |
| Title uses negative contrast | Rewrite as direct positive claim |
| Title feels like a framework | Generate natural problem/mechanism/decision/reader-gain titles |
| Section headings feel like templates | Rewrite them as public article headings |
| Reader artifact is present but weak | Add exit conditions, owners, defaults, or escalation triggers |
| Reader artifact cannot be copied | Add owner, default path, exit condition, review cadence, or escalation trigger |
| Source note is too vague | Add source title, platform/publication, date if known, and link when available |
| Source voice invents access | Replace first-person interview language with the true source relationship |
| Too many concepts compete | Pick one spine and one main mechanism |
| Mechanism name feels invented | Explain it in prose or choose a plainer phrase |
| Cost table becomes the article | Convert it into narrative tension and a reader-useful artifact |
| Overbroad claims weaken trust | Scope the claim to source context and cost shift |
| Low evidence density | Return to source map and add concrete details |
| No edge cases | Add where the mechanism breaks, becomes risky, or needs human judgment |
| Generic AI prose | Rewrite into concrete Chinese sentences, shorter paragraphs, fewer abstract nouns |

## Reference files

- See [originality-gate.md](references/originality-gate.md) for avoiding reference-essay overlap.
- See [reader-gain-artifacts.md](references/reader-gain-artifacts.md) for decision tools and action frameworks.
- See [reader-artifact-qa.md](references/reader-artifact-qa.md) for artifact quality checks.
- See [reader-artifact-upgrade.md](references/reader-artifact-upgrade.md) for turning simple tables into meeting-ready tools.
- See [artifact-extraction-gate.md](references/artifact-extraction-gate.md) for meeting-ready reader tools.
- See [title-guide.md](references/title-guide.md) for title patterns and anti-patterns.
- See [direct-positive-title.md](references/direct-positive-title.md) for title-level positive claims.
- See [primary-source-title-distance.md](references/primary-source-title-distance.md) for avoiding translated source titles.
- See [section-heading-guide.md](references/section-heading-guide.md) for natural public headings.
- See [publication-gates.md](references/publication-gates.md) for reader gain, one-spine, and publication polish.
- See [claim-calibration.md](references/claim-calibration.md) for scoping bold claims.
- See [source-traceability.md](references/source-traceability.md) for source notes and claim pointers.
- See [source-voice-integrity.md](references/source-voice-integrity.md) for preserving source relationships.
- See [reference-distance.md](references/reference-distance.md) for polished-reference distance checks.
- See [series-anti-rut.md](references/series-anti-rut.md) for consecutive article differentiation.
- See [direct-positive-claims.md](references/direct-positive-claims.md) for the direct positive prose pass.
- See [best-of-n.md](references/best-of-n.md) for comparing multiple model drafts.
- See [quality-rubric.md](references/quality-rubric.md) for v7 scoring.
- See [workflow-templates.md](references/workflow-templates.md) for internal tables.
