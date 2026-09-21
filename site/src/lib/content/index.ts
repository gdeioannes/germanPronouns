// Loads the shared content bundles. Both apps read the same files in
// `assets/content/`, so nothing is duplicated or re-authored during the port:
// regenerate with `dart run tool/generate_content.dart` and both pick it up.
//
// The catalog is imported statically, so it is baked into the prerendered HTML
// with no runtime fetch. Course bundles are large (the German course is ~1.3MB)
// and belong to one route each, so those are imported lazily.

import catalogJson from '$content/catalog.json';
import type { Catalog, CourseCard, PopulatedCourse, Quiz, ReadingQuiz } from './types';

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

export function isReading(quiz: Quiz): quiz is ReadingQuiz {
	return quiz.type === 'reading';
}
