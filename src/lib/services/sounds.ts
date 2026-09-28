// Sound effects, synthesised with the Web Audio API: short chimes built from
// oscillators, so there are no audio files to download, cache or license.
//
// Like the TTS chain, this reads a plain flag rather than the progress store,
// so it stays free of framework imports. The flag is set from the learner's
// "Sound effects" setting.
//
// Browsers only let audio start from a user gesture, and iOS insists the
// context is unlocked inside one. Answers are scored after an await, which
// is outside the gesture, so the context is unlocked on the first tap or key
// press instead (see `unlockAudio`).

import { STREAK_LAP_SIZE } from '$lib/domain/progress';
import { isMuted } from './mute';

let enabled = true;
let ctx: AudioContext | null = null;

export function setSoundEffects(on: boolean): void {
	enabled = on;
}

function context(): AudioContext | null {
	if (typeof window === 'undefined') return null;
	if (!ctx) {
		const Ctor =
			window.AudioContext ??
			(window as unknown as { webkitAudioContext?: typeof AudioContext }).webkitAudioContext;
		if (!Ctor) return null;
		ctx = new Ctor();
	}
	if (ctx.state === 'suspended') void ctx.resume();
	return ctx;
}

/** Listens for the first gesture and unlocks audio with it. Call once. */
export function unlockAudio(): void {
	if (typeof window === 'undefined') return;
	const unlock = () => {
		const ac = context();
		if (ac) {
			// A silent one-sample buffer: what iOS needs to count as "played".
			const source = ac.createBufferSource();
			source.buffer = ac.createBuffer(1, 1, 22050);
			source.connect(ac.destination);
			source.start();
		}
		window.removeEventListener('pointerdown', unlock);
		window.removeEventListener('keydown', unlock);
	};
	window.addEventListener('pointerdown', unlock);
	window.addEventListener('keydown', unlock);
}

/** One enveloped note: quick attack, exponential decay. */
function note(
	ac: AudioContext,
	freq: number,
	start: number,
	length: number,
	{ type = 'triangle' as OscillatorType, volume = 0.16, glideTo = 0 } = {}
): void {
	const osc = ac.createOscillator();
	const gain = ac.createGain();
	osc.type = type;
	osc.frequency.setValueAtTime(freq, start);
	if (glideTo) osc.frequency.exponentialRampToValueAtTime(glideTo, start + length);
	gain.gain.setValueAtTime(0.0001, start);
	gain.gain.exponentialRampToValueAtTime(volume, start + 0.012);
	gain.gain.exponentialRampToValueAtTime(0.0001, start + length);
	osc.connect(gain).connect(ac.destination);
	osc.start(start);
	osc.stop(start + length + 0.02);
}

/** Frequency `semitones` above `base`. */
const up = (base: number, semitones: number) => base * 2 ** (semitones / 12);

export type Sound = 'right' | 'wrong' | 'milestone' | 'complete';

// ── The streak progression ──────────────────────────────────────────────
//
// A streak is counted in laps of STREAK_LAP_SIZE (the tracker's pips). The
// right-answer chime is built so a run is something you can hear:
//   * within a lap, each answer steps up a major-pentatonic scale
//     (do re mi so la) — the lap climbs;
//   * the answer that completes a lap plays a flourish that resolves it;
//   * each new lap starts a whole step higher and adds a layer — an octave
//     shimmer, then a three-note arpeggio, then a sparkle on top.
// A few cents of random detune and a choice of two consonant intervals keep
// repeats alive without ever sounding like a different sound.

/** The five pentatonic steps one lap climbs, in semitones above its root. */
const LADDER = [0, 2, 4, 7, 9];
/** C5: low enough that four laps of climbing never turn shrill. */
const BASE = 523.25;
/** How many laps keep adding pitch and layers before the sound plateaus. */
const MAX_LAP = 3;

function lapOf(streak: number): number {
	return Math.min(Math.floor((Math.max(streak, 1) - 1) / STREAK_LAP_SIZE), MAX_LAP);
}

