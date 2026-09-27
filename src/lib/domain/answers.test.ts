import { describe, expect, it } from 'vitest';
import {
	canonicalGapAnswer,
	gapCount,
	matchesAccepted,
	matchesGaps,
	splitGapAnswer
} from './answers';

describe('umlaut-strict checking', () => {
	it('folds umlauts in relaxed mode for an ordinary quiz', () => {
		expect(matchesAccepted('schon', ['schön'], true)).toBe(true);
	});

	it('never folds them for an umlaut-strict quiz, even in relaxed mode', () => {
		expect(matchesAccepted('hatte', ['hätte'], true, true)).toBe(false);
		expect(matchesAccepted('hätte', ['hätte'], true, true)).toBe(true);
		expect(matchesAccepted('konnte', ['könnte'], true, true)).toBe(false);
	});

	it('still ignores punctuation and case for a strict quiz in relaxed mode', () => {
		expect(matchesAccepted('Hätte.', ['hätte'], true, true)).toBe(true);
	});
});

describe('multi-gap sentences', () => {
	it('counts the gaps', () => {
		expect(gapCount('Je ____ ich lese, ____ mehr verstehe ich.')).toBe(2);
		expect(gapCount('Ich ____ nach Hause.')).toBe(1);
		expect(gapCount('kein Gap')).toBe(0);
	});

	it('splits a key on its ellipsis, one part per gap', () => {
		expect(splitGapAnswer('je … desto', 2)).toEqual(['je', 'desto']);
		expect(splitGapAnswer('je…desto', 2)).toEqual(['je', 'desto']);
		expect(splitGapAnswer('wird', 2)).toBeNull();
		expect(splitGapAnswer('wird … haben', 1)).toEqual(['wird … haben']);
	});

	it('matches gap for gap against any usable key', () => {
		const keys = ['je … desto', 'je … umso', 'wird'];
		expect(matchesGaps(['je', 'desto'], keys, true)).toBe(true);
		expect(matchesGaps(['Je', 'umso'], keys, true)).toBe(true);
		expect(matchesGaps(['je', 'wird'], keys, true)).toBe(false);
		expect(matchesGaps(['', 'desto'], keys, true)).toBe(false);
	});

	it('writes back the key that matched, or the first usable one', () => {
		const keys = ['je … desto', 'je … umso'];
		expect(canonicalGapAnswer(['je', 'umso'], keys, true)).toEqual(['je', 'umso']);
		expect(canonicalGapAnswer(['x', 'y'], keys, true)).toEqual(['je', 'desto']);
		expect(canonicalGapAnswer([''], ['hätte'], true)).toEqual(['hätte']);
	});
});
