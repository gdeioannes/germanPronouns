// The study notes as a lesson: the quiz's Help Memory cut into one idea per
// screen, with a question after each rule — so the notes are worked through
// before the drill, not scrolled past on the way to it.
//
// Pure: it decides the steps and the checks; Lesson.svelte draws them. Every
// shuffle is seeded by the quiz id, so the prerendered page and the browser
// agree on the order of the answers.

import type { Example, HelpTable, HelpTip, HelpVocab, Quiz } from '$lib/content/types';
import { helpTableFor, type HelpTable as DerivedTable } from './help-table';
import type { VocabEntry } from './vocab';

/**
 * Whether a quiz opens on the lesson instead of the study-notes panel. The
 * `hook` is the switch: a quiz's notes are rewritten for the lesson (hook,
 * a check per rule, highlighted examples) module by module, and the ones not
 * yet rewritten keep the panel.
 */
export function hasLesson(quiz: Quiz): boolean {
	return !!quiz.help?.hook && !!quiz.help.tips?.length;
}

/** One multiple-choice question, ready to draw. */
export interface LessonCheck {
	/** Small caps above the question — what kind of check this is. */
	eyebrow: string;
	question: string;
	/** German to play before answering, for a listening check. */
	listen?: string;
	options: string[];
	answer: string;
	why?: string;
	/** Whether the options are German (set in the serif, read aloud on tap). */
	germanOptions: boolean;
}

export interface LessonWord {
	de: string;
	article?: string;
	plural?: string;
	en: string;
	gender?: string;
}

export type LessonStep =
	| { kind: 'hook'; label: string; hook: string; more?: string; roadmap: string[] }
	| { kind: 'rule'; label: string; tip: HelpTip; number: number; of: number }
	| { kind: 'check'; label: string; check: LessonCheck }
	| { kind: 'words'; label: string; words: LessonWord[] }
	| { kind: 'context'; label: string; context: Example }
	| { kind: 'recap'; label: string; points: string[]; remember: string[]; table?: HelpTable; derived?: DerivedTable; exam?: string };

const ARTICLE_GENDER: Record<string, string> = { der: 'm', die: 'f', das: 'n' };

/** A small deterministic hash: the same quiz always deals the same order. */
function hash(text: string): number {
	let h = 2166136261;
	for (let i = 0; i < text.length; i++) {
		h ^= text.charCodeAt(i);
		h = Math.imul(h, 16777619);
	}
	return h >>> 0;
}

/** Fisher–Yates driven by a seeded LCG, so a shuffle is stable per seed. */
export function seededShuffle<T>(items: readonly T[], seed: string): T[] {
	const out = [...items];
	let s = hash(seed) || 1;
	for (let i = out.length - 1; i > 0; i--) {
		s = (Math.imul(s, 1664525) + 1013904223) >>> 0;
		const j = s % (i + 1);
		[out[i], out[j]] = [out[j], out[i]];
	}
	return out;
}

/** A seeded source in [0, 1), for code that takes a `random` function. */
export function seededRandom(seed: string): () => number {
	let s = hash(seed) || 1;
	return () => {
		s = (Math.imul(s, 1664525) + 1013904223) >>> 0;
		return s / 4294967296;
	};
}

