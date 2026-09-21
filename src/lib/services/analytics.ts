// Privacy-first, cookieless usage analytics (Aptabase).
//
// Ported from lib/services/analytics.dart, but without the SDK: Aptabase's
// ingestion is one POST of a JSON envelope, and the Flutter plugin's extra —
// an on-device outbox — costs more than the events are worth here. An event
// that fails to send is simply dropped.
//
// Why this needs no cookie or consent banner: no cookie is set, no persistent
// identifier is stored (the session id lives in memory and expires after
// inactivity), and no personal data is collected. The server derives a coarse
// country from the request IP and then discards it.
//
// The ingestion key is a public client-side write key — it ships inside any
// web bundle regardless — so it is not a secret. Override or disable it per
// build with PUBLIC_APTABASE_APP_KEY (empty = analytics off entirely).

import { browser, dev } from '$app/environment';
import { env } from '$env/dynamic/public';

const DEFAULT_APP_KEY = 'A-EU-2341128762';

/** Ingestion host per key region, as the Aptabase SDKs resolve them. */
const HOSTS: Record<string, string> = {
	EU: 'https://eu.aptabase.com',
	US: 'https://us.aptabase.com',
	DEV: 'https://localhost:3000'
};

const appKey = env.PUBLIC_APTABASE_APP_KEY ?? DEFAULT_APP_KEY;
const region = appKey.split('-')[1] ?? '';
/** A self-hosted key (region `SH`) needs its host given explicitly. */
const host = env.PUBLIC_APTABASE_HOST || HOSTS[region] || '';

/** Only a well-formed `A-REG-0000000000` key with a known host can send. */
const enabled = appKey.split('-').length === 3 && host !== '';

/** A session is a run of activity; after this much idle time, a new one starts. */
const SESSION_TIMEOUT_MS = 60 * 60 * 1000;

let sessionId = '';
let lastTouched = 0;

/** In-memory only — nothing about the session is ever written to disk. */
function currentSession(): string {
	const now = Date.now();
	if (!sessionId || now - lastTouched > SESSION_TIMEOUT_MS) {
		sessionId = `${now}${Math.floor(Math.random() * 1e8)}`;
	}
	lastTouched = now;
	return sessionId;
}

/**
 * Fire-and-forget custom event. Safe to call from anywhere, including during
 * prerendering, where it is a no-op — analytics must never be able to break a
 * page, so every failure is swallowed.
 */
export function track(name: string, props: Record<string, string | number | boolean> = {}): void {
	if (!browser || !enabled) return;
	void fetch(`${host}/api/v0/event`, {
		method: 'POST',
		headers: { 'Content-Type': 'application/json', 'App-Key': appKey },
		// The request must not hold a navigation open.
		keepalive: true,
		body: JSON.stringify({
			timestamp: new Date().toISOString(),
			sessionId: currentSession(),
			eventName: name,
			systemProps: {
				isDebug: dev,
				locale: navigator.language,
				appVersion: '',
				sdkVersion: 'aptabase-web-fetch@1.0.0'
			},
			props
		})
	}).catch(() => {
		// Dropped. An event is never worth a console error in a learner's browser.
	});
}

let lastRoute: string | null = null;

/** Records one `screen_view`, ignoring the repeat notifications a nav emits. */
export function trackScreenView(path: string): void {
	if (!path || path === lastRoute) return;
	lastRoute = path;
	track('screen_view', { route: path });
}
