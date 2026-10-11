// "Ja oder Nein?" — the deck's surprise: a round of ten yes-or-no questions
// about life in Germany, swiped left or right against a psychedelic sky. No
// score, no medals, nothing to get wrong: the point is to read ten short
// German questions without noticing, laugh, and get a result worth sending
// to someone. Every Ja and every Nein feeds one of five vibes, the strongest
// vibe is who you are tonight, and the share text is a Wordle-style row of
// squares with that name on it.

export type Vibe = 'nacht' | 'ordnung' | 'gemuetlich' | 'wild' | 'natur';

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

/** A this-or-that question, in one line of authoring. */
function pair(left: [string, string, Vibe], right: [string, string, Vibe]): JaNeinQuestion {
	return {
		de: `${left[0]} oder ${right[0]}?`,
		en: `${left[1]} or ${right[1]}?`,
		nein: left[2],
		ja: right[2],
		left: { de: left[0], en: left[1] },
		right: { de: right[0], en: right[1] }
	};
}

export interface Persona {
	vibe: Vibe;
	/** The name, gender-neutral German. */
	title: string;
	emoji: string;
	/** One line about this person, in English. */
	line: string;
	/** The German word to take away, and what it means. */
	word: { de: string; en: string };
}

export const PERSONAS: Record<Vibe, Persona> = {
	nacht: {
		vibe: 'nacht',
		title: 'Nachtbus-Legende',
		emoji: '🚌🌙',
		line: 'You have seen the city at 4 a.m. more often than at 9 a.m., and you regret nothing.',
		word: { de: 'der Nachtbus', en: 'the night bus' }
	},
	ordnung: {
		vibe: 'ordnung',
		title: 'Ordnungsamt in Person',
		emoji: '📋🧹',
		line: 'Seven bins, slippers for guests, five minutes early. Germany is lucky to have you.',
		word: { de: 'die Ordnung', en: 'order, tidiness' }
	},
	gemuetlich: {
		vibe: 'gemuetlich',
		title: 'Gemütlichkeits-Guru',
		emoji: '🛋️☕',
		line: 'Socks, tea, cake at three, Tatort at eight. Nobody does a Sunday like you.',
		word: { de: 'gemütlich', en: 'cosy, snug' }
	},
	wild: {
		vibe: 'wild',
		title: 'Späti-Royalty',
		emoji: '🍻✨',
		line: 'Your kingdom is open all night and sells Club-Mate. Döner at four is a food group.',
		word: { de: 'der Späti', en: 'the late-night corner shop' }
	},
	natur: {
		vibe: 'natur',
		title: 'Waldbaden-Profi',
		emoji: '🌲🧘',
		line: 'Barefoot in the park, a Brotzeit in the bag, phone on flight mode. The lake is never too cold.',
		word: { de: 'das Waldbaden', en: 'forest bathing' }
	}
};

