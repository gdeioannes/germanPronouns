// "Schreib mir!" — the match chat game (docs/match_chat_helga.md).
//
// A character asks; the learner answers by BUILDING a sentence from a word
// bank (never by picking an answer). Two things are read from what they built:
//
//   * MEANING — keywords pick an intent (the branch). Intents are tried top to
//     bottom and the first match wins, so a "nicht" or an earlier claim (a
//     flag) can steer a sentence to a different, often worse, intent.
//   * FORM — a 0–100 score. Every tile is classified from a small lexicon, and
//     verb forms, articles, adjective endings and verb position are checked
//     with real German rules, not against a stored answer, so any sensible
//     sentence the bank allows is graded fairly.
//
// Interest (0–10, starts at 5) moves by the intent's value plus a bonus for a
// perfect sentence. At 0 the character deletes the match on the spot. Every
// chat happens once: the whole state is the log of sent sentences, saved after
// each turn and replayed through these pure functions to rebuild the chat.

// -- content ------------------------------------------------------------------

export type Gender = 'm' | 'f' | 'n' | 'pl';

export interface ChatMessage {
	who: string;
	type: 'text' | 'photo' | 'voice';
	/** The German line (text), or the transcript (voice). May contain {name}. */
	de?: string;
	en?: string;
	/** Shown after the text, never spoken. */
	emoji?: string;
	/** Recorded clip id under /audio/story/, without extension. */
	audio?: string;
	/** Picture id under /img/story/, without extension. */
	image?: string;
	alt?: string;
	/** Lines drawn over a photo (a flyer), so its text is always right. */
	overlay?: string[];
	wide?: boolean;
	/** Background under a voice note. */
	bg?: 'techno' | 'scratch';
	/** Acting brief for the recording tool. */
	direction?: string;
}

export interface IntentWhen {
	/** Every keyword must appear. */
	all?: string[];
	/** At least one must appear. */
	any?: string[];
	/** None may appear. */
	none?: string[];
	/** Only when this flag was set earlier. */
	flag?: string;
	/** Only when this flag was NOT set earlier. */
	noFlag?: string;
}

export interface Intent {
	id: string;
	when: IntentWhen;
	value: number;
	reply: ChatMessage[];
	flags?: string[];
	/** keyword → flag, set only when the keyword is in the sentence. */
	flagsIf?: Record<string, string>;
	/** A line for the contact card: "💃 tanzt gern". */
	fact?: string;
	/** The player's own photo, sent with the sentence. */
	photo?: string;
	/** Why this hurt, for the deletion line. */
	cause?: string;
	next?: string;
	/** No perfect-sentence bonus (a branch switch, not an answer). */
	noBonus?: boolean;
}

/** A wrong tile → the right one, as a plain string or with a note on why. */
export type WrongForm = string | { to: string; kind?: 'verb' | 'word'; note?: string };

export interface Turn {
	id: string;
	before: ChatMessage[];
	tiles: string[];
	/** Wrong forms in this bank → the right one ("tanzt" → "tanze", "machen" → "treffen"). */
	wrong: Record<string, WrongForm>;
	intents: Intent[];
	next?: string;
	/**
	 * The case a preposition takes in this turn, where it can take two
	 * (Wechselpräpositionen): { "auf": "acc" } for "Wohin?", "dat" for "Wo?".
	 */
	prepCase?: Record<string, Case>;
}

export interface Lexicon {
	/** Every noun tile with its gender ("pl" for a plural). */
	nouns: Record<string, Gender>;
	names: string[];
	/** Finite verb forms, right and wrong ones ("tanze", "tanzt", "hat", "wäre"). */
	verbs: string[];
	/** Infinitives and participles that close a clause ("gegessen", "kommen", "gemacht"). */
	nonfinite?: string[];
	/** Imperatives, which may open a sentence ("komm", "gib"). */
	imperatives?: string[];
	/** Verbs with an accusative object. */
	accVerbs: string[];
	/** Verbs with a dative (or dative + accusative) object: geben, helfen, gefallen … */
	datVerbs?: string[];
	adjectives: string[];
	/** Extra subordinators for this chat ("als", "wie", "warum" in indirect questions). */
	subordinators?: string[];
}

export interface ChatTest {
	turn: string;
	/** The sentence as written: "Ich komme mit Freunden." */
	say: string;
	score?: number;
	/** The intent it must hit; null for off-topic or "Hä?". */
	intent?: string | null;
	delta?: number;
}

export interface Playthrough {
	name: string;
	/** [turn id, sentence] in order. */
	say: Array<[string, string]>;
	ending: Ending;
}

export interface ImagePrompt {
	id: string;
	aspect?: string;
	/** "{self}" is replaced with the chat's imageCharacter. */
	prompt: string;
}

export interface MatchChat {
	id: string;
	name: string;
	age: number;
	emoji: string;
	image: string;
	/** The sub-level module: "A1.1" … "C2.2". */
	level: string;
	/** Order within the level on the deck. */
	order?: number;
	bio: string;
	bioEn: string;
	goal: string;
	tagline: string;
	/** Gemini voice name and acting brief for tool/gen-story-audio.mjs. */
	voice?: string;
	brief?: string;
	/** The grammar this chat practises, for the profile card. */
	focus?: string;
	lexicon: Lexicon;
	intro: ChatMessage[];
	turns: Turn[];
	offTopic: ChatMessage;
	confused: ChatMessage[];
	endings: {
		win: ChatMessage[];
		secret: ChatMessage[];
		partial: ChatMessage[];
		deleted: Record<string, ChatMessage>;
		sunday: ChatMessage;
	};
	/** Headline of the partial ending ("Du bist drin. Mit zwölf Kisten."). */
	partialTitle?: string;
	/** Share texts; {score} and {url} are filled in. */
	share?: { win: string; secret?: string; partial: string; deleted: string };
	/** The flag that turns a win into the secret ending (default "secret"). */
	secretFlag?: string;
	/** Only on the deck once another chat's secret ending unlocks it. */
	hidden?: boolean;
	unlocks?: { id: string; name: string; emoji: string; bio: string };
	imageCharacter?: string;
	imagePrompts?: ImagePrompt[];
	tests?: ChatTest[];
	playthroughs?: Playthrough[];
}

const raw = import.meta.glob<MatchChat>('/assets/content/match/*.json', { eager: true, import: 'default' });
const LEVEL_ORDER = ['A1.1', 'A1.2', 'A2.1', 'A2.2', 'B1.1', 'B1.2', 'B2.1', 'B2.2', 'C1.1', 'C1.2', 'C2.1', 'C2.2'];
export const levelRank = (level: string) => {
	const i = LEVEL_ORDER.indexOf(level);
	return i < 0 ? LEVEL_ORDER.indexOf(`${level}.1`) : i;
};
/** Every chat, easiest module first. */
export const MATCH_CHATS: MatchChat[] = Object.values(raw).sort(
	(a, b) => levelRank(a.level) - levelRank(b.level) || (a.order ?? 50) - (b.order ?? 50) || a.id.localeCompare(b.id)
);

