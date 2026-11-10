import { existsSync, readFileSync, statSync } from 'node:fs';
import { join } from 'node:path';
import { catalog, loadCourse } from '$lib/content';
import { loadBook2 } from '$lib/domain/book2';
import { audioShard, SHARDS } from '$lib/audio/shard';
import { spokenTexts, type SpokenText } from '$lib/audio/spoken-texts';
import type { OfflineLevel } from '$lib/offline/saveLevel';

const AUDIO_DIR = join('static', 'audio');

let spoken: Promise<SpokenText[]> | null = null;
const shards = new Map<string, Record<string, Record<string, string>>>();

function shard(id: string): Record<string, Record<string, string>> {
	let s = shards.get(id);
	if (!s) {
		const file = join(AUDIO_DIR, 'manifest', `${id}.json`);
		s = existsSync(file) ? JSON.parse(readFileSync(file, 'utf8')) : {};
		shards.set(id, s!);
	}
	return s!;
}

/** The levels a "save for offline" list exists for: the course's quest chains. */
export async function offlineLevels(): Promise<string[]> {
	const course = await loadCourse(catalog.defaultCourseId);
	return course.nav.groups.flatMap((g) => (g.type === 'questChain' && g.level ? [g.level] : []));
}

/**
 * Everything one level needs to work without a connection: its pages (and the
 * data file SvelteKit fetches when navigating to them in the app), and every
 * recorded clip its exercises, lessons and book chapters can play. Pictures
 * are not listed: the saver collects them from each page's HTML.
 */
export async function offlineLevel(level: string): Promise<OfflineLevel> {
	const courseId = catalog.defaultCourseId;
	const course = await loadCourse(courseId);
	const base = `/course/${courseId}`;

	const routes = [base, `${base}/level/${level}`];
	for (const q of course.quizzes) if (q.level === level) routes.push(`${base}/quiz/${q.id}`);
	const book = loadBook2(courseId, level);
	if (book) {
		routes.push(`${base}/book2/${level}`);
		for (const c of book.chapters) routes.push(`${base}/book2/${level}/${c.id}`);
	}
	// The env module every page imports at start-up (see service-worker.ts).
	const pages = ['/_app/env.js', ...routes.flatMap((r) => [r, `${r}/__data.json`])];

	spoken ??= spokenTexts();
	const audio = new Set<string>();
	let bytes = 0;
	for (const t of await spoken) {
		if (t.level !== level) continue;
		const file = shard(audioShard(t.text))[t.locale]?.[t.text];
		if (!file || audio.has(`/audio/${file}`)) continue;
		audio.add(`/audio/${file}`);
		const path = join(AUDIO_DIR, file);
		if (existsSync(path)) bytes += statSync(path).size;
	}
	const manifests = Array.from({ length: SHARDS }, (_, i) => `/audio/manifest/${i.toString(16)}.json`);

	return { level, pages, media: [...manifests, ...audio], bytes };
}
