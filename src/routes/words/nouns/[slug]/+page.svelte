<script lang="ts">
	// One German noun: its article, plural, cases, an example with audio, the
	// exercises that use it and its neighbours by theme. The page someone lands
	// on from "Tisch der die das" or "plural of Apfel".
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import SpeakButton from '$lib/components/SpeakButton.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { QUIZ_TYPE_ICONS } from '$lib/icons/paths';
	import { breadcrumbLd, definedTermLd, shareImage, topicOf } from '$lib/seo';
	import { GENDER_ARTICLES, GENDER_COLORS } from '$lib/domain/gender';
	import { withArticle } from '$lib/domain/words';
	import { page } from '$app/state';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();
	const { entry, plural, example, cases, categories, quizzes, related } = $derived(data);
	const courseHref = $derived(page.data.site?.courseHref ?? '/');
	const courseId = $derived(page.data.site?.courseId ?? '');

	const LOCALE = 'de-DE';
	const GENDER_NAME: Record<string, string> = { m: 'masculine', f: 'feminine', n: 'neuter' };
	const path = $derived(`/words/nouns/${data.slug}`);
	const headline = $derived(withArticle(entry));
	const title = $derived(`${headline} – ${GENDER_ARTICLES[entry.gender]} or die? plural, cases, "${entry.english}" | Language Quiz`);
	const description = $derived(
		`${headline} means "${entry.english}" and is ${GENDER_NAME[entry.gender]}${
			plural ? `; the plural is die ${plural}` : ''
		}. Cases, an example sentence with audio and exercises to practise it.`
	);
</script>

<Seo
	{title}
	{description}
	{path}
	type="article"
	image={shareImage('words', 'nouns')}
	imageAlt="German nouns with their articles and plurals"
	jsonLd={[
		breadcrumbLd([
			{ name: 'Home', path: '/' },
			{ name: 'Word Library', path: '/words' },
			{ name: 'Nouns', path: '/words/nouns' },
			{ name: headline, path }
		]),
		definedTermLd({
			name: headline,
			description,
			path,
			setPath: '/words/nouns',
			setName: 'German nouns'
		})
	]}
/>

<SiteNav {courseHref} compact />