export function findChat(id: string | null | undefined): MatchChat | undefined {
	return MATCH_CHATS.find((c) => c.id === id);
}

export const MATCH_PATH = '/play/schreib-mir';

/** The tile that ends a sentence; always on offer, never used up. */
export const STOP = '.';
/** The tile that ends a question: the verb may come first ("Kommst du?"). */
export const QUESTION = '?';
const isEnd = (t: string) => t === STOP || t === QUESTION;
export const NAME_TILE = '{name}';

// -- the grammar -------------------------------------------------------------

export type Case = 'nom' | 'acc' | 'dat' | 'gen';
type Kind =
	| 'stop' | 'intj' | 'conj' | 'sub' | 'prep' | 'det' | 'adj' | 'noun' | 'name' | 'num' | 'verb' | 'inf' | 'pron' | 'adv';

const SUBJECT_PRONOUNS = new Set(['ich', 'du', 'er', 'sie', 'wir', 'ihr', 'man']);
const PRONOUNS = new Set([
	...SUBJECT_PRONOUNS, 'es', 'mich', 'dich', 'ihn', 'mir', 'dir', 'ihm', 'uns', 'euch', 'ihnen', 'sich',
	'alles', 'etwas', 'nichts', 'jemand', 'niemand', 'dies'
]);
const INTERJECTIONS = new Set([
	'ja', 'nein', 'doch', 'hallo', 'okay', 'tschüss', 'danke', 'bitte', 'oh', 'ach', 'na', 'klar', 'genau', 'sorry',
	'entschuldigung', 'hey', 'ey', 'naja', 'tja', 'moin', 'servus'
]);
/** Focus particles stand in front of the phrase they focus, inside its slot: "Nur noch deine Unterschrift fehlt". */
const FOCUS = new Set(['nur', 'sogar', 'auch', 'selbst', 'erst', 'schon', 'noch', 'gerade', 'ausgerechnet', 'allein', 'genau']);
/** Adverbs that can follow a noun inside its phrase: "Der Stuhl rechts ist frei". */
const ATTACHED = new Set(['rechts', 'links', 'hier', 'dort', 'da', 'oben', 'unten', 'drüben', 'draußen', 'drinnen', 'nebenan', 'hinten', 'vorne']);
/** Articles whose form the checker does not pin down, but which open a phrase: "Alle Zimmer sind geputzt". */
const OTHER_DETS = new Set([
	'alle', 'jede', 'jeder', 'jedes', 'jeden', 'jedem', 'diese', 'dieser', 'dieses', 'diesen', 'diesem',
	'welche', 'welcher', 'welches', 'welchen', 'welchem', 'manche', 'mancher', 'manches', 'manchen', 'beide', 'beiden',
	'viele', 'vielen', 'einige', 'einigen', 'mehrere', 'mehreren', 'wenige', 'wenigen'
]);
/** Colour words and the like that never take an ending: "das kleine rosa Paket". */
const INDECLINABLE = new Set(['rosa', 'lila', 'beige', 'orange', 'prima', 'super', 'klasse', 'extra']);
/** Clock words that belong to the number: "um halb acht", "Viertel nach drei". */
const TIME_WORDS = new Set(['halb', 'viertel', 'dreiviertel']);
const CONJUNCTIONS = new Set(['und', 'aber', 'oder', 'denn', 'sondern']);
const SUBORDINATORS = new Set([
	'weil', 'dass', 'obwohl', 'wenn', 'ob', 'damit', 'nachdem', 'bevor', 'falls', 'sobald', 'sodass',
	'während', 'seit', 'seitdem', 'bis', 'indem', 'sofern', 'zumal', 'soweit'
]);
const PREPOSITIONS: Record<string, Case> = {
	mit: 'dat', von: 'dat', aus: 'dat', bei: 'dat', zu: 'dat', nach: 'dat', seit: 'dat', gegenüber: 'dat', ab: 'dat',
	// two-way prepositions default to "Wo?" (dative); a turn's prepCase overrides
	auf: 'dat', in: 'dat', an: 'dat', neben: 'dat', über: 'dat', unter: 'dat', vor: 'dat', hinter: 'dat', zwischen: 'dat',
	um: 'acc', für: 'acc', ohne: 'acc', durch: 'acc', gegen: 'acc', bis: 'acc',
	wegen: 'gen', trotz: 'gen', während: 'gen', statt: 'gen', anstatt: 'gen', innerhalb: 'gen', außerhalb: 'gen',
	aufgrund: 'gen', infolge: 'gen', mithilfe: 'gen', anhand: 'gen', bezüglich: 'gen', hinsichtlich: 'gen',
	angesichts: 'gen', mangels: 'gen', anlässlich: 'gen', zwecks: 'gen', seitens: 'gen', oberhalb: 'gen',
	unterhalb: 'gen', jenseits: 'gen', diesseits: 'gen', unweit: 'gen'
};
/** Preposition + article in one word: the noun after it has no article of its own. */
const CONTRACTIONS: Record<string, Case> = {
	am: 'dat', im: 'dat', zum: 'dat', zur: 'dat', vom: 'dat', beim: 'dat', ins: 'acc', ans: 'acc', aufs: 'acc'
};
const NUMBERS = new Set([
	'null', 'eins', 'ein', 'zwei', 'drei', 'vier', 'fünf', 'sechs', 'sieben', 'acht', 'neun', 'zehn', 'elf',
	'zwölf', 'dreizehn', 'vierzehn', 'fünfzehn', 'sechzehn', 'siebzehn', 'achtzehn', 'neunzehn', 'zwanzig',
	'einundzwanzig', 'zweiundzwanzig', 'dreiundzwanzig', 'dreißig', 'vierzig', 'fünfzig', 'hundert', 'tausend'
]);

