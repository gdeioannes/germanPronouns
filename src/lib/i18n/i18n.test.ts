// Turkish mode: the language pick, the overlay mechanics, and that every built
// overlay still matches the English it was translated from.
import { describe, expect, it } from 'vitest';
import { readFileSync, readdirSync, existsSync } from 'node:fs';
import { pickLang } from './lang.svelte';
import { applyPairs, parsePath, translateDeep } from './content.svelte';
import { TR } from './tr';
import { levelInTurkish, routeInTurkish } from './available';

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
});

describe('availability', () => {
	it('knows the Turkish levels in both spellings', () => {
		expect(levelInTurkish('A1.1')).toBe(true);
		expect(levelInTurkish('a2_2')).toBe(true);
		expect(levelInTurkish('B1.1')).toBe(false);
	});
	it('hides pages without Turkish', () => {
		expect(routeInTurkish('/course/[courseId]/quiz/[quizId]')).toBe(true);
		expect(routeInTurkish('/forum')).toBe(false);
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

describe('Turkish interface strings', () => {
	it('keep their placeholders', () => {
		const holes = (s: string) => (s.match(/\{\w+\}/g) ?? []).sort().join(' ');
		const bad = Object.entries(TR).filter(([en, tr]) => holes(en) !== holes(tr));
		expect(bad).toEqual([]);
	});
});

// Every built overlay must still fit the course: a path whose English has
// changed shows English in Turkish mode. Re-translate it in tool/turkish/tr/
// and run `node tool/turkish/build.mjs <level>`.
describe('built overlays', () => {
	const dir = 'assets/content/tr/de_cert_a1';
	const files = existsSync(dir) ? readdirSync(dir).filter((f) => f.endsWith('.json')) : [];
	const bundle = JSON.parse(readFileSync('assets/content/courses/de_cert_a1.json', 'utf8')) as {
		quizzes: { id: string }[];
	};
	const get = (o: unknown, path: string) =>
		parsePath(path).reduce<unknown>((at, k) => (at as Record<string | number, unknown> | undefined)?.[k], o);
	for (const f of files) {
		it(`${f} matches the current English`, () => {
			const overlay = JSON.parse(readFileSync(`${dir}/${f}`, 'utf8')) as {
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
	}
});

// Every interface string the code gives t() / tk() has its Turkish in tr.ts.
// A new string fails here: add it (tool/turkish/ui-keys.mjs prints the lines).
describe('interface coverage', () => {
	it('tr.ts has every key', async () => {
		const { execFileSync } = await import('node:child_process');
		const out = execFileSync('node', ['tool/turkish/ui-keys.mjs'], { encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'] });
		expect(out.trim()).toBe('');
	});
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
