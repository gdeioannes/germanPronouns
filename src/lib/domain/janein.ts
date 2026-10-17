// "Ja oder Nein?" — the deck's surprise: a themed round of eight yes-or-no
// questions about life in Germany, swiped left or right against a
// psychedelic sky. No score, no medals, nothing to get wrong: the point is
// to read eight short German questions without noticing, laugh, and get a
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
	/** The German word to take away, and what it means. */
	word: { de: string; en: string };
}

export type Answer = 'ja' | 'nein';

export const JA_NEIN_PATH = '/play/ja-nein';

/** The row of squares: green for every Ja, red for every Nein, in order. */
export function answerSquares(answers: Answer[]): string {
	return answers.map((a) => (a === 'ja' ? '🟩' : '🟥')).join('');
}

/**
 * What goes into WhatsApp: who you are, then every answer as a line, a tick
 * for Ja and a cross for Nein, so the person reading it knows exactly what
 * you said yes to — that is the part worth arguing about. The dare and the
 * link close it.
 */
/** The language the share text is written in. German is the native one. */
export type ShareLang = 'de' | 'en';

/**
 * One answer as a line of the share text: the question with a tick or a
 * cross, or for this-or-that the choice over the other.
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

/**
 * What goes into WhatsApp: who you are tonight, every answer as a line, and
 * the link. German by default, on purpose: the person
 * receiving it gets ten real lines of it, and the sender a little pride.
 * English on request, for a friend who would only see noise.
 */
export function shareText(
	result: { persona: Persona; questions: JaNeinQuestion[]; answers: Answer[]; round?: { title: string } },
	url: string,
	lang: ShareLang = 'de'
): string {
	const lines = result.answers.map((a, i) => (result.questions[i] ? shareLine(result.questions[i], a, lang) : ''));
	const theme = result.round ? ` · ${result.round.title}` : '';
	const head =
		lang === 'de'
			? `Ja oder Nein?${theme} 🇩🇪 Heute bin ich ${result.persona.title} ${result.persona.emoji}`
			: `Ja oder Nein?${theme} 🇩🇪 Tonight I'm ${result.persona.title} ${result.persona.emoji}`;
	// The dare: the link opens the same round, so the answer comes back in kind.
	const dare = lang === 'de' ? 'Und du? Gleiche Fragen:' : 'Your turn, same questions:';
	return [head, ...lines, dare, url].join('\n');
}

export function whatsappHref(text: string): string {
	return `https://wa.me/?text=${encodeURIComponent(text)}`;
}

// -- the deck ---------------------------------------------------------------

// The card is one of the deck's surprises (domain/surprise): it turns up by
// chance, at most one surprise a hand, and costs nothing to play.
export const JA_NEIN_CARD_ID = 'play:ja-nein';
