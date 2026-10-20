// Everything a page needs to describe itself to search engines and social
// cards, in one place — so the canonical host, the organisation, the default
// image and the title shape can never drift between routes.

import type { Quiz, QuizType } from '$lib/content/types';

export const SITE_URL = 'https://languagequiz.org';
export const SITE_NAME = 'Language Quiz';
export const DEFAULT_IMAGE = `${SITE_URL}/og/default.png`;
export const DEFAULT_IMAGE_ALT =
	'Language Quiz - learn German free, A1 to C2, with audio';

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
	speaking: 'speaking practice',
	writing: 'writing task',
	vocabulary: 'vocabulary flashcards',
	suchbild: 'vocabulary picture hunt'
};

/** The name schema.org's learningResourceType expects. */
const RESOURCE_TYPE: Record<QuizType, string> = {
	fillBlank: 'Exercise',
	reading: 'Reading exercise',
	listening: 'Listening exercise',
	dictation: 'Dictation',
	speakRepeat: 'Pronunciation exercise',
	speaking: 'Speaking exercise',
	writing: 'Writing exercise',
	vocabulary: 'Flashcards',
	suchbild: 'Picture vocabulary game'
};

/**
 * A page title with the site name appended when it still fits: a result
 * shows about 60 characters, and what people searched for comes first.
 */
export function titleWithSite(title: string, max = 65): string {
	const full = `${title} | ${SITE_NAME}`;
	return full.length <= max ? full : title;
}

/**
 * Search title for an exercise: the topic first (what people type), then
 * level and kind. Kept near 60 characters, the width a result shows.
 */
export function quizTitle(quiz: Quiz): string {
	const topic = topicOf(quiz.title);
	// There is a deck per sub-level, all called "Wortschatz": the sub-level is
	// what keeps the A1.1 and A1.2 decks from sharing one title.
	const level = quiz.type === 'vocabulary' ? (quiz.level ?? '') : cefrOf(quiz.level);
	const german = `German ${level}`.trim();
	const kind = `${german} ${KIND_LABEL[quiz.type]}`;
	// Longest first; a long topic sheds the site name, then the kind.
	const fits = [`${topic} – ${kind} | ${SITE_NAME}`, `${topic} – ${kind}`, `${topic} – ${german}`];
	const fit = fits.find((t) => t.length <= 70);
	if (fit) return fit;
	// A topic too long on its own ("Adverbialsätze II: konzessiv, konsekutiv, …")
	// keeps its head and as much of its list as fits, cut at a comma or space.
	const room = 70 - ` – ${german}`.length - 1;
	const cut = topic.slice(0, room);
	const at = Math.max(cut.lastIndexOf(','), cut.lastIndexOf(' '));
	return `${(at > 20 ? cut.slice(0, at) : cut).replace(/[\s,:;–-]+$/, '')}… – ${german}`;
}

