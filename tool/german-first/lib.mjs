// Shared by extract.mjs, apply.mjs: finds the prose that has to become German.
import { readFileSync, writeFileSync } from 'node:fs';

export const COURSE = 'de_cert_a1';
// A2.2 keeps its English; it gets the grammar-word lesson instead.
export const LEVELS = ['b1_1', 'b1_2', 'b2_1', 'b2_2', 'c1_1', 'c1_2', 'c2_1', 'c2_2'];
/** Done by hand first; their overlays do not exist and they are never extracted. */
export const PILOT_QUIZ = 'quest_b1_1_adj_bestimmt';
export const PILOT_CHAPTER = 'garten';

const EN = /\b(the|a|an|is|are|was|were|be|you|your|with|and|or|of|to|this|that|these|for|not|it|its|when|means?|from|by|on|at|in|as|but|if|then|after|before|here|has|have|can|one|two|word|verb|noun)\b/gi;
// Words spelled the same in both languages do not count as English on their own.
const SHARED = new Set(['in', 'an', 'was', 'also', 'hat', 'man', 'so', 'am', 'war']);
export const englishWords = (s) =>
	(s.replace(/\*[^*]*\*/g, ' ').match(EN) ?? []).filter((w) => !SHARED.has(w.toLowerCase())).length;
export const words = (s) => (s.match(/\S+/g) ?? []).length;

/** Every word the course's German uses: a word outside it, in a book string, may be English. */
let vocabulary;
function germanWords() {
	if (vocabulary) return vocabulary;
	vocabulary = new Set();
	const add = (t) => {
		for (const w of t.toLowerCase().match(/\p{L}+/gu) ?? []) vocabulary.add(w);
	};
	const walk = (o, key = '') => {
		if (typeof o === 'string') {
			if (/^(de|sentence|text|acceptedAnswers|answer|display|word)$/.test(key)) add(o);
		} else if (Array.isArray(o)) o.forEach((v) => walk(v, key));
		else if (o && typeof o === 'object') for (const [k, v] of Object.entries(o)) walk(v, k);
	};
	const { quizzes } = JSON.parse(readFileSync(`assets/content/courses/${COURSE}.json`, 'utf8'));
	for (const q of quizzes) {
		const { help, ...rest } = q;
		walk(rest);
		for (const t of help?.tips ?? []) walk(t.examples);
	}
	return vocabulary;
}
/** A word in this string that no German text in the course has ever used. */
const unknownWord = (s) => {
	const known = germanWords();
	return (s.replace(/\*[^*]*\*/g, ' ').match(/\p{L}{3,}/gu) ?? []).some((w, i) => {
		const lower = w.toLowerCase();
		return !known.has(lower) && (i === 0 || w === lower);
	});
};

export function readJson(path) {
	const raw = readFileSync(path, 'utf8');
	const indent = /\n\t["{[]/.test(raw) ? '\t' : /\n {4}["{[]/.test(raw) && !/\n {2}["{[]/.test(raw) ? 4 : 2;
	return { data: JSON.parse(raw), crlf: raw.includes('\r\n'), end: /\n$/.test(raw), indent };
}
export function writeJson(path, file) {
	let out = JSON.stringify(file.data, null, file.indent) + (file.end ? '\n' : '');
	if (file.crlf) out = out.replace(/\n/g, '\r\n');
	writeFileSync(path, out);
}

const parse = (path) => path.match(/[^.[\]]+/g).map((k) => (/^\d+$/.test(k) ? Number(k) : k));
export function getPath(o, path) {
	let at = o;
	for (const k of parse(path)) at = at?.[k];
	return at;
}
export function setPath(o, path, value) {
	const keys = parse(path);
	let at = o;
	for (const k of keys.slice(0, -1)) at = at[k];
	at[keys.at(-1)] = value;
}

function* leaves(o, path = '') {
	if (typeof o === 'string') yield [path, o];
	else if (Array.isArray(o)) for (let i = 0; i < o.length; i++) yield* leaves(o[i], `${path}[${i}]`);
	else if (o && typeof o === 'object')
		for (const [k, v] of Object.entries(o)) yield* leaves(v, path ? `${path}.${k}` : k);
}

/** Paths in a quiz's help that must come back in German. */
const REQUIRED = /^(hook|intro|recall\.(known|today)|remember\[\d+\]|tips\[\d+\]\.(title|text|trap|check\.why)|mistakes\[\d+\]\.why|exam)$/;
export const isRequired = (path) => REQUIRED.test(path);

/** The help prose of one quiz, as { path: English }. */
export function appStrings(help) {
	const out = {};
	for (const [p, s] of leaves(help)) {
		if (!s.trim()) continue;
		if (REQUIRED.test(p)) out[p] = s;
		else if (/^table\.(caption|columns\[\d+\]|rows\[\d+\]\.cells\[\d+\])/.test(p) && (englishWords(s) || unknownWord(s))) out[p] = s;
		else if (/^tips\[\d+\]\.visual\./.test(p) && !/\.(kind|de(\[\d+\])?|gender)$/.test(p) && !/\.hot/.test(p)) out[p] = s;
	}
	// A check whose options are English has to change as a whole.
	(help.tips ?? []).forEach((t, i) => {
		const opts = t.check?.options ?? [];
		if (opts.some((o) => englishWords(o) >= 1)) {
			out[`tips[${i}].check.q`] = t.check.q;
			opts.forEach((o, j) => (out[`tips[${i}].check.options[${j}]`] = o));
			out[`tips[${i}].check.answer`] = t.check.answer;
		}
	});
	return out;
}

const BOOK_SKIP = /(^|\.)(id|accent|image|de|pl|quiz|listenQuiz|speakQuiz|url|speakers?|gender|role|focus|photo|credit|file|src|license|author|tone|kind)(\[\d+\])?$|\.parts\[\d+\]\.text$/;

/** The English in one book chapter, as { path: English }. Word meanings stay. */
export function bookStrings(chapter) {
	const out = {};
	const { reading, ...rest } = chapter;
	const pick = (o, prefix) => {
		for (const [p, s] of leaves(o, prefix)) {
			if (!s.trim() || BOOK_SKIP.test(p)) continue;
			if (/\.en$/.test(p)) {
				if (p.startsWith('grammar') && words(s) >= 4) out[p] = s;
				continue;
			}
			if (englishWords(s) >= 1 || / · [a-z]/.test(s) || unknownWord(s)) out[p] = s;
		}
	};
	pick(rest, '');
	if (reading) {
		const { en, text, turns, lines, de, ...meta } = reading;
		pick(meta, 'reading');
	}
	return out;
}
