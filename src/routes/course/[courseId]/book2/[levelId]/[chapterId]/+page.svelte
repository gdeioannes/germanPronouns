<script lang="ts">
	import { t } from '$lib/i18n/t';
	// A chapter of the printed book, in the app. Each page code in the book
	// lands here at its own part (#lesen, #uebungen-1 …): the words as
	// flashcards, the reading spoken line by line, and every exercise of the
	// chapter to check against the key. Opening it remembers the place in the
	// book (domain/bookStudy BOOK_PLACE_KEY) for the course home's book strip.
	import { onMount } from 'svelte';
	import Seo from '$lib/components/Seo.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import SpeakButton from '$lib/components/SpeakButton.svelte';
	import CheckExercise from '$lib/components/book2/CheckExercise.svelte';
	import WordCards from '$lib/components/book2/WordCards.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { storage } from '$lib/services/storage';
	import { tts } from '$lib/services/speech';
	import { rich, plain } from '$lib/domain/companion';
	import { hidesEnglish } from '$lib/domain/germanFirst';
	import { START_CHOSEN } from '$lib/domain/placement';
	import {
		BOOK_PLACE_KEY,
		PART_IDS,
		chapterParts,
		checksKey,
		parseChecks,
		type ChapterChecks,
		type PartId
	} from '$lib/domain/bookStudy';
	import type { PageData } from './$types';
	import { inLangChapter } from '$lib/i18n/content.svelte';

	let { data }: { data: PageData } = $props();
	// In Turkish the chapter comes through its level's overlay.
	const c = $derived(inLangChapter(data.chapter, data.level));
	const german = $derived(!!c.german);
	const english = $derived(!hidesEnglish(data.level));
	const parts = $derived(chapterParts(c));
	const exerciseParts = $derived(parts.filter((p) => p.exercises.length));
	const total = $derived(exerciseParts.reduce((n, p) => n + p.exercises.length, 0));
	const courseHref = $derived(`/course/${data.courseId}`);
	const bookHref = $derived(`${courseHref}/book2/${data.level}`);
	const chapterHref = (id: string) => `${bookHref}/${id}`;

	const words = $derived([
		...c.words.groups.flatMap((g) => g.items),
		...(c.words.verbs ?? []).map((v) => ({ de: v.de, en: v.en }))
	]);

	let checks = $state<ChapterChecks>({});
	const checkedCount = $derived(exerciseParts.flatMap((p) => p.exercises).filter((e) => checks[e.key]).length);

	async function savePlace() {
		const hash = location.hash.slice(1) as PartId;
		const part = PART_IDS.includes(hash) ? hash : null;
		await storage.set(
			BOOK_PLACE_KEY,
			JSON.stringify({ level: data.level, chapter: c.id, n: c.n, title: c.title, part, at: Date.now() })
		);
		// A reader who came from the book has chosen where to start: their book's
		// level. The course home then deals from it instead of asking first.
		if (!(await storage.get(START_CHOSEN))) await storage.set(START_CHOSEN, 'book');
		if (!(await storage.get('deck_level'))) await storage.set('deck_level', data.level);
	}

	onMount(() => {
		void (async () => {
			checks = parseChecks(await storage.get(checksKey(data.level, c.id)));
		})();
		void savePlace();
		const onHash = () => void savePlace();
		addEventListener('hashchange', onHash);
		return () => removeEventListener('hashchange', onHash);
	});

	async function onchecked(key: string, score: { right: number; total: number }) {
		checks = { ...checks, [key]: { ...score, at: Date.now() } };
		await storage.set(checksKey(data.level, c.id), JSON.stringify(checks));
	}

	// The whole reading, line after line; tapping again stops it.
	let reading = $state(false);
	async function readAll() {
		if (reading) {
			reading = false;
			void tts.stop();
			return;
		}
		reading = true;
		for (const line of c.reading.lines) {
			if (!reading) break;
			await tts.speak(plain(line.de), { locale: 'de-DE' });
		}
		reading = false;
	}

	const partTitle: Record<PartId, string> = {
		woerter: 'Wörter',
		lesen: 'Lesen',
		'grammatik-1': 'Grammatik 1',
		'grammatik-2': 'Grammatik 2',
		alltag: 'Alltag',
		'uebungen-1': 'Übungen 1',
		'uebungen-2': 'Übungen 2'
	};
</script>

<Seo
	title="{c.title} · {data.bookTitle} {data.level} in the app"
	description="Chapter {c.n} of the book in the app: the words as flashcards, the text read aloud, every exercise checked."
	path="{bookHref}/{c.id}"
	noindex
/>

<SiteNav {courseHref} />

