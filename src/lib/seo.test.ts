import { describe, expect, it } from 'vitest';
import { absoluteUrl, clip, quizDescription, quizTitle, topicOf } from './seo';
import type { Quiz } from './content/types';

describe('seo helpers', () => {
	it('builds absolute URLs on the canonical host', () => {
		expect(absoluteUrl('/words')).toBe('https://languagequiz.org/words');
		expect(absoluteUrl('words')).toBe('https://languagequiz.org/words');
	});

	it('clips on a word boundary within the limit', () => {
		const text = 'word '.repeat(60);
		const out = clip(text, 155);
		expect(out.length).toBeLessThanOrEqual(155);
		expect(out.endsWith('…')).toBe(true);
	});

	it('strips the sub-level prefix from a quiz title', () => {
		expect(topicOf('A1.1 · Artikel im Nominativ')).toBe('Artikel im Nominativ');
	});

	it('leads the title with the topic and never repeats the level', () => {
		const quiz = {
			id: 'q',
			type: 'fillBlank',
			title: 'A1.1 · Artikel im Nominativ',
			level: 'A1.1',
			help: { intro: 'Every German noun has a gender. It is learnt with the noun.' }
		} as unknown as Quiz;
		expect(quizTitle(quiz)).toBe('Artikel im Nominativ – German A1 exercise | Language Quiz');
		expect(quizDescription(quiz)).toBe('A1: Every German noun has a gender. It is learnt with the noun.');
	});
});
