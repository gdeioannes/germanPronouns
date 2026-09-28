import { describe, expect, it } from 'vitest';
import { paginate, paginateCloze, type ClozePart } from './paginate';

describe('paginate', () => {
	it('keeps a short text on one page', () => {
		expect(paginate('Ich heiße Anna.', 100)).toEqual(['Ich heiße Anna.']);
	});

	it('breaks between paragraphs first', () => {
		const a = 'A'.repeat(60);
		const b = 'B'.repeat(60);
		expect(paginate(`${a}\n\n${b}`, 80)).toEqual([a, b]);
	});

	it('packs small paragraphs together', () => {
		expect(paginate('Eins.\n\nZwei.\n\nDrei.', 14)).toEqual(['Eins.\n\nZwei.', 'Drei.']);
	});

	it('falls back to lines, then sentences, never mid-sentence', () => {
		const dialogue = 'Anna: Hallo, wie geht es dir?\nBen: Gut, danke. Und dir?\nAnna: Auch gut.';
		const pages = paginate(dialogue, 32);
		expect(pages.length).toBeGreaterThan(1);
		expect(pages.join('\n').replace(/\s+/g, ' ')).toBe(dialogue.replace(/\s+/g, ' '));

		const prose = 'Das ist Satz eins. Das ist Satz zwei. Das ist Satz drei.';
		const cut = paginate(prose, 20);
		expect(cut).toEqual(['Das ist Satz eins.', 'Das ist Satz zwei.', 'Das ist Satz drei.']);
	});
});

describe('paginateCloze', () => {
	const text = (t: string): ClozePart => ({ text: t });
	const blank = (b: number): ClozePart => ({ blank: b });

	it('keeps a short cloze whole', () => {
		const parts = [text('Ich habe '), blank(0), text(' Hund.')];
		expect(paginateCloze(parts, 200)).toEqual([parts]);
	});

	it('splits at paragraphs and keeps every blank exactly once', () => {
		const parts = [
			text('Erster Absatz mit '),
			blank(0),
			text(' Lücke.\n\nZweiter Absatz mit '),
			blank(1),
			text(' Lücke.')
		];
		const pages = paginateCloze(parts, 40, 10);
		expect(pages).toHaveLength(2);
		const blanks = pages.flat().filter((p) => 'blank' in p);
		expect(blanks).toEqual([blank(0), blank(1)]);
		expect(pages[1][0]).toEqual(text('Zweiter Absatz mit '));
	});

	it('breaks a paragraph that is too long on its own at its sentences', () => {
		const parts = [
			text('Satz eins hat '),
			blank(0),
			text('. Satz zwei hat '),
			blank(1),
			text('. Satz drei ist ohne.')
		];
		const pages = paginateCloze(parts, 30, 6);
		expect(pages.length).toBeGreaterThan(1);
		expect(pages.flat().filter((p) => 'blank' in p)).toEqual([blank(0), blank(1)]);
		const joined = pages
			.map((page) => page.map((p) => ('text' in p ? p.text : `[${p.blank}]`)).join(''))
			.join(' ');
		expect(joined).toBe('Satz eins hat [0]. Satz zwei hat [1]. Satz drei ist ohne.');
	});
});
