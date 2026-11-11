#!/usr/bin/env node
// Writes the English Turkish mode replaces, one file per exercise and chapter:
//   tool/turkish/en/<level>/app/<quiz id>.json      { path: English }
//   tool/turkish/en/<level>/book/<chapter id>.json  { path: English }
//   tool/turkish/en/<level>/book/_front.json
// The translator writes tool/turkish/tr/<level>/... with the same names and
// keys. Prints what has no Turkish yet (resumable).
//   node tool/turkish/extract.mjs [a1_1 ...]
import { existsSync, mkdirSync, writeFileSync } from 'node:fs';
import { COURSE, LEVELS, bookFrontStrings, chapterStrings, levelName, quizStrings, readJson, words } from './lib.mjs';

const levels = process.argv.slice(2).length ? process.argv.slice(2) : LEVELS;
const dir = 'tool/turkish';
const bundle = readJson(`assets/content/courses/${COURSE}.json`);

for (const level of levels) {
	const pending = { app: [], book: [] };
	const size = { app: 0, book: 0 };
	const save = (kind, id, strings) => {
		if (!Object.keys(strings).length) return;
		mkdirSync(`${dir}/en/${level}/${kind}`, { recursive: true });
		writeFileSync(`${dir}/en/${level}/${kind}/${id}.json`, JSON.stringify(strings, null, 1));
		if (!existsSync(`${dir}/tr/${level}/${kind}/${id}.json`)) {
			pending[kind].push(id);
			size[kind] += Object.values(strings).reduce((n, s) => n + words(s), 0);
		}
	};
	for (const q of bundle.quizzes.filter((q) => q.level === levelName(level))) save('app', q.id, quizStrings(q));
	// The level page's syllabus card (what you can do after it, its themes).
	const syllabus = readJson(`assets/content/syllabus/${COURSE}.json`).modules.find((m) => m.level === levelName(level));
	if (syllabus) {
		const { level: _l, title: _t, complete: _c, ...rest } = syllabus;
		save('app', '_syllabus', quizStrings({ id: '_syllabus', ...rest }));
	}
	const bookPath = `assets/content/book2/${COURSE}/${level}.json`;
	if (existsSync(bookPath)) {
		const book = readJson(bookPath);
		save('book', '_front', bookFrontStrings(book));
		for (const c of book.chapters) save('book', c.id, chapterStrings(c));
	}
	console.log(`${level}: app ${pending.app.length} left, ${size.app} words | book ${pending.book.length} left, ${size.book} words`);
}
