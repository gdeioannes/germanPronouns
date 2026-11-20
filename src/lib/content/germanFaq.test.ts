// German FAQ gate: every page links to real exercises and real questions,
// slugs are unique, and the short answer stays short enough to be quoted
// whole by a search result.
import { describe, expect, it } from 'vitest';
import course from '$content/courses/de_cert_a1.json';
import verbData from '$content/shared/verbs/de.json';
import nounData from '$content/shared/nouns/de.json';
import { wordSlug } from '$lib/domain/words';
import { FAQ_GROUPS, GERMAN_FAQ, faqRuns, findFaq, plain, quizLevel, searchFaq } from './germanFaq';

const bundle = course as unknown as { quizzes: { id: string }[]; nav: { groups: { level?: string }[] } };
const quizIds = new Set(bundle.quizzes.map((q) => q.id));
const levels = new Set(bundle.nav.groups.map((g) => g.level).filter(Boolean));
const verbSlugs = new Set((verbData as { verbs: { verb: string }[] }).verbs.map((v) => wordSlug(v.verb)));
const nounSlugs = new Set((nounData as { nouns: { noun: string }[] }).nouns.map((n) => wordSlug(n.noun)));

/** The site pages a "More help" link may point at. */
const STATIC_PAGES = new Set([
	'/words',
	'/words/nouns',
	'/words/verbs',
	'/words/dictionary',
	'/books',
	'/literature',
	'/level-check',
	'/start',
	'/stories',
	'/play/wortbloecke',
	'/play/schreib-mir',
	'/play/ja-nein',
	'{course}/worksheet'
]);

function linkExists(href: string): boolean {
	if (STATIC_PAGES.has(href)) return true;
	const level = href.match(/^\{course\}\/level\/(.+)$/);
	if (level) return levels.has(level[1]);
	const verb = href.match(/^\/words\/verbs\/(.+)$/);
	if (verb) return verbSlugs.has(verb[1]);
	const noun = href.match(/^\/words\/nouns\/(.+)$/);
	if (noun) return nounSlugs.has(noun[1]);
	return false;
}

describe('German FAQ', () => {
	it('has unique, URL-safe slugs', () => {
		const slugs = GERMAN_FAQ.map((f) => f.slug);
		expect(new Set(slugs).size).toBe(slugs.length);
		for (const s of slugs) expect(s).toMatch(/^[a-z0-9]+(-[a-z0-9]+)*$/);
	});

	it('has 36 questions, every group filled', () => {
		expect(GERMAN_FAQ.length).toBe(36);
		for (const g of FAQ_GROUPS) expect(GERMAN_FAQ.some((f) => f.group === g.id), g.id).toBe(true);
	});

	it.each(GERMAN_FAQ.map((f) => [f.slug, f] as const))('%s links to real exercises, pages and questions', (_, f) => {
		expect(f.practice.length).toBeGreaterThanOrEqual(4);
		for (const p of f.practice) {
			expect(quizIds, `${f.slug} → ${p.quiz}`).toContain(p.quiz);
			expect(quizLevel(p.quiz), p.quiz).toMatch(/^[ABC][12]\.[12]$/);
		}
		expect(new Set(f.practice.map((p) => p.quiz)).size).toBe(f.practice.length);
		expect(f.more.length).toBeGreaterThan(0);
		for (const m of f.more) expect(linkExists(m.href), `${f.slug} → ${m.href}`).toBe(true);
		for (const r of f.related) {
			expect(r).not.toBe(f.slug);
			expect(findFaq(r), `${f.slug} → ${r}`).toBeDefined();
		}
		expect(FAQ_GROUPS.map((g) => g.id)).toContain(f.group);
	});

	it.each(GERMAN_FAQ.map((f) => [f.slug, f] as const))('%s has a quotable short answer', (_, f) => {
		const text = plain(f.short);
		expect(text.length).toBeGreaterThan(100);
		expect(text.length).toBeLessThanOrEqual(320);
		expect(f.question, 'phrased as a question').toContain('?');
	});

	it('search finds questions by any spelling of umlauts and ß', () => {
		const top = (q: string) => searchFaq(q)[0]?.slug;
		expect(top('madchen')).toBe('why-is-it-das-maedchen');
		expect(top('Mädchen')).toBe('why-is-it-das-maedchen');
		expect(top('eszett')).toBe('what-is-the-german-ss-eszett');
		expect(top('strasse')).toBeDefined();
		expect(top('halb drei')).toBe('halb-drei-telling-time-in-german');
		expect(searchFaq('Perfekt').map((f) => f.slug)).toContain('haben-or-sein-in-the-perfekt');
		expect(searchFaq('   ')).toEqual([]);
		expect(searchFaq('xylophonzebra')).toEqual([]);
	});

	it('has balanced German markup everywhere', () => {
		const texts = GERMAN_FAQ.flatMap((f) => [
			f.short,
			...f.body.flatMap((b) => [...(b.p ?? []), ...(b.list ?? []), ...(b.table?.rows.flat() ?? [])])
		]);
		for (const t of texts) {
			expect((t.match(/\*/g) ?? []).length % 2, t).toBe(0);
			expect(faqRuns(t).map((r) => r.text).join('')).toBe(plain(t));
		}
	});
});
