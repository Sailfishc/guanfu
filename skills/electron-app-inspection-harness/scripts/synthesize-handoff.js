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
function write(rel, content) {
  const file = path.join(root, rel);
  ensure(path.dirname(rel));
  fs.writeFileSync(file, content);
}
ensure('05-ui-ux-report');
ensure('06-codex-tasks');
ensure('07-parity/references');
ensure('07-parity/state-captures');
ensure('07-parity/measurements');
ensure('07-parity/diffs');
const now = new Date().toISOString();
const ctx = readJson('00-meta/app-context.json', {});
const app = (ctx && ctx.app) || { name: 'Unknown App', slug: 'unknown-app' };
const ledger = readJson('00-meta/capability-ledger.json', { capabilities: [] });
const cdpScan = readJson('01-runtime/cdp-scan.json', null);
const runtimeFiles = listFiles('01-runtime', f => /\.(json|png|md)$/i.test(f));
const staticFiles = listFiles('02-static-asar', f => /\.(json|md|txt)$/i.test(f));
const mcpFiles = listFiles('03-mcp', f => /\.(json|md|txt)$/i.test(f));
const osFiles = listFiles('04-os-automation', f => /\.(json|png|md|txt)$/i.test(f));
const parityFiles = listFiles('07-parity', f => /\.(json|png|md)$/i.test(f));
const screenshots = runtimeFiles.filter(f => /01-runtime\/screenshots\/.*\.png$/i.test(f));
const stateCaptures = parityFiles.filter(f => /07-parity\/state-captures\/.*\.md$/i.test(f));
const diffs = parityFiles.filter(f => /07-parity\/diffs\/.*-report\.json$/i.test(f));
const evidence = [];
if (runtimeFiles.length) evidence.push({ type: 'runtime-cdp', paths: runtimeFiles, confidence: 'high-when-capture-successful' });
if (mcpFiles.length) evidence.push({ type: 'mcp', paths: mcpFiles, confidence: 'high-when-tool-output-present' });
if (staticFiles.length) evidence.push({ type: 'static-asar', paths: staticFiles, confidence: 'medium' });
if (osFiles.length) evidence.push({ type: 'os-automation', paths: osFiles, confidence: 'medium' });
if (parityFiles.length) evidence.push({ type: 'parity', paths: parityFiles, confidence: 'medium-high when backed by runtime capture or diff' });
const evidenceList = evidence.length
  ? evidence.map(e => `- ${e.type}: ${e.paths.slice(0, 8).map(p => '`' + p + '`').join(', ')} (${e.confidence})`).join('\n')
  : '- No evidence artifacts found yet.';
writeIfMissing('05-ui-ux-report/design-tokens.json', JSON.stringify({
  schemaVersion: '4.1.0',
  app: app.slug,
  colors: [], typography: [], spacing: [], radii: [], shadows: [],
  provenanceRules: ['source token > CSS variable > computed CSS > DOM rect > screenshot sample > inference'],
  note: 'Populate from runtime DOM/CSS, static CSS, or screenshot sampling. Keep screenshot values approximate. Run extract-design-tokens-from-cdp.mjs after runtime capture.'
}, null, 2));
writeIfMissing('05-ui-ux-report/component-inventory.md', `# Component Inventory\n\nApp: ${app.name}\n\nFor each component, include purpose, anatomy, props/data model, states, interactions, accessibility, tokens, evidence, and unknowns.\n\n## Priority components for Sumink-like parity\n\n- window shell\n- sidebar navigation\n- topbar\n- note detail content column\n- title block\n- paragraph block\n- ordered list block\n- code block\n- backlinks\n- canvas/card surface when in scope\n`);
writeIfMissing('05-ui-ux-report/interaction-matrix.md', `# Interaction Matrix\n\nApp: ${app.name}\n\n| Flow / Component | Default | Hover | Focus | Active | Selected | Drag | Context menu | Loading | Error | Evidence |\n|---|---|---|---|---|---|---|---|---|---|---|\n| note detail shell | ${screenshots.length ? 'observed' : 'not observed'} | not observed | not observed | not observed | not observed | not observed | not observed | not observed | not observed | ${screenshots[0] || 'pending'} |\n| sidebar item | not observed | not observed | not observed | not observed | not observed | n/a | not observed | n/a | n/a | pending |\n| editor block | not observed | n/a | not observed | n/a | not observed | not observed | n/a | n/a | error state not observed | pending |\n| backlinks | not observed | not observed | not observed | not observed | n/a | n/a | n/a | n/a | n/a | pending |\n`);
writeIfMissing('05-ui-ux-report/inspection-report.md', `# Inspection Report: ${app.name}\n\nGenerated: ${now}\n\n## Evidence summary\n\n${evidenceList}\n\n## Capability ledger\n\nSee \`00-meta/capability-ledger.json\`.\n\n## Runtime status\n\n${cdpScan ? 'CDP scan artifact exists at `01-runtime/cdp-scan.json`.' : 'CDP scan not present yet.'}\n\n## UI/UX findings\n\nAdd findings only when backed by evidence. Mark visual-only claims as approximate.\n\n## Parity findings\n\nUse \`07-parity/parity-matrix.md\` for state gaps and implementation slices.\n\n## Unknowns\n\nKeep hover, focus, active, drag, context menu, loading, error, IME composition, selection, scroll, and resize states as \`not observed\` until captured.\n`);
writeIfMissing('07-parity/parity-matrix.md', `# Parity Matrix\n\nApp: ${app.name}\nGenerated: ${now}\n\n| Atom / Flow | Observation status | Evidence | Gaps to close | Slice |\n|---|---|---|---|---|\n| note detail shell | ${screenshots.length ? 'observed' : 'not observed'} | ${screenshots.join(', ') || 'pending'} | shell/sidebar/topbar/content/backlinks | slice-01-note-detail-static-shell |\n| sidebar states | ${stateCaptures.some(x => /sidebar/i.test(x)) ? 'partially observed' : 'not observed'} | ${stateCaptures.filter(x => /sidebar/i.test(x)).join(', ') || 'pending'} | default/hover/active/pressed | slice-02-sidebar-states |\n| editor block visuals | ${stateCaptures.some(x => /editor|title|paragraph|code|list/i.test(x)) ? 'partially observed' : 'not observed'} | ${stateCaptures.filter(x => /editor|title|paragraph|code|list/i.test(x)).join(', ') || 'pending'} | title/paragraph/list/code | slice-03-editor-block-visuals |\n| editor input stability | not observed | pending | typing/selection/IME/paste/undo | slice-04-editor-input-stability |\n| scroll resize backlinks | ${diffs.length ? 'diff evidence exists' : 'not observed'} | ${diffs.join(', ') || 'pending'} | resize/scroll/backlinks hover | slice-05-scroll-resize-backlinks |\n`);
const slices = [
  {
    id: 'slice-01-note-detail-static-shell',
    title: 'Note detail static shell',
    goal: 'Render the inspected note detail screen as a static, reviewable route before adding interactions.',
    status: screenshots.length ? 'ready' : 'needs-capture',
    atoms: ['window shell', 'sidebar', 'topbar', 'content column', 'typography', 'ordered list', 'backlinks'],
    inputs: ['05-ui-ux-report/inspection-report.md', '05-ui-ux-report/design-tokens.json', '05-ui-ux-report/component-inventory.md', '07-parity/parity-matrix.md'].concat(screenshots.slice(0, 3)),
    outputs: ['centralized tokens', 'note detail example route/story', 'before/after screenshot', 'gap table'],
    acceptance: ['page is visible locally', 'tokens are centralized', 'layout/typography/backlinks gaps are listed as concrete measurements', 'proprietary assets are replaced or documented'],
    evidenceRequired: ['runtime-cdp screenshot or screenshot reference', 'computed CSS token evidence when available'],
    verification: ['visual screenshot capture', 'manual gap table or compare-screenshots output']
  },
  {
    id: 'slice-02-sidebar-states',
    title: 'Sidebar item states',
    goal: 'Implement default, hover, active, and pressed states for sidebar navigation atoms.',
    status: stateCaptures.some(x => /sidebar/i.test(x)) ? 'ready' : 'needs-capture',
    atoms: ['sidebar item', 'section header', 'icon/text alignment', 'active background', 'hover feedback'],
    inputs: ['05-ui-ux-report/interaction-matrix.md', '07-parity/parity-matrix.md'].concat(stateCaptures.filter(x => /sidebar/i.test(x))),
    outputs: ['state stories/examples', 'keyboard focus treatment', 'updated parity matrix'],
    acceptance: ['default/hover/active states exist for observed items', 'alignment and spacing match measured tokens', 'unobserved states stay as capture TODOs'],
    evidenceRequired: ['hover/active state capture or explicit TODO']
  },
  {
    id: 'slice-03-editor-block-visuals',
    title: 'Editor block visual parity',
    goal: 'Implement title, paragraph, ordered-list, and code-block visual states from inspected evidence.',
    status: stateCaptures.some(x => /editor|title|paragraph|code|list/i.test(x)) ? 'ready' : 'needs-capture',
    atoms: ['title block', 'paragraph block', 'ordered list', 'code block', 'block spacing'],
    inputs: ['05-ui-ux-report/design-tokens.json', '05-ui-ux-report/interaction-matrix.md', '07-parity/parity-matrix.md'].concat(stateCaptures.filter(x => /editor|title|paragraph|code|list/i.test(x))),
    outputs: ['editor block components or styles', 'block state examples', 'visual gap table'],
    acceptance: ['font size/weight/line-height are tokenized', 'block spacing is measured or marked approximate', 'code/list rendering is visually stable'],
    evidenceRequired: ['computed CSS for text blocks or screenshot reference']
  },
  {
    id: 'slice-04-editor-input-stability',
    title: 'Editor input and selection stability',
    goal: 'Add typing, selection, IME composition, paste, and undo/redo behavior checks for the editor.',
    status: 'needs-capture',
    atoms: ['cursor', 'selection', 'composition', 'paste', 'undo redo', 'keyboard navigation'],
    inputs: ['references/editor-interaction-contract.md', '05-ui-ux-report/interaction-matrix.md'],
    outputs: ['Playwright tests or manual harness', 'IME/composition notes', 'updated acceptance checklist'],
    acceptance: ['typing keeps cursor stable', 'composition input remains stable', 'undo/redo restores text and cursor state where implemented'],
    evidenceRequired: ['interaction capture or local implementation test']
  },
  {
    id: 'slice-05-scroll-resize-backlinks',
    title: 'Scroll, resize, and backlinks parity',
    goal: 'Stabilize content width, scroll anchoring, resize behavior, and backlinks placement/hover.',
    status: 'needs-capture',
    atoms: ['content max width', 'scroll anchoring', 'resize breakpoints', 'backlinks placement', 'backlinks hover'],
    inputs: ['07-parity/parity-matrix.md'].concat(diffs),
    outputs: ['resize examples/tests', 'backlinks state examples', 'visual diff report'],
    acceptance: ['content column remains stable across captured sizes', 'backlinks position and hover match evidence', 'visual diff report is updated'],
    evidenceRequired: ['resize captures or screenshot references']
  }
];
write('07-parity/implementation-slices.json', JSON.stringify({ schemaVersion: '4.1.0', app: app.slug, profile: 'sumink-note-editor', generatedAt: now, slices }, null, 2));
write('07-parity/codex-parity-prompt.md', `# Codex Parity Implementation Prompt\n\nUse the Electron inspection pack at: ${root}\n\nGoal: implement Sumink-like UI and interaction parity from evidence-backed documentation.\n\nRead order:\n1. 00-meta/manifest.json\n2. 00-meta/app-context.json\n3. 05-ui-ux-report/inspection-report.md\n4. 05-ui-ux-report/design-tokens.json\n5. 05-ui-ux-report/component-inventory.md\n6. 05-ui-ux-report/interaction-matrix.md\n7. 07-parity/parity-matrix.md\n8. 07-parity/implementation-slices.json\n9. 06-codex-tasks/acceptance-checklist.md\n\nLoop for each slice:\nInspect current code → identify smallest visible gap → edit minimally → run checks → capture screenshot → compare if reference exists → update parity matrix and acceptance checklist → report remaining gaps.\n`);
write('06-codex-tasks/acceptance-checklist.md', `# Acceptance Checklist\n\n## Evidence\n\n- [ ] Target app identity is fixed in \`00-meta/app-context.json\`.\n- [ ] Capability recovery attempts are recorded.\n- [ ] Runtime or static evidence exists for each implemented claim.\n- [ ] Every component has states and unknowns.\n- [ ] Tokens include provenance.\n- [ ] Codex tasks use \`slices[]\`.\n- [ ] Visual checks use captured screenshots or explicit approximations.\n\n## Parity\n\n- [ ] \`07-parity/parity-matrix.md\` exists.\n- [ ] \`07-parity/implementation-slices.json\` has at least one slice.\n- [ ] Static default screen has screenshot evidence or a clear capture TODO.\n- [ ] Hover/focus/active states are captured or listed as TODOs.\n- [ ] Editor input/selection/IME states are captured or listed as TODOs.\n- [ ] Screenshot diff exists when reference/current images are available.\n`);
const taskContract = {
  schemaVersion: '4.1.0',
  app: app.slug,
  generatedAt: now,
  goal: 'Implement the UI and interaction parity described by the Electron inspection pack.',
  readOrder: [
    '00-meta/manifest.json',
    '00-meta/app-context.json',
    '00-meta/capability-ledger.json',
    '05-ui-ux-report/inspection-report.md',
    '05-ui-ux-report/design-tokens.json',
    '05-ui-ux-report/component-inventory.md',
    '05-ui-ux-report/interaction-matrix.md',
    '07-parity/parity-matrix.md',
    '07-parity/implementation-slices.json',
    '06-codex-tasks/acceptance-checklist.md'
  ],
  sourceArtifacts: evidence.flatMap(e => e.paths),
  slices,
  followUpCaptureTasks: [
    'capture note detail default screen if screenshots are missing',
    'capture sidebar default/hover/active/pressed states',
    'capture editor title/paragraph/list/code block focus and input states',
    'capture selection, IME composition, paste, undo/redo states',
    'capture scroll, resize, and backlinks hover states'
  ],
  unknowns: []
};
write('06-codex-tasks/task-contract.json', JSON.stringify(taskContract, null, 2));
write('06-codex-tasks/codex-implementation-prompt.md', `Use the Electron inspection pack at: ${root}\n\nGoal: implement or refine frontend UI from evidence-backed documentation and parity slices.\n\nRead order:\n1. 00-meta/manifest.json\n2. 00-meta/app-context.json\n3. 00-meta/capability-ledger.json\n4. 05-ui-ux-report/inspection-report.md\n5. 05-ui-ux-report/design-tokens.json\n6. 05-ui-ux-report/component-inventory.md\n7. 05-ui-ux-report/interaction-matrix.md\n8. 07-parity/parity-matrix.md\n9. 07-parity/implementation-slices.json\n10. 06-codex-tasks/task-contract.json\n11. 06-codex-tasks/acceptance-checklist.md\n\nRules:\n- Prefer runtime CDP, MCP, computed CSS, and accessibility artifacts over screenshots.\n- Treat screenshot-only measurements as approximate.\n- Keep unobserved states as explicit TODOs.\n- Work in one visible slice from task-contract.json.\n- Use TDD or visual regression checks where the target project supports them.\n- Do not copy proprietary assets into production code. Document replacements.\n\nStart with the first slice whose status is \`ready\`; if none is ready, complete the next follow-up capture task.\n`);
const verification = `# Verification Report\n\nGenerated: ${now}\n\n## Evidence routes\n\n${evidenceList}\n\n## Capability recovery\n\nCapabilities recorded: ${(ledger.capabilities || []).length}\n\n## Gaps\n\n- Runtime CDP present: ${runtimeFiles.length ? 'yes' : 'no'}\n- MCP evidence present: ${mcpFiles.length ? 'yes' : 'no'}\n- Static asar evidence present: ${staticFiles.length ? 'yes' : 'no'}\n- Parity evidence present: ${parityFiles.length ? 'yes' : 'no'}\n- Screenshots present: ${screenshots.length ? 'yes' : 'no'}\n\n## Codex readiness\n\n- inspection-report.md: yes\n- design-tokens.json: yes\n- component-inventory.md: yes\n- interaction-matrix.md: yes\n- parity-matrix.md: yes\n- implementation-slices.json: yes\n- codex-implementation-prompt.md: yes\n- task-contract.json: yes\n- acceptance-checklist.md: yes\n`;
write('05-ui-ux-report/verification-report.md', verification);
console.log(JSON.stringify({ ok: true, root, files: ['05-ui-ux-report/inspection-report.md', '07-parity/parity-matrix.md', '07-parity/implementation-slices.json', '06-codex-tasks/task-contract.json'] }, null, 2));
