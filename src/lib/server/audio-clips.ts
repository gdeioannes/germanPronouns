// Which recorded clip plays a given German text — read from the audio
// manifest shards on disk, so a prerendered page (the /play player, the book's
// audio index) can list the files without the browser fetching sixteen shards.

import { existsSync, readFileSync, readdirSync } from 'node:fs';
import { join } from 'node:path';

let cache: Map<string, string> | null = null;

/** text → file name in static/audio/, for the de-DE locale. */
export function audioClips(): Map<string, string> {
	if (cache) return cache;
	cache = new Map();
	const dir = join('static', 'audio', 'manifest');
	if (!existsSync(dir)) return cache;
	for (const name of readdirSync(dir)) {
		if (!name.endsWith('.json')) continue;
		const shard = JSON.parse(readFileSync(join(dir, name), 'utf8')) as Record<string, Record<string, string>>;
		for (const files of Object.values(shard)) for (const [text, file] of Object.entries(files)) cache.set(text, file);
	}
	return cache;
}

/** The clip for a text, if one was recorded. */
export function clipFor(text: string): string | null {
	return audioClips().get(text.trim()) ?? null;
}
