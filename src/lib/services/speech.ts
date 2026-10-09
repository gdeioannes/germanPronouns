// The platform seam for speech. Everything that touches a platform API lives
// behind these two interfaces, so wrapping the app with Capacitor later means
// adding one implementation per interface — not touching any component.
//
// This mirrors the abstraction the Flutter app already had
// (`lib/services/tts/tts_provider.dart`: an interface with cloud and device
// implementations, chained with a fallback). Keep that shape: it is why the
// mobile story stays cheap.
//
// Web today  → Web Speech API (`speechSynthesis` / `SpeechRecognition`).
// Mobile later → @capacitor-community/text-to-speech and
//                @capacitor-community/speech-recognition. Recognition in
//                particular is unreliable in iOS WKWebView, so the native
//                plugin is the reason to wrap rather than ship a bare PWA.

import { env } from '$env/dynamic/public';
import { isMuted } from './mute';
import { audioShard } from '$lib/audio/shard';

/**
 * The project's deployed TTS Worker. Not a secret — it holds the keys, this
 * only knows its address. Override per build with PUBLIC_TTS_PROXY_URL, or set
 * it empty to ship device voices only.
 */
const DEFAULT_TTS_PROXY = 'https://german-tts-proxy.gdeioannes.workers.dev';

export interface SpeakOptions {
	/** BCP-47 tag of the language being spoken, e.g. `de-DE`. */
	locale: string;
	/** 0.5–2.0, where 1 is the voice's natural pace. */
	rate?: number;
}

export interface TtsProvider {
	readonly name: string;
	/** Whether this provider can run here at all (feature detection). */
	isAvailable(): Promise<boolean>;
	speak(text: string, options: SpeakOptions): Promise<boolean>;
	stop(): Promise<void>;
}

export interface SttResult {
	transcript: string;
	/** 0–1 where the engine reports it; undefined when it does not. */
	confidence?: number;
	isFinal: boolean;
}

export interface SttProvider {
	readonly name: string;
	isAvailable(): Promise<boolean>;
	/** Starts listening; returns a function that stops it. */
	listen(
		locale: string,
		onResult: (result: SttResult) => void
	): Promise<() => void>;
}

// ---------------------------------------------------------------------------
// Web implementations
// ---------------------------------------------------------------------------

/** Speech synthesis via the browser's built-in voices. Free, offline, decent. */
export class WebTtsProvider implements TtsProvider {
	readonly name = 'web-speech';

	async isAvailable(): Promise<boolean> {
		return typeof globalThis.speechSynthesis !== 'undefined';
	}

	speak(text: string, options: SpeakOptions): Promise<boolean> {
		return new Promise((resolve) => {
			if (typeof globalThis.speechSynthesis === 'undefined') {
				resolve(false);
				return;
			}
			const utterance = new SpeechSynthesisUtterance(text);
			utterance.lang = options.locale;
			utterance.rate = options.rate ?? 1;
			utterance.onend = () => resolve(true);
			utterance.onerror = () => resolve(false);
			// Chrome keeps a stale queue after navigation; clearing it first
			// stops a phrase from being swallowed.
			speechSynthesis.cancel();
			speechSynthesis.speak(utterance);
		});
	}

	async stop(): Promise<void> {
		globalThis.speechSynthesis?.cancel();
	}
}

/**
 * Recognition via the Web Speech API. Chrome-leaning: Safari support is
 * partial and Firefox has none, so always check [isAvailable] and offer the
 * play-through fallback the Flutter app used.
 */
export class WebSttProvider implements SttProvider {
	readonly name = 'web-speech';

	private ctor(): (new () => SpeechRecognition) | undefined {
		const w = globalThis as unknown as {
			SpeechRecognition?: new () => SpeechRecognition;
			webkitSpeechRecognition?: new () => SpeechRecognition;
		};
		return w.SpeechRecognition ?? w.webkitSpeechRecognition;
	}

	async isAvailable(): Promise<boolean> {
		return this.ctor() !== undefined;
	}

	async listen(
		locale: string,
		onResult: (result: SttResult) => void
	): Promise<() => void> {
		const Ctor = this.ctor();
		if (!Ctor) throw new Error('Speech recognition is unavailable here');

		const recognition = new Ctor();
		recognition.lang = locale;
		recognition.interimResults = true;
		recognition.continuous = false;
		recognition.onresult = (event: SpeechRecognitionEvent) => {
			const result = event.results[event.results.length - 1];
			onResult({
				transcript: result[0].transcript,
				confidence: result[0].confidence,
				isFinal: result.isFinal
			});
		};
		recognition.start();
		return () => recognition.stop();
	}
}

// ---------------------------------------------------------------------------
// Connection trouble
// ---------------------------------------------------------------------------

