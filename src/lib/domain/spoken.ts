// What the app reads aloud, as plain functions. The components speak through
// these, and so does the audio collector (src/lib/audio/spoken-texts.ts) that
// tells tool/gen-audio.mjs what to pre-record — one definition, so a recording
// always matches the exact text a button asks for.

import type { FillBlankQuiz, QuizSentence } from '$lib/content/types';
import { BLANK, canonicalGapAnswer, gapCount } from './answers';
import type { VerbForm } from './words';
import { lang } from '$lib/i18n/lang.svelte';

/**
 * The question pool. An authored bank is used as-is; a template-driven quiz
 * expands `{subject}` across its categories, which is how the generated
 * quizzes (numbers, conjugation tables) produce their items.
 */
export function fillBlankPool(quiz: FillBlankQuiz): QuizSentence[] {
	if (quiz.sentences?.length) return quiz.sentences;

	const generated: QuizSentence[] = [];
	for (const category of quiz.categories ?? []) {
		const templates = quiz.sentenceTemplates?.[category.label] ?? ['{subject} = ____'];
		const english = quiz.englishTemplates?.[category.label] ?? [];
		for (const [index, subject] of (quiz.subjects ?? []).entries()) {
			const answer = category.values[index];
			// A hole (null) in the values skips that subject: Germany has no
			// direction from Germany.
			if (answer == null) continue;
			for (const [t, template] of templates.entries()) {
				const line = englishLine(english[t], subject.english ?? subject.display);
				generated.push({
					subjectKey: subject.key,
					categoryLabel: category.label,
					sentence: template.replace('{subject}', subject.display),
					acceptedAnswers: [answer],
					...(line ? { english: line } : {})
				});
			}
		}
	}
	return generated;
}

/** Nouns whose English plural is not just an -s. */
const IRREGULAR_PLURAL: Record<string, string> = { man: 'men', woman: 'women', child: 'children' };

/**
 * An English template filled in: `{subject}` is the English, `{a}` the
 * article it takes ("an apple"), `{pl}` its plural ("two children").
 */
function englishLine(template: string | undefined, english: string): string | undefined {
	if (!template) return undefined;
	// Arabic: the template and the noun come Arabic from the overlay. Arabic
	// has no word for a/an (an indefinite noun is just the bare noun), and the
	// templates are written so the bare noun fits after a number too.
	// Ukrainian likewise has no articles; its templates are written so the
	// noun stands in the nominative (no number before it).
	if (lang.ar || lang.uk) {
		return template
			.replace(/\{a\}\s*/g, '')
			.replace('{pl}', english)
			.replace('{subject}', english);
	}
	if (lang.fr) return frenchLine(template, english);
	if (lang.es) return spanishLine(template, english);
	if (lang.tr) {
		// Turkish: the template and the noun come Turkish from the overlay.
		// Turkish has "bir" for a/an and no plural after a number or "çok", so
		// the noun goes in bare.
		// "bir" goes before the noun itself, after its adjective: yeni bir masa.
		const withBir = english.includes(' ') ? english.replace(/(\S+)$/, 'bir $1') : `bir ${english}`;
		return template
			.replace('{a} {subject}', withBir)
			.replace('{a}', 'bir')
			.replace('{pl}', english)
			.replace('{subject}', english);
	}
	const head = english.split(' ').pop() ?? english;
	const plural = IRREGULAR_PLURAL[head] ? english.replace(/\S+$/, IRREGULAR_PLURAL[head]) : `${english}s`;
	return template
		.replace('{a}', /^[aeiou]/i.test(english) ? 'an' : 'a')
		.replace('{pl}', plural)
		.replace('{subject}', english);
}

/**
 * French: the template and the noun come French from the overlay. A noun is
 * written with its indefinite article, which carries its French gender, and
 * may add its plural after a bar: "une nouvelle table|nouvelles tables".
 *   {a}          un / une
 *   {subject}    the noun without its article: "nouvelle table"
 *   {pl}         its plural: "nouvelles tables" (given, or -s / -x / -aux)
 *   {le/la}      any "{masculine/feminine}" pair, picked by the noun's gender;
 *                le/la become l' and ma/ta/sa mon/ton/son before a vowel.
 * A word that is not a noun ("je", "la France") has no article and is used as is.
 */