/** The first sentence of a paragraph — the fallback when no hook is authored. */
export function firstSentence(text: string): string {
	const match = text.match(/^.+?[.!?](?=\s+[A-Z„"']|$)/s);
	return (match ? match[0] : text).trim();
}

/**
 * The words a learner should hear and see. Authored vocab wins; text quizzes
 * fall back to the nouns found in their passage.
 */
function wordsFor(quiz: Quiz, derived?: VocabEntry[]): LessonWord[] {
	const authored: HelpVocab[] = quiz.help?.vocab ?? [];
	if (authored.length) {
		return authored.map((w) => ({
			de: w.de,
			article: w.article,
			plural: w.plural,
			en: w.en,
			gender: w.article ? ARTICLE_GENDER[w.article] : undefined
		}));
	}
	return (derived ?? []).map((w) => ({ de: w.noun, article: w.article, en: w.english, gender: w.gender }));
}

/** What a word tile (and the listening check) says aloud: the noun with its article. */
export function spokenWord(w: LessonWord): string {
	return speakable(w.article ? `${w.article} ${w.de}` : w.de);
}

/** Stress written in capitals: GUten, WOher, SIEBzehn. */
const STRESS_MARK = /^[A-ZÄÖÜ]{2,}[a-zäöüß]+$/;

/**
 * A line of teaching German as it should be heard. The notes write for the
 * eye — plural notation (¨-er), arrows, slashes between alternatives, stress
 * in capitals, an English stage note in brackets — and a voice would read
 * every mark. The screen keeps the original; only the speech is cleaned.
 */
export function speakable(text: string): string {
	let t = text
		// "(to a child)" is a note for the reader; "(fährt)" is another form.
		.replace(/\s*\(([^)]*)\)/g, (_, inner: string) => (/\s/.test(inner.trim()) ? '' : `, ${inner}`))
		// Plural notation after a noun: "der Apfel, ¨- →", "das Buch, ¨-er".
		.replace(/,\s*¨?-[a-zäöüß]*(?=\s|$)/g, '')
		.replace(/\s*(→|=|\+|\/)\s*/g, ', ')
		.replace(/['‘’]/g, '')
		.replace(/(\p{L})-(?=\s|$)/gu, '$1');
	const words = t.split(/(\s+)/);
	// Capitals as stress only when the line marks stress at all — "USA" stays.
	if (words.some((w) => STRESS_MARK.test(w.replace(/[^\p{L}]/gu, '')))) {
		t = words
			.map((w) =>
				w.replace(/\p{L}+/gu, (word) =>
					/^[A-ZÄÖÜ]{2,}/.test(word) ? word[0] + word.slice(1).toLowerCase() : word
				)
			)
			.join('');
	}
	return t.replace(/\s*,\s*,/g, ',').replace(/^[,\s]+/, '').trim();
}

/**
 * Every piece of German a lesson reads aloud, for the audio pre-recording
 * (audio/spoken-texts) — derived from the steps, as the view speaks them.
 */
export function lessonSpokenTexts(steps: LessonStep[]): string[] {
	return steps.flatMap((s) => {
		switch (s.kind) {
			case 'rule':
				return (s.tip.examples ?? []).map((ex) => speakable(ex.de));
			case 'words':
				return s.words.map(spokenWord);
			case 'check':
				return s.check.listen ? [s.check.listen] : [];
			case 'context':
				return [speakable(s.context.de)];
			default:
				return [];
		}
	});
}

/**
 * A listening check built from the word list: hear one word, pick what it
 * means. Needs four words with distinct meanings to make three fair
 * distractors.
 */
export function listeningCheck(words: LessonWord[], seed: string): LessonCheck | null {
	const byMeaning = new Map<string, LessonWord>();
	for (const w of words) if (!byMeaning.has(w.en)) byMeaning.set(w.en, w);
	const pool = [...byMeaning.values()];
	if (pool.length < 4) return null;
	const [target, ...rest] = seededShuffle(pool, `${seed}:listen`);
	const options = seededShuffle([target.en, ...rest.slice(0, 3).map((w) => w.en)], `${seed}:listen-options`);
	const spoken = spokenWord(target);
	return {
		eyebrow: 'Listen',
		question: 'Play it, then pick what you heard.',
		listen: spoken,
		options,
		answer: target.en,
		why: `${spoken} — ${target.en}.`,
		germanOptions: false
	};
}

/** The lesson's steps for a quiz, in teaching order. */
export function buildLesson(quiz: Quiz, derivedVocab?: VocabEntry[]): LessonStep[] {
	const help = quiz.help ?? {};
	const tips = help.tips ?? [];
	const steps: LessonStep[] = [];

	// 1 · The idea, in one line, and the map of what follows.
	const hook = help.hook ?? (help.intro ? firstSentence(help.intro) : quiz.title);
	steps.push({
		kind: 'hook',
		label: 'The idea',
		hook,
		more: help.intro && help.intro !== hook ? help.intro : undefined,
		roadmap: tips.map((t) => t.title ?? firstSentence(t.text))
	});

	// 2 · One rule per screen, each followed by its check.
	tips.forEach((tip, i) => {
		steps.push({ kind: 'rule', label: tip.title ?? `Rule ${i + 1}`, tip, number: i + 1, of: tips.length });
		if (tip.check && tip.check.options.includes(tip.check.answer)) {
			steps.push({
				kind: 'check',
				label: 'Quick check',
				check: {
					eyebrow: 'Quick check',
					question: tip.check.q,
					options: seededShuffle(tip.check.options, `${quiz.id}:${i}`),
					answer: tip.check.answer,
					why: tip.check.why,
					germanOptions: true
				}
			});
		}
	});

	// 3 · The words, then hear one and say what it means.
	const words = wordsFor(quiz, derivedVocab);
	if (words.length) {
		steps.push({ kind: 'words', label: 'Words', words });
		const listen = listeningCheck(words, quiz.id);
		if (listen) steps.push({ kind: 'check', label: 'Listen', check: listen });
	}

	// 4 · The structure in a real exchange.
	if (help.context) steps.push({ kind: 'context', label: 'In context', context: help.context });

	// 5 · The mistakes English speakers make, as "which one is right?".
	(help.mistakes ?? []).forEach((m, i) => {
		steps.push({
			kind: 'check',
			label: 'Spot the mistake',
			check: {
				eyebrow: 'Spot the mistake',
				question: 'Which one is right?',
				options: seededShuffle([m.wrong, m.right], `${quiz.id}:mistake:${i}`),
				answer: m.right,
				why: m.why,
				germanOptions: true
			}
		});
	});

	// 6 · The cheat sheet: every rule in a line, the memory aids, the table.
	// The grid's own table is left out when the word list already showed the
	// same forms (a word list and a two-column table of it say one thing twice).
	const derived = help.table ? undefined : (helpTableFor(quiz) ?? undefined);
	const derivedRepeatsWords = !!derived && derived.columns.length === 1 && words.length > 0;
	steps.push({
		kind: 'recap',
		label: 'Cheat sheet',
		points: tips.map((t) => t.title ?? firstSentence(t.text)),
		remember: help.remember ?? [],
		table: help.table,
		derived: derivedRepeatsWords ? undefined : derived,
		exam: help.exam
	});

	return steps;
}

/**
 * Splits a German sentence around its focus words so the view can mark them.
 * Whole words only, case-sensitive — `ein` must not light up inside `eine`.
 */
export function splitFocus(text: string, focus: readonly string[] | undefined): { text: string; hit: boolean }[] {
	if (!focus?.length) return [{ text, hit: false }];
	// Plain string search with one shared boundary test: building a unicode
	// regex per call costs about a millisecond, and every example calls this.
	const words = [...new Set(focus)].filter(Boolean).sort((a, b) => b.length - a.length);
	const hits: [number, number][] = [];
	for (const word of words) {
		for (let at = text.indexOf(word); at !== -1; at = text.indexOf(word, at + 1)) {
			const end = at + word.length;
			if (isWordChar(text[at - 1]) || isWordChar(text[end])) continue;
			// Longer words were placed first; a shorter one inside them loses.
			if (hits.some(([s, e]) => at < e && end > s)) continue;
			hits.push([at, end]);
		}
	}
	hits.sort((a, b) => a[0] - b[0]);
	const parts: { text: string; hit: boolean }[] = [];
	let last = 0;
	for (const [start, end] of hits) {
		if (start > last) parts.push({ text: text.slice(last, start), hit: false });
		parts.push({ text: text.slice(start, end), hit: true });
		last = end;
	}
	if (last < text.length) parts.push({ text: text.slice(last), hit: false });
	return parts;
}

const WORD_CHAR = /[\p{L}\p{N}]/u;
function isWordChar(ch: string | undefined): boolean {
	return ch !== undefined && WORD_CHAR.test(ch);
}
