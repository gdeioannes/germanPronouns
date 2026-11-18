import { error } from '@sveltejs/kit';
import { courses, loadCourse } from '$lib/content';
import { loadBook2 } from '$lib/domain/book2';
import type { Quiz } from '$lib/content/types';
import type { EntryGenerator, PageServerLoad } from './$types';

// The "App" side of one printed page: the app's quizzes for that page, each
// tied to the thing on the page it practises (chapter.appQuizzes), in the
// order the book data lists them. Prerendered for every page that has a list.
export const entries: EntryGenerator = async () => {
	const all: { courseId: string; levelId: string; chapterId: string; part: string }[] = [];
	for (const card of courses) {
		const course = await loadCourse(card.id);
		for (const level of new Set(course.quizzes.map((q) => q.level ?? ''))) {
			const book = level ? loadBook2(card.id, level) : null;
			for (const c of book?.chapters ?? []) {
				for (const [part, picks] of Object.entries(c.appQuizzes ?? {})) {
					if (picks?.length) all.push({ courseId: card.id, levelId: level, chapterId: c.id, part });
				}
			}
		}
	}
	return all;
};

/** How big the quiz is, as a count and its unit (the page words it: "19 sentences", "6 Fragen"). */
type Unit = 'sentences' | 'questions' | 'gaps' | 'phrases' | 'cards';
function size(q: Quiz): { n: number; unit: Unit } | null {
	const x = q as unknown as Record<string, unknown[] | undefined>;
	const n = (k: string) => (Array.isArray(x[k]) ? x[k]!.length : 0);
	const of = (count: number, unit: Unit) => (count ? { n: count, unit } : null);
	switch (q.type) {
		case 'fillBlank':
			return of(n('sentences'), 'sentences');
		case 'listening':
		case 'reading':
			return n('inlineBlanks') ? of(n('inlineBlanks'), 'gaps') : of(n('questions'), 'questions');
		case 'dictation':
			return of(n('items'), 'sentences');
		case 'speakRepeat':
			return of(n('phrases'), 'phrases');
		case 'vocabulary':
			return of(n('cards'), 'cards');
		default:
			return null;
	}
}

export const load: PageServerLoad = async ({ params }) => {
	const book = loadBook2(params.courseId, params.levelId);
	const chapter = book?.chapters.find((c) => c.id === params.chapterId);
	if (!book || !chapter || !chapter.appQuizzes?.[params.part]?.length) error(404, 'No quizzes for this page');
	const course = await loadCourse(params.courseId);
	// A quiz whose picture is shared with others (the level's grammar card)
	// shows one of the chapter's own photos instead, a different one each time.
	const shared = new Set(
		Object.entries(
			course.quizzes.reduce<Record<string, number>>((m, q) => (q.image ? ((m[q.image] = (m[q.image] ?? 0) + 1), m) : m), {})
		)
			.filter(([, n]) => n > 1)
			.map(([img]) => img)
	);
	const chapterPhotos = [
		...chapter.grammar.map((g) => g.photo?.photo),
		...(chapter.reading.photos ?? []).map((p) => p.photo),
		chapter.document.photo,
		chapter.opener.photo
	].filter((p): p is string => !!p);
	let nextPhoto = 0;
	const quizzesFor = (picks: NonNullable<typeof chapter.appQuizzes>[string] = []) => picks.flatMap((p, at) => {
		const q = course.quizzes.find((x) => x.id === p.quiz) as Quiz | undefined;
		if (!q) return [];
		const photo = p.photo ?? (!q.image || shared.has(q.image) ? chapterPhotos[nextPhoto++ % chapterPhotos.length] : null);
		const image = photo ? `/img/photo/web/${photo}.jpg` : `/img/${q.image}.webp`;
		return [{ at, id: q.id, title: q.title, type: q.type, storageKeyPrefix: q.storageKeyPrefix, image, for: p.for, note: p.note, size: size(q) }];
	});
	// Every page of the chapter that has a list: all of them come with the
	// page, so the tabs switch without loading anything.
	const lists: Record<string, ReturnType<typeof quizzesFor>> = {};
	for (const [part, picks] of Object.entries(chapter.appQuizzes ?? {})) if (picks?.length) lists[part] = quizzesFor(picks);
	const pages = Object.keys(lists);
	return {
		courseId: params.courseId,
		level: book.level,
		bookTitle: book.title,
		chapter: { id: chapter.id, n: chapter.n, title: chapter.title, world: chapter.world },
		/** From B1 the book speaks German, and so does its quiz list. */
		german: !!chapter.german,
		part: params.part,
		pages,
		lists,
		/** The raw lists, for the second-language overlay (inLangChapter): its paths are appQuizzes.<part>[i].for / .note. */
		appQuizzes: chapter.appQuizzes,
		learnLocale: course.learnLocale
	};
};
