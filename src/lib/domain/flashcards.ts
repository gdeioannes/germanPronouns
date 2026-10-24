// The flip-card mechanics: what a written answer must contain, which four
// options a multiple-choice card shows, and what makes a word "weak". Pure
// functions, so the deck's behaviour is unit-tested without a browser.

import type { VocabCard } from '$lib/content/types';
import { matchesAccepted } from './answers';

/** The German a learner must produce: a noun always with its article. */
export function fullForm(card: VocabCard): string {
	return card.kind === 'noun' && card.article ? `${card.article} ${card.de}` : card.de;
}

/**
 * Checks a written answer. A noun without its article is wrong even when the
 * noun itself is right — the article is the half a learner forgets, and this
 * deck exists to make it stick. Umlaut-strict, so "Apfel" is not "Äpfel".
 */
export function checkWritten(
	typed: string,
	card: VocabCard,
	relaxed: boolean
): { correct: boolean; missingArticle: boolean } {
	const target = fullForm(card);
	// A synonym is written as it stands; a noun synonym carries its own article.
	const accepted = [target, ...(card.also ?? [])];
	if (matchesAccepted(typed, accepted, relaxed, true)) {
		return { correct: true, missingArticle: false };
	}
	const missingArticle =
		card.kind === 'noun' && !!card.article && matchesAccepted(typed, [card.de], relaxed, true);
	return { correct: false, missingArticle };
}

/**
 * The four options for a choose-mode card: the answer plus three distractors
 * drawn from the deck, preferring cards of the same kind and, for nouns, the
 * same gender — so the choice is between "der Vertrag", "der Betrag" and
 * "das Gehalt", not between a noun and a number.
 */
export function chooseOptions(
	card: VocabCard,
	deck: readonly VocabCard[],
	random: () => number = Math.random
): string[] {
	const others = deck.filter((c) => c !== card && fullForm(c) !== fullForm(card));
	const tiers = [
		others.filter((c) => c.kind === card.kind && c.article === card.article),
		others.filter((c) => c.kind === card.kind),
		others
	];
	const picked: VocabCard[] = [];
	for (const tier of tiers) {
		const pool = tier.filter((c) => !picked.includes(c));
		shuffle(pool, random);
		for (const c of pool) {
			if (picked.length === 3) break;
			picked.push(c);
		}
		if (picked.length === 3) break;
	}
	const options = [card, ...picked].map(fullForm);
	shuffle(options, random);
	return options;
}

/**
 * The ending rules the A1.1 lesson "Endings that give the gender away"
 * teaches, longest ending first so "-heit" wins over "-e". `how` is said to
 * the learner, so it is as honest as the deck: -ung has no exception in it,
 * -er misses one noun in four. `not` lists endings that only look like the
 * rule: Papier's -ier and Baum's -aum are not the -er and -um it means.
 */
const GENDER_RULES: { ending: string; article: string; how: string; not?: string[] }[] = [
	{ ending: 'schaft', article: 'die', how: 'always' },
	{ ending: 'heit', article: 'die', how: 'always' },
	{ ending: 'keit', article: 'die', how: 'always' },
	{ ending: 'ung', article: 'die', how: 'always' },
	{ ending: 'ion', article: 'die', how: 'almost always' },
	{ ending: 'chen', article: 'das', how: 'almost always' },
	{ ending: 'lein', article: 'das', how: 'almost always' },
	{ ending: 'ment', article: 'das', how: 'mostly' },
	{ ending: 'ling', article: 'der', how: 'almost always' },
	{ ending: 'um', article: 'das', how: 'mostly', not: ['aum'] },
	{ ending: 'er', article: 'der', how: 'usually', not: ['ier'] },
	{ ending: 'e', article: 'die', how: 'mostly' }
];

/** Plural-only nouns take die for being plural, not for their ending. */
const PLURAL_ONLY = /(Geschwister|Eltern|Leute|Ferien|Kosten)$/;

export interface GenderRule {
	ending: string;
	article: string;
	how: string;
	/** The noun the rule is about: "Wetter" in "schlechte Wetter". */
	noun: string;
	/** False when the card is an exception to the rule. */
	follows: boolean;
}

/**
 * The ending rule a noun card falls under, if any — for the correction on a
 * missed card: "-ung words are always die", or "most -er words are der, but
 * Mutter is an exception". A phrase card ("schlechte Wetter", "Bitte um") is
 * judged by its last capitalised word, the noun.
 */
export function genderRule(card: VocabCard): GenderRule | null {
	if (card.kind !== 'noun' || !card.article) return null;
	const noun = card.de.split(/\s+/).filter((w) => /^[A-ZÄÖÜ]/.test(w)).pop();
	if (!noun || PLURAL_ONLY.test(noun) || card.plural === '(Pl.)' || /plural/i.test(card.en)) return null;
	for (const rule of GENDER_RULES) {
		// The ending must follow a stem: "Ei" is not an -ei word, nor "Um" an -um one.
		if (!noun.endsWith(rule.ending) || noun.length < rule.ending.length + 2) continue;
		if (rule.not?.some((n) => noun.endsWith(n))) return null;
		return {
			ending: rule.ending,
			article: rule.article,
			how: rule.how,
			noun,
			follows: card.article === rule.article
		};
	}
	return null;
}

function shuffle<T>(items: T[], random: () => number): void {
	for (let i = items.length - 1; i > 0; i--) {
		const j = Math.floor(random() * (i + 1));
		[items[i], items[j]] = [items[j], items[i]];
	}
}

/** What the vocab store keeps per word. */
export interface WordRecord {
	seen: number;
	wrong: number;
	/** Correct answers in a row; reset by a miss. */
	streak: number;
	/** ISO date of the last miss, if any. */
	lastWrong?: string;
	/** The last mode the word was missed in. */
	mode?: 'write' | 'choose' | 'flip';
	/** The deck (quiz id) the word was last practised in. */
	deck?: string;
}

export const EMPTY_WORD: WordRecord = { seen: 0, wrong: 0, streak: 0 };

/** The most right answers in a row a word ever needs to leave the weak deck. */
export const CLEARED_STREAK = 3;

/**
 * Right answers in a row that clear a word: as many as it has been missed,
 * up to CLEARED_STREAK. One slip is fixed by one right answer; a word that
 * keeps tripping the learner up has to be got right three times running.
 */
export function clearsNeeded(record: WordRecord): number {
	return Math.min(Math.max(record.wrong, 1), CLEARED_STREAK);
}

/**
 * A word is weak when it has been missed and not yet answered right enough
 * times in a row since (see clearsNeeded). The weak deck is those words,
 * most recent miss first.
 */
export function isWeak(record: WordRecord): boolean {
	return record.wrong > 0 && record.streak < clearsNeeded(record);
}

export function recordOutcome(
	record: WordRecord,
	correct: boolean,
	mode: WordRecord['mode'],
	now: Date = new Date()
): WordRecord {
	if (correct) {
		return { ...record, seen: record.seen + 1, streak: record.streak + 1 };
	}
	return {
		...record,
		seen: record.seen + 1,
		wrong: record.wrong + 1,
		streak: 0,
		lastWrong: now.toISOString(),
		mode
	};
}

/** The key a card's record is stored under: the full form, article included. */
export function wordKey(card: VocabCard): string {
	return fullForm(card);
}
