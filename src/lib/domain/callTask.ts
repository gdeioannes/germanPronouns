// "Call Kim after the party": a phone number is read out and the learner
// gets it right in one of two ways — dialling the smudged digits ('fill'), or
// picking the right one of three near-identical numbers ('pick', built on
// sound-alikes: zwei/drei, sechs/sieben). A wrong number gets a stranger and
// a joke — five to collect — and a right one moves the chase on.
//
// Pure logic, so the scene component only draws and plays. Content lives in
// assets/content/tasks/call_after_party.json.

export interface CallLine {
	/** Who speaks — a voice in tool/gen-story-audio.mjs. */
	who: string;
	/** Who picked up, as the call screen names them. */
	name: string;
	/** Clip id: static/audio/story/<audio>.mp3. */
	audio: string;
	de: string;
	en: string;
	/** How it is acted, for the recording (tool/gen-story-audio.mjs). */
	style?: string;
}

/** A text message: German, with its English underneath. */
export interface TextMessage {
	de: string;
	en: string;
}

export interface WrongCaller extends CallLine {
	/** The joke shown after the wrong call. */
	caption: string;
	/** Their face in the collection. */
	emoji: string;
}

export interface CallRound {
	kind: 'fill' | 'pick';
	/** Where the number is written ("On your hand"). */
	where: string;
	/** What to do, in one line. */
	prompt: string;
	/** As displayed, with spaces: "0176 520 3847". */
	number: string;
	/** fill: positions in the digit string (spaces removed) that are smudged. */
	hide?: number[];
	/** pick: the three numbers on offer, the right one among them. */
	options?: string[];
	/** Text messages that arrive with the clip. */
	texts?: TextMessage[];
	/** A slip the speaker takes back ("null, zwei… nein, Quatsch!"), not part of the number. */
	correction?: string;
	/** What the learner listens to for this number. */
	clip: CallLine;
}

export interface CallTaskContent {
	id: string;
	title: string;
	intro: string;
	rounds: CallRound[];
	ending: CallLine;
	/** Kim's text after the call. */
	endingText: string;
	wrong: WrongCaller[];
}

/** One character of the displayed number: a printed digit, a slot, or a space. */
export type NumberCell =
	| { kind: 'digit'; digit: string }
	| { kind: 'slot'; slot: number }
	| { kind: 'space' };

export const digitsOf = (number: string) => number.replace(/\D/g, '');

/** The number as cells, hidden digits replaced by their slot index (in `hide` order). */
export function numberCells(number: string, hide: readonly number[]): NumberCell[] {
	const cells: NumberCell[] = [];
	let index = 0;
	for (const ch of number) {
		if (!/\d/.test(ch)) {
			cells.push({ kind: 'space' });
			continue;
		}
		const slot = hide.indexOf(index);
		cells.push(slot >= 0 ? { kind: 'slot', slot } : { kind: 'digit', digit: ch });
		index++;
	}
	return cells;
}

/** The digits the slots expect, in slot order. */
export function expected(number: string, hide: readonly number[]): string[] {
	const digits = digitsOf(number);
	return hide.map((i) => digits[i]);
}

/** A key press: the digit goes into the first empty slot. */
export function press(typed: readonly string[], digit: string): string[] {
	const next = [...typed];
	const free = next.indexOf('');
	if (free >= 0) next[free] = digit;
	return next;
}

/** Backspace: clears the last filled slot that is not locked (a hint or already right). */
export function erase(typed: readonly string[], locked: readonly number[] = []): string[] {
	const next = [...typed];
	for (let i = next.length - 1; i >= 0; i--) {
		if (next[i] && !locked.includes(i)) {
			next[i] = '';
			break;
		}
	}
	return next;
}

export function checkCall(
	number: string,
	hide: readonly number[],
	typed: readonly string[]
): { correct: boolean; wrong: number[] } {
	const want = expected(number, hide);
	const wrong = want.flatMap((d, i) => (typed[i] === d ? [] : [i]));
	return { correct: wrong.length === 0, wrong };
}

/** After a wrong call: right digits stay, wrong ones are cleared for another go. */
export function keepRight(typed: readonly string[], wrong: readonly number[]): string[] {
	return typed.map((d, i) => (wrong.includes(i) ? '' : d));
}

/** Picks the stranger who answers a wrong number — never the same one twice running. */
export function pickWrongCaller(count: number, previous: number | null, random: () => number = Math.random): number {
	if (count <= 1) return 0;
	let pick = Math.floor(random() * count);
	if (pick === previous) pick = (pick + 1) % count;
	return pick;
}

/** Adds a stranger to the collection (the ids met so far), keeping it unique. */
export function meet(met: readonly string[], who: string): string[] {
	return met.includes(who) ? [...met] : [...met, who];
}
