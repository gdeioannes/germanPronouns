<script lang="ts">
	// One book's own page: the cover, what it is (free, PDF, which level), its
	// twelve chapters with their places and grammar, how the paper and the app
	// work together, and the questions people ask before they download. The
	// page a search or an AI answer for "free German A1 textbook PDF" lands on;
	// /books stays the shelf of all twelve.
	//
	// In a second language the A1–A2 books have this page at their own address
	// (/ar/books/a1-1), with that edition's PDF and cover and the chapters from
	// the level's overlay; B1–C2 open as the books are, German with this page's
	// own lines translated.
	import { page } from '$app/state';
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { BOOKS, BOOK_PAGES, bookCover, bookMb, bookPdf, bookReadHref, bookSlug, hasLocalPdf } from '$lib/content/books';
	import { BOOK_EDITION } from '$lib/version';
	import { lang } from '$lib/i18n/lang.svelte';
	import { t } from '$lib/i18n/t';
	import { levelTranslated } from '$lib/i18n/available';
	import { inLangBookFront, inLangChapter } from '$lib/i18n/content.svelte';
	import { feedback } from '$lib/state/feedback.svelte';
	import { trackBookDownload } from '$lib/services/analytics';
	import { ORGANIZATION, absoluteUrl, breadcrumbLd, cefrOf, titleWithSite } from '$lib/seo';

	let { data } = $props();

	const courseHref = $derived(page.data.site?.courseHref ?? '/');
	const book = $derived(BOOKS.find((b) => bookSlug(b) === data.slug)!);
	const level = $derived(book.level);
	const name = $derived(`Deutsch ${level} · ${book.sub}`);
	const cefr = $derived(cefrOf(level));
	const path = $derived(`/books/${data.slug}`);
	// A1–A2 explain German in the reader's language; from B1 the book is all German.
	const beginner = $derived(levelTranslated(level));

	// The book's own wording, through the level's overlay in a second language.
	const cover = $derived(inLangBookFront({ cover: data.cover }, level).cover);
	const chapters = $derived(data.chapters.map((c) => inLangChapter(c, level)));
	const badge = $derived(cover.badge ?? t('for complete beginners'));
	const lede = $derived(
		cover.lede ??
			t('A Späti at midnight. A market in Munich. A flat in Prenzlauer Berg, Sunday cake at Oma’s, the fish market at five in the morning. Twelve chapters, twelve real places, and the German you need in each of them.')
	);
	const realRaw = $derived(cover.real ?? t('A price board, a doorbell, a menu, a form at the Bürgeramt'));
	// Mid-sentence here; English lowers its first letter, other scripts and Turkish's İ are left alone.
	const real = $derived(lang.limited ? realRaw : realRaw.charAt(0).toLowerCase() + realRaw.slice(1));

	const pdf = $derived(bookPdf(book, lang.current));
	const mb = $derived(bookMb(book, lang.current));
	const coverImg = $derived(bookCover(book, lang.current));
	const readHref = $derived(bookReadHref(courseHref, book));

	const places = $derived(chapters.slice(0, 4).map((c) => c.world).join('; '));
	const description = $derived(
		t('{name}: a free {pages}-page German textbook (PDF) for level {level}. Twelve chapters, each a real place, with stories, grammar, audio and exercises. No sign-up.', {
			name,
			pages: BOOK_PAGES,
			level
		})
	);

	const faqs = $derived([
		{
			q: t('Is Deutsch {level} really free?', { level }),
			a: t('Yes. The whole book is a free PDF: all {pages} pages, twelve chapters and the answer key. There is nothing to pay, no trial and no sign-up; the download starts when you tap the button. You can also read every page online first.', { pages: BOOK_PAGES })
		},
		{
			q: t('Who is this book for?'),
			a: beginner
				? t('For adults learning German at level {level} ({cefr} on the European CEFR scale), {badge}. The explanations are in your own language: the book exists in English, Arabic, French, Spanish, Turkish and Ukrainian.', { level, cefr, badge })
				: t('For adults learning German at level {level} ({cefr} on the European CEFR scale), {badge}. From B1 on the book explains German in German, the way a course at this level does; the app shows a translation of every explanation at a tap.', { level, cefr, badge })
		},
		{
			q: t('Does the book have audio?'),
			a: t('Yes. Every chapter has a QR code and a short page code; scan it or type it at languagequiz.org and the story is read aloud by German voices, free and without an account.')
		},
		{
			q: t('How do I check my answers?'),
			a: t('Two ways. The answer key is printed at the back of the book. Or use the small code on the page: the app opens the same exercises, checks each answer and explains every mistake.')
		},
		{
			q: t('Can I print it?'),
			a: t('Yes. The pages are A4 and made for paper: print the whole book or one chapter at a time, and write in it. All twelve books, from A1.1 to C2.2, have the same {pages}-page layout.', { pages: BOOK_PAGES })
		}
	]);

	const jsonLd = $derived([
		{
			'@context': 'https://schema.org',
			'@type': ['Book', 'LearningResource'],
			name,
			alternateName: `German ${level} textbook`,
			description: lede,
			image: absoluteUrl(coverImg),
			bookFormat: 'https://schema.org/EBook',
			bookEdition: String(BOOK_EDITION.n),
			datePublished: BOOK_EDITION.date,
			numberOfPages: BOOK_PAGES,
			inLanguage: beginner ? ['de', hasLocalPdf(book, lang.current) ? lang.current : 'en'] : ['de'],
			educationalLevel: `CEFR ${level}`,
			learningResourceType: 'Textbook',
			teaches: `German at CEFR level ${level}`,
			about: { '@type': 'Thing', name: 'German language' },
			author: ORGANIZATION,
			publisher: ORGANIZATION,
			isAccessibleForFree: true,
			encoding: { '@type': 'MediaObject', contentUrl: absoluteUrl(pdf), encodingFormat: 'application/pdf' },
			offers: { '@type': 'Offer', price: '0', priceCurrency: 'EUR', availability: 'https://schema.org/InStock' },
			hasPart: chapters.map((c) => ({
				'@type': 'Chapter',
				position: c.n,
				name: c.title,
				description: c.subtitle
			}))
		},
		{
			'@context': 'https://schema.org',
			'@type': 'FAQPage',
			mainEntity: faqs.map((f) => ({ '@type': 'Question', name: f.q, acceptedAnswer: { '@type': 'Answer', text: f.a } }))
		},
		breadcrumbLd([
			{ name: 'Home', path: '/' },
			{ name: t('Books'), path: '/books' },
			{ name, path }
		])
	]);

	function download(e: MouseEvent) {
		trackBookDownload(level, 'book_page');
		feedback.beforeDownload(e, { href: pdf, book: level });
	}
