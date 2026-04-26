#!/usr/bin/env node
const fs = require('fs');
const path = require('path');
const root = process.argv[2];
if (!root) {
  console.error('Usage: synthesize-handoff.js <analysis-root>');
  process.exit(64);
}
function ensure(rel) { fs.mkdirSync(path.join(root, rel), { recursive: true }); }
function readJson(rel, fallback = null) {
  try { return JSON.parse(fs.readFileSync(path.join(root, rel), 'utf8')); } catch { return fallback; }
}
function exists(rel) { return fs.existsSync(path.join(root, rel)); }
function listFiles(rel, pred = () => true) {
  const dir = path.join(root, rel);
  if (!fs.existsSync(dir)) return [];
  const out = [];
  function walk(d, base) {
    for (const item of fs.readdirSync(d)) {
      const abs = path.join(d, item);
      const r = path.join(base, item);
      const st = fs.statSync(abs);
      if (st.isDirectory()) walk(abs, r);
      else if (pred(r)) out.push(path.join(rel, r).replace(/\\/g, '/'));
    }
  }
  walk(dir, '');
  return out;
}
function writeIfMissing(rel, content) {
  const file = path.join(root, rel);
  ensure(path.dirname(rel));
  if (!fs.existsSync(file)) fs.writeFileSync(file, content);
}
ensure('05-ui-ux-report');
ensure('06-codex-tasks');
const now = new Date().toISOString();
const ctx = readJson('00-meta/app-context.json', {});
const app = (ctx && ctx.app) || { name: 'Unknown App', slug: 'unknown-app' };
const ledger = readJson('00-meta/capability-ledger.json', { capabilities: [] });
const cdpScan = readJson('01-runtime/cdp-scan.json', null);
const runtimeFiles = listFiles('01-runtime', f => /\.(json|png|md)$/i.test(f));
const staticFiles = listFiles('02-static-asar', f => /\.(json|md|txt)$/i.test(f));
const mcpFiles = listFiles('03-mcp', f => /\.(json|md|txt)$/i.test(f));
const osFiles = listFiles('04-os-automation', f => /\.(json|png|md|txt)$/i.test(f));
const evidence = [];
if (runtimeFiles.length) evidence.push({ type: 'runtime-cdp', paths: runtimeFiles, confidence: 'high-when-capture-successful' });
if (mcpFiles.length) evidence.push({ type: 'mcp', paths: mcpFiles, confidence: 'high-when-tool-output-present' });
if (staticFiles.length) evidence.push({ type: 'static-asar', paths: staticFiles, confidence: 'medium' });
if (osFiles.length) evidence.push({ type: 'os-automation', paths: osFiles, confidence: 'medium' });
const evidenceList = evidence.length
  ? evidence.map(e => `- ${e.type}: ${e.paths.slice(0, 6).map(p => '`' + p + '`').join(', ')} (${e.confidence})`).join('\n')
  : '- No evidence artifacts found yet.';
