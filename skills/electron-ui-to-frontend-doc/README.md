# electron-ui-to-frontend-doc

Reusable Agent Skill for turning a specified local macOS Electron app into an app-scoped, Codex-ready frontend implementation documentation pack.

## Primary output

The Skill writes to an app-named folder:

```text
electron-ui-doc/<app-slug>/
```

Core files:

```text
electron-ui-doc/<app-slug>/
  .app-context.json                  # explicit app identity and output root
  manifest.json                      # machine-readable doc pack map
  00-environment-report.md           # local tools, app path, evidence routes
  01-route-decision.md               # selected route A/B/C/D/E, confidence, fallback
  02-app-map.md                      # app.asar/source/static map, framework, assets
  03-screen-inventory.md             # screens, regions, states, evidence, confidence
  04-user-flows.md                   # observed flows, actions, feedback, gaps
  05-design-tokens.json              # colors, typography, spacing, radii, provenance
  06-assets-inventory.md             # fonts, icons, SVG/images, provenance and license notes
  components/
    <component-name>.md              # human-readable component spec
    <component-name>.spec.json       # machine-readable component contract
  captures/
    screenshots/
    dom/
    accessibility/
  handoff/
    frontend-implementation.md       # canonical frontend handoff
    codex-implementation-prompt.md   # pasteable Codex prompt
    task-contract.json               # machine-readable implementation tasks
    acceptance-checklist.md          # verification checklist
    verification-report.md           # evidence coverage and gaps
```

## Install

Codex:

```bash
mkdir -p ~/.agents/skills
cp -R electron-ui-to-frontend-doc ~/.agents/skills/
```

Project-scoped Codex install:

```bash
mkdir -p .agents/skills
cp -R electron-ui-to-frontend-doc .agents/skills/
```

Claude Code:

```bash
mkdir -p ~/.claude/skills
cp -R electron-ui-to-frontend-doc ~/.claude/skills/
```

## Use

Run environment detection first:

```bash
bash ~/.agents/skills/electron-ui-to-frontend-doc/scripts/check-electron-ui-env.sh \
  --app "/Applications/Target.app" \
  --out-root ./electron-ui-doc
```

Archive-only mode:

```bash
bash ~/.agents/skills/electron-ui-to-frontend-doc/scripts/check-electron-ui-env.sh \
  --app-name "Target" \
  --asar ./path/to/app.asar \
  --out-root ./electron-ui-doc
```

Then invoke the Skill in Codex:

```text
Use electron-ui-to-frontend-doc on /Applications/Target.app.
Output root: ./electron-ui-doc.
Scope: whole app inventory plus deep dive on CanvasCard and SidebarNavItem.
Target output: frontend documentation pack + Codex handoff.
Target stack: React + TypeScript + Tailwind.
```

## Handoff to Codex

After generation, paste or pass this file to Codex:

```text
electron-ui-doc/<app-slug>/handoff/codex-implementation-prompt.md
```

Codex should read `manifest.json`, `handoff/frontend-implementation.md`, `components/*.md`, `components/*.spec.json`, `05-design-tokens.json`, and `handoff/task-contract.json` before implementation.