const DEF: Record<Gender, Record<Case, string>> = {
	m: { nom: 'der', acc: 'den', dat: 'dem', gen: 'des' },
	f: { nom: 'die', acc: 'die', dat: 'der', gen: 'der' },
	n: { nom: 'das', acc: 'das', dat: 'dem', gen: 'des' },
	pl: { nom: 'die', acc: 'die', dat: 'den', gen: 'der' }
};
/** Endings of ein / mein / kein / dein … */
const EIN_END: Record<Gender, Record<Case, string>> = {
	m: { nom: '', acc: 'en', dat: 'em', gen: 'es' },
	f: { nom: 'e', acc: 'e', dat: 'er', gen: 'er' },
	n: { nom: '', acc: '', dat: 'em', gen: 'es' },
	pl: { nom: 'e', acc: 'e', dat: 'en', gen: 'er' }
};
const STRONG: Record<Gender, Record<Case, string>> = {
	m: { nom: 'er', acc: 'en', dat: 'em', gen: 'en' },
	f: { nom: 'e', acc: 'e', dat: 'er', gen: 'er' },
	n: { nom: 'es', acc: 'es', dat: 'em', gen: 'en' },
	pl: { nom: 'e', acc: 'e', dat: 'en', gen: 'er' }
};
const WEAK: Record<Gender, Record<Case, string>> = {
	m: { nom: 'e', acc: 'en', dat: 'en', gen: 'en' },
	f: { nom: 'e', acc: 'e', dat: 'en', gen: 'en' },
	n: { nom: 'e', acc: 'e', dat: 'en', gen: 'en' },
	pl: { nom: 'en', acc: 'en', dat: 'en', gen: 'en' }
};
const DEF_FORMS = new Set(['der', 'die', 'das', 'dem', 'den', 'des']);
const EIN_STEMS = ['ein', 'mein', 'dein', 'kein', 'sein', 'unser', 'euer', 'ihr'];
const ENDINGS = ['e', 'en', 'em', 'er', 'es'];

function einStem(word: string): string | null {
	for (const stem of EIN_STEMS) {
		if (word === stem || (word.startsWith(stem) && ENDINGS.includes(word.slice(stem.length)))) return stem;
	}
	return null;
}

function adjBase(word: string, adjectives: string[]): string | null {
	if (word !== word.toLowerCase()) return null;
	for (const base of adjectives) {
		if (word === base) return base;
		if (word.startsWith(base) && ENDINGS.includes(word.slice(base.length))) return base;
	}
	return null;
}

function baseKind(tile: string, lex: Lexicon): Kind {
	const low = tile.toLowerCase();
	if (isEnd(tile)) return 'stop';
	if (tile === NAME_TILE || lex.names.includes(tile)) return 'name';
	if (tile in lex.nouns) return 'noun';
	if (lex.verbs.includes(low) || lex.imperatives?.includes(low)) return 'verb';
	if (lex.nonfinite?.includes(low)) return 'inf';
	if (INTERJECTIONS.has(low)) return 'intj';
	if (CONJUNCTIONS.has(low)) return 'conj';
	if (SUBORDINATORS.has(low) || lex.subordinators?.includes(low)) return 'sub';
	if (low in PREPOSITIONS || low in CONTRACTIONS) return 'prep';
	// "ihr" alone is a pronoun; "ihre", "ihren" … are articles.
	if (low !== 'ihr' && (DEF_FORMS.has(low) || einStem(low) || OTHER_DETS.has(low))) return 'det';
	if (adjBase(tile, lex.adjectives)) return 'adj';
	if (NUMBERS.has(low) || TIME_WORDS.has(low)) return 'num';
	if (PRONOUNS.has(low)) return 'pron';
	return 'adv';
}

const isPhrase = (k: Kind | undefined) => k === 'det' || k === 'adj' || k === 'noun' || k === 'num' || k === 'name';

/**
 * Kinds in context: "während des Films" is a preposition, "während ich esse"
 * a subordinator; "das" with no noun after it is a pronoun ("Das ist gut").
 */
function kindsOf(sentence: string[], lex: Lexicon): Kind[] {
	const kinds = sentence.map((t) => baseKind(t, lex));
	kinds.forEach((k, i) => {
		const low = sentence[i].toLowerCase();
		const next = kinds[i + 1];
		// "seit ich hier wohne" opens a clause; "seit gestern", "bis morgen", "während des Films" are prepositions.
		if (k === 'sub' && low in PREPOSITIONS) kinds[i] = next === 'pron' || next === 'name' ? 'sub' : 'prep';
		if (k === 'det' && low === 'das' && !isPhrase(next)) kinds[i] = 'pron';
		// "ihr Nachbar": the possessive. Bare "ihr" can only own a masculine or
		// neuter noun; before "Schokolade" or "Platten" it is "to her".
		if (k === 'pron' && low === 'ihr' && next === 'adj') kinds[i] = 'det';
		if (k === 'pron' && low === 'ihr' && next === 'noun' && ['m', 'n'].includes(lex.nouns[sentence[i + 1]]))
			kinds[i] = 'det';
		// "sein" before nothing it could own is the infinitive ("pünktlich sein").
		if (k === 'det' && low === 'sein' && !isPhrase(next) && lex.nonfinite?.includes(low)) kinds[i] = 'inf';
		// "werden" after a participle closes a passive ("muss gemacht werden").
		if (k === 'verb' && lex.nonfinite?.includes(low) && kinds[i - 1] === 'inf') kinds[i] = 'inf';
		if (k === 'adv' && INDECLINABLE.has(low) && (next === 'noun' || next === 'adj')) kinds[i] = 'adj';
	});
	return kinds;
}

const isIndeclinable = (word: string) => INDECLINABLE.has(word.toLowerCase());

/**
 * In a question, a word a chat lists as a subordinator for indirect questions
 * ("welches", "was") that is followed by a single verb opens a direct question:
 * "Welches Formular brauche ich?" is a main clause, not "…, welches ich brauche".
 */
function questionKinds(sentence: string[] & { question?: boolean }, kinds: Kind[]): Kind[] {
	if (!sentence.question) return kinds;
	let lead = 0;
	while (lead < kinds.length && kinds[lead] === 'intj') lead++;
	if (kinds[lead] === 'sub' && kinds.filter((k) => k === 'verb').length === 1) {
		const out = [...kinds];
		// "Welches Formular …?": an article of its phrase; "Was …?": a word of its own.
		out[lead] = kinds[lead + 1] === 'noun' || kinds[lead + 1] === 'adj' ? 'det' : 'adv';
		return out;
	}
	return kinds;
}

export interface Correction {
	/** What was written ('' for a word-order or missing-verb note). */
	from: string;
	/** What it should be. */
	to: string;
	kind: 'verb' | 'word' | 'article' | 'ending' | 'order' | 'noVerb';
	points: number;
	/** Why, in English, for the score details. */
	note?: string;
}

export interface Grade {
	score: number;
	corrections: Correction[];
	/** The sentence as sent, punctuated and capitalised. */
	text: string;
	/** The same with every word fix applied (the recast). */
	fixed: string;
}

const POINTS = { verb: 20, word: 15, article: 15, ending: 15, order: 30, noVerb: 50 } as const;

/** Splits on the end tiles; empty sentences are dropped. Each knows whether it is a question. */
function sentencesOf(tokens: string[]): Array<string[] & { question?: boolean }> {
	const out: Array<string[] & { question?: boolean }> = [[]];
	for (const t of tokens) {
		if (isEnd(t)) {
			out[out.length - 1].question = t === QUESTION;
			out.push([]);
		} else out[out.length - 1].push(t);
	}
	return out.filter((s) => s.length);
}

type ClauseType = 'main' | 'sub' | 'afterSub';
interface Clause {
	start: number;
	tokens: string[];
	kinds: Kind[];
	type: ClauseType;
}

