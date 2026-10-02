import { error } from '@sveltejs/kit';
import { readFileSync } from 'node:fs';
import { courses, loadCourse } from '$lib/content';
import { buildWorkbook, workbookFile, workbookLevels } from '$lib/domain/workbook';
import type { EntryGenerator, PageServerLoad } from './$types';

/** One prerendered workbook per sub-level: the page tool/gen-workbooks.mjs prints. */
export const entries: EntryGenerator = async () => {
	const all: { courseId: string; levelId: string }[] = [];
	for (const card of courses) {
		const course = await loadCourse(card.id);
		for (const { level } of workbookLevels(course)) all.push({ courseId: card.id, levelId: level });
	}
	return all;
};

/** What tool/gen-workbooks.mjs recorded about the PDFs it wrote. */
export interface WorkbookPdf {
	pages: number;
	bytes: number;
	/** The course version the PDF was printed from. */
	version: string;
}

function pdfManifest(): Record<string, WorkbookPdf> {
	try {
		return JSON.parse(readFileSync('static/workbooks/manifest.json', 'utf8'));
	} catch {
		return {};
	}
}

// A server load, so the booklet arrives as prerendered HTML and the browser
// never downloads the course bundle to print one level of it.
export const load: PageServerLoad = async ({ params }) => {
	const course = await loadCourse(params.courseId);
	const workbook = buildWorkbook(course, params.levelId);
	if (!workbook) error(404, 'No such level');

	const levels = workbookLevels(course);
	const at = levels.findIndex((l) => l.level === params.levelId);
	const file = workbookFile(course.id, params.levelId);

	return {
		workbook,
		pdf: pdfManifest()[file] ? { href: `/workbooks/${file}`, ...pdfManifest()[file] } : null,
		previous: levels[at - 1]?.level ?? null,
		next: levels[at + 1]?.level ?? null
	};
};
