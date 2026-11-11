// Shared by extract.mjs and build.mjs: finds the English that Turkish mode
// replaces, in the A1–A2 exercises (from the built course bundle, so it is
// exactly what the app shows) and in the A1–A2 books.
import { readFileSync } from 'node:fs';
import { englishWords, unknownWord, words } from '../german-first/lib.mjs';

export { words };
export const COURSE = 'de_cert_a1';

/**
 * The second language the tools work on: `--lang ar` (Turkish when left out).
 * Its sources live in tool/turkish/<lang>/, its overlays in assets/content/<lang>/.
 */
const langAt = process.argv.indexOf('--lang');
export const LANG = langAt >= 0 ? process.argv[langAt + 1] : 'tr';
if (!/^[a-z]{2}$/.test(LANG)) throw new Error(`--lang needs a two-letter code, got "${LANG}"`);
/** The command's arguments without flags and without the --lang value. */
export const plainArgs = () =>
	process.argv.slice(2).filter((a, i, all) => !a.startsWith('--') && all[i - 1] !== '--lang');
export const LEVELS = ['a1_1', 'a1_2', 'a2_1', 'a2_2'];
export const levelName = (id) => id.toUpperCase().replace('_', '.');
export const readJson = (p) => JSON.parse(readFileSync(p, 'utf8'));

/**
 * A key in a path: plain (`a.b`), or `["key"]` when the key itself holds a
 * dot or a bracket ("mein (my, Nom.)"). src/lib/i18n/content.svelte.ts reads both.
 */