/** The lap's key: each lap a whole step above the last. */
function lapRoot(lap: number): number {
	return up(BASE, lap * 2);
}

/** ±4 cents: the same sound, never quite a recording. */
const detune = () => 2 ** (((Math.random() - 0.5) * 8) / 1200);

function rightChime(ac: AudioContext, t: number, streak: number): void {
	const lap = lapOf(streak);
	const step = (Math.max(streak, 1) - 1) % STREAK_LAP_SIZE;
	const root = up(lapRoot(lap), LADDER[step]) * detune();
	// Richer laps share the same loudness budget, so they sound fuller,
	// not louder.
	const v = 0.16 - lap * 0.02;

	if (lap < 2) {
		// The chime: the step note, answered a fourth or a fifth above.
		note(ac, root, t, 0.12, { volume: v });
		note(ac, up(root, Math.random() < 0.5 ? 5 : 7), t + 0.075, 0.22, { volume: v });
	} else {
		// From lap three the answer is a quick major arpeggio.
		[0, 4, 7].forEach((s, i) => note(ac, up(root, s), t + i * 0.055, 0.18, { volume: v }));
	}
	if (lap >= 1) {
		// An octave shimmer under the tail.
		note(ac, up(root, 12), t + 0.09, 0.3, { type: 'sine', volume: 0.045 });
	}
	if (lap >= 3) {
		// And a sparkle on top.
		[19, 24].forEach((s, i) =>
			note(ac, up(root, s), t + 0.14 + i * 0.05, 0.16, { type: 'sine', volume: 0.025 })
		);
	}
}

/** The lap-completing flourish: a run up the lap's own key, longer each lap. */
function lapFlourish(ac: AudioContext, t: number, streak: number): void {
	const lap = lapOf(streak);
	const root = lapRoot(lap) * detune();
	const run = [0, 4, 7, 12, 16].slice(0, 4 + Math.min(lap, 1));
	run.forEach((s, i) => note(ac, up(root, s), t + i * 0.065, 0.2, { volume: 0.13 }));
	const end = t + run.length * 0.065;
	// A held chord to land on, which grows a voice per lap.
	[0, 4, 7, 12].slice(0, 2 + lap).forEach((s) =>
		note(ac, up(root, s + 12), end, 0.5 + lap * 0.12, { type: 'sine', volume: 0.05 })
	);
}

/**
 * Plays a sound effect. For 'right', `streak` is the run after this answer:
 * it picks the step of the climb, and a lap-completing answer plays the
 * flourish instead.
 */
export function playSound(sound: Sound, streak = 0): void {
	if (!enabled || isMuted()) return;
	const ac = context();
	if (!ac) return;
	const t = ac.currentTime + 0.01;

	if (sound === 'right' && streak > 0 && streak % STREAK_LAP_SIZE === 0) sound = 'milestone';

	switch (sound) {
		case 'right':
			rightChime(ac, t, streak);
			break;
		case 'wrong':
			// A soft, low "bonk" that falls — tells, never scolds.
			note(ac, 220, t, 0.24, { type: 'sine', volume: 0.2, glideTo: 150 });
			note(ac, 165, t + 0.05, 0.2, { type: 'triangle', volume: 0.07, glideTo: 120 });
			break;
		case 'milestone':
			lapFlourish(ac, t, Math.max(streak, STREAK_LAP_SIZE));
			break;
		case 'complete':
			// A little fanfare: G C E, then a held C major chord with a sparkle.
			[392, 523.25, 659.25].forEach((f, i) => note(ac, f, t + i * 0.1, 0.16, { volume: 0.14 }));
			for (const f of [523.25, 659.25, 783.99, 1046.5]) {
				note(ac, f, t + 0.32, 0.9, { volume: 0.08 });
			}
			[2093, 2637.02, 3135.96].forEach((f, i) =>
				note(ac, f, t + 0.36 + i * 0.06, 0.18, { type: 'sine', volume: 0.04 })
			);
			break;
	}
}
