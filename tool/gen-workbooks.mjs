// Prints each level's workbook (/course/<id>/workbook/<level>) to a PDF in
// static/workbooks/, so the workbook page can offer a plain "Download PDF"
// beside "Print". Run `npm run workbooks` after the content changes; the PDFs
// are committed, like the audio and the pictures, so the build never needs a
// browser.
//
//   npm run workbooks                 every level of every course
//   npm run workbooks -- A1.1 B2.2    just these levels
//   npm run workbooks -- --url http://localhost:5173   use a running server
//
// Chrome draws the PDF from the same page and print stylesheet a learner's
// browser uses, so the file and the Print button can't drift apart. It needs
// a local Chrome or Edge (CHROME_PATH overrides the search).

import { spawn } from 'node:child_process';
import { existsSync, mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import puppeteer from 'puppeteer-core';

const root = fileURLToPath(new URL('..', import.meta.url));
const read = (p) => JSON.parse(readFileSync(new URL(p, import.meta.url), 'utf8'));
const outDir = `${root}static/workbooks/`;
const manifestPath = `${outDir}manifest.json`;

const args = process.argv.slice(2);
const urlFlag = args.indexOf('--url');
const givenUrl = urlFlag >= 0 ? args[urlFlag + 1] : null;
const onlyLevels = args.filter((a, i) => !a.startsWith('--') && !(urlFlag >= 0 && i === urlFlag + 1));

/** Mirrors workbookFile() in src/lib/domain/workbook.ts. */
const fileFor = (courseId, level) => `${courseId}_${level.toLowerCase().replace(/\./g, '_')}.pdf`;

function findChrome() {
	const candidates = [
		process.env.CHROME_PATH,
		'C:/Program Files/Google/Chrome/Application/chrome.exe',
		'C:/Program Files (x86)/Google/Chrome/Application/chrome.exe',
		'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe',
		'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
		'/usr/bin/google-chrome',
		'/usr/bin/chromium',
		'/usr/bin/chromium-browser'
	];
	const found = candidates.find((p) => p && existsSync(p));
	if (!found) throw new Error('No Chrome or Edge found — set CHROME_PATH.');
	return found;
}

/** Starts the dev server on its own port and resolves once it answers. */
async function startServer() {
	const port = 5187;
	const server = spawn(process.execPath, [`${root}node_modules/vite/bin/vite.js`, 'dev', '--port', String(port), '--strictPort'], {
		cwd: root,
		stdio: 'ignore'
	});
	const base = `http://localhost:${port}`;
	for (let i = 0; i < 120; i++) {
		try {
			if ((await fetch(base)).ok) return { base, stop: () => server.kill() };
		} catch {
			// not up yet
		}
		await new Promise((r) => setTimeout(r, 500));
	}
	server.kill();
	throw new Error('The dev server did not start.');
}

/** Waits until the fonts and every picture on the page have loaded. */
async function settled(page) {
	await page.evaluate(async () => {
		await document.fonts.ready;
		await Promise.all(
			[...document.images].map((img) =>
				img.complete
					? null
					: new Promise((r) => {
							img.addEventListener('load', r, { once: true });
							img.addEventListener('error', r, { once: true });
						})
			)
		);
	});
}

async function printLevel(browser, base, courseId, level) {
	// The dev server may reload a page the first time it bundles a route, and
	// a print racing that reload fails — so a failed print is simply retried.
	for (let attempt = 1; ; attempt++) {
		const page = await browser.newPage();
		try {
			await page.goto(`${base}/course/${courseId}/workbook/${level}`, { waitUntil: 'load', timeout: 120_000 });
			await settled(page);
			return await page.pdf({ format: 'A4', printBackground: true, timeout: 300_000 });
		} catch (err) {
			if (attempt >= 4) throw err;
			await new Promise((r) => setTimeout(r, 2000));
		} finally {
			await page.close();
		}
	}
}

const pageCount = (pdf) => (Buffer.from(pdf).toString('latin1').match(/\/Type\s*\/Page[^s]/g) ?? []).length;

const catalog = read('../assets/content/catalog.json');
const manifest = existsSync(manifestPath) ? JSON.parse(readFileSync(manifestPath, 'utf8')) : {};
mkdirSync(outDir, { recursive: true });

const server = givenUrl ? { base: givenUrl.replace(/\/$/, ''), stop: () => {} } : await startServer();
const browser = await puppeteer.launch({ executablePath: findChrome(), headless: true });

try {
	for (const card of catalog.courses) {
		const course = read(`../assets/content/courses/${card.id}.json`);
		const levels = course.nav.groups
			.filter((g) => g.type === 'questChain' && g.level)
			.map((g) => g.level)
			.filter((level) => onlyLevels.length === 0 || onlyLevels.includes(level));

		for (const level of levels) {
			const file = fileFor(card.id, level);
			const pdf = await printLevel(browser, server.base, card.id, level);
			writeFileSync(outDir + file, pdf);
			manifest[file] = { pages: pageCount(pdf), bytes: pdf.length, version: course.version };
			console.log(`${file}  ${manifest[file].pages} pages  ${(pdf.length / 1e6).toFixed(1)} MB`);
		}
	}
} finally {
	await browser.close();
	server.stop();
}

const sorted = Object.fromEntries(Object.entries(manifest).sort(([a], [b]) => a.localeCompare(b)));
writeFileSync(manifestPath, JSON.stringify(sorted, null, '\t') + '\n');
