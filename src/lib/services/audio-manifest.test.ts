// The recorded-voice manifest written by tool/gen-audio.mjs: every entry must
// point at a clip that is on disk, or RecordedTtsProvider would 404 and the
// learner would silently get the fallback voice instead.
import { existsSync, readFileSync } from 'node:fs';
import { join } from 'node:path';
import { describe, expect, it } from 'vitest';

const dir = join(process.cwd(), 'static', 'audio');
const manifestPath = join(dir, 'manifest.json');

describe.runIf(existsSync(manifestPath))('recorded audio manifest', () => {
	const manifest: Record<string, Record<string, string>> = JSON.parse(readFileSync(manifestPath, 'utf8'));

	it('keys texts by BCP-47 locale', () => {
		for (const locale of Object.keys(manifest)) expect(locale).toMatch(/^[a-z]{2}-[A-Z]{2}$/);
	});

	it('points every text at a clip on disk', () => {
		const missing = Object.values(manifest)
			.flatMap((files) => Object.values(files))
			.filter((file) => !existsSync(join(dir, file)));
		expect(missing).toEqual([]);
	});

	it('stores texts trimmed, as the provider looks them up', () => {
		for (const files of Object.values(manifest))
			for (const text of Object.keys(files)) expect(text).toBe(text.trim());
	});
});
