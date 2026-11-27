import { afterEach, describe, expect, it, vi } from 'vitest';
import { downloadName, isRemoteMedia } from '../../tool/media-rule.mjs';
import { CHARTS_FILENAME } from '$lib/content/charts';
import { LITERATURE, pdfFilename } from '$lib/content/literature';

describe('media rule', () => {
	it('moves recordings and PDFs, keeps manifests and pictures', () => {
		expect(isRemoteMedia('audio/0a1b2c.mp3')).toBe(true);
		expect(isRemoteMedia('audio/story/sfx/techno_loop.mp3')).toBe(true);
		expect(isRemoteMedia('books/v2/de_cert_a1_a1_1_ar.pdf')).toBe(true);
		expect(isRemoteMedia('workbooks/de_cert_a1_b2_1.pdf')).toBe(true);
		expect(isRemoteMedia('audio/manifest/a.json')).toBe(false);
		expect(isRemoteMedia('workbooks/manifest.json')).toBe(false);
		expect(isRemoteMedia('img/books/a1_1.webp')).toBe(false);
	});

	it('saves PDFs under the names the download links ask for', () => {
		expect(downloadName('books/charts/german-grammar-charts.pdf')).toBe(CHARTS_FILENAME);
		for (const book of LITERATURE) {
			const path = book.pdf.href.replace(/^.*?\/books\//, 'books/');
			expect(downloadName(path)).toBe(pdfFilename(book));
		}
		expect(downloadName('workbooks/de_cert_a1_b2_1.pdf')).toBe('German B2.1 workbook.pdf');
		expect(downloadName('books/v2/de_cert_a1_a1_1.pdf')).toBe('de_cert_a1_a1_1.pdf');
	});
});

describe('mediaUrl', () => {
	afterEach(() => {
		vi.unstubAllEnvs();
		vi.resetModules();
	});

	it('leaves every path alone without a bucket', async () => {
		vi.stubEnv('PUBLIC_MEDIA_BASE', '');
		const { mediaUrl } = await import('./media');
		expect(mediaUrl('/audio/x.mp3')).toBe('/audio/x.mp3');
	});

	it('points recordings and PDFs at the bucket, nothing else', async () => {
		vi.stubEnv('PUBLIC_MEDIA_BASE', 'https://media.example.org/');
		const { mediaUrl } = await import('./media');
		expect(mediaUrl('/audio/x.mp3')).toBe('https://media.example.org/audio/x.mp3');
		expect(mediaUrl('/books/v2/a.pdf')).toBe('https://media.example.org/books/v2/a.pdf');
		expect(mediaUrl('/audio/manifest/a.json')).toBe('/audio/manifest/a.json');
		expect(mediaUrl('/img/a.webp')).toBe('/img/a.webp');
		// Already absolute: unchanged, so wrapping twice is harmless.
		expect(mediaUrl('https://media.example.org/audio/x.mp3')).toBe('https://media.example.org/audio/x.mp3');
	});
});