/** Where a sentence that opens with "Weil/Wenn/…" switches to its main clause: the main verb. */
function mainVerbAfterOpeningSub(kinds: Kind[]): number {
	let lead = 0;
	while (lead < kinds.length && kinds[lead] === 'intj') lead++;
	if (kinds[lead] !== 'sub') return -1;
	const f1 = kinds.findIndex((k, i) => i > lead && k === 'verb');
	return f1 < 0 ? -1 : kinds.findIndex((k, i) => i > f1 && k === 'verb');
}

/**
 * A sentence into clauses: the main clause; "und/aber" + a new clause (when a
 * verb follows); a subordinate clause from "weil/dass/…" to the next cut; and
 * a sentence that opens with one ("Weil ich krank bin, komme ich nicht"),
 * whose subordinate clause runs up to the main verb that follows it.
 */
function clausesOf(sentence: string[], kinds: Kind[]): Clause[] {
	const n = sentence.length;
	let lead = 0;
	while (lead < n && kinds[lead] === 'intj') lead++;
	const cuts: Array<{ at: number; type: ClauseType }> = [{ at: 0, type: 'main' }];
	let from = 1;
	if (kinds[lead] === 'sub') {
		cuts[0].type = 'sub';
		const main = mainVerbAfterOpeningSub(kinds);
		if (main > 0) {
			cuts.push({ at: main, type: 'afterSub' });
			from = main + 1;
		} else from = n;
	}
	for (let i = from; i < n; i++) {
		if (kinds[i] === 'sub') cuts.push({ at: i, type: 'sub' });
		else if (kinds[i] === 'conj') {
			let j = i + 1;
			let verb = false;
			while (j < n && kinds[j] !== 'conj' && kinds[j] !== 'sub') {
				if (kinds[j] === 'verb') verb = true;
				j++;
			}
			if (verb) cuts.push({ at: i, type: 'main' });
		}
	}
	return cuts
		.map((c, k) => {
			const end = cuts[k + 1]?.at ?? n;
			return { start: c.at, tokens: sentence.slice(c.at, end), kinds: kinds.slice(c.at, end), type: c.type };
		})
		.filter((c) => c.tokens.length);
}

/**
 * How many constituents stand in front of position `end`. A constituent is a
 * phrase: focus particles + [preposition] + a number with its clock words and
 * noun, or [article] adjectives (joined by und) and a noun, with what may hang
 * off that noun (a name: "Herr Wolf"; a place adverb: "der Stuhl rechts"; a
 * prepositional phrase: "die Limonade mit Eis"). An adverb followed straight
 * by a prepositional phrase is one slot too ("Gestern um acht").
 */
function constituentsBefore(tokens: string[], kinds: Kind[], start: number, end: number): number {
	const low = (i: number) => tokens[i]?.toLowerCase() ?? '';
	/** The noun phrase or number phrase starting at i; returns where it ends. */
	const nounPhrase = (i: number): number => {
		if (i < end && kinds[i] === 'num') {
			// "elf", "halb acht", "vierzehn Uhr zwölf", "fünf Freunden"
			while (i < end && (kinds[i] === 'num' || (kinds[i] === 'noun' && kinds[i - 1] === 'num'))) i++;
			return i;
		}
		if (i < end && (kinds[i] === 'det' || kinds[i] === 'adj')) {
			if (kinds[i] === 'det') i++;
			while (i < end && (kinds[i] === 'adj' || (CONJUNCTIONS.has(low(i)) && kinds[i + 1] === 'adj'))) i++;
			if (i < end && (kinds[i] === 'noun' || kinds[i] === 'name' || kinds[i] === 'pron')) i++;
			return i;
		}
		if (i < end) return i + 1; // pronoun, name, bare noun, adverb
		return i;
	};
	/** A prepositional phrase starting at i, or i itself if there is none. */
	const prepPhrase = (i: number): number => (i < end && kinds[i] === 'prep' && i + 1 < end ? nounPhrase(i + 1) : i);
	let count = 0;
	let i = start;
	while (i < end) {
		count++;
		while (i + 1 < end && FOCUS.has(low(i)) && kinds[i] === 'adv') i++;
		const first = kinds[i];
		i = kinds[i] === 'prep' ? prepPhrase(i) : nounPhrase(i);
		// What hangs off a noun inside its slot.
		if (first === 'det' || first === 'adj' || first === 'noun' || first === 'name') {
			while (i < end && kinds[i] === 'name') i++;
			if (i < end && ATTACHED.has(low(i))) i++;
			if (i < end && kinds[i] === 'prep' && i + 1 < end && isPhrase(kinds[i + 1])) i = prepPhrase(i);
		} else if (first === 'adv' && i < end && kinds[i] === 'prep') {
			i = prepPhrase(i);
		}
	}
	return count;
}

const ORDER_NOTES = {
	v2: 'Word order: the verb goes in second place.',
	sub: 'In a clause with weil, dass, wenn, ob … the verb goes to the end.',
	afterSub: 'After a weil/wenn/dass clause, the main verb comes first.',
	bracket: 'The infinitive or participle goes to the end of the clause.'
} as const;

/**
 * Grades what the learner built. `tokens` are tile texts in order, with STOP
 * between sentences; `name` replaces the name tile in the text; `prepCase`
 * is the turn's case for two-way prepositions.
 */
