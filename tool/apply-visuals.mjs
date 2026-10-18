#!/usr/bin/env node
// Folds lesson diagrams into the authoring files.
//
// The diagrams are written per sub-level in assets/content/visuals/<course>/
// <module>.json as `{ "<quizId>": { "<tipIndex or tip title>": visual } }`,
// apart from the much larger lesson prose, so a level's pictures can be
// reviewed in one file. This script stamps each one onto its rule card in
// assets/content/authoring/<course>/<module>.json (`tips[i].visual`); run
// tool/apply-authoring.mjs afterwards to carry them into the bundle.
//
//   node tool/apply-visuals.mjs de_cert_a1            # every module
//   node tool/apply-visuals.mjs de_cert_a1 a1_1       # one module
//
// A key that names no quiz or no tip fails loudly. Idempotent.

import { readFileSync, writeFileSync, readdirSync, existsSync } from 'node:fs';
import { join, resolve } from 'node:path';

const [courseId, ...modules] = process.argv.slice(2);
if (!courseId) {
	console.error('usage: node tool/apply-visuals.mjs <courseId> [module ...]');
	process.exit(1);
}
const root = resolve(import.meta.dirname, '..');
const visualsDir = join(root, 'assets/content/visuals', courseId);
const authoringDir = join(root, 'assets/content/authoring', courseId);
if (!existsSync(visualsDir)) {
	console.error(`no visuals directory: ${visualsDir}`);
	process.exit(1);
}

const files = (modules.length ? modules.map((m) => `${m}.json`) : readdirSync(visualsDir)).filter((f) => f.endsWith('.json')).sort();
let stamped = 0;
let failed = false;
for (const file of files) {
	const visuals = JSON.parse(readFileSync(join(visualsDir, file), 'utf8'));
	const path = join(authoringDir, file);
	const raw = readFileSync(path, 'utf8');
	// Keep the file's own indentation, so a diff shows only the diagrams.
	const indent = raw.match(/^\[\r?\n([ \t]+)/)?.[1] ?? '  ';
	const entries = JSON.parse(raw);
	// Start clean: a diagram removed from the visuals file leaves the lesson.
	for (const e of entries) for (const t of e.help?.tips ?? []) delete t.visual;
	for (const [quizId, byTip] of Object.entries(visuals)) {
		if (quizId.startsWith('//')) continue;
		const entry = entries.find((e) => e.id === quizId);
		const tips = entry?.help?.tips ?? entry?.quiz?.help?.tips;
		if (!tips) {
			console.error(`${file}: no quiz "${quizId}" with tips`);
			failed = true;
			continue;
		}
		for (const [key, visual] of Object.entries(byTip)) {
			const index = /^\d+$/.test(key) ? Number(key) : tips.findIndex((t) => t.title === key);
			if (!tips[index]) {
				console.error(`${file}: ${quizId} has no tip "${key}"`);
				failed = true;
				continue;
			}
			tips[index].visual = visual;
			stamped++;
		}
	}
	writeFileSync(path, JSON.stringify(entries, null, indent) + '\n');
}
if (failed) process.exit(1);
console.log(`${courseId}: ${stamped} diagrams stamped across ${files.length} module(s)`);
