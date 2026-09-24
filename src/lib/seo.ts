// Everything a page needs to describe itself to search engines and social
// cards, in one place — so the canonical host, the default image and the
// title shape can never drift between routes.

import type { Quiz, QuizType } from '$lib/content/types';

export const SITE_URL = 'https://languagequiz.org';
export const SITE_NAME = 'Language Quiz';
export const DEFAULT_IMAGE = `${SITE_URL}/og-image.png`;
export const DEFAULT_IMAGE_ALT = 'Language Quiz - a free interactive German course';

/** Absolute URL for a site path, the same form the sitemap lists. */
export function absoluteUrl(path: string): string {
	if (/^https?:/.test(path)) return path;
	return SITE_URL + (path.startsWith('/') ? path : `/${path}`);
}

/**
 * Cuts text to a meta-description length on a word boundary. Search results
 * show roughly 155 characters; anything longer is truncated mid-word by them.
 */
export function clip(text: string, max = 155): string {
	const clean = text.replace(/\s+/g, ' ').trim();
	if (clean.length <= max) return clean;
	const cut = clean.slice(0, max - 1);
	const at = cut.lastIndexOf(' ');
	return `${(at > 60 ? cut.slice(0, at) : cut).replace(/[,;:.\s—–-]+$/, '')}…`;
}

/** The first sentence or two of a text, up to a description's length. */
export function lead(text: string, max = 155): string {
	const sentences = text.replace(/\s+/g, ' ').trim().match(/[^.!?]+[.!?]+/g) ?? [text];
	let out = '';
	for (const s of sentences) {
		if ((out + s).trim().length > max) break;
		out += s;
	}
	return out.trim() || clip(text, max);
}

/** "A1.1 · Artikel im Nominativ" → "Artikel im Nominativ". */
export function topicOf(title: string): string {
	return title.replace(/^[ABC][12](?:\.\d)?\s*·\s*/, '').trim();
}

/** "A1.1" → "A1". */
export function cefrOf(level: string | undefined): string {
	return (level ?? '').slice(0, 2);
}

const KIND_LABEL: Record<QuizType, string> = {
	fillBlank: 'exercise',
	reading: 'reading exercise',
	listening: 'listening exercise',
	dictation: 'dictation',
	speakRepeat: 'pronunciation practice',
	speaking: 'speaking practice'
};

/** The name schema.org's learningResourceType expects. */
const RESOURCE_TYPE: Record<QuizType, string> = {
	fillBlank: 'Exercise',
	reading: 'Reading exercise',
	listening: 'Listening exercise',
	dictation: 'Dictation',
	speakRepeat: 'Pronunciation exercise',
	speaking: 'Speaking exercise'
};

/**
 * Search title for an exercise: the topic first (what people type), then
 * level and kind. Kept near 60 characters, the width a result shows.
 */
export function quizTitle(quiz: Quiz): string {
	const topic = topicOf(quiz.title);
	const cefr = cefrOf(quiz.level);
	const tail = `German ${cefr} ${KIND_LABEL[quiz.type]}`.replace(/\s+/g, ' ');
	const full = `${topic} – ${tail} | ${SITE_NAME}`;
	return full.length <= 70 ? full : `${topic} – ${tail}`;
}

/** Meta description for an exercise, from the opening of its explanation. */
export function quizDescription(quiz: Quiz): string {
	const intro = quiz.help?.intro;
	const cefr = cefrOf(quiz.level);
	if (intro) return clip(`${cefr}: ${lead(intro, 150)}`);
	return clip(
		`Free German ${cefr} ${KIND_LABEL[quiz.type]}: ${topicOf(quiz.title)}. Rules, examples and audio, no sign-up.`
	);
}

export type Crumb = { name: string; path: string };

export function breadcrumbLd(crumbs: Crumb[]) {
	return {
		'@context': 'https://schema.org',
		'@type': 'BreadcrumbList',
		itemListElement: crumbs.map((c, i) => ({
			'@type': 'ListItem',
			position: i + 1,
			name: c.name,
			item: absoluteUrl(c.path)
		}))
	};
}

export function learningResourceLd(quiz: Quiz, path: string, courseName: string, coursePath: string) {
	const cefr = cefrOf(quiz.level);
	return {
		'@context': 'https://schema.org',
		'@type': 'LearningResource',
		name: topicOf(quiz.title),
		description: quizDescription(quiz),
		url: absoluteUrl(path),
		inLanguage: ['en', 'de'],
		learningResourceType: RESOURCE_TYPE[quiz.type],
		educationalLevel: cefr ? `CEFR ${cefr}` : undefined,
		teaches: topicOf(quiz.title),
		isAccessibleForFree: true,
		interactivityType: 'active',
		provider: { '@type': 'Organization', name: SITE_NAME, url: SITE_URL },
		isPartOf: { '@type': 'Course', name: courseName, url: absoluteUrl(coursePath) }
	};
}
