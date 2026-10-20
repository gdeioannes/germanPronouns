// The correction a checked big-text cloze gives: every missed gap in its own
// sentence, what was written beside what was right, and why. A score on its
// own teaches nothing — "0 of 12" says that it went wrong, not where or how.

import type { InlineBlank } from '$lib/content/types';

export interface ClozeMiss {
	/** The gap's index in `inlineBlanks`. */
	index: number;
	/** The sentence up to the gap, trimmed, every other gap filled in correctly. */
	before: string;
	/** The sentence after the gap, its leading space kept (a comma has none). */
	after: string;
	/** What the learner gave, trimmed; empty for a gap left blank. */
	given: string;
	answer: string;
	/** The gap's hint ("(f) Wand", "sein · Präteritum"): what it was about. */
	hint?: string;
	/** The authored reason, where there is one. */
	why?: string;
}

const MARKER = /\{\{(\d+)\}\}/g;
/** Where a sentence ends: its punctuation, then space (or the text's end). */
const END = /[.!?:](?=\s|$)/;

/** The template's text with every gap's marker swapped for its answer. */
function fill(text: string, blanks: readonly InlineBlank[]): string {
	return text.replace(MARKER, (_, n) => blanks[Number(n)]?.answer ?? '');
}

/** The sentence holding gap `index`, split at the gap. */
export function gapSentence(
	template: string,
	blanks: readonly InlineBlank[],
	index: number
): { before: string; after: string } {
	const marker = `{{${index}}}`;
	const at = template.indexOf(marker);
	if (at < 0) return { before: '', after: '' };
	let start = 0;
	// A fresh global copy: a shared one carries its lastIndex between calls.
	for (const m of template.slice(0, at).matchAll(new RegExp(END, 'g'))) start = m.index + 1;
	const rest = template.slice(at + marker.length);
	const stop = END.exec(rest);
	const end = stop ? stop.index + 1 : rest.length;
	return {
		before: fill(template.slice(start, at), blanks).trim(),
		after: fill(rest.slice(0, end), blanks).trimEnd()
	};
}

/** Every missed gap, in the order the text has them. */
export function clozeMisses(
	template: string,
	blanks: readonly InlineBlank[],
	answers: readonly string[],
	results: readonly boolean[]
): ClozeMiss[] {
	const order = [...template.matchAll(MARKER)].map((m) => Number(m[1]));
	return order
		.filter((i) => blanks[i] && !results[i])
		.map((i) => ({
			index: i,
			...gapSentence(template, blanks, i),
			given: (answers[i] ?? '').trim(),
			answer: blanks[i].answer,
			hint: blanks[i].hint,
			why: blanks[i].why
		}));
}