export const join = (path, k) => (/[.[\]"]/.test(k) ? `${path}[${JSON.stringify(k)}]` : path ? `${path}.${k}` : k);

function* leaves(o, path = '', key = '') {
	if (typeof o === 'string') yield [path, o, key];
	else if (Array.isArray(o)) for (let i = 0; i < o.length; i++) yield* leaves(o[i], `${path}[${i}]`, key);
	else if (o && typeof o === 'object')
		for (const [k, v] of Object.entries(o)) yield* leaves(v, join(path, k), k);
}

/** Always the learner's language (English today). */
const EN_KEYS = new Set([
	'en', 'english', 'why', 'intro', 'hook', 'remember', 'trap', 'caption', 'explanation',
	'explanationSections', 'exam', 'known', 'today', 'note', 'hint', 'translation',
	'passageTranslation', 'questionTranslation', 'optionsTranslation', 'practisePoints',
	'priorityErrors', 'scoringCriteria', 'scoringNote', 'material', 'topic', 'sceneAlt',
	'imageDescription', 'q', 'subtitle', 'canDo', 'instructions', 'instruction', 'prompt',
	'task', 'meaning', 'gloss', 'lede', 'tip', 'summary', 'body', 'whyEn'
]);
/** German, or machinery: never translated. */
const NEVER = new Set([
	'id', 'image', 'storageKeyPrefix', 'type', 'level', 'covers', 'kind', 'gender', 'article',
	'plural', 'pl', 'focus', 'de', 'key', 'values', 'acceptedAnswers', 'accepted',
	'tiles', 'subjectKey', 'sourceQuizId', 'scene', 'mode', 'prep', 'color', 'game',
	'voiceGender', 'digital', 'time', 'passage', 'passageTitle', 'inlineTemplate',
	'targetVocabulary', 'cue', 'forms', 'result', 'role', 'question', 'promptLabel',
	'subjectsLabel', 'quiz', 'listenQuiz', 'speakQuiz', 'accent', 'world', 'url', 'photo',
	'credit', 'file', 'src', 'license', 'author', 'speaker', 'speakers', 'tone', 'audio', 'n',
	'hot', 'icon', 'status', 'version', 'spot'
]);

/** English (or mixed German · English) in a string under this key? */
function wanted(key, s) {
	if (!s.trim() || NEVER.has(key)) return false;
	if (/^[\d\s.,:;·–—\-+=/()%€?!]*$/.test(s)) return false;
	if (EN_KEYS.has(key)) return true;
	return englishWords(s) >= 1 || unknownWord(s) || / · [a-z]/.test(s) || /\((I|you|he|she|it|we|they)\b/.test(s);
}

/**
 * A multiple choice whose options are partly English must change as a whole:
 * once one option (or its question) is picked up, every option and the answer
 * go along, so the translator sees and translates the set together.
 */
function completeChoices(o, out, path = '') {
	if (Array.isArray(o)) return o.forEach((v, i) => completeChoices(v, out, `${path}[${i}]`));
	if (!o || typeof o !== 'object') return;
	const at = (k) => join(path, k);
	if (Array.isArray(o.options) && o.options.every((x) => typeof x === 'string')) {
		const opt = (i) => `${at("options")}[${i}]`;
		const picked = o.options.some((_, i) => opt(i) in out);
		if (picked) {
			o.options.forEach((x, i) => (out[opt(i)] = x));
			if (typeof o.answer === 'string') out[at('answer')] = o.answer;
		}
	}
	for (const [k, v] of Object.entries(o)) completeChoices(v, out, at(k));
}

/**
 * A table (`head` + `rows`) changes by column: the column its head marks
 * `en: true`, or any column with two English cells already picked, goes in
 * whole ("my", "her", "our" have no stop-word of their own); and once one
 * head cell is picked, every head cell goes, so the translator sees the set.
 */
function completeTables(o, out, path = '') {
	if (Array.isArray(o)) return o.forEach((v, i) => completeTables(v, out, `${path}[${i}]`));
	if (!o || typeof o !== 'object') return;
	const at = (k) => join(path, k);
	if (Array.isArray(o.rows) && o.rows.every((r) => Array.isArray(r))) {
		const cell = (i, j) => `${at('rows')}[${i}][${j}]`;
		const width = Math.max(0, ...o.rows.map((r) => r.length));
		const head = Array.isArray(o.head) ? o.head : [];
		const headText = (j) => (typeof head[j] === 'string' ? `${at('head')}[${j}]` : `${at('head')}[${j}].text`);
		for (let j = 0; j < width; j++) {
			const picked = o.rows.filter((r, i) => cell(i, j) in out).length;
			if (head[j]?.en === true || picked >= 2)
				o.rows.forEach((r, i) => typeof r[j] === 'string' && r[j].trim() && (out[cell(i, j)] = r[j]));
		}
		if (head.some((_, j) => headText(j) in out))
			head.forEach((h, j) => {
				const text = typeof h === 'string' ? h : h?.text;
				if (typeof text === 'string' && text.trim()) out[headText(j)] = text;
			});
	}
	for (const [k, v] of Object.entries(o)) completeTables(v, out, at(k));
}

/**
 * Book blocks whose short English has no stop-word to give it away: a tile's
 * `word` (the gloss of its German `big`: helfen → "help"), a block's bare
 * string `head` cells ("first", "past form") and a block's `title`
 * ("In order", "Who first?"). German ones come back unchanged.
 */
function completeBookBlocks(o, out, path = '') {
	if (Array.isArray(o)) return o.forEach((v, i) => completeBookBlocks(v, out, `${path}[${i}]`));
	if (!o || typeof o !== 'object') return;
	const at = (k) => join(path, k);
	if (typeof o.big === 'string' && typeof o.word === 'string' && o.word.trim()) out[at('word')] = o.word;
	if (o.kind && typeof o.title === 'string' && o.title.trim()) out[at('title')] = o.title;
	if (o.kind && Array.isArray(o.head))
		o.head.forEach((h, j) => typeof h === 'string' && h.trim() && (out[`${at('head')}[${j}]`] = h));
	for (const [k, v] of Object.entries(o)) completeBookBlocks(v, out, at(k));
}

/** { path: English } for one quiz of the built bundle. */
export function quizStrings(quiz) {
	const out = {};
	const { title, ...rest } = quiz;
	for (const [p, s, k] of leaves(rest)) if (wanted(k, s)) out[p] = s;
	completeChoices(rest, out);
	completeTables(rest, out);
	if (title && englishWords(title) >= 1) out.title = title;
	return out;
}

/** { path: English } for one book chapter, word meanings and reading translations included. */
export function chapterStrings(chapter) {
	const out = {};
	for (const [p, s, k] of leaves(chapter)) if (wanted(k, s)) out[p] = s;
	completeChoices(chapter, out);
	completeTables(chapter, out);
	completeBookBlocks(chapter, out);
	return out;
}

/** The book's own lines outside the chapters (title, subtitle, front matter). */
export function bookFrontStrings(book) {
	const out = {};
	const { chapters, _comment, names, ...rest } = book;
	for (const [p, s, k] of leaves(rest)) if (wanted(k, s)) out[p] = s;
	return out;
}
