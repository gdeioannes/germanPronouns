<script lang="ts">
	import { feedback } from '$lib/state/feedback.svelte';
	import Seo from '$lib/components/Seo.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import ShareNudge from '$lib/components/ShareNudge.svelte';
	import { withLang } from '$lib/i18n/paths';
	import { courseLd, websiteLd } from '$lib/seo';
	// The front door. One product, one language pair: English → German. The
	// hero shows the benefits and one key visual — a learner with the course's
	// cards swirling out of her phone — which is itself the way into the deck.
	// The numbers come from the course bundle (see +page.server.ts), so nothing
	// here is a hand-maintained duplicate of the content, and because the route
	// is prerendered a crawler sees all of it as plain HTML.
	import Icon from '$lib/icons/Icon.svelte';
	import StoreEditions from '$lib/components/StoreEditions.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import HeroCarousel from '$lib/components/HeroCarousel.svelte';
	import { progress } from '$lib/state/progress.svelte';
	import { afterNavigate } from '$app/navigation';
	import { onMount } from 'svelte';
	import { fade } from 'svelte/transition';
	import { LITERATURE, bookRequestHref, pdfFilename } from '$lib/content/literature';
	import { CHARTS_BOOK } from '$lib/content/charts';
	import ChartsDownload from '$lib/components/ChartsDownload.svelte';
	import { BOOKS, bookCover, bookMb, bookPdf, pdfOffered } from '$lib/content/books';
	import { t } from '$lib/i18n/t';
	import { lang } from '$lib/i18n/lang.svelte';
	import { explainsAllLevels } from '$lib/i18n/content.svelte';
	import { levelTranslated } from '$lib/i18n/available';
	import { SettingsKeys } from '$lib/domain/keys';
	import { track, trackBookDownload } from '$lib/services/analytics';
	import WortArcade from '$lib/components/WortArcade.svelte';
	import type { PageData } from './$types';

	const kafka = LITERATURE[0];

	// One corner label per offer, each leading to its own section. A label goes
	// for good in this browser once it is clicked, and only then: scrolling
	// past the offer does not count.
	// The whole shelf, A1.1 included: one free PDF per level (Book v2).
	// Every book in every language: A1–A2 in the language's edition, B1–C2 as
	// they are (German explanations). Kafka (English notes) only in English.
	const SHELF = BOOKS;
	const firstBook = BOOKS[0];

	const OFFERS = $derived([
		{ id: 'book', title: t('The books, A1 to C2'), note: t('free PDFs') },
		...(kafka && !lang.limited ? [{ id: 'literature', title: 'Kafka in German', note: 'free PDF' }] : [])
	]);
	let seen = $state<string[] | null>(null);
	const labels = $derived(seen ? OFFERS.filter((o) => !seen!.includes(o.id)) : []);

	function readSeen(): string[] {
		try {
			return JSON.parse(localStorage.getItem(SettingsKeys.offersSeen) ?? '[]');
		} catch {
			return [];
		}
	}
	function markSeen(id: string) {
		if (!seen || seen.includes(id)) return;
		seen = [...seen, id];
		try {
			localStorage.setItem(SettingsKeys.offersSeen, JSON.stringify(seen));
		} catch {
			// storage blocked: the label just comes back next visit
		}
	}

	onMount(() => {
		seen = readSeen();
	});

	let { data }: { data: PageData } = $props();

	const courseHref = $derived(`/course/${data.card.id}`);

	// A learner coming back must not be dropped into A1.1 again: once the page
	// is live and finds progress, the start buttons lead to the course home,
	// whose deck deals the next exercise from what they have done. The
	// prerendered HTML keeps the A1 link for first visits and crawlers.
	//
	// The front page always shows, returning learner or not: it used to jump
	// a returning learner straight into the course on arrival, and that was
	// switched off on request (2026-11-20). "Continue learning" is one tap.
	let returning = $state(false);
	afterNavigate(async () => {
		returning = await progress.hasAnyProgress();
	});
	// A newcomer chooses where to start first (/start): new to German, find my
	// level, or pick it. Everyone used to land in A1.1 without knowing they could.
	const startHref = $derived(returning ? courseHref : '/start');


	// How it works, in the order you meet it: swipe, learn or play, come back.
	const HOW = $derived([
		{
			img: 'deck/b2a12_bahn_opener',
			zoom: 1,
			focus: '50% 50%',
			title: t('Swipe until something catches you'),
			try: { id: 'quest_a1_1_zahlen', name: 'Zahlen 0–10', note: t('pick a mission') },
			text: t('The deck deals one card at a time. Not in the mood? Swipe left. Curious? Swipe right.')
		},
		{
			img: 'deck/b2a22_bibliothek_opener',
			zoom: 1,
			focus: '50% 50%',
			title: t('Read the rule, or jump straight in'),
			try: { id: 'quest_a1_1_artikel', name: 'Artikel im Nominativ', note: t('lesson + quiz') },
			text: t('Every card has a short lesson and a quiz. Hear any sentence spoken, as often as you like.')
		},
		{
			img: 'deck/b2a12_biergarten_opener',
			zoom: 1,
			focus: '50% 50%',
			title: t('Move on, and come back when you want'),
			try: { id: 'quest_a1_1_sprechen_vorstellung', name: 'Sprechen: Vorstellung', note: t('repeat aloud') },
			text: t('Nothing is locked and nothing is lost. Repeat what feels shaky, skip what you already know, collect medals on the way.')
		}
	]);

	// The English FAQ also feeds the FAQPage JSON-LD; the Turkish one is shown only.
	const FAQ_EN = [
		{
			q: 'Is it really free?',
			a: 'Yes. Every exercise is open — no paywall, no trial, no account. Your progress is saved in your own browser.'
		},
		{
			q: 'Do I need an account?',
			a: 'No. If you want your progress on more than one device, sign in with just your email address — no password, nothing else asked.'
		},
		{
			q: 'I already speak some German — must I start at A1?',
			a: 'No. Nothing is locked: pick the level that matches you from the {n} sub-levels and start there instead of replaying the basics.'
		},
		{
			q: 'Does it work on my phone?',
			a: 'Yes. It is a website, so it runs in any browser on a phone, tablet or computer, with nothing to install.'
		},
		{
			q: 'Does it prepare me for an exam?',
			a: 'The levels follow the CEFR scale from A1 to C2 and the skills exams test: reading, listening, writing and speaking. Language Quiz is an independent study aid and is not affiliated with any examination body.'
		},
		{
			q: 'How is AI used?',
			a: 'Illustrations and the audio voices are generated; the lessons and exercises are written and checked by a person. Nothing you do is sent to an AI. More on the About page.'
		}
	];
	// In Turkish the course stops at A2, so the level answers say so; signing in is English-only.
	const FAQ_TR_SWAP: Record<string, string> = {
		'Do I need an account?': 'No. Your progress is saved in your own browser, with nothing to sign up for.',
		'I already speak some German — must I start at A1?':
			'No. Nothing is locked: pick the level that matches you from the twelve sub-levels (A1.1 to A2.2 in your language, then in German) and start there.',
		'Does it prepare me for an exam?':
			'The course covers A1 to C2 of the CEFR scale, A1 and A2 explained in your language, and the skills exams test: reading, listening, writing and speaking. Language Quiz is an independent study aid and is not affiliated with any examination body.'
	};
	// French, Ukrainian and Spanish explain every level, so the exam answer says so.
	const faqSwap = (q: string) =>
		q === 'Does it prepare me for an exam?' && explainsAllLevels()
			? 'The course covers A1 to C2 of the CEFR scale, every level explained in your language, and the skills exams test: reading, listening, writing and speaking. Language Quiz is an independent study aid and is not affiliated with any examination body.'
			: FAQ_TR_SWAP[q];
	const FAQ = $derived(
		FAQ_EN.map((item) => ({
			id: item.q,
			q: t(item.q),
			a: t(lang.limited ? (faqSwap(item.q) ?? item.a) : item.a, { n: data.subLevelCount })
		}))
	);
	const faqEn = $derived(FAQ_EN.map((item) => ({ q: item.q, a: item.a.replace('{n}', String(data.subLevelCount)) })));

	const jsonLd = $derived(
		courseLd(
			{ id: data.card.id, name: 'German for English speakers (A1–C2)', tagline: data.card.tagline },
			{ numberOfLessons: data.total }
		)
	);

	const faqLd = $derived(
		({
			'@context': 'https://schema.org',
			'@type': 'FAQPage',
			mainEntity: faqEn.map((item) => ({
				'@type': 'Question',
				name: item.q,
				acceptedAnswer: { '@type': 'Answer', text: item.a }
			}))
		})
	);
