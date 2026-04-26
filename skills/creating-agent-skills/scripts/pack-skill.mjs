#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';
import { spawnSync } from 'node:child_process';

const root = path.resolve(process.argv[2] || process.cwd());
const name = path.basename(root);
const out = path.resolve(process.argv[3] || `${root}.zip`);
const zip = spawnSync('zip', ['-r', out, name], { cwd: path.dirname(root), stdio: 'inherit' });
if (zip.status !== 0) process.exit(zip.status ?? 1);
console.log(`Wrote ${out}`);
