<script lang="ts">
	// The newsletter's own page: the sign-up form and what to expect. This is
	// the address the quiet mentions link to (the download panel, a book's
	// page, the tip after a few finished exercises) and the one to print or
	// share: languagequiz.org/newsletter. `?from=` says which mention brought
	// the reader, so the statistics show which placement earns its place.
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import NewsletterSignup from '$lib/components/NewsletterSignup.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { returnTo, returnLabel } from '$lib/state/returnTo.svelte';
	import { breadcrumbLd } from '$lib/seo';
	import { onMount } from 'svelte';
	import { page } from '$app/state';

	const FROM = new Set(['download', 'book-page', 'results', 'book']);
	let where = $state('page');
	// Read in the browser: the page is prerendered, so the query is not known before.
	onMount(() => {
		const from = new URLSearchParams(location.search).get('from') ?? '';
		if (FROM.has(from)) where = from;
	});
</script>

<Seo
	title="Newsletter: what's new in Language Quiz, once a week"
	description="One short email a week about the free German course: new lessons, new reading and listening texts, new book editions and what was fixed. Unsubscribe with one click."
	path="/newsletter"
	jsonLd={[breadcrumbLd([{ name: 'Home', path: '/' }, { name: 'Newsletter', path: '/newsletter' }])]}
/>

<SiteNav courseHref={page.data.site?.courseHref ?? '/'} />

<main class="page">
	<a class="back-link" href={returnTo.path}><Icon name="arrowLeft" size="1em" /> {returnLabel(returnTo.path)}</a>
	<h1>The weekly update</h1>
	<p class="lede">
		The course and its books keep changing: new lessons, new texts, corrected editions. One short
		email a week tells you what arrived, so you don't have to come and look.
	</p>

	{#key where}
		<NewsletterSignup {where} />
	{/key}

	<section>
		<h2>What you get</h2>
		<ul>
			<li><strong>New in the course</strong>: lessons, exercises, reading and listening texts.</li>
			<li><strong>New book editions</strong>: when a book you downloaded has been corrected or extended.</li>
			<li><strong>What was fixed</strong>: mistakes found and put right.</li>
		</ul>
		<p>
			Nothing else: no advertising, and your address is never passed on. Every email ends with a
			link that unsubscribes you with one click. The details are in the
			<a href="/legal#newsletter">privacy notice</a>, and everything already published is on
			<a href="/changelog">What's new</a>.
		</p>
	</section>
</main>

<SiteFooter />

<style>
	h1 {
		margin: 0 0 0.5rem;
	}

	.lede {
		margin: 0 0 1.75rem;
		max-width: 56ch;
		color: var(--ink-muted);
	}

	section {
		margin: 2.5rem 0 0;
		max-width: 62ch;
	}

	h2 {
		margin: 0 0 0.6rem;
	}

	ul {
		margin: 0 0 1rem;
		padding-inline-start: 1.2rem;
		line-height: 1.6;
	}
</style>
