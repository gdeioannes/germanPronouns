#!/usr/bin/env node
// The deck's card photos: every Book v2 chapter's opener photo, warm-graded
// (never gloomy) and cut to the card's size, into static/img/deck/<photo>.webp.
// Graded from the print originals in static/img/photo/ (gitignored, local);
// a photo with no original there falls back to its committed web copy.
// src/lib/server/deckPhotos.ts maps each exercise to one of these.
//
//   node tool/build-deck-photos.mjs           only the missing ones
//   node tool/build-deck-photos.mjs --force   all of them again
//
// Before a new photo goes in: check it zoomed in for banned symbols (§86a).
import { existsSync, mkdirSync, readdirSync, readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import sharp from 'sharp';

sharp.cache(false);
const root = fileURLToPath(new URL('..', import.meta.url));
const BOOKS = `${root}assets/content/book2/de_cert_a1/`;
const OUT = `${root}static/img/deck/`;
const force = process.argv.includes('--force');

const warm = (img) =>
	img.recomb([[1.05, 0.02, 0], [0, 1.03, 0], [0, 0, 0.95]]).linear(1.2, -8).modulate({ brightness: 1.04, saturation: 1.25 });

mkdirSync(OUT, { recursive: true });
const photos = new Set();
for (const f of readdirSync(BOOKS).filter((f) => /^[abc]\d_\d\.json$/.test(f))) {
	for (const c of JSON.parse(readFileSync(BOOKS + f, 'utf8')).chapters) photos.add(c.opener.photo);
}

let made = 0;
for (const photo of photos) {
	const out = `${OUT}${photo}.webp`;
	if (!force && existsSync(out)) continue;
	const hd = `${root}static/img/photo/${photo}.jpg`;
	const src = existsSync(hd) ? hd : `${root}static/img/photo/web/${photo}.jpg`;
	await warm(sharp(readFileSync(src))).resize(1000).webp({ quality: 76 }).toFile(out);
	made++;
}
console.log(`${photos.size} chapter photos, ${made} written to static/img/deck/`);
