<script lang="ts">
	// The "App" side of one printed page: its quizzes, each tied to the
	// exercise or box on the page it practises. The learner starts anywhere;
	// inside a quiz, back / previous / next stay within this list
	// (state/bookOpen), like a deck of its own.
	import { onMount } from 'svelte';
	import { t, tk } from '$lib/i18n/t';
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import DoneMark from '$lib/components/DoneMark.svelte';
	import BookAppSwitch from '$lib/components/book2/BookAppSwitch.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { QUIZ_TYPE_ICONS } from '$lib/icons/paths';
	import { progress } from '$lib/state/progress.svelte';
	import { storage } from '$lib/services/storage';
	import { BOOK_PLACE_KEY } from '$lib/domain/bookStudy';
	import { appListHref, bookPageHref, listQuizHref, saveList, setSide } from '$lib/state/bookOpen';
	import { inLangChapter } from '$lib/i18n/content.svelte';
	import type { PageData } from './$types';
	import { pushState } from '$app/navigation';
	import { page } from '$app/state';

	let { data }: { data: PageData } = $props();

	const PART_TITLE: Record<string, string> = {
		woerter: 'Wörter',
		lesen: 'Lesen',
		'grammatik-1': 'Grammatik 1',
		'grammatik-2': 'Grammatik 2',
		alltag: 'Alltag',
		'uebungen-1': 'Übungen 1',
		'uebungen-2': 'Übungen 2'
	};
	const KIND: Record<string, [string, string]> = {
		fillBlank: [tk('Practise'), 'Üben'],
		listening: [tk('Listen'), 'Hören'],
		reading: [tk('Read'), 'Lesen'],
		dictation: [tk('Dictation'), 'Diktat'],
		writing: [tk('Write'), 'Schreiben'],
		speaking: [tk('Speak'), 'Sprechen'],
		speakRepeat: [tk('Say it'), 'Nachsprechen'],
		vocabulary: [tk('Word cards'), 'Wortkarten'],
		suchbild: [tk('Picture hunt'), 'Suchbild']
	};
	/** From B1 the page speaks German, like the book it belongs to. */
	const g = (de: string, en: string) => (data.german ? de : en);

	// The tabs switch pages in place: every page's list came with this one, and
	// the address follows (shallow routing), so a reload lands on the same tab.
	const part = $derived(page.state.bookPart ?? data.part);
	const quizzes = $derived(data.lists[part] ?? []);
	// In Turkish, Arabic or Ukrainian the for / note lines come through the level's overlay.
	const local = $derived(inLangChapter({ id: data.chapter.id, appQuizzes: data.appQuizzes }, data.level).appQuizzes);
	/** "19 sentences", "6 Fragen": the size in the page's language. */
	function sizeOf(q: (typeof quizzes)[number]): string | null {
		if (!q.size) return null;
		const { n, unit } = q.size;
		const de = { sentences: 'Sätze', questions: 'Fragen', gaps: 'Lücken', phrases: 'Sätze', cards: 'Karten' }[unit];
		if (data.german) return `${n} ${de}`;
		switch (unit) {
			case 'sentences':
				return t('{n} sentences', { n });
			case 'questions':
				return t('{n} questions', { n });
			case 'gaps':
				return t('{n} gaps', { n });
			case 'phrases':
				return t('{n} phrases', { n });
			case 'cards':
				return t('{n} cards', { n });
		}
	}
	const forOf = (q: (typeof quizzes)[number]) => local?.[part]?.[q.at]?.for ?? q.for;
	const noteOf = (q: (typeof quizzes)[number]) => local?.[part]?.[q.at]?.note ?? q.note;
	const here = $derived(appListHref(data.courseId, data.level, data.chapter.id, part));
	const bookHref = $derived(bookPageHref(data.courseId, data.level, data.chapter.id, part));
	const pageTitle = $derived(PART_TITLE[part] ?? part);

	function showPage(p: string, e: MouseEvent) {
		if (e.metaKey || e.ctrlKey || e.shiftKey || e.button !== 0) return;
		e.preventDefault();
		if (p === part) return;
		pushState(appListHref(data.courseId, data.level, data.chapter.id, p), { bookPart: p });
	}

	onMount(() => {
		void setSide('app');
		void (async () => {
			await progress.ensureLoaded();
			await progress.hydrateStats(Object.values(data.lists).flat().map((q) => q.storageKeyPrefix));
		})();
	});
	// The list is this page's deck: kept for the session, renewed per page,
	// and the place in the book follows the tab.
	$effect(() => {
		void storage.set(
			BOOK_PLACE_KEY,
			JSON.stringify({ level: data.level, chapter: data.chapter.id, n: data.chapter.n, title: data.chapter.title, part, at: Date.now() })
		);
		saveList({
			label: pageTitle,
			href: here,
			quizzes: quizzes.map((q) => ({ id: q.id, title: q.title }))
		});
	});

	const marks = $derived(
		quizzes.map((q) => (progress.loaded ? progress.markFor(q.type, q.id, q.storageKeyPrefix) : null))
	);
	/** Done = finished and passed; "retry" is finished but marked for another go. */
	const isDone = (m: (typeof marks)[number]) => !!m && m !== 'retry';
	const doneCount = $derived(marks.filter(isDone).length);
	/** The first quiz not done yet: where "Start" points. */
	const firstOpen = $derived(marks.findIndex((m) => !isDone(m)));

	// How far along each page of the chapter is, for the tabs, and the chapter
	// as a whole (a quiz on two pages counts once).
	type Q = (typeof data.lists)[string][number];
	const doneQuiz = (q: Q) => progress.loaded && isDone(progress.markFor(q.type, q.id, q.storageKeyPrefix));
	const pageStats = $derived(
		Object.fromEntries(data.pages.map((p) => [p, { done: data.lists[p].filter(doneQuiz).length, n: data.lists[p].length }]))
	);
	// On a phone the tabs scroll sideways: keep the current one in view.
	let tabsEl = $state<HTMLElement>();
	$effect(() => {
		void part;
		tabsEl?.querySelector('a.on')?.scrollIntoView({ block: 'nearest', inline: 'center' });
	});
	const chapterStats = $derived.by(() => {
		const all = new Map(Object.values(data.lists).flat().map((q) => [q.id, q]));
		return { done: [...all.values()].filter(doneQuiz).length, n: all.size };
	});
