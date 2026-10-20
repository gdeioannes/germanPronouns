#!/usr/bin/env node
// Merges the medal-ladder content into a course bundle, after checking it.
//
// The ladder gives a fill-in drill three steps: choose the answer from four,
// type it with its cue, type it with no help. The first needs three wrong
// options for every sentence, and the last draws on the drill's harder
// sentences. That content is authored per sub-level in
// assets/content/ladder/<course>/<module>.json and folded in here:
//
//   node tool/apply-ladder.mjs de_cert_a1 --check a1_1   # validate only
//   node tool/apply-ladder.mjs de_cert_a1 a1_1 a1_2      # validate, then merge
//   node tool/apply-ladder.mjs de_cert_a1                # every module
//
// A module file is an array of entries. A fill-in drill:
//
//   { "id": "quest_a1_1_pronomen",
//     "sentences": [ { "sentence": "<the existing sentence, verbatim>",
//                      "options": ["wrong", "wrong", "wrong"],
//                      "hard": true, "keepCue": true,
//                      "english": "<replaces the English line, when it must carry the word>" } ],
//     "add": [ { "sentence": "…____…", "acceptedAnswers": ["…"],
//                "english": "…", "subjectKey": "s0", "categoryLabel": "…",
//                "hint": "…", "options": [ … ], "hard": true } ] }
//
// Every existing sentence is listed once. `options` are three answers that
// are wrong in that sentence (not needed for a word-tile item). `hard` marks
// the sentences the no-help step draws on; `keepCue` keeps a trailing
// "(…)" there because it carries something the English line doesn't. `add`
// brings new hard sentences, so every drill has at least MIN_HARD of them.
//
// A big-text cloze: { "id": "…", "blanks": [ { "index": 3, "cue": "lesen", "hint": "…", "options": [ … ] } ] }
// — every gap has a `cue` (what the no-help step still shows: the lemma or a
// two-word gloss), typed ("input") gaps have three wrong options, and `hint`
// replaces the type step's hint when it needs to say more than the cue.
// `why` is the one-line reason the correction gives after a miss ("stellen is
// putting it somewhere: accusative …"); optional, shown only after checking.
//
// Idempotent: running it twice yields the same bundle.

import { readFileSync, writeFileSync, readdirSync, existsSync } from 'node:fs';
import { resolve, join } from 'node:path';

const MIN_HARD = 10;
const OPTION_COUNT = 3;

const args = process.argv.slice(2);
const checkOnly = args.includes('--check');
const [courseId, ...modules] = args.filter((a) => a !== '--check');
if (!courseId) {
	console.error('usage: node tool/apply-ladder.mjs <courseId> [--check] [module ...]');
	process.exit(1);
}

const root = resolve(import.meta.dirname, '..');
const bundlePath = join(root, 'assets/content/courses', `${courseId}.json`);
const ladderDir = join(root, 'assets/content/ladder', courseId);
if (!existsSync(ladderDir)) {
	console.error(`no ladder directory: ${ladderDir}`);
	process.exit(1);
}

const bundle = JSON.parse(readFileSync(bundlePath, 'utf8'));
const files = (modules.length ? modules.map((m) => `${m}.json`) : readdirSync(ladderDir))
	.filter((f) => f.endsWith('.json'))
	.sort();

/** How answers compare: case, spacing, the ellipsis's spelling and final punctuation never matter. */
function norm(text) {
	return String(text)
		.normalize('NFC')
		.toLowerCase()
		.replace(/\.\.\./g, '…')
		.replace(/\s*…\s*/g, ' … ')
		.replace(/\s+/g, ' ')
		.replace(/[.!?,;:]+$/g, '')
		.trim();
}

const gapsOf = (text) => (String(text).match(/____/g) ?? []).length;
const partsOf = (answer) => norm(answer).split(' … ').length;

const errors = [];
const warnings = [];
function fail(where, message) {
	errors.push(`${where}: ${message}`);
}

/** Three wrong options, each a real answer shape for `accepted`, none of them right. */
function checkOptions(where, options, accepted) {
	if (!Array.isArray(options) || options.length !== OPTION_COUNT) {
		fail(where, `needs exactly ${OPTION_COUNT} options`);
		return;
	}
	const right = new Set(accepted.map(norm));
	const seen = new Set();
	const parts = partsOf(accepted[0]);
	for (const option of options) {
		if (typeof option !== 'string' || !option.trim()) {
			fail(where, 'an option is empty');
			continue;
		}
		const n = norm(option);
		if (right.has(n)) fail(where, `option "${option}" is an accepted answer`);
		if (seen.has(n)) fail(where, `option "${option}" is listed twice`);
		seen.add(n);
		if (partsOf(option) !== parts) {
			fail(where, `option "${option}" has ${partsOf(option)} part(s), the answer has ${parts}`);
		}
		if (/____|\(|\)/.test(option)) fail(where, `option "${option}" holds a blank or a bracket`);
	}
}

