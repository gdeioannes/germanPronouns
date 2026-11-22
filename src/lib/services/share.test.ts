// The share link is read by two things: the analytics (the ?ref tag names the
// place it was shared from) and the quiz page (the score to beat).
import { describe, expect, it, vi, beforeEach } from 'vitest';

vi.mock('$lib/services/analytics', () => ({ track: vi.fn() }));

import { readScore, shareLink, whatsappLink } from './share';

describe('readScore', () => {
	it('reads a score from the address', () => {
		expect(readScore('?ref=share-quiz_done&score=9-10')).toEqual({ right: 9, total: 10 });
		expect(readScore('?score=0-6')).toEqual({ right: 0, total: 6 });
	});
	it('ignores anything that is not a score', () => {
		for (const q of ['', '?score=', '?score=11-10', '?score=3-0', '?score=a-b', '?score=9', '?score=-1-10', '?score=9-10x']) {
			expect(readScore(q)).toBeNull();
		}
	});
});

describe('shareLink', () => {
	beforeEach(() => {
		vi.stubGlobal('location', new URL('https://languagequiz.org/ar/course/c/quiz/q?book=1&score=2-10&utm_source=book#top'));
	});
	it('tags this page with where it was shared from, and drops the query it had', () => {
		expect(shareLink('quiz')).toBe('https://languagequiz.org/ar/course/c/quiz/q?ref=share-quiz');
	});
	it('carries the score, and can point at another page', () => {
		expect(shareLink('quiz_done', undefined, { right: 9, total: 10 })).toBe(
			'https://languagequiz.org/ar/course/c/quiz/q?ref=share-quiz_done&score=9-10'
		);
		expect(shareLink('download', '/tr/books')).toBe('https://languagequiz.org/tr/books?ref=share-download');
	});
	it('round-trips through readScore', () => {
		const link = new URL(shareLink('quiz_done', undefined, { right: 7, total: 10 }));
		expect(readScore(link.search)).toEqual({ right: 7, total: 10 });
	});
});

describe('whatsappLink', () => {
	it('writes the text and the link into one message', () => {
		expect(whatsappLink('Look: this', 'https://x.org/a?ref=share-download')).toBe(
			'https://wa.me/?text=Look%3A%20this%0Ahttps%3A%2F%2Fx.org%2Fa%3Fref%3Dshare-download'
		);
	});
});