<main class="page">
	<nav class="crumbs" aria-label="Breadcrumb">
		<a href="/words/nouns"><Icon name="arrowLeft" size="1em" /> German nouns</a>
	</nav>

	<header class="head" class:pictured={data.image}>
		{#if data.image}
			<img class="pic" src={data.image} alt="{entry.english}: {headline}" width="512" height="512" />
		{/if}
		<p class="eyebrow">{GENDER_NAME[entry.gender]} noun · {categories.map((c) => c.name).join(' · ')}</p>
		<h1 lang="de">
			<span class="article" style="color:{GENDER_COLORS[entry.gender]}">{GENDER_ARTICLES[entry.gender]}</span>
			{entry.noun}
		</h1>
		<p class="meaning">
			<span class="en">{entry.english}</span>
			<SpeakButton text={headline} locale={LOCALE} />
		</p>
	</header>

	<dl class="facts">
		<div>
			<dt>Article</dt>
			<dd><strong style="color:{GENDER_COLORS[entry.gender]}">{GENDER_ARTICLES[entry.gender]}</strong> ({GENDER_NAME[entry.gender]})</dd>
		</div>
		<div>
			<dt>Plural</dt>
			<dd>{#if plural}<span lang="de">die {plural}</span>{:else}no plural{/if}</dd>
		</div>
		{#if entry.meanings?.es}
			<div>
				<dt>Spanish</dt>
				<dd lang="es">{entry.meanings.es}</dd>
			</div>
		{/if}
	</dl>

	{#if example}
		<section>
			<h2>In a sentence</h2>
			<p class="example">
				<span lang="de">{example}</span>
				<SpeakButton text={example} locale={LOCALE} />
			</p>
		</section>
	{/if}

	{#if cases}
		<section>
			<h2>Cases</h2>
			<div class="table-wrap">
				<table>
					<thead>
						<tr><th></th><th>Singular</th><th>Plural</th></tr>
					</thead>
					<tbody>
						{#each cases as row (row.label)}
							<tr>
								<th scope="row">{row.label}</th>
								<td lang="de">{row.singular}</td>
								<td lang="de">{row.plural ?? '—'}</td>
							</tr>
						{/each}
					</tbody>
				</table>
			</div>
		</section>
	{/if}

	{#if quizzes.length}
		<section>
			<h2>Practise it</h2>
			<ul class="quizzes">
				{#each quizzes as q (q.id)}
					<li>
						<a href="/course/{courseId}/quiz/{q.id}">
							<span class="kind"><Icon name={QUIZ_TYPE_ICONS[q.type]} size="1em" /></span>
							<span class="title">{topicOf(q.title)}</span>
							<span class="level tnum">{q.level ?? ''}</span>
						</a>
					</li>
				{/each}
			</ul>
		</section>
	{/if}

	{#if related.length}
		<section>
			<h2>More {categories[0]?.name.toLowerCase() ?? 'words'}</h2>
			<ul class="related">
				{#each related as n (n.slug)}
					<li>
						<a href="/words/nouns/{n.slug}">
							<span style="color:{GENDER_COLORS[n.gender]}">{GENDER_ARTICLES[n.gender]}</span>
							<span lang="de">{n.noun}</span>
							<span class="gloss">{n.english}</span>
						</a>
					</li>
				{/each}
			</ul>
		</section>
	{/if}
</main>

<SiteFooter />

<style>
	.crumbs { margin-bottom: 1rem; font-size: var(--step--1); }
	.crumbs a { display: inline-flex; align-items: center; gap: 0.35rem; color: var(--ink-muted); text-decoration: none; font-weight: 600; }
	/* With a picture the header is two columns: words left, the drawing right,
	   on its own cream disc so it sits on the page like a card. */
	.head.pictured { display: grid; grid-template-columns: minmax(0, 1fr) auto; grid-template-areas: 'eyebrow pic' 'h1 pic' 'meaning pic'; column-gap: 1.5rem; align-items: center; }
	.head.pictured .eyebrow { grid-area: eyebrow; }
	.head.pictured h1 { grid-area: h1; }
	.head.pictured .meaning { grid-area: meaning; }
	.pic { grid-area: pic; width: clamp(6rem, 22vw, 9.5rem); height: auto; border-radius: 50%; background: #fbf5e4; }
	.eyebrow { margin: 0; font-size: var(--step--1); font-weight: 700; letter-spacing: 0.05em; color: var(--ink-muted); }
	h1 { margin: 0.3rem 0 0.4rem; font-size: var(--step-3); }
	.article { font-weight: 600; }
	.meaning { display: flex; align-items: center; gap: 0.6rem; margin: 0 0 1.5rem; font-size: var(--step-1); }
	.en { color: var(--ink-muted); }
	.facts { display: grid; grid-template-columns: repeat(auto-fit, minmax(9rem, 1fr)); gap: 0.75rem; margin: 0; }
	.facts div { padding: 0.75rem 0.9rem; border: 1px solid var(--line); border-radius: var(--radius); background: var(--surface); }
	dt { font-size: 0.72rem; font-weight: 800; letter-spacing: 0.06em; text-transform: uppercase; color: var(--ink-muted); }
	dd { margin: 0.2rem 0 0; }
	h2 { margin: 2rem 0 0.5rem; font-size: var(--step-1); }
	.example { display: flex; align-items: center; gap: 0.6rem; margin: 0; padding: 0.9rem 1rem; border-left: 4px solid var(--accent); background: var(--accent-soft); border-radius: var(--radius-sm); }
	.table-wrap { overflow-x: auto; }
	table { border-collapse: collapse; width: 100%; }
	th, td { padding: 0.5rem 0.7rem; text-align: left; border-bottom: 1px solid var(--line); }
	thead th { font-size: 0.72rem; font-weight: 800; letter-spacing: 0.06em; text-transform: uppercase; color: var(--ink-muted); }
	tbody th { font-weight: 600; color: var(--ink-muted); white-space: nowrap; }
	.quizzes, .related { margin: 0; padding: 0; list-style: none; display: grid; gap: 0.2rem; }
	.quizzes a { display: flex; align-items: center; gap: 0.7rem; padding: 0.5rem 0.7rem; border-radius: var(--radius-sm); color: inherit; text-decoration: none; }
	.quizzes a:hover, .related a:hover { background: var(--surface-alt); }
	.kind { display: inline-flex; align-items: center; justify-content: center; width: 1.9rem; height: 1.9rem; flex: none; border-radius: 50%; background: var(--surface-alt); color: var(--ink-muted); }
	.title { flex: 1; }
	.level { color: var(--ink-muted); font-size: var(--step--1); }
	.related { grid-template-columns: repeat(auto-fill, minmax(12rem, 1fr)); }
	.related a { display: flex; gap: 0.4rem; align-items: baseline; padding: 0.35rem 0.5rem; border-radius: var(--radius-sm); color: inherit; text-decoration: none; }
	.gloss { color: var(--ink-muted); font-size: var(--step--1); }
</style>
