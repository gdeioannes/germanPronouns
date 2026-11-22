import { describe, expect, it } from 'vitest';
import { readFileSync } from 'node:fs';
import { FIRST_CHAPTER, PROMOS, companionFor, nextPromo } from './downloadPromo';

describe('companionFor', () => {
	it('leads every course book to its real first chapter', () => {
		expect(Object.keys(FIRST_CHAPTER)).toHaveLength(12);
		for (const [level, first] of Object.entries(FIRST_CHAPTER)) {
			const file = `assets/content/book2/de_cert_a1/${level.toLowerCase().replace('.', '_')}.json`;
			const book = JSON.parse(readFileSync(file, 'utf8')) as { chapters: { id: string; title: string }[] };
			expect({ id: book.chapters[0].id, title: book.chapters[0].title }, level).toEqual(first);
		}
	});

	it('gives the chapter page, and nothing for a classic', () => {
		expect(companionFor('A1.1')).toEqual({ href: '/course/de_cert_a1/book2/A1.1/hallo', title: 'Hallo! Das bin ich' });
		expect(companionFor('Kafka')).toBeNull();
	});
});

describe('nextPromo', () => {
	it('starts with the first card', () => {
		expect(nextPromo(-1, 'A1.1').index).toBe(0);
	});

	it('shows a different card each download, round and round', () => {
		const seen: string[] = [];
		let last = -1;
		for (let i = 0; i < PROMOS.length; i++) {
			const { promo, index } = nextPromo(last, 'A1.1');
			seen.push(promo.id);
			last = index;
		}
		expect(new Set(seen).size).toBe(PROMOS.length);
		expect(nextPromo(last, 'A1.1').index).toBe(0);
	});

	it('never advertises the book being downloaded', () => {
		const kafka = PROMOS.findIndex((p) => p.id === 'kafka');
		const { promo } = nextPromo(kafka - 1, 'Kafka');
		expect(promo.id).not.toBe('kafka');
	});

	it('copes with a stale index from an older, longer list', () => {
		expect(nextPromo(99, 'A1.1').promo).toBeDefined();
	});

	it('every card links inside the site', () => {
		for (const p of PROMOS) {
			expect(p.href.startsWith('/')).toBe(true);
			expect(p.hook.length).toBeLessThan(60);
		}
	});
});
