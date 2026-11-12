import { describe, expect, it } from 'vitest';
import { readFileSync } from 'node:fs';
import { addressIn, hasTwin, localPages, pathLang, stripLang, withLang } from './paths';
import { pickLang } from './lang.svelte';
import { localizeLinks } from '../../hooks.server';

describe('language addresses', () => {
	it('reads the prefix', () => {
		expect(pathLang('/tr')).toBe('tr');
		expect(pathLang('/ar/course/de_cert_a1')).toBe('ar');
		expect(pathLang('/trip')).toBeNull();
		expect(pathLang('/course/tr')).toBeNull();
	});

	it('strips and adds it', () => {
		expect(stripLang('/tr')).toBe('/');
		expect(stripLang('/ar/about')).toBe('/about');
		expect(stripLang('/about')).toBe('/about');
		expect(withLang('tr', '/')).toBe('/tr');
		expect(withLang('ar', '/about')).toBe('/ar/about');
		expect(withLang('en', '/about')).toBe('/about');
		expect(withLang(null, '/about')).toBe('/about');
	});

	it('moves a page between languages', () => {
		expect(addressIn('ar', '/tr/settings')).toBe('/ar/settings');
		expect(addressIn('en', '/tr/settings')).toBe('/settings');
		expect(addressIn('tr', '/')).toBe('/tr');
	});

	it('the prefix wins over ?lang=, a saved choice and the browser', () => {
		expect(pickLang('?lang=en', 'en', ['en'], '/ar/about')).toBe('ar');
		expect(pickLang('', null, ['tr-TR'], '/about')).toBe('tr');
		expect(pickLang('', 'tr', ['en'], '/about')).toBe('tr');
	});
});

describe('translated pages', () => {
	const bundle = JSON.parse(readFileSync('assets/content/courses/de_cert_a1.json', 'utf8')) as {
		quizzes: { id: string; level?: string }[];
	};
	const pages = localPages('de_cert_a1', bundle.quizzes);

	it('cover the A1–A2 exercises and nothing above', () => {
		const quizzes = pages.filter((p) => p.includes('/quiz/'));
		expect(quizzes.length).toBe(bundle.quizzes.filter((q) => /^A[12]\./.test(q.level ?? '')).length);
		expect(pages).toContain('/course/de_cert_a1/level/A2.2');
		expect(pages).not.toContain('/course/de_cert_a1/level/B1.1');
		expect(new Set(pages).size).toBe(pages.length);
	});

	it('links in a translated page point at its twins, and only at pages that have one', () => {
		const set = new Set(pages);
		const html =
			'<a href="/">Home</a><a href="/about#me">About</a><a href="/legal">Legal</a>' +
			'<a href="/course/de_cert_a1/level/B1.1">B1</a><link rel="canonical" href="https://languagequiz.org/about">';
		expect(localizeLinks(html, 'tr', set)).toBe(
			'<a href="/tr">Home</a><a href="/tr/about#me">About</a><a href="/legal">Legal</a>' +
				'<a href="/course/de_cert_a1/level/B1.1">B1</a><link rel="canonical" href="https://languagequiz.org/about">'
		);
	});
});

describe('hasTwin', () => {
	const bundle = JSON.parse(readFileSync('assets/content/courses/de_cert_a1.json', 'utf8')) as {
		quizzes: { id: string; level?: string }[];
	};
	const twins = new Set(localPages('de_cert_a1', bundle.quizzes));
	it('agrees with the list of translated pages for every exercise and level', () => {
		const levels = ['A1.1', 'A1.2', 'A2.1', 'A2.2', 'B1.1', 'B1.2', 'B2.1', 'B2.2', 'C1.1', 'C1.2', 'C2.1', 'C2.2'];
		const paths = [
			...bundle.quizzes.map((q) => `/course/de_cert_a1/quiz/${q.id}`),
			...levels.map((l) => `/course/de_cert_a1/level/${l}`),
			...twins,
			'/legal',
			'/forum',
			'/words/nouns',
			'/course/de_cert_a1/book2/A1.1',
			'/course/de_cert_a1/worksheet'
		];
		expect(paths.filter((p) => hasTwin(p) !== twins.has(p))).toEqual([]);
	});
});
