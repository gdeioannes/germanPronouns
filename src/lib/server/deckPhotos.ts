// Which photo each deck card shows. Every exercise gets a photo from its
// level's book (Book v2): the chapter that names it (its practice, listening
// or speaking exercise) when there is one, else a chapter of the same level,
// spread evenly so neighbouring cards differ. The files are the warm-graded
// copies tool/build-deck-photos.mjs writes to static/img/deck/.
import { loadBook2, photoCredits } from '$lib/domain/book2';
import type { QuizSummary } from '$lib/content/types';

export interface CardPhoto {
	/** /img/deck/<photo>.webp */
	photo: string;
	/** "Author, licence", as the photo's licence asks. */
	credit: string;
}

export function deckPhotos(courseId: string, quizzes: Pick<QuizSummary, 'id' | 'level'>[]): Record<string, CardPhoto> {
	const credits = photoCredits(courseId);
	const credit = (photo: string) => {
		const c = credits[photo];
		return c ? `${c.author.replace(/\s*\(talk\).*$/, '').trim()}, ${c.license}` : '';
	};
	const out: Record<string, CardPhoto> = {};
	for (const level of new Set(quizzes.map((q) => q.level ?? ''))) {
		const book = level ? loadBook2(courseId, level) : null;
		if (!book?.chapters.length) continue;
		const of = (photo: string): CardPhoto => ({ photo, credit: credit(photo) });
		const named = new Map<string, CardPhoto>();
		for (const c of book.chapters) for (const q of [c.quiz, c.listenQuiz, c.speakQuiz]) if (q) named.set(q, of(c.opener.photo));
		// An exercise with a photo of its own (a credit filed under the exercise
		// id) shows that one, so a text about a place shows the place. Those are
		// left out of the count, so adding one does not shift every card after it.
		let i = 0;
		for (const q of quizzes.filter((q) => q.level === level)) {
			if (credits[q.id]) out[q.id] = of(q.id);
			else out[q.id] = named.get(q.id) ?? of(book.chapters[i++ % book.chapters.length].opener.photo);
		}
	}
	return out;
}

/**
 * The picture an exercise shows inside, as an /img path stem: its card photo
 * ("deck/<photo>"), so the deck and the exercise look the same. Exercises whose
 * own picture IS the task keep it: picture hunts and speaking tasks where you
 * describe the picture. (Flashcards' word pictures are per card, not this one.)
 */
export function insidePicture(
	quiz: { id: string; type: string; image?: string; speaking?: { describePicture?: boolean } },
	photo: CardPhoto | undefined
): { image?: string; credit: string | null } {
	const own = quiz.type === 'suchbild' || !!quiz.speaking?.describePicture;
	if (own || !photo) return { image: quiz.image, credit: null };
	return { image: `deck/${photo.photo}`, credit: photo.credit };
}
