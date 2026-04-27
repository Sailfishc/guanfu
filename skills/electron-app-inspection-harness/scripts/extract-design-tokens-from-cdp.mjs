#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';

const root = process.argv[2] || process.argv[process.argv.indexOf('--doc-root') + 1];
if (!root || root === 'undefined') {
  console.error('Usage: extract-design-tokens-from-cdp.mjs <doc-root>');
  process.exit(64);
}
function ensureDir(p) { fs.mkdirSync(p, { recursive: true }); }
function walk(dir, pred, acc = []) {
  if (!fs.existsSync(dir)) return acc;
  for (const item of fs.readdirSync(dir)) {
    const abs = path.join(dir, item);
    const st = fs.statSync(abs);
    if (st.isDirectory()) walk(abs, pred, acc);
    else if (pred(abs)) acc.push(abs);
  }
  return acc;
}
function readJson(file, fallback = null) { try { return JSON.parse(fs.readFileSync(file, 'utf8')); } catch { return fallback; } }
function uniqBy(arr, keyFn, limit = 100) {
  const seen = new Set(); const out = [];
  for (const x of arr) { const k = keyFn(x); if (!k || seen.has(k)) continue; seen.add(k); out.push(x); if (out.length >= limit) break; }
  return out;
}
function numPx(v) { const m = String(v || '').match(/-?\d+(\.\d+)?/); return m ? Number(m[0]) : null; }
function meaningfulName(node, fallback) {
  const text = String(node.text || '').replace(/\s+/g, ' ').trim();
  if (node.ariaLabel) return node.ariaLabel.slice(0, 48);
  if (text) return text.slice(0, 48);
  if (node.role) return node.role;
  if (node.className) return String(node.className).split(/\s+/).filter(Boolean).slice(0, 2).join('.').slice(0, 48);
  return fallback;
}
function isColor(v) {
  const s = String(v || '').trim();
  return /^(rgb|rgba|hsl|hsla)\(/.test(s) && !/^rgba\(0, 0, 0, 0\)$/.test(s) && s !== 'transparent';
}
const files = walk(path.join(root, '01-runtime', 'dom'), (f) => /-dom-styles\.json$/.test(f));
const nodes = [];
for (const file of files) {
  const label = path.basename(file).replace(/-dom-styles\.json$/, '');
  const data = readJson(file, []);
  if (Array.isArray(data)) for (const node of data) nodes.push({ ...node, evidence: path.relative(root, file).replace(/\\/g, '/'), label });
}
const colorCandidates = [];
const typographyCandidates = [];
const radiusCandidates = [];
const shadowCandidates = [];
const spacingCandidates = [];
for (const node of nodes) {
  const s = node.style || {};
  const nameBase = meaningfulName(node, `${node.tag}-${node.index}`);
  if (isColor(s.color)) colorCandidates.push({ name: `${nameBase} text`, value: s.color, property: 'color', evidence: node.evidence, label: node.label });
  if (isColor(s.backgroundColor)) colorCandidates.push({ name: `${nameBase} background`, value: s.backgroundColor, property: 'backgroundColor', evidence: node.evidence, label: node.label });
  const fsPx = numPx(s.fontSize);
  const lhPx = numPx(s.lineHeight);
  if (fsPx && String(node.text || '').trim()) typographyCandidates.push({
    name: nameBase,
    fontFamily: s.fontFamily,
    fontSize: s.fontSize,
    fontWeight: s.fontWeight,
    lineHeight: s.lineHeight,
    letterSpacing: s.letterSpacing,
    sampleText: String(node.text || '').slice(0, 120),
    rect: node.rect,
    evidence: node.evidence,
    label: node.label,
    score: fsPx * 10 + (node.rect?.h || 0)
  });
  if (s.borderRadius && s.borderRadius !== '0px') radiusCandidates.push({ name: nameBase, value: s.borderRadius, evidence: node.evidence, label: node.label, rect: node.rect });
  if (s.boxShadow && s.boxShadow !== 'none') shadowCandidates.push({ name: nameBase, value: s.boxShadow, evidence: node.evidence, label: node.label, rect: node.rect });
  for (const prop of ['padding', 'margin']) {
    if (s[prop] && s[prop] !== '0px') spacingCandidates.push({ name: `${nameBase} ${prop}`, property: prop, value: s[prop], evidence: node.evidence, label: node.label, rect: node.rect });
  }
  if (node.rect) {
    for (const [prop, value] of Object.entries({ x: node.rect.x, y: node.rect.y, w: node.rect.w, h: node.rect.h })) {
      if (typeof value === 'number' && value > 0 && value < 2500) spacingCandidates.push({ name: `${nameBase} rect.${prop}`, property: `rect.${prop}`, value: Number(value.toFixed(2)), unit: 'px', evidence: node.evidence, label: node.label });
    }
  }
}
const typography = uniqBy(typographyCandidates.sort((a, b) => b.score - a.score), (x) => `${x.fontFamily}|${x.fontSize}|${x.fontWeight}|${x.lineHeight}`, 32).map(({ score, ...x }) => x);
const colors = uniqBy(colorCandidates, (x) => `${x.property}|${x.value}`, 64);
const radii = uniqBy(radiusCandidates, (x) => x.value, 32);
const shadows = uniqBy(shadowCandidates, (x) => x.value, 24);
const spacing = uniqBy(spacingCandidates, (x) => `${x.property}|${x.value}`, 96);
const output = {
  schemaVersion: '4.1.0',
  generatedAt: new Date().toISOString(),
  source: 'runtime-cdp computed CSS + DOM rects',
  colors,
  typography,
  spacing,
  radii,
  shadows,
  provenanceRules: ['computed CSS and DOM rects are high confidence', 'screenshot-only measurements remain approximate', 'manual naming should be refined after review']
};
ensureDir(path.join(root, '05-ui-ux-report'));
ensureDir(path.join(root, '07-parity', 'measurements'));
fs.writeFileSync(path.join(root, '05-ui-ux-report', 'design-tokens.json'), JSON.stringify(output, null, 2));
fs.writeFileSync(path.join(root, '07-parity', 'measurements', 'design-token-measurements.json'), JSON.stringify({ files: files.map((f) => path.relative(root, f).replace(/\\/g, '/')), counts: { nodes: nodes.length, colors: colors.length, typography: typography.length, spacing: spacing.length, radii: radii.length, shadows: shadows.length } }, null, 2));
fs.writeFileSync(path.join(root, '07-parity', 'measurements', 'design-token-measurements.md'), `# Design Token Measurements\n\nGenerated: ${output.generatedAt}\n\n| Token class | Count |\n|---|---:|\n| Colors | ${colors.length} |\n| Typography | ${typography.length} |\n| Spacing/rects | ${spacing.length} |\n| Radii | ${radii.length} |\n| Shadows | ${shadows.length} |\n\nSource files:\n\n${files.map((f) => `- \`${path.relative(root, f).replace(/\\/g, '/')}\``).join('\n') || '- none'}\n`);
console.log(JSON.stringify({ ok: true, counts: { nodes: nodes.length, colors: colors.length, typography: typography.length, spacing: spacing.length, radii: radii.length, shadows: shadows.length } }, null, 2));
