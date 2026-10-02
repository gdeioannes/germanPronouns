// What the app reads aloud, as plain functions. The components speak through
// these, and so does the audio collector (src/lib/audio/spoken-texts.ts) that
// tells tool/gen-audio.mjs what to pre-record — one definition, so a recording
// always matches the exact text a button asks for.

import type { FillBlankQuiz, QuizSentence } from '$lib/content/types';
import { BLANK, canonicalGapAnswer, gapCount } from './answers';
import type { VerbForm } from './words';

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
		for (const [index, subject] of (quiz.subjects ?? []).entries()) {
			const answer = category.values[index];
			if (answer === undefined) continue;
			for (const template of templates) {
				generated.push({
					subjectKey: subject.key,
					categoryLabel: category.label,
					sentence: template.replace('{subject}', subject.display),
					acceptedAnswers: [answer]
				});
			}
		}
	}
	return generated;
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
