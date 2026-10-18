import { error } from '@sveltejs/kit';
import { courses, loadCourse } from '$lib/content';
import { buildWorkbook, workbookLevels } from '$lib/domain/workbook';
import { clipFor } from '$lib/server/audio-clips';
import type { EntryGenerator, PageServerLoad } from './$types';

// The player a book's audio QR opens: every clip of one exercise, numbered as
// the page numbers them, with nothing else on the screen. Prerendered for
// every exercise that has something to hear.

export const entries: EntryGenerator = async () => {
	const all: { quizId: string }[] = [];
	for (const card of courses) {
		const course = await loadCourse(card.id);
		for (const { level } of workbookLevels(course)) {
			for (const unit of buildWorkbook(course, level)?.units ?? []) if (unit.audio.length) all.push({ quizId: unit.quizId });
		}
	}
	return all;
};

export const load: PageServerLoad = async ({ params }) => {
	for (const card of courses) {
		const course = await loadCourse(card.id);
		const quiz = course.quizzes.find((q) => q.id === params.quizId);
		if (!quiz) continue;
		const unit = buildWorkbook(course, quiz.level ?? '')?.units.find((u) => u.quizId === quiz.id);
		if (!unit || !unit.audio.length) break;
		const from = unit.extra?.kind === 'dictation' || unit.extra?.kind === 'phrases' ? unit.extra.lines[0].n : 1;
		const lines = unit.extra?.kind === 'dictation' || unit.extra?.kind === 'phrases' ? unit.extra.lines : null;
		return {
			courseId: course.id,
			quizId: quiz.id,
			title: unit.title,
			level: quiz.level,
			kind: unit.kindLabel,
			clips: unit.audio.map((text, i) => ({
				n: from + i,
				text,
				en: lines?.[i]?.en,
				file: clipFor(text)
			})),
			quizHref: `/course/${course.id}/quiz/${quiz.id}`
		};
	}
	error(404, 'Nothing to play');
};
