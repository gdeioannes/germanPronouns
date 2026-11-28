import { error } from '@sveltejs/kit';
import registry from '$content/booklinks.json';
import { courses, loadCourse } from '$lib/content';
import type { BookLinkRegistry, LinkKind } from '$lib/domain/booklinks';
import { codeUrl } from '$lib/domain/booklinks';
import { loadBook2, photoCredits, type BookExtra } from '$lib/domain/book2';
import { qrSvg } from '$lib/server/qr';
import { INSTAGRAM, newsUrl } from '$lib/domain/bookNews';
import { PART_IDS, type PartId } from '$lib/domain/bookStudy';
import type { EntryGenerator, PageServerLoad } from './$types';

// Book v2 (docs/book_v2_plan.md), prerendered like the workbooks so
// tool/gen-book2.mjs prints the same page a browser shows.
export const entries: EntryGenerator = async () => {
	const all: { courseId: string; levelId: string }[] = [];
	for (const card of courses) {
		const course = await loadCourse(card.id);
		for (const level of new Set(course.quizzes.map((q) => q.level ?? ''))) if (level && loadBook2(card.id, level)) all.push({ courseId: card.id, levelId: level });
	}
	return all;
};

export const load: PageServerLoad = async ({ params }) => {
	const book = loadBook2(params.courseId, params.levelId);
	if (!book) error(404, 'No such book');
	const links = registry as unknown as BookLinkRegistry;
	// Codes are the printed book's permanent ones; one not yet minted is left off.
	const code = async (kind: LinkKind, target?: string) => {
		const link = target ? links.links.find((l) => l.kind === kind && l.target === target) : undefined;
		return link ? { svg: await qrSvg(codeUrl(link.code)), code: link.code, url: codeUrl(link.code) } : null;
	};
	const qr: Record<string, { app: Awaited<ReturnType<typeof code>>; listen: Awaited<ReturnType<typeof code>>; speak: Awaited<ReturnType<typeof code>> }> = {};
	for (const c of book.chapters) qr[c.id] = { app: await code('quiz', c.quiz), listen: await code('audio', c.listenQuiz), speak: await code('quiz', c.speakQuiz) };
	// The small code on each page that opens that part of the chapter in the app
	// (domain/bookStudy): check the page, the words as flashcards, the text read aloud.
	const pages: Record<string, Partial<Record<PartId, Awaited<ReturnType<typeof code>>>>> = {};
	for (const c of book.chapters) {
		pages[c.id] = {};
		for (const part of PART_IDS) pages[c.id][part] = await code('chapter', `${book.level}/${c.id}/${part}`);
	}
	// "Mehr lesen und hören": the level's longer texts, printed from the bundle.
	const credits = photoCredits(params.courseId);
	const extras: BookExtra[] = [];
	if (book.extras?.length) {
		const course = await loadCourse(params.courseId);
		for (const id of book.extras) {
			const q = course.quizzes.find((x) => x.id === id);
			if (!q || (q.type !== 'reading' && q.type !== 'listening') || !('questions' in q) || !q.questions?.length) continue;
			extras.push({
				id,
				kind: q.type,
				title: q.passageTitle,
				passage: q.passage,
				questions: q.questions.map((x) => ({ question: x.question, options: x.options, correct: x.correctIndex })),
				photo: credits[id] ? id : null,
				image: q.image ?? null,
				code: await code('quiz', id)
			});
		}
	}
	// The newsletter card at each chapter's end: its code, tagged like its link (domain/bookNews).
	const newsQr: Record<string, string> = {};
	for (const [i, c] of book.chapters.entries()) newsQr[c.id] = await qrSvg(newsUrl('qr', book.level, i));
	newsQr.cover = await qrSvg(newsUrl('qr', book.level, 'cover'));
	newsQr.end = await qrSvg(newsUrl('qr', book.level, 'end'));
	return { book, credits, qr, pages, extras, siteQr: await qrSvg('https://languagequiz.org'), newsQr, instaQr: await qrSvg(INSTAGRAM) };
};
