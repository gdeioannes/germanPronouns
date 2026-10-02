import { describe, expect, it } from 'vitest';
import course from '$content/courses/de_cert_a1.json';
import type { Quiz } from '$lib/content/types';
import { buildLesson, firstSentence, hasLesson, seededShuffle, speakable, splitFocus } from './lesson';

const quizzes = (course as unknown as { quizzes: Quiz[] }).quizzes;
const zahlen = quizzes.find((q) => q.id === 'quest_a1_1_zahlen')!;

describe('lesson', () => {
	it('is on for quizzes whose notes have a hook, and off for the rest', () => {
		expect(hasLesson(zahlen)).toBe(true);
		const withoutHook = { ...zahlen, help: { ...zahlen.help, hook: undefined } } as Quiz;
		expect(hasLesson(withoutHook)).toBe(false);
	});

	it('every lesson quiz has a check on every rule', () => {
		for (const q of quizzes.filter(hasLesson)) {
			for (const tip of q.help?.tips ?? []) {
				expect(tip.check, `${q.id}: "${tip.title}" has no check`).toBeTruthy();
			}
		}
	});

	it('teaches in order: idea, each rule then its check, words, context, mistakes, cheat sheet', () => {
		const kinds = buildLesson(zahlen).map((s) => s.kind);
		expect(kinds[0]).toBe('hook');
		expect(kinds.at(-1)).toBe('recap');
		// Every authored rule check sits straight after its rule.
		kinds.forEach((k, i) => {
			if (k === 'rule') expect(kinds[i + 1]).toBe('check');
		});
		expect(kinds.indexOf('words')).toBeGreaterThan(kinds.lastIndexOf('rule'));
		expect(kinds.filter((k) => k === 'check').length).toBe(
			3 + 1 + (zahlen.help?.mistakes?.length ?? 0)
		);
	});

	it('opens on the authored hook and keeps the intro behind it', () => {
		const [hook] = buildLesson(zahlen);
		expect(hook.kind === 'hook' && hook.hook).toBe(zahlen.help?.hook);
		expect(hook.kind === 'hook' && hook.more).toBe(zahlen.help?.intro);
	});

	it('deals the same answer order every time, with the answer among the options', () => {
		const a = buildLesson(zahlen);
		const b = buildLesson(zahlen);
		expect(a).toEqual(b);
		for (const s of a) {
			if (s.kind !== 'check') continue;
			expect(s.check.options).toContain(s.check.answer);
			expect(new Set(s.check.options).size).toBe(s.check.options.length);
		}
	});

	it('leaves out the grid table when the word list already shows those forms', () => {
		const recap = buildLesson(zahlen).at(-1)!;
		expect(recap.kind === 'recap' && recap.derived).toBeUndefined();
	});
});

describe('splitFocus', () => {
	it('marks whole words only', () => {
		const parts = splitFocus('ein Apfel, eine Banane, ein Brot', ['ein']);
		expect(parts.filter((p) => p.hit).map((p) => p.text)).toEqual(['ein', 'ein']);
		expect(parts.map((p) => p.text).join('')).toBe('ein Apfel, eine Banane, ein Brot');
	});

	it('prefers the longer of two overlapping focus words', () => {
		const parts = splitFocus('eine Banane', ['ein', 'eine']);
		expect(parts[0]).toEqual({ text: 'eine', hit: true });
	});

	it('passes text through untouched without focus words', () => {
		expect(splitFocus('Hallo', undefined)).toEqual([{ text: 'Hallo', hit: false }]);
	});
});

describe('speakable', () => {
	it.each([
		['Wie heißt du? (to a child)', 'Wie heißt du?'],
		['Kommst du nicht? – Doch! (Yes, I am!)', 'Kommst du nicht? – Doch!'],
		['fahren (fährt)', 'fahren, fährt'],
		['der Apfel, ¨- → die Äpfel', 'der Apfel, die Äpfel'],
		['das Buch, ¨-er → die Bücher', 'das Buch, die Bücher'],
		['der Tisch → die Tische; der Hund → die Hunde', 'der Tisch, die Tische; der Hund, die Hunde'],
		['der Großvater / Opa', 'der Großvater, Opa'],
		['der Hund + die Hütte = die Hundehütte', 'der Hund, die Hütte, die Hundehütte'],
		['GUten TAG! – Ich HEIße Anna.', 'Guten Tag! – Ich Heiße Anna.'],
		['SIEBzehn, VIERzig', 'Siebzehn, Vierzig'],
		['Er kommt aus den USA.', 'Er kommt aus den USA.'],
		['Doppel-', 'Doppel'],
		["Woher kommt Max? → '… komme aus England.'", 'Woher kommt Max?, … komme aus England.'],
		['Meine Telefonnummer ist null-eins-sieben-drei.', 'Meine Telefonnummer ist null-eins-sieben-drei.']
	])('%s', (input, spoken) => {
		expect(speakable(input)).toBe(spoken);
	});
});

describe('helpers', () => {
	it('seededShuffle is a stable permutation', () => {
		const items = ['a', 'b', 'c', 'd'];
		expect(seededShuffle(items, 'x')).toEqual(seededShuffle(items, 'x'));
		expect([...seededShuffle(items, 'x')].sort()).toEqual(items);
	});

	it('firstSentence stops at the first full stop before a new sentence', () => {
		expect(firstSentence('One idea. Then more.')).toBe('One idea.');
		expect(firstSentence('4.50 € is vier Euro fünfzig. Next.')).toBe('4.50 € is vier Euro fünfzig.');
	});
});

describe('authored lesson content', () => {
	it('every rule check names an answer that is one of its options', () => {
		for (const q of quizzes) {
			for (const tip of q.help?.tips ?? []) {
				if (!tip.check) continue;
				expect(tip.check.options, `${q.id}: "${tip.title}" check`).toContain(tip.check.answer);
				expect(tip.check.options.length, `${q.id}: "${tip.title}" check options`).toBeGreaterThanOrEqual(2);
			}
		}
	});

	it('every focus word appears in its example', () => {
		// Thousands of words across the course: collect the misses, assert once.
		const missing: string[] = [];
		for (const q of quizzes) {
			const examples = [...(q.help?.tips ?? []).flatMap((t) => t.examples ?? []), ...(q.help?.context ? [q.help.context] : [])];
			for (const ex of examples) {
				for (const f of ex.focus ?? []) {
					if (!splitFocus(ex.de, [f]).some((p) => p.hit)) missing.push(`${q.id}: "${f}" not in "${ex.de}"`);
				}
			}
		}
		expect(missing).toEqual([]);
	});
});
