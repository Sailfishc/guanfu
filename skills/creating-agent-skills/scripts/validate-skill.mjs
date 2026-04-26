#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';
import crypto from 'node:crypto';

const args = process.argv.slice(2);
const root = path.resolve(args[0] || process.cwd());

function fail(msg) {
  console.error(`ERROR: ${msg}`);
  process.exitCode = 1;
}

function read(file) { return fs.readFileSync(file, 'utf8'); }
function exists(file) { return fs.existsSync(file); }
function sha(file) { return crypto.createHash('sha256').update(fs.readFileSync(file)).digest('hex'); }

function parseFrontmatter(text) {
  const m = text.match(/^---\n([\s\S]*?)\n---\n/);
  if (!m) return null;
  const fm = {};
  for (const line of m[1].split(/\r?\n/)) {
    const mm = line.match(/^([A-Za-z0-9_-]+):\s*(.*)$/);
    if (mm) fm[mm[1]] = mm[2].trim().replace(/^['"]|['"]$/g, '');
  }
  return fm;
}

function validateSkillDir(dir) {
  const skillFile = path.join(dir, 'SKILL.md');
  if (!exists(skillFile)) { fail(`${dir}: missing SKILL.md`); return; }
  const text = read(skillFile);
  const fm = parseFrontmatter(text);
  if (!fm) { fail(`${dir}: missing YAML frontmatter`); return; }
  const base = path.basename(dir);
  if (!fm.name) fail(`${dir}: missing name`);
  if (!fm.description) fail(`${dir}: missing description`);
  if (fm.name && !/^[a-z0-9-]{1,64}$/.test(fm.name)) fail(`${dir}: name must be lowercase letters, numbers, hyphens, max 64 chars`);
  if (fm.name && fm.name !== base) fail(`${dir}: name '${fm.name}' must match directory '${base}'`);
  if (fm.description && fm.description.length > 1024) fail(`${dir}: description exceeds 1024 chars`);
  if (fm.description && /I can|You can use this/i.test(fm.description)) fail(`${dir}: description should be third-person routing language`);
  if (fm.description && /step|first|then|workflow|run .* and .* then/i.test(fm.description)) fail(`${dir}: description appears to summarize workflow`);
  const lines = text.split(/\r?\n/).length;
  if (lines > 500) fail(`${dir}: SKILL.md has ${lines} lines; move details into references/`);
  const refs = [...text.matchAll(/\((references\/[^)]+)\)/g)].map(m => m[1]);
  for (const ref of refs) {
    if (ref.split('/').length > 2) fail(`${dir}: reference '${ref}' is nested deeper than one level`);
    if (!exists(path.join(dir, ref))) fail(`${dir}: referenced file missing: ${ref}`);
  }
}

function walkSkills(base) {
  if (!exists(base)) return [];
  return fs.readdirSync(base, { withFileTypes: true })
    .filter(d => d.isDirectory())
    .map(d => path.join(base, d.name));
}

const visible = walkSkills(path.join(root, 'skills'));
if (visible.length === 0) fail(`${root}: no visible skills/ directory found`);
for (const dir of visible) validateSkillDir(dir);

for (const dir of visible) {
  const name = path.basename(dir);
  const visibleSkill = path.join(dir, 'SKILL.md');
  const codexSkill = path.join(root, '.agents', 'skills', name, 'SKILL.md');
  const claudeSkill = path.join(root, '.claude', 'skills', name, 'SKILL.md');
  if (exists(codexSkill) && sha(visibleSkill) !== sha(codexSkill)) fail(`${name}: Codex mirror differs from visible copy`);
  if (exists(claudeSkill) && sha(visibleSkill) !== sha(claudeSkill)) fail(`${name}: Claude mirror differs from visible copy`);
}

if (exists(path.join(root, 'evals', 'cases.jsonl'))) {
  const lines = read(path.join(root, 'evals', 'cases.jsonl')).split(/\r?\n/).filter(Boolean);
  const ids = new Set();
  for (const [i, line] of lines.entries()) {
    try {
      const obj = JSON.parse(line);
      if (!obj.id) fail(`evals/cases.jsonl:${i+1}: missing id`);
      if (ids.has(obj.id)) fail(`evals/cases.jsonl:${i+1}: duplicate id ${obj.id}`);
      ids.add(obj.id);
      if (typeof obj.prompt !== 'string') fail(`evals/cases.jsonl:${i+1}: missing prompt`);
      if (typeof obj.should_trigger !== 'boolean') fail(`evals/cases.jsonl:${i+1}: missing should_trigger boolean`);
    } catch (e) {
      fail(`evals/cases.jsonl:${i+1}: invalid JSON`);
    }
  }
  console.log(`Validated ${lines.length} eval cases.`);
}

if (!process.exitCode) console.log(`Skill validation passed: ${root}`);