</script>

<Seo title="{pageTitle} · {data.chapter.title} · in the app" description="The app's exercises for this page of the book." path={here} noindex />

<SiteNav courseHref="/course/{data.courseId}" />

<main>
<div class="stick">
	<div class="stick-in">
		<div class="stick-row">
			<BookAppSwitch current="app" {bookHref} appHref={here} />
			<span class="chapter-total" class:full={chapterStats.done === chapterStats.n}>
				<span class="ring" style:--p={chapterStats.n ? chapterStats.done / chapterStats.n : 0} aria-hidden="true"></span>
				<span><b class="tnum">{chapterStats.n ? Math.round((chapterStats.done / chapterStats.n) * 100) : 0}%</b> {g(`von Kapitel ${data.chapter.n}`, t('of chapter {n}', { n: data.chapter.n }))} <span class="tnum of">({chapterStats.done}/{chapterStats.n})</span></span>
			</span>
		</div>
		<nav class="tabs" bind:this={tabsEl} aria-label={g('Seiten dieses Kapitels', t('Pages of this chapter'))} data-sveltekit-preload-data="off">
			{#each data.pages as p (p)}
				{@const st = pageStats[p]}
				<a
					href={appListHref(data.courseId, data.level, data.chapter.id, p)}
					class:on={p === part}
					class:full={st.done === st.n}
					class:started={st.done > 0 && st.done < st.n}
					aria-current={p === part ? 'page' : undefined}
					onclick={(e) => showPage(p, e)}
				>
					{#if st.done === st.n}<Icon name="check" size="0.95em" />{/if}
					{PART_TITLE[p] ?? p}
					<span class="tab-count tnum" aria-hidden="true">{st.done}/{st.n}</span>
					<span class="sr-only">, {g(`${st.done} von ${st.n} geschafft`, t('{done} of {n} done', { done: st.done, n: st.n }))}</span>
				</a>
			{/each}
		</nav>
	</div>
</div>

<div class="page-body">
	<header class="top">
		<p class="eyebrow">{data.bookTitle} · {g(`Kapitel ${data.chapter.n}`, t('Chapter {n}', { n: data.chapter.n }))} · <span lang="de">{data.chapter.title}</span></p>
		<h1 lang="de">{pageTitle}</h1>
		<p class="sub">{g('Zu jeder Übung auf dieser Buchseite gibt es ein Quiz in der App. Fang an, wo du willst; vor und zurück bleiben auf dieser Seite.', t('Each exercise on this page of your book has its practice in the app. Start with any of them; inside, previous and next stay on this page.'))}</p>
		<div class="progress" aria-label={g(`${doneCount} von ${quizzes.length} geschafft`, t('{done} of {n} done', { done: doneCount, n: quizzes.length }))}>
			<span class="bar"><span style:width="{(doneCount / quizzes.length) * 100}%"></span></span>
			<span class="tnum">{g(`${doneCount} von ${quizzes.length} geschafft`, t('{done} of {n} done', { done: doneCount, n: quizzes.length }))}</span>
		</div>
	</header>

	<ol class="cards">
		{#each quizzes as quiz, i (quiz.id + i)}
			{@const mark = marks[i]}
			<li class:next={i === firstOpen} class:done={isDone(mark)} class:retry={mark === 'retry'}>
				<a href={listQuizHref(data.courseId, quiz.id)}>
					<span class="pic">
						{#if quiz.image}<img src={quiz.image} alt="" loading={i < 2 ? 'eager' : 'lazy'} />{/if}
						{#if isDone(mark)}<span class="n ok" aria-hidden="true"><Icon name="check" size="1em" /></span>{:else}<span class="n">{i + 1}</span>{/if}
						{#if quiz.credit}<span class="pcredit">{quiz.credit.text}</span>{/if}
					</span>
					<span class="body">
						<span class="for"><Icon name="book" size="0.95em" /> <span>{forOf(quiz)}</span></span>
						<span class="title" lang={data.learnLocale}>{quiz.title}</span>
						<span class="note">{noteOf(quiz)}</span>
						<span class="meta">
							<span class="kind"><Icon name={QUIZ_TYPE_ICONS[quiz.type as keyof typeof QUIZ_TYPE_ICONS]} size="1em" /> {KIND[quiz.type] ? g(KIND[quiz.type][1], t(KIND[quiz.type][0])) : quiz.type}</span>
							{#if sizeOf(quiz)}<span>{sizeOf(quiz)}</span>{/if}
						</span>
					</span>
					<span class="go">
						{#if isDone(mark)}
							<span class="status"><DoneMark mark={mark!} width={11} /> {g('Geschafft', t('Done'))}</span>
							<span class="again"><Icon name="repeat" size="0.95em" /> {g('Nochmal', t('Again'))}</span>
						{:else if mark === 'retry'}
							<span class="status try"><DoneMark mark="retry" width={16} /> {g('Nochmal versuchen', t('Try again'))}</span>
						{:else}<span class="start">{i === firstOpen ? g('Los', t('Start')) : g('Öffnen', t('Open'))} <Icon name="arrowRight" size="1em" /></span>{/if}
					</span>
				</a>
			</li>
		{/each}
	</ol>
</div>
</main>

<style>
	.stick {
		position: sticky;
		top: 0;
		z-index: 3;
		background: var(--bg);
		border-bottom: 1px solid var(--line);
	}
	.stick-in {
		max-width: 46rem;
		margin: 0 auto;
		padding: 0.6rem 1rem;
		display: flex;
		flex-direction: column;
		gap: 0.55rem;
	}
	.tabs {
		display: flex;
		gap: 0.4rem;
		overflow-x: auto;
		scrollbar-width: none;
	}
	.stick-row {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 0.75rem;
		flex-wrap: wrap;
	}
	.chapter-total {
		display: inline-flex;
		align-items: center;
		gap: 0.5rem;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}
	.chapter-total b {
		font-size: 1.15em;
		color: var(--navy);
	}
	.chapter-total .of {
		font-size: 0.85em;
	}
	.chapter-total.full b {
		color: var(--right);
	}
	/* A ring that fills green with the chapter. */
	.ring {
		width: 1.35rem;
		height: 1.35rem;
		border-radius: 50%;
		background: conic-gradient(var(--right) calc(var(--p) * 360deg), var(--paper-high) 0);
		-webkit-mask: radial-gradient(circle, transparent 52%, #000 54%);
		mask: radial-gradient(circle, transparent 52%, #000 54%);
	}
	/* Each tab carries its page's progress: a green bar filling along its
	   foot and a count; a finished page turns green with a check. */
	.tabs a {
		position: relative;
		overflow: hidden;
		display: inline-flex;
		align-items: center;
		gap: 0.35em;
		flex: none;
		padding: 0.3rem 0.8rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		color: var(--ink);
		font-size: var(--step--1);
		font-weight: 600;
		text-decoration: none;
		background: var(--surface);
	}
	@media (min-width: 40rem) {
		.tabs {
			flex-wrap: wrap;
			overflow: visible;
		}
	}
	.tab-count {
		font-size: 0.75em;
		font-weight: 700;
		color: var(--ink-muted);
	}
	.tabs a.full {
		background: var(--right-bg);
		border-color: var(--right);
		color: var(--right);
	}
	.tabs a.full .tab-count {
		color: var(--right);
	}
	.tabs a.on {
		background: var(--navy);
		border-color: var(--navy);
		color: #fff;
	}
	.tabs a.on .tab-count {
		color: #dbe4f0;
	}
	.tabs a.on.full {
		background: var(--right);
		border-color: var(--right);
	}

	.page-body {
		max-width: 46rem;
		margin: 0 auto;
		padding: 1.25rem 1rem 4rem;
	}
	.top {
		display: flex;
		flex-direction: column;
		gap: 0.35rem;
		margin-bottom: 1.4rem;
	}
	.eyebrow {
		margin: 0;
		font-size: var(--step--1);
		font-weight: 700;
		color: var(--accent-ink);
	}
	h1 {
		margin: 0;
		font-size: var(--step-4);
		line-height: 1.05;
		color: var(--heading);
	}
	.sub {
		margin: 0.2rem 0 0;
		color: var(--ink-muted);
		max-width: 60ch;
	}
	.progress {
		display: flex;
		align-items: center;
		gap: 0.7rem;
		margin-top: 0.5rem;
		font-size: var(--step--1);
		font-weight: 700;
		color: var(--navy);
	}
	.bar {
		flex: 0 1 12rem;
		height: 8px;
		border-radius: 999px;
		background: var(--paper-high);
		overflow: hidden;
	}
	.bar span {
		display: block;
		height: 100%;
		background: var(--right);
		border-radius: inherit;
		transition: width 0.4s;
	}
	.cards {
		list-style: none;
		margin: 0;
		padding: 0;
		display: flex;
		flex-direction: column;
		gap: 0.85rem;
	}
	.cards a {
		display: grid;
		grid-template-columns: 9rem 1fr auto;
		align-items: stretch;
		border: 1px solid var(--line-strong);
		border-radius: 16px;
		background: var(--surface);
		color: var(--ink);
		text-decoration: none;
		overflow: hidden;
		transition: border-color 0.15s, box-shadow 0.15s, transform 0.15s;
	}
	.cards a:hover {
		border-color: var(--navy);
		box-shadow: 0 6px 18px rgb(31 58 95 / 0.12);
		transform: translateY(-1px);
	}
	.cards a:focus-visible {
		outline: 3px solid var(--accent);
		outline-offset: 2px;
	}
	.cards li.next a {
		border-color: var(--navy);
		border-width: 2px;
	}
	.pic {
		position: relative;
		background: var(--paper-high);
		min-height: 8rem;
	}
	.pic img {
		position: absolute;
		inset: 0;
		width: 100%;
		height: 100%;
		object-fit: cover;
	}
	/* The photo's licence credit (full line on /credits). */
	.pcredit {
		position: absolute;
		left: 0;
		right: 0;
		bottom: 0;
		z-index: 1;
		padding: 0.15rem 0.35rem;
		background: rgb(0 0 0 / 0.55);
		color: #fff;
		font-size: 0.6rem;
		line-height: 1.25;
		overflow-wrap: anywhere;
	}
	.n {
		position: absolute;
		top: 0.5rem;
		left: 0.5rem;
		width: 1.7rem;
		height: 1.7rem;
		border-radius: 50%;
		background: var(--navy);
		color: #fff;
		display: grid;
		place-items: center;
		font-weight: 800;
		font-size: 0.85rem;
		box-shadow: 0 1px 4px rgb(0 0 0 / 0.3);
	}
	.body {
		min-width: 0;
		padding: 0.85rem 1rem;
		display: flex;
		flex-direction: column;
		gap: 0.25rem;
	}
	.for {
		align-self: flex-start;
		display: inline-flex;
		align-items: center;
		gap: 0.35em;
		padding: 0.15em 0.6em;
		border-radius: 6px;
		background: var(--accent-soft);
		color: var(--accent-ink);
		font-size: 0.8rem;
		font-weight: 700;
	}
	.title {
		font-size: var(--step-1);
		font-weight: 800;
		line-height: 1.2;
		color: var(--heading);
	}
	.note {
		color: var(--ink);
		font-size: var(--step--1);
		line-height: 1.45;
	}
	.meta {
		display: flex;
		flex-wrap: wrap;
		gap: 0.3rem 0.9rem;
		margin-top: 0.15rem;
		font-size: 0.8rem;
		font-weight: 600;
		color: var(--ink-muted);
	}
	.kind {
		display: inline-flex;
		align-items: center;
		gap: 0.35em;
	}
	.go {
		display: flex;
		align-items: center;
		padding-block: 0;
		padding-inline: 0.25rem 1rem;
	}
	.start {
		display: inline-flex;
		align-items: center;
		gap: 0.35em;
		font-weight: 700;
		font-size: var(--step--1);
		color: var(--navy);
		white-space: nowrap;
	}
	li.next .start {
		background: var(--navy);
		color: #fff;
		padding: 0.45em 0.9em;
		border-radius: 999px;
	}
	/* A done exercise reads as done at a glance: green edge and tint, a check
	   instead of its number, the picture quietened, "Done" with its medal. */
	li.done a {
		border-color: var(--right);
		border-width: 2px;
		background: var(--right-bg);
	}
	li.done .pic img {
		filter: saturate(0.35) brightness(1.08);
		opacity: 0.75;
	}
	li.done .pic::after {
		content: '';
		position: absolute;
		inset: 0;
		background: color-mix(in srgb, var(--right) 22%, transparent);
	}
	.n.ok {
		z-index: 1;
		background: var(--right);
		width: 2rem;
		height: 2rem;
		font-size: 1.05rem;
	}
	li.done .title {
		color: var(--right);
	}
	li.retry a {
		border-color: var(--wrong);
		border-width: 2px;
	}
	.go {
		flex-direction: column;
		justify-content: center;
		align-items: flex-end;
		gap: 0.4rem;
	}
	.status {
		display: inline-flex;
		align-items: center;
		gap: 0.55em;
		min-height: 2.6rem;
		box-sizing: border-box;
		padding-block: 0.5em;
		padding-inline: 1.05em 1.25em;
		border-radius: 999px;
		line-height: 1;
		background: var(--right);
		color: #fff;
		font-weight: 800;
		font-size: var(--step--1);
		white-space: nowrap;
	}
	.status.try {
		background: var(--wrong-bg);
		color: var(--wrong);
	}
	.again {
		display: inline-flex;
		align-items: center;
		gap: 0.3em;
		font-size: 0.8rem;
		font-weight: 700;
		color: var(--ink-muted);
	}

	@media (max-width: 34rem) {
		.cards a {
			grid-template-columns: 6.5rem 1fr;
		}
		.go {
			grid-column: 1 / -1;
			flex-direction: row;
			justify-content: flex-end;
			align-items: center;
			gap: 0.8rem;
			padding: 0 0.9rem 0.8rem;
		}
		.pic {
			grid-row: 1 / 3;
		}
	}
	@media (prefers-reduced-motion: reduce) {
		.cards a,
		.bar span {
			transition: none;
		}
	}
</style>
