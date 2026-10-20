// The worksheet builder's rules: what gets a paper form, what the answer
// column says, and how a sheet is trimmed to the size the learner asked for.
import { describe, expect, it } from 'vitest';

import {
	buildWorksheet,
	countItems,
	gapCategory,
	NO_HISTORY,
	quizWeakness,
	sectionFor,
	selectSections,
	speakingMaterialPairs,
	type ExerciseSection,
	type QuizHistory
} from './worksheet';
import type { FillBlankQuiz, PopulatedCourse, Quiz, VocabCard } from '$lib/content/types';

/** A deterministic stand-in for Math.random: always picks the first option. */
const first = () => 0;

const fillBlank: Quiz = {
	id: 'fb',
	type: 'fillBlank',
	title: 'Articles',
	storageKeyPrefix: 'fb_',
	subjects: [
		{ key: 'Hund', display: 'Hund' },
		{ key: 'Katze', display: 'Katze' }
	],
	categories: [{ label: 'Nominativ', group: 'case', values: ['der', 'die'] }],
	sentences: [
		{
			subjectKey: 'Hund',
			categoryLabel: 'Nominativ',
			sentence: '____ Hund schläft.',
			acceptedAnswers: ['der'],
			english: 'The dog is sleeping.'
		},
		{
			subjectKey: 'Katze',
			categoryLabel: 'Nominativ',
			// No stored answer: it must fall back to the category value.
			sentence: '____ Katze schläft.',
			acceptedAnswers: []
		}
	]
};

const reading: Quiz = {
	id: 'rd',
	type: 'reading',
	title: 'Im Café',
	storageKeyPrefix: 'rd_',
	passageTitle: 'Im Café',
	passage: 'Anna trinkt Kaffee.',
	category: 'Wortschatz',
	questions: [
		{ question: 'Was trinkt Anna?', options: ['Tee', 'Kaffee'], correctIndex: 1 },
		// Out of range: not printable, and must not become a blank item.
		{ question: 'Broken', options: ['a'], correctIndex: 7 }
	]
};

const dictation: Quiz = {
	id: 'dc',
	type: 'dictation',
	title: 'Diktat',
	storageKeyPrefix: 'dc_',
	items: [{ id: '1', text: 'Guten Tag' }]
};

describe('printable kinds', () => {
	it('gives audio-only quizzes no paper form', () => {
		expect(sectionFor(dictation)).toBeNull();
	});

	it('prints a cloze sentence with its stored answer, and its English above', () => {
		const section = sectionFor(fillBlank)!;
		expect(section.kind).toBe('cloze');
		expect(section.items[0]).toMatchObject({
			prompt: '____ Hund schläft.',
			answer: 'der',
			secondary: 'The dog is sleeping.',
			categoryLabel: 'Nominativ'
		});
	});

	it('falls back to the category value when a sentence stores no answer', () => {
		expect(sectionFor(fillBlank)!.items[1].answer).toBe('die');
	});

	it('prints a reading passage with lettered answers, skipping broken questions', () => {
		const section = sectionFor(reading)!;
		expect(section.kind).toBe('reading');
		expect(section.passage).toBe('Anna trinkt Kaffee.');
		expect(section.items).toHaveLength(1);
		expect(section.items[0].answer).toBe('b)  Kaffee');
	});

	it('generates one cloze per subject from templates when there is no bank', () => {
		const templated: Quiz = {
			...(fillBlank as FillBlankQuiz),
			sentences: [],
			sentenceTemplates: { Nominativ: ['____ {subject} ist hier.'] }
		};
		const items = sectionFor(templated, NO_HISTORY, first)!.items;
		expect(items).toHaveLength(2);
		expect(items[0]).toMatchObject({ prompt: '____ Hund ist hier.', answer: 'der' });
	});

	it('prints an inline-cloze passage with the template intact', () => {
		const inline: Quiz = {
			id: 'ic',
			type: 'reading',
			title: 'Big text',
			storageKeyPrefix: 'ic_',
			passageTitle: 'Big text',
			passage: 'Ich heiße Anna.',
			inlineTemplate: 'Ich {{1}} Anna.',
			inlineBlanks: [{ kind: 'input', answer: 'heiße', hint: 'heißen' }]
		};
		const section = sectionFor(inline)!;
		expect(section.kind).toBe('inlineCloze');
		expect(section.passage).toBe('Ich {{1}} Anna.');
		expect(section.items[0]).toMatchObject({ prompt: 'heißen', answer: 'heiße' });
	});
});

