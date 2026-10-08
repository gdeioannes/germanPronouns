// Synthesizes the story modules' sound layer: UI/diegetic effects (DTMF
// dial beeps, busy tone, clue chime, wrong thud, chapter sting) and two
// gentle ambient loops (investigation, tension). Everything is generated
// code — no licensing, fully ours, and consistent with the calm-effects
// philosophy: short, soft, musical. The ambient loops are intentionally
// subtle placeholders; swap in licensed tracks later if wanted without
// changing any keys.
//
//   npm run story-sfx           render every missing file
//   npm run story-sfx -- --force re-render everything
//
// Output: static/audio/story/sfx/<name>.mp3 (44.1 kHz mono MP3 via lamejs).

import { existsSync, mkdirSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { join } from 'node:path';
import { Mp3Encoder } from '@breezystack/lamejs';

const root = fileURLToPath(new URL('..', import.meta.url));
const OUT_DIR = join(root, 'static', 'audio', 'story', 'sfx');
const SR = 44100;

const force = process.argv.includes('--force');
mkdirSync(OUT_DIR, { recursive: true });

/** samples(duration) filled by fn(t, buf). */
function render(seconds, fn) {
	const buf = new Float32Array(Math.floor(SR * seconds));
	fn(buf);
	return buf;
}
const TAU = Math.PI * 2;
/** Add a sine partial with an amplitude envelope. */
function tone(buf, freq, { from = 0, dur = buf.length / SR, gain = 0.3, attack = 0.005, decay = 0.08 } = {}) {
	const start = Math.floor(from * SR);
	const n = Math.min(Math.floor(dur * SR), buf.length - start);
	for (let i = 0; i < n; i++) {
		const t = i / SR;
		const env = Math.min(1, t / attack) * Math.exp(-Math.max(0, t - attack) / decay);
		buf[start + i] += Math.sin(TAU * freq * t) * gain * env;
	}
}
/** Sustained sine with slow tremolo, for ambience. */
function pad(buf, freq, { gain = 0.05, lfo = 0.1, phase = 0 } = {}) {
	for (let i = 0; i < buf.length; i++) {
		const t = i / SR;
		const trem = 0.7 + 0.3 * Math.sin(TAU * lfo * t + phase);
		// Loop-friendly: fade the first/last 50 ms into each other.
		const edge = Math.min(1, (i / SR / 0.05) % 1e9, (buf.length - i) / SR / 0.05);
		buf[i] += Math.sin(TAU * freq * t + phase) * gain * trem * Math.min(1, edge);
	}
}

/** DTMF keypad beep for a digit (the real two-tone frequencies). */
const DTMF = { 1: [697, 1209], 2: [697, 1336], 3: [697, 1477], 4: [770, 1209], 5: [770, 1336], 6: [770, 1477], 7: [852, 1209], 8: [852, 1336], 9: [852, 1477], 0: [941, 1336] };
function dtmf(digit) {
	return render(0.12, (buf) => {
		for (const f of DTMF[digit]) tone(buf, f, { dur: 0.1, gain: 0.18, decay: 0.2 });
	});
}

const FILES = {
	// — diegetic phone sounds
	...Object.fromEntries(Object.keys(DTMF).map((d) => [`dial_${d}`, () => dtmf(d)])),
	busy: () =>
		render(1.6, (buf) => {
			for (let k = 0; k < 2; k++) {
				tone(buf, 425, { from: k * 0.8, dur: 0.48, gain: 0.2, attack: 0.01, decay: 2 });
			}
		}),
	ring: () =>
		render(2.0, (buf) => {
			tone(buf, 425, { dur: 1.0, gain: 0.15, attack: 0.02, decay: 3 });
		}),
	// — city sounds (Episode 0): an Altbau doorbell, the door buzzer, the
	// U-Bahn's three-note door chime
	doorbell: () =>
		render(1.4, (buf) => {
			tone(buf, 659.25, { dur: 0.7, gain: 0.2, decay: 0.45 });
			tone(buf, 1318.5, { dur: 0.4, gain: 0.04, decay: 0.2 });
			tone(buf, 523.25, { from: 0.42, dur: 0.9, gain: 0.2, decay: 0.55 });
			tone(buf, 1046.5, { from: 0.42, dur: 0.4, gain: 0.04, decay: 0.2 });
		}),
	buzzer: () =>
		render(0.9, (buf) => {
			// a rough low buzz: odd harmonics of 110 Hz, held, then cut
			for (const [h, g] of [[1, 0.16], [3, 0.08], [5, 0.05], [7, 0.03]])
				tone(buf, 110 * h, { dur: 0.7, gain: g, attack: 0.01, decay: 3 });
		}),
	ubahn_chime: () =>
		render(1.3, (buf) => {
			[783.99, 659.25, 523.25].forEach((f, i) => tone(buf, f, { from: i * 0.22, dur: 0.7, gain: 0.15, decay: 0.35 }));
		}),
	// — game feedback, soft and musical (pentatonic, brand-calm)
	clue: () =>
		render(0.9, (buf) => {
			[523.25, 659.25, 783.99].forEach((f, i) => tone(buf, f, { from: i * 0.09, dur: 0.6, gain: 0.16, decay: 0.25 }));
		}),
	wrong: () =>
		render(0.5, (buf) => {
			tone(buf, 196, { dur: 0.35, gain: 0.2, decay: 0.12 });
			tone(buf, 185, { from: 0.03, dur: 0.3, gain: 0.12, decay: 0.12 });
		}),
	credibility_lost: () =>
		render(1.2, (buf) => {
			[392, 329.63, 261.63].forEach((f, i) => tone(buf, f, { from: i * 0.18, dur: 0.5, gain: 0.15, decay: 0.3 }));
		}),
	chapter_sting: () =>
		render(1.8, (buf) => {
			[261.63, 329.63, 392, 523.25].forEach((f, i) => tone(buf, f, { from: i * 0.12, dur: 1.0, gain: 0.12, decay: 0.5 }));
			pad(buf, 130.81, { gain: 0.04, lfo: 0.4 });
		}),
	notebook: () =>
		render(0.25, (buf) => {
			tone(buf, 880, { dur: 0.08, gain: 0.08, decay: 0.05 });
			tone(buf, 1320, { from: 0.05, dur: 0.08, gain: 0.06, decay: 0.05 });
		}),
	// — Episode 2: the Buletten hit the pan; a brass key found and jingled
	sizzle: () =>
		render(1.4, (buf) => {
			// filtered noise that swells then settles: hot fat meeting meat
			let lp = 0;
			for (let i = 0; i < buf.length; i++) {
				const t = i / SR;
				const env = Math.min(1, t / 0.08) * (0.55 + 0.45 * Math.exp(-t / 0.5)) * Math.exp(-Math.max(0, t - 1.0) / 0.25);
				lp += (Math.random() * 2 - 1 - lp) * 0.35;
				buf[i] += lp * 0.22 * env;
			}
		}),
	keys: () =>
		render(0.8, (buf) => {
			for (const [f, from] of [[2960, 0], [3520, 0.07], [2640, 0.16], [3960, 0.22], [3100, 0.34]])
				tone(buf, f, { from, dur: 0.25, gain: 0.07, decay: 0.06 });
		}),
	// — ambient loops (~16 s, designed to loop; keep volume low in the app)
	loop_investigation: () =>
		render(16, (buf) => {
			pad(buf, 110, { gain: 0.05, lfo: 0.07 });
			pad(buf, 164.81, { gain: 0.035, lfo: 0.11, phase: 1.3 });
			pad(buf, 220, { gain: 0.02, lfo: 0.05, phase: 2.1 });
			// sparse pizzicato-ish plucks on a minor pentatonic
			const notes = [220, 261.63, 293.66, 329.63, 392];
			for (let k = 0; k < 10; k++) {
				const from = 0.8 + k * 1.5 + (k % 3) * 0.2;
				tone(buf, notes[(k * 3) % notes.length], { from, dur: 0.5, gain: 0.07, decay: 0.3 });
			}
		}),
	loop_tension: () =>
		render(16, (buf) => {
			pad(buf, 98, { gain: 0.06, lfo: 0.21 });
			pad(buf, 103.83, { gain: 0.04, lfo: 0.17, phase: 0.9 });
			pad(buf, 196, { gain: 0.02, lfo: 0.33, phase: 2.6 });
			for (let k = 0; k < 8; k++) {
				tone(buf, 587.33, { from: 1 + k * 2, dur: 0.15, gain: 0.03, decay: 0.08 });
			}
		})
};

let made = 0;
let skipped = 0;
for (const [name, make] of Object.entries(FILES)) {
	const file = join(OUT_DIR, `${name}.mp3`);
	if (existsSync(file) && !force) {
		skipped++;
		continue;
	}
	const buf = make();
	writeFileSync(file, encodeMp3(buf));
	made++;
	console.log(`${name}.mp3`);
}
console.log(`\n${made} rendered, ${skipped} already present, in ${OUT_DIR}`);

function encodeMp3(f32) {
	const pcm = new Int16Array(f32.length);
	for (let i = 0; i < f32.length; i++) pcm[i] = Math.max(-1, Math.min(1, f32[i])) * 32767;
	const enc = new Mp3Encoder(1, SR, 128);
	const chunks = [];
	for (let i = 0; i < pcm.length; i += 1152) {
		const d = enc.encodeBuffer(pcm.subarray(i, i + 1152));
		if (d.length) chunks.push(Buffer.from(d));
	}
	const end = enc.flush();
	if (end.length) chunks.push(Buffer.from(end));
	return Buffer.concat(chunks);
}
