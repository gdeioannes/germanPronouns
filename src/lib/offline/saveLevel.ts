// "Save this level for offline": downloads a level's pages, recorded audio
// and pictures into the caches the service worker (src/service-worker.ts)
// answers from, so the level works on the U-Bahn without ever having been
// opened. Runs in the page, not the worker, so it works the same before the
// worker is installed; the cache names must match the worker's.

import { storage } from '$lib/services/storage';

export const PAGES_CACHE = 'pages';
export const MEDIA_CACHE = 'media';
/** Saved levels: { "A1.1": <ms timestamp> }. */
export const OFFLINE_LEVELS_KEY = 'offline_levels';

export interface OfflineLevel {
	level: string;
	/** Page paths and their __data.json, network-fetched every save. */
	pages: string[];
	/** Audio manifest shards and clips; a clip already cached is skipped. */
	media: string[];
	/** Size of the level's audio, for the button's estimate. */
	bytes: number;
}

export interface SaveProgress {
	done: number;
	total: number;
}

const PARALLEL = 6;
/** Pictures a saved page shows: /img/... in src, href or srcset. */
const IMG_REF = /\/img\/[^"'\s,)]+\.(?:webp|png|jpg|svg)/g;

export function offlineSupported(): boolean {
	return typeof caches !== 'undefined' && 'serviceWorker' in navigator;
}

export async function savedLevels(): Promise<Record<string, number>> {
	try {
		return JSON.parse((await storage.get(OFFLINE_LEVELS_KEY)) ?? '{}');
	} catch {
		return {};
	}
}

export async function fetchOfflineList(level: string): Promise<OfflineLevel> {
	const res = await fetch(`/offline/${level}.json`);
	if (!res.ok) throw new Error(`No offline list for ${level}`);
	return res.json();
}

/**
 * Downloads everything in the list; resolves with how many files failed.
 * Pages always refresh, media only when missing (a clip's name is its hash).
 */
export async function saveLevel(list: OfflineLevel, onProgress: (p: SaveProgress) => void): Promise<number> {
	const pages = await caches.open(PAGES_CACHE);
	const media = await caches.open(MEDIA_CACHE);
	const pictures = new Set<string>();
	let done = 0;
	let failed = 0;
	let total = list.pages.length + list.media.length;
	const tick = () => onProgress({ done, total });

	async function run(urls: string[], job: (url: string) => Promise<void>) {
		const queue = [...urls];
		await Promise.all(
			Array.from({ length: PARALLEL }, async () => {
				for (let url = queue.shift(); url; url = queue.shift()) {
					try {
						await job(url);
					} catch {
						failed++;
					}
					done++;
					tick();
				}
			})
		);
	}

	tick();
	await run(list.pages, async (url) => {
		const res = await fetch(url, { cache: 'no-cache' });
		if (!res.ok) {
			// Not every page has a server data file; that is not a failure.
			if (url.endsWith('/__data.json') && res.status === 404) return;
			throw new Error(`${res.status} ${url}`);
		}
		if (!url.endsWith('.json')) for (const m of (await res.clone().text()).match(IMG_REF) ?? []) pictures.add(m);
		await pages.put(url, res);
	});

	// The manifest shards change with every recording run; refresh them too.
	const isManifest = (url: string) => url.startsWith('/audio/manifest/');
	const mediaUrls = [...list.media, ...pictures];
	total = list.pages.length + mediaUrls.length;
	await run(mediaUrls, async (url) => {
		if (!isManifest(url) && (await media.match(url))) return;
		const res = await fetch(url);
		if (!res.ok) throw new Error(`${res.status} ${url}`);
		await media.put(url, res);
	});

	const saved = await savedLevels();
	saved[list.level] = Date.now();
	await storage.set(OFFLINE_LEVELS_KEY, JSON.stringify(saved));
	return failed;
}

/** Megabytes, rounded for a button: "about 24 MB". */
export function megabytes(bytes: number): number {
	return Math.max(1, Math.round(bytes / 1_000_000));
}