describe('speaking material', () => {
	it('reads `item = meaning` pairs and ignores label lines', () => {
		const material = 'Wortschatz:\ndie Nummer = the number · alt = old\nnot a pair';
		expect(speakingMaterialPairs(material)).toEqual([
			['die Nummer', 'the number'],
			['alt', 'old']
		]);
	});

	it('gives a speaking exercise with no material no paper form', () => {
		const speaking: Quiz = {
			id: 'sp',
			type: 'speaking',
			title: 'Interview',
			storageKeyPrefix: 'sp_',
			speaking: { topic: 'Hallo', practisePoints: [], scoringCriteria: [] }
		};
		expect(sectionFor(speaking)).toBeNull();
	});
});

describe('scope', () => {
	const course = {
		id: 'c',
		name: 'Course',
		quizzes: [fillBlank, reading, dictation],
		nav: { groups: [] }
	} as unknown as PopulatedCourse;

	const history =
		(overrides: Record<string, Partial<QuizHistory>>) =>
		(quiz: Quiz): QuizHistory => ({ ...NO_HISTORY, ...overrides[quiz.id] });

	it('takes every printable quiz for the whole course', () => {
		const sections = buildWorksheet(course, history({}), {
			scope: 'fullCourse',
			random: first
		});
		expect(sections.map((s) => s.quizTitle)).toEqual(['Articles', 'Im Café']);
	});

	it('keeps only finished quizzes for the achieved scope', () => {
		const sections = buildWorksheet(course, history({ rd: { done: true } }), {
			scope: 'achieved',
			random: first
		});
		expect(sections.map((s) => s.quizTitle)).toEqual(['Im Café']);
	});

	it('keeps only quizzes with mistakes for the weak-spot scope', () => {
		const sections = buildWorksheet(
			course,
			history({ fb: { answered: 4, mistakeRate: 0.5 }, rd: { answered: 6, mistakeRate: 0 } }),
			{ scope: 'weakSpots', random: first }
		);
		// The reading was answered, but always right: nothing to drill there.
		expect(sections.map((s) => s.quizTitle)).toEqual(['Articles']);
	});

	it('puts the weakest section first in the weak-spot scope', () => {
		const sections = buildWorksheet(
			course,
			history({ fb: { answered: 20, mistakeRate: 0.1 }, rd: { answered: 20, mistakeRate: 0.8 } }),
			{ scope: 'weakSpots', random: first }
		);
		expect(sections.map((s) => s.quizTitle)).toEqual(['Im Café', 'Articles']);
	});

	it("prints a flashcard deck's missed words, and only those", () => {
		const dog: VocabCard = { de: 'Hund', en: 'dog', kind: 'noun', article: 'der', sourceQuizId: 'fb' };
		const cat: VocabCard = { de: 'Katze', en: 'cat', kind: 'noun', article: 'die', sourceQuizId: 'fb' };
		const deck = {
			id: 'vc',
			type: 'vocabulary',
			title: 'Wörter',
			storageKeyPrefix: 'vc_',
			cards: [dog, cat]
		} as Quiz;
		const withDeck = { ...course, quizzes: [deck] } as PopulatedCourse;
		const sections = buildWorksheet(withDeck, history({ vc: { weakWords: [{ card: cat, wrong: 2 }] } }), {
			scope: 'weakSpots',
			random: first
		});
		expect(sections).toHaveLength(1);
		expect(sections[0].help).toBeUndefined();
		expect(sections[0].items).toEqual([
			expect.objectContaining({ prompt: '____', secondary: 'cat', answer: 'die Katze' })
		]);
	});
});

