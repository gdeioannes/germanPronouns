// "Ja oder Nein?" — the deck's surprise: a themed round of eight yes-or-no
// questions about life in Germany, swiped left or right against a
// psychedelic sky. No score, no medals, nothing to get wrong: the point is
// to read eight short German questions without noticing, laugh, and get a
// result worth sending to someone. Every Ja and every Nein feeds one of the
// round's five personas (./janeinRounds holds the shelves of rounds), the
// strongest is who you are tonight, and the share text is a Wordle-style
// row of squares with that name on it. This file: the question shape, the
// share text, and the tickets the deck deals the card on.

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

export const JA_NEIN_CARD_ID = 'play:ja-nein';
const WALLET_KEY = 'janein_wallet';

/**
 * Rounds are paid for in tickets. One arrives with the first deck, another
 * every twelve hours up to a pocket of two, and a good run can win one. The
 * card is only dealt while there is a ticket to spend, so the game stays a
 * treat rather than a fixture; playing from the deck spends the ticket.
 */
export const TICKET_CAP = 2;
export const REFILL_HOURS = 12;
/** The chance the card joins a deal while a ticket is in the pocket. */
export const DEAL_CHANCE = 0.3;
/** The win chance by how many tickets are already in the pocket; none at the cap. */
export const WIN_CHANCE: readonly number[] = [1 / 4, 1 / 8];

const HOUR = 60 * 60 * 1000;

export interface JaNeinWallet {
	tickets: number;
	/** When the next free ticket arrives. */
	refillAt: number;
	/** The first ticket is dealt for sure, once: a newcomer must meet the game. */
	sureDeal: boolean;
}

export function newWallet(now = Date.now()): JaNeinWallet {
	return { tickets: 1, refillAt: now + REFILL_HOURS * HOUR, sureDeal: true };
}

/**
 * The wallet as it stands now: free tickets that fell due since the last
 * look are added, one per twelve hours, never past the cap. At the cap the
 * clock waits, so an unplayed pocket does not bank refills.
 */
export function refillWallet(w: JaNeinWallet, now = Date.now()): JaNeinWallet {
	let { tickets, refillAt } = w;
	while (tickets < TICKET_CAP && now >= refillAt) {
		tickets++;
		refillAt += REFILL_HOURS * HOUR;
	}
	if (tickets >= TICKET_CAP) refillAt = Math.max(refillAt, now + REFILL_HOURS * HOUR);
	return { ...w, tickets, refillAt };
}

export function loadWallet(now = Date.now()): JaNeinWallet {
	let w: JaNeinWallet | null = null;
	try {
		const raw = localStorage.getItem(WALLET_KEY);
		if (raw) {
			const p = JSON.parse(raw);
			if (typeof p?.tickets === 'number' && typeof p?.refillAt === 'number')
				w = { tickets: p.tickets, refillAt: p.refillAt, sureDeal: p.sureDeal === true };
		}
	} catch {
		/* no storage: a fresh wallet every visit */
	}
	const next = refillWallet(w ?? newWallet(now), now);
	if (!w || next.tickets !== w.tickets || next.refillAt !== w.refillAt) saveWallet(next);
	return next;
}

export function saveWallet(w: JaNeinWallet): void {
	try {
		localStorage.setItem(WALLET_KEY, JSON.stringify(w));
	} catch {
		/* storage unavailable: the wallet just resets next visit */
	}
}

/** A ticket in the pocket right now, refills applied. */
export function jaNeinTickets(now = Date.now()): number {
	return loadWallet(now).tickets;
}

/**
 * The same pocket pays for "Schreib mir!": starting a new match chat spends
 * a ticket too (domain/matchChat), so tickets won in runs buy either game.
 */
export const gameTickets = (now = Date.now()) => jaNeinTickets(now);
/** When the next free ticket arrives (the pocket refills one every twelve hours). */
export const nextTicketAt = (now = Date.now()) => loadWallet(now).refillAt;

/** Opening the game from the deck spends a ticket. */
export function spendJaNeinTicket(now = Date.now()): JaNeinWallet {
	const w = loadWallet(now);
	const next = { ...w, tickets: Math.max(0, w.tickets - 1), sureDeal: false };
	saveWallet(next);
	return next;
}

/** The win chance for a run, given whether it passed and the pocket. */
export function ticketWinChance(passed: boolean, tickets: number): number {
	return passed ? (WIN_CHANCE[tickets] ?? 0) : 0;
}

/**
 * A run just ended: a pass (eight of ten or better) rolls for a ticket, with
 * the odds shrinking as the pocket fills and none at the cap. True when one
 * was won.
 */
export function rollJaNeinTicket(passed: boolean, random: () => number = Math.random, now = Date.now()): boolean {
	const w = loadWallet(now);
	const chance = ticketWinChance(passed, w.tickets);
	if (chance <= 0 || random() >= chance) return false;
	saveWallet({ ...w, tickets: w.tickets + 1 });
	return true;
}

/**
 * Whether this deal gets the card, and where. No ticket: never. The first
 * ticket ever: for sure, right under the top card. Otherwise a coin toss,
 * and a slot from the second to the fifth card. A swipe-away keeps it out
 * until the skip list clears, like any other card.
 */
export function jaNeinDealSlot(
	skipped: Set<string>,
	random: () => number = Math.random,
	wallet: JaNeinWallet = loadWallet()
): number | null {
	if (skipped.has(JA_NEIN_CARD_ID)) return null;
	if (wallet.tickets <= 0) return null;
	if (wallet.sureDeal) return 1;
	if (random() >= DEAL_CHANCE) return null;
	return 1 + Math.floor(random() * 4);
}
