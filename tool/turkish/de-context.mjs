#!/usr/bin/env node
// The German beside each English line of a B1–C2 quiz's button layer, for the
// translator: an example's or a card's `en` is a translation of its `de`, so
// the French is best made from the German.
//   node tool/turkish/de-context.mjs <quiz id>      { path: German }
import { COURSE, readJson } from './lib.mjs';

const id = process.argv[2];
const quiz = readJson(`assets/content/courses/${COURSE}.json`).quizzes.find((q) => q.id === id);
if (!quiz) throw new Error(`no quiz ${id}`);
const out = {};
(function walk(o, path) {
	if (Array.isArray(o)) return o.forEach((v, i) => walk(v, `${path}[${i}]`));
	if (!o || typeof o !== 'object') return;
	if (typeof o.en === 'string' && typeof o.de === 'string') out[`${path}.en`] = o.de;
	for (const [k, v] of Object.entries(o)) walk(v, path ? `${path}.${k}` : k);
})(quiz, '');
console.log(JSON.stringify(out, null, 1));
