// The newsletter card's figures (assets/images/news_manifest.json) stand free
// on the card: this makes the paper around each one transparent and trims it,
// so the figure can rise out of the card's disc (Book2.svelte .news-art).
//
//   node tool/gen-images.mjs --manifest assets/images/news_manifest.json --no-link
//   node tool/cutout-news.mjs        raw PNGs → static/img/news/<id>.webp
//
// The paper is found by a flood fill from the picture's edge, so cream inside
// the figure (a shirt, an envelope) stays.

import { mkdirSync, readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import sharp from 'sharp';

const root = fileURLToPath(new URL('..', import.meta.url));
const ids = JSON.parse(readFileSync(`${root}assets/images/news_manifest.json`, 'utf8')).images.map((i) => i.id);
/** How far a pixel may be from the corner's paper colour and still be paper. */
const NEAR = 38;
mkdirSync(`${root}static/img/news`, { recursive: true });

for (const id of ids) {
	const { data, info } = await sharp(`${root}assets/images/raw/${id}.png`).ensureAlpha().raw().toBuffer({ resolveWithObject: true });
	const { width: w, height: h } = info;
	const paper = [data[0], data[1], data[2]];
	const isPaper = (p) => Math.abs(data[p] - paper[0]) + Math.abs(data[p + 1] - paper[1]) + Math.abs(data[p + 2] - paper[2]) < NEAR;
	const seen = new Uint8Array(w * h);
	const stack = [];
	for (let x = 0; x < w; x++) stack.push(x, x + (h - 1) * w);
	for (let y = 0; y < h; y++) stack.push(y * w, y * w + w - 1);
	while (stack.length) {
		const i = stack.pop();
		if (seen[i] || !isPaper(i * 4)) continue;
		seen[i] = 1;
		data[i * 4 + 3] = 0;
		const x = i % w;
		if (x > 0) stack.push(i - 1);
		if (x < w - 1) stack.push(i + 1);
		if (i >= w) stack.push(i - w);
		if (i < w * (h - 1)) stack.push(i + w);
	}
	const out = `${root}static/img/news/${id}.webp`;
	const cut = await sharp(data, { raw: { width: w, height: h, channels: 4 } }).trim().resize({ width: 640, height: 640, fit: 'inside' }).webp({ quality: 90, alphaQuality: 100 }).toFile(out);
	console.log(`${id}  ${cut.width}×${cut.height}  ${Math.round(cut.size / 1024)} kB`);
}