<main>
	<a class="back" href={bookHref}><Icon name="arrowLeft" size="1em" /> {data.bookTitle} {data.level}</a>

	<header class="top">
		<p class="eyebrow">{german ? `Kapitel ${c.n} von ${data.count}` : t('Chapter {n} of {count}', { n: c.n, count: data.count })} · <span lang="de">{c.world}</span></p>
		<h1 lang="de">{c.title}</h1>
		<p class="sub">
			{german
				? 'Das Kapitel aus deinem Buch, in der App: Wortkarten, der Text zum Hören und jede Übung zum Prüfen.'
				: t('This chapter of your book, in the app: the words as cards, the text read aloud, and every exercise to check.')}
		</p>
		<p class="progress">
			<span class="bar"><span style:width="{total ? (checkedCount / total) * 100 : 0}%"></span></span>
			{checkedCount} / {total} {german ? 'Übungen geprüft' : t('exercises checked')}
		</p>
	</header>

	<nav class="chips" aria-label={german ? 'Teile des Kapitels' : t('Parts of the chapter')}>
		{#each parts as p (p.id)}
			{#if p.id === 'woerter' || p.exercises.length}
				<a href="#{p.id}">{partTitle[p.id]}</a>
			{/if}
		{/each}
	</nav>

	<section id="woerter" class="part">
		<h2>{german ? 'Wortkarten' : t('Word cards')}</h2>
		<WordCards {words} level={data.level} {german} />
	</section>

	<section id="lesen" class="part">
		<h2 lang="de">Lesen · {c.reading.title}</h2>
		<button type="button" class="play" onclick={readAll} aria-pressed={reading}>
			<Icon name={reading ? 'volumeOff' : 'volume'} size="1.1em" />
			{reading ? (german ? 'Stopp' : t('Stop')) : german ? 'Alles hören' : t('Listen to it all')}
		</button>
		<div class="dialogue" lang="de">
			{#each c.reading.lines as l, j (j)}
				<p>
					{#if l.who}<b>{l.who}</b>{/if}
					<span>{@html rich(l.de)}</span>
					<SpeakButton text={plain(l.de)} locale="de-DE" label="Listen to this line" />
				</p>
			{/each}
		</div>
		{#if english}
			<details class="en"><summary>{t('English')}</summary><p>{c.reading.en}</p></details>
		{/if}
		{#each parts.find((p) => p.id === 'lesen')?.exercises ?? [] as e (e.key)}
			<CheckExercise ex={e.ex} n={e.n} {german} saved={checks[e.key] ?? null} onchecked={(s) => onchecked(e.key, s)} />
		{/each}
	</section>

	{#each c.grammar.slice(0, 2) as g, gi (g.heading)}
		{@const part = parts.find((p) => p.id === `grammatik-${gi + 1}`)}
		{#if part?.exercises.length}
			<section id="grammatik-{gi + 1}" class="part">
				<h2 lang="de">Grammatik · {g.heading}</h2>
				{#if g.subheading}<p class="sub">{g.subheading}</p>{/if}
				{#each part.exercises as e (e.key)}
					<CheckExercise ex={e.ex} n={e.n} {german} saved={checks[e.key] ?? null} onchecked={(s) => onchecked(e.key, s)} />
				{/each}
			</section>
		{/if}
	{/each}

	{#if parts.find((p) => p.id === 'alltag')?.exercises.length}
		<section id="alltag" class="part">
			<h2 lang="de">Lesen im Alltag · {c.document.caption}</h2>
			<img class="doc" src="/img/photo/web/{c.document.photo}.jpg" alt={c.document.caption} loading="lazy" />
			<p class="sub">{@html rich(c.document.intro)}</p>
			{#each parts.find((p) => p.id === 'alltag')!.exercises as e (e.key)}
				<CheckExercise ex={e.ex} n={e.n} {german} saved={checks[e.key] ?? null} onchecked={(s) => onchecked(e.key, s)} />
			{/each}
		</section>
	{/if}

	{#each ['uebungen-1', 'uebungen-2'] as id, pi (id)}
		{@const part = parts.find((p) => p.id === id)}
		{#if part?.exercises.length}
			<section {id} class="part">
				<h2 lang="de">Übungen · {pi + 1} {german ? 'von' : t('of')} 2</h2>
				{#each part.exercises as e (e.key)}
					<CheckExercise ex={e.ex} n={e.n} {german} saved={checks[e.key] ?? null} onchecked={(s) => onchecked(e.key, s)} />
				{/each}
			</section>
		{/if}
	{/each}

	<section class="part more">
		<h2>{german ? 'Mehr in der App' : t('More in the app')}</h2>
		<ul>
			{#if data.more.quiz}
				<li><a href="{courseHref}/quiz/{data.more.quiz.id}"><b>{german ? 'Üben' : t('Practise')}</b> <span lang="de">{data.more.quiz.title}</span> <Icon name="arrowRight" size="1em" /></a></li>
			{/if}
			{#if data.more.listen}
				<li><a href="/play/{data.more.listen.id}"><b>{german ? 'Hören' : t('Listen')}</b> <span lang="de">{data.more.listen.title}</span> <Icon name="arrowRight" size="1em" /></a></li>
			{/if}
			{#if data.more.speak}
				<li><a href="{courseHref}/quiz/{data.more.speak.id}"><b>{german ? 'Sprechen' : t('Speak')}</b> <span lang="de">{data.more.speak.title}</span> <Icon name="arrowRight" size="1em" /></a></li>
			{/if}
		</ul>
		<nav class="pager">
			{#if data.prev}<a href={chapterHref(data.prev.id)}><Icon name="arrowLeft" size="1em" /> <span lang="de">{data.prev.title}</span></a>{:else}<span></span>{/if}
			{#if data.next}<a href={chapterHref(data.next.id)}><span lang="de">{data.next.title}</span> <Icon name="arrowRight" size="1em" /></a>{/if}
		</nav>
	</section>
</main>

<style>
	main {
		max-width: 46rem;
		margin: 0 auto;
		padding: 1rem 1rem 4rem;
	}

	.back {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
		color: var(--ink-muted);
		font-size: var(--step--1);
		text-decoration: none;
	}

	.top {
		margin: 1rem 0 0.5rem;
	}

	.eyebrow {
		margin: 0;
		font-size: 0.8rem;
		font-weight: 700;
		color: var(--ink-muted);
	}

	h1 {
		margin: 0.2rem 0 0.4rem;
		font-size: clamp(1.8rem, 1.4rem + 1.6vw, 2.5rem);
		color: var(--heading);
	}

	.sub {
		margin: 0 0 0.5rem;
		color: var(--ink-muted);
	}

	.progress {
		display: flex;
		gap: 0.6rem;
		align-items: center;
		margin: 0.75rem 0 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.bar {
		flex: 0 0 8rem;
		height: 6px;
		border-radius: 3px;
		background: var(--line);
	}

	.bar span {
		display: block;
		height: 100%;
		border-radius: 3px;
		background: var(--right);
	}

	.chips {
		position: sticky;
		top: 0;
		z-index: 3;
		display: flex;
		gap: 0.4rem;
		margin: 1rem -1rem 0;
		padding: 0.6rem 1rem;
		overflow-x: auto;
		background: var(--bg);
		border-bottom: 1px solid var(--line);
	}

	.chips a {
		flex: none;
		padding: 0.3rem 0.75rem;
		border: 1px solid var(--line-strong);
		border-radius: 6px;
		color: var(--ink);
		font-size: var(--step--1);
		text-decoration: none;
	}

	.part {
		padding-top: 2rem;
		scroll-margin-top: 3.5rem;
	}

	h2 {
		margin: 0 0 0.75rem;
		font-size: 1.35rem;
		color: var(--heading);
	}

	.play {
		display: inline-flex;
		align-items: center;
		gap: 0.45rem;
		min-height: 2.6rem;
		padding: 0 1rem;
		border: 1px solid var(--line-strong);
		border-radius: 6px;
		background: var(--surface);
		color: var(--ink);
		font: inherit;
		font-weight: 600;
		cursor: pointer;
	}

	.dialogue {
		margin: 1rem 0;
	}

	.dialogue p {
		margin: 0 0 0.55rem;
		line-height: 1.6;
	}

	.dialogue b {
		margin-right: 0.35rem;
		color: var(--heading);
	}

	.en {
		margin: 0 0 1rem;
		color: var(--ink-muted);
	}

	.doc {
		display: block;
		width: 100%;
		max-height: 26rem;
		object-fit: contain;
		margin: 0 0 0.75rem;
		border-radius: 6px;
		background: var(--surface-alt);
	}

	.more ul {
		display: grid;
		gap: 0.5rem;
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.more li a {
		display: flex;
		gap: 0.5rem;
		align-items: center;
		padding: 0.8rem 1rem;
		border: 1px solid var(--line);
		border-radius: 8px;
		background: var(--surface);
		color: var(--ink);
		text-decoration: none;
	}

	.more li a :global(.icon) {
		margin-left: auto;
		color: var(--accent-ink);
	}

	.pager {
		display: flex;
		justify-content: space-between;
		gap: 1rem;
		margin-top: 2rem;
	}

	.pager a {
		display: inline-flex;
		gap: 0.35rem;
		align-items: center;
		color: var(--accent-ink);
		font-weight: 600;
		text-decoration: none;
	}
</style>
