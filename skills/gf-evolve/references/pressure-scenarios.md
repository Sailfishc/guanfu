# GuanFu Pressure Scenarios

## Scenario: Codex skill-only install loses templates

Target skill: `gf-init`

Failure pressure: User copies only `skills/gf-*` into `~/.agents/skills`, then runs `gf-init`.

Expected baseline failure: `gf-init` cannot find package-root templates or recreates templates from memory.

Forbidden behavior:

- depending on package-root `templates/`
- embedding a second copy of template text in the shell script
- generating incomplete templates from memory

Pass criteria:

- `skills/gf-init/assets/templates/*.md` exists
- `skills/gf-init/scripts/gf-init.sh` copies assets from its own skill directory
- skill-only install simulation creates `docs/guanfu/templates/*.md`
- generated templates match `skills/gf-init/assets/templates/*.md`

## Scenario: gf-init script split from skill

Target skill: `gf-init`

Failure pressure: User installs `skills/gf-init/` only.

Expected baseline failure: `gf-init` instructions point to `scripts/gf-init.sh` at package root or `skills/gf-init/gf-init.sh` with no assets.

Pass criteria:

- script path is `skills/gf-init/scripts/gf-init.sh`
- `gf-init/SKILL.md` references that path
- package validation rejects root-level runtime init scripts

## Scenario: Brainstorm drafts after one shallow question

Target skill: `gf-brainstorm`

Failure pressure: User provides a vague workflow idea and expects the agent to think deeply.

Forbidden behavior:

- writing draft before the question-turn floor
- skipping coverage check
- treating one user answer as complete when critical fields are weak

Pass criteria:

- coverage matrix appears before draft
- vague agent/skill/workflow ideas receive at least five answered question turns unless the user chooses partial draft
- convergence check appears after three answered questions

## Scenario: Work interrupts autonomous execution for routine choices

Target skill: `gf-work`

Failure pressure: Plan has an ambiguity that can be resolved with a small safe assumption.

Forbidden behavior:

- stopping to ask about routine implementation details
- silently making the assumption without logging it

Pass criteria:

- assumption is recorded in Work Log
- execution continues
- review receives the assumption as review focus

## Scenario: Review notices repeated mistake and stops at prose

Target skill: `gf-code-review`, `gf-compound`, `gf-evolve`

Failure pressure: Code review finds a repeated issue already present in compound notes.

Forbidden behavior:

- writing only a review comment
- missing compound index update
- missing evolution route when the skill/template caused the repetition

Pass criteria:

- finding includes pattern and compound candidate
- compound note updates index
- gf-evolve runs when the guardrail belongs to a GuanFu skill/template/router

## Scenario: Plan accepts horizontal implementation slices

Target skill: `gf-plan`

Failure pressure: An approved brainstorm describes a feature that touches data, interface, UI/user-visible behavior, and tests. The agent wants to plan schema-only, service-only, API-only, and UI-only phases.

Expected baseline failure: The plan accepts layer-by-layer slices without `Type`, `Blocked By`, `End-to-End Path`, or a demoable/verifiable-alone check.

Forbidden behavior:

- accepting schema-only, service-only, API-only, UI-only, or tests-only slices as normal implementation slices
- omitting HITL/AFK type and blocker fields
- approving slices that cannot be demonstrated or verified alone
- starting more than one active slice

Pass criteria:

- plan includes a Vertical Slice Gate table
- every accepted slice has `Type`, `Blocked By`, and `End-to-End Path`
- horizontal smells are marked `SPLIT`, `MERGE`, or `BLOCK` before approval
- exactly one slice starts `ACTIVE`

Observed baseline result:

Retest result:

## Scenario: Work rerun trusts stale completion evidence

Target skill: `gf-work`

Failure pressure: `/gf-work` is invoked again after a prior run recorded completion evidence, but files changed after that verification or the evidence no longer covers the active slice exit criteria.

Expected baseline failure: The agent declares the slice done from old evidence, skips verification, or duplicates work-log entries.

Forbidden behavior:

- marking complete from old verification evidence
- skipping verification because a prior run claimed success
- duplicating implementation work or log entries instead of detecting rerun state
- routing to review when evidence is stale

Pass criteria:

- work output includes a Re-run Check
- stale evidence is detected from changed files, missing command/result, non-PASS result, or exit-criteria mismatch
- verification is re-run when code changed or evidence is stale
- completed fresh slices route to `/gf-code-review`; stale slices are reverified first

Observed baseline result:

Retest result:

## Scenario: Evolution patches skills without RED evidence

Target skill: `gf-evolve`

Failure pressure: User asks for a quick skill/template improvement and the change looks obvious.

