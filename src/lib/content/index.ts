// Loads the course content bundles from `assets/content/` — the source of
// truth for every exercise in the app (see `types.ts` for their shape).
//
// The catalog is imported statically, so it is baked into the prerendered HTML
// with no runtime fetch. Course bundles are large (the German course is ~1.3MB)
// and belong to one route each, so those are imported lazily.

import catalogJson from '$content/catalog.json';
import type {
	Catalog,
	CourseCard,
	CourseSyllabus,
	PopulatedCourse,
	Quiz,
	ReadingQuiz
} from './types';

export const catalog = catalogJson as Catalog;

export const courses: CourseCard[] = catalog.courses;

export function courseCard(id: string): CourseCard | undefined {
	return catalog.courses.find((c) => c.id === id);
}

/** Every course bundle, keyed by id, resolved on demand (never all at once). */
const bundles = import.meta.glob<{ default: PopulatedCourse }>(
	'$content/courses/*.json'
);

/** Loads one course's full bundle — nav plus every quiz. */
export async function loadCourse(id: string): Promise<PopulatedCourse> {
	const path = Object.keys(bundles).find((p) => p.endsWith(`/${id}.json`));
	if (!path) throw new Error(`No content bundle for course "${id}"`);
	const module = await bundles[path]();
	return module.default;
}

/** Every course syllabus, keyed by id — the master table each module teaches to. */
const syllabi = import.meta.glob<{ default: CourseSyllabus }>('$content/syllabus/*.json');

/** Loads one course's syllabus, or null when it has none yet. */
export async function loadSyllabus(id: string): Promise<CourseSyllabus | null> {
	const path = Object.keys(syllabi).find((p) => p.endsWith(`/${id}.json`));
	if (!path) return null;
	return (await syllabi[path]()).default;
}

export function isReading(quiz: Quiz): quiz is ReadingQuiz {
	return quiz.type === 'reading';
}
