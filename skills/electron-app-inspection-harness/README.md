# electron-app-inspection-harness

Agent Skill for inspecting a specified Electron app with MCP, CDP, Playwright/Puppeteer, asar static analysis, OS automation, and optional app debug instrumentation.

The goal is to solve the inspection problem, not to produce a weaker fallback document. If high-value tools are missing, the skill installs low-cost local tooling or configures MCP before downgrading.

## Install

Codex user scope:

```bash
mkdir -p ~/.agents/skills
cp -R electron-app-inspection-harness ~/.agents/skills/
```

Codex project scope:

```bash
mkdir -p .agents/skills
cp -R electron-app-inspection-harness .agents/skills/
```

Claude Code:

```bash
mkdir -p ~/.claude/skills
cp -R electron-app-inspection-harness ~/.claude/skills/
```

## Use

```text
Use electron-app-inspection-harness on /Applications/Target.app.
Output root: ./analysis.
Mode: third-party-app.
Scope: whole app inventory plus deep dive on CanvasCard and SidebarNav.
Use MCP/CDP/Playwright/Puppeteer/asar when useful. Install local capture tooling when it improves evidence quality.
```

## Initialize manually

```bash
bash ~/.agents/skills/electron-app-inspection-harness/scripts/init-inspection.sh \
  --app "/Applications/Target.app" \
  --out-root ./analysis \
  --mode third-party-app
```

Then install local tools:

```bash
bash ~/.agents/skills/electron-app-inspection-harness/scripts/bootstrap-inspection-tooling.sh \
  ./analysis/<app-slug> \
  --profile runtime
```

Configure Codex MCP when useful:

```bash
bash ~/.agents/skills/electron-app-inspection-harness/scripts/configure-codex-mcp.sh \
  --doc-root ./analysis/<app-slug> \
  --add chrome-devtools

bash ~/.agents/skills/electron-app-inspection-harness/scripts/configure-codex-mcp.sh \
  --doc-root ./analysis/<app-slug> \
  --add playwright
```

Attach/capture:

```bash
bash ~/.agents/skills/electron-app-inspection-harness/scripts/scan-cdp.sh ./analysis/<app-slug>
bash ~/.agents/skills/electron-app-inspection-harness/scripts/launch-electron-cdp.sh ./analysis/<app-slug> --app-path "/Applications/Target.app" --port 9222
node ~/.agents/skills/electron-app-inspection-harness/scripts/capture-cdp.js --doc-root ./analysis/<app-slug> --port 9222 --label default
```

Static map:

```bash
bash ~/.agents/skills/electron-app-inspection-harness/scripts/extract-asar.sh ./analysis/<app-slug> /Applications/Target.app/Contents/Resources/app.asar
bash ~/.agents/skills/electron-app-inspection-harness/scripts/static-map.sh ./analysis/<app-slug>
```

Generate Codex handoff from collected artifacts:

```bash
node ~/.agents/skills/electron-app-inspection-harness/scripts/synthesize-handoff.js ./analysis/<app-slug>
```

Validate:

```bash
bash ~/.agents/skills/electron-app-inspection-harness/scripts/validate-pack.sh ./analysis/<app-slug>
```

## Main outputs

```text
analysis/<app-slug>/00-meta/manifest.json
analysis/<app-slug>/00-meta/capability-ledger.json
analysis/<app-slug>/05-ui-ux-report/inspection-report.md
analysis/<app-slug>/05-ui-ux-report/design-tokens.json
analysis/<app-slug>/05-ui-ux-report/component-inventory.md
analysis/<app-slug>/05-ui-ux-report/interaction-matrix.md
analysis/<app-slug>/06-codex-tasks/codex-implementation-prompt.md
analysis/<app-slug>/06-codex-tasks/task-contract.json
analysis/<app-slug>/06-codex-tasks/acceptance-checklist.md
```

## What changed from v3

- MCP is first-class, not an optional footnote.
- Codex is treated as the inspection engine, not only the consumer of the final handoff.
- Missing Playwright/CDP/Puppeteer/asar becomes a recoverable capability gap.
- Output is an inspection harness plus UI/UX report plus Codex task contract.
- Tasks are split as vertical slices, so Codex can implement and verify small visible flows.