/** The bank. Each question is a real little slice of Germany, and a yes or a no both say something. */
export const JA_NEIN_QUESTIONS: JaNeinQuestion[] = [
	{ de: 'Döner um vier Uhr morgens?', en: 'Döner at four in the morning?', ja: 'wild', nein: 'gemuetlich' },
	{ de: 'Sonntag im Schlafanzug bis 16 Uhr?', en: 'Sunday in pyjamas until 4 p.m.?', ja: 'gemuetlich', nein: 'ordnung' },
	{ de: 'Pfandflaschen selbst zurückbringen?', en: 'Take your deposit bottles back yourself?', ja: 'ordnung', nein: 'wild' },
	{ de: 'Barfuß im Park?', en: 'Barefoot in the park?', ja: 'natur', nein: 'ordnung' },
	{ de: 'Club-Mate zum Frühstück?', en: 'Club-Mate for breakfast?', ja: 'wild', nein: 'gemuetlich' },
	{ de: 'Tatort am Sonntagabend?', en: 'The Sunday-night crime show, every week?', ja: 'gemuetlich', nein: 'nacht' },
	{ de: 'Letzte U-Bahn verpasst – egal?', en: 'Missed the last U-Bahn. Who cares?', ja: 'nacht', nein: 'ordnung' },
	{ de: 'Mülltrennung mit sieben Tonnen?', en: 'Sorting your rubbish into seven bins?', ja: 'ordnung', nein: 'wild' },
	{ de: 'Ein Bier ist ein Essen?', en: 'A beer counts as a meal?', ja: 'wild', nein: 'gemuetlich' },
	{ de: 'Bei Rot über die Ampel, wenn keiner guckt?', en: 'Cross on red when nobody is looking?', ja: 'nacht', nein: 'ordnung' },
	{ de: 'Spaziergang ohne Ziel?', en: 'A walk with no destination?', ja: 'natur', nein: 'nacht' },
	{ de: 'Kuchen um 15 Uhr ist Pflicht?', en: 'Cake at 3 p.m. is compulsory?', ja: 'gemuetlich', nein: 'wild' },
	{ de: 'Nackt in die Sauna?', en: 'Naked in the sauna?', ja: 'natur', nein: 'ordnung' },
	{ de: 'Brotzeit im Wald?', en: 'A picnic of bread and cheese in the forest?', ja: 'natur', nein: 'nacht' },
	{ de: 'Techno bis zum Sonnenaufgang?', en: 'Techno until sunrise?', ja: 'nacht', nein: 'gemuetlich' },
	{ de: 'Hausschuhe für Gäste?', en: 'Slippers for your guests?', ja: 'ordnung', nein: 'wild' },
	{ de: 'Der Späti ist dein Supermarkt?', en: 'The late-night corner shop is your supermarket?', ja: 'wild', nein: 'ordnung' },
	{ de: 'Fenster auf, auch im Winter?', en: 'Window open to air the room, even in winter?', ja: 'ordnung', nein: 'gemuetlich' },
	{ de: 'Kaffee nach 20 Uhr?', en: 'Coffee after 8 p.m.?', ja: 'nacht', nein: 'gemuetlich' },
	{ de: 'Pilze im Wald selbst sammeln?', en: 'Pick your own mushrooms in the forest?', ja: 'natur', nein: 'ordnung' },
	{ de: 'Pommes mit Mayo UND Ketchup?', en: 'Chips with mayo AND ketchup?', ja: 'wild', nein: 'ordnung' },
	{ de: 'Decke, Tee, Regen – perfekter Tag?', en: 'Blanket, tea, rain. A perfect day?', ja: 'gemuetlich', nein: 'nacht' },
	{ de: 'Nachbarn beim Umzug helfen?', en: 'Help the neighbours move house?', ja: 'ordnung', nein: 'wild' },
	{ de: 'Schwimmen im See, auch im Oktober?', en: 'Swimming in the lake, even in October?', ja: 'natur', nein: 'gemuetlich' },
	{ de: 'Pünktlich heißt fünf Minuten früher?', en: 'Punctual means five minutes early?', ja: 'ordnung', nein: 'nacht' },
	{ de: 'Nachtbus statt Taxi?', en: 'Night bus instead of a taxi?', ja: 'nacht', nein: 'wild' },
	{ de: 'Currywurst ist Kultur?', en: 'Currywurst is culture?', ja: 'wild', nein: 'natur' },
	{ de: 'Kerzen an, Handy aus?', en: 'Candles on, phone off?', ja: 'gemuetlich', nein: 'nacht' },
	{ de: 'Fahrrad bei Schnee?', en: 'Cycling in the snow?', ja: 'natur', nein: 'gemuetlich' },
	{ de: 'Sekt am Montag?', en: 'Sparkling wine on a Monday?', ja: 'wild', nein: 'ordnung' },
	{ de: 'Küche aufräumen vor dem Schlafen?', en: 'Tidy the kitchen before bed?', ja: 'ordnung', nein: 'nacht' },
	{ de: 'Sterne gucken um drei Uhr nachts?', en: 'Stargazing at three in the morning?', ja: 'nacht', nein: 'gemuetlich' },
	{ de: 'Schnitzel größer als der Teller?', en: 'A schnitzel bigger than the plate?', ja: 'wild', nein: 'natur' },
	{ de: 'Socken in Sandalen?', en: 'Socks in sandals?', ja: 'natur', nein: 'wild' },
	{ de: 'Ein Jahr ohne Auto?', en: 'A year without a car?', ja: 'natur', nein: 'ordnung' },
	{ de: 'Frühstück um 11 Uhr ist noch Frühstück?', en: 'Breakfast at 11 is still breakfast?', ja: 'gemuetlich', nein: 'ordnung' },
	{ de: 'Bargeld ist König?', en: 'Cash is king?', ja: 'ordnung', nein: 'wild' },
	{ de: 'Sonntags ist der Rasenmäher verboten?', en: 'No lawnmower on a Sunday, ever?', ja: 'ordnung', nein: 'wild' },
	{ de: 'Döner mit allem und scharf?', en: 'Döner with everything, and spicy?', ja: 'wild', nein: 'gemuetlich' },
	{ de: 'Freibad am ersten warmen Tag?', en: 'The outdoor pool on the first warm day?', ja: 'natur', nein: 'gemuetlich' },
	{ de: 'Abendbrot: nur Brot und Käse?', en: 'Dinner is just bread and cheese?', ja: 'gemuetlich', nein: 'wild' },
	{ de: 'Spätzle sind besser als Pasta?', en: 'Spätzle beat pasta?', ja: 'gemuetlich', nein: 'wild' },
	{ de: 'Flaschenbier auf der Parkbank?', en: 'A bottle of beer on a park bench?', ja: 'wild', nein: 'ordnung' },
	{ de: 'Jeden Tag Wetter-App checken?', en: 'Check the weather app every day?', ja: 'ordnung', nein: 'natur' },
	{ de: 'Kleingarten mit Gartenzwerg?', en: 'An allotment with a garden gnome?', ja: 'gemuetlich', nein: 'nacht' },
	{ de: 'Fahrkarte immer kaufen, auch für eine Station?', en: 'Always buy a ticket, even for one stop?', ja: 'ordnung', nein: 'nacht' },
	{ de: 'Glühwein schon im November?', en: 'Mulled wine already in November?', ja: 'gemuetlich', nein: 'ordnung' },
	{ de: 'Wandern mit Stöcken?', en: 'Hiking with poles?', ja: 'natur', nein: 'wild' },
	{ de: 'Nach dem Club direkt zum Bäcker?', en: 'Straight from the club to the bakery?', ja: 'nacht', nein: 'gemuetlich' },
	{ de: 'Mettbrötchen zum Frühstück?', en: 'Raw minced pork on a roll for breakfast?', ja: 'wild', nein: 'natur' },
	{ de: 'Haustür zu, Welt aus?', en: 'Front door shut, world off?', ja: 'gemuetlich', nein: 'nacht' },
	{ de: 'Die Schuhe bleiben an der Tür?', en: 'Shoes off at the door, always?', ja: 'ordnung', nein: 'wild' },
	{ de: 'Kaltes Wasser im See ist gesund?', en: 'Cold lake water is good for you?', ja: 'natur', nein: 'gemuetlich' },
	{ de: 'Die U-Bahn nachts allein ist kein Problem?', en: 'The U-Bahn alone at night is no problem?', ja: 'nacht', nein: 'ordnung' },
	{ de: 'Karneval, Oktoberfest, Weihnachtsmarkt – alle?', en: 'Carnival, Oktoberfest, Christmas market: all three?', ja: 'wild', nein: 'gemuetlich' },
	{ de: 'Wohnung ohne Fernseher?', en: 'A flat with no TV?', ja: 'natur', nein: 'gemuetlich' },
	{ de: 'Um 22 Uhr ist Nachtruhe, Punkt?', en: 'Quiet hours at 10 p.m., full stop?', ja: 'ordnung', nein: 'nacht' },
	{ de: 'Brot muss eine Kruste haben?', en: 'Bread must have a crust?', ja: 'gemuetlich', nein: 'wild' },
	{ de: 'Zum See mit dem Rad, 30 Kilometer?', en: 'To the lake by bike, 30 kilometres?', ja: 'natur', nein: 'nacht' },
	{ de: 'Flunkyball ist ein Sport?', en: 'Flunkyball is a sport?', ja: 'wild', nein: 'ordnung' },
	{ de: 'Sonnenaufgang vom Dach aus?', en: 'Sunrise from the rooftop?', ja: 'nacht', nein: 'gemuetlich' },
	{ de: 'Kehrwoche ist Ehrensache?', en: 'Sweeping the shared stairwell is a matter of honour?', ja: 'ordnung', nein: 'wild' },
	{ de: 'Picknick im Regen, egal?', en: 'A picnic in the rain, who cares?', ja: 'natur', nein: 'ordnung' },
	{ de: 'Letzte Runde ist nie die letzte?', en: 'The last round is never the last?', ja: 'nacht', nein: 'gemuetlich' },
	{ de: 'Ein Nickerchen nach dem Mittagessen?', en: 'A nap after lunch?', ja: 'gemuetlich', nein: 'natur' },
	{ de: 'Spontan nach Polen zum Tanken?', en: 'A spontaneous trip to Poland to fill up?', ja: 'wild', nein: 'ordnung' },
	// This or that: a swipe left takes the first, a swipe right the second.
	pair(['Oktoberfest', 'Oktoberfest', 'wild'], ['Weihnachtsmarkt', 'Christmas market', 'gemuetlich']),
	pair(['Döner', 'Döner', 'nacht'], ['Currywurst', 'Currywurst', 'wild']),
	pair(['Bier', 'beer', 'wild'], ['Wein', 'wine', 'gemuetlich']),
	pair(['Kaffee', 'coffee', 'nacht'], ['Tee', 'tea', 'gemuetlich']),
	pair(['U-Bahn', 'U-Bahn', 'nacht'], ['Fahrrad', 'bike', 'natur']),
	pair(['Brezel', 'pretzel', 'wild'], ['Brötchen', 'bread roll', 'ordnung']),
	pair(['Berlin', 'Berlin', 'wild'], ['München', 'Munich', 'ordnung']),
	pair(['Techno', 'techno', 'nacht'], ['Schlager', 'German pop hits', 'gemuetlich']),
	pair(['Sauna', 'sauna', 'gemuetlich'], ['See', 'lake', 'natur']),
	pair(['Späti', 'late-night shop', 'wild'], ['Supermarkt', 'supermarket', 'ordnung']),
	pair(['Kuchen', 'cake', 'gemuetlich'], ['Brot', 'bread', 'ordnung']),
	pair(['Sommer', 'summer', 'natur'], ['Winter', 'winter', 'gemuetlich']),
	pair(['Hund', 'dog', 'natur'], ['Katze', 'cat', 'gemuetlich']),
	pair(['Bahn', 'train', 'ordnung'], ['Auto', 'car', 'wild']),
	pair(['Früh aufstehen', 'up early', 'ordnung'], ['Lange schlafen', 'sleep in', 'nacht']),
	pair(['Pommes rot', 'chips with ketchup', 'wild'], ['Pommes weiß', 'chips with mayo', 'gemuetlich']),
	pair(['Club', 'club', 'nacht'], ['Kneipe', 'pub', 'gemuetlich']),
	pair(['Schwarzwald', 'Black Forest', 'natur'], ['Ostsee', 'Baltic coast', 'gemuetlich']),
	pair(['Sprudel', 'sparkling water', 'ordnung'], ['Stilles Wasser', 'still water', 'natur']),
	pair(['Wandern', 'hiking', 'natur'], ['Joggen', 'jogging', 'ordnung']),
	pair(['Käsespätzle', 'cheese Spätzle', 'gemuetlich'], ['Schnitzel', 'schnitzel', 'wild']),
	pair(['Balkon', 'balcony', 'gemuetlich'], ['Park', 'park', 'natur']),
	pair(['Tatort', 'the Sunday crime show', 'gemuetlich'], ['Netflix', 'Netflix', 'nacht']),
	pair(['Bargeld', 'cash', 'ordnung'], ['Karte', 'card', 'wild']),
	pair(['Camping', 'camping', 'natur'], ['Hotel', 'hotel', 'ordnung']),
	pair(['Mate', 'Club-Mate', 'nacht'], ['Spezi', 'cola-orange Spezi', 'gemuetlich']),
	pair(['Stadion', 'football in the stadium', 'wild'], ['Biergarten', 'football in the beer garden', 'gemuetlich']),
	pair(['Böller', 'fireworks at New Year', 'wild'], ['Raclette', 'raclette at New Year', 'gemuetlich']),
	pair(['Flohmarkt', 'flea market', 'wild'], ['IKEA', 'IKEA', 'ordnung']),
	pair(['Baggersee', 'quarry lake', 'natur'], ['Freibad', 'outdoor pool', 'ordnung']),
	pair(['Alpen', 'the Alps', 'natur'], ['Nordsee', 'North Sea', 'wild']),
	pair(['Glühwein', 'mulled wine', 'gemuetlich'], ['Eierpunsch', 'egg punch', 'wild']),
	pair(['Kreuzberg', 'Kreuzberg', 'nacht'], ['Prenzlauer Berg', 'Prenzlauer Berg', 'ordnung']),
	pair(['Nachtbus', 'night bus', 'nacht'], ['Zu Fuß', 'on foot', 'natur']),
	pair(['Mittagsschlaf', 'afternoon nap', 'gemuetlich'], ['Spaziergang', 'lunchtime walk', 'natur'])
];

