# Quality Rubric

Score each category from 0 to 2.

| Category | 0 | 1 | 2 |
|---|---|---|---|
| Purpose | Vague | Clear but broad | Clear, reusable, outcome-based |
| Routing | Missing or generic | Some triggers | Concrete triggers and route-away cases |
| Name | Tool-first or vague | Understandable | Purpose-first, action-oriented |
| Description | Workflow summary | Mixed routing/process | Routing-only metadata |
| Body | Bloated or sparse | Usable | Lean workflow with references |
| Progressive disclosure | None | Some references | One-level references and scripts |
| Evals | None | Static only | Baseline/candidate and dynamic-ready |
| Packaging | Hidden only | Visible only | Visible plus agent mirrors |
| Security | Unreviewed scripts | Basic checks | Local-only defaults and documented risk |
| Report | Claims only | Partial evidence | Commands, results, limitations |

Release gate:

```text
score >= 16/20
package validation passes
all critical eval cases pass or are explicitly pending
```
