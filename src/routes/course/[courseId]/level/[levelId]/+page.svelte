<script lang="ts">
	import Seo from '$lib/components/Seo.svelte';
	import SiteFooter from '$lib/components/SiteFooter.svelte';
	import { absoluteUrl, breadcrumbLd, clip, shareImage, topicOf } from '$lib/seo';
	// A sub-level's syllabus: what it teaches, against what official source,
	// and which exercise covers each item. The learner-facing version of the
	// content master plan's module table — the page to check "have I covered
	// everything for A1?" against.
	import Icon from '$lib/icons/Icon.svelte';
	import RibbonBadge from '$lib/components/RibbonBadge.svelte';
	import InProgressBadge from '$lib/components/InProgressBadge.svelte';
	import { inProgressIds } from '$lib/state/resume';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import { QUIZ_TYPE_ICONS } from '$lib/icons/paths';
	import { onMount } from 'svelte';
	import { DEFAULT_GATING } from '$lib/domain/progress';
	import { progress } from '$lib/state/progress.svelte';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();
	const { course, level, title, module, quizzes, previous, next } = $derived(data);

	onMount(async () => {
		if (!progress.loaded) await progress.load(course.gating ?? DEFAULT_GATING);
		await progress.hydrateStats(quizzes.map((q) => q.storageKeyPrefix));
		inProgress = await inProgressIds(quizzes, (id) => {
			const quiz = quizzes.find((q) => q.id === id)!;
			return progress.isCompleted(quiz.type, quiz.id, quiz.storageKeyPrefix);
		});
	});

	/** Exercises started but not finished, marked in the list. */
	let inProgress = $state<Set<string>>(new Set());

	/** The quizzes that declare a given structure. */
	const coveredBy = $derived((id: string) => quizzes.filter((q) => q.covers?.includes(id)));

	const done = $derived(
		progress.loaded
			? quizzes.filter((q) => progress.isCompleted(q.type, q.id, q.storageKeyPrefix)).length
			: 0
	);
</script>

<Seo
	title="{module?.title ?? topicOf(title)} ({level}) – German course level & exercises | Language Quiz"
	description={clip(
		`German ${level}: ${module?.canDo?.slice(0, 2).join('; ') ?? title}. ${quizzes.length} free exercises mapped to the official ${level.slice(0, 2)} syllabus.`
	)}
	path="/course/{course.id}/level/{level}"
	image={shareImage('level', level)}
	imageAlt="German {level}: {module?.title ?? title}"
	jsonLd={[
		breadcrumbLd([
			{ name: 'Home', path: '/' },
			{ name: course.name, path: `/course/${course.id}` },
			{ name: title, path: `/course/${course.id}/level/${level}` }
		]),
		{
			'@context': 'https://schema.org',
			'@type': 'ItemList',
			name: `${level} exercises`,
			itemListElement: quizzes.map((q, i) => ({
				'@type': 'ListItem',
				position: i + 1,
				url: absoluteUrl(`/course/${course.id}/quiz/${q.id}`),
				name: topicOf(q.title)
			}))
		}
	]}
/>

<SiteNav courseHref="/course/{course.id}" compact />

