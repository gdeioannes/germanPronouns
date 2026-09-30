// The recorded-voice manifest written by tool/gen-audio.mjs, split into
// static/audio/manifest/<shard>.json: every entry must point at a clip that is
// on disk and sit in the shard the app will look in, or RecordedTtsProvider
// would miss it and the learner would silently get the fallback voice.
import { existsSync, readdirSync, readFileSync } from 'node:fs';
import { join } from 'node:path';
import { describe, expect, it } from 'vitest';
import { SHARDS, audioShard } from '$lib/audio/shard';

const dir = join(process.cwd(), 'static', 'audio');
const shardDir = join(dir, 'manifest');

describe('audioShard', () => {
	it('picks one of SHARDS hex names, the same every time', () => {
		for (const text of ['Hallo!', 'Ich heiße Anna.', 'der Apfel', 'Tschüss!', '']) {
			const shard = audioShard(text);
			expect(parseInt(shard, 16)).toBeLessThan(SHARDS);
			expect(audioShard(text)).toBe(shard);
		}
	});

	it('spreads texts across the shards', () => {
		const used = new Set(Array.from({ length: 200 }, (_, i) => audioShard(`Satz ${i}`)));
		expect(used.size).toBe(SHARDS);
	});
});

describe.runIf(existsSync(shardDir))('recorded audio manifest', () => {
	const shards = readdirSync(shardDir)
		.filter((name) => name.endsWith('.json'))
		.map((name) => ({
			shard: name.slice(0, -'.json'.length),
			manifest: JSON.parse(readFileSync(join(shardDir, name), 'utf8')) as Record<string, Record<string, string>>
		}));

	it('replaced the single-file manifest', () => {
		expect(existsSync(join(dir, 'manifest.json'))).toBe(false);
	});

	it('keys texts by BCP-47 locale', () => {
		for (const { manifest } of shards)
			for (const locale of Object.keys(manifest)) expect(locale).toMatch(/^[a-z]{2}-[A-Z]{2}$/);
	});

	it('files every text in the shard the app looks in', () => {
		const misplaced = shards.flatMap(({ shard, manifest }) =>
			Object.values(manifest)
				.flatMap((files) => Object.keys(files))
				.filter((text) => audioShard(text) !== shard)
		);
		expect(misplaced).toEqual([]);
	});

	it('points every text at a clip on disk', () => {
		const missing = shards
			.flatMap(({ manifest }) => Object.values(manifest).flatMap((files) => Object.values(files)))
			.filter((file) => !existsSync(join(dir, file)));
		expect(missing).toEqual([]);
	});

	it('stores texts trimmed, as the provider looks them up', () => {
		for (const { manifest } of shards)
			for (const files of Object.values(manifest))
				for (const text of Object.keys(files)) expect(text).toBe(text.trim());
	});
});
