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

// Bot handling: tag, never suppress. Every event carries a `visitor` prop so
// the dashboard can filter screen_views to humans while total reach stays
// visible. The regex matches the crawlers/tools that execute JS; webdriver
// catches headless automation (Puppeteer/Playwright) even behind a spoofed UA.
const BOT_UA =
	/bot|spider|crawl|preview|headless|slurp|facebookexternalhit|whatsapp|telegram|lighthouse|gtmetrix|pingdom|uptime|monitor|scrape|wget|curl|python|node-fetch|axios/i;

function visitorKind(): 'bot' | 'human' {
	try {
		if (navigator.webdriver || BOT_UA.test(navigator.userAgent)) return 'bot';
		return 'human';
	} catch {
		return 'bot';
	}
}

// ---------------------------------------------------------------------------
// Traffic attribution: where did this visit come from?
//
// Resolved once per page load, from the strongest signal available, and then
// attached to EVERY event (not just the landing screen_view) so any metric in
// the dashboard can be segmented by source:
//
//   1. utm_source / ref query params — explicit tags on links we post; the
//      only signal that survives in-app browsers (Instagram, TikTok strip the
//      referrer, especially on iOS).
//   2. Ad click ids (gclid/fbclid/ttclid/msclkid/twclid) — present even when
//      no UTM was set on the ad.
//   3. document.referrer — mapped to a friendly name and a channel; unknown
//      hosts keep their hostname so new sources surface instead of vanishing
//      into an "other" bucket.
//   4. Nothing → "direct".
//
// Still cookieless: nothing is persisted, so a learner returning tomorrow via
// a bookmark counts as "direct" even if they first found us on Google. That
// is the honest trade-off of consent-free analytics.
// ---------------------------------------------------------------------------

type Attribution = { source: string; channel: string; campaign?: string; medium?: string };

/** referrer hostname fragment → [friendly name, channel]; first match wins. */
const REFERRERS: [string, string, string][] = [
	// Search engines
	['google.', 'google', 'search'],
	['bing.com', 'bing', 'search'],
	['duckduckgo.com', 'duckduckgo', 'search'],
	['search.yahoo.', 'yahoo', 'search'],
	['yandex.', 'yandex', 'search'],
	['ecosia.org', 'ecosia', 'search'],
	['search.brave.com', 'brave', 'search'],
	['startpage.com', 'startpage', 'search'],
	['qwant.com', 'qwant', 'search'],
	['baidu.com', 'baidu', 'search'],
	// Social
	['instagram.com', 'instagram', 'social'],
	['facebook.com', 'facebook', 'social'],
	['fb.com', 'facebook', 'social'],
	['tiktok.com', 'tiktok', 'social'],
	['youtube.com', 'youtube', 'social'],
	['youtu.be', 'youtube', 'social'],
	['twitter.com', 'x', 'social'],
	['x.com', 'x', 'social'],
	['t.co', 'x', 'social'],
	['reddit.com', 'reddit', 'social'],
	['linkedin.com', 'linkedin', 'social'],
	['lnkd.in', 'linkedin', 'social'],
	['pinterest.', 'pinterest', 'social'],
	['threads.net', 'threads', 'social'],
	['bsky.app', 'bluesky', 'social'],
	['mastodon', 'mastodon', 'social'],
	['t.me', 'telegram', 'social'],
	['telegram.org', 'telegram', 'social'],
	['whatsapp.com', 'whatsapp', 'social'],
	['discord.com', 'discord', 'social'],
	['snapchat.com', 'snapchat', 'social'],
	// AI assistants — a growing discovery channel worth its own bucket
	['chatgpt.com', 'chatgpt', 'ai'],
	['chat.openai.com', 'chatgpt', 'ai'],
	['perplexity.ai', 'perplexity', 'ai'],
	['claude.ai', 'claude', 'ai'],
	['gemini.google.com', 'gemini', 'ai'],
	['copilot.microsoft.com', 'copilot', 'ai']
];

/** Ad click-id param → source it implies when no utm_source was set. */
const CLICK_IDS: [string, string, string][] = [
	['gclid', 'google', 'paid'],
	['wbraid', 'google', 'paid'],
	['gbraid', 'google', 'paid'],
	['fbclid', 'facebook', 'social'],
	['igshid', 'instagram', 'social'],
	['ttclid', 'tiktok', 'paid'],
	['msclkid', 'bing', 'paid'],
	['twclid', 'x', 'paid']
];

/** Lowercased, trimmed to something safe to show on a dashboard. */
function cleanParam(value: string | null): string {
	return (value ?? '').trim().toLowerCase().slice(0, 60);
}

