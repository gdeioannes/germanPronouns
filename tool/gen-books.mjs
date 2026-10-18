// Prints the books for print on demand: one interior PDF per level
// (/course/<id>/book/<A1…C2>) from the same page a learner can read on the
// site, with the paper changed for the press — the 1024 px picture originals
// in place of the 512 px web pictures, and nothing else.
//
//   npm run books                      every book
//   npm run books -- A1 B2             just these
//   npm run books -- --url http://localhost:5173   use a running server
//   npm run books -- --proof           also render every page to PNG under
//                                      static/books/proof/<book>/ for checking
//
// Before printing it mints the QR codes the pages need into
// assets/content/booklinks.json (a code is never removed; see
// src/lib/domain/booklinks.ts), so a printed code and the site agree.
//
// Needs a local Chrome or Edge (CHROME_PATH overrides the search).

import { spawn } from 'node:child_process';
import { existsSync, mkdirSync, readFileSync, readdirSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { join } from 'node:path';
import puppeteer from 'puppeteer-core';
import sharp from 'sharp';

const root = fileURLToPath(new URL('..', import.meta.url));
const read = (p) => JSON.parse(readFileSync(join(root, p), 'utf8'));
const outDir = join(root, 'static', 'books');
const hdDir = join(root, 'static', 'img', 'hd');
const manifestPath = join(outDir, 'manifest.json');
const registryPath = join(root, 'assets', 'content', 'booklinks.json');

const args = process.argv.slice(2);
const urlFlag = args.indexOf('--url');
const givenUrl = urlFlag >= 0 ? args[urlFlag + 1] : null;
const proof = args.includes('--proof');
const coverOnly = args.includes('--cover-only');
const only = args.filter((a, i) => !a.startsWith('--') && !(urlFlag >= 0 && i === urlFlag + 1));
const BOOKS = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

function findChrome() {
	const candidates = [
		process.env.CHROME_PATH,
		'C:/Program Files/Google/Chrome/Application/chrome.exe',
		'C:/Program Files (x86)/Google/Chrome/Application/chrome.exe',
		'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe',
		'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
		'/usr/bin/google-chrome',
		'/usr/bin/chromium'
	];
	const found = candidates.find((p) => p && existsSync(p));
	if (!found) throw new Error('No Chrome or Edge found — set CHROME_PATH.');
	return found;
}

async function startServer() {
	const port = 5188;
	const server = spawn(process.execPath, [join(root, 'node_modules/vite/bin/vite.js'), 'dev', '--port', String(port), '--strictPort'], {
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

/**
 * The press pictures: every picture whose 1024 px original is on disk, as a
 * lossless WebP under static/img/hd/ (gitignored). The page keeps asking for
 * /img/<id>.webp; the print run answers from here instead.
 */
async function prepareHd() {
	const rawDir = join(root, 'assets', 'images', 'raw');
	mkdirSync(hdDir, { recursive: true });
	if (!existsSync(rawDir)) return 0;
	let made = 0;
	for (const name of readdirSync(rawDir)) {
		if (!name.endsWith('.png')) continue;
		const id = name.slice(0, -4);
		const out = join(hdDir, `${id}.webp`);
		if (existsSync(out)) continue;
		await sharp(join(rawDir, name)).webp({ quality: 94, effort: 4 }).toFile(out);
		made++;
	}
	return made;
}

/**
 * The chapter photographs at the page's own ratio (186 × 78 mm), cropped once
 * here and committed under static/img/photo/wide/, so the page shows them
 * without object-fit: a cropped-by-CSS image still carries its full object
 * into the PDF, past the page edge, and KDP's checker flags it.
 */
async function prepareWide() {
	const photoDir = join(root, 'static', 'img', 'photo');
	const wideDir = join(photoDir, 'wide');
	mkdirSync(wideDir, { recursive: true });
	let made = 0;
	for (const name of readdirSync(photoDir)) {
		if (!name.endsWith('.jpg')) continue;
		const out = join(wideDir, name);
		if (existsSync(out)) continue;
		await sharp(join(photoDir, name)).resize({ width: 1600, height: 671, fit: 'cover', position: 'attention' }).jpeg({ quality: 86 }).toFile(out);
		made++;
	}
	return made;
}

/** Waits for the fonts and every picture — lazy ones made eager first — with a cap, so a lost picture cannot hang the run. */
async function settled(page) {
	await page.evaluate(async () => {
		await document.fonts.ready;
		for (const img of document.images) img.loading = 'eager';
		const cap = new Promise((r) => setTimeout(r, 180_000));
		await Promise.race([cap, Promise.all(
			[...document.images].map((img) =>
				img.complete
					? null
					: new Promise((r) => {
							img.addEventListener('load', r, { once: true });
							img.addEventListener('error', r, { once: true });
						})
			)
		)]);
	});
}

async function printBook(browser, base, courseId, bookId) {
	for (let attempt = 1; ; attempt++) {
		const page = await browser.newPage();
		try {
			await page.goto(`${base}/course/${courseId}/book/${bookId}`, { waitUntil: 'load', timeout: 300_000 });
			// Swap in the press pictures: static/img/hd/<id>.webp for every picture that has one.
			if (attempt < 3) {
				const ids = existsSync(hdDir) ? readdirSync(hdDir).filter((n) => n.endsWith('.webp')).map((n) => n.slice(0, -5)) : [];
				await page.evaluate((hd) => {
					const has = new Set(hd);
					for (const img of document.images) {
						const m = /\/img\/([a-z0-9_-]+)\.webp$/i.exec(img.getAttribute('src') ?? '');
						img.loading = 'eager';
						if (m && has.has(m[1])) img.src = `/img/hd/${m[1]}.webp`;
					}
				}, ids);
			}
			await settled(page);
			return await page.pdf({ format: 'Letter', printBackground: true, timeout: 1_200_000 });
		} catch (err) {
			console.log(`  attempt ${attempt} failed: ${String(err).split('\n')[0]}`);
			if (attempt >= 4) throw err;
			await new Promise((r) => setTimeout(r, 2000));
		} finally {
			await page.close();
		}
	}
}

/**
 * The cover: Chrome will not print a sheet wider than it is tall, so the
 * cover page is photographed at 300 dpi and wrapped as a one-page PDF of the
 * exact sheet size by PyMuPDF (python, already used for the proofs).
 */
async function printCover(browser, base, courseId, bookId, spec) {
	const page = await browser.newPage();
	try {
		const cssPx = (mm) => Math.round((mm / 25.4) * 96);
		await page.setViewport({ width: cssPx(spec.widthMm), height: cssPx(spec.heightMm), deviceScaleFactor: 300 / 96 });
		await page.goto(`${base}/course/${courseId}/book/${bookId}/cover`, { waitUntil: 'load', timeout: 120_000 });
		await page.evaluate(async () => {
			await document.fonts.ready;
			const cap = new Promise((r) => setTimeout(r, 20_000));
			await Promise.race([cap, Promise.all([...document.images].map((img) => (img.complete ? null : new Promise((r) => { img.addEventListener('load', r, { once: true }); img.addEventListener('error', r, { once: true }); }))))]);
		});
		const png = join(outDir, `${courseId}_${bookId.toLowerCase()}_cover.jpg`);
		const el = await page.$('.wrap');
		await el.screenshot({ path: png, type: 'jpeg', quality: 92 });
		const pdf = png.replace(/.jpg$/, '.pdf');
		const wrap = [
			'import fitz,sys',
			'w,h=float(sys.argv[3]),float(sys.argv[4])',
			'd=fitz.open()',
			'p=d.new_page(width=w/25.4*72,height=h/25.4*72)',
			'p.insert_image(p.rect,filename=sys.argv[1])',
			'd.save(sys.argv[2])'
		].join('\n');
		const py = spawn('python', ['-c', wrap, png, pdf, String(spec.widthMm), String(spec.heightMm)], { stdio: 'inherit' });
		await new Promise((r) => py.on('exit', r));
		return readFileSync(pdf);
	} finally {
		await page.close();
	}
}

const pageCount = (pdf) => (Buffer.from(pdf).toString('latin1').match(/\/Type\s*\/Page[^s]/g) ?? []).length;

/** KDP: spine = pages × 0.002252 in on white paper (colour books print on white); bleed 0.125 in on the outside edges. */
function coverSpec(pages) {
	const spineIn = pages * 0.002252;
	// US Letter trim (8.5 × 11 in): the one full-size trim KDP sells in premium colour with expanded distribution.
	return { spineMm: +(spineIn * 25.4).toFixed(2), widthMm: +((8.5 * 2 + spineIn + 0.25) * 25.4).toFixed(2), heightMm: +((11 + 0.25) * 25.4).toFixed(2) };
}

const catalog = read('assets/content/catalog.json');
const manifest = existsSync(manifestPath) ? JSON.parse(readFileSync(manifestPath, 'utf8')) : {};
mkdirSync(outDir, { recursive: true });

const hd = await prepareHd();
console.log(`${hd} press pictures prepared in static/img/hd/`);
console.log(`${await prepareWide()} wide photographs prepared in static/img/photo/wide/`);

const server = givenUrl ? { base: givenUrl.replace(/\/$/, ''), stop: () => {} } : await startServer();
const browser = await puppeteer.launch({ executablePath: findChrome(), headless: true, protocolTimeout: 1_800_000 });

try {
	for (const card of catalog.courses) {
		const course = read(`assets/content/courses/${card.id}.json`);
		for (const bookId of BOOKS.filter((b) => only.length === 0 || only.includes(b))) {
			const hasLevel = course.quizzes.some((q) => q.level === `${bookId}.1`);
			if (!hasLevel) continue;
			const file = `${card.id}_${bookId.toLowerCase()}.pdf`;
			if (!coverOnly) {
				const pdf = await printBook(browser, server.base, card.id, bookId);
				writeFileSync(join(outDir, file), pdf);
				const pages = pageCount(pdf);
				manifest[file] = { pages, bytes: pdf.length, version: course.version, cover: coverSpec(pages) };
				console.log(`${file}  ${pages} pages  ${(pdf.length / 1e6).toFixed(1)} MB  spine ${manifest[file].cover.spineMm} mm`);
			}
			if (!manifest[file]) continue;
			// The cover reads the page count from the manifest, so write it now;
			// the sheet size is recomputed so a changed spine rule reaches a
			// --cover-only run too.
			manifest[file].cover = coverSpec(manifest[file].pages);
			writeFileSync(manifestPath, JSON.stringify(manifest, null, '\t') + '\n');
			const coverFile = file.replace(/\.pdf$/, '_cover.pdf');
			try {
				const cover = await printCover(browser, server.base, card.id, bookId, manifest[file].cover);
				writeFileSync(join(outDir, coverFile), cover);
				console.log(`${coverFile}  ${manifest[file].cover.widthMm} × ${manifest[file].cover.heightMm} mm`);
			} catch (err) {
				// A cover open in a viewer locks its file on Windows; the interior and the proofs still matter.
				console.log(`  cover not written (${String(err).split('\n')[0]}); close the file and run with --cover-only`);
			}
			if (proof && !coverOnly) {
				const dir = join(outDir, 'proof', bookId);
				mkdirSync(dir, { recursive: true });
				const py = spawn('python', ['-c', `import fitz,sys\nd=fitz.open(sys.argv[1])\nfor i,p in enumerate(d):\n  p.get_pixmap(dpi=60).save(sys.argv[2]+'/p%03d.png'%(i+1))\nprint(d.page_count)`, join(outDir, file), dir], { stdio: 'inherit' });
				await new Promise((r) => py.on('exit', r));
			}
		}
	}
} finally {
	await browser.close();
	server.stop();
}

// The codes the pages minted while rendering live in the server's memory;
// mint the same ones here, in the same order, and write the registry.
{
	const registry = JSON.parse(readFileSync(registryPath, 'utf8'));
	const mint = (kind, target, book, note) => {
		if (registry.links.some((l) => l.kind === kind && l.target === target)) return;
		const prefix = book.toLowerCase();
		const used = registry.links.filter((l) => l.code.startsWith(prefix + '-')).length;
		registry.links.push({ code: `${prefix}-${String(used + 1).padStart(2, '0')}`, kind, target, note, since: new Date().toISOString().slice(0, 10) });
	};
	const clips = new Set();
	const mdir = join(root, 'static', 'audio', 'manifest');
	if (existsSync(mdir))
		for (const n of readdirSync(mdir))
			if (n.endsWith('.json')) for (const files of Object.values(JSON.parse(readFileSync(join(mdir, n), 'utf8')))) for (const t of Object.keys(files)) clips.add(t);
	for (const card of catalog.courses) {
		const course = read(`assets/content/courses/${card.id}.json`);
		for (const bookId of BOOKS.filter((b) => only.length === 0 || only.includes(b))) {
			if (!course.quizzes.some((q) => q.level === `${bookId}.1`)) continue;
			mint('book', bookId, bookId, `Book ${bookId}`);
			for (const level of [`${bookId}.1`, `${bookId}.2`]) {
				for (const q of course.quizzes.filter((q) => q.level === level && q.status !== 'placeholder')) {
					mint('quiz', q.id, bookId, `${bookId} ${q.title}`);
					const audible = ['listening', 'dictation', 'speakRepeat', 'suchbild'].includes(q.type) || (q.type === 'reading' && !('inlineBlanks' in q));
					if (audible) mint('audio', q.id, bookId, `${bookId} ${q.title} audio`);
				}
			}
		}
	}
	writeFileSync(registryPath, JSON.stringify(registry, null, '\t') + '\n');
	console.log(`${registry.links.length} permanent codes in the registry`);
}

const sorted = Object.fromEntries(Object.entries(manifest).sort(([a], [b]) => a.localeCompare(b)));
writeFileSync(manifestPath, JSON.stringify(sorted, null, '\t') + '\n');
