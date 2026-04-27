#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';
import { createRequire } from 'node:module';

const require = createRequire(import.meta.url);

function arg(name, def = '') {
  const i = process.argv.indexOf(name);
  return i >= 0 ? process.argv[i + 1] : def;
}
function has(name) { return process.argv.includes(name); }
function sleep(ms) { return new Promise((resolve) => setTimeout(resolve, ms)); }
function safeLabel(s) { return String(s || 'state').toLowerCase().replace(/[^a-z0-9_-]+/g, '-').replace(/^-+|-+$/g, '') || 'state'; }
function ensureDir(p) { fs.mkdirSync(p, { recursive: true }); }
function writeJson(file, value) { ensureDir(path.dirname(file)); fs.writeFileSync(file, JSON.stringify(value, null, 2)); }
function rel(root, file) { return path.relative(root, file).replace(/\\/g, '/'); }
function loadTool(docRoot, pkg) {
  const local = path.join(docRoot, '.tooling', 'node_modules', pkg);
  try { return require(local); } catch {}
  return require(pkg);
}
function readScenario(file) {
  if (!file) {
    throw new Error('Missing --scenario <scenario.json>. A scenario contains states with actions.');
  }
  const data = JSON.parse(fs.readFileSync(file, 'utf8'));
  if (!Array.isArray(data.states)) throw new Error('Scenario must contain a states array.');
  return data;
}

const docRoot = arg('--doc-root');
const port = Number(arg('--port', '9222'));
const scenarioPath = arg('--scenario');
const targetIndex = Number(arg('--target-index', '0'));
if (!docRoot) {
  console.error('Usage: capture-state-sequence.mjs --doc-root <doc-root> --port 9222 --scenario <scenario.json> [--target-index 0]');
  process.exit(64);
}

const scenario = readScenario(scenarioPath);
const out = {
  screenshots: path.join(docRoot, '01-runtime', 'screenshots'),
  dom: path.join(docRoot, '01-runtime', 'dom'),
  ax: path.join(docRoot, '01-runtime', 'accessibility'),
  cn: path.join(docRoot, '01-runtime', 'console-network'),
  states: path.join(docRoot, '07-parity', 'state-captures'),
  measurements: path.join(docRoot, '07-parity', 'measurements')
};
Object.values(out).forEach(ensureDir);

const selectorResolver = String.raw`(query) => {
  const norm = (s) => String(s || '').replace(/\s+/g, ' ').trim();
  const all = Array.from(document.querySelectorAll('*'));
  let el = null;
  if (query.selector) el = document.querySelector(query.selector);
  if (!el && query.text) {
    const needle = norm(query.text).toLowerCase();
    el = all.find((node) => norm(node.textContent).toLowerCase().includes(needle));
  }
  if (!el && query.exactText) {
    const needle = norm(query.exactText).toLowerCase();
    el = all.find((node) => norm(node.textContent).toLowerCase() === needle);
  }
  if (!el && query.role) {
    const role = String(query.role);
    const name = query.name ? norm(query.name).toLowerCase() : '';
    const candidates = all.filter((node) => {
      const explicit = node.getAttribute('role');
      const implicit = node.tagName.toLowerCase() === 'button' ? 'button' : '';
      return explicit === role || implicit === role;
    });
    el = candidates.find((node) => {
      if (!name) return true;
      const label = norm(node.getAttribute('aria-label') || node.textContent).toLowerCase();
      return label.includes(name);
    });
  }
  if (!el) return null;
  const r = el.getBoundingClientRect();
  return {
    tag: el.tagName.toLowerCase(),
    id: el.id || '',
    className: String(el.className || ''),
    role: el.getAttribute('role') || '',
    ariaLabel: el.getAttribute('aria-label') || '',
    text: norm(el.textContent).slice(0, 160),
    rect: { x: r.x, y: r.y, w: r.width, h: r.height, cx: r.x + r.width / 2, cy: r.y + r.height / 2 }
  };
}`;

async function resolveTarget(Runtime, query) {
  const expression = `(${selectorResolver})(${JSON.stringify(query || {})})`;
  const result = await Runtime.evaluate({ expression, returnByValue: true });
  const value = result?.result?.value;
  if (!value) throw new Error(`Target not found: ${JSON.stringify(query)}`);
  return value;
}

