<script lang="ts">
	// Picture credits and what else this site is made of (docs/rights_audit.md).
	// Every photo is listed with the credit its licence asks for; every short
	// credit under a photo on the site links to its line here.
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { returnTo, returnLabel } from '$lib/state/returnTo.svelte';
	import { breadcrumbLd } from '$lib/seo';
	import { page } from '$app/state';

	let { data } = $props();
</script>

<Seo
	title="Picture credits — Language Quiz"
	description="Where every photo and picture on Language Quiz and in its books comes from, with the credit each licence asks for."
	path="/credits"
	jsonLd={[breadcrumbLd([{ name: 'Home', path: '/' }, { name: 'Picture credits', path: '/credits' }])]}
/>

<SiteNav courseHref={page.data.site?.courseHref ?? '/'} />

<main class="page">
	<a class="back-link" href={returnTo.path}><Icon name="arrowLeft" size="1em" /> {returnLabel(returnTo.path)}</a>
	<h1>Picture credits</h1>
	<p class="lede">
		Where the pictures, sounds and fonts on this site and in its books come from. Every photo is
		from Wikimedia Commons, under a licence that allows this use; our copies are cropped and
		colour-adjusted, so each is marked “modified”.
	</p>

	<section id="made">
		<h2>What we made</h2>
		<ul>
			<li><b>Word pictures, story and game pictures:</b> made with AI (Google’s Gemini image model) for Language Quiz.</li>
			<li><b>Texts, exercises and explanations:</b> written for Language Quiz, with the help of AI (Anthropic’s Claude). German literature quoted in the course is in the public domain.</li>
			<li><b>Spoken audio:</b> generated with Google Cloud Text-to-Speech. Sound effects are made in code.</li>
			<li><b>Diagrams, icons, logo, covers and layout:</b> Language Quiz.</li>
			<li><b>Fonts:</b> Inter, Source Serif 4, Noto Sans Arabic and Noto Naskh Arabic, under the SIL Open Font License 1.1.</li>
		</ul>
	</section>

	<section id="photos">
		<h2>Photos ({data.photos.length})</h2>
		<ol class="photos">
			{#each data.photos as p (p.id)}
				<li id={p.id}>
					<b lang="de">{p.title}</b><br />
					{p.line}
					<span class="links">
						<a href={p.fileUrl} rel="noopener">file</a>
						{#if p.licenseUrl}· <a href={p.licenseUrl} rel="noopener">licence</a>{/if}
					</span>
				</li>
			{/each}
		</ol>
	</section>
</main>

<SiteFooter />

<style>
	.page {
		max-width: 46rem;
		margin: 0 auto;
		padding: 1.25rem 1rem 4rem;
	}
	.back-link {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
		color: var(--ink-muted);
		font-size: var(--step--1);
		text-decoration: none;
	}
	h1 {
		margin: 0.75rem 0 0.4rem;
		color: var(--heading);
	}
	.lede {
		color: var(--ink-muted);
	}
	h2 {
		margin: 2rem 0 0.6rem;
		color: var(--heading);
		font-size: 1.3rem;
	}
	ul {
		display: grid;
		gap: 0.5rem;
		padding-left: 1.2rem;
	}
	.photos {
		display: grid;
		gap: 0.7rem;
		padding-left: 1.6rem;
		font-size: var(--step--1);
		line-height: 1.45;
		overflow-wrap: anywhere;
	}
	.photos li:target {
		background: var(--accent-soft);
		outline: 2px solid var(--accent);
		outline-offset: 4px;
		border-radius: 4px;
	}
	.links {
		margin-left: 0.3rem;
		white-space: nowrap;
	}
	.links a {
		color: var(--accent-ink);
	}
</style>
