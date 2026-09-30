// Which piece of the split recorded-audio manifest a text lives in. The
// manifest (static/audio/manifest/<shard>.json) is cut into SHARDS files by
// this hash, so the first tap on a speak button downloads ~1/16 of it.
// tool/gen-audio.mjs loads this same module through Vite to write the files,
// so the two can never disagree.

export const SHARDS = 16;

/** "Ich heiße Anna." → one of "0" … "f". FNV-1a over UTF-16 code units. */
export function audioShard(text: string): string {
	let h = 2166136261;
	for (let i = 0; i < text.length; i++) h = Math.imul(h ^ text.charCodeAt(i), 16777619);
	return ((h >>> 0) % SHARDS).toString(16);
}
