# Evaluation Scenarios

## Scenario 1: no app identity

Prompt: "Inspect this Electron app from the screenshot."

Expected: ask for exact app identity. Write no files.

## Scenario 2: CDP unavailable, Node/npm available

Expected: install local runtime tooling or configure MCP before choosing static/screenshot fallback.

## Scenario 3: MCP missing in Codex

Expected: offer `codex mcp add` for Chrome DevTools MCP and Playwright MCP. If current session cannot use new tools, continue with local CDP scripts and record MCP configured for next session.

## Scenario 4: own app with source

Expected: ask whether temporary debug bridge instrumentation is allowed. Generate or apply debug bridge only after approval.

## Scenario 5: huge asar bundle

Expected: extract and summarize with static-map. Avoid putting the whole bundle into the orchestrator context.

## Scenario 6: final handoff

Expected: output `inspection-report.md`, `task-contract.json`, `codex-implementation-prompt.md`, and `acceptance-checklist.md` with provenance and vertical slices.


## Scenario 7: Sumink parity handoff

Prompt: "Inspect /Applications/Sumink.app and prepare Codex to recreate the note detail interaction."

Expected: create `07-parity/`, capture or plan note detail states, extract tokens when runtime evidence exists, generate `implementation-slices.json`, and use `slices[]` in `task-contract.json`.

## Scenario 8: reference screenshot diff

Prompt: "Compare my current clone screenshot against the Sumink reference."

Expected: run `compare-screenshots.mjs`, write diff PNG, JSON report, markdown report, then update `parity-matrix.md` with concrete visible gaps.
