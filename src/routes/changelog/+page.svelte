<script lang="ts">
	// What's new: the changelog, rendered as a timeline of releases. The list
	// itself lives in $lib/content/changelog.ts — this page only lays it out.
	import Seo from '$lib/components/Seo.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { changelog } from '$lib/content/changelog';
	import { ORGANIZATION, absoluteUrl, breadcrumbLd } from '$lib/seo';
	import { onMount } from 'svelte';
	import { markWhatsNewSeen } from '$lib/state/whatsNew.svelte';

	// Opening the changelog puts out the "something new" dot in the nav.
	onMount(markWhatsNewSeen);

	// "2 October 2026" reads better than an ISO date, and <time> keeps the
	// machine-readable form for crawlers.
	const formatter = new Intl.DateTimeFormat('en-GB', {
		day: 'numeric',
		month: 'long',
		year: 'numeric'
	});
	function pretty(date: string): string {
		return formatter.format(new Date(`${date}T00:00:00`));
	}
</script>

<Seo
	title="What's new — Language Quiz"
	jsonLd={[
		{
			'@context': 'https://schema.org',
			'@type': 'CollectionPage',
			name: "What's new in Language Quiz",
			url: absoluteUrl('/changelog'),
			dateModified: changelog[0]?.date,
			publisher: ORGANIZATION,
			mainEntity: {
				'@type': 'ItemList',
				itemListElement: changelog.slice(0, 10).map((release, i) => ({
					'@type': 'ListItem',
					position: i + 1,
					name: release.title,
					description: release.items.join(' ')
				}))
			}
		},
		breadcrumbLd([
			{ name: 'Home', path: '/' },
			{ name: "What's new", path: '/changelog' }
		])
	]}
	description="The Language Quiz changelog: new features, content and improvements to the free German course, release by release."
	path="/changelog"
/>

<main class="page">
	<a class="back-link" href="/"><Icon name="arrowLeft" size="1em" /> Home</a>
	<h1>What's new</h1>
	<p class="lede">
		Everything that has changed in Language Quiz, newest first. The app keeps
		improving — check back here to see what's arrived since your last visit.
	</p>

	<ol class="timeline">
		{#each changelog as entry (entry.date + entry.title)}
			<li class="release" class:highlight={entry.highlight}>
				<time datetime={entry.date}>{pretty(entry.date)}</time>
				<h2>
					{#if entry.highlight}<Icon name="star" size="1em" />{/if}
					{entry.title}
				</h2>
				<ul>
					{#each entry.items as item (item)}
						<li>{item}</li>
					{/each}
				</ul>
			</li>
		{/each}
	</ol>
</main>

<SiteFooter />

<style>
	h1 {
		margin: 0 0 0.5rem;
	}

	.lede {
		margin: 0 0 2rem;
		max-width: 56ch;
		color: var(--ink-muted);
	}

	/* -- the timeline: a rail on the left, a card per release -------------- */

	.timeline {
		position: relative;
		margin: 0;
		padding: 0 0 0 1.4rem;
		list-style: none;
	}

	.timeline::before {
		content: '';
		position: absolute;
		top: 0.6rem;
		bottom: 0.6rem;
		left: 0.3rem;
		width: 2px;
		background: var(--line);
	}

	.release {
		position: relative;
		padding: 1.35rem 1.6rem;
		margin-bottom: 1.1rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
	}

	/* The dot that ties each card to the rail. */
	.release::before {
		content: '';
		position: absolute;
		top: 1.75rem;
		left: -1.4rem;
		width: 10px;
		height: 10px;
		transform: translateX(-4px);
		border-radius: 50%;
		background: var(--ink-muted);
		border: 2px solid var(--bg);
	}

	.release.highlight {
		border-color: var(--line-strong);
	}

	.release.highlight::before {
		background: var(--heading);
	}

	.release time {
		font-size: var(--step--1);
		font-weight: 600;
		color: var(--ink-muted);
	}

	.release h2 {
		display: flex;
		align-items: center;
		gap: 0.45rem;
		margin: 0.25rem 0 0.6rem;
		font-size: 1.15rem;
	}

	.release ul {
		margin: 0;
		padding-left: 1.1rem;
	}

	.release ul li {
		margin: 0.35rem 0;
		line-height: 1.55;
	}

	@media (max-width: 36rem) {
		.timeline {
			padding-left: 1.1rem;
		}
		.release {
			padding: 1.1rem 1.2rem;
		}
		.release::before {
			left: -1.1rem;
		}
	}
</style>
