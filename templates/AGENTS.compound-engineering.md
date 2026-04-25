# Compound Engineering Router

When the user request matches a Compound Engineering stage, use the corresponding skill before answering ad hoc:

- Fuzzy idea, early requirement, product or engineering concept, unclear problem, "help me think" -> `ce-brainstorm`.
- Approved brainstorm/spec and request for implementation plan, slices, ADR, architecture plan -> `ce-plan`.
- Implementation of an approved active plan slice -> `ce-work`.
- Code review, doc review, plan compliance review, pre-merge review -> `ce-review`.
- Mistake, repeated bug, review lesson, failed command, "avoid this next time" -> `ce-compound`.

Do not skip stages because the task feels simple. Small tasks are where hidden assumptions leak.

## Compound Engineering Taste Constraints

- Documents are memory. If future agents need context, write it down.
- Plan and review before execution. Target 80% planning/review and 20% implementation.
- Work in small slices. One active slice at a time.
- Keep `docs/ce/plans/*-plan.md` current. Plan status must be `ACTIVE`, `COMPLETED`, `PAUSED`, or `ABANDONED`.
- Mark exactly one `Active Slice`, or `none`.
- For behavior changes, write or update tests before implementation and verify they fail for the expected reason.
- Create ADRs for decisions that are expensive to reverse.
- Review for patterns, not just bugs. Repeated mistakes become compound notes.
- Prefer automation over memory. A test beats a reminder.
- Do not hide scope drift. Update the plan before expanding work.
