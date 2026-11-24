import { courses } from '$lib/content';
import type { EntryGenerator } from './$types';

// The old whole-level book (Deutsch A1 … C2, its cover and its "My book"
// checklist) is gone. Its addresses were prerendered and may be bookmarked or
// indexed, so each one stays as a page that sends the reader to the shelf.

const BOOKS = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

export const entries: EntryGenerator = () =>
	courses.flatMap((c) => BOOKS.flatMap((bookId) => ['', 'cover', 'progress'].map((rest) => ({ courseId: c.id, bookId, rest }))));
