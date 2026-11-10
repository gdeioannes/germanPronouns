#!/usr/bin/env node
// Merges per-sentence whys into a course bundle, after checking them.
//
// A fill-in drill shows the right answer after a miss; the why is the rule
// as applied to that gap, shown with it ("nach 'mit' always dative — der
// Tisch becomes dem Tisch"). It is authored per sub-level in
// assets/content/whys/<course>/<module>.json and folded in here:
//
//   node tool/apply-whys.mjs de_cert_a1 --check a1_1   # validate only
//   node tool/apply-whys.mjs de_cert_a1 a1_1 a1_2      # validate, then merge
//   node tool/apply-whys.mjs de_cert_a1                # every module
//   node tool/apply-whys.mjs de_cert_a1 --report       # coverage per level
//
// A module file is an array of entries:
//
//   { "id": "quest_a1_1_pronomen",
//     "whys": [ { "sentence": "<the existing sentence, verbatim>",
//                 "why": "one sentence: the rule, applied to this gap",
//                 "whyEn": "<the English, for quizzes whose help is German>" } ] }
//
// Rules the check enforces: every listed sentence exists in the quiz; no
// sentence is listed twice; a why is one short line (< 180 chars), never
// empty, and never a bare restating of the answer. A quiz whose help is
// German (B1 up) must give `whyEn` on every why.
//
// Idempotent: running it twice yields the same bundle.

import { readFileSync, writeFileSync, readdirSync, existsSync } from 'node:fs';
import { resolve, join } from 'node:path';

const MAX_WHY = 180;

const args = process.argv.slice(2);
const checkOnly = args.includes('--check');
const report = args.includes('--report');
const [courseId, ...modules] = args.filter((a) => !a.startsWith('--'));
if (!courseId) {
	console.error('usage: node tool/apply-whys.mjs <courseId> [--check|--report] [module ...]');
	process.exit(1);
}

const root = resolve(import.meta.dirname, '..');
const bundlePath = join(root, 'assets/content/courses', `${courseId}.json`);
const bundle = JSON.parse(readFileSync(bundlePath, 'utf8'));

if (report) {
	const by = {};
	for (const q of bundle.quizzes) {
		if (q.type !== 'fillBlank' || !q.sentences?.length) continue;
		const r = (by[q.level] ??= { sentences: 0, whys: 0 });
		r.sentences += q.sentences.length;
		r.whys += q.sentences.filter((s) => s.why).length;
	}
	for (const [level, r] of Object.entries(by))
		console.log(`${level}: ${r.whys}/${r.sentences} whys (${((100 * r.whys) / r.sentences).toFixed(1)}%)`);
	process.exit(0);
}

const whysDir = join(root, 'assets/content/whys', courseId);
if (!existsSync(whysDir)) {
	console.error(`no whys directory: ${whysDir}`);
	process.exit(1);
}

const files = (modules.length ? modules.map((m) => `${m}.json`) : readdirSync(whysDir))
	.filter((f) => f.endsWith('.json'))
	.sort();

const problems = [];
let set = 0;
for (const file of files) {
	const entries = JSON.parse(readFileSync(join(whysDir, file), 'utf8'));
	for (const entry of entries) {
		const quiz = bundle.quizzes.find((q) => q.id === entry.id);
		if (!quiz) {
			problems.push(`${file}: "${entry.id}" is not in the bundle`);
			continue;
		}
		const german = quiz.help?.german === true;
		const seen = new Set();
		for (const w of entry.whys ?? []) {
			const where = `${file} ${entry.id}: "${(w.sentence ?? '').slice(0, 40)}…"`;
			// A drill may pose the same sentence twice ("Heute ____." with two
			// answers): one entry explains them all, since the rule is the same.
			const targets = quiz.sentences?.filter((s) => s.sentence === w.sentence) ?? [];
			const target = targets[0];
			if (!target) {
				problems.push(`${where} — no such sentence (must match verbatim)`);
				continue;
			}
			if (seen.has(w.sentence)) problems.push(`${where} — listed twice`);
			seen.add(w.sentence);
			for (const [field, text] of [
				['why', w.why],
				['whyEn', w.whyEn]
			]) {
				if (text === undefined) continue;
				if (!String(text).trim()) problems.push(`${where} — empty ${field}`);
				if (String(text).length > MAX_WHY) problems.push(`${where} — ${field} over ${MAX_WHY} chars`);
				// A why that only restates the answer teaches nothing.
				const answer = String(target.acceptedAnswers?.[0] ?? '').toLowerCase();
				if (answer && String(text).trim().toLowerCase() === answer)
					problems.push(`${where} — ${field} is just the answer`);
			}
			if (german && w.why && !w.whyEn) problems.push(`${where} — German help needs whyEn`);
			if (checkOnly) continue;
			for (const t of targets) {
				t.why = w.why;
				if (w.whyEn) t.whyEn = w.whyEn;
				else delete t.whyEn;
				set++;
			}
		}
	}
}

if (problems.length) {
	for (const p of problems) console.error(p);
	process.exit(1);
}
if (checkOnly) {
	console.log(`${courseId}: ${files.join(', ')} — all good`);
	process.exit(0);
}
writeFileSync(bundlePath, JSON.stringify(bundle, null, 2) + '\n');
console.log(`${courseId}: ${set} whys set`);