export function gradeSentence(
	tokens: string[],
	lex: Lexicon,
	wrong: Record<string, WrongForm>,
	name = '',
	prepCase: Record<string, Case> = {}
): Grade {
	const corrections: Correction[] = [];
	const fixedTokens = [...tokens];
	const fix = (i: number, to: string, kind: Correction['kind'], note?: string) => {
		corrections.push({ from: tokens[i], to, kind, points: POINTS[kind], ...(note ? { note } : {}) });
		fixedTokens[i] = to;
	};
	const order = (why: keyof typeof ORDER_NOTES) =>
		corrections.push({ from: '', to: '', kind: 'order', points: POINTS.order, note: ORDER_NOTES[why] });

	let offset = 0;
	for (const sentence of sentencesOf(tokens)) {
		// Where this sentence sits in `tokens`, to fix by index.
		while (isEnd(tokens[offset])) offset++;
		const base = offset;
		offset += sentence.length;
		const kinds = questionKinds(sentence, kindsOf(sentence, lex));

		// 1 · the bank's own distractors: wrong verb forms, wrong words.
		sentence.forEach((t, i) => {
			const w = wrong[t] ?? wrong[t.toLowerCase()];
			if (!w) return;
			const to = typeof w === 'string' ? w : w.to;
			// A plain form is a verb ending on a verb; a fix with a note is a word choice.
			const kind =
				typeof w === 'object' ? (w.kind ?? 'word') : kinds[i] === 'verb' || kinds[i] === 'inf' ? 'verb' : 'word';
			fix(base + i, matchCase(to, t), kind, typeof w === 'object' ? w.note : undefined);
		});

		for (const clause of clausesOf(sentence, kinds)) {
			const ck = clause.kinds;
			const ct = clause.tokens;
			const at = (i: number) => base + clause.start + i;

			// 2 · articles and adjective endings, phrase by phrase.
			const verbs = ck.flatMap((k, i) => (k === 'verb' ? [i] : []));
			const verbAt = verbs[0] ?? -1;
			const accVerb = verbs.some((v) => lex.accVerbs.includes(ct[v].toLowerCase()));
			const datVerb = verbs.some((v) => lex.datVerbs?.includes(ct[v].toLowerCase()));
			const hasSubjectPronoun = ct.some((t, i) => ck[i] === 'pron' && SUBJECT_PRONOUNS.has(t.toLowerCase()));
			const existential =
				ct.some((t) => t.toLowerCase() === 'es') && verbs.some((v) => ['gibt', 'gab', 'gäbe'].includes(ct[v].toLowerCase()));
			let lastCase: Case = 'nom';
			let seenPhrase = false;
			for (let i = 0; i < ct.length; i++) {
				if (ck[i] !== 'det' && ck[i] !== 'adj') continue;
				if (i > 0 && (ck[i - 1] === 'det' || ck[i - 1] === 'adj')) continue; // inside a phrase already handled
				// The second of two joined adjectives ("ruhigen und ordentlichen") was handled with the first.
				if (i > 1 && CONJUNCTIONS.has(ct[i - 1].toLowerCase()) && ck[i - 2] === 'adj') continue;
				// The phrase: [det] adj* noun
				let j = i;
				const det = ck[j] === 'det' ? j++ : -1;
				const adjs: number[] = [];
				while (j < ct.length && (ck[j] === 'adj' || (CONJUNCTIONS.has(ct[j].toLowerCase()) && ck[j + 1] === 'adj'))) {
					if (ck[j] === 'adj' && !isIndeclinable(ct[j])) adjs.push(j);
					j++;
				}
				const noun = j < ct.length && ck[j] === 'noun' ? j : -1;
				const gender = noun >= 0 ? lex.nouns[ct[noun]] : undefined;

				const prev = i > 0 ? ct[i - 1].toLowerCase() : '';
				const contraction = i > 0 && prev in CONTRACTIONS;
				// Which cases this phrase may be in, the likeliest first. With a
				// pronoun subject the verb decides; with a noun subject either
				// phrase may be the subject, so any case the verb allows will do.
				let allowed: Case[];
				if (i > 0 && ck[i - 1] === 'prep') allowed = [prepCase[prev] ?? PREPOSITIONS[prev] ?? CONTRACTIONS[prev] ?? 'dat'];
				// "… und deinen Mantel": the same case as the phrase it joins, if there is one.
				else if ((prev === 'und' || prev === 'oder') && seenPhrase) allowed = [lastCase];
				// "Es gibt einen Stuhl": what there is, is in the accusative.
				else if (existential) allowed = ['acc'];
				else if (verbAt < 0) allowed = ['nom', 'acc'];
				else if (hasSubjectPronoun) allowed = datVerb ? ['acc', 'dat'] : accVerb ? ['acc'] : ['nom'];
				else allowed = accVerb || datVerb ? ['nom', 'acc', 'dat'] : ['nom'];
				// Right after a noun, a genitive attribute: "das Auto des Nachbarn".
				if (i > 0 && ck[i - 1] === 'noun') allowed = [...allowed, 'gen'];

				// The article.
				let detEnding: string | null = null;
				let kase: Case = allowed[0];
				if (det >= 0 && gender) {
					const word = ct[det].toLowerCase();
					const stem = einStem(word);
					const formFor = (c: Case) =>
						DEF_FORMS.has(word)
							? DEF[gender][c]
							: stem && !(stem === 'ein' && gender === 'pl')
								? stem + EIN_END[gender][c]
								: null;
					const fits = allowed.find((c) => formFor(c) === word);
					if (fits) kase = fits;
					else {
						const want = formFor(kase);
						if (want) fix(at(det), matchCase(want, ct[det]), 'article');
					}
					detEnding = stem ? EIN_END[gender][kase] : 'def';
				}
				lastCase = kase;
				seenPhrase = true;

				// The adjectives: attributive before the noun, bare when predicative. With an
				// article but no noun ("Ich nehme das grüne") the noun is understood: any
				// ending fits, since the checker can't know which noun was meant.
				for (const a of adjs) {
					const baseForm = adjBase(ct[a], lex.adjectives)!;
					if (det >= 0 && noun < 0) continue;
					if (noun < 0 || !gender) {
						if (ct[a] !== baseForm) fix(at(a), baseForm, 'ending');
						continue;
					}
					const endingIn = (c: Case) =>
						contraction || detEnding === 'def'
							? WEAK[gender][c]
							: detEnding === null || detEnding === ''
								? STRONG[gender][c]
								: WEAK[gender][c];
					// Without an article to pin the case down, any allowed case will do.
					const options = det >= 0 ? [kase] : allowed;
					if (!options.some((c) => ct[a] === baseForm + endingIn(c)))
						fix(at(a), baseForm + endingIn(options[0]), 'ending');
				}
			}
			// A lone adjective not before a noun (predicative: "ist schwarz").
			for (let i = 0; i < ct.length; i++) {
				if (ck[i] !== 'adj' || isIndeclinable(ct[i])) continue;
				let j = i;
				while (j < ct.length && ck[j] === 'adj') j++;
				const beforeNoun = j < ct.length && ck[j] === 'noun';
				const startsPhrase = i === 0 || (ck[i - 1] !== 'det' && ck[i - 1] !== 'adj');
				// "das grüne" with the noun left out: not a predicative adjective.
				if (i > 0 && ck[i - 1] === 'det') continue;
				if (!beforeNoun && startsPhrase) {
					const baseForm = adjBase(ct[i], lex.adjectives)!;
					if (ct[i] !== baseForm && !corrections.some((c) => c.from === ct[i] && c.to === baseForm))
						fix(at(i), baseForm, 'ending');
				}
			}

			// 3 · word order. Interjections, conjunctions and the clause's own
			// subordinator stand outside the count.
			let lead = 0;
			while (lead < ct.length && (ck[lead] === 'intj' || ck[lead] === 'conj')) lead++;
			if (clause.type === 'sub' && ck[lead] === 'sub') lead++;
			const content = ct.length - lead;
			const imperative = verbAt >= 0 && Boolean(lex.imperatives?.includes(ct[verbAt].toLowerCase()));
			const nonfinite = ck.flatMap((k, i) => (k === 'inf' ? [i] : []));

			if (verbAt < 0) {
				const pronounSubject = ct
					.slice(lead)
					.some((t, i) => ck[lead + i] === 'pron' && (SUBJECT_PRONOUNS.has(t.toLowerCase()) || t.toLowerCase() === 'es'));
				if (content >= 2 && pronounSubject) corrections.push({ from: '', to: '', kind: 'noVerb', points: POINTS.noVerb });
				continue;
			}
			if (clause.type === 'sub') {
				// The verb last, any infinitive or participle right before it.
				const last = verbs.at(-1)!;
				const firstInf = ck.findIndex((k, i) => i >= lead && k === 'inf');
				const infOk =
					firstInf < 0 || ck.slice(firstInf, last).every((k, n, all) => k === 'inf' || (k === 'conj' && all[n + 1] === 'inf'));
				if (last !== ct.length - 1 || verbs.length > 1 || !infOk) order('sub');
				continue;
			}
			// "… und sah nichts": a second verb sharing the subject follows "und" straight away.
			const sharedSubject = lead > 0 && ck[lead - 1] === 'conj' && verbAt === lead;
			let before = constituentsBefore(ct, ck, lead, verbAt);
			// "Rocky, es fehlt …": a name used to address someone stands outside the sentence.
			// Only before ich/du/wir/ihr/es/man: "Rüdiger, er …" would be talking about him, not to him.
			if (
				before === 2 &&
				ck[lead] === 'name' &&
				lead + 1 < verbAt &&
				['ich', 'du', 'wir', 'ihr', 'es', 'man'].includes(ct[lead + 1].toLowerCase())
			)
				before = 1;
			if (clause.type === 'afterSub') {
				if (verbAt !== 0) {
					order('afterSub');
					continue;
				}
			} else if (sentence.question) {
				// "Kommst du?" (verb first) or "Wann kommst du?" (question word, then the verb).
				if (before > 1) {
					order('v2');
					continue;
				}
			} else if (!(imperative && verbAt === lead) && !sharedSubject && before !== 1) {
				order('v2');
				continue;
			}
			// The bracket: infinitives and participles close the clause. Two of them can
			// share the auxiliary, each with its own words after "und": "… zum Flughafen
			// gefahren und nach Mallorca geflogen".
			if (nonfinite.length) {
				const tail = ck.slice(nonfinite[0]);
				const parts: Kind[][] = [[]];
				tail.forEach((k) => (k === 'conj' ? parts.push([]) : parts[parts.length - 1].push(k)));
				const ok =
					parts[0].every((k) => k === 'inf') &&
					parts.slice(1).every((part) => part.length > 0 && part.at(-1) === 'inf' && !part.includes('verb'));
				if (!ok) order('bracket');
			}
		}
	}

	const score = Math.max(0, 100 - corrections.reduce((s, c) => s + c.points, 0));
	return { score, corrections, text: render(tokens, name, lex), fixed: render(fixedTokens, name, lex) };
}