/**
 * How long a network voice may take to start before the chain gives up on it
 * and speaks with the device voice instead — a learner waiting on a silent
 * button reads it as broken.
 */
const SLOW_MS = 4000;

/**
 * Set by a provider when the network let it down (offline, failed or timed
 * out) — not when it simply has no clip for a text or the text is too long.
 * The chain resets it per utterance and reads it before the device voice.
 */
let networkTrouble = false;

function noteNetworkTrouble(): void {
	networkTrouble = true;
}

function isOffline(): boolean {
	return typeof navigator !== 'undefined' && navigator.onLine === false;
}

const fallbackListeners = new Set<() => void>();

/**
 * Called whenever the device voice stands in because the connection was down
 * or too slow for the natural voices — VoiceNotice.svelte tells the learner.
 * Returns the unsubscribe function.
 */
export function onConnectionFallback(listener: () => void): () => void {
	fallbackListeners.add(listener);
	return () => fallbackListeners.delete(listener);
}

/**
 * Clips recorded ahead of time by `tool/gen-audio.mjs` (Chirp 3 HD), served
 * from static/audio/. The manifest maps locale → exact text → file, split into
 * shards by audioShard(text), so a tap fetches ~1/16 of it. Any text with a
 * recording plays it; any without falls through to the next voice. No text
 * leaves the device: the files come from the app's own origin.
 */
export class RecordedTtsProvider implements TtsProvider {
	readonly name = 'recorded';

	private shards = new Map<string, Promise<Record<string, Record<string, string>>>>();
	private audio: HTMLAudioElement | null = null;

	constructor(private readonly base = '/audio') {}

	private load(shard: string): Promise<Record<string, Record<string, string>>> {
		let loading = this.shards.get(shard);
		if (!loading) {
			loading = fetch(`${this.base}/manifest/${shard}.json`, { signal: AbortSignal.timeout(SLOW_MS) })
				.then((r) => (r.ok ? r.json() : {}))
				.catch(() => {
					// Offline or too slow: try again next time, and say so.
					this.shards.delete(shard);
					noteNetworkTrouble();
					return {};
				});
			this.shards.set(shard, loading);
		}
		return loading;
	}

	async isAvailable(): Promise<boolean> {
		return typeof Audio !== 'undefined' && typeof fetch !== 'undefined';
	}

	async speak(text: string, options: SpeakOptions): Promise<boolean> {
		const generation = this.generation;
		if (!(await this.isAvailable())) return false;
		const key = text.trim();
		const file = (await this.load(audioShard(key)))[options.locale]?.[key];
		// stop() while the manifest loaded (e.g. the learner left the page):
		// report handled so the chain does not fall through to another voice.
		if (generation !== this.generation) return true;
		if (!file) return false;
		await this.stop();
		const audio = new Audio(`${this.base}/${file}`);
		// Pitch is preserved, so the "Slower" buttons stay natural.
		audio.playbackRate = options.rate ?? 1;
		this.audio = audio;
		try {
			return await new Promise<boolean>((resolve) => {
				// Not started within SLOW_MS: a weak connection. Give up on the
				// clip (resolve first, so the pause below does not count as done).
				const slow = setTimeout(() => {
					noteNetworkTrouble();
					resolve(false);
					audio.pause();
				}, SLOW_MS);
				audio.onplaying = () => clearTimeout(slow);
				audio.onended = () => resolve(true);
				// The clip did not load (offline, dropped connection): the chain
				// falls through to the next voice.
				audio.onerror = () => {
					clearTimeout(slow);
					noteNetworkTrouble();
					resolve(false);
				};
				// A later speak() pauses this one; settle so the caller's busy state clears.
				audio.onpause = () => {
					clearTimeout(slow);
					if (!audio.ended) resolve(true);
				};
				audio.play().catch(() => {
					clearTimeout(slow);
					resolve(false);
				});
			});
		} finally {
			if (this.audio === audio) this.audio = null;
		}
	}

	/** Bumped by stop(), so a speak() still loading knows it was cancelled. */
	private generation = 0;

	async stop(): Promise<void> {
		this.generation++;
		this.audio?.pause();
		this.audio = null;
	}
}

/**
 * Premium neural voices via the project's Cloudflare Worker
 * (`cloudflare-tts-proxy/`), the port of lib/services/tts/cloud_tts_provider.dart.
 *
 * The Worker holds the Azure/Google keys server-side and returns MP3 bytes, so
 * nothing secret ships in this bundle. It only answers for origins on its
 * ALLOWED_ORIGINS list — so on an unlisted origin (a preview deploy, a local
 * dev server) the browser CORS-blocks it, `speak` returns false, and the chain
 * below falls through to the on-device voice.
 */
