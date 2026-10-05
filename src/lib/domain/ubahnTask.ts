// "Last U-Bahn home": a station announcement names the platform (Gleis), the
// learner runs to it. The options pair the answer with the numbers it is
// easiest to mishear (zwei/drei, sechs/sieben, vier/fünf), and one round
// mentions a second number (zwei Minuten) to listen past.

import type { CallLine } from './callTask';

export interface UbahnRound {
	/** The platform, as a digit string. */
	answer: string;
	/** The platform signs on screen, in display order. */
	options: string[];
	clip: CallLine;
}

export interface UbahnTaskContent {
	id: string;
	title: string;
	intro: string;
	rounds: UbahnRound[];
	/** Jokes for the wrong platform. */
	wrong: string[];
	ending: CallLine;
}
