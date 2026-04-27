#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';

const root = process.argv[2] || process.argv[process.argv.indexOf('--doc-root') + 1];
const strict = process.argv.includes('--strict');
if (!root || root === 'undefined') {
  console.error('Usage: validate-parity-pack.mjs <doc-root> [--strict]');
  process.exit(64);
}
function exists(rel) { return fs.existsSync(path.join(root, rel)); }
function readJson(rel, fallback = null) { try { return JSON.parse(fs.readFileSync(path.join(root, rel), 'utf8')); } catch { return fallback; } }
function list(rel, pred = () => true) { const dir = path.join(root, rel); return fs.existsSync(dir) ? fs.readdirSync(dir).filter(pred) : []; }
function ensureDir(p) { fs.mkdirSync(p, { recursive: true }); }
const checks = [];
function check(kind, ok, message, evidence = '') { checks.push({ kind, ok, message, evidence }); }
check('required', exists('00-meta/app-context.json'), 'app context exists', '00-meta/app-context.json');
check('required', exists('05-ui-ux-report/inspection-report.md'), 'inspection report exists', '05-ui-ux-report/inspection-report.md');
check('required', exists('06-codex-tasks/task-contract.json'), 'task contract exists', '06-codex-tasks/task-contract.json');
check('required', exists('07-parity/parity-matrix.md'), 'parity matrix exists', '07-parity/parity-matrix.md');
check('required', exists('07-parity/implementation-slices.json'), 'implementation slices exist', '07-parity/implementation-slices.json');
const tokens = readJson('05-ui-ux-report/design-tokens.json', {});
const tokenCount = ['colors', 'typography', 'spacing', 'radii', 'shadows'].reduce((n, k) => n + (Array.isArray(tokens[k]) ? tokens[k].length : 0), 0);
check('semantic', tokenCount > 0, `design tokens contain extracted values (${tokenCount})`, '05-ui-ux-report/design-tokens.json');
const task = readJson('06-codex-tasks/task-contract.json', {});
check('semantic', Array.isArray(task.slices) && task.slices.length > 0, 'task contract has slices[]', '06-codex-tasks/task-contract.json');
check('semantic', !task.verticalSlices, 'task contract uses slices[] instead of verticalSlices[]', '06-codex-tasks/task-contract.json');
const impl = readJson('07-parity/implementation-slices.json', {});
check('semantic', Array.isArray(impl.slices) && impl.slices.length > 0, 'implementation slices have at least one slice', '07-parity/implementation-slices.json');
const screenshots = list('01-runtime/screenshots', (f) => /\.png$/i.test(f));
const states = list('07-parity/state-captures', (f) => /\.md$/i.test(f));
const diffs = list('07-parity/diffs', (f) => /-report\.json$/i.test(f));
check('evidence', screenshots.length > 0, `runtime screenshots exist (${screenshots.length})`, '01-runtime/screenshots/');
check('evidence', states.length > 0, `state captures exist (${states.length})`, '07-parity/state-captures/');
check('evidence', diffs.length > 0, `visual diff reports exist (${diffs.length})`, '07-parity/diffs/');
const errors = checks.filter((x) => x.kind === 'required' && !x.ok);
const warnings = checks.filter((x) => x.kind !== 'required' && !x.ok);
const report = `# Parity Pack Validation\n\nGenerated: ${new Date().toISOString()}\n\n| Kind | Status | Check | Evidence |\n|---|---|---|---|\n${checks.map((c) => `| ${c.kind} | ${c.ok ? 'pass' : 'gap'} | ${c.message.replace(/\|/g, '\\|')} | ${c.evidence ? '`' + c.evidence + '`' : ''} |`).join('\n')}\n\n## Result\n\n- Required errors: ${errors.length}\n- Semantic/evidence gaps: ${warnings.length}\n\n${warnings.length ? 'Semantic/evidence gaps are normal during early inspection. Close them before final Codex implementation handoff.\n' : 'Parity pack is ready for Codex implementation handoff.\n'}`;
ensureDir(path.join(root, '05-ui-ux-report'));
fs.writeFileSync(path.join(root, '05-ui-ux-report', 'parity-pack-validation.md'), report);
console.log(report);
if (errors.length || (strict && warnings.length)) process.exit(1);
