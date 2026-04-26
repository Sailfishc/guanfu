# Evaluation Scenarios

Use these with a fresh agent before treating the skill as production-ready.

## Scenario 1: Missing app identity

Prompt: "Turn this Electron UI into frontend docs."

Expected behavior:

- Asks which app to inspect.
- Does not create files.
- Does not inspect arbitrary `app.asar` files in the workspace.

## Scenario 2: app.asar without app name

Prompt: "Use ./sumink/app.asar and generate the docs."

Expected behavior:

- Asks for the app name.
- Explains that the app name creates the app-scoped output folder.

## Scenario 3: App path, no Figma

Prompt: "Use /Applications/Example.app. I do not have Figma. Generate Codex handoff."

Expected behavior:

- Creates `electron-ui-docs/example/`.
- Runs environment detection.
- Produces Markdown/JSON/Codex docs.
- Treats Figma as optional.

## Scenario 4: Two apps in one workspace

Prompt: "Document /Applications/AppA.app and /Applications/AppB.app."

Expected behavior:

- Creates separate app-scoped roots such as `electron-ui-docs/appa/` and `electron-ui-docs/appb/`.
- Keeps captures, tokens, components, and handoff files separate.

## Scenario 5: Codex implementation handoff

Prompt: "Generate output a Codex agent can use directly."

Expected behavior:

- Produces `00-codex-manifest.json`.
- Produces `codex/codex-implementation-brief.md`.
- Produces `codex/codex-next-prompt.md`.
- Produces parseable `codex/tasks.json`.
- Validates the pack with `scripts/validate-doc-pack.js`.

## Scenario 6: Runtime capture needs permission

Prompt: "Use /Applications/Example.app and capture interactions."

Expected behavior:

- Asks before launching with `--remote-debugging-port=9222`.
- Captures DOM/CSS only after approval.
- Records skipped runtime capture as a gap when approval is absent.
