// Screenshots for the "?" help panels: the real UI, cropped, with the place
// of each numbered marker measured from the page, so the markers stay on
// their buttons after a redesign. Run against the dev server:
//
//   npx vite dev --port 5180   (in another terminal)
//   node tool/gen-help-shots.mjs            all shots
//   node tool/gen-help-shots.mjs chat-*     only the matching ones
//
// Writes static/img/help/<name>.webp and src/lib/content/helpShots.json
// (marker positions as percentages of the picture). Each shot seeds its own
// state in the browser; the Schreib mir! shots build real saved chats from
// the characters' test playthroughs with the game's own code (Vite serves it).

import { createRequire } from 'node:module';
import { mkdirSync, readFileSync, writeFileSync, existsSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { join } from 'node:path';

const root = fileURLToPath(new URL('..', import.meta.url));
const require = createRequire(join(root, 'package.json'));
const puppeteer = require('puppeteer-core');
const sharp = require('sharp');

const BASE = process.env.HELP_BASE ?? 'http://localhost:5180';
const CHROME = process.env.CHROME ?? 'C:/Program Files/Google/Chrome/Application/chrome.exe';
const OUT_DIR = join(root, 'static', 'img', 'help');
const JSON_OUT = join(root, 'src', 'lib', 'content', 'helpShots.json');
mkdirSync(OUT_DIR, { recursive: true });

/** Runs in the page: a clean learner, plus whatever the shot needs. */
async function seed(kind) {
	localStorage.clear();
	localStorage.setItem('deck_swipe_coached', '1');
	localStorage.setItem('deck_surprises', 'false');
	if (kind === 'deck') return;
	const m = await import('/src/lib/domain/matchChat.ts');
	const DAY = 86400000;
	/** A saved chat from a playthrough (or its first `upTo` sentences, or sentences given outright). */
	const save = (id, ending, { upTo, say, ago = 0 } = {}) => {
		const chat = m.findChat(id);
		const run = say ? { say } : chat.playthroughs.find((p) => p.ending === ending);
		let state = m.startState(chat);
		const log = [];
		for (const [turnId, sentence] of run.say.slice(0, upTo ?? run.say.length)) {
			const turn = chat.turns.find((t) => t.id === turnId);
			const tokens = m.tilesFor(turn, sentence);
			log.push({ turn: turnId, tokens });
			state = m.playTurn(chat, state, tokens, 'Sam');
			if (state.ending) break;
		}
		const at = Date.now() - ago * DAY;
		m.saveChat(id, {
			name: 'Sam',
			log,
			startedAt: at - 600000,
			plays: {},
			...(state.ending ? { ending: state.ending, endedAt: at } : {})
		});
	};
	localStorage.setItem('match_name', 'Sam');
	if (kind === 'contacts') {
		save('helga', 'win', { ago: 2 });
		save('bernd', 'win', { upTo: 2 });
		save('kevin', 'deleted', { ago: 1 });
		localStorage.setItem('match_met', JSON.stringify(['helga', 'bernd', 'kevin', 'lena']));
	}
	if (kind === 'chat') {
		// One sentence in, with a slip (ein Limonade), so the screenshot shows
		// its score badge and the "Ah, du meinst" recast.
		save('lena', null, { say: [['t1', 'Ich möchte ein Limonade, bitte.']] });
		localStorage.setItem('match_met', JSON.stringify(['lena']));
	}
}

/** Each shot: a page, the region to crop (from one element to another), and its markers. */
const SHOTS = [
	{
		name: 'deck-anatomy',
		path: '/course/de_cert_a1',
		seed: 'deck',
		width: 760,
		from: '.deck-head',
		to: '.controls',
		markers: [
			{ n: 1, sel: '.deck-chip' },
			{ n: 2, sel: '.progress' },
			{ n: 3, sel: '.card.top .kind-label' },
			{ n: 4, sel: '.card.top .left' },
			{ n: 8, sel: '.card.top .meta' },
			{ n: 5, sel: '.controls .ctl.no', side: 'top' },
			{ n: 6, sel: '.controls .browse', side: 'top' },
			{ n: 7, sel: '.controls .ctl.yes', side: 'top' }
		]
	},
	{
		name: 'contacts-anatomy',
		path: '/play/schreib-mir',
		seed: 'contacts',
		width: 560,
		from: 'main.contacts .head',
		to: '.waiting li:nth-child(4)',
		markers: [
			{ n: 1, sel: '.tally', side: 'right' },
			{ n: 2, sel: '.chips' },
			{ n: 3, sel: '.contact .row img' },
			{ n: 4, sel: '.contact .knows' },
			{ n: 5, sel: '.contact .later' },
			{ n: 6, sel: '.other.open .go:not(.new)', side: 'right' },
			{ n: 7, sel: '.other.open .go.new', side: 'right' },
			{ n: 8, sel: '.other:not(.open) img' },
			{ n: 9, sel: '.waiting ul' }
		]
	},
	{
		name: 'chat-anatomy',
		path: '/play/schreib-mir/lena',
		seed: 'chat',
		width: 430,
		height: 1180,
		from: 'header.top',
		to: '.composer',
		// Two tiles placed, so the sentence line and its preview show.
		after: async (page) => {
			for (let i = 0; i < 2; i++)
				await page.evaluate(() => document.querySelector('.bank .tile:not(:disabled):not(.stop)')?.click());
			await new Promise((r) => setTimeout(r, 600));
		},
		markers: [
			{ n: 1, sel: '.meter' },
			{ n: 2, sel: '.goal' },
			{ n: 3, sel: '.row.in .bubble', last: true },
			{ n: 4, sel: '.score', side: 'right' },
			{ n: 5, sel: '.bubble.quote' },
			{ n: 6, sel: '.composer .placed' },
			{ n: 7, sel: '.bank' },
			{ n: 8, sel: '.bank .tile.stop', side: 'top' },
			{ n: 9, sel: '.send', side: 'top' }
		]
	}
];

const only = process.argv[2] ? new RegExp('^' + process.argv[2].replace(/\*/g, '.*') + '$') : null;
const browser = await puppeteer.launch({ executablePath: CHROME, headless: true });
const page = await browser.newPage();
// No deal-in or typing animation mid-shot.
await page.emulateMediaFeatures([{ name: 'prefers-reduced-motion', value: 'reduce' }]);
const positions = existsSync(JSON_OUT) ? JSON.parse(readFileSync(JSON_OUT, 'utf8')) : {};

for (const shot of SHOTS) {
	if (only && !only.test(shot.name)) continue;
	await page.setViewport({ width: shot.width, height: shot.height ?? 1000, deviceScaleFactor: 2 });
	await page.goto(BASE + shot.path, { waitUntil: 'load', timeout: 120000 });
	await page.evaluate(seed, shot.seed);
	await page.goto(BASE + shot.path, { waitUntil: 'load', timeout: 120000 });
	await page.waitForSelector(shot.to, { timeout: 60000 });
	await new Promise((r) => setTimeout(r, 3000));
	if (shot.after) await shot.after(page);
	const box = await page.evaluate(
		(from, to, markers) => {
			const a = document.querySelector(from).getBoundingClientRect();
			const b = document.querySelector(to).getBoundingClientRect();
			const pad = 12;
			// Room on the left for the markers, which sit just left of their element.
			const padLeft = 34;
			const region = {
				x: Math.max(0, Math.min(a.left, b.left) - padLeft),
				y: Math.max(0, a.top - pad + window.scrollY),
				right: Math.min(document.documentElement.clientWidth, Math.max(a.right, b.right) + pad),
				bottom: b.bottom + pad + window.scrollY
			};
			const w = region.right - region.x;
			const h = region.bottom - region.y;
			const marks = markers.map((m) => {
				const el = m.last ? [...document.querySelectorAll(m.sel)].at(-1) : document.querySelector(m.sel);
				if (!el) throw new Error(`marker ${m.n}: nothing matches ${m.sel}`);
				const r = el.getBoundingClientRect();
				// The marker sits just left of the element, level with its middle
				// (or its first line, for a tall one); with side "top", centred
				// above it (for buttons side by side).
				// With side "right", just right of it.
				const top = m.side === 'top';
				const right = m.side === 'right';
				const x = top ? r.left + r.width / 2 : right ? r.right : r.left;
				const y = top ? r.top : r.top + Math.min(r.height / 2, 14);
				return {
					n: m.n,
					...(m.side ? { side: m.side } : {}),
					x: Math.round(((x - region.x) / w) * 1000) / 10,
					y: Math.round(((y + window.scrollY - region.y) / h) * 1000) / 10
				};
			});
			return { region: { x: region.x, y: region.y, width: w, height: h }, marks };
		},
		shot.from,
		shot.to,
		shot.markers
	);
	const png = await page.screenshot({ clip: box.region, captureBeyondViewport: true });
	await sharp(png).webp({ quality: 82 }).toFile(join(OUT_DIR, `${shot.name}.webp`));
	positions[shot.name] = {
		width: Math.round(box.region.width),
		height: Math.round(box.region.height),
		markers: box.marks
	};
	console.log(`${shot.name}: ${box.marks.length} markers`);
}

writeFileSync(JSON_OUT, JSON.stringify(positions, null, '\t') + '\n');
await browser.close();
