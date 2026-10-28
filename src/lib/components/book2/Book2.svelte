<script lang="ts">
	// Book v2: one chapter = nine A4 sheets (docs/book_v2_plan.md §3). The
	// companion's LearnBlock and ExerciseBlock draw the grammar and the
	// exercises; this file draws the pages around them: the word page, the
	// full-bleed opener, the reading, the document, the chapter end, the key.
	import ExerciseBlock from '$lib/components/companion/ExerciseBlock.svelte';
	import LearnBlock from '$lib/components/companion/LearnBlock.svelte';
	import { rich } from '$lib/domain/companion';
	import { chapterKey, picturedWords, practiseOf, type Book2, type Chapter, type PhotoCredit } from '$lib/domain/book2';

	interface Qr {
		svg: string;
		code: string;
	}

	let {
		book,
		credits,
		qr,
		cover = false,
		spineMm = 7.4,
		hd = false
	}: {
		book: Book2;
		credits: Record<string, PhotoCredit>;
		/** Only the wraparound print cover: back, spine, front on one sheet with 3 mm bleed. */
		cover?: boolean;
		spineMm?: number;
		/** Print originals (local only, gitignored); otherwise the 1400 px web copies. */
		hd?: boolean;
		/** Per chapter id: the app, Listen and Speak codes, when registered. */
		qr: Record<string, { app: Qr | null; listen: Qr | null; speak: Qr | null }>;
	} = $props();

	/** Nine content pages and a notes page, so every chapter opens on a left-hand page. */
	const PAGES = 10;
	const photoBase = $derived(hd ? '/img/photo' : '/img/photo/web');
	/** Cover, how it works, contents: the first chapter opens on page 4, a left-hand page. */
	const FRONT = 3;
	const firstPage = (i: number) => FRONT + 1 + i * PAGES;
	const side = (p: number) => (p % 2 === 0 ? 'left' : 'right');
	const keyPage = $derived(firstPage(book.chapters.length));
	/** Two chapters of answers per key page. */
	const keyPages = $derived([...Array.from({ length: Math.ceil(book.chapters.length / 2) }, (_, i) => book.chapters.slice(i * 2, i * 2 + 2)), []]);

	const article = (de: string) => /^(der|die|das) /.exec(de)?.[1] ?? '';
	const bare = (de: string) => de.replace(/^(der|die|das) /, '');
	/** "die Äpfel" prints whole; "-n" prints as the ending; "–" as nothing. */
	const plural = (pl?: string) => (!pl || pl === '' ? '' : pl === '–' ? 'no plural' : pl.startsWith('-') || pl.startsWith('¨') ? `pl. ${pl}` : pl);
	const split = <T,>(xs: T[], n: number): [T[], T[]] => [xs.slice(0, n), xs.slice(n)];
</script>

