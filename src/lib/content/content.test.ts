// The content gate. Runs over the real bundle and the real syllabus, so a
// quiz that ships without its Help Memory, a placeholder that forgets to say
// so, or a module that claims completeness without covering its syllabus
// fails the build rather than the learner.
//
// Two tiers: a baseline every quiz must meet today, and the full standard of
// docs/content_master_plan.md §4 which is enforced module by module as each
// one is flagged `complete` in the syllabus.

import { describe, expect, it } from 'vitest';
import course from '$content/courses/de_cert_a1.json';
import syllabus from '$content/syllabus/de_cert_a1.json';
import type { CourseSyllabus, PopulatedCourse, Quiz } from './types';

const bundle = course as unknown as PopulatedCourse;
const syl = syllabus as unknown as CourseSyllabus;

const quizzes = bundle.quizzes;
const byLevel = (level: string) => quizzes.filter((q) => q.level === level);
const isPlaceholder = (q: Quiz) => q.status === 'placeholder';
const isGrammar = (q: Quiz) => q.type === 'fillBlank';

/** The full seven-layer standard, applied to one quiz. */
function assertFullStandard(q: Quiz) {
	const h = q.help;
	expect(h, `${q.id}: no help`).toBeTruthy();
	if (!h) return;
	expect((h.intro ?? '').length, `${q.id}: intro under 300 chars`).toBeGreaterThanOrEqual(300);
	const minTips = isGrammar(q) ? 3 : 2;
	expect(h.tips?.length ?? 0, `${q.id}: fewer than ${minTips} tips`).toBeGreaterThanOrEqual(minTips);
	for (const tip of h.tips ?? []) {
		if (tip.kind === 'exam') continue;
		expect(tip.examples?.length ?? 0, `${q.id}: tip "${tip.title}" has no examples`).toBeGreaterThanOrEqual(1);
		for (const ex of tip.examples ?? []) {
			expect(ex.de, `${q.id}: example missing German`).toBeTruthy();
			expect(ex.en, `${q.id}: example missing English`).toBeTruthy();
		}
	}
	expect(h.remember?.length ?? 0, `${q.id}: no memory aid`).toBeGreaterThanOrEqual(1);
	expect(h.exam, `${q.id}: no exam note`).toBeTruthy();
	if (isGrammar(q)) {
		// A grid quiz derives its table; anything else must author one.
		const hasGrid = 'subjects' in q && q.subjects.length > 0 && q.categories.length > 0;
		expect(hasGrid || !!h.table, `${q.id}: no reference table`).toBe(true);
		// Words: authored, or derived from a grid whose subjects carry meanings.
		const gridWords = 'subjects' in q ? q.subjects.filter((s) => s.english).length : 0;
		expect(
			Math.max(h.vocab?.length ?? 0, gridWords),
			`${q.id}: fewer than 8 words (authored or from the grid)`
		).toBeGreaterThanOrEqual(8);
		expect(h.context, `${q.id}: no in-context text`).toBeTruthy();
		expect(h.mistakes?.length ?? 0, `${q.id}: fewer than 2 common mistakes`).toBeGreaterThanOrEqual(2);
	}
	expect(q.covers?.length ?? 0, `${q.id}: declares nothing it covers`).toBeGreaterThanOrEqual(1);
}

describe('every quiz (baseline)', () => {
	it('has an id, a title, a level and a storage key', () => {
		for (const q of quizzes) {
			expect(q.id).toBeTruthy();
			expect(q.title).toBeTruthy();
			expect(q.level).toBeTruthy();
			expect(q.storageKeyPrefix).toBeTruthy();
		}
	});

	it('has unique ids and storage prefixes', () => {
		const ids = quizzes.map((q) => q.id);
		expect(new Set(ids).size).toBe(ids.length);
		const prefixes = quizzes.map((q) => q.storageKeyPrefix);
		expect(new Set(prefixes).size).toBe(prefixes.length);
	});

	it('has a Help Memory with an intro and at least one tip', () => {
		for (const q of quizzes) {
			expect(q.help?.intro, `${q.id}: no intro`).toBeTruthy();
			expect(q.help?.tips?.length ?? 0, `${q.id}: no tips`).toBeGreaterThanOrEqual(1);
		}
	});

	it('gives a live fill-in enough distinct questions (10) or templates', () => {
		for (const q of quizzes) {
			if (q.type !== 'fillBlank' || isPlaceholder(q)) continue;
			const sentences = q.sentences?.length ?? 0;
			const templates = Object.values(q.sentenceTemplates ?? {}).flat().length;
			expect(
				sentences >= 10 || templates > 0,
				`${q.id}: only ${sentences} sentences and no templates`
			).toBe(true);
		}
	});

	it('gives a placeholder fill-in a grid to derive its table from', () => {
		for (const q of quizzes) {
			if (q.type !== 'fillBlank' || !isPlaceholder(q)) continue;
			expect(q.subjects.length, `${q.id}: placeholder without subjects`).toBeGreaterThan(0);
			expect(q.categories.length, `${q.id}: placeholder without categories`).toBeGreaterThan(0);
		}
	});

	it('only declares syllabus structures that exist, at its own level', () => {
		for (const q of quizzes) {
			const module = syl.modules.find((m) => m.level === q.level);
			for (const id of q.covers ?? []) {
				expect(
					module?.structures.some((s) => s.id === id),
					`${q.id}: covers "${id}", which is not in the ${q.level} syllabus`
				).toBe(true);
			}
		}
	});
});

describe('syllabus', () => {
	it('has one module per quest-chain level in the nav, in order', () => {
		const levels = bundle.nav.groups.filter((g) => g.type === 'questChain').map((g) => g.level);
		expect(syl.modules.map((m) => m.level)).toEqual(levels);
	});

	it('has unique structure ids', () => {
		const ids = syl.modules.flatMap((m) => m.structures.map((s) => s.id));
		expect(new Set(ids).size).toBe(ids.length);
	});
});

describe('completed modules (full standard)', () => {
	const done = syl.modules.filter((m) => m.complete);

	// Vitest treats an `it.each` over an empty list as a suite with no tests and
	// fails it; until the first module is flagged complete, say so instead.
	it('is enforced for the modules flagged complete', () => {
		expect(done.map((m) => m.level)).toBeDefined();
	});

	it.each(done.map((m) => [m.level, m] as const))('%s covers every structure', (_, module) => {
		const covered = new Set(byLevel(module.level).flatMap((q) => q.covers ?? []));
		const missing = module.structures.filter((s) => !covered.has(s.id)).map((s) => s.id);
		expect(missing, `${module.level}: uncovered structures`).toEqual([]);
	});

	it.each(done.map((m) => [m.level, m] as const))(
		'%s quizzes meet the seven-layer Help Memory standard',
		(_, module) => {
			for (const q of byLevel(module.level)) assertFullStandard(q);
		}
	);
});
