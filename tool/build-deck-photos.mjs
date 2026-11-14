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

// Night photos that stay gloomy after the grade: lift their shadows too, so
// no card looks dark (GDI: photos must never be gloomy).
const NIGHT = new Set(['b2b11_silvester_opener', 'b2b21_club_opener']);
const lift = (img, photo) => (NIGHT.has(photo) ? img.normalise({ lower: 1, upper: 99.5 }).clahe({ width: 160, height: 160, maxSlope: 3 }).modulate({ brightness: 1.35 }) : img);

mkdirSync(OUT, { recursive: true });
const photos = new Set();
for (const f of readdirSync(BOOKS).filter((f) => /^[abc]\d_\d\.json$/.test(f))) {
	for (const c of JSON.parse(readFileSync(BOOKS + f, 'utf8')).chapters) photos.add(c.opener.photo);
}

// An exercise's own photo: a credit filed under the exercise id
// (node tool/commons-pick.mjs take "<File:…>" <quizId> de_cert_a1). It is also
// cut to the exercise's scene picture, static/img/<quizId>.webp.
const own = new Set(Object.keys(JSON.parse(readFileSync(BOOKS + '_photos.json', 'utf8'))).filter((id) => id.startsWith('quest_')));
for (const id of own) photos.add(id);

let made = 0;
for (const photo of photos) {
	const out = `${OUT}${photo}.webp`;
	if (!force && !NIGHT.has(photo) && existsSync(out)) continue;
	const hd = `${root}static/img/photo/${photo}.jpg`;
	const src = existsSync(hd) ? hd : `${root}static/img/photo/web/${photo}.jpg`;
	let img = sharp(readFileSync(src));
	// Silvester is a black sky over a small lit gate: keep the gate and the low fireworks.
	if (photo === 'b2b11_silvester_opener') {
		const m = await img.metadata();
		img = sharp(await img.extract({ left: Math.round(m.width * 0.12), top: Math.round(m.height * 0.3), width: Math.round(m.width * 0.76), height: Math.round(m.height * 0.62) }).toBuffer());
	}
	await lift(warm(img), photo).resize(1000).webp({ quality: 76 }).toFile(out);
	if (own.has(photo)) {
		await warm(sharp(readFileSync(src))).resize(512, 384, { fit: 'cover' }).webp({ quality: 78 }).toFile(`${root}static/img/${photo}.webp`);
	}
	made++;
}
console.log(`${photos.size} chapter photos, ${made} written to static/img/deck/`);
