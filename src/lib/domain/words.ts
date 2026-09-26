// The shared noun and verb collections as the word pages read them: the
// entry shapes, the URL slug for a word, and the plural spelt out from the
// dictionary notation the collection stores.

import { GENDER_ARTICLES } from './gender';

/** One entry in assets/content/shared/nouns/de.json. */
export interface SharedNounEntry {
	noun: string;
	gender: string;
	english: string;
	categories: string[];
	difficulty?: string;
	/** True when the singular keeps its form in every case but the genitive. */
	declensionSafe?: boolean;
	/** Dictionary notation ("¨-e", "-en", "—" for none) or the full plural. */
	plural?: string;
	/** An example with `____` where the article goes. */
	sentence?: string;
	meanings?: Record<string, string>;
}

export interface VerbForm {
	person: string;
	form: string;
}

export interface VerbSet {
	label: string;
	forms: VerbForm[];
}

/** One entry in assets/content/shared/verbs/de.json. */
export interface SharedVerbEntry {
	verb: string;
	english: string;
	meanings?: Record<string, string>;
	sets: VerbSet[];
}

/** "Käse" → "kaese", "Straße" → "strasse": ASCII, lower-case, URL-safe. */
export function wordSlug(word: string): string {
	return word
		.toLowerCase()
		.replace(/ä/g, 'ae')
		.replace(/ö/g, 'oe')
		.replace(/ü/g, 'ue')
		.replace(/ß/g, 'ss')
		.replace(/[^a-z0-9]+/g, '-')
		.replace(/^-|-$/g, '');
}

/** The last a, o, u or au in a stem takes the umlaut: Topf → Töpf, Apfel → Äpfel, Haus → Häus. */
function umlaut(stem: string): string {
	const map: Record<string, string> = { a: 'ä', o: 'ö', u: 'ü', A: 'Ä', O: 'Ö', U: 'Ü' };
	let at = -1;
	for (let i = 0; i < stem.length; i++) if (map[stem[i]]) at = i;
	if (at < 0) return stem;
	// "au" is one sound: Haus → Häuser, not Haüser.
	if (stem[at].toLowerCase() === 'u' && stem[at - 1]?.toLowerCase() === 'a') at -= 1;
	return stem.slice(0, at) + map[stem[at]] + stem.slice(at + 1);
}

/**
 * The plural form from the collection's notation: "-e" appends, "¨-e" umlauts
 * and appends, "-" leaves it, "—" means the noun has none (null), and
 * anything else is the full irregular plural as written.
 */
export function pluralForm(noun: string, notation: string | undefined): string | null {
	if (!notation || notation === '—') return null;
	const m = notation.match(/^(¨)?-(.*)$/);
	if (!m) return notation;
	const stem = m[1] ? umlaut(noun) : noun;
	return stem + m[2];
}

/** "der Topf" – the noun with its article. */
export function withArticle(entry: Pick<SharedNounEntry, 'noun' | 'gender'>): string {
	return `${GENDER_ARTICLES[entry.gender] ?? ''} ${entry.noun}`.trim();
}

/** The example sentence with its blank filled by the capitalised article. */
export function exampleSentence(entry: SharedNounEntry): string | null {
	if (!entry.sentence) return null;
	const article = GENDER_ARTICLES[entry.gender] ?? '';
	const cap = article.charAt(0).toUpperCase() + article.slice(1);
	return entry.sentence.replace(/^____/, cap).replace(/____/g, article);
}

/** The dative plural adds -n unless the plural already ends in -n or -s. */
export function dativePlural(plural: string): string {
	return /[ns]$/.test(plural) ? plural : `${plural}n`;
}

const CASE_ARTICLES: Record<string, { nom: string; acc: string; dat: string }> = {
	m: { nom: 'der', acc: 'den', dat: 'dem' },
	f: { nom: 'die', acc: 'die', dat: 'der' },
	n: { nom: 'das', acc: 'das', dat: 'dem' }
};

export interface CaseRow {
	label: string;
	singular: string;
	plural: string | null;
}

/**
 * Nominative, accusative and dative with the definite article, singular and
 * plural. Only for nouns whose singular keeps its form (the collection marks
 * them `declensionSafe`); a weak noun like "der Junge / den Jungen" would need
 * its own endings, so it gets no table rather than a wrong one.
 */
export function caseTable(entry: SharedNounEntry): CaseRow[] | null {
	if (!entry.declensionSafe) return null;
	const a = CASE_ARTICLES[entry.gender];
	if (!a) return null;
	const plural = pluralForm(entry.noun, entry.plural);
	return [
		{ label: 'Nominativ', singular: `${a.nom} ${entry.noun}`, plural: plural && `die ${plural}` },
		{ label: 'Akkusativ', singular: `${a.acc} ${entry.noun}`, plural: plural && `die ${plural}` },
		{
			label: 'Dativ',
			singular: `${a.dat} ${entry.noun}`,
			plural: plural && `den ${dativePlural(plural)}`
		}
	];
}
