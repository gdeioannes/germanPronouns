// Story review scorecard: the static half of the story review system
// (docs/story_review.md). Reads an episode JSON and reports what a playtest
// would feel — pacing, interactivity, "straight questions", words used before
// they are taught, coverage of the episode's word list, feedback on wrong
// answers — as numbers and a list of findings. It never edits anything.
//
//   npm run story-review -- ep0_lost_in_berlin
//   npm run story-review -- ep0_lost_in_berlin --json   machine-readable
//
// The gate test (src/routes/story/story-gate.test.ts) is the hard floor; this
// is the taste check reviewers iterate against.

import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { join } from 'node:path';

const root = fileURLToPath(new URL('..', import.meta.url));
const args = process.argv.slice(2);
const id = args.find((a) => !a.startsWith('--'));
if (!id) {
	console.error('usage: npm run story-review -- <episode id>');
	process.exit(1);
}
const ep = JSON.parse(readFileSync(join(root, 'assets', 'content', 'stories', `${id}.json`), 'utf8'));
const asJson = args.includes('--json');

const findings = [];
const flag = (severity, where, what) => findings.push({ severity, where, what });

// ---- pacing model (seconds, a beginner playing without mistakes) ----------
const T = { narrative: 20, clueBase: 6, cluePerEntry: 3, pick: 12, npcLine: 6, tile: 3, blank: 10, mapFind: 12, walkTurn: 8, stop: 10, micro: 12 };
function seconds(b) {
	if (b.type === 'narrative') return T.narrative;
	if (b.type === 'clue') return T.clueBase + T.cluePerEntry * (b.entries?.length ?? 0);
	switch (b.kind) {
		case 'dialogue':
			return b.lines.reduce((s, l) => s + (l.choose ? T.pick : l.build ? T.tile * l.build.sequence.length + 4 : T.npcLine), 0);
		case 'inlineCloze':
		case 'bigText':
			return T.blank * (b.quiz ?? b).blanks.length;
		case 'map':
			return b.mode === 'walk' ? T.walkTurn * (b.walks?.[0]?.turns.length ?? 2) + 6 : T.mapFind;
		case 'stops':
			return T.stop * ep.pools[b.pool].length + 6;
		case 'orderedPick':
			return T.tile * (Array.isArray(b.sequence) ? b.sequence.length : 8) + (b.audio ? 15 : 0);
		case 'listening':
			return 20 + T.pick * (b.questions?.length ?? 1);
		default:
			return T.pick;
	}
}

