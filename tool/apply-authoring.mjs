#!/usr/bin/env node
// Merges authored Help Memory content into a course bundle.
//
// The bundle (assets/content/courses/<id>.json) is the single source of truth
// the app reads, but at ~1 MB it is not a file a person authors in. So the
// authoring lives in assets/content/authoring/<course>/<module>.json — one
// file per sub-level, one entry per quiz — and this script folds it in:
//
//   node tool/apply-authoring.mjs de_cert_a1            # every module
//   node tool/apply-authoring.mjs de_cert_a1 a1_1 a1_2  # named modules
//
// An authoring entry is `{ id, help?, covers?, status?, title?, quiz? }`:
//   - `help`, `covers`, `status`, `title` are set on the existing quiz;
//   - `quiz` is a whole new quiz object, inserted `after` the id named in
//     `after` (or appended to its level); its `help` may also be given at the
//     top level of the entry.
// Existing sentences, subjects and everything else on a quiz are untouched.
//
// Idempotent: running it twice yields the same bundle.

import { readFileSync, writeFileSync, readdirSync, existsSync } from 'node:fs';
import { resolve, join } from 'node:path';

const [courseId, ...modules] = process.argv.slice(2);
if (!courseId) {
	console.error('usage: node tool/apply-authoring.mjs <courseId> [module ...]');
	process.exit(1);
}

const root = resolve(import.meta.dirname, '..');
const bundlePath = join(root, 'assets/content/courses', `${courseId}.json`);
const authoringDir = join(root, 'assets/content/authoring', courseId);
if (!existsSync(authoringDir)) {
	console.error(`no authoring directory: ${authoringDir}`);
	process.exit(1);
}

const bundle = JSON.parse(readFileSync(bundlePath, 'utf8'));
const files = (modules.length ? modules.map((m) => `${m}.json`) : readdirSync(authoringDir))
	.filter((f) => f.endsWith('.json'))
	.sort();

let set = 0;
let added = 0;
for (const file of files) {
	const entries = JSON.parse(readFileSync(join(authoringDir, file), 'utf8'));
	for (const entry of entries) {
		let quiz = bundle.quizzes.find((q) => q.id === entry.id);
		if (!quiz) {
			if (!entry.quiz) {
				console.error(`${file}: "${entry.id}" is not in the bundle and has no "quiz" to add`);
				process.exit(1);
			}
			quiz = { id: entry.id, ...entry.quiz };
			if (!quiz.storageKeyPrefix) quiz.storageKeyPrefix = `${entry.id}_`;
			const after = entry.after ? bundle.quizzes.findIndex((q) => q.id === entry.after) : -1;
			if (after >= 0) bundle.quizzes.splice(after + 1, 0, quiz);
			else {
				// Append at the end of its level, keeping the chain ordered by level.
				const lastOfLevel = bundle.quizzes.map((q) => q.level).lastIndexOf(quiz.level);
				bundle.quizzes.splice(lastOfLevel + 1, 0, quiz);
			}
			added++;
		}
		if (entry.help) quiz.help = { ...(quiz.help ?? {}), ...entry.help };
		if (entry.covers) quiz.covers = entry.covers;
		if (entry.title) quiz.title = entry.title;
		if (entry.status === 'live') delete quiz.status;
		else if (entry.status) quiz.status = entry.status;
		set++;
	}
}

writeFileSync(bundlePath, JSON.stringify(bundle, null, 2) + '\n');
console.log(`${courseId}: ${set} quizzes updated, ${added} added — ${bundle.quizzes.length} total`);