async function dispatchMouse(Input, x, y, type, button = 'left') {
  await Input.dispatchMouseEvent({ type, x, y, button, clickCount: type === 'mouseMoved' ? 0 : 1 });
}

async function performAction(client, action) {
  const { Runtime, Input, Emulation } = client;
  const type = action.type || 'wait';
  if (type === 'wait') {
    await sleep(Number(action.ms ?? action.duration ?? 250));
    return { action, result: 'waited' };
  }
  if (type === 'evaluate') {
    const result = await Runtime.evaluate({ expression: String(action.expression || 'undefined'), awaitPromise: true, returnByValue: true });
    return { action, result: result?.result?.value ?? null };
  }
  if (type === 'resize') {
    const width = Number(action.width || action.w || 1280);
    const height = Number(action.height || action.h || 800);
    const deviceScaleFactor = Number(action.deviceScaleFactor || action.dpr || 1);
    await Emulation.setDeviceMetricsOverride({ width, height, deviceScaleFactor, mobile: false });
    await sleep(Number(action.afterMs || 250));
    return { action, result: { width, height, deviceScaleFactor } };
  }
  if (type === 'hover' || type === 'click') {
    const target = await resolveTarget(Runtime, action);
    const { cx, cy } = target.rect;
    await dispatchMouse(Input, cx, cy, 'mouseMoved');
    if (type === 'click') {
      await dispatchMouse(Input, cx, cy, 'mousePressed', action.button || 'left');
      await dispatchMouse(Input, cx, cy, 'mouseReleased', action.button || 'left');
    }
    await sleep(Number(action.afterMs || 180));
    return { action, target };
  }
  if (type === 'type') {
    if (action.selector || action.text || action.exactText || action.role) {
      const target = await resolveTarget(Runtime, action);
      await dispatchMouse(Input, target.rect.cx, target.rect.cy, 'mouseMoved');
      await dispatchMouse(Input, target.rect.cx, target.rect.cy, 'mousePressed');
      await dispatchMouse(Input, target.rect.cx, target.rect.cy, 'mouseReleased');
    }
    await Input.insertText({ text: String(action.value ?? action.textToInsert ?? '') });
    await sleep(Number(action.afterMs || 180));
    return { action, result: 'typed' };
  }
  if (type === 'key') {
    const key = String(action.key || 'Enter');
    await Input.dispatchKeyEvent({ type: 'keyDown', key });
    await Input.dispatchKeyEvent({ type: 'keyUp', key });
    await sleep(Number(action.afterMs || 120));
    return { action, result: { key } };
  }
  throw new Error(`Unsupported action type: ${type}`);
}

