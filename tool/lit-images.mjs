#!/usr/bin/env node
// Pictures for the literature poll (content/bookPoll.ts): a public-domain
// illustration, first-edition cover or title page from Wikimedia Commons,
// or (only when none is free beyond doubt) a Gemini picture from
// assets/images/literature_manifest.json.
//
//   node tool/lit-images.mjs search "<query>" --sheet out.png [--n 18]
//       candidates of any size, free licences only, with a numbered sheet.
//   node tool/lit-images.mjs take "<File:…>" <bookId>
//       records the credit as lit_<bookId> (via commons-pick take, so
//       /credits, commons-verify and the rights audit see it) and writes the
//       card picture static/img/lit/lit_<bookId>.webp.
//   node tool/lit-images.mjs ai <bookId>
//       turns assets/images/raw/lit_<bookId>.png (from gen-images) into the card picture.
import { execFileSync } from 'node:child_process';
import { mkdirSync, rmSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { join } from 'node:path';
import sharp from 'sharp';

const root = fileURLToPath(new URL('..', import.meta.url));
const UA = 'LanguageQuizBooks/1.0 (https://languagequiz.org; literature pictures)';
/** The frame colour, also the card art band in BookPoll.svelte. */
const PAPER = '#f4efe6';
const OK = /^(Public domain|CC0|CC BY(?:-SA)? \d(?:\.\d)?)$/i;
const [cmd, ...rest] = process.argv.slice(2);
const flag = (n, d) => (rest.includes(n) ? rest[rest.indexOf(n) + 1] : d);
const pos = rest.filter((a, i) => !a.startsWith('--') && !(i > 0 && rest[i - 1].startsWith('--')));
const strip = (h) => (h ?? '').replace(/<[^>]+>/g, '').replace(/\s+/g, ' ').trim();

async function api(params) {
	for (let t = 0; t < 6; t++) {
		const res = await fetch(`https://commons.wikimedia.org/w/api.php?${new URLSearchParams({ format: 'json', ...params })}`, { headers: { 'user-agent': UA } });
		if (res.ok) return res.json();
		await new Promise((r) => setTimeout(r, 4000 * (t + 1)));
	}
	throw new Error('Commons API kept failing');
}

/** The card picture: the whole image in a 4:5 frame (480×600) on paper tone, since sources mix tall title pages and wide illustrations. */
async function card(buf, id, paper = PAPER) {
	const dir = join(root, 'static', 'img', 'lit');
	mkdirSync(dir, { recursive: true });
	await sharp(buf).rotate().flatten({ background: paper }).resize(480, 600, { fit: 'contain', background: paper }).webp({ quality: 80 }).toFile(join(dir, `lit_${id}.webp`));
}

if (cmd === 'search') {
	const json = await api({ action: 'query', generator: 'search', gsrsearch: `${pos[0]} filetype:bitmap`, gsrnamespace: 6, gsrlimit: Number(flag('--n', 18)), prop: 'imageinfo', iiprop: 'url|extmetadata|size', iiurlwidth: 300 });
	const c = Object.values(json.query?.pages ?? {})
		.sort((a, b) => a.index - b.index)
		.map((p) => {
			const ii = p.imageinfo?.[0];
			const m = ii?.extmetadata ?? {};
			return { title: p.title, lic: m.LicenseShortName?.value ?? '?', author: strip(m.Artist?.value).slice(0, 50), date: strip(m.DateTimeOriginal?.value).slice(0, 20), w: ii?.width, h: ii?.height, thumb: ii?.thumburl };
		})
		.filter((x) => x.thumb && OK.test(x.lic));
	c.forEach((x, i) => console.log(`${String(i).padStart(2)} ${x.lic.padEnd(13)} ${x.w}x${x.h} ${x.title} | ${x.author} | ${x.date}`));
	const out = flag('--sheet');
	if (out && c.length) {
		const T = 220, COLS = 6;
		const tiles = [];
		for (const [i, x] of c.entries()) {
			const res = await fetch(x.thumb, { headers: { 'user-agent': UA } });
			const img = await sharp(Buffer.from(await res.arrayBuffer())).resize(T, T, { fit: 'contain', background: '#eee' }).png().toBuffer();
			const label = Buffer.from(`<svg width="${T}" height="${T}"><rect x="4" y="4" width="34" height="22" rx="4" fill="#1f3a5f"/><text x="21" y="20" font-size="15" font-family="sans-serif" font-weight="700" fill="#fff" text-anchor="middle">${i}</text></svg>`);
			tiles.push({ input: await sharp(img).composite([{ input: label }]).png().toBuffer(), left: (i % COLS) * T, top: Math.floor(i / COLS) * T });
		}
		await sharp({ create: { width: COLS * T, height: Math.ceil(c.length / COLS) * T, channels: 3, background: '#fff' } }).composite(tiles).png().toFile(out);
		console.log('sheet:', out);
	}
} else if (cmd === 'take') {
	const [title, id] = pos;
	execFileSync('node', [join(root, 'tool', 'commons-pick.mjs'), 'take', title, `lit_${id}`, 'de_cert_a1', '--width', '1200'], { stdio: 'inherit' });
	const big = join(root, 'static', 'img', 'photo', `lit_${id}.jpg`);
	await card(big, id);
	// The poll shows only the card: the full-size copies would ship for nothing (Pages size limit).
	rmSync(big, { force: true });
	rmSync(join(root, 'static', 'img', 'photo', 'web', `lit_${id}.jpg`), { force: true });
	console.log(`static/img/lit/lit_${id}.webp`);
} else if (cmd === 'ai') {
	// A generated picture brings its own paper: frame it in that colour, not ours.
	const raw = join(root, 'assets', 'images', 'raw', `lit_${pos[0]}.png`);
	const { data } = await sharp(raw).extract({ left: 4, top: 4, width: 8, height: 8 }).removeAlpha().raw().toBuffer({ resolveWithObject: true });
	const avg = [0, 1, 2].map((c) => Math.round(data.filter((_, i) => i % 3 === c).reduce((a, b) => a + b, 0) / 64));
	await card(raw, pos[0], `rgb(${avg.join(',')})`);
	console.log(`static/img/lit/lit_${pos[0]}.webp`);
} else {
	console.error('usage: lit-images.mjs search "<q>" --sheet out.png | take "<File:…>" <bookId> | ai <bookId>');
	process.exit(1);
}
