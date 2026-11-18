import { describe, expect, it } from 'vitest';
import { fromBookHref } from './booklinks';

describe('fromBookHref', () => {
	it('tags a plain path as a visit from the book', () => {
		expect(fromBookHref('/course/de_cert_a1/quiz/x', 'a1-07')).toBe(
			'/course/de_cert_a1/quiz/x?utm_source=book&utm_medium=code&utm_campaign=a1-07'
		);
	});

	it('keeps the #part at the end, where the browser reads it', () => {
		expect(fromBookHref('/course/de_cert_a1/book2/A1.1/hallo#lesen', 'a1-12')).toBe(
			'/course/de_cert_a1/book2/A1.1/hallo?utm_source=book&utm_medium=code&utm_campaign=a1-12#lesen'
		);
	});

	it('adds to an existing query string', () => {
		expect(fromBookHref('/play/x?book', 'b1-03')).toBe('/play/x?book&utm_source=book&utm_medium=code&utm_campaign=b1-03');
	});

	it('encodes an odd code', () => {
		expect(fromBookHref('/p', 'a b&c')).toContain('utm_campaign=a%20b%26c');
	});
});
