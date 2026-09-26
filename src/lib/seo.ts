// Everything a page needs to describe itself to search engines and social
// cards, in one place — so the canonical host, the organisation, the default
// image and the title shape can never drift between routes.

import type { Quiz, QuizType } from '$lib/content/types';

export const SITE_URL = 'https://languagequiz.org';
export const SITE_NAME = 'Language Quiz';
export const DEFAULT_IMAGE = `${SITE_URL}/og-image.png`;
export const DEFAULT_IMAGE_ALT = 'Language Quiz - a free interactive German course';

/**
 * The language of the interface. Every page is in English today; the
 * plumbing (html lang, og:locale, hreflang) reads this one table so a
 * translated set of routes only has to add a row.
 */
export const DEFAULT_LANG = 'en';
export const LOCALES: Record<string, { ogLocale: string }> = {
	en: { ogLocale: 'en_GB' },
	de: { ogLocale: 'de_DE' },
	es: { ogLocale: 'es_ES' },
	zh: { ogLocale: 'zh_CN' }
};

/** One translated twin of a page, for its hreflang link. */
export type Alternate = { lang: string; path: string };

/** The publisher, as schema.org wants it named on every page. */
export const ORGANIZATION = {
	'@type': 'Organization',
	name: SITE_NAME,
	url: SITE_URL,
	logo: `${SITE_URL}/icons/Icon-512.png`
} as const;

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

/**
 * The share image for a page. One is drawn per CEFR level and per exercise
 * kind (tool/og-images.mjs writes them to static/og/), so a shared quiz link
 * previews as "A1 · Reading" rather than as the generic site card.
 */
export function shareImage(kind: 'level' | 'type' | 'words', key: string): string {
	return `${SITE_URL}/og/${kind}-${key.toLowerCase().replace(/[^a-z0-9]+/g, '-')}.png`;
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

/** The site itself, once, on the home page. */
export function websiteLd() {
	return {
		'@context': 'https://schema.org',
		'@type': 'WebSite',
		name: SITE_NAME,
		url: SITE_URL,
		inLanguage: DEFAULT_LANG,
		publisher: ORGANIZATION
	};
}

/** A course, as the home page and the course page both describe it. */
export function courseLd(course: { id: string; name: string; tagline: string }, extra: object = {}) {
	return {
		'@context': 'https://schema.org',
		'@type': 'Course',
		name: course.name,
		description: course.tagline,
		url: absoluteUrl(`/course/${course.id}`),
		educationalLevel: 'CEFR A1–C2',
		inLanguage: DEFAULT_LANG,
		teaches: 'German',
		isAccessibleForFree: true,
		provider: ORGANIZATION,
		offers: { '@type': 'Offer', price: '0', priceCurrency: 'EUR', category: 'Free' },
		hasCourseInstance: {
			'@type': 'CourseInstance',
			courseMode: 'online',
			courseWorkload: 'PT10M'
		},
		...extra
	};
}

/**
 * An exercise: a LearningResource that is also a schema.org Quiz, since
 * every one of them is answered rather than just read.
 */
export function learningResourceLd(quiz: Quiz, path: string, courseName: string, coursePath: string) {
	const cefr = cefrOf(quiz.level);
	return {
		'@context': 'https://schema.org',
		'@type': ['LearningResource', 'Quiz'],
		name: topicOf(quiz.title),
		description: quizDescription(quiz),
		url: absoluteUrl(path),
		inLanguage: ['en', 'de'],
		learningResourceType: RESOURCE_TYPE[quiz.type],
		educationalLevel: cefr ? `CEFR ${cefr}` : undefined,
		teaches: topicOf(quiz.title),
		about: { '@type': 'Thing', name: 'German language' },
		isAccessibleForFree: true,
		interactivityType: 'active',
		educationalUse: 'practice',
		provider: ORGANIZATION,
		isPartOf: { '@type': 'Course', name: courseName, url: absoluteUrl(coursePath) }
	};
}

/** A dictionary entry (a noun or verb page) as a DefinedTerm. */
export function definedTermLd(term: {
	name: string;
	description: string;
	path: string;
	setPath: string;
	setName: string;
}) {
	return {
		'@context': 'https://schema.org',
		'@type': 'DefinedTerm',
		name: term.name,
		description: term.description,
		url: absoluteUrl(term.path),
		inLanguage: 'de',
		inDefinedTermSet: {
			'@type': 'DefinedTermSet',
			name: term.setName,
			url: absoluteUrl(term.setPath)
		}
	};
}
