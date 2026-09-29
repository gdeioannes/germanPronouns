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

/** The sentence with its blanks filled, so audio reads a natural sentence. */
export function filledSentence(sentence: string, parts: readonly string[]): string {
	let i = 0;
	return sentence.replace(BLANK, () => parts[i++] ?? '');
}

/**
 * What a passage's audio reads: a dialogue's speaker labels ("Frau Weber:")
 * mark the turns on the page but are not spoken, as in an exam recording.
 */
export function spokenPassage(passage: string): string {
	return passage.replace(/^[^\n:]{1,32}:\s*/gm, '');
}

/** A conjugation row read aloud: "ich/er/sie" + "ging" → "ich ging". */
export function spokenVerbForm(form: Pick<VerbForm, 'person' | 'form'>): string {
	return `${form.person.split('/')[0]} ${form.form}`;
}
