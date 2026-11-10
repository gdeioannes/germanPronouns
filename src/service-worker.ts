/// <reference types="@sveltejs/kit" />
/// <reference no-default-lib="true"/>
/// <reference lib="esnext" />
/// <reference lib="webworker" />

// Offline support. The site is static, so a cache of what the learner has
// already opened is enough to keep studying on the U-Bahn:
//
//   - the app shell (the built JS and CSS, fonts, icons) is cached on install;
//   - every page, picture and audio clip is cached the first time it loads,
//     and served from the cache when the network is slow or gone;
//   - pages are tried on the network first, so a new release shows up on the
//     next online visit; media is cache-first, because a clip never changes
//     (its file name is a hash of its text and voice). The audio manifest is
//     the exception: it grows with every recording run, so it is network-first;
//   - "Save this level for offline" (lib/offline/saveLevel) fills the same
//     two caches ahead of time, so the cache names are shared with it.
//
// Nothing of Firebase or Aptabase is touched: those requests go straight to
// the network, and fail quietly offline as they already do.

import { build, files, prerendered, version } from '$service-worker';

const sw = self as unknown as ServiceWorkerGlobalScope;

const SHELL = `shell-${version}`;
/** Pages, keyed by URL; network first. */
const PAGES = 'pages';
/** Audio, pictures, workbooks: cache first, kept across releases. */
const MEDIA = 'media';

/** The static files small enough to take on install: icons, manifest, fonts, not the audio. */
const shellFiles = files.filter((f) => !/^\/(audio|img|workbooks|books|og)\//.test(f));
const shell = new Set([...build, ...shellFiles]);

/**
 * SvelteKit's runtime env module: not a build file, but every page imports
 * it while starting, so without it an offline page shows but never wakes up.
 */
const ENV = '/_app/env.js';

sw.addEventListener('install', (event) => {
	event.waitUntil(
		caches
			.open(SHELL)
			.then(async (cache) => {
				await cache.addAll([...shell]);
				await caches.open(PAGES).then((pages) => pages.add(ENV)).catch(() => {});
			})
			.then(() => sw.skipWaiting())
	);
});

sw.addEventListener('activate', (event) => {
	event.waitUntil(
		caches
			.keys()
			.then((keys) => Promise.all(keys.filter((k) => k.startsWith('shell-') && k !== SHELL).map((k) => caches.delete(k))))
			.then(() => sw.clients.claim())
	);
});

function isManifest(url: URL): boolean {
	return url.pathname.startsWith('/audio/manifest/');
}

function isMedia(url: URL): boolean {
	return /^\/(audio|img|workbooks|books)\//.test(url.pathname) || /\.(mp3|webp|png|jpg|svg|woff2|pdf)$/.test(url.pathname);
}

function isData(url: URL): boolean {
	return url.pathname.endsWith('/__data.json');
}

function isPage(request: Request, url: URL): boolean {
	if (request.mode === 'navigate') return true;
	// SvelteKit's prerendered pages, and the client-side data they load.
	return prerendered.includes(url.pathname) || isData(url);
}

/** Network first, the cache when offline; data files are stored without SvelteKit's query string. */
function networkFirst(cacheName: string, request: Request, url: URL, fallback?: () => Promise<Response | undefined>) {
	const key = isData(url) ? url.origin + url.pathname : request;
	return caches.open(cacheName).then(async (cache) => {
		try {
			const fresh = await fetch(request);
			if (fresh.ok) void cache.put(key, fresh.clone());
			return fresh;
		} catch {
			const hit = await cache.match(key, { ignoreSearch: isData(url) });
			if (hit) return hit;
			return (await fallback?.()) ?? Response.error();
		}
	});
}

sw.addEventListener('fetch', (event) => {
	const { request } = event;
	if (request.method !== 'GET') return;
	const url = new URL(request.url);
	if (url.origin !== sw.location.origin) return;

	if (shell.has(url.pathname)) {
		event.respondWith(caches.match(request).then((hit) => hit ?? fetch(request)));
		return;
	}

	if (url.pathname === ENV) {
		event.respondWith(networkFirst(PAGES, request, url));
		return;
	}

	if (isManifest(url)) {
		event.respondWith(networkFirst(MEDIA, request, url));
		return;
	}

	if (isMedia(url)) {
		event.respondWith(
			caches.open(MEDIA).then(async (cache) => {
				const hit = await cache.match(request);
				if (hit) return hit;
				const fresh = await fetch(request);
				if (fresh.ok) void cache.put(request, fresh.clone());
				return fresh;
			})
		);
		return;
	}

	if (isPage(request, url)) {
		// A page never opened or saved: the home page, if that was visited.
		event.respondWith(networkFirst(PAGES, request, url, () => caches.match('/')));
	}
});
