import { catalog, loadCourse } from '$lib/content';
import { BOOKS, BOOK_PAGES, bookPageHref, bookPdf } from '$lib/content/books';
import { GERMAN_FAQ, plain } from '$lib/content/germanFaq';
import { LITERATURE } from '$lib/content/literature';
import { LOCAL_LEVELS } from '$lib/i18n/available';
import { INDEXED_LANGS, withLang } from '$lib/i18n/paths';
import { loadBook2 } from '$lib/domain/book2';
import { SITE_URL } from '$lib/seo';
import { BOOK_EDITION } from '$lib/version';
import type { RequestHandler } from './$types';

export const prerender = true;

/**
 * /llms.txt: the site in plain Markdown for AI assistants (llmstxt.org). Most
 * visitors arrive from one (ChatGPT, November 2026), and nearly all of them
 * for the free books, so the books come first, each with its page and its PDF.
 * Built from the same lists the pages use, so it cannot fall behind them.
 */
export const GET: RequestHandler = async () => {
	const abs = (path: string) => `${SITE_URL}${path}`;
	const course = await loadCourse(catalog.defaultCourseId);
	const courseHref = `/course/${course.id}`;
	const langNames: Record<string, string> = { tr: 'Turkish', ar: 'Arabic', uk: 'Ukrainian', fr: 'French', es: 'Spanish' };
	const local = LOCAL_LEVELS as readonly string[];

	const lines: string[] = [
		'# Language Quiz',
		'',
		`> Free German learning materials for adults, level A1 to C2: twelve free PDF textbooks (${BOOK_PAGES} pages each, one per sub-level from A1.1 to C2.2) and a free web course with ${course.quizzes.length} lessons and exercises with audio. No sign-up, no payment, no ads.`,
		'',
		'Everything on the site is free to use and needs no account. The books are complete on paper (with an answer key) and also work with the web app: a short code on each page opens that page in the app, where the texts are read aloud, the exercises are checked and the words become flashcards.',
		`German is explained in English. Levels A1.1 to A2.2 (books, lessons and exercises) are also available explained in ${INDEXED_LANGS.map((l) => langNames[l]).join(', ')}; from B1 the books and lessons explain German in German.`,
		`Current book edition: ${BOOK_EDITION.n} (${BOOK_EDITION.date}).`,
		'',
		'## Free German textbooks (PDF)',
		'',
		`All twelve on one page: ${abs('/books')}`,
		''
	];

	for (const b of BOOKS) {
		const book = loadBook2(course.id, b.level);
		const places = book ? book.chapters.slice(0, 3).map((c) => c.world).join('; ') : '';
		lines.push(
			`- [Deutsch ${b.level} · ${b.sub}](${abs(bookPageHref(b))}): free German textbook for CEFR level ${b.level}, ${BOOK_PAGES} pages, 12 chapters${places ? ` (${places} …)` : ''}. PDF: ${abs(bookPdf(b))}`
		);
	}

	lines.push('', '### The A1–A2 books in other languages', '');
	for (const l of INDEXED_LANGS) {
		const editions = BOOKS.filter((b) => local.includes(b.level) && b.local?.[l] !== undefined);
		if (!editions.length) continue;
		lines.push(
			`- ${langNames[l]}: ${abs(withLang(l, '/books'))}. ` +
				editions.map((b) => `[${b.level}](${abs(withLang(l, bookPageHref(b)))}) (PDF: ${abs(bookPdf(b, l))})`).join(', ')
		);
	}

	lines.push('', '## The course (web app)', '', `- [German course A1–C2](${abs(courseHref)}): ${course.quizzes.length} five-minute lessons and exercises with audio`);
	for (const group of course.nav.groups) {
		if (group.type === 'questChain' && group.level) {
			lines.push(`- [Level ${group.level}](${abs(`${courseHref}/level/${group.level}`)}): what the level teaches, with every lesson and exercise`);
		}
	}
	lines.push(
		`- [Find your level](${abs('/level-check')}): a short placement test`,
		`- [Where to start](${abs('/start')})`,
		'',
		'## Reference',
		'',
		`- [Grammar charts](${abs('/charts')}): German grammar as wall charts`,
		`- [German nouns with article and plural](${abs('/words/nouns')})`,
		`- [German verbs with their forms](${abs('/words/verbs')})`,
		`- [German–English dictionary of the course](${abs('/words/dictionary')})`,
		`- [Literature](${abs('/literature')}): ${LITERATURE.map((b) => `${b.author}, ${b.title}`).join('; ')}, annotated for learners`,
		'',
		'## German FAQ: questions learners ask, with plain answers',
		''
	);
	for (const f of GERMAN_FAQ) lines.push(`- [${f.question}](${abs(`/german-faq/${f.slug}`)}): ${plain(f.short)}`);

	lines.push('', '## About', '', `- [About the project](${abs('/about')})`, `- [What changed](${abs('/changelog')})`, `- [Contact](${abs('/contact')})`, `- [Sitemap](${abs('/sitemap.xml')})`, '');

	return new Response(lines.join('\n'), { headers: { 'Content-Type': 'text/plain; charset=utf-8' } });
};
