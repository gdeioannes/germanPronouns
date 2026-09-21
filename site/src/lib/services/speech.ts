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
 * The provider actually in use. Swapping in a Capacitor implementation is a
 * change to these two lines and nothing else.
 */
export const tts: TtsProvider = new WebTtsProvider();
export const stt: SttProvider = new WebSttProvider();
