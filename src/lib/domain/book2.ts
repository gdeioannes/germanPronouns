// Book v2 (docs/book_v2_plan.md): situation-led chapters of nine pages, with
// photographs from Wikimedia Commons and the companion's blocks and exercise
// kinds. One file per sub-level in assets/content/book2/<course>/<stem>.json,
// its photo credits beside it in _photos.json.

import type { Exercise, LearnBlock, KeyEntry, Spread } from './companion';
import { answerKey, companionStem } from './companion';

export type Accent = 'terracotta' | 'mustard' | 'sage' | 'blue';

export interface WordItem {
	de: string;
	/** The plural ending or the whole plural; "–" for none, "" for not applicable. */
	pl?: string;
	en: string;
	/** A picture under /img/<image>.webp. */
	image?: string;
}

export interface PhotoRef {
	/** /img/photo/<photo>.jpg, credited in _photos.json. */
	photo: string;
	caption: string;
}

export interface GrammarPage {
	heading: string;
	subheading?: string;
	photo?: PhotoRef;
	blocks: LearnBlock[];
	/** A three-item check at the foot of the page. */
	check?: Exercise;
	/** The "Wusstest du?" note of the page. */
	fact?: string;
}

export interface Chapter {
	id: string;
	n: number;
	title: string;
	subtitle: string;
	world: string;
	accent: Accent;
	quiz?: string;
	listenQuiz?: string;
	speakQuiz?: string;
	words: {
		intro: string;
		groups: { title: string; items: WordItem[] }[];
		verbs?: { de: string; en: string }[];
		/** Title of the word tiles on the opener plate ("Auch auf dem Markt · also at the market"). */
		more?: string;
	};
	opener: PhotoRef & {
		questions: string[];
		fact?: string;
		/** Words pinned onto the photo, at x/y per cent of the right-hand page; the rest of the word list goes in the strip below. */
		labels?: (WordItem & { x: number; y: number; side?: 'left' | 'right' })[];
	};
	reading: {
		title: string;
		intro: string;
		photos: PhotoRef[];
		lines: { who?: string; de: string }[];
		en: string;
		fact?: string;
		tasks: Exercise[];
	};
	grammar: GrammarPage[];
	document: PhotoRef & { intro: string; fact?: string; tasks: Exercise[] };
	practise: Exercise[];
	speak?: { intro: string };
	listen?: { intro: string };
	canDo: string[];
}

export interface Book2 {
	courseId: string;
	level: string;
	title: string;
	subtitle: string;
	names?: string[];
	chapters: Chapter[];
}

export interface PhotoCredit {
	title: string;
	author: string;
	license: string;
	source: string;
	width: number;
	height: number;
}

const files = import.meta.glob<{ default: Omit<Book2, 'courseId' | 'level'> }>('/assets/content/book2/*/*.json', { eager: true });
const credits = import.meta.glob<{ default: Record<string, PhotoCredit> }>('/assets/content/book2/*/_photos.json', { eager: true });

export function loadBook2(courseId: string, level: string): Book2 | null {
	const stem = companionStem(level);
	for (const [path, mod] of Object.entries(files)) {
		const m = /\/book2\/([^/]+)\/([^/]+)\.json$/.exec(path);
		if (m && m[1] === courseId && m[2] === stem) return { courseId, level, ...mod.default };
	}
	return null;
}

export function photoCredits(courseId: string): Record<string, PhotoCredit> {
	for (const [path, mod] of Object.entries(credits)) if (path.includes(`/book2/${courseId}/`)) return mod.default;
	return {};
}

/** Every pictured word of the chapter, the opener's pins first, without repeats. */
export function picturedWords(c: Chapter): WordItem[] {
	const seen = new Set<string>();
	const out: WordItem[] = [];
	for (const w of [...(c.opener.labels ?? []), ...c.words.groups.flatMap((g) => g.items)]) {
		const key = w.de.replace(/^(der|die|das) /, '');
		if (!w.image || seen.has(key)) continue;
		seen.add(key);
		out.push(w);
	}
	return out;
}

/** The exercise that closes every practice section: twelve of the chapter's pictures to label with their article. */
export function pictureCheck(c: Chapter): Exercise {
	const words = picturedWords(c).filter((w) => /^(der|die|das) /.test(w.de));
	// Spread over the list, so the check is not just the first group.
	const step = Math.max(1, Math.floor(words.length / 12));
	const picked = words.filter((_, i) => i % step === 0).slice(0, 12);
	return {
		title: 'Bilder-Check',
		instruction: 'Write each word with der, die or das. No peeking at the word page.',
		kind: 'tags',
		items: picked.map((w) => ({ image: w.image!, label: '', answer: w.de }))
	};
}

/** The practice exercises as printed: the authored ones, then the picture check. */
export const practiseOf = (c: Chapter): Exercise[] => [...c.practise, pictureCheck(c)];

/** The exercises of a chapter in page order: reading, grammar checks, document, practice. */
export const chapterExercises = (c: Chapter): { part: string; exercises: Exercise[] }[] => [
	{ part: 'Lesen', exercises: c.reading.tasks },
	{ part: 'Grammatik', exercises: c.grammar.flatMap((g) => (g.check ? [g.check] : [])) },
	{ part: 'Lesen im Alltag', exercises: c.document.tasks },
	{ part: 'Übungen', exercises: practiseOf(c) }
].filter((p) => p.exercises.length);

/** The answer key of a chapter, part by part, numbered as printed. */
export function chapterKey(c: Chapter): { part: string; entries: KeyEntry[] }[] {
	return chapterExercises(c).map(({ part, exercises }) => {
		const spread = { id: `${c.id}-${part}`, practise: exercises } as unknown as Spread;
		return { part, entries: answerKey(spread) };
	});
}

/** Every photo a chapter prints. */
export const photosOf = (c: Chapter): string[] => [
	c.opener.photo,
	...c.reading.photos.map((p) => p.photo),
	...c.grammar.flatMap((g) => (g.photo ? [g.photo.photo] : [])),
	c.document.photo
];
