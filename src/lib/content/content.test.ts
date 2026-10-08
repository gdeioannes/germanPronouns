// The content gate. Runs over the real bundle and the real syllabus, so a
// quiz that ships without its Help Memory, a placeholder that forgets to say
// so, or a module that claims completeness without covering its syllabus
// fails the build rather than the learner.
//
// Two tiers: a baseline every quiz must meet today, and the full standard of
// docs/content_master_plan.md §4 which is enforced module by module as each
// one is flagged `complete` in the syllabus.

import { existsSync } from 'node:fs';
import { describe, expect, it } from 'vitest';
import course from '$content/courses/de_cert_a1.json';
import syllabus from '$content/syllabus/de_cert_a1.json';
import type { CourseSyllabus, PopulatedCourse, Quiz } from './types';
import { normalizeAnswer } from '$lib/domain/answers';
import { buildableFromTiles, tileBank } from '$lib/domain/tiles';

const bundle = course as unknown as PopulatedCourse;
const syl = syllabus as unknown as CourseSyllabus;

const quizzes = bundle.quizzes;
const byLevel = (level: string) => quizzes.filter((q) => q.level === level);
const isPlaceholder = (q: Quiz) => q.status === 'placeholder';
const isGrammar = (q: Quiz) => q.type === 'fillBlank';
/** Listening, reading, writing and speaking practice — the only exercises with an exam note. */
const isSkill = (q: Quiz) => /^(Hören|Lesen|Schreiben|Sprechen|Gespräch|Diktat)\b/.test(q.title);

