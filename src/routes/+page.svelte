<script lang="ts">
	import Seo from '$lib/components/Seo.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
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
	import { account } from '$lib/state/account.svelte';
	import { openSignIn } from '$lib/state/signin.svelte';
	import { progress } from '$lib/state/progress.svelte';
	import { afterNavigate, goto } from '$app/navigation';
	import { onMount } from 'svelte';
	import { fade } from 'svelte/transition';
	import { LITERATURE, bookRequestHref } from '$lib/content/literature';
	import { BOOKS } from '$lib/content/books';
	import { SettingsKeys } from '$lib/domain/keys';
	import { track } from '$lib/services/analytics';
	import type { PageData } from './$types';

	const kafka = LITERATURE[0];
	/** The old whole-A1 printed book's test-copy offer; off until a new A1 book exists. */
	const SHOW_TEST_COPY = false;

	// One corner label per offer, each leading to its own section. A label goes
	// for good in this browser once it is clicked, and only then: scrolling
	// past the offer does not count.
	// The whole shelf, A1.1 included: one free PDF per level (Book v2).
	const SHELF = BOOKS;

	const OFFERS = [
		{ id: 'book', title: 'The books, A1 to C2', note: 'free PDFs' },
		...(kafka ? [{ id: 'literature', title: 'Kafka in German', note: 'free PDF' }] : [])
	];
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
	// And a learner who opens the site again lands straight in their deck: the
	// front page is for newcomers. Only on arrival (a typed address, a bookmark,
	// a link from elsewhere); the logo or Home link from inside the app still
	// shows this page.
	//
	// The jump happens in the page head, before anything renders: progress is
	// plain localStorage, so a few lines can check it while the HTML is still
	// being parsed and replace the page with the course at once, instead of
	// loading the whole front page and the app first. It mirrors
	// progress.hasAnyProgress(). Only a full page load runs it, which is what
	// "arrival" means; the logo or Home link inside the app navigates without
	// reloading, so the front page still shows. The query string goes along so
	// campaign tags reach the analytics on the course page.
	const arrivalJump = $derived(
		'<scr' +
			'ipt>try{var s=localStorage,go=false;for(var i=0;i<s.length&&!go;i++){var k=s.key(i)||"";' +
			'if(/quiz_answer_history$/.test(k))go=true;' +
			'else if(/_completed_quizzes$/.test(k)){try{var v=JSON.parse(s.getItem(k));go=Array.isArray(v)&&v.length>0}catch(e){}}}' +
			`if(go&&location.pathname==="/")location.replace(${JSON.stringify(courseHref)}+location.search+location.hash)}catch(e){}</scr` +
			'ipt>'
	);
	let returning = $state(false);
	afterNavigate(async ({ from }) => {
		returning = await progress.hasAnyProgress();
		// Fallback only: the head script has normally left this page already.
		if (returning && from === null) void goto(courseHref, { replaceState: true });
	});
	// A newcomer chooses where to start first (/start): new to German, find my
	// level, or pick it. Everyone used to land in A1.1 without knowing they could.
	const startHref = $derived(returning ? courseHref : '/start');


	// How it works, in the order you meet it: swipe, learn or play, come back.
	const HOW = [
		{
			img: 'how-swipe',
			zoom: 1.5,
			focus: '50% 52%',
			title: 'Swipe until something catches you',
			try: { id: 'quest_a1_1_zahlen', name: 'Zahlen 0–10', note: 'pick a mission' },
			text: 'The deck deals one card at a time. Not in the mood? Swipe left. Curious? Swipe right.'
		},
		{
			img: 'how-learn',
			zoom: 1.08,
			focus: '50% 50%',
			title: 'Read the rule, or jump straight in',
			try: { id: 'quest_a1_1_artikel', name: 'Artikel im Nominativ', note: 'lesson + quiz' },
			text: 'Every card has a short lesson and a quiz. Hear any sentence spoken, as often as you like.'
		},
		{
			img: 'how-repeat',
			zoom: 1.45,
			focus: '50% 52%',
			title: 'Move on, and come back when you want',
			try: { id: 'quest_a1_1_sprechen_vorstellung', name: 'Sprechen: Vorstellung', note: 'repeat aloud' },
			text: 'Nothing is locked and nothing is lost. Repeat what feels shaky, skip what you already know, collect medals on the way.'
		}
	];

	const FAQ = $derived([
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
			a: `No. Nothing is locked: pick the level that matches you from the ${data.subLevelCount} sub-levels and start there instead of replaying the basics.`
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
	]);

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
			mainEntity: FAQ.map((item) => ({
				'@type': 'Question',
				name: item.q,
				acceptedAnswer: { '@type': 'Answer', text: item.a }
			}))
		})
	);
