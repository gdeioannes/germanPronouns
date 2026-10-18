import { describe, expect, it } from 'vitest';
import { ean13Modules, ean13Svg, isbnDigits } from './ean13';
import { ISBN } from './book';

describe('EAN-13', () => {
	it('accepts every book ISBN and rejects a wrong check digit', () => {
		for (const isbn of Object.values(ISBN)) expect(isbnDigits(isbn), isbn).toHaveLength(13);
		expect(isbnDigits('978-3-911749-30-6')).toBeNull();
	});

	it('encodes 95 modules with the guards in place', () => {
		const m = ean13Modules('9783911749305');
		expect(m).toHaveLength(95);
		expect(m.slice(0, 3)).toBe('101');
		expect(m.slice(45, 50)).toBe('01010');
		expect(m.slice(92)).toBe('101');
	});

	it('encodes a known symbol correctly', () => {
		// The worked example on every EAN-13 reference: 4006381333931.
		const m = ean13Modules('4006381333931');
		expect(m.slice(3, 10)).toBe(L4006[0]);
		expect(m.slice(10, 17)).toBe(L4006[1]);
	});

	it('draws an SVG with the digits under the bars', () => {
		const svg = ean13Svg(ISBN.A1)!;
		expect(svg).toContain('<rect');
		expect(svg).toContain('911749');
		expect(svg).toContain('ISBN 978-3-911749-30-5');
	});
});

/** First digit 4 → parity LGLLGG: digit 0 in L, digit 0 in G. */
const L4006 = ['0001101', '0100111'];
