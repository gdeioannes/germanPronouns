#!/usr/bin/env node
// Folds the German in tool/german-first/de/<level>/ into the course, keeping the
// English of app explanations behind the English button (QuizHelp.*En).
// Idempotent. Validates everything first and writes nothing if a check fails.
//   node tool/german-first/apply.mjs b1_1          apply, then run apply-authoring
//   node tool/german-first/apply.mjs b1_1 --check  validate and report only
import { existsSync, readFileSync, readdirSync } from 'node:fs';
import { COURSE, englishWords, getPath, isRequired, readJson, setPath, words, writeJson } from './lib.mjs';

const [level, flag] = process.argv.slice(2);
if (!level) {
	console.error('usage: apply.mjs <level> [--check]');
	process.exit(1);
}
const check = flag === '--check';
const dir = 'tool/german-first';
const load = (p) => JSON.parse(readFileSync(p, 'utf8'));
const ids = (kind) => {
	const d = `${dir}/de/${level}/${kind}`;
	return existsSync(d)
		? readdirSync(d)
				.filter((f) => f.endsWith('.json'))
				.map((f) => f.slice(0, -5))
		: [];
};
const errors = [];
const flags = [];
const sentenceLengths = [];

function inspect(id, en, de, requireAll) {
	for (const key of Object.keys(de)) {
		// Any string of the quiz or chapter may be fixed; applying checks the path exists.
		if (typeof de[key] !== 'string' || !de[key].trim()) errors.push(`${id}: "${key}" is empty`);
	}
	if (requireAll) {
		for (const key of Object.keys(en)) {
			if (isRequired(key) && !(key in de)) errors.push(`${id}: "${key}" is missing`);
		}
	}
	for (const [key, text] of Object.entries(de)) {
		if (typeof text !== 'string') continue;
		if (englishWords(text) >= 3 && text === en[key] && isRequired(key)) flags.push(`${id} ${key}: unchanged English`);
		else if (englishWords(text) >= 4) flags.push(`${id} ${key}: looks English: ${text.slice(0, 70)}`);
		if (/[—–]/.test(text) && !/\d[–—]\d/.test(text)) flags.push(`${id} ${key}: long dash`);
		if ((text.match(/\*/g) ?? []).length % 2) errors.push(`${id} ${key}: unbalanced *`);
		for (const s of text.split(/(?<=[.!?])\s+/)) if (words(s) > 2) sentenceLengths.push(words(s));
	}
}

// ---- app
const appIds = ids('app');
if (appIds.length) {
	const path = `assets/content/authoring/${COURSE}/${level}.json`;
	const file = readJson(path);
	for (const id of appIds) {
		const entry = file.data.find((q) => q.id === id);
		if (!entry) {
			errors.push(`${id}: no such quiz`);
			continue;
		}
		const en = load(`${dir}/en/${level}/app/${id}.json`);
		const de = load(`${dir}/de/${level}/app/${id}.json`);
		inspect(id, en, de, true);
		const help = entry.help ?? entry.quiz.help;
		if (!help.german) {
			if (help.hook) help.hookEn = help.hook;
			if (help.intro) help.introEn = help.intro;
			if (help.remember) help.rememberEn = [...help.remember];
			if (help.recall) help.recallEn = { ...help.recall };
			if (help.exam) help.examEn = help.exam;
			for (const t of help.tips ?? []) {
				t.en = { text: t.text };
				if (t.title) t.en.title = t.title;
				if (t.trap) t.en.trap = t.trap;
				if (t.check?.why) t.check.whyEn = t.check.why;
			}
			for (const m of help.mistakes ?? []) if (m.why) m.whyEn = m.why;
			help.german = true;
		}
		for (const [key, text] of Object.entries(de)) {
			if (getPath(help, key) === undefined) errors.push(`${id}: "${key}" not in the quiz`);
			else setPath(help, key, text);
		}
		for (const t of help.tips ?? []) {
			if (t.check && !t.check.options?.includes(t.check.answer)) {
				errors.push(`${id}: answer "${t.check.answer}" not among the options`);
			}
		}
	}
	if (!check && !errors.length) writeJson(path, file);
}

// ---- book
const bookIds = ids('book');
if (bookIds.length) {
	const path = `assets/content/book2/${COURSE}/${level}.json`;
	const file = readJson(path);
	let en0 = 0;
	let de0 = 0;
	for (const id of bookIds) {
		const chapter = file.data.chapters.find((c) => c.id === id);
		if (!chapter) {
			errors.push(`book ${id}: no such chapter`);
			continue;
		}
		const en = load(`${dir}/en/${level}/book/${id}.json`);
		const de = load(`${dir}/de/${level}/book/${id}.json`);
		inspect(`book ${id}`, en, de, false);
		for (const [key, text] of Object.entries(de)) {
			if (getPath(chapter, key) === undefined) errors.push(`book ${id}: "${key}" not in the chapter`);
			else setPath(chapter, key, text);
			if (en[key]) {
				en0 += en[key].length;
				de0 += text.length;
			}
		}
		const answers = (o, at) => {
			if (Array.isArray(o)) o.forEach((v, i) => answers(v, `${at}[${i}]`));
			else if (o && typeof o === 'object') {
				if (Array.isArray(o.options) && typeof o.answer === 'string' && !o.options.includes(o.answer)) {
					errors.push(`book ${id}: ${at}: answer "${o.answer}" not among the options`);
				}
				for (const [k, v] of Object.entries(o)) answers(v, `${at}.${k}`);
			}
		};
		answers(chapter, 'chapter');
		chapter.german = true;
	}
	console.log(`book length, German against English: ${en0 ? Math.round((de0 / en0) * 100) : 0}%`);
	if (!check && !errors.length) writeJson(path, file);
}

const avg = sentenceLengths.length ? sentenceLengths.reduce((a, b) => a + b, 0) / sentenceLengths.length : 0;
const long = sentenceLengths.filter((n) => n > 20).length;
console.log(`${level}: ${appIds.length} quizzes, ${bookIds.length} chapters; sentences average ${avg.toFixed(1)} words, ${long} over 20`);
for (const f of flags.slice(0, 40)) console.log('  look:', f);
if (flags.length > 40) console.log(`  ... and ${flags.length - 40} more`);
if (errors.length) {
	for (const e of errors) console.error('  ERROR:', e);
	process.exit(1);
}
console.log(check ? 'checks pass, nothing written' : 'applied');
