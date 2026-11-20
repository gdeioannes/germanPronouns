import { page } from '$app/state';

/** The sub-level the current page belongs to ("B1.1" or "b1_1"), if any. Reactive. */
export function pageLevel(): string | null {
	return page.params.levelId ?? (page.data as { quiz?: { level?: string } }).quiz?.level ?? null;
}
