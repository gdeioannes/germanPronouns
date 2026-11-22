<script lang="ts">
	// The grammar charts book: wall charts for the parts of German that are hard
	// to remember, free as one PDF. A test edition: the list and the PDF come
	// from content/charts (written by `npm run charts`).
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import ChartsDownload from '$lib/components/ChartsDownload.svelte';
	import ChartShare from '$lib/components/ChartShare.svelte';
	import ChartFeedback from '$lib/components/ChartFeedback.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { returnTo, returnLabel } from '$lib/state/returnTo.svelte';
	import { CHARTS_BOOK } from '$lib/content/charts';
	import { breadcrumbLd, itemListLd } from '$lib/seo';
	import { page } from '$app/state';

	const courseHref = $derived(page.data.site?.courseHref ?? '/');
	const book = CHARTS_BOOK;
	// Inside the book: four charts that show its range (a table, a path, rings, columns).
	const INSIDE = ['cases', 'verb-position', 'time-prepositions', 'gender'];
	const inside = INSIDE.map((slug) => book.charts.find((c) => c.slug === slug)).filter((c) => !!c);

</script>

<Seo
	title="German grammar charts to print and hang up"
	description="{book.charts.length} wall charts for the parts of German grammar that are hard to remember: the cases, word order, adjective endings, tenses, prepositions. Free PDF to print."
	path="/charts"
	jsonLd={[
		itemListLd('German grammar charts', book.charts.map((c) => ({ name: c.title, path: `/charts#chart-${c.n}` }))),
		breadcrumbLd([{ name: 'Home', path: '/' }, { name: 'Grammar charts', path: '/charts' }])
	]}
/>

<SiteNav {courseHref} />

