<script lang="ts">
	// Every German verb in the course, each a link to its conjugation page.
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { breadcrumbLd, shareImage } from '$lib/seo';
	import { page } from '$app/state';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();
	const courseHref = $derived(page.data.site?.courseHref ?? '/');
</script>

<Seo
	title="{data.verbs.length} German verbs conjugated: Präsens, Perfekt, Präteritum"
	description="Every German verb in the course with full conjugation tables: present, past, perfect, future, imperative and Konjunktiv II, each with audio. Free, no sign-up."
	path="/words/verbs"
	image={shareImage('words', 'verbs')}
	imageAlt="German verbs with their conjugations"
	jsonLd={[
		breadcrumbLd([
			{ name: 'Home', path: '/' },
			{ name: 'Word Library', path: '/words' },
			{ name: 'Verbs', path: '/words/verbs' }
		])
	]}
/>

<SiteNav {courseHref} compact />

<main class="page-wide">
	<a class="back-link" href="/words"><Icon name="arrowLeft" size="1em" /> Word Library</a>
	<h1>German verbs, conjugated</h1>
	<p class="lede">
		{data.verbs.length} verbs, each with its full tables: Präsens, Präteritum, Perfekt, Futur I,
		Imperativ and Konjunktiv II, and audio for every form.
	</p>

	<ul class="grid">
		{#each data.verbs as v (v.slug)}
			<li>
				<a href="/words/verbs/{v.slug}">
					<span class="term" lang="de">{v.verb}</span>
					{#if v.third}<span class="third" lang="de">er {v.third}</span>{/if}
					<span class="gloss">{v.english}</span>
				</a>
			</li>
		{/each}
	</ul>
</main>

<SiteFooter />

<style>
	h1 { margin: 0 0 0.5rem; }
	.lede { margin: 0 0 1.5rem; max-width: 60ch; color: var(--ink-muted); }
	.grid { margin: 0; padding: 0; list-style: none; display: grid; grid-template-columns: repeat(auto-fill, minmax(15rem, 1fr)); gap: 0.15rem 1rem; }
	.grid a { display: flex; align-items: baseline; gap: 0.5rem; padding: 0.35rem 0.5rem; border-radius: var(--radius-sm); color: inherit; text-decoration: none; }
	.grid a:hover { background: var(--surface-alt); }
	.term { font-weight: 600; }
	.third { color: var(--ink-muted); font-size: var(--step--1); }
	.gloss { margin-left: auto; color: var(--ink-muted); font-size: var(--step--1); }
</style>