export const ROUND_LENGTH = 10;

const SEEN_KEY = 'janein_seen';

/** The questions this device has already been asked, by their German text. */
export function seenJaNein(): Set<string> {
	try {
		return new Set(JSON.parse(localStorage.getItem(SEEN_KEY) ?? '[]'));
	} catch {
		return new Set();
	}
}

/** Remember a round's questions, so the next round asks others. */
export function markSeenJaNein(questions: JaNeinQuestion[], seen: Set<string> = seenJaNein()): Set<string> {
	const next = new Set(seen);
	for (const q of questions) next.add(q.de);
	// The whole bank asked: start over, so the next round is fresh again.
	if (JA_NEIN_QUESTIONS.every((q) => next.has(q.de))) next.clear();
	try {
		localStorage.setItem(SEEN_KEY, JSON.stringify([...next]));
	} catch {
		/* no storage: rounds may repeat */
	}
	return next;
}

/**
 * Ten questions, shuffled, from the ones not yet asked on this device; only
 * when fewer than ten are left do already-asked ones fill the round, and
 * the bank then starts over (see markSeenJaNein).
 */
export function dealJaNein(
	random: () => number = Math.random,
	length = ROUND_LENGTH,
	seen: Set<string> = seenJaNein(),
	/** A question to deal first whatever the seen list says (the dev page's "play this one"). */
	first?: JaNeinQuestion
): JaNeinQuestion[] {
	const draw = (from: JaNeinQuestion[], n: number) => {
		const pool = [...from];
		const out: JaNeinQuestion[] = [];
		while (out.length < n && pool.length) out.push(pool.splice(Math.floor(random() * pool.length), 1)[0]);
		return out;
	};
	const rest = JA_NEIN_QUESTIONS.filter((q) => q !== first);
	const out = first ? [first] : [];
	out.push(...draw(rest.filter((q) => !seen.has(q.de)), length - out.length));
	if (out.length < length) out.push(...draw(rest.filter((q) => seen.has(q.de)), length - out.length));
	return out;
}

