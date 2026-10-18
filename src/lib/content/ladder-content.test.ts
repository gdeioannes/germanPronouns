// The medal ladder's content gate: every fill-in sentence can be offered as a
// choice of four, every drill has enough hard sentences for its no-help step,
// and every typed gap of a big-text cloze has its wrong options. Authored in
// assets/content/ladder and merged by tool/apply-ladder.mjs.
import { describe, expect, it } from 'vitest';
import course from '$content/courses/de_cert_a1.json';
import type { PopulatedCourse } from './types';
import { normalizeAnswer } from '$lib/domain/answers';
import { goldSentence, MIN_HARD_POOL, stepPool } from '$lib/domain/fillLadder';
import { fillBlankPool } from '$lib/domain/spoken';

const quizzes = (course as unknown as PopulatedCourse).quizzes;

describe('medal ladder content', () => {
	it('gives every authored fill-in sentence three wrong options, none of them right', () => {
		for (const q of quizzes) {
			if (q.type !== 'fillBlank' || !q.sentences?.length) continue;
			for (const s of q.sentences) {
				if (s.tiles?.length) continue;
				const where = `${q.id}: "${s.sentence}"`;
				expect(s.options?.length, `${where} needs three options`).toBe(3);
				const right = new Set(s.acceptedAnswers.map((a) => normalizeAnswer(a, false)));
				for (const o of s.options ?? []) {
					expect(right.has(normalizeAnswer(o, false)), `${where}: option "${o}" is right`).toBe(false);
				}
			}
		}
	});

	it('gives every drill enough hard sentences for the no-help step', () => {
		for (const q of quizzes) {
			if (q.type !== 'fillBlank' || !q.sentences?.length) continue;
			// Two tile items may share a sentence: count distinct ones.
			const hard = new Set(q.sentences.filter((s) => s.hard).map((s) => s.sentence));
			expect(hard.size, `${q.id} has ${hard.size} hard sentences`).toBeGreaterThanOrEqual(MIN_HARD_POOL);
		}
	});

	it('gives every typed gap of a big-text cloze three wrong options', () => {
		for (const q of quizzes) {
			if (q.type !== 'reading' || !('inlineBlanks' in q) || !q.inlineBlanks) continue;
			q.inlineBlanks.forEach((b, i) => {
				if (b.kind !== 'input') return;
				expect(b.options?.length, `${q.id} gap ${i}`).toBe(3);
			});
		}
	});

	// The no-help step must still ask something: every gold item shows an
	// English line beside the bare sentence, or keeps its cue; generated
	// drills (templates, no authored sentences) included.
	it('leaves every no-help item a question to answer', () => {
		for (const q of quizzes) {
			if (q.type !== 'fillBlank') continue;
			const pool = fillBlankPool(q);
			for (const it of stepPool(pool, 2)) {
				const shown = goldSentence(it);
				const where = `${q.id}: "${it.sentence}"`;
				if (shown !== it.sentence) {
					expect(it.english, `${where} loses its cue without an English line`).toBeTruthy();
					expect(it.english, `${where}: the English line repeats the blank`).not.toMatch(/____/);
				} else {
					// The cue stayed: it must be there to read.
					expect(/\([^()]*(\([^()]*\)[^()]*)*\)\s*$/.test(it.sentence) || !!it.english, where).toBe(true);
				}
			}
		}
	});

	it('gives every big-text gap a cue for the no-help step', () => {
		for (const q of quizzes) {
			if (q.type !== 'reading' || !('inlineBlanks' in q) || !q.inlineBlanks) continue;
			q.inlineBlanks.forEach((b, i) => {
				expect(b.cue?.trim(), `${q.id} gap ${i}`).toBeTruthy();
				expect(normalizeAnswer(b.cue ?? '', false), `${q.id} gap ${i}: the cue is the answer`).not.toBe(
					normalizeAnswer(b.answer, false)
				);
			});
		}
	});
});
