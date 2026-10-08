import { describe, expect, it } from 'vitest';
import content from '$content/tasks/call_after_party.json';
import type { CallTaskContent } from './callTask';
import { emojiSegments, hideNumber, NUMBER_MASK, NUMBER_WORDS } from './emojiText';

const call = content as CallTaskContent;

const render = (line: string) => emojiSegments(line).map((s) => (s.kind === 'text' ? s.text : `[${s.emoji}]`)).join('');

describe('emojiSegments', () => {
	it('puts the keycap right after each number word', () => {
		expect(render('null, eins, sieben')).toBe('null[0️⃣], eins[1️⃣], sieben[7️⃣]');
	});

	it('matches whole words only, any case', () => {
		expect(render('Achtung! Zwei Bier')).toBe('Achtung[⚠️]! Zwei[2️⃣] Bier[🍺]');
		expect(render('Einsicht, Achter')).toBe('Einsicht, Achter');
	});

	it('keeps hyphenated words whole and skips an emoji already written by hand', () => {
		expect(render('die U-Bahn')).toBe('die U-Bahn[🚇]');
		expect(render('dein Ladekabel 😅🔌')).toBe('dein Ladekabel 😅🔌');
	});
});

describe('hideNumber', () => {
	it('takes the spoken number out of every right call, in German and English', () => {
		for (const round of call.rounds.slice(1)) {
			const de = hideNumber(round.clip.de).toLowerCase();
			const en = hideNumber(round.clip.en);
			for (const word of NUMBER_WORDS) expect(de).not.toMatch(new RegExp(String.raw`(?<!\p{L})${word}(?!\p{L})`, 'u'));
			expect(en).not.toMatch(/\d/);
			expect(de).toContain(NUMBER_MASK);
		}
	});

	it('keeps the rest of the line, and a lone number word', () => {
		expect(hideNumber('Die Nummer da ist null, eins, sieben – neun. Gute Nacht.')).toBe(`Die Nummer da ist ${NUMBER_MASK}. Gute Nacht.`);
		expect(hideNumber('Kaffee um drei?')).toBe('Kaffee um drei?');
		expect(hideNumber('my number is 0176 520 3847. Call me!')).toBe(`my number is ${NUMBER_MASK}. Call me!`);
	});
});
