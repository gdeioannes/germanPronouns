import { page } from '$app/state';

/** The sub-level the current page belongs to ("B1.1" or "b1_1"), if any. Reactive. */
export function pageLevel(): string | null {
	const data = page.data as { quiz?: { level?: string }; bookLevel?: string };
	// A book's own page (/books/a1-1) names its level in its data.
	return page.params.levelId ?? data.quiz?.level ?? data.bookLevel ?? null;
}
