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
//     (its file name is a hash of its text and voice).
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

sw.addEventListener('install', (event) => {
	event.waitUntil(
		caches
			.open(SHELL)
			.then((cache) => cache.addAll([...shell]))
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

function isMedia(url: URL): boolean {
	return /^\/(audio|img|workbooks|books)\//.test(url.pathname) || /\.(mp3|webp|png|jpg|svg|woff2|pdf)$/.test(url.pathname);
}

function isPage(request: Request, url: URL): boolean {
	if (request.mode === 'navigate') return true;
	// SvelteKit's prerendered pages, and the client-side data they load.
	return prerendered.includes(url.pathname) || url.pathname.endsWith('/__data.json');
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
		event.respondWith(
			caches.open(PAGES).then(async (cache) => {
				try {
					const fresh = await fetch(request);
					if (fresh.ok) void cache.put(request, fresh.clone());
					return fresh;
				} catch {
					const hit = await cache.match(request);
					if (hit) return hit;
					// A page never opened before: the home page, which is in the
					// shell list of prerendered pages only if it was visited; fall
					// back to the 404 page SvelteKit prerenders for GitHub Pages.
					const home = await cache.match('/');
					return home ?? Response.error();
				}
			})
		);
	}
});
