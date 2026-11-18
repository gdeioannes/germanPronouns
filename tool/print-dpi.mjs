#!/usr/bin/env node
// Print quality: every picture in a printed book, at the size it is printed,
// with the resolution it actually gets there (pixels per inch). KDP asks for
// 300 dpi; below 200 a picture looks soft or pixelated on paper.
//
//   node tool/print-dpi.mjs A1.1 [--print]      one level
//   node tool/print-dpi.mjs all  [--print]      all twelve
// --print measures the KDP interior (the full-size photo originals, ?hd);
// without it, the free download edition (the 1400 px web copies).
// Needs the dev server (--url, default http://localhost:5173). Writes
// docs/rights/print-dpi-<edition>.json and prints the worst pictures.
import { existsSync, mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import puppeteer from 'puppeteer-core';

const args = process.argv.slice(2);
const flag = (n, d) => (args.includes(n) ? args[args.indexOf(n) + 1] : d);
const base = flag('--url', 'http://localhost:5173');
const print = args.includes('--print');
const ALL = ['A1.1', 'A1.2', 'A2.1', 'A2.2', 'B1.1', 'B1.2', 'B2.1', 'B2.2', 'C1.1', 'C1.2', 'C2.1', 'C2.2'];
const levels = args.includes('all') ? ALL : ALL.filter((l) => args.includes(l));
const chrome = [process.env.CHROME_PATH, 'C:/Program Files/Google/Chrome/Application/chrome.exe', 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe', '/usr/bin/google-chrome'].find((p) => p && existsSync(p));

const browser = await puppeteer.launch({ executablePath: chrome, headless: true });
const page = await browser.newPage();
await page.setViewport({ width: 1400, height: 1000 });
const out = [];
for (const level of levels) {
	await page.goto(`${base}/course/de_cert_a1/book2/${level}${print ? '?hd' : ''}`, { waitUntil: 'load', timeout: 180_000 });
	await page.waitForFunction(() => document.documentElement.dataset.bookFit === 'done', { timeout: 300_000 });
	// Every picture must be decoded before its natural size is known.
	await page.evaluate(async () => {
		await Promise.all([...document.images].map((i) => (i.complete ? null : new Promise((r) => { i.onload = i.onerror = r; }))));
	});
	const rows = await page.evaluate(() => {
		const pages = [...document.querySelectorAll('section.page')];
		const res = [];
		pages.forEach((sec, pi) => {
			// A4 page width in CSS px tells how many CSS px make one printed millimetre.
			const pxPerMm = sec.getBoundingClientRect().width / 210;
			for (const img of sec.querySelectorAll('img')) {
				const r = img.getBoundingClientRect();
				if (!img.naturalWidth || r.width < 2 || r.height < 2) continue;
				const fit = getComputedStyle(img).objectFit;
				const sx = r.width / img.naturalWidth;
				const sy = r.height / img.naturalHeight;
				// The scale the picture is drawn at: cover crops (bigger scale), contain fits (smaller).
				const scale = fit === 'cover' ? Math.max(sx, sy) : fit === 'contain' || fit === 'scale-down' ? Math.min(sx, sy) : Math.max(sx, sy);
				const mmPerSrcPx = scale / pxPerMm;
				const dpi = 25.4 / mmPerSrcPx;
				res.push({ page: pi + 1, src: img.getAttribute('src'), widthMm: Math.round(r.width / pxPerMm), dpi: Math.round(dpi) });
			}
		});
		return res;
	});
	for (const r of rows) out.push({ level, ...r });
	const low = rows.filter((r) => r.dpi < 300);
	console.log(`${level}: ${rows.length} pictures, ${low.length} under 300 dpi, ${rows.filter((r) => r.dpi < 200).length} under 200`);
}
await browser.close();
mkdirSync('docs/rights', { recursive: true });
const file = `docs/rights/print-dpi-${print ? 'kdp' : 'download'}.json`;
// Keep other levels' results from earlier runs.
const prev = existsSync(file) ? JSON.parse(readFileSync(file, 'utf8')).filter((r) => !levels.includes(r.level)) : [];
writeFileSync(file, JSON.stringify([...prev, ...out], null, 1));
const worst = out.filter((r) => r.dpi < 200).sort((a, b) => a.dpi - b.dpi);
console.log(`\nworst (${worst.length} under 200 dpi):`);
for (const r of worst.slice(0, 25)) console.log(`  ${r.level} p${r.page} ${r.dpi} dpi, ${r.widthMm} mm wide: ${r.src}`);
console.log(`wrote ${file}`);
