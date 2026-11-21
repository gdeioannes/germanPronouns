#!/usr/bin/env node
// A vocabulary deck's intro states its size ("346 Karten, davon 180 Nomen" /
// "346 cards, 180 of them nouns"). The decks are rebuilt from the exercises
// (tool/build-vocabulary.mjs), so the numbers go stale. This puts the real
// counts back everywhere the sentence lives: the bundle, the authoring file
// and each second language's translation of the intro.
//
//   node tool/deck-counts.mjs de_cert_a1           fix
//   node tool/deck-counts.mjs de_cert_a1 --check   report only (exit 1 when stale)
//
// Afterwards: node tool/turkish/extract.mjs + build.mjs for every language.
import { existsSync, readFileSync, writeFileSync } from 'node:fs';

const [courseId = 'de_cert_a1'] = process.argv.slice(2).filter((a) => !a.startsWith('--'));
const check = process.argv.includes('--check');
const LANGS = ['tr', 'ar', 'uk', 'fr', 'es'];
const bundlePath = `assets/content/courses/${courseId}.json`;
const bundle = JSON.parse(readFileSync(bundlePath, 'utf8'));

const DE = /(\d+) Karten, davon (\d+) Nomen/;
const EN = /(\d+) cards, (\d+) of them nouns/;
let stale = 0;

/** Rewrites a file's raw text, so its formatting stays as it is. */
function patchRaw(path, from, to) {
	if (!existsSync(path)) return;
	const raw = readFileSync(path, 'utf8');
	if (!raw.includes(from)) return;
	writeFileSync(path, raw.split(from).join(to));
	console.log(`  ${path}`);
}

for (const deck of bundle.quizzes.filter((q) => q.type === 'vocabulary')) {
	const total = deck.cards.length;
	const nouns = deck.cards.filter((c) => c.kind === 'noun').length;
	const level = deck.level.toLowerCase().replace('.', '_');
	for (const key of ['intro', 'introEn']) {
		const text = deck.help?.[key];
		if (typeof text !== 'string') continue;
		const m = text.match(DE) ?? text.match(EN);
		if (!m || (Number(m[1]) === total && Number(m[2]) === nouns)) continue;
		stale++;
		const fixed = m[0].replace(m[1], String(total)).replace(new RegExp(`\\b${m[2]}\\b(?!.*\\b${m[2]}\\b)`), String(nouns));
		console.log(`${deck.id} ${key}: "${m[0]}" → "${fixed}"`);
		if (check) continue;
		deck.help[key] = text.replace(m[0], fixed);
		patchRaw(`assets/content/authoring/${courseId}/${level}.json`, m[0], fixed);
		// A translation keeps the two numbers as digits: swap them in the intro's line only.
		for (const l of LANGS) {
			const path = `tool/turkish/${l}/${level}/app/${deck.id}.json`;
			if (!existsSync(path)) continue;
			const raw = readFileSync(path, 'utf8');
			const data = JSON.parse(raw);
			const old = data[`help.${key}`];
			if (typeof old !== 'string') continue;
			const swapped = old.replace(new RegExp(`(?<!\\d)${m[1]}(?!\\d)`), String(total)).replace(new RegExp(`(?<!\\d)${m[2]}(?!\\d)`), String(nouns));
			if (swapped === old) {
				console.log(`  ! ${path}: numbers not found, fix by hand`);
				continue;
			}
			data[`help.${key}`] = swapped;
			const indent = raw.match(/\n([ \t]+)"/)?.[1] ?? ' ';
			writeFileSync(path, JSON.stringify(data, null, indent) + (raw.endsWith('\n') ? '\n' : ''));
			console.log(`  ${path}`);
		}
	}
}
if (!check && stale) writeFileSync(bundlePath, JSON.stringify(bundle, null, 2) + '\n');
console.log(stale ? `${stale} intro(s) ${check ? 'stale' : 'fixed'}` : 'all deck intros state the real counts');
if (check && stale) process.exit(1);
