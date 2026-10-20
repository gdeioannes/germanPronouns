// "Ja oder Nein?" — the deck's surprise: a themed round of twelve yes-or-no
// questions about life in Germany, swiped left or right against a
// psychedelic sky. No score, no medals, nothing to get wrong: the point is
// to read twelve short German questions without noticing, laugh, and get a
// result worth sending to someone. Every Ja and every Nein feeds one of the
// round's five personas (./janeinRounds holds the shelves of rounds), the
// strongest is who you are tonight, and the share text is a Wordle-style
// row of squares with that name on it. This file: the question shape, the
// share text, and the id of its deck card (a surprise, see domain/surprise).

/** A persona id within its category. */
export type Vibe = string;

/** One side of a this-or-that question. */
export interface Option {
	de: string;
	en: string;
}

export interface JaNeinQuestion {
	/** The question, in German, short enough to read at a glance. */
	de: string;
	/** What it means. */
	en: string;
	/** The vibe a Ja (or the right-hand option) feeds. */
	ja: Vibe;
	/** The vibe a Nein (or the left-hand option) feeds. */
	nein: Vibe;
	/** This-or-that: the left option (a swipe left) … */
	left?: Option;
	/** … and the right one (a swipe right). */
	right?: Option;
}

/** Whether a question is this-or-that rather than yes-or-no. */
export function isPair(q: JaNeinQuestion): q is JaNeinQuestion & { left: Option; right: Option } {
	return !!q.left && !!q.right;
}

export interface Persona {
	id: string;
	/** The name, gender-neutral German. */
	title: string;
	emoji: string;
	/** One line about this person, in English. */
	line: string;
	/** Two or three sentences on who this person is: the profile the verdict shows. */
	profile: string;
	/** Three short tags. */
	traits: string[];
	/** The same three, in German, for the German face of the verdict. */
	de: { line: string; profile: string; traits: string[] };
	/** The persona (id) this one gets on best with … */
	match: string;
	/** … and the one it clashes with. */
	clash: string;
	/** The German word to take away, and what it means. */
	word: { de: string; en: string };
}

export type Answer = 'ja' | 'nein';

export const JA_NEIN_PATH = '/play/ja-nein';

/** The row of squares: green for every Ja, red for every Nein, in order. */
export function answerSquares(answers: Answer[]): string {
	return answers.map((a) => (a === 'ja' ? '🟩' : '🟥')).join('');
}

/** The language the share text is written in. German is the native one. */
export type ShareLang = 'de' | 'en';

/**
 * One answer as a line: the question with a tick or a cross, or for
 * this-or-that the choice over the other. Kept for the dev table; the share
 * text itself no longer lists answers.
 */
export function shareLine(q: JaNeinQuestion, a: Answer, lang: ShareLang = 'de'): string {
	if (isPair(q)) {
		const chosen = a === 'ja' ? q.right : q.left;
		const other = a === 'ja' ? q.left : q.right;
		const cap = (w: string) => w.charAt(0).toUpperCase() + w.slice(1);
		return `⚖️ ${cap(chosen[lang])} > ${cap(other[lang])}`;
	}
	return `${a === 'ja' ? '✅' : '❌'} ${q[lang]}`;
}

/** One share of the mix as a bar of eight blocks, WhatsApp-friendly. */
export function mixBar(share: number): string {
	const n = Math.round(Math.max(0, Math.min(1, share)) * 8);
	return '▰'.repeat(n) + '▱'.repeat(8 - n);
}

export interface MixEntry {
	persona: Persona;
	count: number;
	/** 0–1 */
	share: number;
}

/**
 * The message, laid out for WhatsApp (which renders *bold* and _italic_):
 * the question, the type you are and how much, every type as a bar in the
 * theme's fixed order with yours in bold, who you go with, the tagline, and
 * the dare with the link, which opens the same round so the answer comes
 * back in kind. German by default; English for a friend who would only see
 * noise.
 */
export function shareText(
	result: {
		persona: Persona;
		mix: MixEntry[];
		slices?: MixEntry[];
		match?: Persona;
		clash?: Persona;
		category: { title: string; en: string; emoji: string };
	},
	url: string,
	lang: ShareLang = 'de'
): string {
	const de = lang === 'de';
	const p = result.persona;
	const pct = Math.round((result.mix[0]?.share ?? 0) * 100);
	const rows = result.slices ?? result.mix;
	const bars = rows.map((m) => {
		const mine = m.persona.id === p.id;
		const name = mine ? `*${m.persona.title}*` : m.persona.title;
		return `${m.persona.emoji} ${mixBar(m.share)} ${Math.round(m.share * 100)} % ${name}`;
	});
	const lines = [
		`${result.category.emoji} *${de ? result.category.title : result.category.en}*`,
		de ? `Ich bin *${p.title}* ${p.emoji} – zu ${pct} %` : `I'm *${p.title}* ${p.emoji} – ${pct} %`,
		'',
		...bars
	];
	if (result.match && result.clash) {
		lines.push('', `${de ? '💞 Passt zu' : '💞 Gets on with'}: ${result.match.emoji} ${result.match.title}`);
		lines.push(`${de ? '⚡ Clash mit' : '⚡ Clashes with'}: ${result.clash.emoji} ${result.clash.title}`);
	}
	lines.push('', `_${de ? p.de.line : p.line}_`);
	lines.push('', de ? '👉 Und du? Gleiche 12 Fragen:' : '👉 Your turn, same 12 questions:', url);
	return lines.join('\n');
}

// -- the result in the link ------------------------------------------------------

/**
 * The answers as a string in the link ("jnjjnnjjnjjn"), one letter per
 * question in the round's ORIGINAL order (the round is shuffled per play),
 * so whoever opens the link sees the sender's card before playing.
 */
export function encodeAnswers(original: JaNeinQuestion[], played: JaNeinQuestion[], answers: Answer[]): string {
	return original
		.map((q) => {
			const i = played.indexOf(q);
			const a = i >= 0 ? answers[i] : undefined;
			return a === 'ja' ? 'j' : a === 'nein' ? 'n' : '';
		})
		.join('');
}

/** The answers back from the link, or null when the string does not fit the round. */
export function decodeAnswers(code: string | null | undefined, length: number): Answer[] | null {
	if (!code || code.length !== length || !/^[jn]+$/.test(code)) return null;
	return [...code].map((c) => (c === 'j' ? 'ja' : 'nein'));
}

/**
 * The same message without emoji, for WhatsApp Desktop on Windows, which
 * turns 4-byte characters in a wa.me link into question marks (phones are
 * fine). Bars and formatting stay.
 */
export function plainText(text: string): string {
	return text
		.replace(/[\p{Extended_Pictographic}\u{FE0F}\u{200D}]/gu, '')
		.replace(/[ 	]{2,}/g, ' ')
		.replace(/^ +/gm, '');
}

export function whatsappHref(text: string): string {
	return `https://wa.me/?text=${encodeURIComponent(text)}`;
}

// -- the deck ---------------------------------------------------------------

// The card is one of the deck's surprises (domain/surprise): it turns up by
// chance, at most one surprise a hand, and costs nothing to play.
export const JA_NEIN_CARD_ID = 'play:ja-nein';