describe('weak-spot weighting', () => {
	it('ranks the category the learner gets wrong most often highest', () => {
		const stats: QuizHistory = {
			answered: 10,
			mistakeRate: 0.5,
			mistakesByCategory: { Nominativ: 8 },
			done: false
		};
		const [weak] = sectionFor(fillBlank, stats)!.items;
		// 0.6 * (0.5 damped by 10 / 13 answers) + 0.4 * 1 (the only, hence worst, category).
		expect(weak.weakness).toBeCloseTo(0.6 * (5 / 13) + 0.4);
	});

	it('does not let one slip outrank a steady run of misses', () => {
		const slip = quizWeakness({ ...NO_HISTORY, answered: 1, mistakeRate: 1 });
		const steady = quizWeakness({ ...NO_HISTORY, answered: 20, mistakeRate: 0.4 });
		expect(steady).toBeGreaterThan(slip);
	});

	it('reads the recent mistakes over the all-time ones', () => {
		const fixed = { ...NO_HISTORY, answered: 40, mistakeRate: 0.5, recentMistakeRate: 0 };
		expect(quizWeakness(fixed)).toBe(0);
	});

	it('raises a failed last run and lowers a medal', () => {
		const base = { ...NO_HISTORY, answered: 20, mistakeRate: 0.3 };
		expect(quizWeakness({ ...base, lastRunFailed: true })).toBeGreaterThan(quizWeakness(base));
		expect(quizWeakness({ ...base, tier: 'gold' })).toBeLessThan(quizWeakness(base));
	});

	it("weighs a big text's gaps by their own misses", () => {
		const inline: Quiz = {
			id: 'ic',
			type: 'reading',
			title: 'Big text',
			storageKeyPrefix: 'ic_',
			passageTitle: 'Big text',
			passage: '',
			inlineTemplate: '{{0}} {{1}}',
			inlineBlanks: [
				{ kind: 'input', answer: 'a' },
				{ kind: 'input', answer: 'b' }
			]
		};
		const stats: QuizHistory = {
			...NO_HISTORY,
			answered: 4,
			mistakeRate: 0.25,
			mistakesByCategory: { [gapCategory(1)]: 1 }
		};
		const [right, missed] = sectionFor(inline, stats)!.items;
		expect(missed.weakness).toBeGreaterThan(right.weakness);
		expect(missed.categoryLabel).toBeUndefined();
	});

	it('scores an unanswered quiz at zero', () => {
		expect(sectionFor(fillBlank)!.items[0].weakness).toBe(0);
	});
});

describe('sizing', () => {
	const sections: ExerciseSection[] = [
		{
			quizTitle: 'A',
			kind: 'cloze',
			items: [
				{ prompt: 'a1', answer: 'x', options: [], weakness: 0.1 },
				{ prompt: 'a2', answer: 'x', options: [], weakness: 0.9 }
			]
		},
		{
			quizTitle: 'B',
			kind: 'cloze',
			items: [{ prompt: 'b1', answer: 'x', options: [], weakness: 0.5 }]
		}
	];

	it('leaves a sheet alone when it already fits', () => {
		expect(selectSections(sections, { cap: 10, scope: 'fullCourse', random: first })).toBe(
			sections
		);
	});

	it('keeps the weakest exercises first in the weak-spot scope', () => {
		const trimmed = selectSections(sections, { cap: 1, scope: 'weakSpots', random: first });
		expect(countItems(trimmed)).toBe(1);
		expect(trimmed[0].items[0].prompt).toBe('a2');
	});

	it('never splits an inline-cloze passage from its blanks', () => {
		const passage: ExerciseSection = {
			quizTitle: 'Big text',
			kind: 'inlineCloze',
			passage: 'x {{1}} {{2}}',
			items: [
				{ prompt: '1', answer: 'a', options: [], weakness: 0.2 },
				{ prompt: '2', answer: 'b', options: [], weakness: 0.2 }
			]
		};
		// Room for one exercise only: the two-blank passage can't fit, so the
		// single-item section is taken instead of half a passage.
		const trimmed = selectSections([passage, sections[1]], {
			cap: 1,
			scope: 'fullCourse',
			random: first
		});
		expect(trimmed).toHaveLength(1);
		expect(trimmed[0].quizTitle).toBe('B');
	});
});