export function frenchLine(template: string, english: string): string {
	const [written, givenPlural] = english.split('|').map((s) => s.trim());
	const m = /^(une|un)\s+(.+)$/i.exec(written);
	const feminine = m ? m[1].toLowerCase() === 'une' : false;
	const noun = m ? m[2] : written;
	const plural = givenPlural ?? noun.replace(/(\S+)$/, frenchPlural);
	const vowel = (s: string) => /^[aeiouyàâéèêëîïôûœh]/i.test(s.trim());
	let out = template
		.replace(/\{a\}/g, feminine ? 'une' : 'un')
		.replace(/\{pl\}/g, plural)
		.replace(/\{subject\}/g, noun);
	// "{le/la} table" → "la table"; "{Le/La} ami" → "L'ami".
	out = out.replace(/\{([^{}/]+)\/([^{}/]+)\}(\s*)(\S?)/g, (_, masc: string, fem: string, space: string, next: string) => {
		const word = feminine ? fem : masc;
		if (next && vowel(next)) {
			if (/^l[ea]$/i.test(word)) return `${word[0]}'${next}`;
			if (/^[mts]a$/i.test(word)) return `${word[0]}on${space}${next}`;
		}
		return `${word}${space}${next}`;
	});
	return out;
}

const FRENCH_PLURAL: Record<string, string> = { œil: 'yeux', ciel: 'cieux', monsieur: 'messieurs', madame: 'mesdames', travail: 'travaux' };
function frenchPlural(word: string): string {
	const lower = word.toLowerCase();
	if (FRENCH_PLURAL[lower]) return FRENCH_PLURAL[lower];
	if (/[sxz]$/i.test(word)) return word;
	if (/(eau|eu|au)$/i.test(word) && !/^(pneu|bleu)$/i.test(word)) return `${word}x`;
	if (/al$/i.test(word) && !/^(bal|festival|carnaval|récital)$/i.test(word)) return word.replace(/al$/i, 'aux');
	return `${word}s`;
}

/**
 * Spanish: like French, a noun is written with its indefinite article, which
 * carries its gender, and may add its plural after a bar: "una mesa nueva|mesas nuevas".
 *   {a}          un / una
 *   {subject}    the noun without its article: "mesa nueva"
 *   {pl}         its plural: given, or -s after a vowel, -es after a consonant, -z → -ces
 *   {el/la}      any "{masculine/feminine}" pair, picked by the noun's gender;
 *                "a el" and "de el" contract to "al" and "del".
 * A word that is not a noun ("yo", "España") has no article and is used as is.
 */
export function spanishLine(template: string, english: string): string {
	const [written, givenPlural] = english.split('|').map((s) => s.trim());
	const m = /^(una|un)\s+(.+)$/i.exec(written);
	const feminine = m ? m[1].toLowerCase() === 'una' : false;
	const noun = m ? m[2] : written;
	// The noun is the first word ("mesa nueva" → "mesas nuevas" only when given).
	const plural = givenPlural ?? noun.replace(/^(\S+)/, spanishPlural);
	let out = template
		.replace(/\{a\}/g, feminine ? 'una' : 'un')
		.replace(/\{pl\}/g, plural)
		.replace(/\{subject\}/g, noun)
		.replace(/\{([^{}/]+)\/([^{}/]+)\}/g, (_, masc: string, fem: string) => (feminine ? fem : masc));
	out = out.replace(/\b([aA]|[dD]e) el\b/g, (_, p: string) => (p.toLowerCase() === 'a' ? `${p}l` : `${p[0]}el`));
	return out;
}

