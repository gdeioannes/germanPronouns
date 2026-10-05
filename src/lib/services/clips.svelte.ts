// Pre-recorded clips outside the story player: a character's voice line, or
// one of the story sound effects. One voice clip plays at a time; a new one
// stops the last. A voice clip can be paused, resumed and replayed, and
// `voice` says which one is on and whether it is paused, so every play
// button on the page can show the right state.
//
// A clip that fails to load (not recorded yet, offline) falls back to the
// app voice reading its text, so a missing file never blocks a game; that
// fallback can be stopped but not paused.

import { isMuted } from './mute';
import { tts } from './speech';
import { effectsCalm } from '$lib/motion/fx.svelte';

export interface Fallback {
	text: string;
	locale: string;
}

export const voice = $state<{ id: string | null; status: 'idle' | 'playing' | 'paused' }>({
	id: null,
	status: 'idle'
});

let audio: HTMLAudioElement | null = null;
/** Settles the promise of the clip on now, when it ends or is stopped. */
let settle: (() => void) | null = null;

function finish(owner: HTMLAudioElement | null) {
	if (owner !== audio) return;
	audio = null;
	voice.status = 'idle';
	voice.id = null;
	const done = settle;
	settle = null;
	done?.();
}

/** Plays a line from the start; resolves when it has finished or is stopped (at once when muted). */
export function playClip(id: string, fallback?: Fallback): Promise<void> {
	stopClip();
	if (isMuted() || typeof Audio === 'undefined') return Promise.resolve();
	return new Promise((resolve) => {
		const a = new Audio(`/audio/story/${id}.mp3`);
		audio = a;
		settle = resolve;
		voice.id = id;
		voice.status = 'playing';
		a.onended = () => finish(a);
		a.onerror = async () => {
			if (audio !== a) return;
			if (fallback) await tts.speak(fallback.text, { locale: fallback.locale });
			finish(a);
		};
		a.play().catch(() => finish(a));
	});
}

export function pauseClip(): void {
	if (!audio || voice.status !== 'playing') return;
	audio.pause();
	voice.status = 'paused';
}

export function resumeClip(): void {
	if (!audio || voice.status !== 'paused') return;
	voice.status = 'playing';
	audio.play().catch(() => finish(audio));
}

/** The one button: play this line, pause it while it plays, resume it when paused. */
export function toggleClip(id: string, fallback?: Fallback): void {
	if (voice.id === id && voice.status === 'playing') pauseClip();
	else if (voice.id === id && voice.status === 'paused') resumeClip();
	else void playClip(id, fallback);
}

export function stopClip(): void {
	audio?.pause();
	finish(audio);
}

/** A story sound effect (dial_0 … dial_9, ring, busy, ubahn_chime); resolves when done. */
export function playSfx(name: string, gain = 1): Promise<void> {
	if (isMuted() || effectsCalm() || typeof Audio === 'undefined') return Promise.resolve();
	return new Promise((resolve) => {
		const a = new Audio(`/audio/story/sfx/${name}.mp3`);
		a.volume = Math.min(1, 0.8 * gain);
		a.onended = () => resolve();
		a.onerror = () => resolve();
		a.play().catch(() => resolve());
	});
}
