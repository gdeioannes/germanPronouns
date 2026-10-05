// Story playtest bot: the hands-on half of the story review system
// (docs/story_review.md). Plays an episode end to end in a real browser with
// the right answers (it reads the script and the drawn pool variants), takes
// a screenshot of every screen, and reports page errors and screens where it
// got stuck — so a reviewer (human or agent) can look at the actual UI
// without clicking through 15 minutes of story.
//
//   npm run dev                                  (in another terminal)
//   node tool/playtest-story.mjs ep0_lost_in_berlin
//   node tool/playtest-story.mjs ep0_lost_in_berlin --base http://localhost:5199 --desktop
//
// Screenshots: assets/images/raw/playtest/<episode>/ (gitignored). Needs a
// local Chrome or Edge (CHROME_PATH overrides), like tool/gen-workbooks.mjs.

import { existsSync, mkdirSync, readFileSync, rmSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { join } from 'node:path';
import puppeteer from 'puppeteer-core';

const root = fileURLToPath(new URL('..', import.meta.url));
const args = process.argv.slice(2);
const id = args.find((a) => !a.startsWith('--') && !/^https?:/.test(a));
const base = args[args.indexOf('--base') + 1]?.startsWith('http') ? args[args.indexOf('--base') + 1] : 'http://localhost:5173';
const desktop = args.includes('--desktop');
if (!id) {
	console.error('usage: node tool/playtest-story.mjs <episode id> [--base URL] [--desktop]');
	process.exit(1);
}
const ep = JSON.parse(readFileSync(join(root, 'assets', 'content', 'stories', `${id}.json`), 'utf8'));
const { PLACES } = await import('../src/lib/components/story/kiez.ts').catch(() => ({ PLACES: null }));
const placeIds = PLACES
	? Object.keys(PLACES)
	: ['bahnhof', 'platz', 'baeckerei', 'park', 'bruecke', 'fernsehturm', 'linden', 'garten', 'berg', 'schul'];
const OUT = join(root, 'assets', 'images', 'raw', 'playtest', id);
rmSync(OUT, { recursive: true, force: true });
mkdirSync(OUT, { recursive: true });

function findChrome() {
	const candidates = [
		process.env.CHROME_PATH,
		'C:/Program Files/Google/Chrome/Application/chrome.exe',
		'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe',
		'/usr/bin/google-chrome',
		'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
	].filter(Boolean);
	const found = candidates.find((p) => existsSync(p));
	if (!found) throw new Error('No Chrome or Edge found — set CHROME_PATH.');
	return found;
}

const browser = await puppeteer.launch({ executablePath: findChrome(), headless: true });
const page = await browser.newPage();
await page.setViewport(desktop ? { width: 1280, height: 900 } : { width: 412, height: 915, deviceScaleFactor: 1, isMobile: true, hasTouch: true });
const errors = [];
page.on('pageerror', (e) => errors.push(`pageerror: ${e.message}`));
// 404s are listed by URL (missing audio before a recording run is normal);
// the browser's generic console line for them is noise.
const missingFiles = new Set();
page.on('response', (r) => r.status() === 404 && missingFiles.add(new URL(r.url()).pathname));
page.on('console', (m) => m.type() === 'error' && !m.text().startsWith('Failed to load resource') && errors.push(`console: ${m.text()}`));
// Audio can't play headless; record what the player asks for instead.
await page.evaluateOnNewDocument(() => {
	const Real = window.Audio;
	window.__audio = [];
	window.Audio = function (src) {
		const a = new Real(src);
		window.__audio.push(src);
		a.play = () => Promise.resolve();
		return a;
	};
	try {
		localStorage.clear();
	} catch {
		/* ignore */
	}
});

const route = `/story/${id.replace(/_/g, '-')}`;
await page.goto(base + route, { waitUntil: 'domcontentloaded', timeout: 120000 });
await page.waitForSelector('main.story button', { timeout: 120000 });
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
await sleep(600);
// The drawn variants, re-read every step: the game saves them on its first
// write and re-draws them when a chapter restarts.
let draw = {};
const readDraw = async () =>
	(draw = (await page.evaluate((k) => JSON.parse(localStorage.getItem(k) ?? '{}'), `story_${id}`)).draw ?? draw);
const resolve = (t) =>
	`${t}`.replaceAll('{user}', 'partner').replace(/\{pool:([a-zA-Z]+)(?::other(\d))?\}/g, (_, name, other) => {
		const v = ep.pools[name];
		const i = draw[name] ?? 0;
		return v[other ? (i + Number(other)) % v.length : i];
	});
const beats = new Map(ep.chapters.flatMap((c) => c.beats.map((b) => [b.id, b])));

let shot = 0;
async function snap(label) {
	shot += 1;
	await page.screenshot({ path: join(OUT, `${String(shot).padStart(3, '0')}-${label}.png`), fullPage: true });
}
/** Click the first button whose trimmed text matches. */
async function clickText(selector, text) {
	const handles = await page.$$(selector);
	for (const h of handles) {
		const t = (await h.evaluate((el) => el.textContent ?? '')).replace(/\s+/g, ' ').trim();
		if (t === text || t.endsWith(text)) {
			await h.click();
			await sleep(350);
			return true;
		}
	}
	return false;
}
const button = (text) => clickText('main button, main a.btn', text);
async function texts(selector) {
	return page.$$eval(selector, (els) => els.map((e) => (e.textContent ?? '').replace(/\s+/g, ' ').trim()));
}
async function continueOn() {
	for (let i = 0; i < 8; i++) {
		if (await button('Continue')) return true;
		await sleep(300);
	}
	return false;
}

async function play(b) {
	switch (b.type === 'quiz' ? b.kind : b.type) {
		case 'narrative':
			return button('Continue');
		case 'clue':
			return button('Noted');
		case 'banter':
		case 'select':
		case 'recall': {
			await clickText('.opt', resolve(b.options.find((o) => o.correct).text));
			await snap(`${b.id}-answered`);
			return continueOn();
		}
		case 'inlineCloze':
		case 'bigText': {
			for (const bl of (b.quiz ?? b).blanks) await page.select(`select[aria-label="Gap ${bl.n}"]`, bl.answer);
			await button('Check');
			await snap(`${b.id}-answered`);
			return continueOn();
		}
		case 'listening': {
			for (const [i, q] of b.questions.entries()) {
				await clickText('.opt', resolve(q.options.find((o) => o.correct).text));
				if (i + 1 < b.questions.length) await button('Next');
			}
			return continueOn();
		}
		case 'orderedPick': {
			if (b.layout === 'keypad') {
				for (const d of resolve(b.sequence).replace(/\s+/g, '')) await clickText('.key', d);
				await sleep(1200);
				return true;
			}
			for (const t of b.sequence) await clickText('.bank .tile', resolve(t));
			await button('Check');
			await sleep(900);
			return true;
		}
		case 'hotspot': {
			const i = b.spots.findIndex((s) => s.id === resolve(b.answer));
			const spots = await page.$$('.spot');
			await spots[i].click();
			await sleep(400);
			await snap(`${b.id}-answered`);
			return continueOn();
		}
		case 'map': {
			if (b.mode === 'walk') {
				const walk = b.walks[draw[b.walkPool] ?? 0];
				for (const t of walk.turns) {
					await clickText('.turn', t);
					await sleep(800);
				}
			} else {
				const hits = await page.$$('.hit');
				await hits[placeIds.indexOf(resolve(b.target))].click();
				await sleep(400);
			}
			await snap(`${b.id}-answered`);
			return continueOn();
		}
		case 'stops': {
			const want = draw[b.pool] ?? 0;
			for (let i = 0; i < 8; i++) {
				await sleep(700);
				const last = await page.evaluate(() => window.__audio.filter((s) => /halt|stop/.test(s)).at(-1) ?? '');
				const variant = Number(last.match(/_(\d+)\.mp3$/)?.[1]);
				if (variant === want) {
					await clickText('.stop-btn', 'Get off here!');
					break;
				}
				await clickText('.stop-btn', 'Stay on');
			}
			await snap(`${b.id}-answered`);
			return continueOn();
		}
		case 'dialogue': {
			for (let step = 0; step < 40; step++) {
				await sleep(450);
				if (await page.$('main .btn:not(.next)')) {
					await snap(`${b.id}-done`);
					if (await button('Continue')) return true;
				}
				const opts = await texts('.opts .opt');
				if (opts.length) {
					const line = b.lines.find((l) => l.choose && l.choose.every((o) => opts.includes(resolve(o.text))));
					if (!line) return false;
					await clickText('.opts .opt', resolve(line.choose.find((o) => o.correct).text));
					await sleep(700);
					await snap(`${b.id}-turn${step}`);
					continue;
				}
				const tiles = await texts('.bank .tile');
				if (tiles.length) {
					const line = b.lines.find((l) => l.build && (l.build.options ?? l.build.sequence).every((t) => tiles.includes(resolve(t))));
					if (!line) return false;
					for (const t of line.build.sequence) await clickText('.bank .tile', resolve(t));
					await button('Check');
					await sleep(700);
					await snap(`${b.id}-turn${step}`);
					continue;
				}
				if (await button('Next')) continue;
			}
			await snap(`${b.id}-dialogue-end`);
			return continueOn();
		}
		default:
			return false;
	}
}

const visited = [];
let stuck = 0;
let lastKey = '';
for (let step = 0; step < 600; step++) {
	await sleep(300);
	await readDraw();
	const where = await page.evaluate(() => {
		const p = document.querySelector('[data-beat]');
		if (p) return { kind: 'beat', beat: p.getAttribute('data-beat') };
		if (document.querySelector('.micro-panel')) return { kind: 'micro', q: document.querySelector('.micro-panel .q')?.textContent ?? '' };
		if (document.querySelector('.panel.end')) return { kind: 'end' };
		if (document.querySelector('.lead')) return { kind: 'hub' };
		return { kind: 'title' };
	});
	const key = JSON.stringify(where);
	stuck = key === lastKey ? stuck + 1 : 0;
	if (stuck > 6) {
		await snap(`STUCK-${where.beat ?? where.kind}`);
		errors.push(`stuck at ${key}`);
		break;
	}
	if (key !== lastKey) await snap(where.beat ?? where.kind);
	lastKey = key;

	if (where.kind === 'end') break;
	if (where.kind === 'title') {
		if (!(await button('Start the episode'))) await button('Continue');
	} else if (where.kind === 'hub') {
		const leads = await page.$$('.lead:not(.done)');
		if (leads.length) await leads[0].click();
		else await clickText('.btn.finale', resolve(ep.hub.finaleLabel ?? ''));
		await sleep(400);
	} else if (where.kind === 'micro') {
		const m = ep.microChecks.find((c) => resolve(c.question) === where.q.trim());
		if (m) await clickText('.micro-panel .opt', resolve(m.options.find((o) => o.correct).text));
		await sleep(300);
		await button('Back to the case');
	} else {
		const b = beats.get(where.beat);
		if (!visited.includes(b.id)) visited.push(b.id);
		const ok = await play(b);
		if (!ok) errors.push(`could not play ${b.id} (${b.kind ?? b.type})`);
	}
}

const missing = [...beats.keys()].filter((k) => !visited.includes(k));
console.log(`\n${ep.title}: ${visited.length}/${beats.size} beats played, ${shot} screenshots → ${OUT}`);
if (missing.length) console.log(`not reached: ${missing.join(', ')}`);
console.log(errors.length ? `${errors.length} problems:\n  ${errors.join('\n  ')}` : 'no page errors');
if (missingFiles.size) console.log(`${missingFiles.size} missing files (404): ${[...missingFiles].map((p) => p.split('/').pop()).join(', ')}`);
console.log('audio requested:', [...new Set(await page.evaluate(() => window.__audio))].length, 'distinct clips');
await browser.close();
process.exit(errors.length || missing.length ? 1 : 0);
