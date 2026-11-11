#!/usr/bin/env node
// Tap-a-word in Turkish: the dictionary entries the A1–A2 German actually
// uses, in chunks for the translator.
//   node tool/turkish/dict-extract.mjs    writes tool/turkish/en/dictionary/part-NN.json
//                                          { "<de>|<pos>": "<English gloss>" }
// The translator writes tool/turkish/tr/dictionary/part-NN.json (same keys,
// Turkish gloss). `node tool/turkish/dict-build.mjs` merges them into
// assets/content/tr/dictionary.de.json, which the app reads in Turkish mode.
import { existsSync, mkdirSync, writeFileSync } from 'node:fs';
import { COURSE, LEVELS, levelName, readJson } from './lib.mjs';

const dict = readJson('assets/content/shared/dictionary/de.json');
const surfaces = new Map(Object.entries(dict.surfaces));
const bundle = readJson(`assets/content/courses/${COURSE}.json`);

const GERMAN = /^(de|sentence|acceptedAnswers|answer|options|passage|inlineTemplate|passageTitle|tiles|text|question|title|focus|values|cells|display|word|pl)$/;
const used = new Set();
const take = (s) => {
	for (const w of s.match(/\p{L}[\p{L}-]*/gu) ?? []) {
		const i = surfaces.get(w) ?? surfaces.get(w.toLowerCase()) ?? surfaces.get(w[0].toUpperCase() + w.slice(1));
		if (i !== undefined) used.add(i);
	}
};
const walk = (o, key = '') => {
	if (typeof o === 'string') {
		if (GERMAN.test(key)) take(o);
	} else if (Array.isArray(o)) o.forEach((v) => walk(v, key));
	else if (o && typeof o === 'object') for (const [k, v] of Object.entries(o)) walk(v, k);
};
for (const level of LEVELS) {
	for (const q of bundle.quizzes.filter((q) => q.level === levelName(level))) walk(q);
	const book = `assets/content/book2/${COURSE}/${level}.json`;
	if (existsSync(book)) walk(readJson(book));
}

const entries = [...used].sort((a, b) => a - b).map((i) => dict.entries[i]);
const out = {};
for (const e of entries) out[`${e.de}|${e.pos}`] = e.en;
const keys = Object.keys(out);
const SIZE = 350;
mkdirSync('tool/turkish/en/dictionary', { recursive: true });
for (let p = 0; p * SIZE < keys.length; p++) {
	const part = Object.fromEntries(keys.slice(p * SIZE, (p + 1) * SIZE).map((k) => [k, out[k]]));
	writeFileSync(`tool/turkish/en/dictionary/part-${String(p + 1).padStart(2, '0')}.json`, JSON.stringify(part, null, 1));
}
console.log(`${keys.length} entries used in A1–A2, ${Math.ceil(keys.length / SIZE)} parts`);
