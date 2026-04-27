#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';
import { createRequire } from 'node:module';
import { pathToFileURL } from 'node:url';

const require = createRequire(import.meta.url);
function arg(name, def = '') { const i = process.argv.indexOf(name); return i >= 0 ? process.argv[i + 1] : def; }
function ensureDir(p) { fs.mkdirSync(p, { recursive: true }); }
function findDocRoot() {
  const explicit = arg('--doc-root') || process.env.DOC_ROOT;
  if (explicit) return explicit;
  const out = arg('--out');
  if (!out) return process.cwd();
  let cur = path.resolve(path.dirname(out));
  for (let i = 0; i < 8; i++) {
    if (fs.existsSync(path.join(cur, '.tooling'))) return cur;
    cur = path.dirname(cur);
  }
  return process.cwd();
}
async function importPixelmatch(docRoot) {
  const local = path.join(docRoot, '.tooling', 'node_modules', 'pixelmatch', 'index.js');
  if (fs.existsSync(local)) return (await import(pathToFileURL(local).href)).default;
  const mod = await import('pixelmatch');
  return mod.default || mod;
}
function requirePng(docRoot) {
  const local = path.join(docRoot, '.tooling', 'node_modules', 'pngjs');
  try { return require(local).PNG; } catch {}
  return require('pngjs').PNG;
}
function readPng(PNG, file) { return PNG.sync.read(fs.readFileSync(file)); }
function makeCanvas(PNG, src, width, height) {
  const dst = new PNG({ width, height });
  for (let i = 0; i < dst.data.length; i += 4) {
    dst.data[i] = 255; dst.data[i + 1] = 255; dst.data[i + 2] = 255; dst.data[i + 3] = 255;
  }
  for (let y = 0; y < src.height; y++) {
    for (let x = 0; x < src.width; x++) {
      const si = (src.width * y + x) << 2;
      const di = (width * y + x) << 2;
      dst.data[di] = src.data[si];
      dst.data[di + 1] = src.data[si + 1];
      dst.data[di + 2] = src.data[si + 2];
      dst.data[di + 3] = src.data[si + 3];
    }
  }
  return dst;
}

const reference = arg('--reference');
const current = arg('--current');
const outBase = arg('--out');
const threshold = Number(arg('--threshold', '0.1'));
if (!reference || !current || !outBase) {
  console.error('Usage: compare-screenshots.mjs --reference reference.png --current current.png --out out/base [--threshold 0.1] [--doc-root root]');
  process.exit(64);
}

const docRoot = findDocRoot();
const PNG = requirePng(docRoot);
const pixelmatch = await importPixelmatch(docRoot);
const refPng = readPng(PNG, reference);
const curPng = readPng(PNG, current);
const width = Math.max(refPng.width, curPng.width);
const height = Math.max(refPng.height, curPng.height);
const refCanvas = makeCanvas(PNG, refPng, width, height);
const curCanvas = makeCanvas(PNG, curPng, width, height);
const diff = new PNG({ width, height });
const mismatchedPixels = pixelmatch(refCanvas.data, curCanvas.data, diff.data, width, height, { threshold });
const totalPixels = width * height;
const mismatchRatio = totalPixels ? mismatchedPixels / totalPixels : 0;
ensureDir(path.dirname(outBase));
const diffPng = `${outBase}-diff.png`;
const reportJson = `${outBase}-report.json`;
const reportMd = `${outBase}-report.md`;
fs.writeFileSync(diffPng, PNG.sync.write(diff));
const report = {
  schemaVersion: '4.1.0',
  generatedAt: new Date().toISOString(),
  reference,
  current,
  diff: diffPng,
  dimensions: {
    reference: { width: refPng.width, height: refPng.height },
    current: { width: curPng.width, height: curPng.height },
    compared: { width, height }
  },
  threshold,
  mismatchedPixels,
  totalPixels,
  mismatchRatio,
  mismatchPercent: Number((mismatchRatio * 100).toFixed(4)),
  sizeMismatch: refPng.width !== curPng.width || refPng.height !== curPng.height
};
fs.writeFileSync(reportJson, JSON.stringify(report, null, 2));
fs.writeFileSync(reportMd, `# Visual Diff Report\n\nGenerated: ${report.generatedAt}\n\n| Metric | Value |\n|---|---:|\n| Reference size | ${refPng.width} × ${refPng.height} |\n| Current size | ${curPng.width} × ${curPng.height} |\n| Compared size | ${width} × ${height} |\n| Threshold | ${threshold} |\n| Mismatched pixels | ${mismatchedPixels} |\n| Mismatch percent | ${report.mismatchPercent}% |\n| Size mismatch | ${report.sizeMismatch ? 'yes' : 'no'} |\n\nArtifacts:\n\n- diff: \`${path.basename(diffPng)}\`\n- JSON: \`${path.basename(reportJson)}\`\n`);
console.log(JSON.stringify(report, null, 2));
