// @ts-nocheck: a command-line tool in plain JavaScript; the tests import it as is.
// The rights audit: every picture the site and the books ship, matched to where
// it comes from and under which terms (docs/rights_audit.md explains the policy).
//
//   node tool/rights-audit.mjs            print the summary
//   node tool/rights-audit.mjs --json     write docs/rights/images.json (the register)
//
// Sources, in the order a file is matched:
//   commons  a Wikimedia Commons photo credited in a _photos.json (author,
//            licence, source); its copies in photo/, photo/web/, deck/, hero/ …
//   ai       a picture made with Google's Gemini image model from a prompt in
//            assets/images/*manifest.json
//   own      made by this project: code-drawn (OG cards, icons), screenshots of
//            the app, covers composed from the above (assets/rights/own.json)
// A shipped picture with none of these is UNKNOWN, and the test fails on it
// (src/lib/domain/rights.test.ts).
import { execFileSync } from 'node:child_process';
import { readFileSync, readdirSync, writeFileSync, mkdirSync } from 'node:fs';

const root = new URL('..', import.meta.url);
const read = (p) => JSON.parse(readFileSync(new URL(p, root), 'utf8'));

/** Licences a Commons photo may carry: all allow commercial use and changes. */
export const ALLOWED = /^(CC0|Public domain|CC BY(-SA)? (1\.0|2\.0|2\.5|3\.0|4\.0))$/;

/** Folders that hold photos (Commons copies), never generated pictures. */
const PHOTO_FOLDER = /^static\/img\/(photo|deck|hero)\//;

/** Files the site actually ships: tracked by git, under static/, pictures only. */
export function shippedImages() {
	const pats = ['webp', 'jpg', 'jpeg', 'png', 'gif', 'svg', 'avif'].flatMap((x) => [`static/**/*.${x}`, `static/*.${x}`]);
	const out = execFileSync('git', ['ls-files', '--', ...pats], { cwd: root, encoding: 'utf8', maxBuffer: 64 * 1024 * 1024 });
	return out.split('\n').filter((f) => /\.(webp|jpe?g|png|gif|svg|avif)$/i.test(f));
}

export function commonsCredits() {
	const all = {};
	for (const f of ['assets/content/book2/de_cert_a1/_photos.json', 'assets/content/chapters/de_cert_a1/_photos.json']) Object.assign(all, read(f));
	return all;
}

export function aiIds() {
	const ids = new Map();
	for (const f of readdirSync(new URL('assets/images/', root)).filter((f) => f.endsWith('.json'))) {
		const m = read(`assets/images/${f}`);
		for (const img of m.images ?? []) ids.set(img.id, f);
	}
	return ids;
}

export function ownRegister() {
	return read('assets/rights/own.json');
}

/** The id a file is known by: its name without folder, size suffix or extension. */
const idOf = (file) =>
	file
		.split('/')
		.pop()
		.replace(/\.(webp|jpe?g|png|gif|svg|avif)$/i, '')
		.replace(/-(1200|2400|thumb|front|back|spine)(-\w+)?$/, '');

export function audit() {
	const commons = commonsCredits();
	const ai = aiIds();
	const own = ownRegister();
	const rows = [];
	for (const file of shippedImages()) {
		const id = idOf(file);
		const ownHit = own.files.find((o) => new RegExp(o.pattern).test(file));
		let row;
		if (ownHit) row = { file, source: 'own', note: ownHit.note, from: ownHit.from ?? null };
		else if (commons[id]) {
			const { source: url, ...credit } = commons[id];
			row = { file, source: 'commons', id, ...credit, url };
		}
		// A photo folder never holds a generated picture: a name there that
		// matches a prompt id ("bahnhof") is a photo all the same.
		else if (ai.has(id) && !PHOTO_FOLDER.test(file)) row = { file, source: 'ai', id, manifest: ai.get(id) };
		else row = { file, source: 'unknown', id };
		rows.push(row);
	}
	return { rows, commons };
}

/** Problems a Commons credit can have: each must be fixed before the books ship. */
export function creditProblems(commons) {
	const out = [];
	for (const [id, c] of Object.entries(commons)) {
		if (!ALLOWED.test(c.license ?? '')) out.push(`${id}: licence "${c.license}" is not on the allow list`);
		if (!c.author?.trim()) out.push(`${id}: no author`);
		if (!/^https:\/\/commons\.wikimedia\.org\/wiki\/File:/.test(c.source ?? '')) out.push(`${id}: no Commons source link`);
		if (!c.title?.trim()) out.push(`${id}: no file title`);
	}
	return out;
}

if (process.argv[1]?.replace(/\\/g, '/').endsWith('tool/rights-audit.mjs')) {
	const { rows, commons } = audit();
	const by = (s) => rows.filter((r) => r.source === s);
	const lic = {};
	for (const c of Object.values(commons)) lic[c.license] = (lic[c.license] ?? 0) + 1;
	console.log(`shipped pictures: ${rows.length}`);
	for (const s of ['commons', 'ai', 'own', 'unknown']) console.log(`  ${s.padEnd(8)} ${by(s).length}`);
	console.log('commons licences:', lic);
	const unknown = by('unknown');
	if (unknown.length) {
		const folders = {};
		for (const r of unknown) {
			const d = r.file.split('/').slice(0, -1).join('/');
			(folders[d] ??= []).push(r.id);
		}
		console.log('\nUNKNOWN by folder:');
		for (const [d, ids] of Object.entries(folders)) console.log(`  ${d} (${ids.length}): ${ids.slice(0, 8).join(', ')}${ids.length > 8 ? ' …' : ''}`);
	}
	const problems = creditProblems(commons);
	console.log(`\ncredit problems: ${problems.length}`);
	for (const p of problems.slice(0, 20)) console.log('  ' + p);
	if (process.argv.includes('--json')) {
		mkdirSync(new URL('docs/rights/', root), { recursive: true });
		writeFileSync(new URL('docs/rights/images.json', root), JSON.stringify(rows, null, 1));
		console.log('\nwrote docs/rights/images.json');
	}
}
