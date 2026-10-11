// The writing exercise's rules: how long the text has to be, and whether what
// the learner has typed counts as finished.
//
// The app does not mark the writing. The learner writes here, inside a
// character bound, and the app hands them a prompt that carries their own text
// to their own AI for correction — the same trade the speaking exercises make.
// What comes back is the delimited report speaking already parses, so a written
// slip and a spoken one land in the same personal-focus loop.

import type { SpeakingExercise, WritingExercise } from '$lib/content/types';
import { levelBand } from './speakingPrompt';

export interface CharBounds {
	min: number;
	max: number;
}

/**
 * What a text of this level is expected to run to. A beginner who is asked for
 * 900 characters writes nothing; a C2 learner who is capped at 300 cannot show
 * range. Both ends matter: the minimum is what stops a two-word submission.
 */
const BANDS: Record<string, CharBounds> = {
	A1: { min: 120, max: 300 },
	A2: { min: 200, max: 500 },
	B1: { min: 400, max: 900 },
	B2: { min: 600, max: 1300 },
	C1: { min: 900, max: 1800 },
	C2: { min: 1200, max: 2500 }
};

/** The band default, unless the exercise overrides either end. */
export function charBoundsFor(exercise: WritingExercise, level: string | undefined): CharBounds {
	const band = BANDS[levelBand(level ?? 'A1')] ?? BANDS.A1;
	const min = exercise.charMin ?? band.min;
	const max = exercise.charMax ?? band.max;
	// An author who sets only one end must not be able to invert the bound.
	return max >= min ? { min, max } : { min: max, max: min };
}

/**
 * Emphasis markers, written the way Markdown does: `**fett**` and `*kursiv*`.
 * They are plain characters so the text stays plain all the way into the
 * prompt, and the prompt tells the tutor to ignore them.
 */
export const BOLD = '**';
export const ITALIC = '*';
const MARKERS = /\*{1,2}/g;

/** The text as German, with the emphasis markers taken back out. */
export function plainText(text: string): string {
	return text.replace(MARKERS, '');
}

/**
 * The length that counts. Trailing spaces and the blank lines between
 * paragraphs are not writing, so they do not earn their way towards the
 * minimum; a single newline between paragraphs still counts as one character.
 * Emphasis markers are not German either, so a text cannot be padded to the
 * minimum with asterisks.
 */
export function countChars(text: string): number {
	return plainText(text).trim().replace(/[ \t]+/g, ' ').replace(/\n{2,}/g, '\n').length;
}

/**
 * Words, the unit exam tasks are actually set in ("write 80 words"). A German
 * compound is one word however long it is, and a hyphenated one (E-Mail,
 * Kursgebühr-Rückerstattung) counts once, the way a marker would count it.
 */
export function countWords(text: string): number {
	const trimmed = plainText(text).trim();
	if (!trimmed) return 0;
	return trimmed.split(/\s+/).filter((w) => /[\p{L}\p{N}]/u.test(w)).length;
}

export type WritingState = 'short' | 'ready' | 'over';

/** Where the typed text sits against its bound. */
export function writingState(text: string, bounds: CharBounds): WritingState {
	const n = countChars(text);
	if (n < bounds.min) return 'short';
	if (n > bounds.max) return 'over';
	return 'ready';
}

/** Only a text inside its bound may be sent for correction. */
export function canSubmit(text: string, bounds: CharBounds): boolean {
	return writingState(text, bounds) === 'ready';
}

/**
 * How full the length rail is, 0 to 1. It fills towards the minimum, because
 * that is the only end the learner has to reach; past it the rail is full and
 * the bar simply changes colour if they run over the maximum.
 */
export function fillOf(text: string, bounds: CharBounds): number {
	if (bounds.min <= 0) return 1;
	return Math.min(1, countChars(text) / bounds.min);
}

/** The characters a learner on a non-German keyboard cannot type. */
export const GERMAN_KEYS = ['ä', 'ö', 'ü', 'ß', 'Ä', 'Ö', 'Ü'] as const;

// -- the writing surface ----------------------------------------------------
//
// A textarea can only hold plain text, so emphasis written as `**fett**` shows
// up as asterisks instead of bold. The box is therefore a rich-text surface,
// and these two turn its content into the marker text the prompt carries, and
// back again when a draft is restored. The marker text stays the single source
// of truth: it is what is counted, saved and sent.

const ESCAPE: Record<string, string> = {
	'&': '&amp;',
	'<': '&lt;',
	'>': '&gt;'
};

/** Marker text to the HTML the editor shows. */
export function markersToHtml(text: string): string {
	const safe = text.replace(/[&<>]/g, (c) => ESCAPE[c]);
	return safe
		.replace(/\*\*([^*\n]+)\*\*/g, '<strong>$1</strong>')
		.replace(/\*([^*\n]+)\*/g, '<em>$1</em>')
		.split('\n')
		.map((line) => `<div>${line || '<br>'}</div>`)
		.join('');
}

/**
 * The shape this reads off a DOM node, named so the conversion can be tested
 * without a browser. A real `Node` satisfies it.
 */
export interface MarkerNode {
	nodeType: number;
	nodeName: string;
	data?: string;
	childNodes: ArrayLike<MarkerNode>;
}

const TEXT_NODE = 3;
const BLOCKS = new Set(['DIV', 'P', 'LI']);
const WRAP: Record<string, string> = { STRONG: BOLD, B: BOLD, EM: ITALIC, I: ITALIC };

/** The editor's content as marker text, which is what gets sent and saved. */
export function serialiseMarkers(root: MarkerNode): string {
	const out: string[] = [];

	const walk = (node: MarkerNode, into: string[]) => {
		for (let i = 0; i < node.childNodes.length; i++) {
			const child = node.childNodes[i];
			if (child.nodeType === TEXT_NODE) {
				into.push(child.data ?? '');
				continue;
			}
			const name = child.nodeName.toUpperCase();
			if (name === 'BR') {
				// A <br> that only terminates an empty block is not a blank line.
				const alone = node.childNodes.length === 1;
				if (!alone) into.push('\n');
				continue;
			}
			const mark = WRAP[name];
			if (mark) {
				const inner: string[] = [];
				walk(child, inner);
				const body = inner.join('');
				// Never emit an empty pair: `****` would be asterisks in the text.
				into.push(body.trim() ? mark + body + mark : body);
				continue;
			}
			if (BLOCKS.has(name)) {
				const inner: string[] = [];
				walk(child, inner);
				if (into.length > 0) into.push('\n');
				into.push(inner.join(''));
				continue;
			}
			walk(child, into);
		}
	};

	walk(root, out);
	return out.join('');
}

/**
 * A writing exercise seen as a speaking one, so the single prompt renderer
 * builds both. The mode is what selects the writing family, and therefore the
 * correction rules and the written scoring table.
 */
export function asSpeakingExercise(exercise: WritingExercise): SpeakingExercise {
	return {
		topic: exercise.topic,
		practisePoints: exercise.practisePoints,
		scoringCriteria: exercise.scoringCriteria,
		targetVocabulary: exercise.targetVocabulary,
		priorityErrors: exercise.priorityErrors,
		mode: 'writing',
		passScore: exercise.passScore,
		reportMaxWords: exercise.reportMaxWords,
		maxCorrections: exercise.maxCorrections,
		material: exercise.material
	};
}
