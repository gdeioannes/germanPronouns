#!/usr/bin/env node
// Lists every interface string given to t() / tn() that tr.ts has no Turkish for.
//   node tool/turkish/ui-keys.mjs           missing keys, as lines ready to paste into tr.ts
//   node tool/turkish/ui-keys.mjs --unused  keys in tr.ts nothing uses any more
import { mkdirSync, readFileSync, readdirSync, statSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';

const files = [];
(function walk(d) {
	for (const f of readdirSync(d)) {
		const p = join(d, f);
		if (statSync(p).isDirectory()) walk(p);
		else if (/\.(svelte|ts)$/.test(f) && !/\.test\.ts$/.test(f) && !/i18n[\\/]tr\.ts$/.test(p)) files.push(p);
	}
})('src');

// A quoted JS string literal: quote in group a, body in group b.
const lit = (a, b) => `(['"\`])((?:\\\\.|(?!\\${a})[^\\\\])*)\\${a}`.replace('((?:', '((?:').replace(/^/, '');
// t('…') and the constant marker tk('…').
const T = new RegExp(String.raw`\btk?\(\s*` + lit(1), 'g');
const TN = new RegExp(String.raw`\btn\(\s*[^,]+,\s*` + lit(1) + String.raw`\s*,\s*` + lit(3), 'g');
const unescape = (s, q) => s.split('\\' + q).join(q).split('\\\\').join('\\');

const used = new Map();
for (const f of files) {
	const src = readFileSync(f, 'utf8');
	for (const m of src.matchAll(T)) {
		if (m[1] === '`' && m[2].includes('${')) continue;
		used.set(unescape(m[2], m[1]), f);
	}
	for (const m of src.matchAll(TN)) {
		used.set(unescape(m[2], m[1]), f);
		used.set(unescape(m[4], m[3]), f);
	}
}
// Page help (content/pageHelp.ts) is shown through t() field by field: its
// strings count for the routes that exist in Turkish (i18n/available.ts).
{
	const routes = [...readFileSync('src/lib/i18n/available.ts', 'utf8').matchAll(/^\t'(\/[^']*)',?$/gm)].map((m) => m[1]);
	const help = readFileSync('src/lib/content/pageHelp.ts', 'utf8');
	const blocks = [...help.matchAll(/^\t'(\/[^']*)': \{$/gm)];
	blocks.forEach((b, i) => {
		if (!routes.includes(b[1])) return;
		const body = help.slice(b.index, blocks[i + 1]?.index ?? help.length);
		for (const m of body.matchAll(/(?:title|intro|text):\s*('(?:[^'\\]|\\.)*')|^\s*('(?:[^'\\]|\\.)*'),?$/gm)) {
			const lit = m[1] ?? m[2];
			if (lit) used.set(unescape(lit.slice(1, -1), "'"), 'src/lib/content/pageHelp.ts');
		}
	});
}
const trSrc = readFileSync('src/lib/i18n/tr.ts', 'utf8');
const have = new Set();
for (const m of trSrc.matchAll(new RegExp(String.raw`^\s*` + lit(1) + String.raw`\s*:`, 'gm'))) have.add(unescape(m[2], m[1]));
// Keys Prettier leaves unquoted (About: '…').
for (const m of trSrc.matchAll(/^\s*([\p{L}_$][\p{L}\p{N}_$]*)\s*:/gmu)) have.add(m[1]);

if (process.argv.includes('--json')) {
	// For the translator: tool/turkish/ui/en.json { English: file } of what tr.ts lacks.
	const missing = Object.fromEntries([...used].filter(([k]) => !have.has(k)).map(([k, f]) => [k, f.replace(/\\/g, '/')]));
	mkdirSync('tool/turkish/ui', { recursive: true });
	writeFileSync('tool/turkish/ui/en.json', JSON.stringify(missing, null, 1));
	console.log(`${Object.keys(missing).length} keys → tool/turkish/ui/en.json`);
} else if (process.argv.includes('--unused')) {
	for (const k of have) if (!used.has(k)) console.log(JSON.stringify(k));
} else {
	const missing = [...used].filter(([k]) => !have.has(k));
	const byFile = {};
	for (const [k, f] of missing) (byFile[f] ??= []).push(k);
	for (const [f, ks] of Object.entries(byFile)) {
		console.log(`\t// ${f.replace(/\\/g, '/')}`);
		for (const k of ks) console.log(`\t${JSON.stringify(k)}: '',`);
	}
	console.error(`${missing.length} missing of ${used.size}`);
}
