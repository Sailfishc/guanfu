# Reader Artifact QA v7

## Goal

The article must give the primary reader a usable object, not just a clever idea.

Good artifacts:

- Decision table
- Role-change checklist
- Operating model
- Failure-mode list
- Before/after workflow
- Field guide
- Requirement triage table
- Task-routing matrix

## Artifact QA gate

Before final output, check:

1. **Title matches content.** The heading promises exactly what the artifact does.
2. **Rows are distinct.** No two rows say the same thing with different words.
3. **Each row changes a decision.** A reader can use it in a real meeting or task.
4. **Primary-reader language.** The artifact speaks to the chosen reader, not the author.
5. **Introduced before, interpreted after.** The article explains why the artifact exists and what it means.
6. **Concise enough to reuse.** Prefer 4-7 rows unless the domain demands more.
7. **Copyable into a meeting doc.** A reader can paste it into a review, planning, or decision document without rewriting it.

## Common fixes

| Problem | Fix |
|---|---|
| Table title says 3 scenarios but has 5 rows | Rename the title or reduce rows |
| Rows overlap | Merge similar rows and sharpen distinctions |
| Rows describe facts only | Add a decision or action for each row |
| Artifact appears suddenly | Add a short setup paragraph before it |
| Artifact ends the section cold | Add a paragraph interpreting the pattern |

## Strong artifact pattern

| Demand type | Best next move | Why |
|---|---|---|
| User pain is clear, model boundary is uncertain | Research preview | Real use reveals whether the model is ready |
| Behavior quality is hard to describe | Write evals | Tests make success repeatable |
| Security, billing, permissions, enterprise promise | PRD and review | Mistake cost is high |
| Temporary model weakness | Removable scaffold | New models may make it obsolete |


## Extraction check

```text
Artifact title:
Primary reader:
Decision it changes this week:
Can copy into meeting doc: yes/no
Rows/checks distinct: yes/no
Setup before artifact: yes/no
Interpretation after artifact: yes/no
```

If `Can copy into meeting doc` is no, add one of: owner, default path, exit condition, escalation trigger, review cadence, or what to avoid.
