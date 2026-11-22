// The grammar charts book: one PDF of A4 landscape wall charts.
//
//   npm run charts            build the PDF, the page previews and the web manifest
//
// Each chart is one self-contained HTML file in tool/charts/src (its own CSS,
// some build their body with a small script). This tool opens each one in a
// local Chrome, keeps only its `.sheet`, swaps the placeholder QR for a real
// one that leads to the book's page on the site, prints it as one A4 landscape
// page, and joins everything behind a cover and a "how to read a chart" page.
//
// Out:
//   static/books/charts/german-grammar-charts.pdf   the book
//   static/img/charts/NN.webp, cover.webp           previews for the web page
//   src/lib/content/charts.json                      titles + page count + size, read by the site
//
// Needs a local Chrome or Edge (CHROME_PATH overrides the search) and network
// access for the two web fonts the charts load.

import { existsSync, mkdirSync, readFileSync, statSync, writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';
import puppeteer from 'puppeteer-core';
import { PDFDocument } from 'pdf-lib';
import QRCode from 'qrcode';
import sharp from 'sharp';
import { CHART_QUIZZES } from './charts/quizzes.mjs';

const root = join(dirname(fileURLToPath(import.meta.url)), '..');
const SRC = join(root, 'tool', 'charts', 'src');
const TMP = join(root, 'tool', 'charts', '.tmp');
const PDF_OUT = join(root, 'static', 'books', 'charts', 'german-grammar-charts.pdf');
const IMG_OUT = join(root, 'static', 'img', 'charts');
const MANIFEST_OUT = join(root, 'src', 'lib', 'content', 'charts.json');
const PAGE_URL = 'https://languagequiz.org/charts';
const config = JSON.parse(readFileSync(join(root, 'tool', 'charts', 'charts.json'), 'utf8'));
// The order in charts.json is the order in the book. A chart file keeps the number it was
// written with (its file name); RENUMBER maps that to its place in the book, and every
// "Chart N" printed on a sheet (its own label and cross-references) is rewritten with it.
config.charts.forEach((c, i) => (c.n = i + 1));
// Each chart has a stable address, /charts/<slug> (its file name without the number), so a
// printed QR code keeps working when the book order changes. Its page lists the app quizzes
// from tool/charts/quizzes.mjs; every id must exist in the course.
const courseQuizIds = new Set(JSON.parse(readFileSync(join(root, 'assets', 'content', 'courses', 'de_cert_a1.json'), 'utf8')).quizzes.map((q) => q.id));
for (const c of config.charts) {
	c.slug = c.file.replace(/^\d+-/, '');
	c.quizzes = (CHART_QUIZZES[c.file] ?? []).map(([quiz, part, note]) => ({ quiz, for: part, note }));
	if (!c.quizzes.length) throw new Error(c.file + ': no app quizzes in tool/charts/quizzes.mjs');
	for (const q of c.quizzes) if (!courseQuizIds.has(q.quiz)) throw new Error(c.file + ': unknown quiz ' + q.quiz);
}
// Who publishes the book: the same source as the site's imprint and the course books'
// (src/lib/operator.ts). Until a real street address is filled in there, the imprint
// prints without one and the build says so.
const operatorSrc = readFileSync(join(root, 'src', 'lib', 'operator.ts'), 'utf8');
const op = (key) => new RegExp(key + ": '([^']*)'").exec(operatorSrc)?.[1] ?? '';
const OPERATOR = { name: op('name'), street: op('street'), city: op('city'), country: op('country'), email: op('email') };
const HAS_ADDRESS = !!OPERATOR.street && !OPERATOR.street.startsWith('[') && !OPERATOR.city.startsWith('[');
if (!HAS_ADDRESS) console.warn('NOTE: no street address in src/lib/operator.ts — the imprint is printed without it.');
const YEAR = new Date().getFullYear();
/** The line down the right edge of every chart: a page cut out and hung up still says whose it is. */
const EDGE_LINE = `© ${YEAR} Language Quiz · languagequiz.org · ${config.edition.split(' · ')[0]}: may contain mistakes · For personal and classroom use only. Not for sale or redistribution.`;
const RENUMBER = Object.fromEntries(config.charts.map((c) => [parseInt(c.file, 10), c.n]));

function findChrome() {
	const found = [
		process.env.CHROME_PATH,
		'C:/Program Files/Google/Chrome/Application/chrome.exe',
		'C:/Program Files (x86)/Google/Chrome/Application/chrome.exe',
		'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe',
		'/usr/bin/google-chrome',
		'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
	].find((p) => p && existsSync(p));
	if (!found) throw new Error('No Chrome or Edge found — set CHROME_PATH.');
	return found;
}

const FONTS =
	'<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Source+Serif+4:ital,opsz,wght@0,8..60,400;0,8..60,600;0,8..60,700;1,8..60,400&display=swap">';
const LOGO =
	'<svg viewBox="0 0 68 68" aria-hidden="true"><rect width="68" height="68" rx="15" fill="#fbf8f3"/><g transform="translate(2 2)"><circle cx="32" cy="32" r="23.5" fill="none" stroke="#1f3a5f" stroke-width="9"/><path d="M37.5 37.5L54 54" stroke="#c9683b" stroke-width="8"/></g></svg>';

/** Print styles shared by every page: one A4 landscape sheet, nothing around it. */
const PRINT_CSS = `
@page { size: 297mm 210mm; margin: 0 }
html, body { margin: 0 !important; padding: 0 !important; background: #fff !important }
.sheet { width: 297mm !important; height: 210mm !important; min-width: 0 !important; aspect-ratio: auto !important; box-shadow: none !important; container-type: inline-size; overflow: hidden }
/* The address sits above the QR code, right-aligned: it may be wider than the code and then runs to the left, over the empty top of the header, instead of pushing the code off the sheet. */
.sheet .qr { flex-direction: column-reverse !important; align-items: flex-end !important; width: 4.3cqw; overflow: visible }
.sheet .qr .qurl { white-space: nowrap; font-size: .84cqw; line-height: 1.2 }
.sheet .qr .qurl b { font-weight: 800; color: #a24c26; text-transform: uppercase; letter-spacing: .05em; font-size: .74cqw; margin-right: .5cqw }
.sheet { position: relative }
.sheet .edge { position: absolute; right: 1.05cqw; top: 50%; transform: translateY(-50%); writing-mode: vertical-rl; white-space: nowrap; font-family: 'Inter', ui-sans-serif, system-ui, sans-serif; font-size: .62cqw; font-weight: 600; letter-spacing: .04em; color: #6e6458 }
.sheet .lvl { display: inline-block; margin-left: 1.2cqw; padding: .18cqw .7cqw .16cqw; border-radius: .4cqw; background: #a24c26; color: #fff; font-family: 'Inter', ui-sans-serif, system-ui, sans-serif; font-size: 1.05cqw; font-weight: 800; letter-spacing: .06em; text-transform: uppercase; line-height: 1.2 }
`;

const BASE = `
:root { --ink: #111; --muted: #45413b; --navy: #1f3a5f; --navy-soft: #e8edf4; --terra: #a24c26; --hi: #ffe14d; --dat: #5b3aa8; --gen: #0b6e74;
	--sans: 'Inter', ui-sans-serif, system-ui, sans-serif; --serif: 'Source Serif 4', ui-serif, Georgia, serif }
.sheet { font-family: var(--sans); color: var(--ink); background: #fff; box-sizing: border-box }
.sheet * { box-sizing: border-box }
`;

function coverHtml(manImg) {
	return `<!doctype html><html><head><meta charset="utf-8">${FONTS}<style>${BASE}
.sheet { background: var(--navy); color: #fff; display: grid; grid-template-columns: 1fr 34cqw; }
.l { padding: 7cqw 0 6cqw 7cqw; display: flex; flex-direction: column }
.brand { display: flex; align-items: center; gap: 1.2cqw; font-family: var(--serif); font-size: 2.3cqw; font-weight: 700 }
.brand svg { width: 3.6cqw; height: 3.6cqw }
.brand span { font-family: var(--sans); font-size: 1.4cqw; font-weight: 600; opacity: .85; margin-left: .6cqw }
h1 { font-family: var(--serif); font-size: 8.6cqw; line-height: .98; letter-spacing: -.015em; margin: auto 0 0; font-weight: 700 }
h1 em { font-style: normal; color: var(--hi) }
.sub { font-size: 2.1cqw; line-height: 1.35; font-weight: 500; margin: 2.2cqw 0 0; max-width: 46cqw }
.chips { display: flex; gap: 1cqw; margin-top: 3cqw; font-size: 1.25cqw; font-weight: 800; letter-spacing: .05em; text-transform: uppercase }
.chips span { border-radius: .5cqw; padding: .4cqw 1cqw }
.nom { background: #fff; color: var(--ink) } .akk { background: var(--hi); color: var(--ink) } .dat { background: var(--dat) } .gen { background: var(--gen) }
.ed { margin-top: 3.4cqw; font-size: 1.3cqw; font-weight: 700; letter-spacing: .08em; text-transform: uppercase; color: #e9b99f }
.r { background: #f6efdd; display: flex; align-items: center; justify-content: center; border-left: 1.2cqw solid var(--terra) }
.r img { width: 100%; display: block; mix-blend-mode: multiply; -webkit-mask-image: radial-gradient(closest-side, #000 72%, transparent 100%); mask-image: radial-gradient(closest-side, #000 72%, transparent 100%) }
</style></head><body><div class="sheet">
	<div class="l">
		<div class="brand">${LOGO}Language Quiz<span>languagequiz.org</span></div>
		<h1>German<br>Grammar<br><em>Charts</em></h1>
		<p class="sub">${config.charts.length} wall charts for the parts of German that are hard to remember. Cut them out, hang them up, look at them every day.</p>
		<div class="chips"><span class="nom">Nominativ</span><span class="akk">Akkusativ</span><span class="dat">Dativ</span><span class="gen">Genitiv</span></div>
		<p class="ed">${config.edition}</p>
	</div>
	<div class="r"><img src="${manImg}" alt=""></div>
</div></body></html>`;
}

function introHtml(qrTell, qrGive) {
	const rows = config.charts
		.map((c) => `<li><b>${c.n}</b><span><strong>${c.title}</strong><i>${c.topic}</i></span><em>${c.level}</em></li>`)
		.join('');
	return `<!doctype html><html><head><meta charset="utf-8">${FONTS}<style>${BASE}
.sheet { padding: 3.4cqw 5cqw 3cqw; display: grid; grid-template-columns: 1fr 1.25fr; gap: 4.5cqw }
h2 { font-family: var(--serif); font-size: 3cqw; color: var(--navy); margin: 0 0 1cqw; line-height: 1.05 }
h3 { font-size: 1.05cqw; font-weight: 800; letter-spacing: .08em; text-transform: uppercase; color: var(--terra); margin: 1.7cqw 0 .6cqw }
p { font-size: 1.32cqw; line-height: 1.5; margin: 0 0 .7cqw }
.steps { list-style: none; margin: 0; padding: 0; display: grid; gap: .7cqw; font-size: 1.32cqw; line-height: 1.4 }
.steps li { display: grid; grid-template-columns: 2.4cqw 1fr; align-items: start }
.steps b { width: 1.8cqw; line-height: 1.8cqw; border-radius: 50%; background: var(--navy); color: #fff; text-align: center; font-size: 1cqw }
.key { display: grid; grid-template-columns: auto 1fr; gap: .55cqw 1.2cqw; align-items: center; font-size: 1.2cqw }
.c { font-weight: 800; padding: .1cqw .6cqw; border-radius: .3cqw; font-size: 1.1cqw; white-space: nowrap; justify-self: start }
.c.nom { box-shadow: inset 0 0 0 .16cqw var(--ink) } .c.akk { background: var(--hi) } .c.dat { background: var(--dat); color: #fff } .c.gen { background: var(--gen); color: #fff }
.c.v { background: var(--terra); color: #fff } .c.e { box-shadow: inset 0 0 0 .2cqw var(--terra); color: var(--terra) }
.c.m { color: #0f4a96 } .c.f { color: #a81f1b } .c.n { color: #1c6a3c }
.toc { list-style: none; margin: 0; padding: 0; border-top: .3cqw solid var(--navy) }
.toc li { display: grid; grid-template-columns: 2.4cqw 1fr auto; align-items: center; gap: .5cqw; padding: .08cqw 0; border-bottom: .1cqw solid #8f887b }
.toc b { font-family: var(--serif); font-size: 1.25cqw; color: var(--terra); line-height: 1 }
.toc span { display: flex; align-items: baseline; gap: .8cqw; line-height: 1.25; min-width: 0; white-space: nowrap; overflow: hidden }
.toc strong { font-size: 1.02cqw } .toc i { font-family: var(--serif); font-size: .84cqw; color: var(--muted); overflow: hidden; text-overflow: ellipsis }
.toc em { font-style: normal; font-size: .62cqw; font-weight: 800; letter-spacing: .06em; text-transform: uppercase; color: var(--navy); background: var(--navy-soft); border-radius: .3cqw; padding: .15cqw .6cqw }
.foot { display: grid; grid-template-columns: 1fr 1fr; gap: 1.6cqw; margin-top: 1.5cqw }
.foot div { display: flex; align-items: center; gap: 1cqw }
.foot svg { width: 5.8cqw; height: 5.8cqw; flex: none }
.foot p { font-size: 1cqw; line-height: 1.35; margin: 0 }
.foot strong { display: block; font-size: 1.12cqw; color: var(--navy) }
.pre { font-size: 1.05cqw; margin: 1.1cqw 0 0; color: var(--muted) }
.sheet { grid-template-rows: 1fr auto; row-gap: 1.2cqw }
.legal { grid-column: 1 / -1; border-top: .16cqw solid var(--navy); padding-top: .7cqw; columns: 2; column-gap: 4.5cqw }
.legal p { font-size: .8cqw; line-height: 1.4; margin: 0 0 .35cqw; color: var(--muted); break-inside: avoid }
.legal b { color: var(--navy) }
</style></head><body><div class="sheet">
	<div>
		<h2>How to use these charts</h2>
		<p>Each chart is one page about one thing that is hard to remember in German. They are made to hang on a wall, where you see them every day.</p>
		<ol class="steps">
			<li><b>1</b><span>Print the pages <strong>on one side only</strong>, in colour, on A4 or larger.</span></li>
			<li><b>2</b><span>Hang up the one you need this week. One chart at a time works better than all of them.</span></li>
			<li><b>3</b><span>On every chart, start at the box marked <strong>Look here first</strong>, then read <strong>The one idea</strong>.</span></li>
			<li><b>4</b><span>The rows at the bottom hold the details and the mistakes to watch out for.</span></li>
		</ol>
		<h3>The colours mean the same on every chart</h3>
		<div class="key">
			<span class="c nom">Nominativ</span><span>the subject: who does it</span>
			<span class="c akk">Akkusativ</span><span>the direct object, and where to</span>
			<span class="c dat">Dativ</span><span>to whom, with whom, and where</span>
			<span class="c gen">Genitiv</span><span>whose</span>
			<span class="c v">kaufe</span><span>the verb that changes with the person</span>
			<span class="c e">gekauft</span><span>the other verb words: they never change</span>
			<span><span class="c m">der</span> <span class="c f">die</span> <span class="c n">das</span></span><span>the gender of a noun</span>
		</div>
		<div class="foot">
			<div>${qrTell}<p><strong>Tell us</strong>Found a mistake? Love a chart? Scan and say it in one tap.</p></div>
			<div>${qrGive}<p><strong>Give it to a friend</strong>Let them scan this to get the whole book.</p></div>
		</div>
		<p class="pre"><strong>Test edition.</strong> The charts are still being tested and more are on the way. The code on each chart opens its quizzes, where you can also rate and share that chart.</p>
	</div>
	<div>
		<h2>The charts</h2>
		<ol class="toc">${rows}</ol>
	</div>
	<div class="legal">
		<p><b>${config.edition}.</b> This is a test edition: the charts are still being checked and may contain mistakes. They are offered as they are, with no guarantee that they are complete or correct. Found a mistake? Scan “Tell us”.</p>
		<p><b>© ${YEAR} ${OPERATOR.name}. All rights reserved.</b> You may print these charts and hang them up for your own use or in your own classroom. No part of this book may be sold, resold, put into another product or service, uploaded or offered for download anywhere else, translated or changed, in print or in digital form, without the publisher’s written permission. To pass it on, share the link, not the file.</p>
		<p><b>Published by</b> ${[OPERATOR.name, ...(HAS_ADDRESS ? [OPERATOR.street, OPERATOR.city] : []), OPERATOR.country].join(', ')} · ${OPERATOR.email} · languagequiz.org</p>
		<p><b>Credits.</b> Texts and charts: Language Quiz, written with AI support (Anthropic Claude) and checked by a person. Illustrations: made for Language Quiz with Google Gemini. Typefaces: Inter and Source Serif 4, under the SIL Open Font License 1.1. QR Code is a registered trademark of DENSO WAVE INCORPORATED. Language Quiz is an independent study aid, not affiliated with or endorsed by any examination body.</p>
	</div>
</div></body></html>`;
}

mkdirSync(TMP, { recursive: true });
mkdirSync(dirname(PDF_OUT), { recursive: true });
mkdirSync(IMG_OUT, { recursive: true });

const qrSvg = await QRCode.toString(PAGE_URL, { type: 'svg', margin: 0, color: { dark: '#1f3a5f', light: '#ffffff' } });
const manPng = await sharp(join(root, 'tool', 'charts', 'cover-man.png')).resize(900).webp({ quality: 86 }).toBuffer();
const manImg = 'data:image/webp;base64,' + manPng.toString('base64');

const QR_OPTS = { type: 'svg', margin: 0, color: { dark: '#1f3a5f', light: '#ffffff' } };
const chartQr = (slug) => QRCode.toString(PAGE_URL + '/' + slug, { type: 'svg', margin: 0, color: { dark: '#1f3a5f', light: '#ffffff' } });

const browser = await puppeteer.launch({ executablePath: findChrome(), headless: true });
const page = await browser.newPage();
// 1123 px = 297 mm at 96 dpi, so the screen layout is the print layout.
await page.setViewport({ width: 1123, height: 794, deviceScaleFactor: 2 });

/** Load one HTML string, optionally reduce it to its sheet, and return { pdf, png }. */
async function render(name, html, isolate, level, qrOwn, urlOwn) {
	const file = join(TMP, name + '.html');
	writeFileSync(file, html);
	await page.goto(pathToFileURL(file).href, { waitUntil: 'networkidle0' });
	const problem = await page.evaluate(
		(isolate, qr, css, renumber, level, url, edge) => {
			const sheet = document.querySelector('.sheet');
			if (!sheet) return 'no .sheet';
			if (isolate) {
				// The chart files keep their <style> and font <link> next to the markup:
				// they have to survive the clear-out.
				for (const el of document.body.querySelectorAll('style, link')) document.head.appendChild(el);
				document.body.replaceChildren(sheet);
				const walker = document.createTreeWalker(sheet, NodeFilter.SHOW_TEXT);
				for (let n = walker.nextNode(); n; n = walker.nextNode())
					if (/Chart \d/.test(n.nodeValue)) n.nodeValue = n.nodeValue.replace(/Chart (\d+)/g, (m, d) => 'Chart ' + (renumber[d] ?? d));
				// The level tag sits in the logo row, where every chart has room; the levels live in charts.json.
				// The web address moves under the QR code, so the logo row keeps only the logo and the level.
				sheet.querySelector('.brand > span')?.remove();
				const num = sheet.querySelector('.brand') || sheet.querySelector('h2.title small');
				if (level && num) { const tag = document.createElement('span'); tag.className = 'lvl'; tag.textContent = 'Level ' + level; num.append(tag); }
				for (const box of sheet.querySelectorAll('.qr')) box.innerHTML = qr + '<span class="qurl"><b>Practise · rate · share</b> ' + url + '</span>';
				const line = document.createElement('div');
				line.className = 'edge';
				line.textContent = edge;
				sheet.append(line);
				// A "see Chart N" pointer never breaks across two lines.
				for (const el of sheet.querySelectorAll('.aside')) if (/^see Chart d+$/.test(el.textContent.trim())) el.style.whiteSpace = 'nowrap';
			}
			const style = document.createElement('style');
			style.textContent = css;
			document.head.appendChild(style);
			return null;
		},
		isolate,
		qrOwn ?? qrSvg,
		PRINT_CSS,
		RENUMBER,
		level,
		urlOwn ?? 'languagequiz.org/charts',
		EDGE_LINE
	);
	if (problem) throw new Error(`${name}: ${problem}`);
	await page.evaluate(() => document.fonts.ready);
	// A chart (or the intro page) whose content is taller than its sheet would be cut off in print.
	const over = await page.evaluate(() => {
		const p = document.querySelector('.sheet .page') || document.querySelector('.sheet');
		return p ? p.scrollHeight - p.clientHeight : 0;
	});
	if (over > 1) throw new Error(`${name}: content is ${over}px taller than the sheet`);
	const pdf = await page.pdf({ width: '297mm', height: '210mm', printBackground: true, pageRanges: '1' });
	const png = await (await page.$('.sheet')).screenshot();
	return { pdf, png };
}

const wrap = (body) => `<!doctype html><html><head><meta charset="utf-8"></head><body>${body}</body></html>`;
const parts = [];
parts.push({ id: 'cover', ...(await render('cover', coverHtml(manImg), false)) });
parts.push({ id: 'intro', ...(await render('intro', introHtml(await QRCode.toString(PAGE_URL + '?ref=print-feedback#feedback', QR_OPTS), await QRCode.toString(PAGE_URL + '?ref=share-print', QR_OPTS)), false)) });
for (const c of config.charts) {
	process.stdout.write(`chart ${c.n} … `);
	const html = wrap(readFileSync(join(SRC, c.file + '.html'), 'utf8'));
	parts.push({ id: String(c.n).padStart(2, '0'), ...(await render(c.file, html, true, c.level, await chartQr(c.slug), 'languagequiz.org/charts/' + c.slug)) });
	console.log('ok');
}
await browser.close();

const book = await PDFDocument.create();
book.setTitle('German Grammar Charts');
book.setAuthor('Language Quiz');
book.setSubject('Wall charts for German grammar, ' + config.edition + '. © ' + YEAR + ' ' + OPERATOR.name + '. All rights reserved. Personal and classroom use only; not for sale or redistribution.');
for (const part of parts) {
	const doc = await PDFDocument.load(part.pdf);
	const [p] = await book.copyPages(doc, [0]);
	book.addPage(p);
}
writeFileSync(PDF_OUT, await book.save());

for (const part of parts) {
	if (part.id === 'intro') continue; // only the cover and the charts are shown on the site
	await sharp(part.png).resize(part.id === 'cover' ? 1280 : 1100).webp({ quality: 80 }).toFile(join(IMG_OUT, part.id + '.webp'));
}

const megabytes = Math.round((statSync(PDF_OUT).size / 1048576) * 10) / 10;
const manifest = {
	edition: config.edition,
	// When the free download stops (an ISO date-time), or null for no end: the site's button counts down to it.
	downloadUntil: config.downloadUntil ?? null,
	pdf: '/books/charts/german-grammar-charts.pdf',
	pages: parts.length,
	megabytes,
	cover: '/img/charts/cover.webp',
	charts: config.charts.map((c) => ({ n: c.n, title: c.title, topic: c.topic, kind: c.kind, level: c.level, slug: c.slug, quizzes: c.quizzes, img: `/img/charts/${String(c.n).padStart(2, '0')}.webp` }))
};
writeFileSync(MANIFEST_OUT, JSON.stringify(manifest, null, '\t') + '\n');
console.log(`\n${parts.length} pages, ${megabytes} MB → ${PDF_OUT}`);
