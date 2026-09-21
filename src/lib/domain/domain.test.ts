// The safety net for the ported rules. The Flutter app had 1,463 tests; these
// cover the logic that actually decides what a learner sees — tiers, gating,
// answer acceptance, draw order and score parsing — so a silent behaviour
// change during the port shows up here rather than in production.
import { describe, expect, it } from 'vitest';

import {
	isAcceptedAnswer,
	acceptedViaRelaxedOnly,
	levenshtein,
	matchesSpoken,
	normalizeAnswer,
	normalizeForSpeech,
	stripDiacritics
} from './answers';
import { drawFromShuffleBag } from './shuffleBag';
import {
	isQuizDone,
	lapsForStreak,
	lapsForTier,
	parseSpeakingFixes,
	parseSpeakingScore,
	ribbonTierForLaps,
	speakingGrade,
	speakingMedal,
	STREAK_LAP_SIZE,
	type Gating
} from './progress';
import { buildLadder, courseProgress, nextQuiz } from './ladder';
import type { PopulatedCourse, Quiz } from '$lib/content/types';

describe('ribbon tiers', () => {
	it('uses the shipped boundaries: bronze 1, silver 3, gold 5', () => {
		expect(ribbonTierForLaps(0)).toBe('bronze');
		expect(ribbonTierForLaps(2)).toBe('bronze');
		expect(ribbonTierForLaps(3)).toBe('silver');
		expect(ribbonTierForLaps(4)).toBe('silver');
		expect(ribbonTierForLaps(5)).toBe('gold');
		expect(ribbonTierForLaps(99)).toBe('gold');
	});

	it('lapsForTier inverts ribbonTierForLaps', () => {
		for (const tier of ['bronze', 'silver', 'gold'] as const) {
			expect(ribbonTierForLaps(lapsForTier(tier))).toBe(tier);
		}
	});

	it('counts laps in fives', () => {
		expect(STREAK_LAP_SIZE).toBe(5);
		expect(lapsForStreak(4)).toBe(0);
		expect(lapsForStreak(5)).toBe(1);
		expect(lapsForStreak(14)).toBe(2);
	});
});

describe('fill-in completion', () => {
	const gating: Gating = { progressionUnlockLaps: 2, questUnlockLaps: 2 };

	it('completes at the goal streak, not before', () => {
		expect(isQuizDone(9, gating)).toBe(false);
		expect(isQuizDone(10, gating)).toBe(true);
		expect(isQuizDone(11, gating)).toBe(true);
	});
});

describe('answer normalization', () => {
	it('folds the sharp s and accents to ASCII', () => {
		expect(stripDiacritics('Fußball')).toBe('Fussball');
		expect(stripDiacritics('schön')).toBe('schon');
		expect(stripDiacritics('mañana')).toBe('manana');
	});

	it('is strict by default and forgiving when relaxed', () => {
		expect(normalizeAnswer('  Schön  ', false)).toBe('schön');
		expect(normalizeAnswer('  Schön  ', true)).toBe('schon');
	});

	it('accepts a missing umlaut only in relaxed mode', () => {
		expect(isAcceptedAnswer('schon', ['schön'], false)).toBe(false);
		expect(isAcceptedAnswer('schon', ['schön'], true)).toBe(true);
		// A correctly-accented answer still passes in relaxed mode.
		expect(isAcceptedAnswer('schön', ['schön'], true)).toBe(true);
	});

	it('flags the near-miss that should offer relaxed correction', () => {
		expect(acceptedViaRelaxedOnly('schon', ['schön'])).toBe(true);
		// A genuinely wrong answer must not trigger the offer...
		expect(acceptedViaRelaxedOnly('blau', ['schön'])).toBe(false);
		// ...nor one that was already right.
		expect(acceptedViaRelaxedOnly('schön', ['schön'])).toBe(false);
	});

	it('never accepts an empty answer', () => {
		expect(isAcceptedAnswer('   ', ['ich'], true)).toBe(false);
	});
});

describe('spoken answers', () => {
	it('folds umlauts to digraphs and strips punctuation', () => {
		expect(normalizeForSpeech('Grüße, Anna!')).toBe('gruesse anna');
		expect(normalizeForSpeech('heiße')).toBe(normalizeForSpeech('heisse'));
	});

	it('measures edit distance', () => {
		expect(levenshtein('kitten', 'sitting')).toBe(3);
		expect(levenshtein('same', 'same')).toBe(0);
	});

	it('is forgiving about recognizer noise', () => {
		expect(matchesSpoken('Ich heisse Anna', 'Ich heiße Anna.')).toBe(true);
		// Recognizers often add leading words.
		expect(matchesSpoken('ähm ich heiße Anna', 'Ich heiße Anna')).toBe(true);
		expect(matchesSpoken('guten morgen', 'Ich heiße Anna')).toBe(false);
	});

	it('never matches against an empty target', () => {
		expect(matchesSpoken('anything', '')).toBe(false);
	});
});