function spanishPlural(word: string): string {
	if (/[aeiouáéó]$/i.test(word)) return `${word}s`;
	if (/z$/i.test(word)) return word.replace(/z$/i, 'ces');
	// A last-syllable accent goes in the plural: canción → canciones, autobús → autobuses.
	if (/[áéíóú][ns]$/i.test(word)) return `${word.replace(/[áéíóú](?=[ns]$)/i, (v) => 'aeiou'['áéíóú'.indexOf(v.toLowerCase())])}es`;
	if (/[sx]$/i.test(word)) return word;
	return `${word}es`;
}

/** The first usable answer for each gap — what a reveal writes in. */
export function revealedParts(item: QuizSentence, strict: boolean): string[] {
	const gaps = Math.max(1, gapCount(item.sentence));
	return canonicalGapAnswer(new Array(gaps).fill(''), item.acceptedAnswers, true, strict);
}

/**
 * The sentence with its blanks filled, so audio reads a natural sentence: the
 * cue for the learner goes ("(you, formal)", "(lernen)"), and an answer that
 * opens a sentence is capitalised ("ihr seid …" → "Ihr seid …").
 */
export function filledSentence(sentence: string, parts: readonly string[]): string {
	let i = 0;
	const filled = sentence.replace(BLANK, (_, offset: number) => {
		const part = parts[i++] ?? '';
		return opensSentence(sentence.slice(0, offset)) ? part.charAt(0).toUpperCase() + part.slice(1) : part;
	});
	return forSpeech(filled);
}

/** Whether text placed after `before` starts a sentence (or a dialogue turn). */
function opensSentence(before: string): boolean {
	return /^\s*$|[.!?]\s+(–\s+)?$/.test(before);
}

/** A bracketed note, allowing one level of nesting: "(for what → wo(r)-)". */
const NOTE = String.raw`\((?:[^()]|\([^()]*\))*\)`;

/** What a grammar tag after a word or pattern names: "seit + Dat". */
const GRAMMAR_TAG = /(\s*\+\s*(Nom|Akk|Dat|Gen|Partizip II|Infinitiv|Konjunktiv II))+\s*$/;

/**
 * Exercise text as it should be heard. The cards write for the eye — a cue in
 * brackets at the end, "→" between a sentence and its rewrite, "+" and "=" in
 * word sums, "+ Dat" after a preposition — and a voice would read every mark,
 * in German, English cues included. The screen keeps the original.
 */
export function forSpeech(text: string): string {
	return (
		text
			// The cue for the learner at the end: "… Müller. (you, formal)".
			.replace(new RegExp(String.raw`\s*${NOTE}\s*([.!?…]*)\s*$`), '$1')
			// A note on the first half of a rewrite: "Das passt mir nicht. (the date) → …".
			.replace(new RegExp(String.raw`\s*${NOTE}\s*(?=→)`, 'g'), ' ')
			.replace(GRAMMAR_TAG, '')
			// "1 = eins" says the number once.
			.replace(/^\d+\s*=\s*/, '')
			// Between a sentence and its rewrite, a sentence break is pause enough.
			.replace(/([.!?])\s*→\s*/g, '$1 ')
			.replace(/\s*(→|=|\+)\s*/g, ', ')
			.replace(/\s+([.,!?;:])/g, '$1')
			.replace(/\s{2,}/g, ' ')
			.trim()
	);
}

/**
 * What a passage's audio reads: a dialogue's speaker labels ("Frau Weber:")
 * mark the turns on the page but are not spoken, as in an exam recording.
 */
export function spokenPassage(passage: string): string {
	return passage.replace(/^[^\n:]{1,32}:\s*/gm, '');
}

/**
 * A conjugation row read aloud: "ich/er/sie" + "ging" → "ich ging". An
 * imperative's bracketed person is not said: "(du)" + "sei" → "Sei!".
 */
export function spokenVerbForm(form: Pick<VerbForm, 'person' | 'form'>): string {
	if (form.person.startsWith('(')) return `${form.form.charAt(0).toUpperCase()}${form.form.slice(1)}!`;
	return `${form.person.split('/')[0]} ${form.form}`;
}
