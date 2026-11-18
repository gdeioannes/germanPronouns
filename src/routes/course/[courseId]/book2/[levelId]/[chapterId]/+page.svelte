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
	import BookAppSwitch from '$lib/components/book2/BookAppSwitch.svelte';
	import { appListHref } from '$lib/state/bookOpen';
	import { creditShort } from '$lib/domain/credits';

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

	// Book | App: the App side is the quiz list of the page in view (the hash),
	// or the chapter's first page that has one.
	const appParts = $derived(Object.entries(data.chapter.appQuizzes ?? {}).filter(([, l]) => l?.length).map(([p]) => p));
	function appHref(): string | null {
		if (!appParts.length) return null;
		const hash = typeof location === 'undefined' ? '' : location.hash.slice(1);
		const part = appParts.includes(hash) ? hash : appParts[0];
		return appListHref(data.courseId, data.level, c.id, part);
	}
	const bookSelf = () => `${chapterHref(c.id)}${typeof location === 'undefined' ? '' : location.hash}`;

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

	// Each part opens like a page of the book: a photo of the chapter's world
	// (the ones the printed book already uses), never the same one twice.
	type Photo = { photo: string; caption: string };
	const photoFor = $derived.by(() => {
		const pool: Photo[] = [];
		const add = (p?: Photo | null) => {
			if (p?.photo && !pool.some((x) => x.photo === p.photo)) pool.push(p);
		};
		c.grammar.forEach((g) => add(g.photo));
		c.reading.photos?.forEach(add);
		// Last in line: the cover panorama and the document, for the practice
		// pages far below them.
		add({ photo: c.opener.photo, caption: c.opener.caption ?? '' });
		add({ photo: c.document.photo, caption: c.document.caption });
		const used = new Set<string>();
		const take = (want?: Photo | null): Photo | null => {
			const p = want && !used.has(want.photo) ? want : pool.find((x) => !used.has(x.photo));
			if (!p) return null;
			used.add(p.photo);
			return p;
		};
		const out: Partial<Record<PartId, Photo | null>> = {};
		out.lesen = take(c.reading.photos?.[0]);
		out['grammatik-1'] = take(c.grammar[0]?.photo);
		out['grammatik-2'] = take(c.grammar[1]?.photo);
		out['uebungen-1'] = take();
		out['uebungen-2'] = take();
		return out;
	});

	/** Who speaks in the reading, in order of first line: the first sits left, the second right. */
	const speakers = $derived([...new Set(c.reading.lines.map((l) => l.who).filter(Boolean))] as string[]);
	const WHO_COLOURS = ['#a24c26', '#1f5aa6', '#2a7247', '#836215'];
	const whoColor = (who?: string) => (who ? WHO_COLOURS[speakers.indexOf(who) % WHO_COLOURS.length] : 'var(--ink-muted)');

	/** Checked exercises per part, for the tabs. */
	const partStats = $derived(
		Object.fromEntries(parts.map((p) => [p.id, { done: p.exercises.filter((e) => checks[e.key]).length, n: p.exercises.length }]))
	);
	/** The words with pictures, for the strip on the words page. */
	const pictureWords = $derived(words.filter((w) => 'image' in w && w.image).slice(0, 12) as { de: string; en: string; image: string }[]);
</script>

