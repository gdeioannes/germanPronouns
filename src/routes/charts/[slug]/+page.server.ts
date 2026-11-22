import { error } from '@sveltejs/kit';
import { loadCourse } from '$lib/content';
import { CHARTS_BOOK, CHARTS_COURSE, chartBySlug } from '$lib/content/charts';
import type { Quiz } from '$lib/content/types';
import type { EntryGenerator, PageServerLoad } from './$types';

// Where a chart's printed QR code lands: the app quizzes that practise that
// chart, easiest first, each tied to the part of the chart it trains
// (tool/charts/quizzes.mjs → charts.json). Prerendered for every chart.
export const entries: EntryGenerator = () => CHARTS_BOOK.charts.map((c) => ({ slug: c.slug }));

/** How big the quiz is: a count and its unit ("19 sentences", "15 words"). */
function size(q: Quiz): string | null {
	const x = q as unknown as Record<string, unknown[] | undefined>;
	const n = (k: string) => (Array.isArray(x[k]) ? x[k]!.length : 0);
	const of = (count: number, unit: string) => (count ? `${count} ${unit}` : null);
	switch (q.type) {
		case 'fillBlank':
			return of(n('sentences'), 'sentences') ?? of(n('subjects'), 'words to sort');
		case 'listening':
		case 'reading':
			return n('inlineBlanks') ? of(n('inlineBlanks'), 'gaps') : of(n('questions'), 'questions');
		case 'dictation':
			return of(n('items'), 'sentences');
		case 'vocabulary':
			return of(n('cards'), 'cards');
		default:
			return null;
	}
}

export const load: PageServerLoad = async ({ params }) => {
	const chart = chartBySlug(params.slug);
	if (!chart) error(404, 'No such chart');
	const course = await loadCourse(CHARTS_COURSE);
	const quizzes = chart.quizzes.flatMap((pick) => {
		const q = course.quizzes.find((x) => x.id === pick.quiz) as Quiz | undefined;
		if (!q) return [];
		return [{
			id: q.id,
			title: q.title,
			type: q.type,
			level: q.level ?? '',
			storageKeyPrefix: q.storageKeyPrefix,
			image: q.image ? `/img/${q.image}.webp` : null,
			for: pick.for,
			note: pick.note,
			size: size(q)
		}];
	});
	return {
		courseId: CHARTS_COURSE,
		chart: { n: chart.n, title: chart.title, topic: chart.topic, level: chart.level, slug: chart.slug, img: chart.img },
		total: CHARTS_BOOK.charts.length,
		quizzes,
		learnLocale: course.learnLocale
	};
};
