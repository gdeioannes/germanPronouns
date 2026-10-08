import { describe, expect, it } from 'vitest';
import { CLOSE_MARK, dictationWords, gradeDictation, PARTIAL_MARK } from './dictation';

const grade = (typed: string, target: string, relaxed = true, strict = false) =>
	gradeDictation(typed, target, relaxed, strict);

describe('dictationWords', () => {
	it('splits on whitespace and drops punctuation', () => {
		expect(dictationWords('Ich heiße Maya, und du?')).toEqual(['Ich', 'heiße', 'Maya', 'und', 'du']);
	});

	it('keeps the hyphen and apostrophe inside a word', () => {
		expect(dictationWords("E-Mail geht's")).toEqual(['E-Mail', "geht's"]);
	});
});

describe('gradeDictation', () => {
	const line = 'Ich wohne seit zwei Jahren in Berlin.';

	it('marks an exact line perfect', () => {
		const g = grade(line, line);
		expect(g.band).toBe('perfect');
		expect(g.score).toBe(100);
		expect(g.right).toBe(true);
		expect(g.marks.every((m) => m.state === 'hit')).toBe(true);
	});

	it('is still perfect with the full stop left off, in relaxed mode', () => {
		expect(grade('Ich wohne seit zwei Jahren in Berlin', line).band).toBe('perfect');
	});

	it('calls a one-word typo close, and counts it right', () => {
		const g = grade('Ich wohne seit zwei Jahren in Berln.', line);
		expect(g.band).toBe('close');
		expect(g.score).toBeGreaterThanOrEqual(CLOSE_MARK);
		expect(g.right).toBe(true);
		expect(g.marks.find((m) => m.target === 'Berlin')?.state).toBe('slip');
	});

	it('calls half the words partial, and counts it wrong', () => {
		const g = grade('Ich wohne seit Berlin', line);
		expect(g.band).toBe('partial');
		expect(g.score).toBeGreaterThanOrEqual(PARTIAL_MARK);
		expect(g.score).toBeLessThan(CLOSE_MARK);
		expect(g.right).toBe(false);
	});

	it('calls a wholly different line off', () => {
		const g = grade('Guten Morgen', line);
		expect(g.band).toBe('off');
		expect(g.score).toBeLessThan(PARTIAL_MARK);
	});

	it('scores an empty answer at zero', () => {
		const g = grade('', line);
		expect(g.score).toBe(0);
		expect(g.band).toBe('off');
		expect(g.marks.every((m) => m.state === 'miss')).toBe(true);
	});

	it('aligns around a missing word instead of shifting everything after it', () => {
		// "seit" dropped: every other word still has to land on its own word.
		const g = grade('Ich wohne zwei Jahren in Berlin.', line);
		expect(g.marks.find((m) => m.target === 'seit')?.state).toBe('miss');
		expect(g.marks.filter((m) => m.state === 'hit').length).toBe(6);
		expect(g.band).toBe('close');
	});

	it('names the words that were invented', () => {
		const g = grade('Ich wohne seit zwei Jahren in Berlin heute morgen.', line);
		const extras = g.marks.filter((m) => m.state === 'extra').map((m) => m.typed);
		expect(extras).toEqual(['heute', 'morgen']);
		expect(g.score).toBeLessThan(100);
	});

	it('forgives a dropped umlaut in relaxed mode', () => {
		expect(grade('Ich hore Musik', 'Ich höre Musik.').band).toBe('perfect');
	});

	it('counts a dropped umlaut as a slip where the quiz insists on it', () => {
		const g = grade('Ich hore Musik.', 'Ich höre Musik.', true, true);
		expect(g.band).toBe('close');
		expect(g.right).toBe(true);
		expect(g.marks.find((m) => m.target === 'höre')?.state).toBe('slip');
	});

	it('never reads 100 without an exact match', () => {
		// Every word in place, only the full stop missing, with the forgiving
		// setting off — so the line is not the line, however close it reads.
		const g = grade('Ich wohne seit zwei Jahren in Berlin', line, false);
		expect(g.score).toBe(99);
		expect(g.band).toBe('close');
	});

	it('drops a short line below close for a single wrong word', () => {
		const g = grade('Ich bin hier', 'Ich bin da');
		expect(g.band).toBe('partial');
		expect(g.marks.find((m) => m.target === 'da')?.state).toBe('wrong');
	});
});
