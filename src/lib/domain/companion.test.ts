// The study companion is authored by hand, so these checks keep it honest:
// every exercise has its answers in the key, every picture is on disk and
// credited, every QR code points at a registered link, nothing is asked that
// wasn't taught, and the prose talks about paper, not the app's screens — or
// exam brands.
import { existsSync } from 'node:fs';
import { describe, expect, it } from 'vitest';

import registry from '$content/booklinks.json';
import { loadCourse } from '$lib/content';
import {
	answerKey,
	exercisesOf,
	germanAskedBy,
	germanOf,
	imagesOf,
	loadCompanion,
	plain,
	wordsIn,
	type Companion,
	type LearnBlock
} from './companion';

const course = await loadCourse('de_cert_a1');
const levels = [...new Set(course.quizzes.map((q) => q.level).filter(Boolean))] as string[];
const companions = levels.map((l) => loadCompanion(course.id, l)).filter((c): c is Companion => c !== null);

/** Screen-only wording (cf. book-paper.test.ts) and exam brand names. */
const FORBIDDEN =
	/\b(tap|taps|tapping|swipe|click|press play|this quiz|type (it|the|your)|typing|keyboard|Goethe|telc|ÖSD|TestDaF)\b/i;

function blockTexts(b: LearnBlock): string[] {
	if (b.kind === 'columns') return b.blocks.flatMap(blockTexts);
	return [b.title, ...('note' in b && b.note ? [b.note] : []), ...('text' in b ? [b.text] : [])];
}

/** Every piece of prose a companion prints. */
function texts(c: Companion): string[] {
	const out = [...c.welcome, ...(c.overview?.blocks.flatMap(blockTexts) ?? []), c.dictionary?.note ?? ''];
	for (const s of c.spreads) {
		out.push(s.title, s.subtitle, s.hook, ...s.canDo, ...s.learn.flatMap(blockTexts));
		for (const ex of exercisesOf(s)) out.push(ex.title, ex.instruction);
	}
	return out.map(plain);
}

/** The German a companion teaches: its names, learn pages, overview and picture dictionary. */
function taughtBy(c: Companion): string[] {
	return [
		...(c.names ?? []),
		...c.spreads.flatMap((s) => s.learn.flatMap(germanOf)),
		...(c.overview?.blocks.flatMap(germanOf) ?? []),
		...(c.dictionary?.words.map((w) => w.de) ?? [])
	].flatMap(wordsIn);
}

const hasLink = (kind: string, target: string) => registry.links.some((l) => l.kind === kind && l.target === target);

describe('study companions', () => {
	it('A1.1 has one', () => {
		expect(companions.map((c) => c.level)).toContain('A1.1');
	});

	for (const [n, c] of companions.entries()) {
		describe(c.level, () => {
			it('answers every exercise', () => {
				for (const s of c.spreads) {
					for (const k of answerKey(s)) {
						expect(k.answers.length > 0 || !!k.note, `${s.id} ${k.exercise} ${k.title}`).toBe(true);
					}
					for (const ex of exercisesOf(s)) {
						const where = `${s.id}: ${ex.title}`;
						if (ex.kind === 'match') {
							expect([...ex.answers].sort(), where).toEqual(ex.right.map((_, i) => i));
							expect(ex.answers.length, where).toBe(ex.left.length);
						}
						if (ex.kind === 'write' || ex.kind === 'tags') {
							for (const item of ex.items) expect(item.answer.trim(), where).not.toBe('');
						}
						if (ex.kind === 'circle') {
							for (const item of ex.items) expect(item.options, `${where}: ${item.before}`).toContain(item.answer);
						}
					}
				}
			});

			it('prints only pictures that are on disk', () => {
				for (const id of imagesOf(c)) expect(existsSync(`static/img/${id}.webp`), id).toBe(true);
				expect(c.credits.length).toBeGreaterThan(0);
			});

			it('links only to registered codes for real quizzes', () => {
				const ids = new Set(course.quizzes.map((q) => q.id));
				for (const s of c.spreads) {
					if (!s.review) expect(s.quiz, `${s.id} has a quiz`).toBeTruthy();
					if (s.quiz) {
						expect(ids.has(s.quiz), s.quiz).toBe(true);
						expect(hasLink('quiz', s.quiz), `code for ${s.quiz}`).toBe(true);
					}
					if (s.listenQuiz) expect(hasLink('audio', s.listenQuiz), `audio code for ${s.listenQuiz}`).toBe(true);
					if (exercisesOf(s).some((ex) => ex.listen)) expect(s.listenQuiz, `${s.id} has a Listen exercise`).toBeTruthy();
				}
			});

			// Nothing is asked that wasn't taught: every German word an exercise
			// shows has been printed on a learn page by then — this spread's, an
			// earlier one's, or an earlier level's book (A1.2 builds on A1.1).
			it('asks only for German it has taught', () => {
				const taught = new Set<string>((c.names ?? []).flatMap(wordsIn));
				const untaught: string[] = [];
				// A taught infinitive teaches its regular forms too: the pages teach the
				// rule (stem + -e, -st, -t, -en), so lernen → lerne, lernst, lernt.
				const teach = (w: string) => {
					taught.add(w);
					if (w.length > 4 && w.endsWith('en')) for (const end of ['e', 'st', 't', 'est', 'et']) taught.add(w.slice(0, -2) + end);
				};
				companions.slice(0, n).flatMap(taughtBy).forEach(teach);
				for (const s of c.spreads) {
					s.learn.flatMap(germanOf).flatMap(wordsIn).forEach((w) => teach(w));
					for (const ex of exercisesOf(s)) {
						const missing = germanAskedBy(ex).flatMap(wordsIn).filter((w) => !taught.has(w));
						if (missing.length) untaught.push(`${s.id}: ${ex.title}: ${[...new Set(missing)].join(', ')}`);
					}
				}
				expect(untaught).toEqual([]);
			});

			it('talks about paper, not the screen', () => {
				for (const t of texts(c)) expect(t).not.toMatch(FORBIDDEN);
			});

			// docs/study_companion_guide.md: der, die and das always print in their colours.
			it('colours every der/die/das table', () => {
				const walk = (b: LearnBlock): LearnBlock[] => (b.kind === 'columns' ? b.blocks.flatMap(walk) : [b]);
				const blocks = [...c.spreads.flatMap((s) => s.learn), ...(c.overview?.blocks ?? [])].flatMap(walk);
				for (const b of blocks) {
					if (b.kind !== 'table') continue;
					const heads = b.head.map((h) => h.text.toLowerCase());
					if (['der', 'die', 'das'].every((g) => heads.includes(g))) expect(b.genders, b.title).toBe(true);
				}
			});

			it('has a unique id per spread', () => {
				const ids = c.spreads.map((s) => s.id);
				expect(new Set(ids).size).toBe(ids.length);
			});
		});
	}
});