// ---- vocabulary: words used before the notebook (or a voice) taught them --
const norm = (s) =>
	s
		.toLowerCase()
		.replace(/\{pool:[a-zA-Z]+(:other\d)?\}…?/g, ' ')
		.replace(/[.,!?…:;“”"'‘’()–—]/g, ' ')
		.replace(/[🌀-🫿←-⇿➔➜]/gu, ' ')
		.split(/\s+/)
		.filter(Boolean);
const NAMES = new Set(['maya', 'jonas', 'weber', 'demir', 'frau', 'herr', 'böhm', 'amerika', 'berlin', 'u-bahn', 'straße']);
for (const values of Object.values(ep.pools)) for (const v of values) for (const w of norm(v)) NAMES.add(w);
// A late episode may lean on what the course already taught (`assumes`: the
// words the level's exercises covered); everything else must still be taught
// in-story before it is asked.
for (const w of ep.assumes ?? []) for (const t of norm(w)) NAMES.add(t);
let known = new Set(NAMES);
const learn = (de) => norm(de).forEach((w) => known.add(w));
function checkGerman(where, text) {
	const unknown = norm(text).filter((w) => !known.has(w) && !/^\d+$/.test(w) && w.length > 1);
	if (unknown.length) flag('warn', where, `German used before it is taught: ${[...new Set(unknown)].join(', ')}`);
}

/** A German answer (vs an English sentence about the case). */
const isGerman = (t) =>
	!/\b(the|a|is|on|it's|and|of|to|I)\b/i.test(t.replace(/\{pool:[^}]+\}/g, '')) &&
	/[äöüß]|^(ja|nein|hallo|danke|bitte|tschüss|guten|nummer|ich|wo|wie|auf|bis|entschuldigung)\b/i.test(t);

// ---- straight questions ----------------------------------------------------
const STRAIGHT = /\b(what does .+ mean|what is .+ in (english|german)|means\?|translate|bedeutet|which word means)\b/i;

// ---- walk the episode in play order (hub leads in authored order) ---------
const allBeats = [];
let total = 0;
const kinds = new Map();
let critical = 0;
let quizBeats = 0;
let plainPicks = 0;
let run = 0;
let lastKind = '';
let sameKind = 0;
const images = new Set();
// Hub leads play in any order: each starts from what was known when the hub
// opened, and only the finale gets the union of all of them.
const leads = new Set(ep.hub?.leads ?? []);
let atHub = null;
const learnedInLeads = new Set();
/** Clue → the words its chapter taught (for leads that `require` that clue). */
const learnedByClue = new Map();
for (const ch of ep.chapters) {
	if (leads.has(ch.id)) {
		atHub ??= new Set(known);
		known = new Set(atHub);
		for (const c of ch.requires ?? []) for (const w of learnedByClue.get(c) ?? []) known.add(w);
	} else if (atHub) {
		known = new Set([...atHub, ...learnedInLeads]);
	}
	for (const b of ch.beats) {
		const where = `${ch.id}/${b.id}`;
		allBeats.push(b);
		total += seconds(b);
		if (b.image) images.add(b.image);
		const kind = b.type === 'quiz' ? b.kind : b.type;
		kinds.set(kind, (kinds.get(kind) ?? 0) + 1);
		if (b.critical) critical++;

		// interactivity: long stretches of reading/listening without a tap
		if (b.type === 'quiz') {
			quizBeats++;
			run = 0;
			if (b.kind === 'select' || b.kind === 'recall') plainPicks++;
		} else if (++run > 2) flag('warn', where, `${run} passive beats in a row (narrative/clue) — give the learner something to do`);

		// repetition: the same mechanic three times running
		sameKind = kind === lastKind ? sameKind + 1 : 1;
		lastKind = kind;
		if (b.type === 'quiz' && sameKind === 3) flag('info', where, `third "${kind}" in a row — vary the mechanic or the framing`);

		// text length
		if (b.type === 'narrative' && b.text.length > 340) flag('warn', where, `narration is ${b.text.length} chars — beginners skim past ~300`);

		// straight questions
		for (const q of [b.question, b.prompt].filter(Boolean))
			if (STRAIGHT.test(q)) flag('warn', where, `straight translation question: “${q.slice(0, 80)}”`);

		// teaching
		if (b.type === 'clue') b.entries.forEach((e) => learn(e.de));
		if (b.kind === 'cloze' || b.kind === 'inlineCloze')
			for (const bl of (b.quiz ?? b).blanks) checkGerman(`${where} blank ${bl.n}`, bl.answer);
		if (b.kind === 'dialogue') {
			for (const [i, l] of b.lines.entries()) {
				const at = `${where} line ${i + 1}`;
				if (l.de && !l.blur) learn(l.de); // heard + glossable
				(l.entries ?? []).forEach((e) => learn(e.de));
				if (l.choose) {
					for (const o of l.choose) checkGerman(o.correct ? at : `${at} (distractor)`, o.text);
					for (const o of l.choose) if (!o.correct && !o.reply) flag('warn', at, `wrong option “${o.text}” has no reply — every miss should get a reaction`);
				}
				if (l.build) checkGerman(at, l.build.sequence.join(' '));
				if (l.who === 'aside' && (l.text ?? '').length > 170) flag('info', at, `aside is ${l.text.length} chars`);
			}
		}
		if (b.kind === 'banter' || b.kind === 'select' || b.kind === 'recall') {
			for (const o of b.options ?? []) if (b.kind === 'banter' && !o.correct && !o.reply) flag('warn', where, `banter option “${o.text}” has no reply`);
			// German answers (no English letters-only sentences): check the right one
			const right = (b.options ?? []).find((o) => o.correct)?.text ?? '';
			const english = /\b(the|a|is|on|it's|and|of|to|I)\b/i.test(right.replace(/\{pool:[^}]+\}/g, ''));
			if (!english) for (const o of b.options ?? []) if (isGerman(o.text)) checkGerman(where, o.text);
		}
		if (b.kind === 'hotspot') {
			// the tap itself files its entries (decode from the picture, then learn)
			(b.entries ?? []).forEach((e) => learn(e.de));
			const ans = (b.spots ?? []).find((s) => s.id === b.answer);
			if (ans?.label) checkGerman(where, ans.label);
		}
		if (b.kind === 'map') {
			if (b.mode === 'walk') for (const w of b.walks ?? []) checkGerman(where, w.turns.join(' '));
			(b.entries ?? []).forEach((e) => learn(e.de));
		}
	}
	if (leads.has(ch.id)) for (const w of known) learnedInLeads.add(w);
	if (ch.clue) learnedByClue.set(ch.clue, new Set(known));
	for (const m of ep.microChecks.filter((m) => m.after === ch.id)) {
		total += T.micro;
		if (STRAIGHT.test(m.question)) flag('warn', `micro after ${ch.id}`, `straight question: “${m.question}”`);
		for (const o of m.options) if (isGerman(o.text)) checkGerman(`micro after ${ch.id}`, o.text);
	}
}

// ---- coverage of the episode's word list ----------------------------------
const notebook = new Set();
for (const b of allBeats) {
	for (const e of b.entries ?? []) notebook.add(e.de.toLowerCase());
	for (const l of b.lines ?? []) for (const e of l.entries ?? []) notebook.add(e.de.toLowerCase());
}
const everything = JSON.stringify(ep).toLowerCase();
for (const w of ep.teaches ?? []) {
	const lw = w.toLowerCase();
	if (![...notebook].some((n) => n.includes(lw.replace(' …', '')))) flag('warn', 'teaches', `“${w}” never lands in the notebook`);
	// used in an interaction at least twice (taught once, used once)
	const uses = everything.split(lw.replace(' …', '')).length - 1;
	if (uses < 2) flag('info', 'teaches', `“${w}” appears only once — no second encounter`);
}

// ---- the formula's numbers --------------------------------------------------
const minutes = total / 60;
if (minutes < ep.minutesFloor) flag('error', 'episode', `estimated ${minutes.toFixed(1)} min < floor ${ep.minutesFloor}`);
if (critical < 5 || critical > 8) flag('warn', 'episode', `${critical} critical beats (formula: 5–8)`);
const pickShare = plainPicks / quizBeats;
if (pickShare > 0.25) flag('warn', 'episode', `${Math.round(pickShare * 100)}% of exercises are plain pick-one questions (aim ≤ 25%)`);
const passiveShare = 1 - quizBeats / allBeats.length;

const scorecard = {
	episode: ep.id,
	minutes: Number(minutes.toFixed(1)),
	floor: ep.minutesFloor,
	beats: allBeats.length,
	exercises: quizBeats,
	passiveShare: Number(passiveShare.toFixed(2)),
	plainPickShare: Number(pickShare.toFixed(2)),
	mechanics: Object.fromEntries(kinds),
	critical,
	notebookWords: notebook.size,
	images: images.size,
	findings
};

if (asJson) {
	console.log(JSON.stringify(scorecard, null, 2));
} else {
	console.log(`\n${ep.title} (${ep.id})`);
	console.log(`  ${scorecard.minutes} min estimated (floor ${ep.minutesFloor}) · ${scorecard.beats} beats · ${quizBeats} exercises · ${critical} critical`);
	console.log(`  passive beats ${Math.round(passiveShare * 100)}% · plain pick-one ${Math.round(pickShare * 100)}% · ${notebook.size} notebook words · ${images.size} images`);
	console.log(`  mechanics: ${[...kinds].map(([k, n]) => `${k}×${n}`).join(' ')}`);
	const order = { error: 0, warn: 1, info: 2 };
	findings.sort((a, b) => order[a.severity] - order[b.severity]);
	console.log(findings.length ? `\n${findings.length} findings:` : '\nNo findings.');
	for (const f of findings) console.log(`  [${f.severity}] ${f.where}: ${f.what}`);
}