async function captureState(client, label, actionResults) {
  const { Runtime, Page, Accessibility } = client;
  const meta = await Runtime.evaluate({ expression: `({title: document.title, url: location.href, readyState: document.readyState, viewport: {w: innerWidth, h: innerHeight, dpr: devicePixelRatio}, activeElement: {tag: document.activeElement?.tagName?.toLowerCase(), text: (document.activeElement?.textContent || '').trim().slice(0, 160), role: document.activeElement?.getAttribute?.('role') || '', ariaLabel: document.activeElement?.getAttribute?.('aria-label') || ''}})`, returnByValue: true });
  const domStyles = await Runtime.evaluate({ expression: `(() => {
    const nodes = Array.from(document.querySelectorAll('*')).slice(0, 2500);
    return nodes.map((el, index) => {
      const r = el.getBoundingClientRect();
      const s = getComputedStyle(el);
      const text = (el.textContent || '').trim().replace(/\s+/g, ' ').slice(0, 180);
      return {
        index,
        tag: el.tagName.toLowerCase(),
        id: el.id || '',
        className: String(el.className || ''),
        role: el.getAttribute('role') || '',
        ariaLabel: el.getAttribute('aria-label') || '',
        text,
        rect: {x: r.x, y: r.y, w: r.width, h: r.height},
        style: {
          display: s.display, position: s.position, zIndex: s.zIndex,
          fontFamily: s.fontFamily, fontSize: s.fontSize, fontWeight: s.fontWeight, lineHeight: s.lineHeight,
          letterSpacing: s.letterSpacing, color: s.color, backgroundColor: s.backgroundColor,
          padding: s.padding, margin: s.margin, border: s.border,
          borderRadius: s.borderRadius, boxShadow: s.boxShadow,
          overflow: s.overflow, opacity: s.opacity, cursor: s.cursor
        }
      };
    });
  })()`, returnByValue: true });
  const metaFile = path.join(out.dom, `${label}-meta.json`);
  const domFile = path.join(out.dom, `${label}-dom-styles.json`);
  const screenshotFile = path.join(out.screenshots, `${label}.png`);
  const axFile = path.join(out.ax, `${label}-ax-tree.json`);
  writeJson(metaFile, meta.result.value);
  writeJson(domFile, domStyles.result.value);
  try {
    const shot = await Page.captureScreenshot({ format: 'png', captureBeyondViewport: true });
    fs.writeFileSync(screenshotFile, Buffer.from(shot.data, 'base64'));
  } catch (e) {
    fs.writeFileSync(path.join(out.screenshots, `${label}-screenshot-error.txt`), String(e.stack || e));
  }
  try {
    const ax = await Accessibility.getFullAXTree({});
    writeJson(axFile, ax);
  } catch (e) {
    fs.writeFileSync(path.join(out.ax, `${label}-ax-error.txt`), String(e.stack || e));
  }
  const measurement = {
    schemaVersion: '4.1.0',
    label,
    capturedAt: new Date().toISOString(),
    meta: meta.result.value,
    actionResults,
    artifacts: {
      screenshot: rel(docRoot, screenshotFile),
      domStyles: rel(docRoot, domFile),
      meta: rel(docRoot, metaFile),
      accessibility: rel(docRoot, axFile)
    }
  };
  writeJson(path.join(out.measurements, `${label}-measurement.json`), measurement);
  fs.writeFileSync(path.join(out.states, `${label}.md`), `# State Capture: ${label}\n\nCaptured: ${measurement.capturedAt}\n\n## Actions\n\n${actionResults.map((x, i) => `- ${i + 1}. ${x.action.type}: ${JSON.stringify(x.action)}`).join('\n') || '- none'}\n\n## Artifacts\n\n- screenshot: \`${measurement.artifacts.screenshot}\`\n- DOM/CSS: \`${measurement.artifacts.domStyles}\`\n- accessibility: \`${measurement.artifacts.accessibility}\`\n- measurement: \`07-parity/measurements/${label}-measurement.json\`\n`);
  return measurement;
}

async function main() {
  const CDP = loadTool(docRoot, 'chrome-remote-interface');
  const targets = await CDP.List({ port });
  writeJson(path.join(docRoot, '01-runtime', 'pages.json'), targets);
  const pageTargets = targets.filter((t) => t.type === 'page' || t.type === 'webview');
  const pageTarget = pageTargets[targetIndex] || pageTargets[0] || targets[0];
  if (!pageTarget) throw new Error(`No CDP targets on port ${port}`);
  const client = await CDP({ port, target: pageTarget });
  const { Runtime, Page, DOM, Accessibility, Log, Network, Input, Emulation } = client;
  const logs = [];
  try {
    await Promise.all([Runtime.enable(), Page.enable(), DOM.enable(), Log.enable(), Network.enable()].filter(Boolean));
    if (Log?.entryAdded) Log.entryAdded(({ entry }) => logs.push(entry));
    const captures = [];
    for (const state of scenario.states) {
      const label = safeLabel(state.label || state.name);
      const actionResults = [];
      for (const action of state.actions || []) actionResults.push(await performAction({ Runtime, Page, DOM, Accessibility, Log, Network, Input, Emulation }, action));
      captures.push(await captureState({ Runtime, Page, Accessibility }, label, actionResults));
    }
    writeJson(path.join(out.cn, `${safeLabel(scenario.name || 'state-sequence')}-log-entries.json`), logs);
    writeJson(path.join(out.measurements, `${safeLabel(scenario.name || 'state-sequence')}-summary.json`), { schemaVersion: '4.1.0', scenario, captures });
    console.log(JSON.stringify({ ok: true, target: pageTarget.title || pageTarget.url, captures: captures.map((c) => c.label) }, null, 2));
  } finally {
    await client.close();
  }
}

main().catch((e) => { console.error(e.stack || e); process.exit(1); });
