// Every piece of German the app can read aloud, for tool/gen-audio.mjs to
// pre-record. It walks the same content the pages render and derives each
// string with the same function the page's speak button uses (domain/spoken,
// fullForm, exampleSentence …), so a recording matches the text exactly.
//
// When you add a speak button, add its text here too — otherwise it keeps
// working, just with the fallback voice.

import nounData from '$content/shared/nouns/de.json';
import verbData from '$content/shared/verbs/de.json';
import { catalog, loadCourse } from '$lib/content';
import type { Quiz } from '$lib/content/types';
import { TRY_QUESTIONS, tryFilled } from '$lib/content/try-exercise';
import { fullForm } from '$lib/domain/flashcards';
import {
	fillBlankPool,
	filledSentence,
	revealedParts,
	spokenPassage,
	spokenVerbForm
} from '$lib/domain/spoken';
import { exampleSentence, withArticle, type SharedNounEntry, type SharedVerbEntry } from '$lib/domain/words';

export interface SpokenText {
	text: string;
	/** BCP-47, as passed to tts.speak. */
	locale: string;
	/** Where it is heard, for the tool's listing. */
	source: string;
	/** The sub-level of the exercise it belongs to; absent for app-wide text. */
	level?: string;
}

/** Only the German course speaks today; its learn locale comes from the bundle. */
const WORDS_LOCALE = 'de-DE';

export async function spokenTexts(): Promise<SpokenText[]> {
	const out: SpokenText[] = [];
	const add = (text: string | null | undefined, locale: string, source: string, level?: string) => {
		const t = text?.trim();
		if (t) out.push({ text: t, locale, source, level });
	};

	for (const card of catalog.courses) {
		const course = await loadCourse(card.id);
		const locale = course.learnLocale;
		for (const quiz of course.quizzes) {
			for (const [text, source] of quizTexts(quiz)) add(text, locale, source, quiz.level);
			add(quiz.help?.context?.de, locale, 'help memory', quiz.level);
		}
	}

	for (const entry of (nounData as { nouns: SharedNounEntry[] }).nouns) {
		add(withArticle(entry), WORDS_LOCALE, 'word library noun');
		add(exampleSentence(entry), WORDS_LOCALE, 'word library example');
	}
	for (const entry of (verbData as { verbs: SharedVerbEntry[] }).verbs) {
		add(entry.verb, WORDS_LOCALE, 'word library verb');
		for (const set of entry.sets)
			for (const form of set.forms) add(spokenVerbForm(form), WORDS_LOCALE, 'word library conjugation');
	}

	for (const q of TRY_QUESTIONS) add(tryFilled(q), 'de-DE', 'landing demo');

	// First occurrence wins, so a sentence keeps its lowest level.
	const seen = new Set<string>();
	return out.filter((s) => {
		const key = `${s.locale}|${s.text}`;
		if (seen.has(key)) return false;
		seen.add(key);
		return true;
	});
}

/** [text, source] for everything one exercise can speak. */
function quizTexts(quiz: Quiz): [string, string][] {
	switch (quiz.type) {
		case 'fillBlank': {
			const strict = quiz.strictDiacritics === true;
			return fillBlankPool(quiz).map((item) => [
				filledSentence(item.sentence, revealedParts(item, strict)),
				'fill in the blank'
			]);
		}
		case 'listening':
		case 'reading':
			// InlineClozeQuiz speaks a big text verbatim; PassageQuiz drops speaker labels.
			if ('inlineBlanks' in quiz) return [[quiz.passage, 'big text']];
			return [
				[spokenPassage(quiz.passage), `${quiz.type} passage`],
				...(quiz.questions ?? []).map((q): [string, string] => [q.question, `${quiz.type} question`])
			];
		case 'dictation':
			return quiz.items.map((item) => [item.text, 'dictation']);
		case 'speakRepeat':
			return quiz.phrases.map((phrase) => [phrase.text, 'speak & repeat']);
		case 'vocabulary':
			return quiz.cards.map((c) => [fullForm(c), 'flashcard']);
		default:
			return [];
	}
}
