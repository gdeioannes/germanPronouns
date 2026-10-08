// German lines in the number tasks get an emoji right after the words a
// beginner should pin down: every number word gets its keycap (drei 3️⃣), and
// a handful of nouns their picture (Bier 🍺). Display only — the content keeps
// plain German, because the audio tools record and check that text.

export const NUMBER_WORDS = ['null', 'eins', 'zwei', 'drei', 'vier', 'fünf', 'sechs', 'sieben', 'acht', 'neun', 'zehn'];

const KEYCAPS = ['0️⃣', '1️⃣', '2️⃣', '3️⃣', '4️⃣', '5️⃣', '6️⃣', '7️⃣', '8️⃣', '9️⃣', '🔟'];

const EMOJI: Record<string, string> = {
	...Object.fromEntries(NUMBER_WORDS.map((w, i) => [w, KEYCAPS[i]])),
	bier: '🍺',
	prost: '🍻',
	bar: '🍸',
	leute: '👥',
	sofort: '⚡',
	kaffee: '☕',
	ladekabel: '🔌',
	nummer: '🔢',
	privatnummer: '🔢',
	arbeit: '💼',
	büro: '🏢',
	sonntag: '📅',
	tanzfläche: '💃',
	nacht: '🌙',
	minuten: '⏱️',
	'u-bahn': '🚇',
	gleis: '🚉',
	gleiswechsel: '🔀',
	achtung: '⚠️',
	pizzeria: '🍕',
	margherita: '🍕',
	zahnschmerzen: '🦷',
	sauna: '🧖',
	liegestütze: '💪',
	taxi: '🚕'
};

export type EmojiSegment = { kind: 'text'; text: string } | { kind: 'emoji'; emoji: string };

/** The line as text runs with an emoji after each word that has one (never twice in a row). */
export function emojiSegments(line: string): EmojiSegment[] {
	const out: EmojiSegment[] = [];
	let text = '';
	let last = 0;
	for (const m of line.matchAll(/[A-Za-zÄÖÜäöüß]+(?:-[A-Za-zÄÖÜäöüß]+)*/g)) {
		const end = m.index + m[0].length;
		const emoji = EMOJI[m[0].toLowerCase()];
		text += line.slice(last, end);
		last = end;
		// Already written by hand ("Ladekabel 😅🔌")? Leave it.
		if (!emoji || line.slice(end, end + 6).includes(emoji)) continue;
		out.push({ kind: 'text', text }, { kind: 'emoji', emoji });
		text = '';
	}
	text += line.slice(last);
	if (text) out.push({ kind: 'text', text });
	return out;
}

const WORD = `(?:${NUMBER_WORDS.join('|')})`;
const NUMBER_RUN = new RegExp(String.raw`(?<!\p{L})${WORD}(?:[\s,–-]+${WORD})+(?!\p{L})`, 'giu');
const DIGIT_RUN = /\d(?:[\d ]*\d){2,}/g;
export const NUMBER_MASK = '🔢 ···';

/**
 * A phone line with the number itself taken out: runs of German number words
 * ("null, eins, sieben, sechs") and of digits ("0176 913") become 🔢 ···, so
 * the line can stay on screen while the number has to be caught by ear.
 */
export function hideNumber(line: string): string {
	return line.replace(NUMBER_RUN, NUMBER_MASK).replace(DIGIT_RUN, NUMBER_MASK);
}