</script>

<Seo
	title={t('Language Quiz: Free German Course, Books (PDF) & App, A1–C2')}
	description={t('Free German resources, A1 to C2: {n} five-minute lessons and quizzes with audio, plus twelve free PDF books. No sign-up, no ads.', { n: lang.limited ? data.localTotal : data.total })}
	path="/"
	ogTitle={t('Language Quiz — Swipe your way to German, free')}
	ogDescription={t('A German course for English speakers living in Germany or moving there: five-minute cards with lessons, quizzes and picture hunts, every sentence spoken, and a book for every level linked to the app. A1 to C2, no account.')}
	jsonLd={[websiteLd(), jsonLd, faqLd]}
/>

<SiteNav {courseHref} />

<!-- The hero: life in Germany, slide by slide; the visitor moves it. -->
<HeroCarousel {startHref} {returning} />

<main>
	<section id="how" class="block">
		<header class="block-head">
			<p class="kicker">{t('How it works')}</p>
			<h2>{t('Your course, your order')}</h2>
		</header>
		<ol class="how">
			{#each HOW as step, i (step.img)}
				<li>
					<span class="how-pic">
						<img
							src="/img/{step.img}.webp"
							alt=""
							width="512"
							height="512"
							loading="lazy"
							style:transform="scale({step.zoom})"
							style:transform-origin={step.focus}
						/>
					</span>
					<span class="num">{i + 1}</span>
					<h3>{step.title}</h3>
					<p>{step.text}</p>
					<a class="try" href="/course/{data.card.id}/quiz/{step.try.id}">
						<span class="try-label">{t('Try it')}</span>
						<span class="try-text"
							><span class="try-name" lang="de">{step.try.name}</span>
							<span class="try-note">· {step.try.note}</span></span
						>
						<Icon name="arrowRight" size="1em" />
					</a>
				</li>
			{/each}
		</ol>
	</section>

	<!-- The new book: Deutsch A1.1 (Book v2), a free PDF. -->
	<section id="book" class="book-offer" aria-labelledby="book-offer-title">
		<a class="book-pic" href="/course/{data.card.id}/book2/A1.1" tabindex="-1" aria-hidden="true">
			<img src={bookCover(firstBook, lang.current)} alt="" width="640" height="905" loading="lazy" />
		</a>
		<div class="book-copy">
			<p class="kicker">{t('New · the book · free PDF')}</p>
			<h2 id="book-offer-title" lang="de">Deutsch A1.1 · Erste Schritte</h2>
			<p>
				{t('Twelve chapters, each one a real place in Germany: words first, a photo, a story, two rules, a real document, and the practice. A code on every page opens that chapter in the app: check your answers, learn the words as flashcards, hear the texts. 131 pages.')}
			</p>
			<!-- Turkish: the Turkish edition once it is printed; until then no download. -->
			{#if pdfOffered(firstBook, lang.current)}
				<a class="primary" href={bookPdf(firstBook, lang.current)} download onclick={(e) => { trackBookDownload('A1.1', 'home'); feedback.beforeDownload(e, { href: bookPdf(firstBook, lang.current), book: 'A1.1' }); }}>
					<Icon name="download" size="1.05em" /> {t('Download the PDF · {mb} MB', { mb: bookMb(firstBook, lang.current) })}
				</a>
			{/if}
			<a class="book-preview" href="/course/{data.card.id}/book2/A1.1">{t('Look inside first')}</a>
		</div>
	</section>
	<section class="book-shelf" aria-labelledby="book-shelf-title">
		<h2 id="book-shelf-title">{lang.limited ? t('The twelve books, A1.1 to C2.2') : 'All twelve books, A1.1 to C2.2'}</h2>
		<p>{t('Each one has twelve new places, twelve stories and real German documents. All free, 131 pages each.')}</p>
		<ShareNudge
			where="home"
			text={t('I thought of you: twelve free German books with audio, from A1 to C2. No sign-up, nothing to pay.')}
			path={withLang(lang.local, '/books')}
		/>
		<ul>
			{#each SHELF as book (book.level)}
				<li>
					<a class="shelf-pic" href="/course/{data.card.id}/book2/{book.level}" tabindex="-1" aria-hidden="true">
						<img src={bookCover(book, lang.current)} alt="" width="640" height="905" loading="lazy" />
					</a>
					<strong lang="de">Deutsch {book.level}</strong>
					<span class="shelf-sub" lang="de">{book.sub}</span>
					{#if lang.limited && !levelTranslated(book.level)}<span class="shelf-sub">{t('Explained in German')}</span>{/if}
					{#if pdfOffered(book, lang.current)}
						<a class="shelf-link" href={bookPdf(book, lang.current)} download onclick={(e) => { trackBookDownload(book.level, 'home'); feedback.beforeDownload(e, { href: bookPdf(book, lang.current), book: book.level }); }}>
							<Icon name="download" size="1em" /> PDF · {bookMb(book, lang.current)} MB
						</a>
					{/if}
					<a class="shelf-link" href="/course/{data.card.id}/book2/{book.level}">{t('Look inside')}</a>
				</li>
			{/each}
		</ul>
	</section>

	<!-- Literature: the first annotated classic, free as a PDF. The shelf
	     itself is /literature; this offer shows its first book. -->
	{#if kafka && !lang.limited}
		<section id="literature" class="book-offer lit" aria-labelledby="lit-offer-title">
			<a class="book-pic" href="/literature" tabindex="-1" aria-hidden="true">
				<img src={kafka.cover} alt="" width="640" height="1024" loading="lazy" />
			</a>
			<div class="book-copy">
				<p class="kicker">New · Literature · free PDF</p>
				<h2 id="lit-offer-title">Read Kafka in the German he wrote.</h2>
				<p>
					<i lang="de">{kafka.title}</i>, the whole story in its original words, split into
					twelve short reading stages. The hard words are explained in English in the margin,
					beside the line they are on, and notes at the foot of the page explain the German
					worth noticing on the way.
				</p>
				<div class="lit-actions">
					<a
						class="primary"
						href={kafka.pdf.href}
						download={pdfFilename(kafka)}
						onclick={(e) => {
							track('literature_download', { book: kafka.id, from: 'home' });
							feedback.beforeDownload(e, { href: kafka.pdf.href, filename: pdfFilename(kafka), book: kafka.short });
						}}
					>
						<Icon name="download" size="1.05em" /> Download the free PDF
					</a>
					<a class="lit-more" href="/literature">See the literature shelf <Icon name="arrowRight" size="1em" /></a>
				</div>
				<p class="book-note">{kafka.pdf.pages} pages · {kafka.level} · English glossaries and notes</p>
				<StoreEditions book={kafka} from="home" />
				<p class="lit-request">
					Want a different book? <a href={bookRequestHref()}>Ask for it on the forum</a>.
				</p>
			</div>
		</section>
	{/if}

	<!-- The grammar charts: wall charts in one free PDF (a test edition).
	     English only, like the literature shelf. Its page is /charts. -->
	{#if !lang.limited}
		<section id="charts" class="book-offer charts" aria-labelledby="charts-offer-title">
			<a class="book-pic" href="/charts" tabindex="-1" aria-hidden="true">
				<img src={CHARTS_BOOK.cover} alt="" width="1280" height="905" loading="lazy" />
				<span class="book-stamp">Test</span>
			</a>
			<div class="book-copy">
				<p class="kicker">New · Grammar charts · test run</p>
				<h2 id="charts-offer-title">The hard parts of German, on your wall.</h2>
				<p>
					{CHARTS_BOOK.charts.length} charts to print and hang up: the four cases, where the verb goes,
					adjective endings, the tenses on one line, verbs with their prepositions. One idea per
					page, the same colours on every chart.
				</p>
				<div class="lit-actions">
					<span class="charts-dl"><ChartsDownload from="home" /></span>
					<a class="lit-more" href="/charts">See all the charts <Icon name="arrowRight" size="1em" /></a>
				</div>
				<p class="book-note">{CHARTS_BOOK.pages} pages · {CHARTS_BOOK.megabytes} MB · A4 landscape · a test edition, more charts on the way</p>
			</div>
		</section>
	{/if}

	<!-- The word game: an arcade cabinet that plays itself (WortArcade). -->
	<WortArcade />

	<section class="block faq-block">
		<header class="block-head">
			<p class="kicker">{t('FAQ')}</p>
			<h2>{t('Good to know')}</h2>
		</header>
		<dl class="faq">
			{#each FAQ as item (item.id)}
				<div>
					<dt>{item.q}</dt>
					<dd>
						{#if item.id.startsWith('How is AI')}
							{item.a.replace(' ' + t('More on the About page.'), '')} <a href="/about#ai">{t('More on the About page.')}</a>
						{:else}
							{item.a}
						{/if}
					</dd>
				</div>
			{/each}
		</dl>
	</section>

	<!-- Small fixed labels, one per offer this visitor has not seen yet, each
	     leading to its own offer. Shown only once the page is live, so a
	     returning visitor who has seen everything never sees them flash in. -->
	{#if labels.length}
		<div class="book-tags">
			{#each labels as l (l.id)}
				<a class="book-tag" class:alt={l.id === 'literature'} href="#{l.id}" onclick={() => markSeen(l.id)} transition:fade={{ duration: 160 }}>
					<Icon name="book" size="1.1em" />
					<span><b>{l.title}</b><span class="note">&nbsp;· {l.note}</span></span>
				</a>
			{/each}
		</div>
	{/if}

	<section class="closing">
		<h2>{t('Your first German lesson takes five minutes.')}</h2>
		<p>{t('No account, no download, nothing to pay. Just open it and start.')}</p>
		<a class="primary light" href={startHref}>
			{returning ? t('Continue learning') : t('Start learning German')}
			<Icon name="arrowRight" size="1.05em" />
		</a>
	</section>
</main>

<SiteFooter />

<style>
	main {
		max-width: 72rem;
		margin: 0 auto;
		padding: 2rem 1.25rem 0;
	}

	/* -- how it works: three equal cards --------------------------------- */

	.how {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(min(16rem, 100%), 1fr));
		gap: 1.25rem;
		margin: 0;
		padding: 0;
		list-style: none;
		counter-reset: how;
	}

	/* One cream card: the picture bleeds to the top edge, the words sit right
	   under it on the same paper. */
	.how li {
		position: relative;
		display: flex;
		flex-direction: column;
		padding: 0 1.4rem 1.5rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: #fbf5e4;
		overflow: hidden;
		transition:
			transform var(--medium) var(--ease-out),
			box-shadow var(--medium) var(--ease-out);
	}

	.how li:hover {
		transform: translateY(-3px);
		box-shadow: 0 20px 40px -30px rgba(31, 58, 95, 0.45);
	}

	/* The pictures are drawn small on wide paper: a square window, each one
	   zoomed just enough that its subject fills it without losing a foot. */
	.how-pic {
		display: block;
		margin: 0 -1.4rem 0.8rem;
		aspect-ratio: 1;
		overflow: hidden;
	}

	.how-pic img {
		display: block;
		width: 100%;
		height: 100%;
		object-fit: cover;
	}

	.how .num {
		position: absolute;
		top: 1rem;
		inset-inline-start: 1rem;
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2rem;
		height: 2rem;
		border-radius: 50%;
		background: var(--navy);
		color: #fff;
		font-size: 0.95rem;
		font-weight: 800;
		box-shadow: 0 0 0 3px #fbf5e4;
	}

	.how h3 {
		margin: 0 0 0.4rem;
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-1);
		line-height: 1.2;
	}

	.how p {
		margin: 0 0 0.25rem;
		color: var(--ink-muted);
		font-size: var(--step--1);
		line-height: 1.55;
	}

	/* A real exercise to try, pinned to the card's foot. */
	.try {
		display: grid;
		grid-template-columns: auto minmax(0, 1fr) auto;
		align-items: center;
		gap: 0.5rem;
		margin-top: auto;
		padding-top: 1rem;
		font-size: var(--step--1);
		color: var(--heading);
		text-decoration: none;
	}

	.try-label {
		padding: 0.15rem 0.55rem;
		border-radius: 4px;
		background: var(--accent-ink);
		color: #fff;
		font-size: 0.7rem;
		font-weight: 800;
		letter-spacing: 0.06em;
		text-transform: uppercase;
	}

	.try-name {
		font-weight: 700;
	}

	.try-note {
		color: var(--ink-muted);
	}

	.try-text {
		line-height: 1.35;
	}

	.try :global(.icon) {
		color: var(--accent-ink);
		transition: transform var(--fast) var(--ease-out);
	}

	.try:hover .try-name {
		color: var(--accent-ink);
	}

	.try:hover :global(.icon) {
		transform: translateX(calc(3px * var(--flip)));
	}

	/* Phone: one card per row, laid sideways — the picture on the left, the
	   words beside it — so three cards fit in a screen and a half. */
	@media (max-width: 40rem) {
		.how {
			gap: 0.75rem;
		}
		.how li {
			display: grid;
			grid-template-columns: 38% minmax(0, 1fr);
			column-gap: 0.9rem;
			align-items: center;
			padding-block: 0;
			padding-inline: 0 0.9rem;
			border-radius: var(--radius);
		}
		.how-pic {
			grid-row: 1 / 4;
			align-self: stretch;
			margin: 0;
			aspect-ratio: auto;
			min-height: 11rem;
		}
		.how .num {
			top: 0.5rem;
			inset-inline-start: 0.5rem;
			width: 1.5rem;
			height: 1.5rem;
			font-size: 0.75rem;
		}
		.how h3 {
			margin: 0.9rem 0 0.25rem;
			font-size: var(--step-0);
		}
		.how p {
			margin: 0;
			font-size: 0.8rem;
			line-height: 1.45;
		}
		.try {
			grid-template-columns: auto minmax(0, 1fr) auto;
			margin: 0;
			padding: 0.5rem 0 0.9rem;
			font-size: 0.78rem;
		}
		.try-label {
			font-size: 0.58rem;
			padding: 0.1rem 0.4rem;
		}
		.try-note {
			display: none;
		}
	}

	/* -- the main button, used on the book offer and the closing band ----- */

	.primary {
		display: inline-flex;
		align-items: center;
		gap: 0.6rem;
		padding: 0.95rem 1.8rem;
		border-radius: 6px;
		background: var(--accent-ink);
		color: #fff;
		font-size: var(--step-0);
		font-weight: 700;
		text-decoration: none;
		box-shadow: 0 14px 30px -16px rgba(201, 104, 59, 0.8);
		transition:
			transform var(--medium) var(--ease-out),
			box-shadow var(--medium) var(--ease-out),
			background var(--medium) var(--ease-out);
	}

	.primary:hover {
		transform: translateY(-2px);
		color: #fff;
		text-decoration: none;
		box-shadow: 0 20px 36px -18px rgba(201, 104, 59, 0.9);
	}

	.primary :global(.icon) {
		transition: transform var(--medium) var(--ease-out);
	}

	.primary:hover :global(.icon) {
		transform: translateX(calc(3px * var(--flip)));
	}

	/* On navy the terracotta reads a step brighter, with a warm glow — but
	   only as bright as white text still reads on (4.5:1). */
	.primary.light {
		background: #b3542b;
		box-shadow: 0 16px 36px -14px rgba(201, 104, 59, 1);
	}

	.primary.light:hover {
		background: var(--accent-ink);
	}

	/* -- the book offer ----------------------------------------------------- */

	.book-offer {
		display: grid;
		grid-template-columns: minmax(0, 14rem) minmax(0, 1fr);
		align-items: center;
		gap: 2.5rem;
		margin-top: 5rem;
		padding: 2rem 2.5rem;
		border-radius: var(--radius);
		border: 1px solid var(--line);
		background:
			radial-gradient(circle at 90% 10%, rgba(201, 104, 59, 0.16), transparent 45%),
			var(--accent-soft);
	}

	.book-pic {
		display: block;
		justify-self: center;
		width: min(100%, 13rem);
		transform: rotate(-4deg);
		transition: transform var(--medium) var(--ease-out);
	}

	.book-pic:hover {
		transform: rotate(-1deg) translateY(-4px);
	}

	.book-pic img {
		display: block;
		width: 100%;
		height: auto;
		border-radius: 6px;
		box-shadow:
			0 30px 50px -28px rgba(31, 58, 95, 0.7),
			0 0 0 1px rgba(31, 58, 95, 0.08);
	}

	.book-pic {
		position: relative;
	}

	.book-stamp {
		position: absolute;
		top: 0.9rem;
		inset-inline-end: -0.9rem;
		padding: 0.3rem 0.7rem;
		border-radius: 999px;
		background: var(--accent-ink);
		color: #fff;
		font-size: 0.72rem;
		font-weight: 800;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		transform: rotate(8deg);
		box-shadow: 0 8px 16px -8px rgba(0, 0, 0, 0.5);
	}

	/* The fixed label: a small pill in the corner, out of the way of the text. */
	.book-tags {
		position: fixed;
		inset-inline-end: 1rem;
		bottom: 1rem;
		z-index: 5;
		display: flex;
		flex-direction: column;
		align-items: flex-end;
		gap: 0.45rem;
	}

	/* The offers sit under the sticky bar when a label jumps to them. */
	#book,
	#literature,
	#charts {
		scroll-margin-top: 5rem;
	}

	.book-tag {
		display: inline-flex;
		align-items: center;
		gap: 0.5rem;
		padding-block: 0.55rem;
		padding-inline: 0.75rem 0.9rem;
		border-radius: 6px;
		background: var(--navy);
		color: #fff;
		font-size: 0.82rem;
		text-decoration: none;
		box-shadow: 0 12px 28px -12px rgba(31, 58, 95, 0.8);
		transition: transform var(--medium) var(--ease-out);
	}

	.book-tag:hover {
		transform: translateY(-2px);
	}

	.book-tag b {
		font-weight: 700;
	}

	/* The literature label: same shape, light, so the two read as two books. */
	.book-tag.alt {
		background: var(--surface);
		color: var(--navy);
		border: 1px solid var(--line-strong);
		box-shadow: 0 12px 28px -14px rgba(31, 58, 95, 0.5);
	}

	/* On a phone the labels keep their title and drop the note. */
	@media (max-width: 40rem) {
		.book-tag .note {
			display: none;
		}
		.book-tag {
			font-size: 0.78rem;
		}
	}

	.book-copy h2 {
		margin-bottom: 0.8rem;
	}

	.book-copy p {
		margin: 0 0 1rem;
		color: var(--ink-muted);
		line-height: 1.6;
	}

	.book-copy .primary {
		margin-top: 0.4rem;
	}

	/* The literature offer: same card, quieter colour, the book on the right. */
	.book-offer.lit {
		margin-top: 1.5rem;
		grid-template-columns: minmax(0, 1fr) minmax(0, 11rem);
		background: var(--surface);
	}

	.book-offer.lit .book-pic {
		order: 2;
		transform: rotate(3deg);
	}

	.book-offer.lit .book-pic:hover {
		transform: rotate(1deg) translateY(-4px);
	}

	/* The grammar charts offer: the literature card with a landscape cover. */
	.book-offer.charts {
		margin-top: 1.5rem;
		grid-template-columns: minmax(0, 19rem) minmax(0, 1fr);
		/* Its own colour, the yellow the charts use for what matters, so it stands
		   apart from the white and cream blocks around it. */
		background: #ffe14d;
		border: 0;
		box-shadow: 0 14px 34px -18px rgb(31 58 95 / 0.55);
	}

	.book-offer.charts .kicker,
	.book-offer.charts .book-copy p,
	.book-offer.charts .book-note {
		color: #2b2a25;
	}
	.book-offer.charts .lit-more {
		color: var(--navy, #1f3a5f);
	}

	.book-offer.charts .book-pic {
		width: min(100%, 19rem);
		transform: rotate(-2deg);
	}

	.book-offer.charts .book-pic:hover {
		transform: rotate(-0.5deg) translateY(-4px);
	}

	@media (max-width: 56rem) {
		.book-offer.charts {
			grid-template-columns: minmax(0, 1fr);
		}
		.book-offer.charts .book-pic {
			width: min(86%, 19rem);
		}
	}

	.lit-actions {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 0.6rem 1.2rem;
		margin-top: 0.4rem;
	}

	.lit-actions .primary {
		margin-top: 0;
	}

	.lit-request {
		margin: 0.6rem 0 0;
		font-size: 0.85rem;
		line-height: 1.5;
	}

	.lit-request a {
		color: var(--accent-ink);
		font-weight: 700;
	}

	.lit-more {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
		color: var(--accent-ink);
		font-weight: 700;
		text-decoration: none;
	}

	@media (max-width: 56rem) {
		.book-offer.lit {
			grid-template-columns: minmax(0, 1fr);
		}
		.book-offer.lit .book-pic {
			order: 0;
		}
		.lit-actions {
			justify-content: center;
		}
	}

	.book-note {
		margin: 0.9rem 0 0;
		font-size: 0.85rem;
	}

	@media (max-width: 56rem) {
		.book-offer {
			grid-template-columns: minmax(0, 1fr);
			padding: 1.5rem 1.25rem;
			text-align: center;
		}
		.book-pic {
			width: min(60%, 11rem);
		}
	}

	/* -- sections --------------------------------------------------------- */

	.block {
		padding-top: 5rem;
	}

	.block-head {
		max-width: 40rem;
		margin-bottom: 2rem;
	}

	.kicker {
		margin: 0 0 0.5rem;
		font-size: 0.75rem;
		font-weight: 800;
		letter-spacing: 0.09em;
		text-transform: uppercase;
		color: var(--accent-ink);
	}

	h2 {
		margin: 0;
		font-size: var(--step-3);
		line-height: 1.15;
		color: var(--heading);
	}

	h3 {
		margin: 0 0 0.3rem;
		font-size: var(--step-0);
		color: var(--heading);
	}

	/* -- faq: two columns, each read top to bottom ----------------------- */

	.faq {
		columns: 2;
		column-gap: 3.5rem;
		margin: 0;
	}

	.faq > div {
		break-inside: avoid;
		padding: 0 0 1.1rem;
		margin-bottom: 1.1rem;
		border-bottom: 1px solid var(--line);
	}

	.faq dt {
		font-weight: 700;
		color: var(--heading);
	}

	.faq dd {
		margin: 0.3rem 0 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
		line-height: 1.55;
	}

	@media (max-width: 48rem) {
		.faq {
			columns: 1;
		}
	}

	.faq dd a {
		color: var(--accent-ink);
	}

	.book-shelf {
		max-width: 60rem;
		margin: 3.5rem auto 0;
	}
	.book-shelf h2 {
		margin: 0 0 0.35rem;
	}
	.book-shelf p {
		margin: 0 0 1.25rem;
	}
	.book-shelf ul {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(9rem, 1fr));
		gap: 1.5rem 1.1rem;
		list-style: none;
		/* Room under the share band, so the covers do not sit on its edge. */
		margin: 1.75rem 0 0;
		padding: 0;
	}
	.book-shelf li {
		display: flex;
		flex-direction: column;
		gap: 0.2rem;
		min-width: 0;
	}
	.shelf-pic {
		display: block;
		margin-bottom: 0.45rem;
	}
	.shelf-pic img {
		display: block;
		width: 100%;
		height: auto;
		border-radius: 3px;
		box-shadow: 0 4px 14px rgb(0 0 0 / 0.16);
	}
	.shelf-sub {
		font-size: 0.85rem;
		opacity: 0.75;
	}
	.shelf-link {
		display: inline-flex;
		align-items: center;
		gap: 0.3em;
		font-size: 0.875rem;
		min-height: 1.75rem;
	}
	.book-preview {
		display: inline-block;
		margin-inline-start: 1rem;
		font-size: var(--step--1);
	}

	/* -- closing ---------------------------------------------------------- */

	.closing {
		margin: 5rem 0 0;
		padding: 3.5rem 2rem;
		border-radius: var(--radius);
		background:
			radial-gradient(circle at 85% 20%, rgba(201, 104, 59, 0.35), transparent 45%),
			var(--navy);
		color: #fff;
		text-align: center;
	}

	.closing h2 {
		max-width: 28ch;
		margin: 0 auto 0.7rem;
		color: #fff;
	}

	.closing p {
		margin: 0 0 1.8rem;
		color: rgba(255, 255, 255, 0.78);
	}

	/* -- footer ----------------------------------------------------------- */

</style>