function resolveAttribution(): Attribution {
	try {
		const params = new URLSearchParams(location.search);

		// 1. Explicit tagging beats everything.
		const utm = cleanParam(params.get('utm_source')) || cleanParam(params.get('ref'));
		if (utm) {
			const attribution: Attribution = { source: utm, channel: 'campaign' };
			const medium = cleanParam(params.get('utm_medium'));
			const campaign = cleanParam(params.get('utm_campaign'));
			if (medium) attribution.medium = medium;
			if (campaign) attribution.campaign = campaign;
			return attribution;
		}

		// 2. An ad click id identifies the platform even untagged.
		for (const [param, source, channel] of CLICK_IDS) {
			if (params.has(param)) return { source, channel };
		}

		// 3. Referrer, ignoring our own origin (hard reloads mid-site).
		if (document.referrer) {
			const host = new URL(document.referrer).hostname.toLowerCase();
			if (host && host !== location.hostname) {
				for (const [fragment, source, channel] of REFERRERS) {
					if (host.includes(fragment)) return { source, channel };
				}
				// Android apps often arrive as android-app://com.vendor.app
				if (document.referrer.startsWith('android-app://')) {
					return { source: host, channel: 'app' };
				}
				return { source: host.replace(/^www\./, ''), channel: 'referral' };
			}
		}
	} catch {
		// Attribution is best-effort; a malformed referrer is just "direct".
	}
	return { source: 'direct', channel: 'direct' };
}

/** Resolved lazily on the first event, when location/referrer are final. */
let attribution: Attribution | null = null;

// ---------------------------------------------------------------------------
// New vs returning, within the EU audience-measurement exemption (CNIL/TTDSG):
// one localStorage key holding a first-visit DATE (day precision, nothing
// unique — thousands of visitors share any given value), used only for
// aggregate statistics, never sent raw (only a boolean and a coarse bucket),
// shared with no third party for its own purposes, and expired at the CNIL
// 13-month horizon, after which the visitor counts as new again. Disclosed in
// Settings → Privacy. Storage can be blocked or cleared at any time; the
// visitor then simply counts as new, which is the correct failure mode.
// ---------------------------------------------------------------------------

const FIRST_SEEN_KEY = 'lq_first_seen';
const FIRST_SEEN_MAX_AGE_MS = 13 * 30 * 24 * 60 * 60 * 1000;

type Tenure = { returning: boolean; days_since_first: '0' | '1-7' | '8-30' | '30+' };

function resolveTenure(): Tenure {
	const today = new Date().toISOString().slice(0, 10);
	try {
		const stored = localStorage.getItem(FIRST_SEEN_KEY) ?? '';
		const firstSeen = Date.parse(stored);
		const age = Date.now() - firstSeen;
		if (!stored || Number.isNaN(firstSeen) || age > FIRST_SEEN_MAX_AGE_MS) {
			localStorage.setItem(FIRST_SEEN_KEY, today);
			return { returning: false, days_since_first: '0' };
		}
		const days = Math.floor(age / (24 * 60 * 60 * 1000));
		return {
			returning: days > 0,
			days_since_first: days < 1 ? '0' : days <= 7 ? '1-7' : days <= 30 ? '8-30' : '30+'
		};
	} catch {
		// Storage blocked (private mode, hardened browser): count as new.
		return { returning: false, days_since_first: '0' };
	}
}

let tenure: Tenure | null = null;

/** "Start over" in Settings erases the statistics marker along with progress. */
export function forgetFirstSeen(): void {
	try {
		localStorage.removeItem(FIRST_SEEN_KEY);
	} catch {
		// Storage blocked — nothing was kept anyway.
	}
	tenure = null;
}

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
			props: {
				visitor: visitorKind(),
				...(attribution ??= resolveAttribution()),
				...(tenure ??= resolveTenure()),
				...props
			}
		})
	}).catch(() => {
		// Dropped. An event is never worth a console error in a learner's browser.
	});
}

// `engaged` fires once per visit, the first time the visitor behaves like a
// person: an interaction (pointer, key, touch, scroll) or ten seconds with the
// tab visible. Sessions with an `engaged` event are near-certainly human even
// when the UA check above was fooled, giving three tiers in the dashboard:
// all views → views where visitor=human → engaged visits.
const ENGAGED_DWELL_MS = 10 * 1000;
let engagedSent = false;

function markEngaged(via: 'interaction' | 'dwell'): void {
	if (engagedSent) return;
	engagedSent = true;
	track('engaged', { via, route: lastRoute ?? '' });
}

if (browser) {
	const once = { once: true, passive: true } as const;
	for (const type of ['pointerdown', 'keydown', 'touchstart', 'scroll'] as const) {
		window.addEventListener(type, () => markEngaged('interaction'), once);
	}
	setTimeout(() => {
		if (document.visibilityState === 'visible') markEngaged('dwell');
	}, ENGAGED_DWELL_MS);
}

let lastRoute: string | null = null;

/** Records one `screen_view`, ignoring the repeat notifications a nav emits. */
export function trackScreenView(path: string): void {
	if (!path || path === lastRoute) return;
	lastRoute = path;
	track('screen_view', { route: path });
}