/** The sentences an entry adds, by text. */
const addTexts = (entry) => new Set((entry.add ?? []).map((a) => a.sentence));

const plan = [];
for (const file of files) {
	const module = file.replace(/\.json$/, '');
	let entries;
	try {
		entries = JSON.parse(readFileSync(join(ladderDir, file), 'utf8'));
	} catch (e) {
		fail(file, `not valid JSON — ${e.message}`);
		continue;
	}
	if (!Array.isArray(entries)) {
		fail(file, 'must be an array of entries');
		continue;
	}
	for (const entry of entries) {
		const quiz = bundle.quizzes.find((q) => q.id === entry.id);
		const where = `${module}/${entry.id}`;
		if (!quiz) {
			fail(where, 'no such quiz in the bundle');
			continue;
		}

		if (quiz.type === 'reading' && quiz.inlineBlanks) {
			const given = new Map((entry.blanks ?? []).map((b) => [b.index, b]));
			quiz.inlineBlanks.forEach((b, index) => {
				const e = given.get(index);
				const at = `${where} gap ${index} ("${b.answer}")`;
				if (!e) {
					fail(at, 'not covered: every gap needs a cue');
					return;
				}
				if (typeof e.cue !== 'string' || !e.cue.trim()) fail(at, 'needs a cue for the no-help step');
				else if (norm(e.cue) === norm(b.answer)) fail(at, 'the cue is the answer');
				if (e.hint !== undefined && (typeof e.hint !== 'string' || !e.hint.trim())) fail(at, '"hint" must be text');
				if (e.why !== undefined && (typeof e.why !== 'string' || !e.why.trim())) fail(at, '"why" must be text');
				if (b.kind === 'input') checkOptions(at, e.options, [b.answer, ...(b.accepted ?? [])]);
				else if (e.options) fail(at, 'a dropdown gap has its own options');
			});
			for (const index of given.keys()) {
				if (!quiz.inlineBlanks[index]) fail(where, `gap ${index} does not exist`);
			}
			plan.push({ quiz, entry, kind: 'cloze' });
			continue;
		}

		if (quiz.type !== 'fillBlank' || !quiz.sentences?.length) {
			fail(where, 'not a fill-in drill with authored sentences');
			continue;
		}

		// Sentences this file adds are in the bundle already after a first merge:
		// they are checked as additions, not as sentences to cover.
		const addTexts = new Set((entry.add ?? []).map((a) => a.sentence));
		const byText = new Map();
		for (const s of entry.sentences ?? []) {
			if (byText.has(s.sentence)) fail(where, `sentence listed twice: ${s.sentence}`);
			byText.set(s.sentence, s);
		}
		let hard = 0;
		// Two word-tile items may share a sentence ("Heute ____."): one entry covers both.
		const covered = new Set();
		for (const sentence of quiz.sentences) {
			if (addTexts.has(sentence.sentence)) continue;
			const s = byText.get(sentence.sentence);
			const at = `${where} "${sentence.sentence}"`;
			if (!s) {
				if (!covered.has(sentence.sentence)) fail(at, 'not covered');
				continue;
			}
			covered.add(sentence.sentence);
			if (sentence.tiles?.length) {
				if (s.options) fail(at, 'a word-tile item takes no options (its tiles are the choice)');
			} else checkOptions(at, s.options, sentence.acceptedAnswers);
			if (s.hard !== undefined && typeof s.hard !== 'boolean') fail(at, '"hard" must be true or false');
			if (s.keepCue !== undefined) {
				if (typeof s.keepCue !== 'boolean') fail(at, '"keepCue" must be true or false');
				if (s.keepCue && !/\)\s*$/.test(sentence.sentence)) fail(at, '"keepCue" but no trailing "(…)" cue');
			}
			if (s.english !== undefined) {
				if (typeof s.english !== 'string' || !s.english.trim()) fail(at, '"english" must be text');
				else if (/____/.test(s.english)) fail(at, 'the English line must carry the word, not a blank');
			}
			if (s.hard) hard++;
		}
		for (const text of byText.keys()) {
			if (!covered.has(text)) fail(where, `listed but not in the drill: ${text}`);
		}

		const labels = new Set((quiz.categories ?? []).map((c) => c.label));
		for (const c of quiz.sentences) labels.add(c.categoryLabel);
		// The drill's subjects, and any key its own sentences already use.
		const keys = new Set([
			...(quiz.subjects ?? []).map((s) => s.key),
			...quiz.sentences.map((s) => s.subjectKey)
		]);
		const existing = new Set(
			quiz.sentences.filter((s) => !addTexts.has(s.sentence)).map((s) => norm(s.sentence))
		);
		for (const [i, a] of (entry.add ?? []).entries()) {
			const at = `${where} add[${i}]`;
			if (typeof a.sentence !== 'string' || gapsOf(a.sentence) < 1) fail(at, 'sentence needs a ____ gap');
			if (!Array.isArray(a.acceptedAnswers) || !a.acceptedAnswers.length) fail(at, 'needs acceptedAnswers');
			else if (gapsOf(a.sentence) !== partsOf(a.acceptedAnswers[0]))
				fail(at, `${gapsOf(a.sentence)} gap(s) but the answer has ${partsOf(a.acceptedAnswers[0])} part(s)`);
			if (typeof a.english !== 'string' || !a.english.trim()) fail(at, 'needs an English line');
			if (!labels.has(a.categoryLabel)) fail(at, `categoryLabel "${a.categoryLabel}" is not one of the drill's`);
			if (keys.size && !keys.has(a.subjectKey)) fail(at, `subjectKey "${a.subjectKey}" is not one of the drill's`);
			if (existing.has(norm(a.sentence))) fail(at, 'duplicates a sentence already in the drill');
			existing.add(norm(a.sentence));
			if (a.hard !== true) fail(at, 'an added sentence is a hard one: "hard": true');
			if (a.tiles) fail(at, 'added sentences are typed, not tiled');
			if (Array.isArray(a.acceptedAnswers)) checkOptions(at, a.options, a.acceptedAnswers);
			hard++;
		}
		if (hard < MIN_HARD) fail(where, `only ${hard} hard sentences — at least ${MIN_HARD}`);
		plan.push({ quiz, entry, kind: 'drill' });
	}
}

