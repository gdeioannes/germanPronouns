// The three real questions TryExercise.svelte shows on the landing page. A
// module of their own so the audio collector can pre-record their sentences.

export interface TryQuestion {
	before: string;
	after: string;
	english: string;
	options: string[];
	answer: string;
	why: string;
}

export const TRY_QUESTIONS: TryQuestion[] = [
	{
		before: 'Ich trinke',
		after: 'Kaffee.',
		english: "I'm drinking a coffee.",
		options: ['der', 'den', 'dem'],
		answer: 'den',
		why: 'Kaffee is masculine and the object of trinken, so der becomes den — the accusative.'
	},
	{
		before: 'Wir fahren morgen',
		after: 'Berlin.',
		english: "We're going to Berlin tomorrow.",
		options: ['nach', 'zu', 'in'],
		answer: 'nach',
		why: 'Towns and most countries take nach when you travel to them.'
	},
	{
		before: 'Ich bleibe zu Hause, weil ich krank',
		after: '.',
		english: "I'm staying at home because I'm ill.",
		options: ['bin', 'ist', 'sein'],
		answer: 'bin',
		why: 'weil sends the verb to the end of its clause — and with ich it is bin.'
	}
];

/** The sentence with its answer in place — what the speak button reads. */
export function tryFilled(q: TryQuestion): string {
	return `${q.before} ${q.answer}${q.after === '.' ? '' : ' '}${q.after}`;
}
