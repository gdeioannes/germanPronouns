// The story formula's gate (docs/story_bible.md → "The numbers"): every
// episode must hold these invariants or it doesn't ship.
import { describe, expect, it } from 'vitest';
import { existsSync, readdirSync, readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { join } from 'node:path';
import { NODES, PLACES } from '$lib/components/story/kiez';
import { storyNotebook } from '$lib/audio/spoken-texts';

const root = fileURLToPath(new URL('../../..', import.meta.url));
const storiesDir = join(root, 'assets', 'content', 'stories');
const episodes = readdirSync(storiesDir)
	.filter((f) => f.endsWith('.json'))
	.map((f) => JSON.parse(readFileSync(join(storiesDir, f), 'utf8')));

type Beat = Record<string, unknown> & { id: string; type: string };
type Line = Record<string, unknown> & { who: string };

/** Beats that draw their own picture (the code-drawn Kiez map). */
const NO_IMAGE_KINDS = new Set(['map']);

function questionCount(ch: { beats: Beat[] }): number {
	let n = 0;
	for (const b of ch.beats) {
		if (b.type !== 'quiz') continue;
		const q = (b.quiz ?? b) as Beat;
		if (Array.isArray(q.blanks)) n += q.blanks.length;
		else if (Array.isArray(b.questions)) n += (b.questions as unknown[]).length;
		else if (b.kind === 'dialogue') n += (b.lines as Line[]).filter((l) => l.choose || l.build).length;
		else n += 1;
	}
	return n;
}

/** Every pooled audio key → the files it needs on disk. */
function audioFiles(ep: { pools: Record<string, string[]> }, key: string): string[] {
	const base = key.replace('story/', '').replace(/_\{pool:[a-zA-Z]+\}$/, '');
	const pool = key.match(/\{pool:([a-zA-Z]+)\}/)?.[1];
	const variants = pool ? ep.pools[pool].map((_, i) => `_${i}`) : [''];
	return variants.map((v) => `${base}${v}.mp3`);
}

for (const ep of episodes) {
	const beats: Beat[] = ep.chapters.flatMap((c: { beats: Beat[] }) => c.beats);
	const prefix = ep.id.split('_')[0];
	const lines = beats.flatMap((b) => (b.kind === 'dialogue' ? (b.lines as Line[]) : []));

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
			const keys = beats.filter((b) => !NO_IMAGE_KINDS.has(b.kind as string)).map((b) => b.image);
			for (const extra of [ep.cover, ep.ending?.image]) if (extra) keys.push(extra);
			for (const key of keys) {
				expect(key, `a beat has no image`).toBeTruthy();
				const file = join(root, 'static', (key as string).replace('story/', 'img/story/') + '.webp');
				expect(existsSync(file), `${key}`).toBe(true);
			}
		});

		it('every scripted audio key exists on disk (all pool variants)', () => {
			const keys = [...beats.map((b) => b.audio), ...lines.map((l) => l.audio)].filter(Boolean);
			for (const key of keys as string[])
				for (const file of audioFiles(ep, key))
					expect(existsSync(join(root, 'static', 'audio', 'story', file)), file).toBe(true);
		});

		it('every narrative panel has its narration recorded', () => {
			for (const b of beats) {
				if (b.type !== 'narrative' || `${b.audio ?? ''}`.includes('podcast')) continue;
				const pool = `${b.text}`.match(/\{pool:([a-zA-Z]+)\}/)?.[1];
				const variants = pool ? (ep.pools[pool] as string[]).map((_, i) => `_${i}`) : [''];
				for (const v of variants)
					expect(
						existsSync(join(root, 'static', 'audio', 'story', `${prefix}_narr_${b.id}${v}.mp3`)),
						`${prefix}_narr_${b.id}${v}.mp3`
					).toBe(true);
			}
		});

		it('recall decoys use the other-variant syntax, never literals of another pool draw', () => {
			const recalls = [...beats, ...ep.microChecks].filter((b: Beat) => b.kind === 'recall');
			for (const b of recalls) {
				if (!Array.isArray(b.options)) continue;
				const opts = b.options as { text: string; correct: boolean }[];
				const pooled = opts.filter((o) => o.text.includes('{pool:'));
				if (pooled.length) {
					expect(pooled.some((o) => o.correct), b.id ?? b.after).toBe(true);
					for (const o of pooled)
						if (!o.correct) expect(o.text, b.id ?? b.after).toMatch(/\{pool:[a-zA-Z]+:other\d\}/);
				}
			}
		});

		it('micro-checks exist after most chapters', () => {
			expect(ep.microChecks.length).toBeGreaterThanOrEqual(3);
			for (const m of ep.microChecks)
				expect(ep.chapters.some((c: Beat) => c.id === m.after), m.after).toBe(true);
		});

		it('every choice and pick has exactly one right answer', () => {
			for (const b of beats)
				if (Array.isArray(b.options) && typeof (b.options as unknown[])[0] === 'object')
					expect((b.options as { correct: boolean }[]).filter((o) => o.correct), b.id).toHaveLength(1);
			for (const l of lines)
				if (l.choose) expect((l.choose as { correct: boolean }[]).filter((o) => o.correct)).toHaveLength(1);
		});

		it('word builds can be finished with their tiles (every pool variant)', () => {
			const variants = Math.max(1, ...Object.values(ep.pools).map((v) => (v as string[]).length));
			const fill = (t: string, i: number) =>
				t.replace(/{pool:([a-zA-Z]+)}/g, (_, n) => ep.pools[n][i % ep.pools[n].length]);
			for (const l of lines) {
				const build = l.build as { sequence: string[]; options?: string[] } | undefined;
				if (!build) continue;
				for (let i = 0; i < variants; i++) {
					const tiles = (build.options ?? build.sequence).map((t) => fill(t, i));
					for (const w of build.sequence) expect(tiles, fill(w, i)).toContain(fill(w, i));
					expect(new Set(build.sequence.map((w) => fill(w, i))).size, 'sequence tiles are unique').toBe(build.sequence.length);
				}
				expect(new Set(build.options ?? build.sequence).size, 'tiles are unique').toBe(
					(build.options ?? build.sequence).length
				);
			}
		});

		it('every notebook word has a recorded clip (npm run audio)', () => {
			const dir = join(root, 'static', 'audio', 'manifest');
			const recorded = new Set<string>();
			for (const f of readdirSync(dir))
				for (const t of Object.keys(JSON.parse(readFileSync(join(dir, f), 'utf8'))['de-DE'] ?? {}))
					recorded.add(t);
			for (const de of storyNotebook(ep)) expect(recorded.has(de.trim()), de).toBe(true);
		});

		it('hotspots and map beats point at things that exist', () => {
			for (const b of beats) {
				if (b.kind === 'hotspot') {
					const ids = (b.spots as { id: string }[]).map((s) => s.id);
					const m = `${b.answer}`.match(/^\{pool:([a-zA-Z]+)\}$/);
					for (const a of m ? ep.pools[m[1]] : [b.answer]) expect(ids, b.id).toContain(a);
				}
				if (b.kind === 'map' && b.mode === 'find') {
					const target = b.target as string;
					const m = target.match(/^\{pool:([a-zA-Z]+)\}$/);
					for (const t of m ? ep.pools[m[1]] : [target]) expect(Object.keys(PLACES), b.id).toContain(t);
				}
				if (b.kind === 'map' && b.mode === 'walk') {
					const walks = b.walks as { turns: string[]; path: string[] }[];
					expect(walks.length, `${b.id}: one walk per variant`).toBe(ep.pools[b.walkPool as string].length);
					for (const w of walks) {
						expect(w.path.length, b.id).toBe(w.turns.length + 1);
						for (const n of w.path) expect(Object.keys(NODES), b.id).toContain(n);
					}
				}
				if (b.kind === 'stops') expect(ep.pools[b.pool as string], b.id).toBeDefined();
			}
		});
	});
}
