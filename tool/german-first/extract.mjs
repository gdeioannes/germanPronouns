#!/usr/bin/env node
// Writes the English still to be replaced, one file per quiz and per chapter:
//   tool/german-first/en/<level>/app/<quiz id>.json     { path: English }
//   tool/german-first/en/<level>/book/<chapter id>.json { path: English }
// Prints what has no German yet. usage: node tool/german-first/extract.mjs [level ...]
import { existsSync, mkdirSync, writeFileSync } from 'node:fs';
import { COURSE, LEVELS, PILOT_CHAPTER, PILOT_QUIZ, appStrings, bookStrings, readJson, words } from './lib.mjs';

const levels = process.argv.slice(2).length ? process.argv.slice(2) : LEVELS;
const dir = 'tool/german-first';
for (const level of levels) {
	const pending = { app: [], book: [] };
	const size = { app: 0, book: 0 };
	const save = (kind, id, strings) => {
		mkdirSync(`${dir}/en/${level}/${kind}`, { recursive: true });
		writeFileSync(`${dir}/en/${level}/${kind}/${id}.json`, JSON.stringify(strings, null, 1));
		if (!existsSync(`${dir}/de/${level}/${kind}/${id}.json`)) {
			pending[kind].push(id);
			size[kind] += Object.values(strings).reduce((n, s) => n + words(s), 0);
		}
	};
	for (const q of readJson(`assets/content/authoring/${COURSE}/${level}.json`).data) {
		const help = q.help ?? q.quiz?.help;
		// Once German, the English file already holds what it needs.
		if (help && q.id !== PILOT_QUIZ && !help.german) save('app', q.id, appStrings(help));
	}
	for (const c of readJson(`assets/content/book2/${COURSE}/${level}.json`).data.chapters) {
		if (c.id !== PILOT_CHAPTER && !c.german) save('book', c.id, bookStrings(c));
	}
	console.log(`${level}: app ${pending.app.length} left, ${size.app} words | book ${pending.book.length} left, ${size.book} words`);
}