<main class="page-wide">
	<a class="back-link" href="/course/{course.id}"><Icon name="arrowLeft" size="1em" /> {course.name}</a>

	<header class="head">
		<p class="eyebrow">{level} · Syllabus</p>
		<h1>{title}{#if module?.subtitle}<span class="sub"> · {module.subtitle}</span>{/if}</h1>
		<p class="count tnum">{done} / {quizzes.length} exercises done</p>
	</header>

	{#if module && (module.canDo.length || module.themes.length)}
		<section class="two">
			{#if module.canDo.length}
				<div>
					<h2>After this level you can</h2>
					<ul>
						{#each module.canDo as item (item)}<li>{item}</li>{/each}
					</ul>
				</div>
			{/if}
			{#if module.themes.length}
				<div>
					<h2>Themes</h2>
					<ul>
						{#each module.themes as item (item)}<li>{item}</li>{/each}
					</ul>
				</div>
			{/if}
		</section>
	{/if}

	{#if module?.structures.length}
		<h2>What it teaches</h2>
		<p class="lede">
			Each line is a structure the official syllabus requires at this level, and the
			exercises that teach it.
		</p>
		<div class="table-wrap">
			<table class="structures">
				<thead>
					<tr><th>Structure</th><th>Official level</th><th>Exercises</th></tr>
				</thead>
				<tbody>
					{#each module.structures as s (s.id)}
						{@const qs = coveredBy(s.id)}
						<tr class:uncovered={qs.length === 0}>
							<td>{s.label}</td>
							<td class="official">{s.official ?? ''}</td>
							<td>
								{#if qs.length === 0}
									<span class="soon">coming</span>
								{:else}
									{#each qs as q, i (q.id)}{#if i > 0}, {/if}<a href="/course/{course.id}/quiz/{q.id}">{q.title.replace(/^[A-C][12]\.[12] · /, '')}</a>{/each}
								{/if}
							</td>
						</tr>
					{/each}
				</tbody>
			</table>
		</div>
	{/if}

	{#if module?.exam?.length}
		<h2>Towards a certificate</h2>
		<ul class="exam">
			{#each (Array.isArray(module.exam) ? module.exam : [module.exam]) as item (item)}<li>{item}</li>{/each}
		</ul>
	{/if}

	<h2>The exercises</h2>
	<ol class="quizzes">
		{#each quizzes as quiz (quiz.id)}
			{@const ribbon = progress.loaded
				? progress.ribbonFor(quiz.type, quiz.id, quiz.storageKeyPrefix)
				: null}
			<li>
				<a href="/course/{course.id}/quiz/{quiz.id}">
					{#if quiz.image}
						<img class="thumb" src="/img/{quiz.image}.webp" alt="" width="1024" height="768" loading="lazy" />
					{:else}
						<span class="kind" data-kind={quiz.type}><Icon name={QUIZ_TYPE_ICONS[quiz.type]} size="1em" /></span>
					{/if}
					<span class="title">{quiz.title}</span>
					{#if quiz.status === 'placeholder'}<span class="soon">preview</span>{/if}
					{#if ribbon}<RibbonBadge tier={ribbon} width={13} />
					{:else if inProgress.has(quiz.id)}<InProgressBadge />{/if}
				</a>
			</li>
		{/each}
	</ol>

	<nav class="pager">
		{#if previous}<a href="/course/{course.id}/level/{previous}"><Icon name="arrowLeft" size="1em" /> {previous}</a>{:else}<span></span>{/if}
		{#if next}<a href="/course/{course.id}/level/{next}">{next} <Icon name="arrowRight" size="1em" /></a>{/if}
	</nav>
</main>

<SiteFooter />

<style>
	.head { margin-bottom: 1.5rem; }
	.eyebrow { margin: 0; font-size: var(--step--1); font-weight: 700; letter-spacing: 0.05em; color: var(--ink-muted); }
	h1 { margin: 0.3rem 0 0.4rem; }
	.sub { font-weight: 400; color: var(--ink-muted); }
	.count { margin: 0; color: var(--ink-muted); }
	h2 { margin: 2rem 0 0.5rem; font-size: var(--step-1); }
	.lede { margin: 0 0 0.75rem; color: var(--ink-muted); }

	.two { display: grid; grid-template-columns: repeat(auto-fit, minmax(16rem, 1fr)); gap: 1rem 2rem; }
	.two h2 { margin-top: 1rem; }
	.two ul, .exam { margin: 0; padding-left: 1.2rem; }
	.two li, .exam li { margin-bottom: 0.3rem; }

	.table-wrap { overflow-x: auto; }
	.structures { border-collapse: collapse; width: 100%; font-size: var(--step--1); }
	.structures th, .structures td { padding: 0.5rem 0.7rem; text-align: left; border-bottom: 1px solid var(--line); vertical-align: top; }
	.structures thead th { font-size: 0.72rem; font-weight: 800; letter-spacing: 0.06em; text-transform: uppercase; color: var(--ink-muted); }
	.official { white-space: nowrap; color: var(--ink-muted); }
	.uncovered td { color: var(--ink-muted); }
	.soon { display: inline-block; padding: 0.1rem 0.5rem; border-radius: 999px; background: var(--surface-alt); font-size: 0.7rem; font-weight: 700; letter-spacing: 0.04em; text-transform: uppercase; color: var(--ochre, #8a6d1f); }

	.quizzes { margin: 0; padding: 0; list-style: none; display: grid; gap: 0.2rem; }
	.quizzes a { display: flex; align-items: center; gap: 0.7rem; padding: 0.5rem 0.7rem; border-radius: var(--radius-sm); color: inherit; text-decoration: none; }
	.quizzes a:hover { background: var(--surface-alt); }
	.title { flex: 1; font-size: var(--step--1); }
	.thumb { width: 2.6rem; height: 1.9rem; flex: none; border-radius: 6px; background: #fbf5e4; object-fit: cover; }
	.kind { display: inline-flex; align-items: center; justify-content: center; width: 1.9rem; height: 1.9rem; flex: none; border-radius: 50%; background: var(--surface-alt); color: var(--ink-muted); }
	.kind[data-kind='fillBlank'] { background: #ebe7f4; color: #55478a; }
	.kind[data-kind='vocabulary'] { background: #f9e7ee; color: #a33a63; }
	.kind[data-kind='reading'] { background: #e6ecf3; color: var(--navy); }
	.kind[data-kind='listening'] { background: #e8efe9; color: var(--forest); }
	.kind[data-kind='dictation'] { background: #f4eddc; color: var(--ochre-ink); }
	.kind[data-kind='speakRepeat'] { background: #fbe9e2; color: #b5522a; }
	.kind[data-kind='speaking'] { background: var(--accent-soft); color: var(--accent-ink); }

	.pager { display: flex; justify-content: space-between; margin-top: 2.5rem; padding-top: 1rem; border-top: 1px solid var(--line); }
	.pager a { display: inline-flex; align-items: center; gap: 0.35rem; text-decoration: none; font-weight: 700; }
</style>
