---
name: refactor
preamble-tier: 3
version: 1.0.0
description: |
  Use when the user explicitly invokes /refactor or asks to restructure existing code according to best practices without changing behavior. Do not use for feature implementation, bug diagnosis, shipping, QA sweeps, or ordinary review.
allowed-tools:
  - Bash
  - Read
  - Grep
  - Glob
  - Write
  - Edit
  - Agent
  - AskUserQuestion
  - WebSearch
triggers:
  - /refactor
  - refactor this
  - clean up this code
  - restructure this code
  - apply best practices
---

# Refactor: Best-Practice Code Restructuring

This is a special-scenario skill. It is not part of the normal product development flow.

Use it when the user wants existing code made simpler, safer, clearer, or easier to maintain without changing external behavior.

## Boundary

Do not invoke this skill during normal `/brainstorm`, `/plan`, `/implement`, `/qa`, `/review`, or `/ship` unless the user explicitly asks for `/refactor` or approves a refactor as the next step.

This skill preserves behavior. If behavior is unknown or broken, run `/debug` first.

## Core rules

1. Preserve externally visible behavior unless the user explicitly approves a behavior change.
2. Establish a safety net before broad edits. Use existing tests or add characterization tests.
3. Refactor in small reversible slices. Each slice should be explainable in one sentence.
4. Follow local conventions before generic advice. Existing project style wins unless it is causing real harm.
5. Improve boundaries, names, dependencies, and tests. Do not cosmetically churn code.
6. Never use refactor as a hidden feature request. New behavior requires a separate plan.
7. If new tests or bug fixes are needed, use `test-driven-development` for those changes.

## Workflow

Copy this checklist and update it as you work:

```text
Refactor Progress:
- [ ] 0. Scope contract
- [ ] 1. Baseline behavior and test safety
- [ ] 2. Code smell inventory
- [ ] 3. Refactor strategy options
- [ ] 4. Slice-by-slice refactor
- [ ] 5. Best-practice verification
- [ ] 6. Final report
```

### 0. Scope contract

Before editing, define:

- Target files, modules, or feature area
- Behavior that must not change
- Allowed behavior changes, if any
- Success criteria, such as lower duplication, smaller files, clearer API, fewer branches, faster test setup
- Verification commands

Run:

```bash
git status --short
git branch --show-current
```

If the scope includes more than one subsystem, ask the user to choose the first subsystem or approve a multi-phase refactor.

### 1. Baseline behavior and test safety

Find the nearest tests:

```bash
find . -maxdepth 4 -type f | grep -Ei '(test|spec)' | head -50
```

Run the narrowest relevant tests before changing code.

If there are no useful tests, add characterization tests before refactoring. A characterization test records current behavior so the refactor cannot accidentally change it.

Minimum safety net:

- Public API behavior covered
- Main happy path covered
- At least one important edge case covered
- Error behavior covered if the code handles errors

Do not refactor broadly with no safety net. If tests are impossible, ask for approval and keep changes tiny.

### 2. Code smell inventory

Inspect the target area and classify issues:

| Smell | What to look for | Preferred fix |
|---|---|---|
| Mixed responsibilities | One file handles UI, data, validation, persistence | Extract focused modules |
| Long functions | Multiple phases, many branches, hidden state | Split by intent and name each step |
| Duplication | Same logic copied with small variations | Extract shared helper or normalize inputs |
| Primitive obsession | Repeated loose strings, dicts, numbers | Introduce typed object or named constants |
| Tight coupling | Low-level details leak across modules | Introduce boundary or dependency injection |
| Poor names | Names describe mechanics, not purpose | Rename around domain intent |
| Shotgun changes | One concept spread across many files | Consolidate ownership |
| Hidden side effects | Function reads/writes unexpected state | Make inputs and outputs explicit |
| Over-abstraction | Generic layer used once | Inline or simplify |
| Dead code | Unused branches, flags, helpers | Delete only when evidence proves unused |

Record the inventory before choosing a strategy.

