<script lang="ts">
	// One German verb with every conjugation table the collection has, each
	// form with audio. The page for "konjugation sein" or "haben present tense".
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import SpeakButton from '$lib/components/SpeakButton.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { spokenVerbForm } from '$lib/domain/spoken';
	import { breadcrumbLd, clip, definedTermLd, shareImage, titleWithSite } from '$lib/seo';
	import { page } from '$app/state';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();
	const { entry, related } = $derived(data);
	const courseHref = $derived(page.data.site?.courseHref ?? '/');

	const LOCALE = 'de-DE';
	const path = $derived(`/words/verbs/${data.slug}`);
	const labels = $derived(entry.sets.map((s) => s.label));
	const present = $derived(entry.sets.find((s) => s.label === 'Präsens'));
	const title = $derived(titleWithSite(`${entry.verb} conjugation – ${labels.slice(0, 3).join(', ')}`));
	const description = $derived(
		clip(
			`Conjugate the German verb ${entry.verb} ("${entry.english}")` +
				(present ? `. Präsens: ${present.forms.map((f) => `${f.person} ${f.form}`).join(', ')}` : '') +
				(labels.some((l) => l !== 'Präsens')
					? `. Also ${labels.filter((l) => l !== 'Präsens').join(', ')}.`
					: '.')
		)
	);
</script>

<Seo
	{title}
	{description}
	{path}
	type="article"
	image={shareImage('words', 'verbs')}
	imageAlt="German verbs with their conjugations"
	jsonLd={[
		breadcrumbLd([
			{ name: 'Home', path: '/' },
			{ name: 'Word Library', path: '/words' },
			{ name: 'Verbs', path: '/words/verbs' },
			{ name: entry.verb, path }
		]),
		definedTermLd({
			name: entry.verb,
			description,
			path,
			setPath: '/words/verbs',
			setName: 'German verbs'
		})
	]}
/>

<SiteNav {courseHref} compact />

<main class="page">
	<nav class="crumbs" aria-label="Breadcrumb">
		<a href="/words/verbs"><Icon name="arrowLeft" size="1em" /> German verbs</a>
	</nav>

	<header class="head">
		<p class="eyebrow">verb · {labels.length} tenses and moods</p>
		<h1 lang="de">{entry.verb}</h1>
		<p class="meaning">
			<span class="en">{entry.english}</span>
			{#if entry.meanings?.es}<span class="es" lang="es">· {entry.meanings.es}</span>{/if}
			<SpeakButton text={entry.verb} locale={LOCALE} />
		</p>
	</header>

	<div class="sets">
		{#each entry.sets as set (set.label)}
			<section>
				<h2 id={set.label.toLowerCase().replace(/\s+/g, '-')}>{set.label}</h2>
				<table>
					<tbody>
						{#each set.forms as form (form.person)}
							<tr>
								<th scope="row" lang="de">{form.person}</th>
								<td lang="de">{form.form}</td>
								<td class="say"><SpeakButton text={spokenVerbForm(form)} locale={LOCALE} /></td>
							</tr>
						{/each}
					</tbody>
				</table>
			</section>
		{/each}
	</div>

	{#if related.length}
		<section>
			<h2>More verbs</h2>
			<ul class="related">
				{#each related as v (v.slug)}
					<li><a href="/words/verbs/{v.slug}"><span lang="de">{v.verb}</span> <span class="gloss">{v.english}</span></a></li>
				{/each}
			</ul>
		</section>
	{/if}
</main>

<SiteFooter />

<style>
	.crumbs { margin-bottom: 1rem; font-size: var(--step--1); }
	.crumbs a { display: inline-flex; align-items: center; gap: 0.35rem; color: var(--ink-muted); text-decoration: none; font-weight: 600; }
	.eyebrow { margin: 0; font-size: var(--step--1); font-weight: 700; letter-spacing: 0.05em; color: var(--ink-muted); }
	h1 { margin: 0.3rem 0 0.4rem; font-size: var(--step-3); }
	.meaning { display: flex; align-items: center; flex-wrap: wrap; gap: 0.6rem; margin: 0 0 1.5rem; font-size: var(--step-1); }
	.en, .es { color: var(--ink-muted); }
	.sets { display: grid; grid-template-columns: repeat(auto-fit, minmax(16rem, 1fr)); gap: 0 2rem; }
	h2 { margin: 1.5rem 0 0.4rem; font-size: var(--step-0); }
	table { border-collapse: collapse; width: 100%; }
	th, td { padding: 0.35rem 0.6rem; text-align: left; border-bottom: 1px solid var(--line); }
	tbody th { font-weight: 600; color: var(--ink-muted); white-space: nowrap; width: 5.5rem; }
	.say { width: 2.5rem; text-align: right; }
	.related { margin: 0; padding: 0; list-style: none; display: grid; grid-template-columns: repeat(auto-fill, minmax(12rem, 1fr)); gap: 0.2rem; }
	.related a { display: flex; gap: 0.4rem; align-items: baseline; padding: 0.35rem 0.5rem; border-radius: var(--radius-sm); color: inherit; text-decoration: none; }
	.related a:hover { background: var(--surface-alt); }
	.gloss { color: var(--ink-muted); font-size: var(--step--1); }
</style>