function matchCase(word: string, like: string): string {
	return like[0] === like[0].toUpperCase() ? word[0].toUpperCase() + word.slice(1) : word;
}

/** Tiles → a written sentence: capitals, the commas German needs, a full stop. */
export function render(tokens: string[], name = '', lex?: Lexicon): string {
	const parts: string[] = [];
	for (const sentence of sentencesOf(tokens)) {
		const kinds: Kind[] = lex ? questionKinds(sentence, kindsOf(sentence, lex)) : sentence.map(() => 'adv');
		let lead = 0;
		while (lead < sentence.length && kinds[lead] === 'intj') lead++;
		// The comma after an opening subordinate clause sits before the main verb.
		const mainVerb = mainVerbAfterOpeningSub(kinds);
		const words = sentence.map((t) => (t === NAME_TILE ? name || '…' : t));
		let out = '';
		words.forEach((w, i) => {
			const low = sentence[i].toLowerCase();
			const word = i === 0 ? w.charAt(0).toUpperCase() + w.slice(1) : w;
			const comma =
				i > 0 &&
				(low === 'aber' || low === 'denn' || low === 'sondern' || (kinds[i] === 'sub' && i > lead) || i === mainVerb);
			if (comma) out = out.replace(/,?$/, ',');
			out += (i ? ' ' : '') + word;
			if (i === 0 && INTERJECTIONS.has(low) && words.length > 1) out += ',';
		});
		// "Hallo!" / "Ja!" on their own are exclamations, not statements.
		const lone = sentence.length === 1 && INTERJECTIONS.has(sentence[0].toLowerCase());
		parts.push(out.replace(/,$/, '') + (sentence.question ? '?' : lone ? '!' : '.'));
	}
	return parts.join(' ');
}

/**
 * "Ich komme mit Freunden." → the tiles of `turn`'s bank that build it
 * (longest tile first, so "in der Mitte" stays one tile; STOP between
 * sentences), or an error naming the word the bank cannot supply. The content
 * tests use it: every example sentence must be buildable from its bank.
 */