</script>

<Seo
	title={titleWithSite(t('Deutsch {level}: Free German {cefr} Textbook (PDF)', { level, cefr }))}
	{description}
	{path}
	image={absoluteUrl(coverImg)}
	imageAlt={t('The cover of {name}', { name })}
	{jsonLd}
/>

<SiteNav {courseHref} />

<main class="page-wide">
	<a class="back-link" href="/books"><Icon name="arrowLeft" size="1em" /> {t('All twelve books')}</a>

	<header class="hero">
		<a class="cover-link" href={readHref} tabindex="-1" aria-hidden="true">
			<img class="cover" src={coverImg} alt="" width="640" height="905" />
		</a>
		<div class="hero-text">
			<p class="kicker">{t('Free German textbook')} · <span dir="ltr">{level}</span> · {badge}</p>
			<h1><bdi lang="de">Deutsch {level}</bdi> <span class="sub"><bdi lang="de">{book.sub}</bdi></span></h1>
			<p class="lede">{lede}</p>
			<div class="actions">
				<a class="primary" href={pdf} download onclick={download}>
					<Icon name="download" size="1.05em" /> {t('Download the PDF')} · <span dir="ltr">{mb} MB</span>
				</a>
				<a class="secondary" href={readHref}><Icon name="book" size="1.05em" /> {t('Read online')}</a>
			</div>
			<p class="terms">{t('Free. No sign-up, no email, no ads.')}</p>
		</div>
	</header>

	<dl class="facts">
		<div><dt>{t('Level')}</dt><dd><bdi>{level}</bdi> <span>CEFR {cefr}</span></dd></div>
		<div><dt>{t('Pages')}</dt><dd>{BOOK_PAGES} <span>{t('A4, made to print')}</span></dd></div>
		<div><dt>{t('Chapters')}</dt><dd>12 <span>{t('each a real place')}</span></dd></div>
		<div><dt>{t('Words')}</dt><dd>{data.words} <span>{beginner ? t('each with its meaning') : t('in word lists')}</span></dd></div>
		<div><dt>{t('Explained in')}</dt><dd>{beginner ? t('your language') : t('German')} <span>{beginner ? t('six language editions') : t('as courses are from B1')}</span></dd></div>
		<div><dt>{t('Edition')}</dt><dd>{BOOK_EDITION.n} <span>{BOOK_EDITION.date}</span></dd></div>
	</dl>
	<!-- English only, as the newsletter is. -->
	{#if !lang.limited}
		<p class="updates">
			A corrected book comes out as a new edition.
			<a href="/newsletter?from=book-page">Get new editions by email</a>.
		</p>
	{/if}

	<section aria-labelledby="inside-title">
		<h2 id="inside-title">{t('What is in the book')}</h2>
		<p class="intro">
			{t('Every chapter is one place: {places}, and eight more. The place gives you the words, the words carry a story, and the story carries the grammar. Each chapter has the words with pictures, a photo to talk about, a story, two grammar pages, a real document ({real}) and practice.', { places, real })}
			{#if data.extras}{t('After the last chapter come {n} longer texts to read and hear.', { n: data.extras })}{/if}
		</p>

		<ol class="chapters">
			{#each chapters as c (c.id)}
				<li class="chapter">
					<img src="/img/photo/web/{c.photo}.jpg" alt={c.world} width="1400" height="933" loading="lazy" decoding="async" />
					<div class="ch-text">
						<p class="ch-n">{t('Chapter {n}', { n: c.n })} · <span lang="de">{c.world}</span></p>
						<h3 lang="de">{c.title}</h3>
						<p class="ch-sub" lang={beginner ? undefined : 'de'}>{c.subtitle}</p>
						<p class="ch-grammar"><b>{t('Grammar:')}</b> <span lang="de">{c.grammar.join(' · ')}</span></p>
						<p class="ch-grammar"><b>{t('Story:')}</b> <span lang="de">{c.story}</span></p>
						<details>
							<summary>{t('After this chapter you can …')}</summary>
							<ul lang={beginner ? undefined : 'de'}>
								{#each c.canDo as can, i (i)}<li>{can}</li>{/each}
							</ul>
							<a class="ch-open" href="{courseHref}/book2/{level}/{c.id}">{t('This chapter in the app')} <Icon name="arrowRight" size="1em" /></a>
						</details>
					</div>
				</li>
			{/each}
		</ol>
	</section>

	<section class="together" aria-labelledby="together-title">
		<h2 id="together-title">{t('The paper and the app work together')}</h2>
		<p class="intro">
			{t('The book is complete on paper. But every page carries a short code (like {code}) and every chapter a QR code. They open the same page in the free app, where you can:', { code: 'languagequiz.org/b/a1-07' })}
		</p>
		<ul>
			<li>
				<Icon name="headphones" size="1.5em" />
				<div><b>{t('Hear it.')}</b> {t('The story of every chapter, read aloud by German voices.')}</div>
			</li>
			<li>
				<Icon name="check" size="1.5em" />
				<div><b>{t('Check it.')}</b> {t('The page’s exercises, checked answer by answer, with the reason for every mistake.')}</div>
			</li>
			<li>
				<Icon name="cards" size="1.5em" />
				<div><b>{t('Keep it.')}</b> {t('The chapter’s words as flashcards, with pictures and sound.')}</div>
			</li>
		</ul>
		<a class="app-link" href="{courseHref}/level/{level}">{t('See the {level} course in the app', { level })} <Icon name="arrowRight" size="1em" /></a>
	</section>

	<section class="faq" aria-labelledby="faq-title">
		<h2 id="faq-title">{t('Before you download')}</h2>
		{#each faqs as f (f.q)}
			<h3>{f.q}</h3>
			<p>{f.a}</p>
		{/each}
	</section>

	<div class="again">
		<a class="primary" href={pdf} download onclick={download}>
			<Icon name="download" size="1.05em" /> {t('Download Deutsch {level} (PDF, {mb} MB)', { level, mb })}
		</a>
		<a class="secondary" href={readHref}><Icon name="book" size="1.05em" /> {t('Read online')}</a>
	</div>

	<nav class="neighbours" aria-label={t('Other books')}>
		{#if data.prev}
			<a class="prev" href="/books/{data.prev.slug}">
				<Icon name="arrowLeft" size="1em" />
				<span><small>{t('The book before')}</small><b lang="de" dir="ltr">Deutsch {data.prev.level} · {data.prev.sub}</b></span>
			</a>
		{/if}
		{#if data.next}
			<a class="next" href="/books/{data.next.slug}">
				<span><small>{t('The next book')}</small><b lang="de" dir="ltr">Deutsch {data.next.level} · {data.next.sub}</b></span>
				<Icon name="arrowRight" size="1em" />
			</a>
		{/if}
	</nav>
</main>

<SiteFooter />

<style>
	.updates {
		margin: -0.5rem 0 2rem;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.hero {
		display: grid;
		grid-template-columns: minmax(0, 17rem) minmax(0, 1fr);
		gap: 2.2rem;
		align-items: center;
	}

	.cover-link {
		display: block;
	}

	.cover {
		width: 100%;
		height: auto;
		border-radius: 4px;
		box-shadow:
			0 30px 44px -28px rgba(31, 58, 95, 0.7),
			0 0 0 1px rgba(31, 58, 95, 0.08);
	}

	.kicker {
		margin: 0 0 0.5rem;
		font-size: var(--step--1);
		font-weight: 700;
		letter-spacing: 0.04em;
		text-transform: uppercase;
		color: var(--accent-ink);
	}

	h1 {
		margin: 0;
		font-size: var(--step-4);
		line-height: 1.08;
		color: var(--heading);
	}

	h1 .sub {
		display: block;
		margin-top: 0.2rem;
		font-size: var(--step-2);
		font-weight: 600;
		color: var(--accent-ink);
	}

	.lede {
		margin: 1rem 0 0;
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-1);
		line-height: 1.45;
		color: var(--heading);
	}

	.actions,
	.again {
		display: flex;
		flex-wrap: wrap;
		gap: 0.7rem 1.4rem;
		align-items: center;
		margin-top: 1.4rem;
	}

	.primary {
		display: inline-flex;
		align-items: center;
		gap: 0.5rem;
		min-height: 2.9rem;
		padding: 0.7rem 1.3rem;
		border-radius: 6px;
		background: var(--accent-ink);
		color: #fff;
		font-weight: 700;
		text-decoration: none;
	}

	.primary:hover {
		filter: brightness(1.08);
	}

	.secondary {
		display: inline-flex;
		align-items: center;
		gap: 0.45rem;
		min-height: 2.9rem;
		color: var(--accent-ink);
		font-weight: 700;
		text-decoration: none;
	}

	.terms {
		margin: 0.7rem 0 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.facts {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(8.5rem, 1fr));
		gap: 1px;
		margin: 2.4rem 0 0;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--line);
		overflow: hidden;
	}

	.facts div {
		padding: 0.8rem 1rem;
		background: var(--surface);
	}

	.facts dt {
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.facts dd {
		margin: 0.1rem 0 0;
		font-size: var(--step-1);
		font-weight: 700;
		color: var(--heading);
	}

	.facts dd span {
		display: block;
		font-size: var(--step--1);
		font-weight: 400;
		color: var(--ink-muted);
	}

	section {
		margin-top: 3rem;
	}

	h2 {
		margin: 0 0 0.6rem;
		font-size: var(--step-3);
		color: var(--heading);
	}

	.intro {
		max-width: 44rem;
		margin: 0;
		line-height: 1.65;
	}

	.chapters {
		list-style: none;
		margin: 1.6rem 0 0;
		padding: 0;
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(min(100%, 19rem), 1fr));
		gap: 1.2rem;
	}

	.chapter {
		display: flex;
		flex-direction: column;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
		overflow: hidden;
	}

	.chapter img {
		width: 100%;
		height: auto;
		aspect-ratio: 3 / 2;
		object-fit: cover;
	}

	.ch-text {
		padding: 0.9rem 1.1rem 1.1rem;
	}

	.ch-n {
		margin: 0;
		font-size: var(--step--1);
		font-weight: 700;
		color: var(--accent-ink);
	}

	h3 {
		margin: 0.15rem 0 0.25rem;
		font-size: var(--step-1);
		line-height: 1.2;
		color: var(--heading);
	}

	.ch-sub {
		margin: 0 0 0.6rem;
		line-height: 1.5;
	}

	.ch-grammar {
		margin: 0.2rem 0 0;
		font-size: var(--step--1);
		line-height: 1.5;
		color: var(--ink-muted);
	}

	.ch-grammar b {
		color: var(--ink);
	}

	details {
		margin-top: 0.7rem;
		font-size: var(--step--1);
	}

	summary {
		min-height: 1.75rem;
		font-weight: 700;
		color: var(--accent-ink);
		cursor: pointer;
	}

	details ul {
		margin: 0.4rem 0 0.6rem;
		padding-inline-start: 1.1rem;
		line-height: 1.55;
	}

	.ch-open {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
		font-weight: 700;
		color: var(--accent-ink);
		text-decoration: none;
	}

	.together {
		padding: 1.6rem 1.6rem 1.7rem;
		border-radius: var(--radius);
		background: var(--surface-alt);
	}

	.together ul {
		list-style: none;
		margin: 1.2rem 0 0;
		padding: 0;
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(min(100%, 15rem), 1fr));
		gap: 1rem 1.6rem;
	}

	.together li {
		display: flex;
		gap: 0.8rem;
		align-items: flex-start;
		line-height: 1.55;
		color: var(--ink);
	}

	.together li :global(svg) {
		flex: none;
		margin-top: 0.1rem;
		color: var(--accent-ink);
	}

	.app-link {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		margin-top: 1.3rem;
		font-weight: 700;
		color: var(--accent-ink);
		text-decoration: none;
	}

	.faq h3 {
		margin: 1.3rem 0 0.2rem;
		font-size: var(--step-0);
	}

	.faq p {
		max-width: 44rem;
		margin: 0;
		line-height: 1.65;
	}

	.again {
		margin: 2.4rem 0 2rem;
	}

	.neighbours {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 1rem;
		margin-top: 2.5rem;
	}

	.neighbours a {
		display: flex;
		align-items: center;
		gap: 0.8rem;
		padding: 0.9rem 1.1rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
		color: var(--heading);
		text-decoration: none;
	}

	.neighbours .next {
		grid-column: 2;
		justify-content: flex-end;
		text-align: end;
	}

	.neighbours small {
		display: block;
		color: var(--ink-muted);
	}

	@media (max-width: 40rem) {
		.hero {
			grid-template-columns: 1fr;
			gap: 1.4rem;
		}

		.cover-link {
			max-width: 11rem;
		}

		.neighbours {
			grid-template-columns: 1fr;
		}

		.neighbours .next {
			grid-column: 1;
		}
	}
</style>