{#snippet foot(page: number, c: Chapter)}
	<footer class="foot">
		<span class="tnum">{page}</span>
		<span><b>{c.n}</b> · {c.title} · <i>{c.world}</i></span>
	</footer>
{/snippet}

{#snippet fact(text?: string)}
	{#if text}
		<aside class="fact">
			<span class="eyebrow">Wusstest du?</span>
			<p>{@html rich(text)}</p>
		</aside>
	{/if}
{/snippet}

{#snippet filler(prompt: string)}
	<div class="fill">
		<p class="eyebrow">Schreib mit! · your turn</p>
		<p class="fill-prompt">{prompt}</p>
		<div class="fill-lines"></div>
	</div>
{/snippet}

{#snippet photo(id: string, caption: string, cls = '')}
	<figure class="photo {cls}">
		<img src="{photoBase}/{id}.jpg" alt="" />
		<figcaption lang="de">{caption}</figcaption>
	</figure>
{/snippet}

<div class="book2" class:wrap={cover}>
{#if cover}
	{@const front = book.chapters[2] ?? book.chapters[0]}
	{@const back = book.chapters[0]}
	<section class="sheet" style:--spine="{spineMm}mm" data-accent={front.accent}>
		<div class="half backhalf" data-accent={back.accent}>
			<img class="bleed" src="{photoBase}/{back.opener.photo}.jpg" alt="" />
			<div class="back-plate">
			<p class="kicker">Language Quiz · German for English speakers</p>
				<h2>German, one place at a time.</h2>
				<p class="lede">A Berlin street at dusk. A Späti at midnight. A market in Munich, a flat in Prenzlauer Berg, Sunday cake at Oma’s, the fish market at five in the morning. Twelve chapters, twelve real places, and the German you need in each of them.</p>
				<ul class="worlds">
					{#each book.chapters as c (c.id)}<li><b>{c.n}</b> {c.world}</li>{/each}
				</ul>
				<div class="back-cols">
					<p><b>Words first.</b> Every chapter opens on a photograph with the words pinned to the things, so the first thing you learn is what you can see.</p>
					<p><b>Real German.</b> Price boards, a departures board, a doorbell, a menu, a passport, a lost-cat notice: the texts Germany actually prints, photographed and read.</p>
					<p><b>Paper and phone.</b> Write in the book. Scan a code and the chapter is read aloud, a tutor talks to you, or the exercise opens in the app with instant correction.</p>
					<p><b>Free.</b> The whole course, A1 to C2, is free at languagequiz.org. This book is its paper half.</p>
				</div>
				<p class="site">languagequiz.org</p>
			</div>
		</div>
		<div class="spine"><span>Deutsch A1.1 · Erste Schritte</span><b>languagequiz.org</b></div>
		<div class="half fronthalf">
			<img class="bleed" src="{photoBase}/{front.opener.photo}.jpg" alt="" />
			<div class="plate">
				<p class="kicker">Language Quiz · German for English speakers</p>
				<h1>{book.title}</h1>
				<p class="subtitle">{book.subtitle}</p>
				<p class="blurb">{book.chapters.length} chapters, each one a real place in Germany: words first, a photo, a story, two rules, a real document, and the practice. Every chapter's audio by QR code.</p>
				<p class="site">languagequiz.org</p>
			</div>
		</div>
	</section>
{:else}
	<!-- 1 · cover -->
	<section class="page right cover" data-accent={book.chapters[2]?.accent ?? 'sage'}>
		<img class="bleed" src="{photoBase}/{book.chapters[2]?.opener.photo ?? book.chapters[0].opener.photo}.jpg" alt="" />
		<div class="plate">
			<p class="kicker">Language Quiz · German for English speakers</p>
			<h1>{book.title}</h1>
			<p class="subtitle">{book.subtitle}</p>
			<p class="blurb">{book.chapters.length} chapters, each one a real place in Germany: words first, a photo, a story, two rules, a real document, and the practice. Every chapter's audio by QR code.</p>
			<p class="site">languagequiz.org</p>
		</div>
	</section>

	<!-- 2 · how this book works -->
	<section class="page left how">
		<header class="head small">
			<p class="eyebrow">Before you start</p>
			<h2>How this book works</h2>
		</header>
		<div class="how-cols">
			<div>
				<p>Every chapter is one place: a market in Munich, a Späti at midnight, a flat in Berlin, the Bürgeramt. The place gives you the words, the words carry the story, and the story carries the grammar. You never learn a rule before you have met it in a sentence.</p>
				<p>The chapters all have the same ten pages, so you always know where you are:</p>
				<ol class="pages">
					<li><b>The photo.</b> A real place, with the words pinned on the things.</li>
					<li><b>Words first.</b> The rest of the chapter's words, with pictures. Cover the English, test yourself.</li>
					<li><b>Reading.</b> Maya, Lena and Max in the situation. The English is underneath, small.</li>
					<li><b>Grammar, twice.</b> Two pages, two rules, a Mini-Check at the foot of each.</li>
					<li><b>Reading the real thing.</b> A photographed sign, menu, form or board, as Germany prints it.</li>
					<li><b>Practice, two pages.</b> Write in the book. The answers are at the back, not on the page.</li>
					<li><b>Listen, speak, I can.</b> The QR codes, and the four things you can now do.</li>
					<li><b>The picture dictionary.</b> Every pictured word of the chapter on one page.</li>
				</ol>
			</div>
			<div>
				<p><b>Work with a pencil.</b> Say every German word out loud as you write it. The ruled lines at the foot of a page are yours: the sentences you want to keep, the mistakes you made twice.</p>
				<p><b>The codes.</b> Scan a code with your phone camera and the chapter's audio plays, the tutor talks to you, or the app opens the exercise with instant correction. The number under each code is its address if the camera will not read it: languagequiz.org/b/<i>code</i>.</p>
				<p><b>Wusstest du?</b> The box at the foot of a page is a fact about Germany, not grammar. Skip it or read it; it is there because the place deserved it.</p>
				<p><b>Three colours.</b> Blue words are <b class="art der">der</b>, red words <b class="art die">die</b>, green words <b class="art das">das</b>, in every list and table. Buy three pencils.</p>
				<p class="name">This book belongs to <span></span></p>
			</div>
		</div>
		<footer class="foot"><span class="tnum">2</span><span>{book.title} · {book.subtitle}</span></footer>
	</section>

	<!-- 3 · contents -->
	<section class="page right contents">
		<header class="head small">
			<p class="eyebrow">{book.level}</p>
			<h2>Contents</h2>
		</header>
		<ol class="toc">
			{#each book.chapters as c, i (c.id)}
				<li data-accent={c.accent}>
					<span class="no">{c.n}</span>
					<span class="t"><b lang="de">{c.title}</b> <small>{c.subtitle}</small><i>{c.world}</i></span>
					<span class="pg tnum">{firstPage(i)}</span>
				</li>
			{/each}
			<li class="key-line"><span class="no">✓</span><span class="t"><b>Answers</b> <small>and the picture credits</small></span><span class="pg tnum">{keyPage}</span></li>
		</ol>
		<footer class="foot"><span class="tnum">3</span><span>{book.title} · {book.subtitle}</span></footer>
	</section>

	{#each book.chapters as c, i (c.id)}
		{@const p = firstPage(i)}
		{@const prac = practiseOf(c)}
		{@const [prac1, prac2] = split(prac, Math.ceil(prac.length / 2))}

		<!-- 1 · Opener: the left page of the opening spread; the plate holds the words not pinned on the photo -->
		{@const pinned = new Set((c.opener.labels ?? []).map((l) => bare(l.de)))}
		{@const strip = c.words.groups.flatMap((g) => g.items).filter((w) => !pinned.has(bare(w.de)))}
		<section class="page {side(p)} opener" data-accent={c.accent}>
			<img class="bleed pano left" src="{photoBase}/{c.opener.photo}.jpg" alt="" />
			<div class="plate">
				<span class="num">{c.n}</span>
				<div class="plate-cols">
					<div>
						<h2 lang="de">{c.title}</h2>
						<p class="world">{c.world}</p>
						<p class="cap" lang="de">{c.opener.caption}</p>
					</div>
					<ol class="qs" lang="de">
						{#each c.opener.questions as q (q)}<li>{q}</li>{/each}
					</ol>
				</div>
				<p class="strip-title">{c.words.more ?? 'Auch hier · also here'}</p>
				<ul class="grid">
					{#each strip as w (w.de)}
						{@const a = article(w.de)}
						<li>
							{#if w.image}<img src="/img/{w.image}.webp" alt="" />{/if}
							<span class="de" lang="de">{#if a}<b class="art {a}">{a}</b>&nbsp;{/if}{bare(w.de)}</span>
							{#if plural(w.pl)}<span class="pl">{plural(w.pl)}</span>{/if}
							<span class="en">{w.en}</span>
						</li>
					{/each}
				</ul>
			</div>
		</section>

		<!-- 2 · Words first: the right half of the panorama, the words pinned onto it -->
		<section class="page {side(p + 1)} words" data-accent={c.accent}>
			<img class="bleed pano right" src="{photoBase}/{c.opener.photo}.jpg" alt="" />
			<p class="eyebrow onphoto">Wörter zuerst · words first</p>
			{#each c.opener.labels ?? [] as l (l.de)}
				{@const a = article(l.de)}
				<div class="pin {l.side ?? 'right'}" style:left="{l.x}%" style:top="{l.y}%">
					<span class="dot"></span>
					<span class="tag">
						<span class="de" lang="de">{#if a}<b class="art {a}">{a}</b>&nbsp;{/if}{bare(l.de)}</span>
						<span class="meta">{#if plural(l.pl)}{plural(l.pl)} · {/if}{l.en}</span>
					</span>
				</div>
			{/each}
			{@render foot(p + 1, c)}
		</section>

		<!-- 3 · Reading -->
		<section class="page {side(p + 2)} reading" data-accent={c.accent}>
			<header class="head small">
				<p class="eyebrow">Lesen · reading</p>
				<h2 lang="de">{c.reading.title}</h2>
			</header>
			<p class="intro">{c.reading.intro}</p>
			<div class="read-cols">
				<div class="dialogue" lang="de">
					{#each c.reading.lines as l, j (j)}
						<p class:a={l.who === c.reading.lines[0].who} class:prose={!l.who}>
							{#if l.who}<b>{l.who}</b>{/if}
							<span>{@html rich(l.de)}</span>
						</p>
					{/each}
				</div>
				<div class="side-photos">
					{#each c.reading.photos as ph (ph.photo)}{@render photo(ph.photo, ph.caption, 'small')}{/each}
				</div>
			</div>
			<p class="en"><b>English</b> · {c.reading.en}</p>
			<div class="flow">
				{#each c.reading.tasks as ex, e (e)}<ExerciseBlock {ex} n={e + 1} />{/each}
			</div>
			{@render filler('Copy the two sentences of the text you want to remember, then write one of your own in the same shape.')}
			{@render fact(c.reading.fact)}
			{@render foot(p + 2, c)}
		</section>

		<!-- 4–5 · Grammar -->
		{#each c.grammar as g, gi (g.heading)}
			<section class="page {side(p + 3 + gi)} grammar" data-accent={c.accent}>
				<header class="head small">
					<p class="eyebrow">Grammatik · {gi + 1} of {c.grammar.length}</p>
					<h2 lang="de">{g.heading}</h2>
					{#if g.subheading}<p class="sub">{g.subheading}</p>{/if}
				</header>
				<div class="flow" class:with-photo={g.photo}>
					{#if g.photo}{@render photo(g.photo.photo, g.photo.caption, 'float')}{/if}
					{#each g.blocks as block, b (b)}<LearnBlock {block} />{/each}
					{#if g.check}<div class="check"><ExerciseBlock ex={g.check} n={gi + 1} /></div>{/if}
				</div>
				{@render filler('Write three sentences of your own with the rule of this page. Use words from the word page.')}
				{@render fact(g.fact)}
				{@render foot(p + 3 + gi, c)}
			</section>
		{/each}

		<!-- 6 · Real-world reading -->
		<section class="page {side(p + 5)} document" data-accent={c.accent}>
			<header class="head small">
				<p class="eyebrow">Lesen im Alltag · reading the real thing</p>
				<h2 lang="de">{c.document.caption}</h2>
			</header>
			{@render photo(c.document.photo, '', 'wide')}
			<p class="intro">{c.document.intro}</p>
			<div class="flow">
				{#each c.document.tasks as ex, e (e)}<ExerciseBlock {ex} n={e + 1} />{/each}
			</div>
			{@render filler('Write down every German word you can read on the photo, with its article if it is a noun.')}
			{@render fact(c.document.fact)}
			{@render foot(p + 5, c)}
		</section>

		<!-- 7–8 · Practise -->
		{#each [prac1, prac2] as exs, pi (pi)}
			<section class="page {side(p + 6 + pi)} practise" data-accent={c.accent}>
				<header class="head small">
					<p class="eyebrow">Übungen · practise {pi + 1} of 2</p>
					<h2 lang="de">{c.title}</h2>
				</header>
				<div class="flow">
					{#each exs as ex, e (e)}<ExerciseBlock {ex} n={pi * prac1.length + e + 1} listen={qr[c.id]?.listen ?? null} />{/each}
				</div>
				{@render filler(pi === 0 ? 'Pick five words from this chapter and write one sentence with each.' : 'Write what you got wrong on these two pages, correctly, once each.')}
				{@render foot(p + 6 + pi, c)}
			</section>
		{/each}

		<!-- 9 · Listen, speak, I can -->
		<section class="page {side(p + 8)} end" data-accent={c.accent}>
			<header class="head small">
				<p class="eyebrow">Hören, sprechen, können</p>
				<h2 lang="de">{c.title}</h2>
			</header>
			<div class="codes">
				{#if qr[c.id]?.listen}
					<div class="code">
						{@html qr[c.id].listen!.svg}
						<div><b>Hören</b><p>{c.listen?.intro ?? 'Every recording of this chapter. Scan, listen, and do the Listen exercise again with your eyes closed.'}</p><small>{qr[c.id].listen!.code}</small></div>
					</div>
				{/if}
				{#if qr[c.id]?.speak}
					<div class="code">
						{@html qr[c.id].speak!.svg}
						<div><b>Sprechen</b><p>{c.speak?.intro ?? 'Open the code and speak with the tutor.'}</p><small>{qr[c.id].speak!.code}</small></div>
					</div>
				{/if}
				{#if qr[c.id]?.app}
					<div class="code">
						{@html qr[c.id].app!.svg}
						<div><b>In der App</b><p>The chapter's exercise with instant correction and the medal ladder.</p><small>{qr[c.id].app!.code}</small></div>
					</div>
				{/if}
			</div>
			<div class="cando">
				<p class="eyebrow">Ich kann … · I can</p>
				<ul>
					{#each c.canDo as line (line)}<li><span class="box"></span>{line}</li>{/each}
				</ul>
			</div>
			<div class="next">
				<p>Done? Tick what you can, circle what you got wrong on the practice pages, and come back to those in a week. The answers are on page {keyPage}.</p>
			</div>
			<p class="eyebrow notes-title">Meine Notizen · my notes</p>
			<div class="fill"><div class="fill-lines"></div></div>
			{@render foot(p + 8, c)}
		</section>

		<!-- 10 · The chapter's picture dictionary -->
		<section class="page {side(p + 9)} dict" data-accent={c.accent}>
			<header class="head small">
				<p class="eyebrow">Bildwörterbuch · picture dictionary</p>
				<h2 lang="de">{c.title}</h2>
			</header>
			<p class="intro">Every pictured word of this chapter on one page. Cover the words, say them from the pictures; cover the pictures, draw them from the words.</p>
			<ul class="grid big">
				{#each picturedWords(c).slice(0, 35) as w (w.de)}
					{@const a = article(w.de)}
					<li>
						<img src="/img/{w.image}.webp" alt="" />
						<span class="de" lang="de">{#if a}<b class="art {a}">{a}</b>&nbsp;{/if}{bare(w.de)}</span>
						{#if plural(w.pl)}<span class="pl">{plural(w.pl)}</span>{/if}
						<span class="en">{w.en}</span>
					</li>
				{/each}
			</ul>
			{@render foot(p + 9, c)}
		</section>
	{/each}

	<!-- Key and credits -->
	{#each keyPages as chunk, k (k)}
		<section class="page {side(keyPage + k)} key">
			<header class="head small">
				<p class="eyebrow">Lösungen · the key</p>
				<h2>{chunk.length ? `Answers · ${k + 1} of ${keyPages.length - 1}` : 'Picture credits'}</h2>
			</header>
			<div class="keycols">
				{#each chunk as c (c.id)}
					<section>
						<h3><b>{c.n}</b> {c.title}</h3>
						{#each chapterKey(c) as part (part.part)}
							<h4>{part.part}</h4>
							{#each part.entries as x (x.exercise)}
								<p>
									<span class="n">{x.exercise}</span> <em>{x.title}</em> ·
									{#each x.answers as a, j (j)}{#if j}<span class="sep">&ensp;·&ensp;</span>{/if}<span lang="de">{#if a.q}<span class="q">{a.q}</span>&nbsp;{/if}<strong>{a.a}</strong></span>{/each}
									{#if x.note}<i> {x.note}</i>{/if}
								</p>
							{/each}
						{/each}
					</section>
				{/each}
			</div>
			{#if k === keyPages.length - 1}
				<div class="credits full">
					<p class="eyebrow">Die Fotos · picture credits</p>
					{#each [...new Set(book.chapters.flatMap((c) => [c.opener.photo, ...c.reading.photos.map((x) => x.photo), ...c.grammar.flatMap((g) => (g.photo ? [g.photo.photo] : [])), c.document.photo]))] as id (id)}
						{#if credits[id]}<p>{credits[id].title} — {credits[id].author}, {credits[id].license}, Wikimedia Commons.</p>{/if}
					{/each}
					<p>Word pictures and diagrams: Language Quiz.</p>
				</div>
			{/if}
			<footer class="foot"><span class="tnum">{keyPage + k}</span><span>{book.title} · {book.subtitle}</span></footer>
		</section>
	{/each}
	<!-- back cover -->
	<section class="page left back" data-accent={book.chapters[0].accent}>
		<img class="bleed" src="{photoBase}/{book.chapters[0].opener.photo}.jpg" alt="" />
		<div class="back-plate">
			<p class="kicker">Language Quiz · German for English speakers</p>
			<h2>German, one place at a time.</h2>
			<p class="lede">A Berlin street at dusk. A Späti at midnight. A market in Munich, a flat in Prenzlauer Berg, Sunday cake at Oma's, the fish market at five in the morning. Twelve chapters, twelve real places, and the German you need in each of them.</p>
			<ul class="worlds">
				{#each book.chapters as c (c.id)}<li><b>{c.n}</b> {c.world}</li>{/each}
			</ul>
			<div class="back-cols">
				<p><b>Words first.</b> Every chapter opens on a photograph with the words pinned to the things, so the first thing you learn is what you can see.</p>
				<p><b>Real German.</b> Price boards, a departures board, a doorbell, a menu, a passport, a lost-cat notice: the texts Germany actually prints, photographed and read.</p>
				<p><b>Paper and phone.</b> Write in the book. Scan a code and the chapter is read aloud, a tutor talks to you, or the exercise opens in the app with instant correction.</p>
				<p><b>Free.</b> The whole course, A1 to C2, is free at languagequiz.org. This book is its paper half.</p>
			</div>
			<p class="site">languagequiz.org · Deutsch A1.1 · Erste Schritte</p>
		</div>
	</section>
{/if}
</div>

<style>
	.book2 {
		--serif: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		--sans: 'Inter Variable', Inter, ui-sans-serif, system-ui, sans-serif;
		--navy: #1f3a5f;
		--ink: #24262b;
		--muted: #5f5a52;
		--rule: #cfc8bb;
		--paper: #fbf8f3;
		--accent: #c9683b;
		--accent-tint: #fbefe8;
		--der: #1f5aa6;
		--die: #b8322e;
		--das: #2f7d4f;
		display: grid;
		justify-content: center;
		gap: 8mm;
		padding: 8mm 0 16mm;
		color: var(--ink);
		font-family: var(--sans);
		font-size: 10.5pt;
		line-height: 1.4;
		-webkit-print-color-adjust: exact;
		print-color-adjust: exact;
	}

	[data-accent='terracotta'] { --accent: #c9683b; --accent-tint: #fbefe8; }
	[data-accent='mustard'] { --accent: #b9842a; --accent-tint: #fbf3df; }
	[data-accent='sage'] { --accent: #5f8064; --accent-tint: #eef3ee; }
	[data-accent='blue'] { --accent: #3b6ea5; --accent-tint: #e9f0f8; }

	.page {
		position: relative;
		box-sizing: border-box;
		display: flex;
		flex-direction: column;
		width: 210mm;
		height: 297mm;
		overflow: hidden;
		padding: 14mm 18mm 18mm 22mm;
		background: #fff;
		box-shadow: 0 1px 2px rgb(0 0 0 / 0.06), 0 8px 28px rgb(0 0 0 / 0.07);
	}
	.page.left { padding: 14mm 22mm 18mm 18mm; }

	/* The fore-edge tab: the chapter's colour on the outer edge of every page. */
	.page::before {
		content: '';
		position: absolute;
		top: 40mm;
		bottom: 40mm;
		right: 0;
		width: 3mm;
		background: var(--accent);
	}
	.page.left::before { right: auto; left: 0; }

	.foot {
		position: absolute;
		bottom: 9mm;
		left: 22mm;
		right: 18mm;
		display: flex;
		justify-content: space-between;
		align-items: baseline;
		padding-top: 2mm;
		border-top: 0.25mm solid var(--rule);
		font-size: 7.5pt;
		color: var(--muted);
	}
	.foot .tnum { order: 2; font-size: 9pt; font-weight: 800; color: var(--navy); }
	.left .foot { left: 18mm; right: 22mm; }
	.left .foot .tnum { order: 0; }

	.eyebrow {
		margin: 0;
		font-size: 7.5pt;
		font-weight: 800;
		letter-spacing: 0.1em;
		text-transform: uppercase;
		color: var(--accent);
	}
	h2 {
		margin: 0.5mm 0 0;
		font-family: var(--serif);
		font-size: 24pt;
		line-height: 1.05;
		color: var(--navy);
	}
	.head { display: flex; gap: 5mm; align-items: flex-start; margin-bottom: 4mm; }
	.head.small { display: block; margin-bottom: 3mm; }
	.head.small h2 { font-size: 19pt; }
	.head .num {
		font-family: var(--serif);
		font-size: 44pt;
		line-height: 0.9;
		font-weight: 700;
		color: var(--accent);
	}
	.sub { margin: 1mm 0 0; font-size: 10pt; color: var(--muted); }
	.intro { margin: 0 0 3mm; font-size: 10pt; color: var(--muted); max-width: 150mm; }
	.flow { display: flex; flex-direction: column; gap: 3mm; }

	/* -- the print wrap: back + spine + front, 3 mm bleed all round ------------- */
	.sheet { --bleed: 3mm; position: relative; display: grid; grid-template-columns: calc(210mm + var(--bleed)) var(--spine) calc(210mm + var(--bleed)); width: calc(420mm + var(--spine) + 2 * var(--bleed)); height: calc(297mm + 2 * var(--bleed)); background: var(--accent); overflow: hidden; }
	.half { position: relative; overflow: hidden; }
	.half .bleed { position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover; }
	.backhalf .bleed { filter: brightness(0.55); }
	.backhalf .back-plate { left: calc(18mm + var(--bleed)); right: 18mm; top: calc(22mm + var(--bleed)); bottom: auto; padding: 10mm 11mm 8mm; }
	.backhalf .back-plate .site { margin-top: 5mm; }
	.backhalf .back-cols { font-size: 10pt; }
	.backhalf .worlds { font-size: 10pt; line-height: 1.7; }
	.backhalf h2 { font-size: 34pt; }
	.backhalf .lede { font-size: 13pt; }
	.fronthalf .plate { position: absolute; left: 0; right: 0; bottom: 0; padding: 10mm calc(18mm + var(--bleed)) calc(12mm + var(--bleed)) 22mm; background: rgb(251 248 243 / 0.96); border-top: 4mm solid var(--accent); }
	.fronthalf .kicker { margin: 0; font-size: 8pt; font-weight: 800; letter-spacing: 0.12em; text-transform: uppercase; color: var(--accent); }
	.fronthalf h1 { margin: 2mm 0 0; font-family: var(--serif); font-size: 52pt; line-height: 1; color: var(--navy); }
	.fronthalf .subtitle { margin: 1mm 0 4mm; font-family: var(--serif); font-size: 20pt; color: var(--ink); }
	.fronthalf .blurb { margin: 0; max-width: 130mm; font-size: 10pt; color: var(--muted); }
	.fronthalf .site { margin: 5mm 0 0; font-size: 9pt; font-weight: 800; color: var(--navy); }
	.spine { display: flex; flex-direction: column; justify-content: space-between; align-items: center; padding: calc(10mm + var(--bleed)) 0; background: var(--accent); color: #fff; writing-mode: vertical-rl; }
	.spine span { font-family: var(--serif); font-size: 11pt; font-weight: 700; }
	.spine b { font-size: 7pt; letter-spacing: 0.08em; }
	.wrap { padding: 0; display: block; }

	/* -- back cover ------------------------------------------------------------ */
	.back { padding: 0; }
	.back::before { display: none; }
	.back .bleed { position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover; filter: brightness(0.55); }
	.back-plate { position: absolute; left: 18mm; right: 22mm; top: 22mm; bottom: 22mm; padding: 10mm 11mm; background: rgb(251 248 243 / 0.96); border-radius: 2mm; display: flex; flex-direction: column; }
	.back .kicker { margin: 0; font-size: 8pt; font-weight: 800; letter-spacing: 0.12em; text-transform: uppercase; color: var(--accent); }
	.back h2 { margin: 2mm 0 3mm; font-size: 30pt; }
	.back .lede { margin: 0 0 5mm; font-family: var(--serif); font-size: 12pt; line-height: 1.4; color: var(--ink); }
	.worlds { list-style: none; margin: 0 0 6mm; padding: 3mm 0; border-top: 0.3mm solid var(--accent); border-bottom: 0.3mm solid var(--accent); columns: 2; column-gap: 8mm; font-size: 9pt; line-height: 1.6; }
	.worlds b { display: inline-block; width: 7mm; font-family: var(--serif); color: var(--accent); }
	.back-cols { columns: 2; column-gap: 8mm; font-size: 9.5pt; line-height: 1.45; }
	.back-cols p { margin: 0 0 3mm; break-inside: avoid; }
	.back .site { margin-top: auto; font-size: 9pt; font-weight: 800; color: var(--navy); }

	/* -- cover, how, contents ------------------------------------------------ */
	.cover { padding: 0; }
	.cover::before { display: none; }
	.cover .bleed { position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover; }
	.cover .plate { position: absolute; left: 0; right: 0; bottom: 0; padding: 10mm 18mm 12mm 22mm; background: rgb(251 248 243 / 0.96); border-top: 4mm solid var(--accent); }
	.cover .kicker { margin: 0; font-size: 8pt; font-weight: 800; letter-spacing: 0.12em; text-transform: uppercase; color: var(--accent); }
	.cover h1 { margin: 2mm 0 0; font-family: var(--serif); font-size: 52pt; line-height: 1; color: var(--navy); }
	.cover .subtitle { margin: 1mm 0 4mm; font-family: var(--serif); font-size: 20pt; color: var(--ink); }
	.cover .blurb { margin: 0; max-width: 130mm; font-size: 10pt; color: var(--muted); }
	.cover .site { margin: 5mm 0 0; font-size: 9pt; font-weight: 800; color: var(--navy); }
	.how-cols { display: grid; grid-template-columns: 1fr 1fr; gap: 8mm; font-size: 9.5pt; line-height: 1.45; }
	.how-cols p { margin: 0 0 2.5mm; }
	.pages { margin: 0 0 3mm; padding-left: 5mm; }
	.pages li { margin-bottom: 1.2mm; }
	.name { margin-top: 8mm !important; font-family: var(--serif); font-size: 12pt; color: var(--navy); }
	.name span { display: inline-block; width: 60mm; border-bottom: 0.3mm solid var(--navy); }
	.toc { list-style: none; margin: 2mm 0 0; padding: 0; }
	.toc li { display: grid; grid-template-columns: 12mm 1fr 12mm; align-items: baseline; gap: 3mm; padding: 1.7mm 0; border-bottom: 0.25mm solid var(--rule); }
	.toc .no { font-family: var(--serif); font-size: 18pt; font-weight: 700; color: var(--accent); }
	.toc .t b { font-family: var(--serif); font-size: 13pt; color: var(--navy); }
	.toc .t small { display: block; font-size: 8.5pt; color: var(--muted); }
	.toc .t i { display: block; font-size: 7.5pt; font-style: normal; letter-spacing: 0.06em; text-transform: uppercase; color: var(--accent); margin-top: 0.5mm; }
	.toc .pg { text-align: right; font-weight: 800; color: var(--navy); }
	.toc .key-line .no { color: var(--navy); }

	/* -- words first --------------------------------------------------------- */
	.words { padding: 0; }
	.words::before { display: none; }
	.words .eyebrow.onphoto { position: absolute; top: 8mm; left: 10mm; padding: 1mm 2.5mm; background: var(--navy); color: #fff; border-radius: 1mm; }
	.pin { position: absolute; display: flex; align-items: center; gap: 1.2mm; transform: translate(-1.6mm, -50%); }
	.pin.left { flex-direction: row-reverse; transform: translate(calc(-100% + 1.6mm), -50%); }
	.pin .dot { width: 3.2mm; height: 3.2mm; border-radius: 50%; background: var(--accent); border: 0.5mm solid #fff; box-shadow: 0 0 0 0.3mm var(--navy); flex: none; }
	.pin .tag { display: flex; flex-direction: column; padding: 1mm 2.2mm 1.2mm; background: rgb(255 255 255 / 0.93); border-radius: 1.2mm; box-shadow: 0 0.6mm 2mm rgb(0 0 0 / 0.28); line-height: 1.15; white-space: nowrap; }
	.pin .de { font-size: 9.5pt; font-weight: 800; color: var(--navy); }
	.pin .meta { font-size: 6.6pt; color: var(--muted); }
	.strip { position: absolute; left: 10mm; right: 14mm; bottom: 16mm; padding: 3.5mm 4mm 3mm; background: rgb(251 248 243 / 0.95); border-radius: 2mm; box-shadow: 0 2mm 8mm rgb(0 0 0 / 0.2); }
	.strip-title { margin: 0 0 1.2mm; padding-top: 1.5mm; border-top: 0.3mm solid var(--accent); font-size: 7.5pt; font-weight: 800; letter-spacing: 0.08em; text-transform: uppercase; color: var(--accent); }
	.words .foot { left: 10mm; right: 14mm; border-top: 0; color: transparent; }
	.words .foot .tnum { color: #fff; }
	.plate-cols { display: grid; grid-template-columns: 1.3fr 1fr; gap: 6mm; align-items: end; margin-bottom: 2.5mm; }
	.phrases { list-style: none; margin: 0; padding: 0; font-size: 8.5pt; line-height: 1.3; columns: 1; }
	.phrases .en { color: var(--muted); font-size: 7.5pt; }
	.phrases li { border-left: 0.4mm solid var(--accent); padding-left: 2mm; margin-bottom: 0.6mm; }
	.grid {
		list-style: none;
		margin: 0;
		padding: 0;
		display: grid;
		grid-template-columns: repeat(6, 1fr);
		gap: 1.4mm 2mm;
	}
	.grid li { display: flex; flex-direction: column; align-items: center; text-align: center; font-size: 8.5pt; line-height: 1.2; }
	.grid img { width: 12mm; height: 12mm; object-fit: contain; margin-bottom: 0.8mm; background: #fff; border-radius: 2mm; }
	.grid .de { font-weight: 700; color: var(--ink); }
	.grid .pl { font-size: 7pt; color: var(--muted); }
	.grid .en { font-size: 7.5pt; color: var(--muted); }
	.art.der { color: var(--der); }
	.art.die { color: var(--die); }
	.art.das { color: var(--das); }
	.verbs { list-style: none; margin: 0; padding: 0; display: grid; grid-template-columns: repeat(4, 1fr); gap: 1.5mm 4mm; font-size: 8.5pt; }
	.verbs li { display: flex; flex-direction: column; border-left: 0.4mm solid var(--accent); padding-left: 2mm; }
	.verbs .en { color: var(--muted); font-size: 7.5pt; }

	/* -- opener ------------------------------------------------------------- */
	.opener { padding: 0; }
	.opener::before { display: none; }
	/* The panorama: one photo across the spread, each page showing its half. */
	.bleed.pano { position: absolute; top: 0; height: 297mm; width: 420mm; object-fit: cover; }
	.bleed.pano.left { left: 0; }
	.bleed.pano.right { left: -210mm; }
	.opener .bleed { height: 297mm; clip-path: inset(0 0 126mm 0); }
	.opener .plate {
		position: absolute;
		left: 0; right: 0; bottom: 0;
		height: 126mm;
		padding: 5mm 22mm 5mm 18mm;
		background: var(--paper);
		border-top: 3mm solid var(--accent);
	}
	.opener .num { position: absolute; left: 18mm; top: -22mm; font-family: var(--serif); font-size: 60pt; font-weight: 700; color: #fff; text-shadow: 0 1px 6px rgb(0 0 0 / 0.5); }
	.opener h2 { font-size: 26pt; }
	.opener .world { margin: 0.5mm 0 2mm; font-size: 9pt; font-weight: 700; letter-spacing: 0.05em; text-transform: uppercase; color: var(--accent); }
	.opener .cap { margin: 0; font-family: var(--serif); font-size: 10.5pt; color: var(--ink); }
	.qs { margin: 0; padding-left: 5mm; font-size: 10pt; }
	.qs li { margin-bottom: 0.8mm; }
	.fact.onplate { position: absolute; right: 22mm; bottom: 8mm; width: 56mm; margin: 0; }

	/* -- reading ------------------------------------------------------------ */
	.read-cols { display: grid; grid-template-columns: 1fr 46mm; gap: 5mm; margin-bottom: 2mm; }
	.dialogue { font-family: var(--serif); font-size: 10pt; line-height: 1.3; }
	.dialogue p { margin: 0 0 0.9mm; display: grid; grid-template-columns: 22mm 1fr; gap: 2mm; }
	.dialogue p.prose { display: block; margin-bottom: 2.2mm; }
	.dialogue b { font-family: var(--sans); font-size: 8pt; font-weight: 800; letter-spacing: 0.04em; text-transform: uppercase; color: var(--accent); padding-top: 0.8mm; }
	.dialogue p.a b { color: var(--navy); }
	.side-photos { display: flex; flex-direction: column; gap: 3mm; }
	.reading .en { margin: 0 0 2mm; font-size: 6.8pt; color: var(--muted); line-height: 1.25; }
	.reading .en b { color: var(--navy); }

	/* -- photos --------------------------------------------------------------- */
	.photo { margin: 0; }
	.photo img { display: block; width: 100%; border: 0.3mm solid var(--navy); border-radius: 1mm; }
	.photo figcaption { margin-top: 1mm; font-size: 7.5pt; color: var(--muted); font-style: italic; }
	.photo.small img { aspect-ratio: 4 / 3; object-fit: cover; }
	.photo.wide img { aspect-ratio: 3 / 2; object-fit: cover; max-height: 94mm; }
	.photo.wide { margin-bottom: 3mm; }
	.photo.float { float: right; width: 66mm; margin: 0 0 3mm 4mm; }
	.flow.with-photo { display: block; }
	.flow.with-photo > :global(*) { margin-bottom: 3mm; }

	/* -- filler: ruled lines that take whatever room the page has left ---------- */
	.fill { flex: 1 1 0; display: flex; flex-direction: column; min-height: 0; margin-top: 3mm; overflow: hidden; }
	.fill-prompt { margin: 0.5mm 0 0; font-size: 8pt; color: var(--muted); }
	.fill-lines { flex: 1; min-height: 0; margin-top: 1mm; background: repeating-linear-gradient(to bottom, transparent 0, transparent 7.7mm, var(--rule) 7.7mm, var(--rule) 7.95mm); background-position: 0 100%; }
	.flow { flex: 0 0 auto; }

	/* -- facts --------------------------------------------------------------- */
	.fact {
		margin-top: 3mm;
		padding: 2.5mm 3.5mm;
		background: var(--accent-tint);
		border-left: 1mm solid var(--accent);
		border-radius: 0 1.5mm 1.5mm 0;
		font-size: 8.5pt;
		line-height: 1.35;
		margin-bottom: 11mm;
	}
	.fact p { margin: 0.5mm 0 0; }

	/* -- document ------------------------------------------------------------ */
	.document .head.small h2 { font-size: 13pt; font-family: var(--sans); font-weight: 600; color: var(--ink); }

	/* -- chapter end --------------------------------------------------------- */
	.codes { display: grid; gap: 4mm; margin: 4mm 0 8mm; }
	.code { display: grid; grid-template-columns: 26mm 1fr; gap: 4mm; align-items: center; padding: 3mm; border: 0.3mm solid var(--rule); border-radius: 2mm; }
	.code :global(svg) { width: 26mm; height: 26mm; }
	.code b { font-family: var(--serif); font-size: 14pt; color: var(--navy); }
	.code p { margin: 1mm 0; font-size: 9.5pt; }
	.code small { color: var(--muted); font-size: 7.5pt; }
	.cando { padding: 5mm 6mm; background: var(--accent-tint); border-radius: 2mm; }
	.cando ul { list-style: none; margin: 2mm 0 0; padding: 0; display: grid; gap: 2mm; font-size: 11pt; }
	.cando li { display: flex; gap: 3mm; align-items: center; }
	.box { width: 5mm; height: 5mm; border: 0.4mm solid var(--navy); border-radius: 1mm; flex: none; }
	.next { margin-top: 6mm; font-size: 9.5pt; color: var(--muted); max-width: 140mm; }

	/* -- notes ------------------------------------------------------------------ */
	.lines { display: grid; gap: 8.2mm; margin-top: 4mm; }
	.lines.short { gap: 7.5mm; margin-top: 2mm; }
	.notes-title { margin-top: 6mm; }
	.check { margin-top: 2mm; padding-top: 2mm; border-top: 0.3mm solid var(--accent); }
	.grid.big { grid-template-columns: repeat(5, 1fr); gap: 3mm 3mm; margin-top: 3mm; }
	.grid.big img { width: 24mm; height: 24mm; }
	.grid.big li { font-size: 9.5pt; }
	.grid.big .en { font-size: 8pt; }
	.lines span { display: block; border-bottom: 0.25mm solid var(--rule); }

	/* -- key ------------------------------------------------------------------- */
	.keycols { columns: 3; column-gap: 5mm; font-size: 7pt; line-height: 1.3; overflow: hidden; max-height: 240mm; }
	.key h3 { margin: 0 0 1.5mm; font-family: var(--serif); font-size: 12pt; color: var(--navy); }
	.key h4 { margin: 2.5mm 0 1mm; font-size: 7.5pt; letter-spacing: 0.08em; text-transform: uppercase; color: var(--accent); }
	.key p { margin: 0 0 1mm; break-inside: avoid; }
	.key .n { display: inline-block; min-width: 3.5mm; font-weight: 800; color: var(--navy); }
	.key em { color: var(--muted); }
	.key .q { color: var(--muted); }
	.key i { color: var(--muted); }
	.credits { margin-top: auto; margin-bottom: 11mm; font-size: 7pt; color: var(--muted); line-height: 1.3; }
	.credits.full { margin-top: 0; columns: 2; column-gap: 6mm; }
	.credits p { margin: 0.5mm 0; }

	@media print {
		.book2 { display: block; padding: 0; }
		.page { box-shadow: none; break-after: page; }
		.page:last-child { break-after: auto; }
		:global(.skip-link) { display: none; }
	}
	@media screen and (max-width: 222mm) { .book2 { zoom: 0.45; } }
</style>
