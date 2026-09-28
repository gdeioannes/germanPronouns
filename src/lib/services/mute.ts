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