export function tilesFor(turn: Turn, sentence: string): string[] {
	const bank = [...turn.tiles];
	const words = sentence
		.replace(/!/g, '.')
		.replace(/[,„“":;]/g, '')
		.split(/\s+/)
		.flatMap((w) =>
			w === '.' || w === '?'
				? [w]
				: w.endsWith('.') || w.endsWith('?')
					? [w.slice(0, -1), w.slice(-1)]
					: [w]
		)
		.filter(Boolean);
	while (isEnd(words.at(-1) ?? '') && words.at(-1) === STOP) words.pop();
	const out: string[] = [];
	for (let i = 0; i < words.length; ) {
		if (isEnd(words[i])) {
			out.push(words[i]);
			i++;
			continue;
		}
		const sentenceStart = i === 0 || isEnd(out.at(-1) ?? '');
		const options = [...new Set(bank)].sort((a, b) => b.split(' ').length - a.split(' ').length);
		const hit = options.find((tile) =>
			tile.split(' ').every((p, k) => {
				const w = words[i + k];
				if (!w) return false;
				if (p === NAME_TILE) return w === NAME_TILE;
				// Case may differ only where the sentence capitalises the first word.
				return p === w || (k === 0 && sentenceStart && p.toLowerCase() === w.toLowerCase());
			})
		);
		if (!hit) throw new Error(`"${words[i]}" is not in ${turn.id}'s bank (${sentence})`);
		bank.splice(bank.indexOf(hit), 1);
		out.push(hit);
		i += hit.split(' ').length;
	}
	return out;
}

// -- meaning -----------------------------------------------------------------

function has(tokens: string[], key: string): boolean {
	const k = key.toLowerCase();
	if (k.endsWith('*')) return tokens.some((t) => t.startsWith(k.slice(0, -1)));
	return tokens.includes(k);
}

export function matchIntent(intents: Intent[], tokens: string[], flags: string[]): Intent | undefined {
	const low = tokens.filter((t) => !isEnd(t)).map((t) => (t === NAME_TILE ? NAME_TILE : t.toLowerCase()));
	return intents.find(({ when }) => {
		if (when.flag && !flags.includes(when.flag)) return false;
		if (when.noFlag && flags.includes(when.noFlag)) return false;
		if (when.all && !when.all.every((k) => has(low, k))) return false;
		if (when.any && !when.any.some((k) => has(low, k))) return false;
		if (when.none && when.none.some((k) => has(low, k))) return false;
		return true;
	});
}

// -- the chat ----------------------------------------------------------------

export const START_INTEREST = 5;
export const MAX_INTEREST = 10;
export const WIN_AT = 7;
export const PARTIAL_AT = 4;
/** Below this the character cannot follow the sentence at all. */
export const UNDERSTOOD_AT = 60;

export type Ending = 'win' | 'secret' | 'partial' | 'deleted';

export interface SentLog {
	turn: string;
	tokens: string[];
}

export interface TurnResult {
	turn: string;
	tokens: string[];
	grade: Grade;
	intent: Intent | null;
	/** 'ok' | 'offTopic' | 'confused' */
	heard: 'ok' | 'offTopic' | 'confused';
	delta: number;
	interestAfter: number;
	/** Helga's answer, in order: the recast quote is drawn separately from `grade.fixed`. */
	reply: ChatMessage[];
	photo?: string;
	recast: boolean;
}

export interface ChatState {
	interest: number;
	flags: string[];
	facts: string[];
	results: TurnResult[];
	/** The turn waiting for an answer, or null when the chat is over. */
	current: Turn | null;
	ending: Ending | null;
	/** Why it was deleted: a cause key of endings.deleted. */
	cause: string | null;
	average: number;
}

export function turnById(chat: MatchChat, id: string): Turn | undefined {
	return chat.turns.find((t) => t.id === id);
}

function nextTurn(chat: MatchChat, turn: Turn, intent: Intent | null): Turn | null {
	const id = intent?.next ?? turn.next;
	if (id) return turnById(chat, id) ?? null;
	const i = chat.turns.indexOf(turn);
	return chat.turns[i + 1] ?? null;
}

/** Plays one sent sentence against the state. Pure. */
export function playTurn(chat: MatchChat, state: ChatState, tokens: string[], name = ''): ChatState {
	const turn = state.current;
	if (!turn || state.ending) return state;
	const grade = gradeSentence(tokens, chat.lexicon, turn.wrong, name, turn.prepCase);
	let intent: Intent | null = null;
	let heard: TurnResult['heard'] = 'ok';
	let delta: number;
	let reply: ChatMessage[];
	const flags = [...state.flags];
	const facts = [...state.facts];

	if (grade.score < UNDERSTOOD_AT) {
		heard = 'confused';
		delta = -1;
		reply = chat.confused;
	} else {
		intent = matchIntent(turn.intents, tokens, flags) ?? null;
		if (!intent) {
			heard = 'offTopic';
			delta = -1;
			reply = [chat.offTopic];
		} else {
			const bonus = intent.value >= 0 && !intent.noBonus && grade.score === 100 ? 1 : 0;
			delta = intent.value + bonus;
			reply = intent.reply;
			for (const f of intent.flags ?? []) if (!flags.includes(f)) flags.push(f);
			const low = tokens.map((t) => t.toLowerCase());
			for (const [k, f] of Object.entries(intent.flagsIf ?? {}))
				if (has(low, k) && !flags.includes(f)) flags.push(f);
			if (intent.fact && !facts.includes(intent.fact)) facts.push(intent.fact);
		}
	}

	const interest = Math.max(0, Math.min(MAX_INTEREST, state.interest + delta));
	const result: TurnResult = {
		turn: turn.id,
		tokens,
		grade,
		intent,
		heard,
		delta,
		interestAfter: interest,
		reply,
		photo: intent?.photo,
		recast: heard !== 'confused' && grade.score < 100
	};
	const results = [...state.results, result];
	const average = Math.round(results.reduce((s, r) => s + r.grade.score, 0) / results.length);
	const base = { interest, flags, facts, results, average };

	if (interest <= 0) {
		return { ...base, current: null, ending: 'deleted', cause: causeOf(results, intent) };
	}
	const next = heard === 'confused' ? nextTurn(chat, turn, null) : nextTurn(chat, turn, intent);
	if (next) return { ...base, current: next, ending: null, cause: null };

	let ending: Ending;
	if (interest >= WIN_AT) ending = flags.includes(chat.secretFlag ?? 'secret') ? 'secret' : 'win';
	else if (interest >= PARTIAL_AT) ending = 'partial';
	else ending = 'deleted';
	return { ...base, current: null, ending, cause: ending === 'deleted' ? causeOf(results, null) : null };
}

/** The cause that sank the chat: the final blow if it had one, else the worst turn's. */
function causeOf(results: TurnResult[], lastIntent: Intent | null): string {
	if (lastIntent?.cause) return lastIntent.cause;
	if (results.filter((r) => r.heard === 'confused').length >= 3) return 'confused';
	const worst = [...results].filter((r) => r.intent?.cause).sort((a, b) => a.delta - b.delta)[0];
	return worst?.intent?.cause ?? 'default';
}

export function startState(chat: MatchChat): ChatState {
	return {
		interest: START_INTEREST,
		flags: [],
		facts: [],
		results: [],
		current: chat.turns[0],
		ending: null,
		cause: null,
		average: 0
	};
}

/** Rebuilds a chat from its saved log. */
export function replay(chat: MatchChat, log: SentLog[], name = ''): ChatState {
	let state = startState(chat);
	for (const sent of log) {
		if (!state.current || state.current.id !== sent.turn) break;
		state = playTurn(chat, state, sent.tokens, name);
	}
	return state;
}

/** The contact card's lines. */
export function contactFacts(state: ChatState): string[] {
	const facts = [...state.facts];
	if (state.average >= 90) facts.push('⭐ spricht super Deutsch');
	return facts;
}

/** {name} → the learner's name. */
export function personalise(text: string | undefined, name: string): string {
	return (text ?? '').replaceAll('{name}', name);
}

/** "ich kommt → ich komme", the corrections worth banking in the fix log. */
export function wordFixes(results: TurnResult[]): Array<{ said: string; correct: string }> {
	return results
		.filter((r) => r.heard !== 'confused')
		.flatMap((r) =>
			r.grade.corrections.filter((c) => c.from).length
				? [{ said: r.grade.text, correct: r.grade.fixed }]
				: []
		);
}

// -- saving ------------------------------------------------------------------

export interface SavedChat {
	name: string;
	log: SentLog[];
	startedAt: number;
	endedAt?: number;
	ending?: Ending;
	/** Voice-note plays spent, by clip id: a voice note plays twice at most. */
	plays?: Record<string, number>;
}

const SAVE_PREFIX = 'match_chat_';
const NAME_KEY = 'match_name';

export function loadChat(id: string): SavedChat | null {
	try {
		const raw = localStorage.getItem(SAVE_PREFIX + id);
		return raw ? (JSON.parse(raw) as SavedChat) : null;
	} catch {
		return null;
	}
}

export function saveChat(id: string, saved: SavedChat): void {
	try {
		localStorage.setItem(SAVE_PREFIX + id, JSON.stringify(saved));
	} catch {
		/* no storage: the chat still plays, it just won't survive a reload */
	}
}

export function clearChat(id: string): void {
	try {
		localStorage.removeItem(SAVE_PREFIX + id);
	} catch {
		/* nothing to clear */
	}
}

export function loadName(): string {
	try {
		return localStorage.getItem(NAME_KEY) ?? '';
	} catch {
		return '';
	}
}

export function saveName(name: string): void {
	try {
		localStorage.setItem(NAME_KEY, name);
	} catch {
		/* the name lives for this visit only */
	}
}

/** A name that fits on one tile: letters (any script), a hyphen, at most 14. */
export function cleanName(input: string): string {
	return input
		.replace(/[^\p{L}\- ]/gu, '')
		.trim()
		.split(/\s+/)[0]
		?.slice(0, 14) ?? '';
}

export interface Contact {
	chat: MatchChat;
	saved: SavedChat;
	state: ChatState;
}

/** Everyone who liked the learner back, newest first. */
export function contacts(): Contact[] {
	return MATCH_CHATS.flatMap((chat) => {
		const saved = loadChat(chat.id);
		if (!saved?.ending || (saved.ending !== 'win' && saved.ending !== 'secret')) return [];
		return [{ chat, saved, state: replay(chat, saved.log, saved.name) }];
	}).sort((a, b) => (b.saved.endedAt ?? 0) - (a.saved.endedAt ?? 0));
}

/** The first Sunday 14:05 after `from`: when a won contact sends their follow-up. */
export function sundayAfter(from: number): number {
	const d = new Date(from);
	const target = new Date(d);
	target.setHours(14, 5, 0, 0);
	const days = (7 - d.getDay()) % 7;
	target.setDate(d.getDate() + days);
	if (target.getTime() <= from) target.setDate(target.getDate() + 7);
	return target.getTime();
}

// -- the feed ----------------------------------------------------------------

export type FeedItem =
	| { key: string; kind: 'in'; msg: ChatMessage }
	| { key: string; kind: 'out'; result: TurnResult }
	| { key: string; kind: 'outPhoto'; image: string }
	| { key: string; kind: 'recast'; result: TurnResult }
	| { key: string; kind: 'system'; text: string };

/**
 * Everything on screen, in order, rebuilt from the state: the opening lines,
 * then per turn the question, the learner's sentence (and photo), the recast
 * when it needed one, the answer; then the waiting question or the ending.
 */
export function buildFeed(chat: MatchChat, state: ChatState): FeedItem[] {
	const feed: FeedItem[] = chat.intro.map((msg, i) => ({ key: `intro-${i}`, kind: 'in', msg }));
	const asked = (turn: Turn, n: number) =>
		turn.before.forEach((msg, i) => feed.push({ key: `t${n}-b${i}`, kind: 'in', msg }));
	state.results.forEach((r, n) => {
		asked(turnById(chat, r.turn)!, n);
		feed.push({ key: `t${n}-out`, kind: 'out', result: r });
		if (r.photo) feed.push({ key: `t${n}-photo`, kind: 'outPhoto', image: r.photo });
		if (r.recast && r.grade.fixed !== r.grade.text) feed.push({ key: `t${n}-recast`, kind: 'recast', result: r });
		r.reply.forEach((msg, i) => feed.push({ key: `t${n}-r${i}`, kind: 'in', msg }));
	});
	if (state.current) asked(state.current, state.results.length);
	if (state.ending === 'deleted') {
		const last = chat.endings.deleted[state.cause ?? 'default'] ?? chat.endings.deleted.default;
		feed.push({ key: 'end-0', kind: 'in', msg: last });
		feed.push({ key: 'end-sys', kind: 'system', text: `${chat.name} hat das Match gelöscht.` });
	} else if (state.ending) {
		chat.endings[state.ending].forEach((msg, i) => feed.push({ key: `end-${i}`, kind: 'in', msg }));
	}
	return feed;
}

/** The words of `fixed` that differ from `text`, for highlighting the recast. */
export function changedWords(text: string, fixed: string): Array<{ word: string; changed: boolean }> {
	const a = text.split(' ');
	const b = fixed.split(' ');
	return b.map((word, i) => ({ word, changed: a.length === b.length && a[i] !== word }));
}

/** What went wrong, for the ending card: each turn that cost interest, in the character's words. */
export function lowPoints(state: ChatState): Array<{ said: string; why: string }> {
	return state.results
		.filter((r) => r.delta < 0)
		.map((r) => ({
			said: r.grade.text,
			why:
				r.heard === 'confused'
					? "The sentence was too broken to follow."
					: r.heard === 'offTopic'
						? "That didn't answer the question."
						: (r.reply[0]?.en ?? '')
		}));
}

// -- the course deck ------------------------------------------------------------

export const CHAT_CARD_PREFIX = 'chat:';

export interface ChatDeal {
	chat: MatchChat;
	/** Already started: the card comes back in every hand until the chat ends. */
	resume: boolean;
}

/** Characters on offer: not hidden, or unlocked by another chat's secret ending. */
export function availableChats(saved: (id: string) => SavedChat | null = loadChat): MatchChat[] {
	const unlocked = new Set(
		MATCH_CHATS.filter((c) => c.unlocks && saved(c.id)?.ending === 'secret').map((c) => c.unlocks!.id)
	);
	return MATCH_CHATS.filter((c) => !c.hidden || unlocked.has(c.id));
}

/**
 * The character the course deck would deal, if any. A chat in progress comes
 * first: started is enough, even if the learner left before the first answer.
 * Otherwise the next unplayed character at the learner's module, or the
 * nearest one around it. Whether the hand gets a surprise at all, and which
 * kind, is decided by domain/surprise; skipped cards sit out like any other.
 */
export function chatDeckCard(
	level: string | null,
	skipped: Set<string>,
	saved: (id: string) => SavedChat | null = loadChat
): ChatDeal | null {
	const chats = availableChats(saved).filter((c) => !skipped.has(CHAT_CARD_PREFIX + c.id));
	const live = chats.find((c) => {
		const s = saved(c.id);
		return s && !s.ending;
	});
	if (live) return { chat: live, resume: true };
	const fresh = chats.filter((c) => !saved(c.id));
	if (!fresh.length) return null;
	const target = level ? levelRank(level) : 0;
	// Nearest module first, the easier side winning a tie.
	const pick = [...fresh].sort(
		(a, b) =>
			Math.abs(levelRank(a.level) - target) - Math.abs(levelRank(b.level) - target) ||
			levelRank(a.level) - levelRank(b.level)
	)[0];
	return { chat: pick, resume: false };
}