describe('shuffle bag', () => {
	const seeded = (seed: number) => () => {
		seed = (seed * 1664525 + 1013904223) % 4294967296;
		return seed / 4294967296;
	};

	it('hands out the whole pool before repeating', () => {
		const pool = ['a', 'b', 'c', 'd'];
		const bag: string[] = [];
		const random = seeded(3);
		const seen = new Set<string>();
		for (let i = 0; i < pool.length; i++) {
			seen.add(drawFromShuffleBag(bag, pool, { randomChance: 0, random }));
		}
		expect(seen.size).toBe(pool.length);
	});

	it('never repeats the previous item back to back', () => {
		const pool = ['a', 'b', 'c'];
		const bag: string[] = [];
		let previous: string | undefined;
		const random = seeded(7);
		for (let i = 0; i < 200; i++) {
			const next = drawFromShuffleBag(bag, pool, { avoidRepeat: previous, random });
			expect(next).not.toBe(previous);
			previous = next;
		}
	});

	it('accepts a repeat only when the pool leaves no choice', () => {
		expect(drawFromShuffleBag([], ['a'], { avoidRepeat: 'a' })).toBe('a');
	});

	it('rejects an empty pool rather than returning undefined', () => {
		expect(() => drawFromShuffleBag([], [])).toThrow();
	});
});

describe('speaking scores', () => {
	it('grades 0-100 onto 1-10', () => {
		expect(speakingGrade(84)).toBe(8);
		expect(speakingGrade(0)).toBe(1); // clamped, never 0
		expect(speakingGrade(100)).toBe(10);
	});

	it('awards medals at grade 9 / 7 / 5 and nothing below', () => {
		expect(speakingMedal(95)).toBe('gold');
		expect(speakingMedal(75)).toBe('silver');
		expect(speakingMedal(54)).toBe('bronze');
		expect(speakingMedal(40)).toBeNull();
	});

	it('prefers the SCORE= line over any other number in the report', () => {
		// The regression this guards: "FINAL SCORE: 84 / 100" must not yield 100.
		expect(parseSpeakingScore('FINAL SCORE: 84 / 100\nSCORE=84')).toBe(84);
		expect(parseSpeakingScore('  71 ')).toBe(71);
		expect(parseSpeakingScore('SCORE = 7')).toBe(7);
	});

	it('rejects anything unparseable or out of range', () => {
		expect(parseSpeakingScore('')).toBeNull();
		expect(parseSpeakingScore('great job!')).toBeNull();
		expect(parseSpeakingScore('SCORE=101')).toBeNull();
	});

	it('reads FIX: corrections in either arrow form', () => {
		const fixes = parseSpeakingFixes(
			'- FIX: ich bin gehen -> ich gehe\nFIX: mein Haus → mein Haus ist'
		);
		expect(fixes).toHaveLength(2);
		expect(fixes[0]).toEqual({ said: 'ich bin gehen', correct: 'ich gehe' });
	});
});

describe('the gated ladder', () => {
	const quiz = (id: string, level: string) =>
		({
			id,
			type: 'reading',
			title: id,
			storageKeyPrefix: id + '_',
			level,
			passageTitle: '',
			passage: '',
			questions: []
		}) as unknown as Quiz;

	const course = {
		id: 'c',
		nav: {
			groups: [
				{ id: 'g1', title: 'A1.1', type: 'questChain', level: 'A1.1' },
				{ id: 'g2', title: 'A1.2', type: 'questChain', level: 'A1.2' },
				{ id: 'g3', title: 'A2.1', type: 'questChain', level: 'A2.1' },
				{ id: 'more', title: 'MORE', type: 'links' }
			]
		},
		quizzes: [quiz('a', 'A1.1'), quiz('b', 'A1.1'), quiz('c', 'A1.2'), quiz('d', 'A2.1')]
	} as unknown as PopulatedCourse;

	it('opens only the first level to a new learner', () => {
		const ladder = buildLadder(course, () => false);
		expect(ladder.map((l) => l.unlocked)).toEqual([true, false, false]);
	});

	it('opens the next level only when every earlier quiz is done', () => {
		// One of the two A1.1 quizzes done is not enough.
		let ladder = buildLadder(course, (q) => q.id === 'a');
		expect(ladder[1].unlocked).toBe(false);

		ladder = buildLadder(course, (q) => q.id === 'a' || q.id === 'b');
		expect(ladder[1].unlocked).toBe(true);
		// ...but the one after it stays shut.
		expect(ladder[2].unlocked).toBe(false);
	});

	it('lets a placement open a level without marking anything complete', () => {
		const ladder = buildLadder(
			course,
			() => false,
			(id) => id === 'd'
		);
		expect(ladder[2].unlocked).toBe(true);
		// The honest ring: placing earns nothing.
		expect(courseProgress(ladder).done).toBe(0);
	});

	it('resumes at the first unfinished quiz in an open level', () => {
		expect(nextQuiz(buildLadder(course, () => false), () => false)?.id).toBe('a');
		const done = (q: Quiz) => q.id === 'a';
		expect(nextQuiz(buildLadder(course, done), done)?.id).toBe('b');
	});

	it('counts overall progress across levels', () => {
		expect(courseProgress(buildLadder(course, () => true))).toEqual({
			done: 4,
			total: 4
		});
	});
});
