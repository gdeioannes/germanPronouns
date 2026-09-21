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
		let url: string;
		try {
			const response = await fetch(this.endpoint, {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({ text, locale: options.locale, gender: this.gender })
			});
			if (!response.ok) return false;
			url = URL.createObjectURL(await response.blob());
		} catch {
			// Offline, CORS-blocked, or the cloud APIs are down: the caller falls back.
			return false;
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

	async stop(): Promise<void> {
		this.audio?.pause();
		this.audio = null;
	}
}

/**
 * The fallback chain: the premium cloud voice first, the on-device voice when
 * it cannot answer. This is the Dart `TtsService` chain, and it is why a
 * learner offline — or on a build with no proxy — still gets audio.
 *
 * `voice_offline_only` (the Flutter settings key, verbatim) skips the cloud
 * leg entirely for learners who would rather not have their sentences leave
 * the device.
 */
export class ChainedTtsProvider implements TtsProvider {
	readonly name = 'chain';

	constructor(
		private readonly cloud: TtsProvider,
		private readonly device: TtsProvider,
		/** Consulted per utterance, so the setting takes effect immediately. */
		private readonly offlineOnly: () => boolean = () => false
	) {}

	async isAvailable(): Promise<boolean> {
		return (await this.device.isAvailable()) || (await this.cloud.isAvailable());
	}

	async speak(text: string, options: SpeakOptions): Promise<boolean> {
		if (!this.offlineOnly() && (await this.cloud.speak(text, options))) return true;
		return this.device.speak(text, options);
	}

	async stop(): Promise<void> {
		await this.cloud.stop();
		await this.device.stop();
	}
}

/** Set by the settings page; read per utterance by the chain above. */
let offlineOnly = false;

export function setVoiceOfflineOnly(value: boolean): void {
	offlineOnly = value;
}

export function isVoiceOfflineOnly(): boolean {
	return offlineOnly;
}

/**
 * The provider actually in use. Swapping in a Capacitor implementation is a
 * change to these two lines and nothing else.
 */
export const tts: TtsProvider = new ChainedTtsProvider(
	new CloudTtsProvider(env.PUBLIC_TTS_PROXY_URL ?? DEFAULT_TTS_PROXY),
	new WebTtsProvider(),
	() => offlineOnly
);
export const stt: SttProvider = new WebSttProvider();
