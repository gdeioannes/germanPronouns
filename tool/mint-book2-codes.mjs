// Mints the page codes of the Book v2 chapters into assets/content/booklinks.json.
//
// Every chapter page with something to do in the app gets one permanent code
// (kind 'chapter', target "<level>/<chapter>/<part>"): the words page, the
// reading, both grammar pages, the real-world reading and both practice pages.
// The code opens that part of the chapter's page in the app (src/lib/domain/
// bookStudy.ts). Codes are "<level stem>-<n>", e.g. a11-07, and like every
// printed code they are never deleted or reused: re-running this tool only
// adds the codes that are missing.
//
//   node tool/mint-book2-codes.mjs            mint for every book
//   node tool/mint-book2-codes.mjs A1.1       one book
//   node tool/mint-book2-codes.mjs --check    exit 1 if a code is missing

import { readFileSync, writeFileSync, readdirSync } from 'node:fs';

const REGISTRY = 'assets/content/booklinks.json';
const BOOKS = 'assets/content/book2/de_cert_a1/';
const PARTS = ['woerter', 'lesen', 'grammatik-1', 'grammatik-2', 'alltag', 'uebungen-1', 'uebungen-2'];

const args = process.argv.slice(2);
const check = args.includes('--check');
const only = args.find((a) => !a.startsWith('--'));

const registry = JSON.parse(readFileSync(REGISTRY, 'utf8'));
const today = new Date().toISOString().slice(0, 10);
let added = 0;
const missing = [];

for (const file of readdirSync(BOOKS).filter((f) => /^[abc]\d_\d\.json$/.test(f)).sort()) {
	const stem = file.replace('.json', '');
	const level = stem.toUpperCase().replace('_', '.');
	if (only && only !== level) continue;
	const book = JSON.parse(readFileSync(BOOKS + file, 'utf8'));
	const prefix = stem.replace('_', '');
	for (const c of book.chapters) {
		for (const part of PARTS) {
			if (part.startsWith('grammatik') && !c.grammar[Number(part.slice(-1)) - 1]) continue;
			const target = `${level}/${c.id}/${part}`;
			if (registry.links.some((l) => l.kind === 'chapter' && l.target === target)) continue;
			if (check) {
				missing.push(target);
				continue;
			}
			const used = registry.links.filter((l) => l.code.startsWith(prefix + '-')).length;
			const code = `${prefix}-${String(used + 1).padStart(2, '0')}`;
			registry.links.push({ code, kind: 'chapter', target, note: `${level} ${c.title} · ${part}`, since: today });
			added++;
		}
	}
}

if (check) {
	if (missing.length) {
		console.error(`${missing.length} page codes not minted, e.g. ${missing.slice(0, 3).join(', ')}. Run node tool/mint-book2-codes.mjs`);
		process.exit(1);
	}
	console.log('Every page code is minted.');
} else {
	writeFileSync(REGISTRY, JSON.stringify(registry, null, '\t') + '\n');
	console.log(`Minted ${added} page codes.`);
}
