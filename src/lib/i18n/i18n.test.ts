// The second languages (Turkish, Arabic): the language pick, the overlay
// mechanics, and that every built overlay still matches the English it was
// translated from.
import { describe, expect, it } from 'vitest';
import { readFileSync, readdirSync, existsSync } from 'node:fs';
import { pickLang } from './lang.svelte';
import { applyPairs, localize, parsePath, translateDeep } from './content.svelte';
import { STRINGS } from './t';
import { levelTranslated, routeTranslated } from './available';

describe('pickLang', () => {
	it('takes ?lang= over everything', () => {
		expect(pickLang('?lang=tr', 'en', ['en-GB'])).toBe('tr');
		expect(pickLang('?lang=en', 'tr', ['tr-TR'])).toBe('en');
	});
	it('then the saved choice, then the browser', () => {
		expect(pickLang('', 'en', ['tr-TR'])).toBe('en');
		expect(pickLang('', null, ['de-DE', 'tr'])).toBe('tr');
		expect(pickLang('', null, ['en-US'])).toBe('en');
	});
	it('knows Arabic, and takes the first language the site speaks', () => {
		expect(pickLang('?lang=ar', null, ['en-GB'])).toBe('ar');
		expect(pickLang('', null, ['ar-SY', 'en'])).toBe('ar');
		expect(pickLang('', null, ['en-GB', 'ar'])).toBe('en');
		expect(pickLang('', null, ['de-DE', 'ar-IQ', 'tr'])).toBe('ar');
		expect(pickLang('?lang=xx', 'tr', [])).toBe('tr');
	});
});

describe('availability', () => {
	it('knows the translated levels in both spellings', () => {
		expect(levelTranslated('A1.1')).toBe(true);
		expect(levelTranslated('a2_2')).toBe(true);
		expect(levelTranslated('B1.1')).toBe(false);
	});
	it('hides pages without a translation', () => {
		expect(routeTranslated('/course/[courseId]/quiz/[quizId]')).toBe(true);
		expect(routeTranslated('/forum')).toBe(false);
	});
});

describe('overlay mechanics', () => {
	it('swaps known English deep inside, German untouched', () => {
		const out = translateDeep({ a: 'Hello', b: ['Hallo', { c: 'Hello' }] }, { Hello: 'Merhaba' });
		expect(out).toEqual({ a: 'Merhaba', b: ['Hallo', { c: 'Merhaba' }] });
	});
	it('reads keys that hold a dot', () => {
		expect(parsePath('englishTemplates["mein (my, Nom.)"][0]')).toEqual(['englishTemplates', 'mein (my, Nom.)', 0]);
		expect(parsePath('help.tips[2].title')).toEqual(['help', 'tips', 2, 'title']);
	});
	it('applies a path only while its English is unchanged', () => {
		const quiz = { help: { tips: [{ title: 'you' }, { title: 'you' }, { title: 'edited' }] } };
		const out = applyPairs(quiz, {
			'help.tips[0].title': ['you', 'sen'],
			'help.tips[1].title': ['you', 'siz'],
			'help.tips[2].title': ['old English', 'eski']
		});
		expect(out.help.tips.map((t) => t.title)).toEqual(['sen', 'siz', 'edited']);
		expect(quiz.help.tips[0].title).toBe('you');
	});
});

describe('interface strings', () => {
	// Some keys reach t() through constants the key scanner cannot follow (the
	// home FAQ, level advice), so Turkish, the first and fullest table, is the
	// reference: every other language must have every key it has.
	for (const [l, table] of Object.entries(STRINGS)) {
		if (l === 'tr') continue;
		it(`${l} has every key tr has`, () => {
			expect(Object.keys(STRINGS.tr).filter((k) => !(k in table))).toEqual([]);
		});
	}
	for (const [l, table] of Object.entries(STRINGS)) {
		it(`${l} keeps its placeholders`, () => {
			const holes = (s: string) => (s.match(/\{\w+\}/g) ?? []).sort().join(' ');
			const bad = Object.entries(table).filter(([en, tr]) => holes(en) !== holes(tr));
			expect(bad).toEqual([]);
		});
	}
});

