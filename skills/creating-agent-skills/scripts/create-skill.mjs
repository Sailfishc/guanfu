#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';

const args = process.argv.slice(2);
function get(name, fallback = null) {
  const i = args.indexOf(`--${name}`);
  return i >= 0 ? args[i + 1] : fallback;
}
function has(name) { return args.includes(`--${name}`); }
function usage() {
  console.log(`Usage:
  node create-skill.mjs --name creating-x --description "Use when ..." --out ./package --surfaces codex,claude --with-evals

Options:
  --name          lowercase hyphen skill name
  --description   routing description for frontmatter
  --out           output package directory
  --surfaces      codex,claude,generic (default: codex,claude)
  --with-evals    create evals/cases.jsonl and eval runner placeholder
  --force         overwrite existing output directory
`);
}
if (has('help') || has('h')) { usage(); process.exit(0); }

const name = get('name');
const description = get('description');
const out = path.resolve(get('out', `./${name || 'new-skill'}-package`));
const surfaces = get('surfaces', 'codex,claude').split(',').map(s => s.trim()).filter(Boolean);
if (!name || !description) { usage(); process.exit(1); }
if (!/^[a-z0-9-]{1,64}$/.test(name)) { console.error('ERROR: invalid --name'); process.exit(1); }
if (description.length > 1024) { console.error('ERROR: --description exceeds 1024 chars'); process.exit(1); }
if (fs.existsSync(out) && !has('force')) { console.error(`ERROR: ${out} exists. Use --force to overwrite.`); process.exit(1); }
if (fs.existsSync(out)) fs.rmSync(out, { recursive: true, force: true });

function write(file, content) {
  fs.mkdirSync(path.dirname(file), { recursive: true });
  fs.writeFileSync(file, content);
}
function copyDir(src, dst) {
  fs.mkdirSync(dst, { recursive: true });
  for (const ent of fs.readdirSync(src, { withFileTypes: true })) {
    const s = path.join(src, ent.name); const d = path.join(dst, ent.name);
    if (ent.isDirectory()) copyDir(s, d); else fs.copyFileSync(s, d);
  }
}

const skillDir = path.join(out, 'skills', name);
write(path.join(skillDir, 'SKILL.md'), `---\nname: ${name}\ndescription: ${description}\n---\n\n# ${name.split('-').map(w => w[0].toUpperCase()+w.slice(1)).join(' ')}\n\n## Core principle\n\nDescribe the reusable behavior this skill teaches.\n\n## When to use\n\n- Primary trigger\n- Secondary trigger\n\nRoute these tasks elsewhere:\n\n- Related task outside this skill\n\n## Workflow\n\n1. Gather inputs.\n2. Follow the standard process.\n3. Produce the output contract.\n\n## Output contract\n\n\`\`\`text\n${name.toUpperCase().replaceAll('-', ' ')} REPORT\n- Inputs:\n- Actions:\n- Result:\n\`\`\`\n`);
write(path.join(skillDir, 'references', 'README.md'), '# References\n\nAdd one-level reference files here when SKILL.md would become too long.\n');
write(path.join(skillDir, 'agents', 'openai.yaml'), `interface:\n  display_name: "${name}"\n  short_description: "${description.slice(0, 120).replace(/"/g, '\\"')}"\npolicy:\n  allow_implicit_invocation: true\n`);

if (surfaces.includes('codex')) copyDir(skillDir, path.join(out, '.agents', 'skills', name));
if (surfaces.includes('claude')) copyDir(skillDir, path.join(out, '.claude', 'skills', name));

write(path.join(out, 'README.md'), `# ${name}\n\n## Install for Codex\n\n\`\`\`bash\nmkdir -p .agents/skills\ncp -R skills/${name} .agents/skills/\n\`\`\`\n\n## Install for Claude Code\n\n\`\`\`bash\nmkdir -p .claude/skills\ncp -R skills/${name} .claude/skills/\n\`\`\`\n`);
write(path.join(out, 'AGENTS.md.snippet'), `## Skill routing\n\nUse \`$${name}\` when: ${description}\n`);
write(path.join(out, 'CLAUDE.md.snippet'), `## Skill routing\n\nUse \`/${name}\` or the skill picker when: ${description}\n`);

if (has('with-evals')) {
  write(path.join(out, 'evals', 'cases.jsonl'), [
    { id: 'positive-primary', prompt: `Use ${name} for its primary task.`, should_trigger: true, expected_sections: [`${name.toUpperCase().replaceAll('-', ' ')} REPORT`], category: 'positive' },
    { id: 'negative-route-away', prompt: 'Run tests and commit the code.', should_trigger: false, category: 'route-away' },
    { id: 'explicit-invocation', prompt: `$${name} run the standard workflow.`, should_trigger: true, category: 'explicit' },
  ].map(o => JSON.stringify(o)).join('\n') + '\n');
}
console.log(`Created skill package at ${out}`);