<main class="page-wide">
	<a class="back-link" href={returnTo.path}><Icon name="arrowLeft" size="1em" /> {returnLabel(returnTo.path)}</a>

	<header class="top">
		<!-- The cover as a book lying at a slight angle: a spine down the left, the block of pages along the right and bottom. -->
		<div class="pile">
			<div class="book">
				<img class="cover" src={book.cover} alt="Cover of German Grammar Charts" width="1280" height="905" />
			</div>
			<!-- Four of its pages, in one straight row under the book: each leads to its chart below. -->
			<p class="inside-head">Inside the book</p>
			<div class="inside">
				{#each inside as chart (chart.n)}
					<a href="#chart-{chart.n}" aria-label="Chart {chart.n}: {chart.title}">
						<img src={chart.img} alt="" width="1100" height="778" loading="lazy" />
					</a>
				{/each}
			</div>
		</div>
		<div class="text">
			<p class="where">{book.edition}</p>
			<h1>German Grammar Charts</h1>
			<div class="get">
				<ChartsDownload from="charts" />
				<p class="small">{book.pages} pages · {book.megabytes} MB · print in colour, A4 or larger</p>
			</div>
			<div class="pass-on"><ChartShare path="/charts" code="charts-book" text="Free German grammar wall charts to print and hang up" /></div>
			<p class="lede">
				{book.charts.length} wall charts for the parts of German that are hard to remember. Each one
				is a single page about a single thing: print it, hang it up, and look at it every day.
			</p>
			<ul>
				<li>One idea per chart, with a box that says where to look first</li>
				<li>The same colours everywhere: one for each case, one for the verb</li>
				<li>The rules and the usual mistakes in short rows at the bottom</li>
				<li>A4 landscape, made to be printed on one side</li>
			</ul>
		</div>
	</header>

	<p class="preview-note">
		<strong>This is a test edition.</strong> The charts are still being tested with learners and more
		are on the way. If something on a chart is unclear or wrong, please
		<a href="#feedback">tell us</a>: it will be fixed in the next edition. The charts, their texts and
		their pictures were made with the help of AI and a lot of human work: every chart was planned, read,
		corrected and redrawn by a person.
	</p>

	<h2 class="list-title">The {book.charts.length} charts</h2>
	<ol class="charts">
		{#each book.charts as chart (chart.n)}
			<li id="chart-{chart.n}">
				<a href={chart.img} target="_blank" rel="noopener" aria-label="Chart {chart.n}: {chart.title}, open the preview in a new tab">
					<img src={chart.img} alt="Chart {chart.n}: {chart.title}" width="1100" height="778" loading="lazy" />
				</a>
				<p class="kind">Chart {chart.n} · Level {chart.level}</p>
				<h3>{chart.title}</h3>
				<p class="topic">{chart.topic}</p>
				<a class="practise" href="/charts/{chart.slug}">Practise in the app · {chart.quizzes.length} {chart.quizzes.length === 1 ? 'quiz' : 'quizzes'} <Icon name="arrowRight" size="0.95em" /></a>
			</li>
		{/each}
	</ol>

	<div class="again">
		<ChartsDownload from="charts-foot" label="Download all {book.charts.length} charts · {book.megabytes} MB" />
	</div>

	<ChartFeedback path="/charts" code="charts-book" title="How are the charts?" shareText="Free German grammar wall charts to print and hang up" />
</main>

<SiteFooter />

<style>
	.top {
		display: grid;
		grid-template-columns: minmax(0, 1.05fr) minmax(0, 1fr);
		gap: 2.2rem;
		align-items: center;
		margin-top: 1rem;
	}

	.cover {
		width: 100%;
		height: auto;
		border-radius: 6px;
		box-shadow:
			0 26px 44px -26px rgba(31, 58, 95, 0.65),
			0 0 0 1px rgba(31, 58, 95, 0.1);
	}

	.where {
		margin: 0;
		font-size: var(--step--1);
		font-weight: 700;
		color: var(--accent-ink);
	}

	h1 {
		margin: 0.2rem 0 0.6rem;
	}

	.text p,
	.text ul {
		line-height: 1.6;
	}

	.text ul {
		margin: 0.6rem 0 1.3rem;
		padding-inline-start: 1.2rem;
	}

	/* The download comes first, right under the title: nobody should scroll for it. */
	.get {
		margin: 0.9rem 0 1.1rem;
	}

	.pass-on {
		max-width: 26rem;
		margin-bottom: 1.2rem;
	}

	.small {
		margin: 0.6rem 0 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.preview-note {
		margin: 2rem 0 0;
		padding: 1rem 1.2rem;
		border: 1px dashed var(--line-strong);
		border-radius: var(--radius);
		line-height: 1.6;
	}

	.preview-note a {
		color: var(--accent-ink);
		font-weight: 700;
	}

	.list-title {
		margin: 2.4rem 0 0;
		font-size: var(--step-2);
		color: var(--heading);
	}

	.charts {
		list-style: none;
		margin: 1.2rem 0 0;
		padding: 0;
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(17rem, 1fr));
		gap: 1.6rem 1.4rem;
	}

	.charts img {
		display: block;
		width: 100%;
		height: auto;
		border-radius: 4px;
		background: #fff;
		box-shadow:
			0 14px 26px -18px rgba(31, 58, 95, 0.6),
			0 0 0 1px rgba(31, 58, 95, 0.14);
		transition: transform var(--medium) var(--ease-out);
	}

	.charts a:hover img {
		transform: translateY(-3px);
	}

	.kind {
		margin: 0.8rem 0 0;
		font-size: 0.74rem;
		font-weight: 800;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--accent-ink);
	}

	.charts h3 {
		margin: 0.15rem 0 0;
		font-size: var(--step-1);
		color: var(--heading);
	}

	.topic {
		margin: 0.2rem 0 0;
		color: var(--ink-muted);
		line-height: 1.45;
	}
	.practise {
		display: inline-flex;
		align-items: center;
		gap: 0.35em;
		margin-top: 0.45rem;
		font-size: var(--step--1);
		font-weight: 700;
		color: var(--navy);
		text-decoration: none;
	}
	.practise:hover {
		text-decoration: underline;
	}

	/* -- the book ---------------------------------------------------------- */
	.pile {
		min-width: 0;
		padding: 4% 7% 0 3%;
		perspective: 1600px;
	}
	.book {
		position: relative;
		transform: rotateY(-16deg) rotateX(5deg) rotate(-1deg);
		transform-origin: 30% 50%;
		border-radius: 3px 7px 7px 3px;
		/* The block of pages: sheets showing along the right and bottom edge,
		   then the shadow the book throws on the table. */
		box-shadow:
			2px 2px 0 #fff,
			3px 3px 0 #cfc9ba,
			5px 5px 0 #fff,
			6px 6px 0 #cfc9ba,
			8px 8px 0 #fff,
			9px 9px 0 #cfc9ba,
			11px 11px 0 #fff,
			12px 12px 0 #b9b2a0,
			34px 44px 50px -18px rgb(31 58 95 / 0.55);
		transition: transform var(--slow) var(--ease-out);
	}
	.book:hover {
		transform: rotateY(-7deg) rotateX(2deg) rotate(0deg);
	}
	.book .cover {
		display: block;
		border-radius: inherit;
		box-shadow: none;
	}
	/* The spine: a dark fold and a line of light just right of it. */
	.book::before {
		content: '';
		position: absolute;
		inset: 0;
		z-index: 1;
		border-radius: inherit;
		background: linear-gradient(
			90deg,
			rgb(0 0 0 / 0.32) 0,
			rgb(0 0 0 / 0.08) 1.6%,
			rgb(255 255 255 / 0.28) 2.6%,
			rgb(0 0 0 / 0.12) 3.8%,
			transparent 6.5%,
			transparent 92%,
			rgb(255 255 255 / 0.08) 100%
		);
		pointer-events: none;
	}
	@media (prefers-reduced-motion: reduce) {
		.book {
			transition: none;
		}
	}
	/* Inner pages: equal sheets, equal gaps, as wide as the book. */
	.inside-head {
		margin: 9% 0 0.5rem;
		font-size: 0.72rem;
		font-weight: 700;
		letter-spacing: 0.08em;
		text-transform: uppercase;
		color: var(--ink-muted);
	}
	.inside {
		display: grid;
		grid-template-columns: repeat(4, minmax(0, 1fr));
		gap: 0.6rem;
	}
	.inside a {
		display: block;
		border-radius: 4px;
		overflow: hidden;
		background: #fff;
		border: 1px solid var(--line-strong);
		box-shadow: 0 6px 14px -8px rgb(31 58 95 / 0.45);
		transition: transform var(--medium) var(--ease-out);
	}
	.inside a:hover,
	.inside a:focus-visible {
		transform: translateY(-4px) scale(1.04);
	}
	.inside img {
		display: block;
		width: 100%;
		height: auto;
	}

	.again {
		margin: 2.4rem 0 0;
		display: flex;
		flex-direction: column;
		align-items: center;
	}



	@media (max-width: 48rem) {
		.top {
			grid-template-columns: minmax(0, 1fr);
			gap: 1.4rem;
		}
	}
</style>