{#snippet pageHead(id: PartId, kicker: string, title: string, photo: Photo | null | undefined)}
	<header class="page-head" class:has-photo={!!photo}>
		{#if photo}
			<img src="/img/photo/web/{photo.photo}.jpg" alt={photo.caption} loading="lazy" />
		{/if}
		<div class="page-head-text">
			<span class="kicker">{kicker}</span>
			<h2 lang="de">{title}</h2>
			{#if photo}<p class="caption" lang="de">{photo.caption}</p>{/if}
			{#if photo && creditShort(photo.photo)}<a class="pcredit" href="/credits#{photo.photo}">{creditShort(photo.photo)}</a>{/if}
		</div>
		{#if partStats[id]?.n}
			<span class="page-score" class:full={partStats[id].done === partStats[id].n}>
				{#if partStats[id].done === partStats[id].n}<Icon name="check" size="0.95em" />{/if}
				{partStats[id].done}/{partStats[id].n}
			</span>
		{/if}
	</header>
{/snippet}

<Seo
	title="{c.title} · {data.bookTitle} {data.level} in the app"
	description="Chapter {c.n} of the book in the app: the words as flashcards, the text read aloud, every exercise checked."
	path="{bookHref}/{c.id}"
	noindex
/>

<SiteNav {courseHref} />

<main>
<div class="hero">
	<img class="hero-img" src="/img/photo/web/{c.opener.photo}.jpg" alt={c.opener.caption ?? ''} />
	{#if creditShort(c.opener.photo)}<a class="hero-credit" href="/credits#{c.opener.photo}">{creditShort(c.opener.photo)}</a>{/if}
	<div class="hero-shade"></div>
	<div class="hero-in">
		<a class="back" href={bookHref}><Icon name="arrowLeft" size="1em" /> {data.bookTitle}</a>
		<p class="eyebrow">{german ? `Kapitel ${c.n} von ${data.count}` : t('Chapter {n} of {count}', { n: c.n, count: data.count })} · <span lang="de">{c.world}</span></p>
		<h1 lang="de">{c.title}</h1>
		<p class="sub">
			{german
				? 'Das Kapitel aus deinem Buch: Wortkarten, der Text zum Hören und jede Übung zum Prüfen.'
				: t('This chapter of your book: the words as cards, the text read aloud, and every exercise to check.')}
		</p>
		<p class="progress">
			<span class="bar"><span style:width="{total ? (checkedCount / total) * 100 : 0}%"></span></span>
			<span class="tnum" dir="ltr">{checkedCount} / {total}</span> {german ? 'Übungen geprüft' : t('exercises checked')}
		</p>
	</div>
</div>

<div class="stick">
	<div class="stick-in">
		{#if appParts.length}<BookAppSwitch current="book" bookHref={bookSelf} {appHref} />{/if}
		<nav class="chips" aria-label={german ? 'Teile des Kapitels' : t('Parts of the chapter')}>
			{#each parts as p (p.id)}
				{#if p.id === 'woerter' || p.exercises.length}
					{@const st = partStats[p.id]}
					<a href="#{p.id}" class:full={st.n > 0 && st.done === st.n}>
						{#if st.n > 0 && st.done === st.n}<Icon name="check" size="0.95em" />{/if}
						{partTitle[p.id]}
						{#if st.n}<span class="chip-count tnum">{st.done}/{st.n}</span>{/if}
					</a>
				{/if}
			{/each}
		</nav>
	</div>
</div>

<div class="page-body">
	<section id="woerter" class="part">
		{@render pageHead('woerter', german ? 'Seite · Wörter' : t('Page · Words'), german ? 'Wortkarten' : 'Wörter zuerst', null)}
		{#if pictureWords.length}
			<ul class="word-strip" lang="de">
				{#each pictureWords as w (w.de)}
					<li>
						<img src="/img/{w.image}.webp" alt="" loading="lazy" />
						<b>{w.de}</b>
						{#if english}<span lang="en">{w.en}</span>{/if}
					</li>
				{/each}
			</ul>
		{/if}
		<div class="sheet">
			<WordCards {words} level={data.level} {german} />
		</div>
	</section>

	<section id="lesen" class="part">
		{@render pageHead('lesen', german ? 'Seite · Lesen' : t('Page · Reading'), c.reading.title, photoFor.lesen)}
		<div class="sheet">
			{#if c.reading.intro && english}<p class="intro">{@html rich(c.reading.intro)}</p>{/if}
			<button type="button" class="play" onclick={readAll} aria-pressed={reading}>
				<Icon name={reading ? 'volumeOff' : 'volume'} size="1.1em" />
				{reading ? (german ? 'Stopp' : t('Stop')) : german ? 'Alles hören' : t('Listen to it all')}
			</button>
			<div class="dialogue" lang="de">
				{#each c.reading.lines as l, j (j)}
					{@const side = l.who && speakers.indexOf(l.who) % 2 === 1 ? 'right' : 'left'}
					<div class="bubble {side}" style:--who={whoColor(l.who)}>
						{#if l.who}<b>{l.who}</b>{/if}
						<p>
							<span>{@html rich(l.de)}</span>
							<SpeakButton text={plain(l.de)} locale="de-DE" label="Listen to this line" />
						</p>
					</div>
				{/each}
			</div>
			{#if english}
				<details class="en"><summary>{t('English')}</summary><p>{c.reading.en}</p></details>
			{/if}
		</div>
		{#each parts.find((p) => p.id === 'lesen')?.exercises ?? [] as e (e.key)}
			<CheckExercise ex={e.ex} n={e.n} {german} saved={checks[e.key] ?? null} onchecked={(s) => onchecked(e.key, s)} />
		{/each}
	</section>

	{#each c.grammar.slice(0, 2) as g, gi (g.heading)}
		{@const part = parts.find((p) => p.id === `grammatik-${gi + 1}`)}
		{#if part?.exercises.length}
			<section id="grammatik-{gi + 1}" class="part">
				{@render pageHead(part.id, `${german ? 'Seite' : t('Page')} · Grammatik ${gi + 1}`, g.heading, photoFor[part.id])}
				{#if g.subheading}<p class="lede">{g.subheading}</p>{/if}
				{#each part.exercises as e (e.key)}
					<CheckExercise ex={e.ex} n={e.n} {german} saved={checks[e.key] ?? null} onchecked={(s) => onchecked(e.key, s)} />
				{/each}
			</section>
		{/if}
	{/each}

	{#if parts.find((p) => p.id === 'alltag')?.exercises.length}
		<section id="alltag" class="part">
			{@render pageHead('alltag', german ? 'Seite · Lesen im Alltag' : t('Page · Everyday reading'), c.document.caption, null)}
			<figure class="doc">
				<img src="/img/photo/web/{c.document.photo}.jpg" alt={c.document.caption} loading="lazy" />
				<figcaption>{@html rich(c.document.intro)}{#if creditShort(c.document.photo)}<a class="doc-credit" href="/credits#{c.document.photo}">{creditShort(c.document.photo)}</a>{/if}</figcaption>
			</figure>
			{#each parts.find((p) => p.id === 'alltag')!.exercises as e (e.key)}
				<CheckExercise ex={e.ex} n={e.n} {german} saved={checks[e.key] ?? null} onchecked={(s) => onchecked(e.key, s)} />
			{/each}
		</section>
	{/if}

	{#each ['uebungen-1', 'uebungen-2'] as id, pi (id)}
		{@const part = parts.find((p) => p.id === id)}
		{#if part?.exercises.length}
			<section {id} class="part">
				{@render pageHead(part.id, `${german ? 'Seite' : t('Page')} · Übungen ${pi + 1}`, `Übungen ${pi + 1} ${german ? 'von' : t('of')} 2`, photoFor[part.id])}
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
</div>
</main>

<style>
	/* The chapter in the app, dressed like the book: its panorama as the
	   cover, each part opening like a printed page with one of the chapter's
	   photos, paper sheets for the content. */
	.hero {
		position: relative;
		min-height: 20rem;
		display: flex;
		align-items: flex-end;
		color: #fff;
		overflow: hidden;
		background: var(--navy);
	}
	/* The photos' licence credits; the full lines are on /credits. */
	.hero-credit {
		position: absolute;
		right: 0.6rem;
		bottom: 0.4rem;
		z-index: 2;
		font-size: 0.65rem;
		color: rgb(255 255 255 / 0.8);
		text-decoration: none;
	}
	.pcredit {
		position: relative;
		z-index: 2;
		display: block;
		margin-top: 0.3rem;
		font-size: 0.65rem;
		color: rgb(255 255 255 / 0.8);
		text-decoration: none;
	}
	.doc-credit {
		display: block;
		margin-top: 0.4rem;
		font-size: 0.72rem;
		color: var(--ink-muted);
	}
	.hero-img {
		position: absolute;
		inset: 0;
		width: 100%;
		height: 100%;
		object-fit: cover;
	}
	.hero-shade {
		position: absolute;
		inset: 0;
		background: linear-gradient(180deg, rgb(20 28 44 / 0.3) 0%, rgb(20 28 44 / 0.6) 40%, rgb(20 28 44 / 0.92) 100%);
	}
	.hero-in {
		position: relative;
		width: 100%;
		max-width: 48rem;
		margin: 0 auto;
		box-sizing: border-box;
		padding: 3.5rem 1rem 1.5rem;
	}
	.back {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
		margin-bottom: 1rem;
		padding: 0.3rem 0.75rem;
		border-radius: 999px;
		background: rgb(255 255 255 / 0.16);
		backdrop-filter: blur(6px);
		color: #fff;
		font-size: var(--step--1);
		font-weight: 600;
		text-decoration: none;
	}
	.eyebrow {
		margin: 0;
		font-size: 0.8rem;
		font-weight: 700;
		letter-spacing: 0.08em;
		text-transform: uppercase;
		color: #f3d2c0;
	}
	h1 {
		margin: 0.25rem 0 0.4rem;
		font-size: clamp(2.1rem, 1.5rem + 3vw, 3.4rem);
		line-height: 1.02;
		color: #fff;
		text-wrap: balance;
	}
	.hero .sub {
		margin: 0;
		max-width: 38rem;
		color: rgb(255 255 255 / 0.88);
	}
	.progress {
		display: flex;
		gap: 0.6rem;
		align-items: center;
		margin: 1rem 0 0;
		font-size: var(--step--1);
		font-weight: 600;
		color: rgb(255 255 255 / 0.9);
	}
	.bar {
		flex: 0 0 9rem;
		height: 7px;
		border-radius: 999px;
		background: rgb(255 255 255 / 0.25);
		overflow: hidden;
	}
	.bar span {
		display: block;
		height: 100%;
		border-radius: inherit;
		background: #8fd19e;
	}

	/* The Book | App switch and the page tabs stay in view while reading. */
	.stick {
		position: sticky;
		top: 0;
		z-index: 3;
		background: var(--bg);
		border-bottom: 1px solid var(--line);
	}
	.stick-in {
		max-width: 48rem;
		margin: 0 auto;
		padding: 0.6rem 1rem;
		display: flex;
		flex-direction: column;
		gap: 0.55rem;
	}
	.chips {
		display: flex;
		gap: 0.4rem;
		overflow-x: auto;
		scrollbar-width: none;
	}
	@media (min-width: 40rem) {
		.chips {
			flex-wrap: wrap;
			overflow: visible;
		}
	}
	.chips a {
		display: inline-flex;
		align-items: center;
		gap: 0.35em;
		flex: none;
		padding: 0.3rem 0.8rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		background: var(--surface);
		color: var(--ink);
		font-size: var(--step--1);
		font-weight: 600;
		text-decoration: none;
	}
	.chips a:hover {
		border-color: var(--accent);
	}
	.chips a.full {
		background: var(--right-bg);
		border-color: var(--right);
		color: var(--right);
	}
	.chip-count {
		font-size: 0.75em;
		font-weight: 700;
		color: var(--ink-muted);
	}
	.chips a.full .chip-count {
		color: var(--right);
	}

	.page-body {
		max-width: 48rem;
		margin: 0 auto;
		padding: 0.5rem 1rem 4rem;
	}
	.part {
		padding-top: 2.5rem;
		scroll-margin-top: 6.5rem;
		display: flex;
		flex-direction: column;
		gap: 1rem;
	}

	/* A part opens like a printed page: photo band, page label, title. */
	.page-head {
		position: relative;
		display: flex;
		align-items: flex-end;
		min-height: 5.5rem;
		padding: 1.1rem 1.2rem;
		border-radius: 16px;
		background: var(--accent-soft);
		overflow: hidden;
	}
	.page-head.has-photo {
		min-height: 11rem;
		background: var(--navy);
	}
	.page-head img {
		position: absolute;
		inset: 0;
		width: 100%;
		height: 100%;
		object-fit: cover;
	}
	.page-head.has-photo::before {
		content: '';
		position: absolute;
		inset: 0;
		z-index: 1;
		background: linear-gradient(180deg, transparent 20%, rgb(20 28 44 / 0.82) 100%);
	}
	.page-head-text {
		position: relative;
		z-index: 2;
		min-width: 0;
		padding-right: 4.5rem;
	}
	.kicker {
		display: inline-block;
		margin-bottom: 0.35rem;
		padding: 0.15em 0.6em;
		border-radius: 4px;
		background: var(--accent-ink);
		color: #fff;
		font-size: 0.72rem;
		font-weight: 800;
		letter-spacing: 0.08em;
		text-transform: uppercase;
	}
	h2 {
		margin: 0;
		font-size: clamp(1.4rem, 1.2rem + 1vw, 1.9rem);
		line-height: 1.1;
		color: var(--heading);
		text-wrap: balance;
	}
	.has-photo h2 {
		color: #fff;
	}
	.caption {
		margin: 0.3rem 0 0;
		font-size: 0.8rem;
		color: rgb(255 255 255 / 0.82);
	}
	.page-score {
		position: absolute;
		z-index: 2;
		top: 0.9rem;
		right: 0.9rem;
		display: inline-flex;
		align-items: center;
		gap: 0.3em;
		padding: 0.25em 0.7em;
		border-radius: 999px;
		background: var(--surface);
		color: var(--ink);
		font-size: var(--step--1);
		font-weight: 800;
		font-variant-numeric: tabular-nums;
		box-shadow: 0 1px 4px rgb(0 0 0 / 0.15);
	}
	.page-score.full {
		background: var(--right);
		color: #fff;
	}
	.lede {
		margin: 0;
		color: var(--ink-muted);
		font-size: var(--step-0);
	}

	/* Paper for content that isn't an exercise card. */
	.sheet {
		padding: 1.2rem;
		border: 1px solid var(--line);
		border-radius: 16px;
		background: var(--surface);
	}

	/* The words page opens with its pictures. */
	.word-strip {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(6.5rem, 1fr));
		gap: 0.6rem;
		margin: 0;
		padding: 0;
		list-style: none;
	}
	@media (max-width: 34rem) {
		.word-strip {
			grid-template-columns: none;
			grid-auto-flow: column;
			grid-auto-columns: 6.5rem;
			overflow-x: auto;
			scroll-snap-type: x mandatory;
			padding-bottom: 0.3rem;
		}
		.word-strip li {
			scroll-snap-align: start;
		}
	}
	.word-strip li {
		display: flex;
		flex-direction: column;
		align-items: center;
		gap: 0.15rem;
		padding: 0.6rem 0.4rem 0.7rem;
		border: 1px solid var(--line);
		border-radius: 12px;
		background: var(--surface);
		text-align: center;
	}
	.word-strip img {
		width: 4.2rem;
		height: 4.2rem;
		object-fit: contain;
	}
	.word-strip b {
		font-size: 0.9rem;
	}
	.word-strip span {
		font-size: 0.75rem;
		color: var(--ink-muted);
	}

	/* The reading as a conversation. */
	.intro {
		margin: 0 0 0.9rem;
		color: var(--ink-muted);
	}
	.play {
		display: inline-flex;
		align-items: center;
		gap: 0.45rem;
		min-height: 2.6rem;
		padding: 0 1.1rem;
		border: 0;
		border-radius: 999px;
		background: var(--navy);
		color: #fff;
		font: inherit;
		font-weight: 700;
		cursor: pointer;
	}
	.play[aria-pressed='true'] {
		background: var(--accent-ink);
	}
	.dialogue {
		display: flex;
		flex-direction: column;
		gap: 0.55rem;
		margin: 1.1rem 0 0.5rem;
	}
	.bubble {
		max-width: 85%;
		padding: 0.55rem 0.85rem;
		border-radius: 14px;
		border-end-start-radius: 4px;
		background: color-mix(in srgb, var(--who) 10%, var(--surface));
		border: 1px solid color-mix(in srgb, var(--who) 30%, transparent);
	}
	.bubble.right {
		align-self: flex-end;
		border-radius: 14px;
		border-end-end-radius: 4px;
	}
	.bubble b {
		display: block;
		font-size: 0.75rem;
		letter-spacing: 0.04em;
		text-transform: uppercase;
		color: var(--who);
	}
	.bubble p {
		display: flex;
		align-items: center;
		gap: 0.4rem;
		margin: 0;
		line-height: 1.5;
	}
	.en {
		margin: 0.5rem 0 0;
		color: var(--ink-muted);
	}

	/* The everyday document, large, with its intro. */
	.doc {
		margin: 0;
		border: 1px solid var(--line);
		border-radius: 16px;
		background: var(--surface);
		overflow: hidden;
	}
	.doc img {
		display: block;
		width: 100%;
		max-height: 30rem;
		object-fit: contain;
		background: var(--surface-alt);
	}
	.doc figcaption {
		padding: 0.9rem 1.1rem;
		color: var(--ink-muted);
	}

	.more h2 {
		font-size: 1.35rem;
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
		padding: 0.9rem 1.1rem;
		border: 1px solid var(--line);
		border-radius: 12px;
		background: var(--surface);
		color: var(--ink);
		text-decoration: none;
	}
	.more li a :global(.icon) {
		margin-inline-start: auto;
		color: var(--accent-ink);
	}
	.pager {
		display: flex;
		justify-content: space-between;
		gap: 1rem;
		margin-top: 1rem;
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
