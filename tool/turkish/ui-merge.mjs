#!/usr/bin/env node
// Appends the translator's interface strings (tool/turkish/ui/tr.json,
// { English: Türkçe }) to src/lib/i18n/tr.ts, skipping keys tr.ts already has
// and any whose {placeholders} do not match. Then delete ui/tr.json.
import { readFileSync, writeFileSync, existsSync } from 'node:fs';

const path = 'src/lib/i18n/tr.ts';
const src = readFileSync(path, 'utf8');
const incoming = JSON.parse(readFileSync('tool/turkish/ui/tr.json', 'utf8'));
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