for (const w of warnings) console.warn(`warning: ${w}`);
if (errors.length) {
	for (const e of errors) console.error(e);
	console.error(`\n${errors.length} problem(s) — nothing merged.`);
	process.exit(1);
}
if (checkOnly) {
	console.log(`${files.length} module(s) check out: ${plan.length} quizzes.`);
	process.exit(0);
}

let sentences = 0;
let added = 0;
for (const { quiz, entry, kind } of plan) {
	if (kind === 'cloze') {
		for (const b of entry.blanks) {
			const gap = quiz.inlineBlanks[b.index];
			if (b.options) gap.options = b.options;
			gap.cue = b.cue;
			if (b.hint) gap.hint = b.hint;
			if (b.why) gap.why = b.why;
		}
		continue;
	}
	const byText = new Map(entry.sentences.map((s) => [s.sentence, s]));
	for (const sentence of quiz.sentences) {
		const s = byText.get(sentence.sentence);
		if (!s) continue; // one this file added on an earlier run
		if (s.options) sentence.options = s.options;
		if (s.english) sentence.english = s.english;
		if (s.hard) sentence.hard = true;
		else delete sentence.hard;
		if (s.keepCue) sentence.keepCue = true;
		else delete sentence.keepCue;
		sentences++;
	}
	// A drill whose subject labels each belong to one sentence (the label is
	// that sentence's own cue) has none that fits a new sentence: an added one
	// goes without, rather than show another sentence's label above it.
	const uses = new Map();
	for (const sentence of quiz.sentences) {
		if (addTexts(entry).has(sentence.sentence)) continue;
		uses.set(sentence.subjectKey, (uses.get(sentence.subjectKey) ?? 0) + 1);
	}
	const itemLabels = [...uses.values()].every((n) => n <= 1);
	// Re-running adds nothing twice: an added sentence is matched by its text.
	for (const a of entry.add ?? []) {
		const fresh = {
			subjectKey: itemLabels ? '' : (a.subjectKey ?? quiz.sentences[0].subjectKey),
			categoryLabel: a.categoryLabel,
			sentence: a.sentence,
			acceptedAnswers: a.acceptedAnswers,
			...(a.hint ? { hint: a.hint } : {}),
			english: a.english,
			options: a.options,
			hard: true,
			...(a.keepCue ? { keepCue: true } : {})
		};
		const at = quiz.sentences.findIndex((s) => s.sentence === a.sentence);
		if (at >= 0) quiz.sentences[at] = fresh;
		else {
			quiz.sentences.push(fresh);
			added++;
		}
	}
}

writeFileSync(bundlePath, JSON.stringify(bundle, null, 2) + '\n');
console.log(`${courseId}: ${plan.length} quizzes, ${sentences} sentences set, ${added} hard sentences added.`);