writeIfMissing('05-ui-ux-report/design-tokens.json', JSON.stringify({
  schemaVersion: '4.0.0',
  app: app.slug,
  colors: [], typography: [], spacing: [], radii: [], shadows: [],
  provenanceRules: ['source token > CSS variable > computed CSS > DOM rect > screenshot sample > inference'],
  note: 'Populate from runtime DOM/CSS, static CSS, or screenshot sampling. Keep screenshot values approximate.'
}, null, 2));
writeIfMissing('05-ui-ux-report/component-inventory.md', `# Component Inventory\n\nApp: ${app.name}\n\nFor each component, include purpose, anatomy, props/data model, states, interactions, accessibility, tokens, evidence, and unknowns.\n`);
writeIfMissing('05-ui-ux-report/interaction-matrix.md', `# Interaction Matrix\n\nApp: ${app.name}\n\n| Flow / Component | Default | Hover | Focus | Active | Selected | Drag | Context menu | Loading | Error | Evidence |\n|---|---|---|---|---|---|---|---|---|---|---|\n| TBD | not observed | not observed | not observed | not observed | not observed | not observed | not observed | not observed | not observed | pending |\n`);
writeIfMissing('05-ui-ux-report/inspection-report.md', `# Inspection Report: ${app.name}\n\nGenerated: ${now}\n\n## Evidence summary\n\n${evidenceList}\n\n## Capability ledger\n\nSee \`00-meta/capability-ledger.json\`.\n\n## Runtime status\n\n${cdpScan ? 'CDP scan artifact exists at `01-runtime/cdp-scan.json`.' : 'CDP scan not present yet.'}\n\n## UI/UX findings\n\nAdd findings only when backed by evidence. Mark visual-only claims as approximate.\n\n## Unknowns\n\nKeep hover, focus, active, drag, context menu, loading, error, and accessibility states as \`not observed\` until captured.\n`);
writeIfMissing('06-codex-tasks/acceptance-checklist.md', `# Acceptance Checklist\n\n- [ ] Target app identity is fixed in \`00-meta/app-context.json\`.\n- [ ] Capability recovery attempts are recorded.\n- [ ] Runtime or static evidence exists for each implemented claim.\n- [ ] Every component has states and unknowns.\n- [ ] Tokens include provenance.\n- [ ] Codex tasks are vertical slices.\n- [ ] Visual checks use captured screenshots or explicit approximations.\n`);
const taskContract = {
  schemaVersion: '4.0.0',
  app: app.slug,
  generatedAt: now,
  sourceArtifacts: evidence.flatMap(e => e.paths),
  verticalSlices: [
    {
      id: 'slice-1-visible-component',
      title: 'Implement tokens plus one visible priority component',
      inputs: ['05-ui-ux-report/inspection-report.md', '05-ui-ux-report/design-tokens.json', '05-ui-ux-report/component-inventory.md'],
      outputs: ['src/tokens.css', 'src/components/<PriorityComponent>.tsx', 'stories or examples for default state'],
      acceptance: ['component matches captured default state', 'tokens use documented provenance', 'unknown interaction states remain explicit'],
      evidenceRequired: ['runtime-cdp or screenshot plus static-asar']
    },
    {
      id: 'slice-2-interaction-and-accessibility',
      title: 'Add captured interaction states and accessibility semantics',
      inputs: ['05-ui-ux-report/interaction-matrix.md', '01-runtime/accessibility/ or 03-mcp/playwright-summary.md'],
      outputs: ['state stories/examples', 'keyboard/focus handling', 'accessibility notes'],
      acceptance: ['default, hover, focus, selected are implemented when observed', 'not observed states remain TODOs with capture task']
    },
    {
      id: 'slice-3-layout-flow',
      title: 'Compose the component into the target screen or flow',
      inputs: ['05-ui-ux-report/inspection-report.md', '01-runtime/screenshots/'],
      outputs: ['screen composition', 'visual check artifacts'],
      acceptance: ['layout uses documented spacing and hierarchy', 'visual check compares against captured app screen']
    }
  ],
  followUpCaptureTasks: [
    'capture missing hover/focus/active/selected/drag/context-menu states',
    'capture accessibility tree for priority screen',
    'capture console/network/performance artifacts for target flow'
  ]
};
fs.writeFileSync(path.join(root, '06-codex-tasks/task-contract.json'), JSON.stringify(taskContract, null, 2));
const prompt = `Use the Electron inspection pack at: ${root}\n\nGoal: implement or refine frontend UI from evidence-backed documentation.\n\nRead order:\n1. 00-meta/manifest.json\n2. 00-meta/app-context.json\n3. 00-meta/capability-ledger.json\n4. 05-ui-ux-report/inspection-report.md\n5. 05-ui-ux-report/design-tokens.json\n6. 05-ui-ux-report/component-inventory.md\n7. 05-ui-ux-report/interaction-matrix.md\n8. 06-codex-tasks/task-contract.json\n9. 06-codex-tasks/acceptance-checklist.md\n\nRules:\n- Prefer runtime CDP, MCP, computed CSS, and accessibility artifacts over screenshots.\n- Treat screenshot-only measurements as approximate.\n- Keep unobserved states as explicit TODOs.\n- Work in vertical slices from task-contract.json.\n- Use TDD or visual regression checks where the target project supports them.\n- Do not copy proprietary assets into production code. Document replacements.\n\nStart with the first vertical slice whose inputs are available.\n`;
fs.writeFileSync(path.join(root, '06-codex-tasks/codex-implementation-prompt.md'), prompt);
const verification = `# Verification Report\n\nGenerated: ${now}\n\n## Evidence routes\n\n${evidenceList}\n\n## Capability recovery\n\nCapabilities recorded: ${(ledger.capabilities || []).length}\n\n## Gaps\n\n- Runtime CDP present: ${runtimeFiles.length ? 'yes' : 'no'}\n- MCP evidence present: ${mcpFiles.length ? 'yes' : 'no'}\n- Static asar evidence present: ${staticFiles.length ? 'yes' : 'no'}\n\n## Codex readiness\n\n- inspection-report.md: yes\n- design-tokens.json: yes\n- component-inventory.md: yes\n- interaction-matrix.md: yes\n- codex-implementation-prompt.md: yes\n- task-contract.json: yes\n- acceptance-checklist.md: yes\n`;
fs.writeFileSync(path.join(root, '05-ui-ux-report/verification-report.md'), verification);
console.log(JSON.stringify({ ok: true, root, files: ['05-ui-ux-report/inspection-report.md', '06-codex-tasks/codex-implementation-prompt.md', '06-codex-tasks/task-contract.json'] }, null, 2));