</script>

<svelte:head>
	<!-- Returning learner: straight to the deck, before this page renders. -->
	{@html arrivalJump}
</svelte:head>

<Seo
	title="Learn German Free — Swipe-Through Course, A1 to C2 | Language Quiz"
	description="Learn German from English with {data.total} free five-minute cards: lessons, quizzes and picture hunts, every sentence spoken. A1 to C2, no sign-up."
	path="/"
	ogTitle="Language Quiz — Swipe your way to German, free"
	ogDescription="A free German course for English speakers: swipe through five-minute cards with lessons, quizzes, picture hunts and Maya's Berlin mysteries. Every sentence spoken, A1 to C2, no account."
	jsonLd={[websiteLd(), jsonLd, faqLd]}
/>

<SiteNav {courseHref} />

<!-- The hero: life in Germany, slide by slide; the visitor moves it. -->
<HeroCarousel {startHref} {returning} />

<main>
	{#if account.available && !account.signedIn}
		<p class="have-account">
			Already learning on another device?
			<button type="button" onclick={openSignIn}>Sign in</button>
		</p>
	{/if}

	<section id="how" class="block">
		<header class="block-head">
			<p class="kicker">How it works</p>
			<h2>Your course, your order</h2>
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
						<span class="try-label">Try it</span>
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
	{#if !SHOW_TEST_COPY}
	<section id="book" class="book-offer" aria-labelledby="book-offer-title">
		<a class="book-pic" href="/course/{data.card.id}/book2/A1.1" tabindex="-1" aria-hidden="true">
			<img src="/img/book-a1-1-front.webp" alt="" width="640" height="905" loading="lazy" />
		</a>
		<div class="book-copy">
			<p class="kicker">New · the book · free PDF</p>
			<h2 id="book-offer-title" lang="de">Deutsch A1.1 · Erste Schritte</h2>
			<p>
				Twelve chapters, each one a real place in Germany: words first, a photo, a story, two rules,
				a real document, and the practice. Every chapter's audio is a QR code away. 131 pages.
			</p>
			<a class="primary" href="/books/v2/de_cert_a1_a1_1.pdf" download onclick={() => track('book_download', { book: 'A1.1', from: 'home' })}>
				<Icon name="download" size="1.05em" /> Download the PDF · {BOOKS[0].mb} MB
			</a>
			<a class="book-preview" href="/course/{data.card.id}/book2/A1.1">Look inside first</a>
		</div>
	</section>
	<section class="book-shelf" aria-labelledby="book-shelf-title">
		<h2 id="book-shelf-title">All twelve books, A1.1 to C2.2</h2>
		<p>Each one has twelve new places, twelve stories and real German documents. All free, 131 pages each.</p>
		<ul>
			{#each SHELF as book (book.level)}
				<li>
					<a class="shelf-pic" href="/course/{data.card.id}/book2/{book.level}" tabindex="-1" aria-hidden="true">
						<img src="/img/book-{book.cover}-front.webp" alt="" width="640" height="905" loading="lazy" />
					</a>
					<strong lang="de">Deutsch {book.level}</strong>
					<span class="shelf-sub" lang="de">{book.sub}</span>
					<a class="shelf-link" href="/books/v2/de_cert_a1_{book.file}.pdf" download onclick={() => track('book_download', { book: book.level, from: 'home' })}>
						<Icon name="download" size="1em" /> PDF · {book.mb} MB
					</a>
					<a class="shelf-link" href="/course/{data.card.id}/book2/{book.level}">Look inside</a>
				</li>
			{/each}
		</ul>
	</section>
	{:else}
	<!-- Hidden 2026-11-05: the old whole-A1 printed book and its test-copy offer,
	     withdrawn until a new A1 book (A1.1 + A1.2) replaces it. -->
	<section id="book" class="book-offer" aria-labelledby="book-offer-title">
		<a class="book-pic" href="/contact" tabindex="-1" aria-hidden="true">
			<img src="/img/book-a1-front.webp" alt="" width="640" height="828" loading="lazy" />
			<span class="book-stamp">Work in progress</span>
		</a>
		<div class="book-copy">
			<p class="kicker">The book · test copies, free</p>
			<h2 id="book-offer-title">Deutsch A1 is becoming a printed book. Want to test it?</h2>
			<p>
				The whole A1 course on paper: 170 pages in colour, every lesson and exercise, and a code
				on each unit that opens its audio and tutor in the app. It is not finished. The layout,
				the wording and the order of things are still being worked on, and that is exactly why I
				need readers now, before it goes on sale.
			</p>
			<p>
				The first people who are interested get a copy for free, printing and postage on me. Read
				it, use it for a week or two, and tell me what you think, good or bad. Your notes shape
				the finished book.
			</p>
			<a class="primary" href="/contact">
				Ask for a test copy <Icon name="arrowRight" size="1.05em" />
			</a>
			<p class="book-note">A handful of copies · no strings, no obligation to be kind</p>
			<div class="book-dl">
				<p class="kicker">New · free PDF</p>
				<p><strong>Deutsch A1.1 · Erste Schritte</strong>, the new book: twelve chapters, each one a real place in Germany, with photos, stories and the practice. 131 pages.</p>
				<a class="primary" href="/books/v2/de_cert_a1_a1_1.pdf" download onclick={() => track('book_download', { book: 'A1.1', from: 'home' })}>
					<Icon name="download" size="1.05em" /> Download the PDF · {BOOKS[0].mb} MB
				</a>
				<a class="book-preview" href="/course/{data.card.id}/book2/A1.1">Look inside first</a>
			</div>
		</div>
	</section>
	{/if}

	<!-- Literature: the first annotated classic, free as a PDF. The shelf
	     itself is /literature; this offer shows its first book. -->
	{#if kafka}
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
						download="{kafka.author} - {kafka.title}.pdf"
						onclick={() => track('literature_download', { book: kafka.id, from: 'home' })}
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

	<section class="block faq-block">
		<header class="block-head">
			<p class="kicker">FAQ</p>
			<h2>Good to know</h2>
		</header>
		<dl class="faq">
			{#each FAQ as item (item.q)}
				<div>
					<dt>{item.q}</dt>
					<dd>
						{#if item.q.startsWith('How is AI')}
							{item.a.replace(' More on the About page.', '')} <a href="/about#ai">More on the About page.</a>
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
		<h2>Your first German lesson takes five minutes.</h2>
		<p>No account, no download, nothing to pay. Just open it and start.</p>
		<a class="primary light" href={startHref}>
			{returning ? 'Continue learning' : 'Start learning German'}
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

	.have-account {
		margin: 0 0 0;
		text-align: center;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.have-account button {
		padding: 0;
		border: 0;
		background: none;
		color: var(--accent-ink);
		font: inherit;
		font-weight: 700;
		text-decoration: underline;
		text-underline-offset: 2px;
		cursor: pointer;
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
		border-radius: 20px;
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
		left: 1rem;
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
		border-radius: 999px;
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
		transform: translateX(3px);
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
			padding: 0 0.9rem 0 0;
			border-radius: 16px;
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
			left: 0.5rem;
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

	/* -- the pill button, used on the story band and the closing band ----- */

	.primary {
		display: inline-flex;
		align-items: center;
		gap: 0.6rem;
		padding: 0.95rem 1.8rem;
		border-radius: 999px;
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
		transform: translateX(3px);
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
		border-radius: 24px;
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
		right: -0.9rem;
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
		right: 1rem;
		bottom: 1rem;
		z-index: 5;
		display: flex;
		flex-direction: column;
		align-items: flex-end;
		gap: 0.45rem;
	}

	/* The offers sit under the sticky bar when a label jumps to them. */
	#book,
	#literature {
		scroll-margin-top: 5rem;
	}

	.book-tag {
		display: inline-flex;
		align-items: center;
		gap: 0.5rem;
		padding: 0.55rem 0.9rem 0.55rem 0.75rem;
		border-radius: 999px;
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

	.book-dl {
		margin-top: 1.5rem;
		padding-top: 1.2rem;
		border-top: 1px solid var(--line);
	}

	.book-dl p {
		margin: 0.3rem 0 0.8rem;
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
		margin: 0;
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
		margin-left: 1rem;
		font-size: var(--step--1);
	}

	/* -- closing ---------------------------------------------------------- */

	.closing {
		margin: 5rem 0 0;
		padding: 3.5rem 2rem;
		border-radius: 24px;
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
