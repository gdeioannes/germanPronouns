// The answer, said aloud after every answer — right or wrong. The chime or
// the bonk goes first, then a beat, then the voice says the German ("die
// Brille"), so the sound, the picture and the word land together. A miss
// hears the right form while the learner is still looking at it.
//
// The promise settles when the voice is done (or gave up, or the page was
// muted), never later than MAX_WAIT: the quiz waits on it before it moves on
// by itself, so the next question never cuts the answer off. With "Say
// questions and answers aloud" off it settles at once: a screen reader is
// reading the answer already, and two voices at once drown each other.

import { speaksOnItsOwn } from './mute';
import { tts } from './speech';

/** The beat between the answer's sound effect and the voice. */
const AFTER_SOUND_MS = 350;
/** However the voice fares, the quiz never waits longer than this. */
const MAX_WAIT_MS = 4000;

/**
 * `stillShown` is asked after the beat: a learner who already moved on
 * (Enter) must not hear the old answer over the new question.
 */
export function sayAnswer(text: string, locale: string, stillShown: () => boolean): Promise<void> {
	if (!speaksOnItsOwn()) return Promise.resolve();
	const said = new Promise<void>((resolve) => {
		setTimeout(() => {
			if (!stillShown()) return resolve();
			tts
				.speak(text, { locale })
				.catch(() => false)
				.then(() => resolve());
		}, AFTER_SOUND_MS);
	});
	const cap = new Promise<void>((resolve) => setTimeout(resolve, MAX_WAIT_MS));
	return Promise.race([said, cap]);
}
