import { MATCH_CHATS } from '$lib/domain/matchChat';
import { courses, loadCourse } from '$lib/content';
import { SITE_URL } from '$lib/seo';
import { coursePaths, DICTIONARY_PATH, lastModified, SHARED_WORD_PATHS } from '$lib/server/lastmod';
import { nouns, verbs } from '$lib/server/words';
import { wordSlug } from '$lib/domain/words';
import { SONGS } from '$lib/domain/songs';
import { LITERATURE } from '$lib/content/literature';
import { kafkaStages } from '$lib/server/kafka';
import type { RequestHandler } from './$types';

export const prerender = true;

/**
 * A real sitemap, generated from the content rather than hand-maintained.
 * Each URL's <lastmod> is the date of the last commit that touched the
 * content it is built from, so a crawler can tell what actually changed
 * rather than seeing every page "updated" on every deploy.
 */
export const GET: RequestHandler = async () => {
	const today = lastModified('src/routes/+page.svelte', 'src/routes/+page.server.ts');
	const wordsDate = lastModified(...SHARED_WORD_PATHS);
	const urls: { loc: string; lastmod: string; priority: string }[] = [
		{ loc: '/', lastmod: today, priority: '1.0' },
		{ loc: '/changelog', lastmod: lastModified('src/lib/content/changelog.ts'), priority: '0.4' },
		{ loc: '/about', lastmod: lastModified('src/routes/about'), priority: '0.5' },
		{ loc: '/contact', lastmod: lastModified('src/routes/contact'), priority: '0.3' },
		{ loc: '/legal', lastmod: lastModified('src/routes/legal'), priority: '0.2' },
		{ loc: '/songs', lastmod: lastModified('src/lib/domain/songs.ts'), priority: '0.6' },
		{ loc: '/stories', lastmod: lastModified('src/lib/domain/stories.ts'), priority: '0.6' },
		{ loc: '/literature', lastmod: lastModified('src/lib/content/literature.ts'), priority: '0.6' },
		{ loc: '/level-check', lastmod: lastModified('src/routes/level-check'), priority: '0.7' },
		{ loc: '/level-check/test', lastmod: lastModified('src/routes/level-check/test', 'src/lib/domain/placement.ts'), priority: '0.7' },
		{ loc: '/level-check/words', lastmod: lastModified('src/routes/level-check', 'assets/content/wordcheck/de.json'), priority: '0.7' },
		// The boards' front page; the topics themselves load live and stay noindex.
		{ loc: '/forum', lastmod: lastModified('src/routes/forum'), priority: '0.4' },
		{ loc: '/words', lastmod: wordsDate, priority: '0.6' },
		{ loc: '/words/nouns', lastmod: wordsDate, priority: '0.7' },
		{ loc: '/words/verbs', lastmod: wordsDate, priority: '0.7' },
		{ loc: '/words/dictionary', lastmod: lastModified(DICTIONARY_PATH), priority: '0.7' }
	];

	// The annotated editions themselves: a search engine indexes a PDF's text,
	// so "Die Verwandlung with English notes" can land straight on the book.
	for (const book of LITERATURE) {
		urls.push({ loc: book.pdf.href, lastmod: lastModified(`static${book.pdf.href}`), priority: '0.5' });
		// The book read online: its front page and one page per stage.
		if (book.read) {
			const lastmod = lastModified('assets/reference', 'src/routes/literature');
			urls.push({ loc: book.read, lastmod, priority: '0.6' });
			for (const stage of kafkaStages()) urls.push({ loc: `${book.read}/stage-${stage.n}`, lastmod, priority: '0.5' });
		}
	}

	for (const card of courses) {
		const lastmod = lastModified(...coursePaths(card.id));
		urls.push({ loc: `/course/${card.id}`, lastmod, priority: '0.9' });
		const course = await loadCourse(card.id);
		// The level syllabus pages: the densest overview text on the site.
		for (const group of course.nav.groups) {
			if (group.type === 'questChain' && group.level) {
				urls.push({ loc: `/course/${card.id}/level/${group.level}`, lastmod, priority: '0.8' });
			}
		}
		for (const quiz of course.quizzes) {
			urls.push({ loc: `/course/${card.id}/quiz/${quiz.id}`, lastmod, priority: '0.7' });
		}
	}

	// The sing-along pages. Story episodes are deliberately absent: they are
	// noindex, because an episode read out of the course spoils itself.
	for (const song of SONGS) {
		urls.push({
			loc: song.href,
			lastmod: lastModified('src/lib/domain/songs.ts'),
			priority: '0.6'
		});
	}

	urls.push({ loc: '/play/ja-nein', lastmod: lastModified('src/lib/domain/janein.ts'), priority: '0.6' });
	urls.push({ loc: '/play/ja-nein/personas', lastmod: lastModified('src/lib/domain/janeinRounds.ts'), priority: '0.4' });
	urls.push({ loc: '/play/schreib-mir', lastmod: lastModified('src/lib/domain/matchChat.ts'), priority: '0.6' });
	for (const chat of MATCH_CHATS.filter((c) => !c.hidden))
		urls.push({ loc: `/play/schreib-mir/${chat.id}`, lastmod: lastModified(`assets/content/match/${chat.id}.json`), priority: '0.5' });

	for (const n of nouns) {
		urls.push({ loc: `/words/nouns/${wordSlug(n.noun)}`, lastmod: wordsDate, priority: '0.5' });
	}
	for (const v of verbs) {
		urls.push({ loc: `/words/verbs/${wordSlug(v.verb)}`, lastmod: wordsDate, priority: '0.5' });
	}

	const entries = urls
		.map(
			(u) =>
				`  <url>\n    <loc>${SITE_URL}${u.loc}</loc>\n    <lastmod>${u.lastmod}</lastmod>\n    <priority>${u.priority}</priority>\n  </url>`
		)
		.join('\n');

	const body =
		'<?xml version="1.0" encoding="UTF-8"?>\n' +
		'<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n' +
		entries +
		'\n</urlset>';

	return new Response(body, { headers: { 'Content-Type': 'application/xml' } });
};
