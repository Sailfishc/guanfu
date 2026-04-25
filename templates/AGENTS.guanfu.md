# GuanFu Router

When the user request matches a GuanFu stage, use the corresponding skill before answering ad hoc:

- Repository setup, first-time harness initialization, docs contract, router setup, or code explore setup -> `gf-init`.
- Fuzzy idea, early requirement, product or engineering concept, unclear problem, "help me think" -> `gf-brainstorm`.
- Approved brainstorm/spec and request for implementation plan, slices, ADR, architecture plan -> `gf-plan`.
- Implementation of an approved active plan slice -> `gf-work`.
- Code review, diff review, test review, slice completion review -> `gf-code-review`.
- Plan review, ADR review, brainstorm review, review document review, handoff quality review -> `gf-doc-review`.
- Mistake, repeated bug, review lesson, failed command, "avoid this next time" -> `gf-compound`.
- Skill improvement, repeated workflow failure, new pressure scenario, package iteration -> `gf-evolve`.

Recommended sequence:

```text
gf-init -> gf-brainstorm -> gf-plan -> gf-work -> gf-code-review -> gf-doc-review -> gf-compound -> gf-evolve
```

Do not skip stages because the task feels simple. Small tasks are where hidden assumptions leak.

## GuanFu Taste Constraints

- Documents are memory. If future agents need context, write it down.
- Plan and review before execution. Target 80% planning/review and 20% implementation.
- Work in small slices. One active slice at a time.
- Keep `docs/guanfu/plans/*-plan.md` current. Plan status must be `ACTIVE`, `COMPLETED`, `PAUSED`, or `ABANDONED`.
- Mark exactly one `Active Slice`, or `none`.
- For behavior changes, write or update tests before implementation and verify they fail for the expected reason.
- Create ADRs for decisions that are expensive to reverse.
- Review for patterns, not just bugs. Repeated mistakes become compound notes.
- Prefer automation over memory. A test beats a reminder.
- Do not hide scope drift. Update the plan before expanding work.
- Track skill improvement opportunities in `docs/guanfu/evolution/`.
- Use `gf-evolve` when a compound note should update a GuanFu skill.

## GuanFu Document Contract

```text
docs/guanfu/
  context/
  brainstorms/
  plans/
  reviews/code/
  reviews/docs/
  adr/
  compound/
  standards/
  evolution/
```