### 3. Refactor strategy options

Present 2 or 3 approaches before broad edits:

```markdown
APPROACH A: Minimal cleanup
Summary: <smallest useful improvement>
Risk: Low/Medium/High
Files: <list>
Pros: ...
Cons: ...

APPROACH B: Boundary refactor
Summary: <better module/API boundary>
Risk: Low/Medium/High
Files: <list>
Pros: ...
Cons: ...

APPROACH C: Deeper architecture cleanup
Summary: <larger but cleaner direction>
Risk: Low/Medium/High
Files: <list>
Pros: ...
Cons: ...

RECOMMENDATION: Choose <A/B/C> because <reason tied to maintainability and user impact>.
```

Ask before proceeding when:

- Public API, database schema, route names, file layout, or package boundaries change.
- More than 5 files will be edited.
- The refactor deletes code that might still be used.
- The refactor changes performance characteristics or async ordering.

### 4. Slice-by-slice refactor

Use this order when possible:

1. Add or improve tests.
2. Rename for clarity.
3. Extract pure helpers.
4. Move helpers to better files.
5. Simplify control flow.
6. Collapse duplication.
7. Decouple dependencies.
8. Delete proven dead code.
9. Update docs only if public usage changed.

After each slice:

```bash
<narrow test command>
```

If a slice fails tests, revert or fix that slice before continuing. Do not stack uncertain changes.

### 5. Best-practice verification

Review the final code against this checklist:

```text
Best-Practice Check:
- [ ] Behavior preserved or approved behavior changes documented
- [ ] Public API remains stable, or call sites updated
- [ ] Names reveal domain intent
- [ ] Each module has one clear responsibility
- [ ] Dependencies point in the right direction
- [ ] Duplication reduced without premature abstraction
- [ ] Error handling remains explicit
- [ ] Async, lifecycle, and state ordering preserved
- [ ] Performance did not obviously regress
- [ ] Dead code removal has evidence
- [ ] Tests cover the preserved behavior
- [ ] Final verification command passed
```

For UI code, also check:

```text
UI Refactor Check:
- [ ] Loading, empty, error, and success states preserved
- [ ] Accessibility attributes preserved or improved
- [ ] Keyboard and focus behavior unchanged
- [ ] Layout does not regress on small screens
```

### 6. Final report

End with one of these statuses:

- `DONE` if refactor completed and verification passed.
- `DONE_WITH_CONCERNS` if refactor completed but a risk remains.
- `PARTIAL` if only part of the approved scope was completed.
- `BLOCKED` if safety net, ambiguity, or missing context prevents safe progress.

Report template:

```markdown
STATUS: DONE | DONE_WITH_CONCERNS | PARTIAL | BLOCKED

SCOPE:
<files/modules refactored>

BEHAVIOR CONTRACT:
<what was preserved>

CHANGES MADE:
- <slice 1>
- <slice 2>

BEST-PRACTICE IMPROVEMENTS:
- <specific improvement and why it matters>

VERIFICATION:
- <command>: <result>

USER IMPACT:
<why this makes the product safer, faster to change, or less likely to break>

REMAINING RISKS:
<any uncertainty or follow-up>
```

## Stop conditions

Stop and ask when:

- The requested refactor is really a feature change.
- Existing behavior is unclear and cannot be characterized.
- No relevant tests exist and the refactor is broad.
- The code is actively failing for unknown reasons.
- The change touches auth, billing, data deletion, migrations, or security-sensitive paths.
- Three slices in a row require backtracking.

## Common mistakes

| Mistake | Better move |
|---|---|
| Rewriting from scratch | Preserve behavior and refactor in slices |
| Renaming everything | Rename only where it clarifies ownership or intent |
| Abstracting too early | Remove duplication after understanding variation |
| Refactoring without tests | Add characterization tests or ask before tiny manual-safe edits |
| Mixing feature work with cleanup | Split behavior change into a separate plan |
| Deleting code by intuition | Prove unused status with search, tests, or runtime evidence |
