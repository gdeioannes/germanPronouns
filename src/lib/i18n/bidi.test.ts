// German runs inside Arabic sentences are isolated so their punctuation stays put.
import { describe, expect, it } from 'vitest';
import { arabicContent, isolateLatin, turnArrows } from './bidi';

const F = '⁨';
const P = '⁩';

describe('isolateLatin', () => {
	it('wraps each German run in an Arabic sentence', () => {
		expect(isolateLatin('أن أسأل (Können Sie mir sagen, ob …?)')).toBe(`أن أسأل (${F}Können Sie mir sagen, ob …?${P})`);
		expect(isolateLatin('ein لـ der وdas')).toBe(`${F}ein${P} لـ ${F}der${P} و${F}das${P}`);
	});
	it('leaves the Arabic full stop outside', () => {
		expect(isolateLatin('تعلّمها مع die.')).toBe(`تعلّمها مع ${F}die${P}.`);
	});
	it('keeps a German question or exclamation whole', () => {
		expect(isolateLatin('Schreib mit! · دورك')).toBe(`${F}Schreib mit!${P} · دورك`);
	});
	it('never touches placeholders', () => {
		expect(isolateLatin('أرى اثنين: {pl}.')).toBe('أرى اثنين: {pl}.');
		expect(isolateLatin('{n} من {total} der')).toBe(`{n} من {total} ${F}der${P}`);
	});
	it('leaves German-only, markup and already isolated strings alone', () => {
		expect(isolateLatin('Ich bin müde.')).toBe('Ich bin müde.');
		expect(isolateLatin('<b>der</b> اسم')).toBe('<b>der</b> اسم');
		const once = isolateLatin('ein لـ der');
		expect(isolateLatin(once)).toBe(once);
	});
});

describe('turnArrows', () => {
	it('points an arrow the way an Arabic line reads', () => {
		expect(turnArrows('geht → ging: فعل غير منتظم')).toBe('geht ← ging: فعل غير منتظم');
		expect(turnArrows('Gericht ← Bund، انتبه → هنا')).toBe('Gericht → Bund، انتبه ← هنا');
	});
	it('leaves German-only lines alone', () => {
		expect(turnArrows('geht → ging')).toBe('geht → ging');
	});
	it('turns, then isolates, in course content', () => {
		expect(arabicContent('ich → mich')).toBe('ich → mich');
		expect(arabicContent('ich → mich يعني')).toBe(`${F}ich${P} ← ${F}mich${P} يعني`);
	});
});
