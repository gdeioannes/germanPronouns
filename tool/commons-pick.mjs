#!/usr/bin/env node
// Photographs for the books from Wikimedia Commons, free licences only.
//
//   node tool/commons-pick.mjs search "<query>" [--n 24] [--sheet out.png]
//       lists candidates (public domain, CC0, CC BY, CC BY-SA) with their
//       licence, size and author, numbered, and draws a contact sheet of
//       their thumbnails so a person can pick by number.
//
//   node tool/commons-pick.mjs take "<File:… .jpg>" <id> <book> [--width 2400]
//       downloads the original sized to --width (print needs ~300 dpi at the
//       printed width), writes static/img/photo/<id>.jpg, and records title,
//       author, licence and source in assets/content/book2/<book>/_photos.json
//       so the credits page can print them.
//
// Commons asks for a descriptive User-Agent; nothing else is needed.

import { existsSync, mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { join } from 'node:path';
import sharp from 'sharp';

const root = fileURLToPath(new URL('..', import.meta.url));
const UA = 'LanguageQuizBooks/1.0 (https://languagequiz.org; book pictures)';
const OK_LICENCES = /^(Public domain|CC0|CC BY(?:-SA)? \d(?:\.\d)?)$/i;
const API = 'https://commons.wikimedia.org/w/api.php';

const [cmd, ...rest] = process.argv.slice(2);
const flag = (name, dflt) => {
	const i = rest.indexOf(name);
	return i >= 0 ? rest[i + 1] : dflt;
};
const positional = rest.filter((a, i) => !a.startsWith('--') && !(i > 0 && rest[i - 1].startsWith('--')));

async function api(params) {
	const url = `${API}?${new URLSearchParams({ format: 'json', ...params })}`;
	const res = await fetch(url, { headers: { 'user-agent': UA } });
	if (!res.ok) throw new Error(`${res.status} ${url}`);
	return res.json();
}

const strip = (html) => (html ?? '').replace(/<[^>]+>/g, '').trim();

async function search(query, n) {
	const json = await api({
		action: 'query',
		generator: 'search',
		gsrsearch: `${query} filetype:bitmap`,
		gsrnamespace: 6,
		gsrlimit: n,
		prop: 'imageinfo',
		iiprop: 'url|extmetadata|size',
		iiurlwidth: 360
	});
	const pages = Object.values(json.query?.pages ?? {});
	return pages
		.map((p) => {
			const ii = p.imageinfo?.[0];
			const m = ii?.extmetadata ?? {};
			return {
				title: p.title,
				licence: m.LicenseShortName?.value ?? '?',
				author: strip(m.Artist?.value).slice(0, 60),
				width: ii?.width,
				height: ii?.height,
				thumb: ii?.thumburl,
				url: ii?.url,
				page: ii?.descriptionurl
			};
		})
		.filter((c) => c.thumb && OK_LICENCES.test(c.licence) && c.width >= 1600);
}

async function sheet(cands, out) {
	const T = 240;
	const COLS = 6;
	const tiles = await Promise.all(
		cands.map(async (c, i) => {
			const res = await fetch(c.thumb, { headers: { 'user-agent': UA } });
			const buf = Buffer.from(await res.arrayBuffer());
			const img = await sharp(buf).resize(T, T, { fit: 'cover' }).png().toBuffer();
			const label = Buffer.from(
				`<svg width="${T}" height="${T}"><rect x="4" y="4" width="36" height="22" rx="4" fill="#1f3a5f"/><text x="22" y="20" font-size="15" font-family="sans-serif" font-weight="700" fill="#fff" text-anchor="middle">${i}</text></svg>`
			);
			return { input: await sharp(img).composite([{ input: label }]).png().toBuffer(), left: (i % COLS) * T, top: Math.floor(i / COLS) * T };
		})
	);
	const rows = Math.ceil(cands.length / COLS);
	await sharp({ create: { width: COLS * T, height: Math.max(1, rows) * T, channels: 3, background: '#fff' } })
		.composite(tiles)
		.png()
		.toFile(out);
}

async function take(title, id, book, width) {
	const json = await api({ action: 'query', titles: title, prop: 'imageinfo', iiprop: 'url|extmetadata|size', iiurlwidth: width });
	const p = Object.values(json.query.pages)[0];
	const ii = p.imageinfo[0];
	const m = ii.extmetadata;
	const licence = m.LicenseShortName?.value ?? '?';
	if (!OK_LICENCES.test(licence)) throw new Error(`${title}: licence ${licence} is not free enough`);
	const res = await fetch(ii.thumburl ?? ii.url, { headers: { 'user-agent': UA } });
	if (!res.ok) throw new Error(`${res.status} downloading ${title}`);
	const buf = Buffer.from(await res.arrayBuffer());
	const dir = join(root, 'static', 'img', 'photo');
	mkdirSync(dir, { recursive: true });
	const file = join(dir, `${id}.jpg`);
	const info = await sharp(buf).rotate().jpeg({ quality: 88, mozjpeg: true }).toFile(file);
	// The web copy the site and the download edition use; the original above is for print only (gitignored).
	mkdirSync(join(dir, 'web'), { recursive: true });
	await sharp(buf).rotate().resize({ width: 1400, height: 1400, fit: 'inside', withoutEnlargement: true }).jpeg({ quality: 74, mozjpeg: true }).toFile(join(dir, 'web', `${id}.jpg`));
	const credits = join(root, 'assets', 'content', 'book2', book, '_photos.json');
	mkdirSync(join(root, 'assets', 'content', 'book2', book), { recursive: true });
	const all = existsSync(credits) ? JSON.parse(readFileSync(credits, 'utf8')) : {};
	all[id] = {
		title: title.replace(/^File:/, ''),
		author: strip(m.Artist?.value) || 'unknown',
		license: licence,
		source: ii.descriptionurl,
		width: info.width,
		height: info.height
	};
	writeFileSync(credits, JSON.stringify(all, null, '\t') + '\n');
	console.log(`${id}: ${info.width}×${info.height} ${licence} — ${all[id].author}`);
}

if (cmd === 'search') {
	const cands = await search(positional[0], Number(flag('--n', 24)));
	cands.forEach((c, i) => console.log(`${String(i).padStart(2)}  ${c.licence.padEnd(12)} ${c.width}×${c.height}  ${c.title}  — ${c.author}`));
	const out = flag('--sheet', null);
	if (out && cands.length) {
		await sheet(cands, out);
		console.log(`sheet: ${out}`);
	}
} else if (cmd === 'take') {
	await take(positional[0], positional[1], positional[2], Number(flag('--width', 2400)));
} else {
	console.error('usage: commons-pick.mjs search "<query>" [--n 24] [--sheet out.png] | take "<File:…>" <id> <book>');
	process.exit(1);
}