export type Answer = 'ja' | 'nein';

export interface JaNeinResult {
	persona: Persona;
	questions: JaNeinQuestion[];
	/** Each vibe's count, so the result can show the runner-up. */
	tally: Record<Vibe, number>;
	runnerUp: Persona | null;
	ja: number;
	nein: number;
	answers: Answer[];
}

const VIBES: Vibe[] = ['nacht', 'ordnung', 'gemuetlich', 'wild', 'natur'];

/** Who you are tonight: the vibe your answers fed most; ties go to the vibe you fed first. */
export function scoreJaNein(questions: JaNeinQuestion[], answers: Answer[]): JaNeinResult {
	const tally = Object.fromEntries(VIBES.map((v) => [v, 0])) as Record<Vibe, number>;
	const firstFed: Partial<Record<Vibe, number>> = {};
	answers.forEach((answer, i) => {
		const q = questions[i];
		if (!q) return;
		const vibe = q[answer];
		tally[vibe] += 1;
		firstFed[vibe] ??= i;
	});
	const ranked = [...VIBES].sort(
		(a, b) => tally[b] - tally[a] || (firstFed[a] ?? Infinity) - (firstFed[b] ?? Infinity)
	);
	const top = ranked[0];
	const second = ranked[1];
	return {
		persona: PERSONAS[top],
		questions,
		tally,
		runnerUp: tally[second] > 0 ? PERSONAS[second] : null,
		ja: answers.filter((a) => a === 'ja').length,
		nein: answers.filter((a) => a === 'nein').length,
		answers
	};
}

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
export function shareText(result: JaNeinResult, url: string, lang: ShareLang = 'de'): string {
	const lines = result.answers.map((a, i) => (result.questions[i] ? shareLine(result.questions[i], a, lang) : ''));
	const head =
		lang === 'de'
			? `Ja oder Nein? 🇩🇪 Heute bin ich ${result.persona.title} ${result.persona.emoji}`
			: `Ja oder Nein? 🇩🇪 Tonight I'm ${result.persona.title} ${result.persona.emoji}`;
	return [head, ...lines, url].join('\n');
}