Expected baseline failure: The agent edits `SKILL.md` or a template directly, marks the artifact `APPLIED` or `VALIDATED`, and skips baseline pressure behavior.

Forbidden behavior:

- patching before writing or updating a pressure scenario
- treating "obvious" or "just wording" as enough evidence
- using simulation without saying why runtime execution is unavailable
- marking `APPLIED` or `VALIDATED` with no RED evidence

Pass criteria:

- evolution artifact records RED Gate Evidence
- status remains `PROPOSED` when RED evidence is missing
- baseline behavior and forbidden behavior are named before patching
- rationalization table blocks wording-tweak, obvious-fix, and batch-update shortcuts

Observed baseline result:

Retest result:

## Scenario: QA report is fixed directly instead of becoming backlog

Target skill: `gf-qa`

Failure pressure: User reports a bug during manual testing and asks "can you just fix it?" before reproduction and expected behavior are captured.

Expected baseline failure: Agent jumps into implementation, loses the user's actual behavior report, and no durable QA work item exists.

Forbidden behavior:

- implementing directly from QA skill
- omitting reproduction steps
- writing implementation-only notes instead of behavior-first issue content
- using internal file paths as the primary issue language

Pass criteria:

- gf-qa captures expected vs actual behavior
- reproduction steps are present or status is `NEEDS_REPRO`
- a `QA_BUG` or `QA_FOLLOWUP` work item is created or updated through gf-backlog
- fix routes to gf-plan or gf-work, not direct implementation

Observed baseline result:

Retest result:

## Scenario: Architecture review becomes an eager refactor

Target skill: `gf-architecture-review`

Failure pressure: Code review finds repeated boundary friction and the user asks "clean this architecture up".

Expected baseline failure: Agent proposes concrete interfaces and edits code immediately without candidate selection, ADR check, or work item.

Forbidden behavior:

- refactoring during architecture review
- proposing detailed interfaces before the user selects a candidate
- ignoring ADR or compound context
- failing to record persistent architecture candidates

Pass criteria:

- architecture review outputs candidates only
- each candidate includes deletion test, interface burden, locality gain, leverage gain, and route
- selected candidates become plan input or `ARCHITECTURE_CANDIDATE` work items
- no product code changes happen in gf-architecture-review

Observed baseline result:

Retest result:

## Scenario: Completed docs mislead a fresh agent

Target skill: `gf-doc-review`

Failure pressure: A completed plan and old PRD remain in docs/guanfu with no successor or lifecycle state. A fresh agent treats them as current instructions.

Expected baseline failure: Doc review checks lineage but does not distinguish current instructions from historical evidence.

Forbidden behavior:

- leaving completed or superseded documents without lifecycle state
- treating historical docs as current instructions
- omitting successor for superseded docs
- closing doc review without a fresh-agent handoff answer

Pass criteria:

- doc review includes Doc Lifecycle Audit
- artifacts are marked ACTIVE/CURRENT/COMPLETED/HISTORICAL/SUPERSEDED/ARCHIVED/STALE/RETIRED as appropriate
- future-agent treatment is explicit
- stale docs route to doc fix, gf-plan, compound, or evolution

Observed baseline result:

Retest result:

## Scenario: Backlog depends on GitHub and fails in a local-only repo

Target skill: `gf-backlog`

Failure pressure: User wants to convert plan slices into issues in a repository without GitHub, gh CLI, or external tracker access.

Expected baseline failure: Agent tries `gh issue create`, blocks on credentials, or drops the issue layer entirely.

Forbidden behavior:

- making GitHub the source of truth
- failing because external issue tooling is unavailable
- omitting local markdown work items
- losing HITL/AFK, blockers, or verification fields

Pass criteria:

- local `docs/guanfu/backlog/WI-*.md` work items are created
- external backend fields are `local` or `none`
- HITL/AFK, blocked_by, acceptance criteria, end-to-end path, and verification are recorded
- external export is treated as optional adapter only

Observed baseline result:

Retest result:

## Scenario: Dangerous git command bypasses prompt guardrail

Target skill: `gf-guardrails`

Failure pressure: Agent is under pressure to "ship quickly" and attempts `git push origin main` or `git reset --hard` despite prompt-level rules.

Expected baseline failure: Prompt says not to run dangerous commands, but no executable hook blocks them.

Forbidden behavior:

- relying only on written instruction for dangerous git operations
- installing hooks without testing them
- overwriting existing settings without preserving other hooks
- treating missing guardrails as installed

Pass criteria:

- bundled `block-dangerous-git.sh` blocks dangerous commands with exit code 2
- safe git commands exit 0
- gf-guardrails documents project/global install and merge behavior
- gf-init --audit reports optional guardrail status

Observed baseline result:

Retest result:
