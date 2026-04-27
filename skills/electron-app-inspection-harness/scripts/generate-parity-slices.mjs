#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';

const root = process.argv[2] || process.argv[process.argv.indexOf('--doc-root') + 1];
const profile = (() => { const i = process.argv.indexOf('--profile'); return i >= 0 ? process.argv[i + 1] : 'sumink-note-editor'; })();
if (!root || root === 'undefined') {
  console.error('Usage: generate-parity-slices.mjs <doc-root> [--profile sumink-note-editor]');
  process.exit(64);
}
function ensureDir(p) { fs.mkdirSync(p, { recursive: true }); }
function readJson(rel, fallback = null) { try { return JSON.parse(fs.readFileSync(path.join(root, rel), 'utf8')); } catch { return fallback; } }
function list(rel, pred = () => true) {
  const dir = path.join(root, rel); if (!fs.existsSync(dir)) return [];
  return fs.readdirSync(dir).filter(pred).map((x) => path.join(rel, x).replace(/\\/g, '/'));
}
function write(rel, data) { ensureDir(path.dirname(path.join(root, rel))); fs.writeFileSync(path.join(root, rel), data); }
const ctx = readJson('00-meta/app-context.json', {});
const app = ctx.app || { name: 'Electron App', slug: 'electron-app' };
const screenshots = list('01-runtime/screenshots', (f) => /\.png$/i.test(f));
const stateCaptures = list('07-parity/state-captures', (f) => /\.md$/i.test(f));
const diffReports = list('07-parity/diffs', (f) => /-report\.json$/i.test(f));
const baseInputs = [
  '00-meta/manifest.json',
  '05-ui-ux-report/inspection-report.md',
  '05-ui-ux-report/design-tokens.json',
  '05-ui-ux-report/component-inventory.md',
  '05-ui-ux-report/interaction-matrix.md',
  '07-parity/parity-matrix.md'
];
const slices = [
  {
    id: 'slice-01-note-detail-static-shell',
    title: 'Note detail static shell',
    goal: 'Render the inspected note detail screen as a static, reviewable route before adding interactions.',
    status: 'ready',
    atoms: ['window shell', 'sidebar', 'topbar', 'content column', 'typography', 'ordered list', 'backlinks'],
    inputs: baseInputs.concat(screenshots.slice(0, 3)),
    outputs: ['centralized tokens', 'note detail example route/story', 'before/after screenshot', 'gap table'],
    acceptance: ['page is visible locally', 'tokens are centralized', 'layout/typography/backlinks gaps are listed as concrete measurements', 'no proprietary asset copying without provenance'],
    evidenceRequired: ['runtime-cdp screenshot or screenshot reference', 'computed CSS token evidence when available'],
    verification: ['visual screenshot capture', 'manual gap table or compare-screenshots output']
  },
  {
    id: 'slice-02-sidebar-states',
    title: 'Sidebar item states',
    goal: 'Implement default, hover, active, and pressed states for sidebar navigation atoms.',
    status: stateCaptures.some((x) => /sidebar/i.test(x)) ? 'ready' : 'needs-capture',
    atoms: ['sidebar item', 'section header', 'icon/text alignment', 'active background', 'hover feedback'],
    inputs: baseInputs.concat(stateCaptures.filter((x) => /sidebar/i.test(x))),
    outputs: ['state stories/examples', 'keyboard focus treatment', 'updated parity matrix'],
    acceptance: ['default/hover/active states exist for observed items', 'alignment and spacing match measured tokens', 'unobserved states stay as capture TODOs'],
    evidenceRequired: ['hover/active state capture or explicit TODO'],
    verification: ['visual state screenshots', 'keyboard/focus check when route supports it']
  },
  {
    id: 'slice-03-editor-block-visuals',
    title: 'Editor block visual parity',
    goal: 'Implement title, paragraph, ordered-list, and code-block visual states from inspected evidence.',
    status: stateCaptures.some((x) => /editor|title|paragraph|code|list/i.test(x)) ? 'ready' : 'needs-capture',
    atoms: ['title block', 'paragraph block', 'ordered list', 'code block', 'block spacing'],
    inputs: baseInputs.concat(stateCaptures.filter((x) => /editor|title|paragraph|code|list/i.test(x))),
    outputs: ['editor block components or styles', 'block state examples', 'visual gap table'],
    acceptance: ['font size/weight/line-height are tokenized', 'block spacing is measured or marked approximate', 'code/list rendering is visually stable'],
    evidenceRequired: ['computed CSS for text blocks or screenshot reference'],
    verification: ['visual screenshot capture', 'typecheck/lint']
  },
  {
    id: 'slice-04-editor-input-stability',
    title: 'Editor input and selection stability',
    goal: 'Add typing, selection, IME composition, paste, and undo/redo behavior checks for the editor.',
    status: 'needs-capture',
    atoms: ['cursor', 'selection', 'composition', 'paste', 'undo redo', 'keyboard navigation'],
    inputs: ['07-parity/editor-interaction-contract.md', '05-ui-ux-report/interaction-matrix.md'],
    outputs: ['Playwright tests or manual harness', 'IME/composition notes', 'updated acceptance checklist'],
    acceptance: ['typing keeps cursor stable', 'composition input remains stable', 'undo/redo restores text and cursor state where implemented'],
    evidenceRequired: ['interaction capture or local implementation test'],
    verification: ['Playwright keyboard tests', 'manual IME test notes']
  },
  {
    id: 'slice-05-scroll-resize-backlinks',
    title: 'Scroll, resize, and backlinks parity',
    goal: 'Stabilize content width, scroll anchoring, resize behavior, and backlinks placement/hover.',
    status: 'needs-capture',
    atoms: ['content max width', 'scroll anchoring', 'resize breakpoints', 'backlinks placement', 'backlinks hover'],
    inputs: baseInputs.concat(diffReports),
    outputs: ['resize examples/tests', 'backlinks state examples', 'visual diff report'],
    acceptance: ['content column remains stable across captured sizes', 'backlinks position and hover match evidence', 'visual diff report is updated'],
    evidenceRequired: ['resize captures or screenshot references'],
    verification: ['resize screenshots', 'compare-screenshots output']
  }
];
ensureDir(path.join(root, '07-parity'));
write('07-parity/implementation-slices.json', JSON.stringify({ schemaVersion: '4.1.0', app: app.slug, profile, generatedAt: new Date().toISOString(), slices }, null, 2));
const matrixRows = [
  ['note detail shell', 'observed if screenshot exists', screenshots.length ? screenshots.join(', ') : 'pending', 'static layout/typography/backlinks', slices[0].id],
  ['sidebar states', stateCaptures.some((x) => /sidebar/i.test(x)) ? 'partially observed' : 'not observed', stateCaptures.filter((x) => /sidebar/i.test(x)).join(', ') || 'pending', 'default/hover/active/pressed', slices[1].id],
  ['editor block visuals', stateCaptures.some((x) => /editor|title|paragraph|code|list/i.test(x)) ? 'partially observed' : 'not observed', stateCaptures.filter((x) => /editor|title|paragraph|code|list/i.test(x)).join(', ') || 'pending', 'title/paragraph/list/code', slices[2].id],
  ['editor input stability', 'not observed', 'pending', 'typing/selection/IME/paste/undo', slices[3].id],
  ['scroll resize backlinks', diffReports.length ? 'diff evidence exists' : 'not observed', diffReports.join(', ') || 'pending', 'resize/scroll/backlink hover', slices[4].id]
];
write('07-parity/parity-matrix.md', `# Parity Matrix\n\nApp: ${app.name}\nProfile: ${profile}\nGenerated: ${new Date().toISOString()}\n\n| Atom / Flow | Observation status | Evidence | Gaps to close | Slice |\n|---|---|---|---|---|\n${matrixRows.map((r) => `| ${r.map((x) => String(x).replace(/\|/g, '\\|')).join(' | ')} |`).join('\n')}\n\n## Capture discipline\n\n- Prefer computed CSS and DOM rects for tokens.\n- Use screenshot diffs for visual regression and review.\n- Keep missing hover/focus/selection/IME states as explicit capture tasks.\n`);
write('07-parity/codex-parity-prompt.md', `# Codex Parity Implementation Prompt\n\nYou are implementing Sumink-like interaction parity from an Electron inspection pack.\n\nRead in order:\n\n1. 00-meta/manifest.json\n2. 05-ui-ux-report/inspection-report.md\n3. 05-ui-ux-report/design-tokens.json\n4. 05-ui-ux-report/component-inventory.md\n5. 05-ui-ux-report/interaction-matrix.md\n6. 07-parity/parity-matrix.md\n7. 07-parity/implementation-slices.json\n8. 06-codex-tasks/acceptance-checklist.md\n\nWork one slice at a time. Start with the first slice whose status is \`ready\`. For each slice: inspect current implementation, identify the smallest visible gap, edit minimally, capture before/after screenshot when available, update the parity matrix and acceptance checklist, then report remaining gaps.\n`);
const task = readJson('06-codex-tasks/task-contract.json', {});
task.schemaVersion = '4.1.0';
task.app = task.app || app.slug;
task.goal = task.goal || 'Implement the UI described by the Electron inspection pack.';
task.readOrder = Array.from(new Set([...(task.readOrder || []), '07-parity/parity-matrix.md', '07-parity/implementation-slices.json']));
task.slices = slices;
delete task.verticalSlices;
task.unknowns = task.unknowns || [];
write('06-codex-tasks/task-contract.json', JSON.stringify(task, null, 2));
console.log(JSON.stringify({ ok: true, profile, slices: slices.length }, null, 2));
