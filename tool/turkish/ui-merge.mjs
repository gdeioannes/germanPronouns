#!/usr/bin/env node
// Appends the translator's interface strings (tool/turkish/ui/<lang>.json,
// { English: translation }) to src/lib/i18n/<lang>.ts, skipping keys it already
// has and any whose {placeholders} do not match. Then delete ui/<lang>.json.
//   node tool/turkish/ui-merge.mjs [--lang ar]
import { readFileSync, writeFileSync, existsSync } from 'node:fs';

const langAt = process.argv.indexOf('--lang');
const LANG = langAt >= 0 ? process.argv[langAt + 1] : 'tr';
const path = `src/lib/i18n/${LANG}.ts`;
const src = readFileSync(path, 'utf8');
const incoming = JSON.parse(readFileSync(`tool/turkish/ui/${LANG}.json`, 'utf8'));
const holes = (s) => (s.match(/\{\w+\}/g) ?? []).sort().join(' ');
const lines = [];
let skipped = 0;
for (const [en, tr] of Object.entries(incoming)) {
	if (!tr || src.includes(`${JSON.stringify(en)}:`) || src.includes(`'${en.replace(/'/g, "\'")}':`)) continue;
	if (holes(en) !== holes(tr)) {
		console.log('placeholders differ, skipped:', en);
		skipped++;
		continue;
	}
	lines.push(`\t${JSON.stringify(en)}:\n\t\t${JSON.stringify(tr)},`);
}
const end = src.lastIndexOf('};');
const before = src.slice(0, end).replace(/\s*$/, '');
const out = `${before}${before.endsWith(',') ? '' : ','}\n\n\t// ── Added by tool/turkish/ui-merge.mjs ───────────────────\n${lines.join('\n')}\n};\n`;
writeFileSync(path, out);
console.log(`${lines.length} added, ${skipped} skipped`);
if (!existsSync('tool/turkish/ui/en.json')) process.exit(0);