/** The full seven-layer standard, applied to one quiz. */
function assertFullStandard(q: Quiz) {
	const h = q.help;
	expect(h, `${q.id}: no help`).toBeTruthy();
	if (!h) return;
	expect((h.intro ?? '').length, `${q.id}: intro under 300 chars`).toBeGreaterThanOrEqual(300);
	const minTips = isGrammar(q) ? 3 : 2;
	expect(h.tips?.length ?? 0, `${q.id}: fewer than ${minTips} tips`).toBeGreaterThanOrEqual(minTips);
	for (const tip of h.tips ?? []) {
		expect(tip.examples?.length ?? 0, `${q.id}: tip "${tip.title}" has no examples`).toBeGreaterThanOrEqual(1);
		for (const ex of tip.examples ?? []) {
			expect(ex.de, `${q.id}: example missing German`).toBeTruthy();
			expect(ex.en, `${q.id}: example missing English`).toBeTruthy();
		}
	}
	expect(h.remember?.length ?? 0, `${q.id}: no memory aid`).toBeGreaterThanOrEqual(1);
	if (isSkill(q)) expect(h.exam, `${q.id}: no exam note`).toBeTruthy();
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

	it('gives every dictation and repeat-aloud at least 10 lines', () => {
		for (const q of quizzes) {
			if (isPlaceholder(q)) continue;
			const lines = q.type === 'dictation' ? q.items : q.type === 'speakRepeat' ? q.phrases : null;
			if (!lines) continue;
			expect(lines.length, `${q.id}: only ${lines.length} lines`).toBeGreaterThanOrEqual(10);
		}
	});

	it('keys every gap of a multi-gap sentence, and uses the ellipsis for nothing else', () => {
		for (const q of quizzes) {
			if (q.type !== 'fillBlank') continue;
			for (const s of q.sentences ?? []) {
				const gaps = (s.sentence.match(/_{4,}/g) ?? []).length;
				expect(gaps, `${q.id}: "${s.sentence}" has no blank`).toBeGreaterThan(0);
				for (const key of s.acceptedAnswers) {
					const parts = key.split(/\s*…\s*/);
					expect(
						parts.length,
						`${q.id}: key "${key}" has ${parts.length} parts for ${gaps} gap(s) in "${s.sentence}"`
					).toBe(gaps);
					expect(parts.every((p) => p.trim()), `${q.id}: empty part in key "${key}"`).toBe(true);
				}
			}
		}
	});

	it('builds every key of a word-tile item from its tiles, and no tile passes for another', () => {
		for (const q of quizzes) {
			if (q.type !== 'fillBlank') continue;
			for (const s of q.sentences ?? []) {
				if (!s.tiles) continue;
				const where = `${q.id}: "${s.sentence}"`;
				expect((s.sentence.match(/_{4,}/g) ?? []).length, `${where}: a tile item has one gap`).toBe(1);
				expect(s.tiles.length, `${where}: fewer than 2 tiles`).toBeGreaterThanOrEqual(2);
				expect(s.tiles.length, `${where}: more than 8 tiles`).toBeLessThanOrEqual(8);
				for (const key of s.acceptedAnswers)
					expect(buildableFromTiles(key, s.tiles), `${where}: "${key}" can't be laid from the tiles`).toBe(true);
				const offered = tileBank(s).map((t) => t.text);
				expect(
					s.acceptedAnswers.some((key) => buildableFromTiles(key, offered, true)),
					`${where}: the bank reads as an answer left to right`
				).toBe(false);
				// "Sie" and "sie" would both be accepted — a distractor must really be wrong.
				const forms = new Map<string, string>();
				for (const tile of s.tiles) {
					const form = normalizeAnswer(tile, true);
					const seen = forms.get(form);
					expect(seen === undefined || seen === tile, `${where}: "${seen}" and "${tile}" check the same`).toBe(true);
					forms.set(form, tile);
				}
			}
		}
	});

	it('never puts the answer in the hint', () => {
		for (const q of quizzes) {
			if (q.type !== 'fillBlank') continue;
			for (const s of q.sentences ?? []) {
				if (!s.hint) continue;
				// Case-sensitive: a nominalisation drill hints "steigen" for "Steigen".
				const hint = s.hint;
				for (const key of s.acceptedAnswers) {
					const parts = key.split(/\s*…\s*/).map((p) => p.trim());
					// "English: orange" for the colour orange is the same word in both
					// languages; that is the meaning, not the answer. And a two-gap item
					// whose hint is the infinitive only gives away the participle gap,
					// not the conjunction the item tests: flag it when EVERY part is given.
					const given = parts.filter((part) => {
						if (part.length < 4) return false;
						if (/^english:\s*/i.test(hint) && hint.replace(/^english:\s*/i, '') === part) return false;
						const escaped = part.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
						return new RegExp(`(^|[^\\p{L}])${escaped}([^\\p{L}]|$)`, 'u').test(hint);
					});
					expect(
						given.length > 0 && given.length === parts.length,
						`${q.id}: hint "${s.hint}" contains the answer "${key}"`
					).toBe(false);
				}
			}
		}
	});

	it('gives every passage a title, a translation and well-formed questions', () => {
		for (const q of quizzes) {
			if (q.type !== 'reading' && q.type !== 'listening') continue;
			expect(q.passageTitle, `${q.id}: no passageTitle`).toBeTruthy();
			expect(q.passageTranslation, `${q.id}: no passageTranslation`).toBeTruthy();
			if ('inlineBlanks' in q && Array.isArray(q.inlineBlanks)) {
				const markers = q.inlineTemplate.match(/\{\{\d+\}\}/g) ?? [];
				expect(markers.length, `${q.id}: markers vs blanks`).toBe(q.inlineBlanks.length);
				for (let i = 0; i < q.inlineBlanks.length; i++) {
					expect(q.inlineTemplate.includes(`{{${i}}}`), `${q.id}: missing {{${i}}}`).toBe(true);
				}
				continue;
			}
			const questions = 'questions' in q ? q.questions : [];
			expect(questions.length, `${q.id}: fewer than 3 questions`).toBeGreaterThanOrEqual(3);
			const indices = new Set<number>();
			for (const question of questions) {
				expect(question.options.length, `${q.id}: "${question.question}" needs 3+ options`).toBeGreaterThanOrEqual(3);
				expect(new Set(question.options).size, `${q.id}: duplicate options`).toBe(question.options.length);
				expect(question.correctIndex, `${q.id}: bad correctIndex`).toBeLessThan(question.options.length);
				expect(question.explanation, `${q.id}: "${question.question}" has no explanation`).toBeTruthy();
				indices.add(question.correctIndex);
			}
			expect(indices.size, `${q.id}: every correct answer is option ${[...indices][0]}`).toBeGreaterThan(1);
		}
	});

	it('points every quiz scene at a picture on disk, with words for the tutor', () => {
		for (const q of quizzes) {
			if (!q.image) continue;
			expect(existsSync(`static/img/${q.image}.webp`), `${q.id}: missing scene ${q.image}`).toBe(true);
			if (q.type === 'speaking') {
				expect(q.imageDescription, `${q.id}: scene without a description`).toBeTruthy();
			}
		}
	});

	it('gives every exercise a picture for its deck card (own scene or the shared card_<type>_<level>)', () => {
		for (const q of quizzes) {
			if (q.status === 'placeholder') continue;
			expect(q.image, `${q.id}: no card picture — add a manifest entry and run npm run images`).toBeTruthy();
		}
	});

	it('gives every flashcard deck sound cards: nouns with articles, no duplicates', () => {
		for (const q of quizzes) {
			if (q.type !== 'vocabulary') continue;
			expect(q.cards.length, `${q.id}: fewer than 40 cards`).toBeGreaterThanOrEqual(40);
			const seen = new Set<string>();
			for (const card of q.cards) {
				expect(card.de && card.en, `${q.id}: card without both sides`).toBeTruthy();
				if (card.kind === 'noun') {
					expect(card.article, `${q.id}: noun "${card.de}" has no article`).toMatch(/^(der|die|das)$/);
				} else {
					expect(card.article, `${q.id}: "${card.de}" is not a noun but has an article`).toBeUndefined();
				}
				const key = `${card.article ?? ''} ${card.de}`.trim();
				expect(seen.has(key), `${q.id}: duplicate card "${key}"`).toBe(false);
				seen.add(key);
				expect(
					quizzes.some((s) => s.id === card.sourceQuizId),
					`${q.id}: "${card.de}" points at unknown quiz ${card.sourceQuizId}`
				).toBe(true);
				if (card.image) {
					expect(
						existsSync(`static/img/${card.image}.webp`),
						`${q.id}: "${card.de}" points at missing picture ${card.image}`
					).toBe(true);
				}
			}
			// Choose mode needs three same-gender distractors for every noun.
			for (const article of ['der', 'die', 'das']) {
				const count = q.cards.filter((c) => c.article === article).length;
				if (count > 0) expect(count, `${q.id}: only ${count} "${article}" nouns`).toBeGreaterThanOrEqual(4);
			}
		}
	});

	it('gives every picture hunt a room on disk and sound, tappable spots', () => {
		for (const q of quizzes) {
			if (q.type !== 'suchbild') continue;
			expect(existsSync(`static/img/${q.scene}.webp`), `${q.id}: missing room ${q.scene}`).toBe(true);
			expect(q.sceneAlt, `${q.id}: room without alt text`).toBeTruthy();
			// A run is ten finds; fewer objects would repeat inside one run.
			expect(q.spots.length, `${q.id}: fewer than 10 spots`).toBeGreaterThanOrEqual(10);
			const seen = new Set<string>();
			for (const s of q.spots) {
				expect(s.article, `${q.id}: "${s.de}" has no article`).toMatch(/^(der|die|das)$/);
				expect(s.en, `${q.id}: "${s.de}" has no English`).toBeTruthy();
				expect(seen.has(s.de), `${q.id}: duplicate spot "${s.de}"`).toBe(false);
				seen.add(s.de);
				// Inside the picture, and big enough for a fingertip on a phone.
				for (const b of [s, ...(s.also ?? [])]) {
					expect(b.x >= 0 && b.y >= 0 && b.x + b.w <= 100 && b.y + b.h <= 100, `${q.id}: "${s.de}" leaves the picture`).toBe(true);
					expect(Math.min(b.w, b.h), `${q.id}: "${s.de}" is too small to tap`).toBeGreaterThanOrEqual(4);
				}
			}
		}
	});

	it('shapes authored help tables as {cells} rows with a caption', () => {
		for (const q of quizzes) {
			const table = q.help?.table;
			if (!table) continue;
			expect(Array.isArray(table.rows) && table.rows.length, `${q.id}: empty table`).toBeTruthy();
			for (const row of table.rows) {
				expect(Array.isArray((row as { cells?: unknown }).cells), `${q.id}: table row is not {cells}`).toBe(true);
			}
			expect('title' in table, `${q.id}: table uses "title" instead of "caption"`).toBe(false);
		}
	});

	it('shows learners no internal codes, author notes or brand names', () => {
		const forbidden = [
			/\bE\d{1,2}\s*[—-]\s/,
			/\(no:\s/i,
			/\bnein:\s/,
			/Erkundungen|Aspekte C|Hueber|Klett|Cornelsen/,
			/Goethe|telc|ÖSD|TestDaF|\bDSH\b/,
			/Kal[ée]ko/
		];
		for (const q of quizzes) {
			const text = JSON.stringify(q);
			for (const re of forbidden) {
				const m = re.exec(text);
				expect(m, `${q.id}: "${m?.[0]}" at …${text.slice(Math.max(0, (m?.index ?? 0) - 60), (m?.index ?? 0) + 60)}…`).toBeNull();
			}
		}
	});

	it('teaches the language, not the exam', () => {
		// The certificate is a side goal: only skill exercises carry the one-line
		// exam note, no help text names an exam task number, and learning help
		// gives the real reason — never "the exam tests it" or "you need it at B1".
		// tool/check-exam-framing.mjs prints the same findings per authoring file.
		const TASK = /\bTeil\s*\d|\b\d\s*Teile\b/;
		const FRAMING = /\b(exams?|examiners?|certificate|certification)\b|\b[ABC][12](\.[12])?\b/i;
		for (const q of quizzes) {
			const h = q.help;
			if (!h) continue;
			const skill = isSkill(q);
			expect(!!h.exam, `${q.id}: ${skill ? 'skill exercise without' : 'learning exercise with'} an exam note`).toBe(skill);
			if (h.exam) expect(h.exam, `${q.id}: exam task number`).not.toMatch(TASK);
			const prose = [
				h.intro,
				...(h.remember ?? []),
				...(h.tips ?? []).flatMap((t) => [t.title, t.text, t.trap]),
				h.table?.caption,
				...(h.table?.columns ?? []),
				...(h.mistakes ?? []).map((m) => m.why)
			].filter((s): s is string => typeof s === 'string');
			for (const s of prose) {
				expect(s, `${q.id}: exam task number`).not.toMatch(TASK);
				expect(s, `${q.id}: exam or level framing`).not.toMatch(FRAMING);
			}
			for (const t of h.tips ?? []) expect(t.kind, `${q.id}: exam tip`).not.toBe('exam');
		}
	});

	it('keeps the level out of exercise titles (the nav shows it)', () => {
		for (const q of quizzes) expect(q.title, q.id).not.toMatch(/^[ABC][12]\.[12]\s*·/);
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

	it('lists exam facts as an array in every module', () => {
		for (const m of syl.modules) {
			expect(Array.isArray(m.exam ?? []), `${m.level}: exam is not an array`).toBe(true);
		}
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