export class CloudTtsProvider implements TtsProvider {
	readonly name = 'cloud-proxy';

	/** The Worker's text cap; anything longer is left to the device voice. */
	private static readonly MAX_CHARS = 600;

	constructor(
		private readonly endpoint: string,
		/** Which neural voice to ask for; the Worker defaults to female. */
		private readonly gender: 'female' | 'male' = 'female'
	) {}

	private audio: HTMLAudioElement | null = null;

	async isAvailable(): Promise<boolean> {
		return this.endpoint !== '' && typeof Audio !== 'undefined';
	}

	async speak(text: string, options: SpeakOptions): Promise<boolean> {
		if (!(await this.isAvailable()) || text.length > CloudTtsProvider.MAX_CHARS) {
			return false;
		}
		const generation = this.generation;
		let url: string;
		try {
			const response = await fetch(this.endpoint, {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({ text, locale: options.locale, gender: this.gender }),
				// Synthesis itself takes a moment, so a little longer than a file.
				signal: AbortSignal.timeout(SLOW_MS + 2000)
			});
			if (!response.ok) return false;
			url = URL.createObjectURL(await response.blob());
		} catch {
			// Offline, too slow, or CORS-blocked (an unlisted origin looks the
			// same from here): the caller falls back.
			noteNetworkTrouble();
			return false;
		}
		// stop() arrived while the clip downloaded: drop it, and report handled
		// so the chain does not fall through to the device voice.
		if (generation !== this.generation) {
			URL.revokeObjectURL(url);
			return true;
		}

		await this.stop();
		const audio = new Audio(url);
		audio.playbackRate = options.rate ?? 1;
		this.audio = audio;
		try {
			return await new Promise<boolean>((resolve) => {
				audio.onended = () => resolve(true);
				audio.onerror = () => resolve(false);
				audio.play().catch(() => resolve(false));
			});
		} finally {
			URL.revokeObjectURL(url);
			if (this.audio === audio) this.audio = null;
		}
	}

	/** Bumped by stop(), so a speak() still downloading knows it was cancelled. */
	private generation = 0;

	async stop(): Promise<void> {
		this.generation++;
		this.audio?.pause();
		this.audio = null;
	}
}

/**
 * The fallback chain: a pre-recorded clip first, then the premium cloud voice,
 * then the on-device voice when neither can answer. This is the Dart
 * `TtsService` chain, and it is why a learner offline — or on a build with no
 * proxy — still gets audio.
 *
 * `voice_offline_only` (the Flutter settings key, verbatim) skips the cloud
 * leg entirely for learners who would rather not have their sentences leave
 * the device. Recordings still play: they send no text anywhere.
 */
export class ChainedTtsProvider implements TtsProvider {
	readonly name = 'chain';

	constructor(
		private readonly recorded: TtsProvider,
		private readonly cloud: TtsProvider,
		private readonly device: TtsProvider,
		/** Consulted per utterance, so the setting takes effect immediately. */
		private readonly offlineOnly: () => boolean = () => false
	) {}

	async isAvailable(): Promise<boolean> {
		return (await this.device.isAvailable()) || (await this.cloud.isAvailable());
	}

	async speak(text: string, options: SpeakOptions): Promise<boolean> {
		// The app-wide mute silences the voice too — a learner on a bus meant it.
		if (isMuted()) return false;
		networkTrouble = false;
		if (await this.recorded.speak(text, options)) return true;
		if (!this.offlineOnly()) {
			// Offline, or the recording already hit a slow/failed connection:
			// skip the cloud's request (another wait) and go to the device voice.
			if (isOffline()) noteNetworkTrouble();
			else if (!networkTrouble && (await this.cloud.speak(text, options))) return true;
		}
		// The learner's own offline-only choice is not trouble; a failed or
		// slow connection is, and they should know why the voice changed.
		if (networkTrouble) for (const listener of fallbackListeners) listener();
		return this.device.speak(text, options);
	}

	async stop(): Promise<void> {
		await this.recorded.stop();
		await this.cloud.stop();
		await this.device.stop();
	}
}

/** Set by the settings page; read per utterance by the chain above. */
let offlineOnly = false;

export function setVoiceOfflineOnly(value: boolean): void {
	offlineOnly = value;
}

/**
 * The provider actually in use. Swapping in a Capacitor implementation is a
 * change to these two lines and nothing else.
 */
export const tts: TtsProvider = new ChainedTtsProvider(
	new RecordedTtsProvider(),
	new CloudTtsProvider(env.PUBLIC_TTS_PROXY_URL ?? DEFAULT_TTS_PROXY),
	new WebTtsProvider(),
	() => offlineOnly
);
export const stt: SttProvider = new WebSttProvider();
