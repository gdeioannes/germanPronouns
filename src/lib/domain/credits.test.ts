import { describe, expect, it } from 'vitest';
import commons from '../../../assets/rights/commons.json';
import { creditFor, creditLine, photoBanned } from './credits';

// Every credit the site prints is complete: who, which licence (with its link
// unless public domain), where the file is, and that our copy is modified.
describe('photo credits', () => {
	// Photos the zero-doubt review replaces do not ship, so they need no credit.
	const ids = Object.keys(commons).filter((id) => !photoBanned(id));
	it('name every author without Commons signature leftovers', () => {
		const bad = ids.filter((id) => {
			const a = creditFor(id)!.author;
			// An unknown author is only acceptable in the public domain, which asks for no credit.
			const unknownOk = creditFor(id)!.license === 'public domain';
			return !a || /\(\s*talk|UTC\)|^--|^User:/i.test(a) || (/Unknown author/i.test(a) && !unknownOk);
		});
		expect(bad).toEqual([]);
	});
	it('link the licence for everything not in the public domain', () => {
		const bad = ids.filter((id) => {
			const c = creditFor(id)!;
			return c.license !== 'public domain' && !/^https?:\/\/creativecommons\.org\//.test(c.licenseUrl ?? '');
		});
		expect(bad).toEqual([]);
	});
	it('print a full line for every photo', () => {
		for (const id of ids) expect(creditLine(id)).toMatch(/via Wikimedia Commons, commons\.wikimedia\.org\/\?curid=\d+, modified$/);
	});
});
