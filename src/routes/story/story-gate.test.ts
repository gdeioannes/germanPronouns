// The story formula's gate (docs/story_bible.md → "The numbers"): every
// episode must hold these invariants or it doesn't ship.
import { describe, expect, it } from 'vitest';
import { existsSync, readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { join } from 'node:path';

const root = fileURLToPath(new URL('../../..', import.meta.url));
const ep = JSON.parse(
	readFileSync(join(root, 'assets', 'content', 'stories', 'ep1_empty_room.json'), 'utf8')
);

type Beat = Record<string, unknown> & { id: string; type: string };
const beats: Beat[] = ep.chapters.flatMap((c: { beats: Beat[] }) => c.beats);

function questionCount(ch: { beats: Beat[] }): number {
	let n = 0;
	for (const b of ch.beats) {
		if (b.type !== 'quiz') continue;
		const q = (b.quiz ?? b) as Beat;
		if (Array.isArray(q.blanks)) n += q.blanks.length;
		else if (Array.isArray(b.questions)) n += (b.questions as unknown[]).length;
		else n += 1;
	}
	return n;
}

describe(`story gate: ${ep.id}`, () => {
	it('every pool has at least 3 variants', () => {
		for (const [name, values] of Object.entries(ep.pools))
			expect((values as string[]).length, name).toBeGreaterThanOrEqual(3);
	});

	it('every pool reference resolves to a real pool', () => {
		const text = JSON.stringify(ep);
		for (const m of text.matchAll(/\{pool:([a-zA-Z]+)(?::other\d)?\}/g))
			expect(ep.pools[m[1]], m[0]).toBeDefined();
	});

	it('every evidence chapter asks at least 3 questions', () => {
		for (const ch of ep.chapters) {
			if (!ch.clue) continue;
			expect(questionCount(ch), ch.id).toBeGreaterThanOrEqual(3);
		}
	});

	it('cloze beats have enough blanks and sorts enough items', () => {
		for (const b of beats) {
			if (b.kind === 'bigText') expect(((b.quiz ?? b) as Beat).blanks, b.id).toHaveLength(7);
			if (b.kind === 'orderedPick' && b.layout === 'tiles')
				expect((b.sequence as string[]).length, b.id).toBeGreaterThanOrEqual(6);
		}
	});

	it('hub clues are all grantable and the finale is gated on them', () => {
		const granted = ep.chapters.map((c: Beat) => c.clue).filter(Boolean);
		for (const c of ep.hub.requiredClues) expect(granted, c).toContain(c);
		expect(ep.chapters.some((c: Beat) => c.id === ep.hub.unlocks)).toBe(true);
		for (const lead of ep.hub.leads)
			expect(ep.chapters.some((c: Beat) => c.id === lead), lead).toBe(true);
	});

	it('every beat has an image and every image file exists', () => {
		for (const b of beats) {
			expect(b.image, `${b.id} has no image`).toBeTruthy();
			const file = join(root, 'static', (b.image as string).replace('story/', 'img/story/') + '.webp');
			expect(existsSync(file), `${b.image}`).toBe(true);
		}
	});

	it('every scripted audio key exists on disk (all pool variants)', () => {
		for (const b of beats) {
			if (!b.audio) continue;
			const key = b.audio as string;
			const base = key.replace('story/', '').replace(/_\{pool:[a-zA-Z]+\}$/, '');
			const pool = key.match(/\{pool:([a-zA-Z]+)\}/)?.[1];
			const variants = pool ? (ep.pools[pool] as string[]).map((_, i) => `_${i}`) : [''];
			for (const v of variants) {
				const file = join(root, 'static', 'audio', 'story', `${base}${v}.mp3`);
				expect(existsSync(file), `${base}${v}.mp3`).toBe(true);
			}
		}
	});

	it('every narrative panel has its narration recorded', () => {
		for (const ch of ep.chapters)
			for (const b of ch.beats as Beat[]) {
				if (b.type !== 'narrative' || `${b.audio ?? ''}`.includes('podcast')) continue;
				const pool = `${b.text}`.match(/\{pool:([a-zA-Z]+)\}/)?.[1];
				const variants = pool ? (ep.pools[pool] as string[]).map((_, i) => `_${i}`) : [''];
				for (const v of variants)
					expect(
						existsSync(join(root, 'static', 'audio', 'story', `ep1_narr_${b.id}${v}.mp3`)),
						`ep1_narr_${b.id}${v}.mp3`
					).toBe(true);
			}
	});

	it('recall decoys use the other-variant syntax, never literals of another pool draw', () => {
		for (const b of beats) {
			if (b.kind !== 'recall' || !Array.isArray(b.options)) continue;
			const opts = b.options as { text: string; correct: boolean }[];
			const pooled = opts.filter((o) => o.text.includes('{pool:'));
			if (pooled.length) {
				expect(pooled.some((o) => o.correct), b.id).toBe(true);
				for (const o of pooled)
					if (!o.correct) expect(o.text, b.id).toMatch(/\{pool:[a-zA-Z]+:other\d\}/);
			}
		}
	});

	it('micro-checks exist after most chapters', () => {
		expect(ep.microChecks.length).toBeGreaterThanOrEqual(3);
		for (const m of ep.microChecks)
			expect(ep.chapters.some((c: Beat) => c.id === m.after), m.after).toBe(true);
	});
});
