// The authored files a printed book is built from, per course: the chapter
// files (themes, photos, opening texts), the photo credits, and the units'
// paper wording. Both the book route and its "My book" checklist read them
// through here, so the two always see the same book.

import type { ChapterSpec, Photo } from '$lib/domain/book';
import type { PaperOverrides } from '$lib/domain/workbook';

type Credits = Record<string, Omit<Photo, 'id'>>;

const chapterGlob = import.meta.glob<{ default: ChapterSpec | Credits }>('$content/chapters/*/*.json', { eager: true });
const paperGlob = import.meta.glob<{ default: PaperOverrides }>('$content/book/*/*.json', { eager: true });

/** "a1_1" → "A1.1": the file name is the level in a form a file system likes. */
const levelOf = (name: string) => name.toUpperCase().replace('_', '.');

export interface BookFiles {
	files: Record<string, ChapterSpec>;
	photos: Credits;
	paper: Record<string, PaperOverrides>;
}

export function bookFilesOf(courseId: string): BookFiles {
	const files: Record<string, ChapterSpec> = {};
	let photos: Credits = {};
	const paper: Record<string, PaperOverrides> = {};
	for (const [path, mod] of Object.entries(chapterGlob)) {
		const m = /\/chapters\/([^/]+)\/([^/]+)\.json$/.exec(path);
		if (!m || m[1] !== courseId) continue;
		if (m[2] === '_photos') photos = mod.default as Credits;
		else files[levelOf(m[2])] = mod.default as ChapterSpec;
	}
	for (const [path, mod] of Object.entries(paperGlob)) {
		const m = /\/book\/([^/]+)\/([^/]+)\.json$/.exec(path);
		if (!m || m[1] !== courseId) continue;
		const { _comment: _, ...units } = mod.default as PaperOverrides & { _comment?: string };
		paper[levelOf(m[2])] = units;
	}
	return { files, photos, paper };
}