/** Meta description for an exercise, from the opening of its explanation. */
export function quizDescription(quiz: Quiz): string {
	const intro = quiz.help?.intro;
	const cefr = cefrOf(quiz.level);
	if (intro) {
		const opening = `${cefr}: ${lead(intro, 150)}`;
		// One short sentence is too thin for a result snippet: say what the page offers.
		if (opening.length >= 100) return clip(opening);
		// Padding is added whole or not at all: clipped, it would end "…examples and…".
		const padded = `${opening} Free ${KIND_LABEL[quiz.type]} with rules, examples and audio.`.replace(/\s+/g, ' ');
		return padded.length <= 155 ? padded : clip(opening);
	}
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
/**
 * schema.org accessibility metadata (the W3C/DAISY vocabulary): what the
 * course does for screen readers, keyboards and learners who need more time.
 * Only claims what the app actually does — see the About page's
 * accessibility note, which says the same in prose.
 */
const ACCESSIBILITY = {
	accessibilityAPI: ['ARIA'],
	accessibilityControl: ['fullKeyboardControl', 'fullMouseControl', 'fullTouchControl'],
	accessibilityFeature: [
		'ARIA',
		'alternativeText',
		'displayTransformability',
		'readingOrder',
		'structuralNavigation',
		'timingControl'
	],
	accessibilityHazard: ['noFlashingHazard', 'noMotionSimulationHazard', 'noSoundHazard'],
	accessibilitySummary:
		'Aims at WCAG 2.2 AA. Works with a keyboard and screen readers: answers, corrections and results are announced, and German text is marked as German so it is read in a German voice. No time limits ("Wait for me" setting), optional text for listening exercises, reduced motion on request, and text that meets contrast guidelines.'
};

/** Exercises built on audio: the text is the alternative a learner can switch on. */
const AUDIO_TYPES = new Set<QuizType>(['listening', 'dictation', 'speakRepeat']);

function accessibilityOf(type?: QuizType) {
	const audio = !!type && AUDIO_TYPES.has(type);
	return {
		accessMode: audio ? ['textual', 'auditory', 'visual'] : ['textual', 'visual'],
		accessModeSufficient: audio
			? [
					{ '@type': 'ItemList', itemListElement: ['auditory', 'textual'], description: 'Audio with on-screen text' },
					{ '@type': 'ItemList', itemListElement: ['textual'], description: 'Text only, with "Show the text" switched on' }
				]
			: [{ '@type': 'ItemList', itemListElement: ['textual'], description: 'Text only' }],
		...ACCESSIBILITY,
		accessibilityFeature: audio
			? [...ACCESSIBILITY.accessibilityFeature, 'transcript']
			: ACCESSIBILITY.accessibilityFeature
	};
}

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
		// The course as a whole includes listening, so it is described with audio.
		...accessibilityOf('listening'),
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
		...accessibilityOf(quiz.type),
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

/** What a "Schreib mir!" chat page needs to describe itself. */
export type ChatSeo = { id: string; name: string; level: string; goal: string; focus?: string };

/**
 * Search title for one chat: who and what first, then the level. The
 * game's own name goes last, as the part a searcher is least likely to type.
 */
export function chatTitle(chat: ChatSeo): string {
	const fits = [
		`Chat with ${chat.name} in German (${chat.level}) – Schreib mir! | ${SITE_NAME}`,
		`Chat with ${chat.name} in German (${chat.level}) – Schreib mir!`,
		`Chat with ${chat.name} in German (${chat.level})`
	];
	return fits.find((t) => t.length <= 70) ?? fits[fits.length - 1];
}

/**
 * Meta description for a chat: the goal is the hook, so it leads; the
 * level and how the game is played follow while they fit.
 */
export function chatDescription(chat: ChatSeo): string {
	const opening = `German ${chat.level} chat game. Your goal: ${chat.goal}`;
	const padded = `${opening} Build each answer from word tiles, free.`.replace(/\s+/g, ' ');
	return padded.length <= 155 ? padded : clip(opening);
}

/**
 * A browser game that teaches: a LearningResource that is also a Game, so
 * the play pages can surface for the game and for the German they drill.
 */
export function gameLd(game: { name: string; description: string; path: string; level?: string; teaches?: string }) {
	return {
		'@context': 'https://schema.org',
		'@type': ['LearningResource', 'Game'],
		name: game.name,
		description: game.description,
		url: absoluteUrl(game.path),
		inLanguage: ['en', 'de'],
		learningResourceType: 'Game',
		educationalLevel: game.level ? `CEFR ${cefrOf(game.level)}` : undefined,
		teaches: game.teaches ?? 'German',
		about: { '@type': 'Thing', name: 'German language' },
		isAccessibleForFree: true,
		interactivityType: 'active',
		educationalUse: 'practice',
		provider: ORGANIZATION
	};
}

/**
 * An annotated edition on the literature shelf: a Book whose free PDF is
 * the offer. `workExample` is this edition; the book itself is the author's.
 */
export function bookLd(book: {
	id: string;
	author: string;
	title: string;
	en: string;
	year: number;
	level: string;
	blurb: string;
	pdf: { href: string; pages: number };
	cover: string;
}) {
	return {
		'@context': 'https://schema.org',
		'@type': 'Book',
		name: book.title,
		alternateName: book.en,
		author: { '@type': 'Person', name: book.author },
		datePublished: String(book.year),
		inLanguage: 'de',
		description: book.blurb,
		image: absoluteUrl(book.cover),
		url: absoluteUrl(`/literature#${book.id}`),
		educationalLevel: `CEFR ${book.level}`,
		isAccessibleForFree: true,
		workExample: {
			'@type': 'Book',
			name: `${book.title}, annotated for English speakers`,
			bookFormat: 'https://schema.org/EBook',
			inLanguage: ['de', 'en'],
			numberOfPages: book.pdf.pages,
			publisher: ORGANIZATION,
			isAccessibleForFree: true,
			encoding: { '@type': 'MediaObject', contentUrl: absoluteUrl(book.pdf.href), encodingFormat: 'application/pdf' },
			offers: { '@type': 'Offer', price: '0', priceCurrency: 'EUR', availability: 'https://schema.org/InStock' }
		}
	};
}

/**
 * A book read online in stages: the Book, each stage a Chapter of it, so a
 * result can show the parts and a stage page is known to belong to the book.
 */
export function readingBookLd(
	book: { author: string; title: string; en: string; year: number; level: string; blurb: string; cover: string },
	path: string,
	stages: { name: string; path: string }[]
) {
	return {
		'@context': 'https://schema.org',
		'@type': 'Book',
		name: book.title,
		alternateName: book.en,
		author: { '@type': 'Person', name: book.author },
		datePublished: String(book.year),
		inLanguage: 'de',
		description: book.blurb,
		image: absoluteUrl(book.cover),
		url: absoluteUrl(path),
		educationalLevel: `CEFR ${book.level}`,
		isAccessibleForFree: true,
		publisher: ORGANIZATION,
		hasPart: stages.map((s, i) => ({
			'@type': 'Chapter',
			position: i + 1,
			name: s.name,
			url: absoluteUrl(s.path)
		}))
	};
}

/** One reading stage of a book, as a Chapter that is also a learning resource. */
export function readingStageLd(stage: {
	name: string;
	description: string;
	path: string;
	position: number;
	level: string;
	words: number;
	book: { author: string; title: string; path: string };
}) {
	return {
		'@context': 'https://schema.org',
		'@type': ['Chapter', 'LearningResource'],
		name: stage.name,
		description: stage.description,
		url: absoluteUrl(stage.path),
		position: stage.position,
		inLanguage: ['de', 'en'],
		wordCount: stage.words,
		learningResourceType: 'Reading',
		educationalLevel: `CEFR ${stage.level}`,
		about: { '@type': 'Thing', name: 'German language' },
		isAccessibleForFree: true,
		author: { '@type': 'Person', name: stage.book.author },
		publisher: ORGANIZATION,
		isPartOf: { '@type': 'Book', name: stage.book.title, url: absoluteUrl(stage.book.path) }
	};
}

/** A page that lists things (stories, books): an ItemList of links. */
export function itemListLd(name: string, items: { name: string; path: string }[]) {
	return {
		'@context': 'https://schema.org',
		'@type': 'ItemList',
		name,
		itemListElement: items.map((it, i) => ({
			'@type': 'ListItem',
			position: i + 1,
			name: it.name,
			url: absoluteUrl(it.path)
		}))
	};
}

/** What a song page needs to describe itself: the registry's Song, loosely. */
export type SongSeo = {
	title: string;
	level: string;
	tagline: string;
	teaches: string[];
	href: string;
	courseId: string;
};

/**
 * Search title for a sing-along. The song's name comes first — it is what
 * someone who heard it types — then what the page is and the level.
 */
export function songTitle(song: SongSeo): string {
	return titleWithSite(`${song.title} — German sing-along (${song.level})`, 70);
}

/**
 * Meta description for a sing-along: the tagline, then what the page holds.
 * Clipped, because a tagline is written for the card, not for a result.
 */
export function songDescription(song: SongSeo): string {
	const opening = `German ${cefrOf(song.level)} sing-along. ${song.tagline}`;
	const padded = `${opening} Recording, lyrics and translations, free.`.replace(/\s+/g, ' ');
	return padded.length <= 155 ? padded : clip(opening);
}

/**
 * A sing-along as structured data: a recording that is also a learning
 * resource, so it can surface for the song as well as for the grammar it
 * drills. Songs carry no score, hence `interactivityType: 'mixed'`.
 */
export function songLd(song: SongSeo, courseName: string) {
	return {
		'@context': 'https://schema.org',
		'@type': ['LearningResource', 'MusicRecording'],
		name: song.title,
		description: songDescription(song),
		url: absoluteUrl(song.href),
		inLanguage: ['en', 'de'],
		learningResourceType: 'Song',
		educationalLevel: `CEFR ${cefrOf(song.level)}`,
		teaches: song.teaches,
		about: { '@type': 'Thing', name: 'German language' },
		isAccessibleForFree: true,
		interactivityType: 'mixed',
		educationalUse: 'practice',
		...accessibilityOf('listening'),
		provider: ORGANIZATION,
		isPartOf: {
			'@type': 'Course',
			name: courseName,
			url: absoluteUrl(`/course/${song.courseId}`)
		}
	};
}