export function whatsappHref(text: string): string {
	return `https://wa.me/?text=${encodeURIComponent(text)}`;
}

// -- the deck ---------------------------------------------------------------

export const JA_NEIN_CARD_ID = 'play:ja-nein';
const LAST_KEY = 'janein_last';
const FIRST_KEY = 'janein_first_deal';
/**
 * The welcome window: for the first minutes after the deck is first dealt
 * the card is a sure thing, so a newcomer meets the fun side of the app
 * before the grammar. After that it is a rare treat.
 */
export const WELCOME_MINUTES = 5;
/** How long a round (or a swipe-away) keeps the card out of the deck. */
export const QUIET_HOURS = 48;
/** The chance the card joins a deal after the welcome window: a surprise, not a fixture. */
export const DEAL_CHANCE = 0.15;

/** When the deck was first dealt on this device; set on the first deal. */
export function firstDealAt(now = Date.now()): number {
	try {
		const raw = Number(localStorage.getItem(FIRST_KEY));
		if (raw) return raw;
		localStorage.setItem(FIRST_KEY, String(now));
	} catch {
		/* no storage: every visit is a first visit */
	}
	return now;
}

export function lastPlayedJaNein(): number | null {
	try {
		const raw = localStorage.getItem(LAST_KEY);
		return raw ? Number(raw) || null : null;
	} catch {
		return null;
	}
}

export function markJaNeinPlayed(now = Date.now()): void {
	try {
		localStorage.setItem(LAST_KEY, String(now));
	} catch {
		/* storage unavailable: the card just comes round again */
	}
}

/**
 * Whether this deal gets the card, and where. In the welcome window, and not
 * yet played: always, right under the top card. Later: null unless the last
 * round is long enough ago and the coin says yes, then a slot from the
 * second to the fifth card.
 */
export function jaNeinDealSlot(
	skipped: Set<string>,
	random: () => number = Math.random,
	lastPlayed: number | null = lastPlayedJaNein(),
	now = Date.now(),
	firstDeal: number = firstDealAt(now)
): number | null {
	if (skipped.has(JA_NEIN_CARD_ID)) return null;
	if (lastPlayed !== null && now - lastPlayed < QUIET_HOURS * 60 * 60 * 1000) return null;
	if (lastPlayed === null && now - firstDeal < WELCOME_MINUTES * 60 * 1000) return 1;
	if (random() >= DEAL_CHANCE) return null;
	return 1 + Math.floor(random() * 4);
}
