// The app-wide mute: one flag that both audio sources check — the sound
// effects (sounds.ts) and the read-aloud voice (speech.ts). A plain flag,
// set from the learner's "Mute the app" setting, so neither service needs
// the progress store.

let muted = false;

export function setMuted(value: boolean): void {
	muted = value;
}

export function isMuted(): boolean {
	return muted;
}

// "Say questions and answers aloud": when off, the voice no longer speaks
// on its own (a question as it appears, the answer after a check) — a
// screen reader is already reading those. The voice still answers every
// play button, and an exercise whose question is only heard still says it.

let autoSpeak = true;

export function setAutoSpeak(value: boolean): void {
	autoSpeak = value;
}

export function speaksOnItsOwn(): boolean {
	return autoSpeak;
}
