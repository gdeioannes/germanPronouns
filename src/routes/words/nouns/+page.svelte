<script lang="ts">
	// Every German noun in the course, by theme, each a link to its own page.
	// Plain lists rather than the library's search box: this is the page a
	// crawler walks and a reader skims.
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { breadcrumbLd, shareImage } from '$lib/seo';
	import { GENDER_ARTICLES, GENDER_COLORS } from '$lib/domain/gender';
	import { page } from '$app/state';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();
	const courseHref = $derived(page.data.site?.courseHref ?? '/');
</script>

<Seo
	title="{data.total} German nouns with der, die, das and plural | Language Quiz"
	description="Every German noun in the course by theme: its article (der, die or das), its plural, its English meaning and an example sentence with audio. Free, no sign-up."
	path="/words/nouns"
	image={shareImage('words', 'nouns')}
	imageAlt="German nouns with their articles and plurals"
	jsonLd={[
		breadcrumbLd([
			{ name: 'Home', path: '/' },
			{ name: 'Word Library', path: '/words' },
			{ name: 'Nouns', path: '/words/nouns' }
		])
	]}
/>

<SiteNav {courseHref} compact />

<main class="page-wide">
	<a class="back-link" href="/words"><Icon name="arrowLeft" size="1em" /> Word Library</a>
	<h1>German nouns, with their articles</h1>
	<p class="lede">
		{data.total} nouns, grouped by theme. Every one is shown with <strong style="color:{GENDER_COLORS.m}">der</strong>,
		<strong style="color:{GENDER_COLORS.f}">die</strong> or <strong style="color:{GENDER_COLORS.n}">das</strong>,
		because a German noun is learnt with its article or not at all. Open a word for its plural,
		its cases, an example sentence with audio and the exercises that practise it.
	</p>

	<nav class="themes" aria-label="Themes">
		{#each data.groups as g (g.id)}
			<a href="#{g.id}">{g.name} <span class="tnum">{g.nouns.length}</span></a>
		{/each}
	</nav>

	{#each data.groups as g (g.id)}
		<section id={g.id}>
			<h2>{g.name}</h2>
			<ul class="grid">
				{#each g.nouns as n (n.slug)}
					<li>
						<a href="/words/nouns/{n.slug}">
							{#if n.image}
								<img class="thumb" src={n.image} alt="" width="512" height="512" loading="lazy" />
							{/if}
							<span class="article" style="color:{GENDER_COLORS[n.gender]}">{GENDER_ARTICLES[n.gender]}</span>
							<span class="term" lang="de">{n.noun}</span>
							<span class="gloss">{n.english}</span>
						</a>
					</li>
				{/each}
			</ul>
		</section>
	{/each}
</main>

<SiteFooter />

<style>
	h1 { margin: 0 0 0.5rem; }
	.lede { margin: 0 0 1.5rem; max-width: 60ch; color: var(--ink-muted); }
	.themes { display: flex; flex-wrap: wrap; gap: 0.4rem; margin-bottom: 1.5rem; font-size: var(--step--1); }
	.themes a { padding: 0.25rem 0.7rem; border: 1px solid var(--line); border-radius: 999px; color: var(--ink); text-decoration: none; }
	.themes a:hover { border-color: var(--accent); color: var(--accent-ink); }
	.themes .tnum { color: var(--ink-muted); }
	h2 { margin: 2rem 0 0.5rem; font-size: var(--step-1); }
	.grid { margin: 0; padding: 0; list-style: none; display: grid; grid-template-columns: repeat(auto-fill, minmax(14rem, 1fr)); gap: 0.15rem 1rem; }
	.grid a { display: flex; align-items: baseline; gap: 0.45rem; padding: 0.35rem 0.5rem; border-radius: var(--radius-sm); color: inherit; text-decoration: none; }
	.grid a:hover { background: var(--surface-alt); }
	.thumb { width: 2.1rem; height: 2.1rem; flex: none; align-self: center; margin: -0.2rem 0.05rem -0.2rem 0; border-radius: 50%; background: #fbf5e4; object-fit: cover; }
	.article { font-weight: 700; font-size: var(--step--1); min-width: 1.9rem; }
	.term { font-weight: 600; }
	.gloss { color: var(--ink-muted); font-size: var(--step--1); }
</style>
