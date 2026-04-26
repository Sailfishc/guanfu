# Pressure Scenarios

Use these with a fresh agent to test the skill.

## 1. Strong reference essay overlap

Input: a polished yage essay plus the same raw transcript.
Expected: final article has a different opening, title pattern, section order, at least 30% underused examples, and a distinct reader artifact.
Fail: article reuses the same opening scene and thesis structure.

## 2. Stiff title pressure

Input: source material where internal analysis naturally produces old/new cost table.
Expected: title translates the cost shift into a reader-facing consequence.
Fail: title contains `旧价格表`, `新价格表`, `成本结构`, `模式`, or `框架`.

## 3. Stiff heading leak

Input: draft outline with headings like `旧成本结构`, `新稀缺`, `读者决策表`.
Expected: final article uses natural headings such as `以前，PM 的价值来自降低执行浪费`.
Fail: public article exposes internal analysis labels.

## 4. Weak reader artifact

Input: essay draft with a table whose title says “三个场景” but table has five rows.
Expected: artifact title and rows are consistent, distinct, and decision-changing.
Fail: artifact is present but sloppy or unusable.

## 5. Overbroad claim pressure

Input: article draft with claims like “代码成本趋近于零” and “PM 不再需要 PRD”.
Expected: claims are scoped to concrete contexts or rewritten as cost shifts.
Fail: final article keeps absolute claims without boundary.

## 6. Workbench leakage

Input: user asks for a publishable article.
Expected: no source map, thesis tournament, quality score, or roadmap in final response.
Fail: output shows research process before article.

## 7. Deep but dry article

Input: technical workshop transcript.
Expected: article includes one usable decision table, checklist, field guide, or operating model.
Fail: article only explains concepts.

## 8. Too many concepts

Input: multi-source pack with many possible theses.
Expected: one main spine, extra insights omitted or listed only in analysis_pack when requested.
Fail: article becomes a taxonomy with 8+ mechanisms.

## 9. Best-of-N variance

Input: two model outputs, one with better angle, one with better polish.
Expected: skill picks a champion, salvages strengths, and recommends a merged publication direction.
Fail: skill treats both as equal or rewrites from scratch without using their strengths.

## 10. Direct positive claim style

Input: draft with many `不是 A，而是 B` constructions.
Expected: final version states the positive claim directly.
Fail: contrastive negative phrasing remains throughout.
