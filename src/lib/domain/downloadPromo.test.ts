import { describe, expect, it } from 'vitest';
import { PROMOS, nextPromo } from './downloadPromo';

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
