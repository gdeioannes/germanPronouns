import { describe, expect, it } from 'vitest';
import { absoluteUrl, clip, courseLd, learningResourceLd, quizDescription, quizTitle, titleWithSite, topicOf } from './seo';
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
		// A one-sentence intro is too thin for a snippet, so it is padded.
		expect(quizDescription(quiz)).toBe(
			'A1: Every German noun has a gender. It is learnt with the noun. Free exercise with rules, examples and audio.'
		);
	});

	it('keeps a long enough intro as it is', () => {
		const quiz = {
			id: 'q',
			type: 'fillBlank',
			title: 'A1.1 · Artikel',
			level: 'A1.1',
			help: { intro: 'Every German noun has a gender, and the article tells you which one: der, die or das. It is learnt with the noun.' }
		} as unknown as Quiz;
		expect(quizDescription(quiz)).not.toMatch(/Free exercise/);
	});

	it('appends the site name to a title only while it fits', () => {
		expect(titleWithSite('Short')).toBe('Short | Language Quiz');
		const long = 'x'.repeat(60);
		expect(titleWithSite(long)).toBe(long);
	});
});

describe('accessibility metadata', () => {
	const quizOf = (type: string) =>
		({ id: 'q', type, title: 'A1.1 · Topic', level: 'A1.1', help: { intro: 'Intro.' } }) as unknown as Quiz;

	it('describes the course and every exercise for assistive technology', () => {
		const course = courseLd({ id: 'c', name: 'Course', tagline: 'Tagline' });
		for (const ld of [course, learningResourceLd(quizOf('fillBlank'), '/q', 'Course', '/c')]) {
			expect(ld.accessibilityControl).toContain('fullKeyboardControl');
			expect(ld.accessibilityFeature).toContain('timingControl');
			expect(ld.accessibilityHazard).toContain('noFlashingHazard');
			expect(ld.accessibilitySummary).toMatch(/WCAG/);
		}
	});

	it('marks audio exercises as auditory, with a text alternative', () => {
		const listening = learningResourceLd(quizOf('listening'), '/q', 'Course', '/c');
		expect(listening.accessMode).toContain('auditory');
		expect(listening.accessibilityFeature).toContain('transcript');
		const drill = learningResourceLd(quizOf('fillBlank'), '/q', 'Course', '/c');
		expect(drill.accessMode).not.toContain('auditory');
		expect(drill.accessibilityFeature).not.toContain('transcript');
	});
});