// Every built overlay must still fit the course: a path whose English has
// changed shows English in that language. Re-translate it in
// tool/turkish/<lang>/ and run `node tool/turkish/build.mjs <level> --lang <lang>`.
describe('built overlays', () => {
	const files = ['tr', 'ar'].flatMap((l) => {
		const dir = `assets/content/${l}/de_cert_a1`;
		return existsSync(dir) ? readdirSync(dir).filter((f) => f.endsWith('.json')).map((f) => `${l}/de_cert_a1/${f}`) : [];
	});
	const bundle = JSON.parse(readFileSync('assets/content/courses/de_cert_a1.json', 'utf8')) as {
		quizzes: { id: string }[];
	};
	const get = (o: unknown, path: string) =>
		parsePath(path).reduce<unknown>((at, k) => (at as Record<string | number, unknown> | undefined)?.[k], o);
	for (const f of files) {
		it(`${f} matches the current English`, () => {
				const overlay = JSON.parse(readFileSync(`assets/content/${f}`, 'utf8')) as {
				quizzes: Record<string, Record<string, [string, string]>>;
			};
			const stale: string[] = [];
			for (const [id, pairs] of Object.entries(overlay.quizzes)) {
				if (id.startsWith("_")) continue; // the level page's syllabus card, not an exercise
				const quiz = bundle.quizzes.find((q) => q.id === id);
				if (!quiz) {
					stale.push(`${id}: no such exercise`);
					continue;
				}
				for (const [path, [en]] of Object.entries(pairs)) if (get(quiz, path) !== en) stale.push(`${id} ${path}`);
			}
			expect(stale).toEqual([]);
		});
		// The text map is keyed by English words, and German looks English
		// sometimes ("hat", "bin", "in"): only paths may change an answer, and
		// nothing may change a code ("kind", "spot"), or the page breaks.
		it(`${f} leaves codes and German alone`, () => {
			const overlay = JSON.parse(readFileSync(`assets/content/${f}`, 'utf8')) as {
				quizzes: Record<string, Record<string, [string, string]>>;
				chapters: Record<string, Record<string, [string, string]>>;
				text: Record<string, string>;
			};
			const level = f.split('/').at(-1)!;
			const book = existsSync(`assets/content/book2/de_cert_a1/${level}`)
				? (JSON.parse(readFileSync(`assets/content/book2/de_cert_a1/${level}`, 'utf8')) as { chapters: { id: string }[] }).chapters
				: [];
			const guarded = new Set(['kind', 'spot', 'image', 'mode', 'answer', 'acceptedAnswers', 'options', 'tiles', 'forms', 'values', 'focus', 'de']);
			const changed: string[] = [];
			const compare = (id: string, before: unknown, after: unknown, field = '') => {
				if (typeof before === 'string') {
					if (guarded.has(field) && before !== after) changed.push(`${id} ${field}: ${before} → ${String(after)}`);
				} else if (Array.isArray(before)) before.forEach((v, i) => compare(id, v, (after as unknown[])[i], field));
				else if (before && typeof before === 'object')
					for (const [k, v] of Object.entries(before)) compare(id, v, (after as Record<string, unknown>)[k], k);
			};
			const items: [string, { id: string }, Record<string, [string, string]> | undefined][] = [
				...bundle.quizzes.map((q) => [q.id, q, overlay.quizzes[q.id]] as [string, { id: string }, Record<string, [string, string]> | undefined]),
				...book.map((c) => [c.id, c, overlay.chapters[c.id]] as [string, { id: string }, Record<string, [string, string]> | undefined])
			];
			for (const [id, item, pairs] of items) compare(id, applyPairs(item, pairs), localize(item, pairs, overlay.text));
			expect(changed).toEqual([]);
		});
	}
});

// Every interface string the code gives t() / tk() has its translation in
// tr.ts and ar.ts. A new string fails here: add it
// (`node tool/turkish/ui-keys.mjs [--lang ar]` prints the lines).
describe('interface coverage', () => {
	for (const l of Object.keys(STRINGS)) {
		it(`${l}.ts has every key`, async () => {
			const { execFileSync } = await import('node:child_process');
			const out = execFileSync('node', ['tool/turkish/ui-keys.mjs', '--lang', l], { encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'] });
			expect(out.trim()).toBe('');
		});
	}
});

describe('Turkish noun templates', () => {
	it('puts "bir" after the adjective and leaves plurals bare', async () => {
		const { lang } = await import('./lang.svelte');
		const { fillBlankPool } = await import('$lib/domain/spoken');
		lang.current = 'tr';
		try {
			const quiz = {
				categories: [{ label: 'c', values: ['x', 'y'] }],
				subjects: [
					{ key: '0', display: 'neuer Tisch', english: 'yeni masa' },
					{ key: '1', display: 'Kind', english: 'çocuk' }
				],
				sentenceTemplates: { c: ['____', '____'] },
				englishTemplates: { c: ['Bu {a} {subject}.', 'İki {pl} görüyorum.'] }
			};
			const lines = fillBlankPool(quiz as never).map((s) => s.english);
			expect(lines).toEqual(['Bu yeni bir masa.', 'İki yeni masa görüyorum.', 'Bu bir çocuk.', 'İki çocuk görüyorum.']);
		} finally {
			lang.current = 'en';
		}
	});
});
