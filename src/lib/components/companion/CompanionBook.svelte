<script lang="ts">
	// A level's study companion (domain/companion), page by page: the cover,
	// the welcome and the contents, one two-page spread per topic — learn on
	// the left, practise on the right, so they face each other when printed
	// double-sided — with review spreads between, then the grammar overview,
	// the picture dictionary and the answers. Every page is a fixed A4 sheet
	// with its own margins (wider on the binding side) and its own footer, so
	// the screen shows exactly what the printer gets.
	import { answerKey, rich, type Companion, type Spread } from '$lib/domain/companion';
	import ExerciseBlock from './ExerciseBlock.svelte';
	import LearnBlock from './LearnBlock.svelte';

	interface Qr {
		svg: string;
		code: string;
	}

	let {
		companion,
		courseName,
		qr
	}: {
		companion: Companion;
		courseName: string;
		/** Per spread id: the app and the Listen codes, when registered. */
		qr: Record<string, { app: Qr | null; listen: Qr | null }>;
	} = $props();

	// Cover (1), welcome (2), contents (3), then the spreads from page 4, so
	// every learn page is a left-hand page.
	const spreadPage = (i: number) => 4 + i * 2;
	const spreads = $derived(companion.spreads);
	/** Topic numbers skip the reviews. */
	const topicNo = $derived(spreads.map((_, i) => spreads.slice(0, i + 1).filter((s) => !s.review).length));
	const reviewNo = $derived(spreads.map((_, i) => spreads.slice(0, i + 1).filter((s) => s.review).length));
	const topics = $derived(spreads.filter((s) => !s.review).length);

	const overviewPage = $derived(spreadPage(spreads.length));
	const dictionaryPage = $derived(companion.overview ? overviewPage + 1 : overviewPage);
	const DICT_PER_PAGE = 20;
	const dictPages = $derived(
		companion.dictionary
			? Array.from({ length: Math.ceil(companion.dictionary.words.length / DICT_PER_PAGE) }, (_, i) =>
					companion.dictionary!.words.slice(i * DICT_PER_PAGE, (i + 1) * DICT_PER_PAGE)
				)
			: []
	);

	// The answers flow over as many pages as they need: spreads are packed
	// onto a page until its share of text runs out.
	const ANSWER_BUDGET = 6200;
	const weight = (s: Spread) =>
		answerKey(s).reduce((n, k) => n + 60 + k.answers.reduce((m, x) => m + (x.q?.length ?? 0) + x.a.length + 4, 0) + (k.note?.length ?? 0), 80);
	const answerPages = $derived.by(() => {
		const pages: number[][] = [[]];
		let used = 0;
		spreads.forEach((s, i) => {
			const w = weight(s);
			if (used + w > ANSWER_BUDGET && pages.at(-1)!.length) {
				pages.push([]);
				used = 0;
			}
			pages.at(-1)!.push(i);
			used += w;
		});
		return pages;
	});
	const answersPage = $derived(dictionaryPage + dictPages.length);
	/** A lined notes page when the book would otherwise end on an odd page. */
	const lastPage = $derived(answersPage + answerPages.length - 1);
	const notesPage = $derived(lastPage % 2 ? lastPage + 1 : null);

	const side = (page: number) => (page % 2 ? 'right' : 'left');
	const label = (i: number) => (spreads[i].review ? `Review ${reviewNo[i]}` : `Topic ${topicNo[i]}`);
	const running = $derived(`${companion.level} ${companion.title}`);
	const article = (de: string) => /^(der|die|das) /.exec(de)?.[1];
</script>

{#snippet footer(page: number, title?: string)}
	<footer class="foot">
		<span class="tnum">{page}</span>
		<span>{title ?? running}</span>
	</footer>
{/snippet}

{#snippet practiseHead(s: Spread, kicker: string)}
	<header class="bar-head">
		<div>
			<p class="eyebrow">{kicker}</p>
			<h2 lang="de">{s.title}</h2>
		</div>
		{#if qr[s.id]?.app}
			<figure class="qr">
				{@html qr[s.id].app!.svg}
				<figcaption>More practice<br />in the app<br /><span>{qr[s.id].app!.code}</span></figcaption>
			</figure>
		{/if}
	</header>
{/snippet}

{#snippet canDo(s: Spread)}
	<aside class="can-do">
		<p><b>I can …</b> <small>tick only what you could do tomorrow, without the book</small></p>
		<ul>
			{#each s.canDo as line (line)}<li><span class="box"></span>{line}</li>{/each}
		</ul>
	</aside>
{/snippet}

<div class="companion">
	<!-- 1 · cover -->
	<section class="page right cover">
		<p class="kicker">{courseName} · Study companion</p>
		<p class="code">{companion.level}</p>
		<h1>{companion.title}</h1>
		<img class="cover-pic" src="/img/{companion.cover}.webp" alt="" width="1024" height="768" />
		<div class="cover-foot">
			<p>{topics} {topics === 1 ? 'topic' : 'topics'} · learn on the left, write on the right · answers at the back</p>
			<p class="site">languagequiz.org</p>
		</div>
	</section>

	<!-- 2 · welcome -->
	<section class="page left welcome">
		<p class="eyebrow">Before you start</p>
		<h2>How this book works</h2>
		{#each companion.welcome as para, i (i)}<p class="para">{@html rich(para)}</p>{/each}

		<div class="anatomy" aria-hidden="true">
			<div class="mini">
				<b>Learn</b>
				<span class="bar w80"></span><span class="grid"></span><span class="bar w60"></span><span class="bar w90"></span>
				<small>tables · diagrams · rules</small>
			</div>
			<div class="mini">
				<b>Practise</b>
				<span class="lines"></span><span class="lines"></span><span class="ticks"></span>
				<small>write · match · listen · tick</small>
			</div>
		</div>

		<p class="name">This book belongs to <span></span></p>
		{@render footer(2)}
	</section>

	<!-- 3 · contents -->
	<section class="page right contents">
		<p class="eyebrow">{companion.level}</p>
		<h2>Contents</h2>
		<!-- More than twenty lines (A1.2's seventeen topics) close up to stay on the page; more than
		     twenty-four (B2.2's twenty topics and three reviews) close up further. -->
		<ol
			class:dense={spreads.length + (companion.planned?.length ?? 0) + 3 > 20}
			class:denser={spreads.length + (companion.planned?.length ?? 0) + 3 > 24}
		>
			{#each spreads as s, i (s.id)}
				<li class:review={s.review}>
					<span class="no tnum">{s.review ? '↻' : topicNo[i]}</span>
					<span class="t"><b lang="de">{s.title}</b> <small>{s.subtitle}</small></span>
					<span class="pg tnum">{spreadPage(i)}</span>
				</li>
			{/each}
			{#each companion.planned ?? [] as p, i (p.title)}
				<li class="planned">
					<span class="no tnum">{topics + i + 1}</span>
					<span class="t"><b lang="de">{p.title}</b> <small>{p.subtitle}</small></span>
					<span class="pg">in progress</span>
				</li>
			{/each}
			{#if companion.overview}
				<li class="back">
					<span class="no">≡</span>
					<span class="t"><b>{companion.overview.title}</b></span>
					<span class="pg tnum">{overviewPage}</span>
				</li>
			{/if}
			{#if companion.dictionary}
				<li class="back">
					<span class="no">◧</span>
					<span class="t"><b>{companion.dictionary.title}</b></span>
					<span class="pg tnum">{dictionaryPage}</span>
				</li>
			{/if}
			<li class="back">
				<span class="no">✓</span>
				<span class="t"><b>Answers</b></span>
				<span class="pg tnum">{answersPage}</span>
			</li>
		</ol>
		{@render footer(3)}
	</section>

	{#each spreads as s, i (s.id)}
		{#if s.review}
			<!-- a review: exercises on both pages -->
			<section class="page left practise review">
				{@render practiseHead(s, `${label(i)} · ${s.subtitle}`)}
				<p class="review-hook">{@html rich(s.hook)}</p>
				<div class="flow">
					{#each s.left ?? [] as ex, e (e)}<ExerciseBlock {ex} n={e + 1} listen={qr[s.id]?.listen ?? null} />{/each}
				</div>
				{@render footer(spreadPage(i), `${s.title} · 1`)}
			</section>
			<section class="page right practise review">
				<div class="flow">
					{#each s.practise as ex, e (e)}
						<ExerciseBlock {ex} n={(s.left?.length ?? 0) + e + 1} listen={qr[s.id]?.listen ?? null} />
					{/each}
				</div>
				{@render canDo(s)}
				{@render footer(spreadPage(i) + 1, `${s.title} · 2`)}
			</section>
		{:else}
			<!-- learn: the left page -->
			<section class="page left learn">
				<header class="opener" class:with-hero={s.hero}>
					<div>
						<p class="eyebrow">{companion.level} · {label(i)}</p>
						<h2 lang="de">{s.title}</h2>
						<p class="sub">{s.subtitle}</p>
						<p class="hook">{s.hook}</p>
					</div>
					{#if s.hero}
						<figure>
							<img src="/img/{s.hero.image}.webp" alt="" width="1024" height="768" />
							{#if s.hero.caption}<figcaption>{s.hero.caption}</figcaption>{/if}
						</figure>
					{/if}
				</header>
				<div class="flow">
					{#each s.learn as block, b (b)}<LearnBlock {block} />{/each}
				</div>
				{@render footer(spreadPage(i), `${s.title} · Learn`)}
			</section>

			<!-- practise: the right page -->
			<section class="page right practise">
				{@render practiseHead(s, `${label(i)} · Practise`)}
				<div class="flow">
					{#each s.practise as ex, e (e)}<ExerciseBlock {ex} n={e + 1} listen={qr[s.id]?.listen ?? null} />{/each}
				</div>
				{@render canDo(s)}
				{@render footer(spreadPage(i) + 1, `${s.title} · Practise`)}
			</section>
		{/if}
	{/each}

	{#if companion.overview}
		<!-- the grammar on one page -->
		<section class="page {side(overviewPage)} overview">
			<p class="eyebrow">{companion.level} · cut it out, stick it up</p>
			<h2>{companion.overview.title}</h2>
			<div class="flow tight">
				{#each companion.overview.blocks as block, b (b)}<LearnBlock {block} />{/each}
			</div>
			{@render footer(overviewPage, companion.overview.title)}
		</section>
	{/if}

	{#each dictPages as words, d (d)}
		<section class="page {side(dictionaryPage + d)} dictionary">
			{#if d === 0 && companion.dictionary}
				<p class="eyebrow">{companion.level}</p>
				<h2>{companion.dictionary.title}</h2>
				<p class="dict-note">{@html rich(companion.dictionary.note)}</p>
			{/if}
			<ol class="dict">
				{#each words as w (w.de)}
					{@const a = article(w.de)}
					<li>
						<img src="/img/{w.image}.webp" alt="" width="512" height="512" />
						<span class="de" lang="de">{#if a}<b class="art {a}">{a}</b> {w.de.slice(a.length + 1)}{:else}{w.de}{/if}</span>
						<span class="en">{w.en}</span>
					</li>
				{/each}
			</ol>
			{@render footer(dictionaryPage + d, companion.dictionary?.title)}
		</section>
	{/each}

	{#each answerPages as chunk, a (a)}
		<section class="page {side(answersPage + a)} answers">
			{#if a === 0}
				<p class="eyebrow">{companion.level}</p>
				<h2>Answers</h2>
			{/if}
			<div class="key">
				{#each chunk as i (i)}
					{@const s = spreads[i]}
					<section>
						<h3>
							<span class="tnum">{s.review ? '↻' : topicNo[i]}</span>
							<span lang="de">{s.title}</span>
							<small>p. {s.review ? spreadPage(i) : spreadPage(i) + 1}</small>
						</h3>
						{#each answerKey(s) as k (k.exercise)}
							<p>
								<b class="tnum">{k.exercise}</b>
								{#each k.answers as x, j (j)}{#if j}<span class="sep">&ensp;·&ensp;</span>{/if}<span class="ans" lang="de">{#if x.q}<span class="q">{x.q}</span>&nbsp;{/if}<strong>{x.a}</strong></span>{/each}
								{#if k.note}<em>{k.note}</em>{/if}
							</p>
						{/each}
					</section>
				{/each}
			</div>
			{#if a === answerPages.length - 1}
				<div class="credits">
					<p class="eyebrow">Pictures</p>
					{#each companion.credits as c (c.what)}<p>{c.what}: {c.source}. {c.licence}.</p>{/each}
				</div>
			{/if}
			{@render footer(answersPage + a, 'Answers')}
		</section>
	{/each}

	{#if notesPage}
		<section class="page {side(notesPage)} notes">
			<p class="eyebrow">{companion.level}</p>
			<h2>Notizen</h2>
			<div class="ruled"></div>
			{@render footer(notesPage)}
		</section>
	{/if}
</div>

<style>
	.companion {
		--serif: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		--sans: 'Inter Variable', Inter, ui-sans-serif, system-ui, sans-serif;
		--navy: #1f3a5f;
		--accent: #c9683b;
		--accent-tint: #fbefe8;
		--mustard: #c8932c;
		--mustard-tint: #fbf3df;
		--sage: #5f8064;
		--sage-tint: #eef3ee;
		--ink: #24262b;
		--muted: #5f5a52;
		--rule: #cfc8bb;
		display: grid;
		justify-content: center;
		gap: 8mm;
		padding: 8mm 0 16mm;
		color: var(--ink);
		font-family: var(--sans);
		-webkit-print-color-adjust: exact;
		print-color-adjust: exact;
	}

	/* A fixed A4 sheet. The binding side (left of a right-hand page) gets
	   the wider margin, so double-sided printing can be punched or bound. */
	.page {
		position: relative;
		box-sizing: border-box;
		display: flex;
		flex-direction: column;
		width: 210mm;
		height: 297mm;
		overflow: hidden;
		padding: 13mm 17mm 17mm 24mm;
		background: #fff;
		box-shadow:
			0 1px 2px rgb(0 0 0 / 0.06),
			0 8px 28px rgb(0 0 0 / 0.07);
	}

	.page.left {
		padding: 13mm 24mm 17mm 17mm;
	}

	.foot {
		position: absolute;
		bottom: 9mm;
		left: 24mm;
		right: 17mm;
		display: flex;
		justify-content: space-between;
		align-items: baseline;
		padding-top: 2mm;
		border-top: 0.25mm solid var(--rule);
		font-size: 7.5pt;
		color: var(--muted);
	}

	.foot .tnum {
		order: 2;
		font-size: 9pt;
		font-weight: 800;
		color: var(--navy);
	}

	.left .foot {
		left: 17mm;
		right: 24mm;
	}

	.left .foot .tnum {
		order: 0;
	}

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
		font-size: 26pt;
		line-height: 1.05;
		color: var(--navy);
	}

	.flow {
		display: flex;
		flex-direction: column;
		gap: 4.5mm;
	}

	/* -- cover --------------------------------------------------------------- */

	.cover {
		border-top: 8mm solid var(--accent);
		padding-top: 14mm;
	}

	.kicker {
		margin: 0;
		font-size: 9pt;
		font-weight: 800;
		letter-spacing: 0.12em;
		text-transform: uppercase;
		color: var(--navy);
	}

	.code {
		margin: 8mm 0 0;
		font-family: var(--serif);
		font-size: 110pt;
		font-weight: 800;
		line-height: 0.85;
		letter-spacing: -0.03em;
		color: var(--accent);
	}

	h1 {
		margin: 4mm 0 0;
		font-family: var(--serif);
		font-size: 36pt;
		line-height: 1.05;
		color: var(--navy);
	}

	/* A tall picture shrinks to the room left above the footer instead of running into it. */
	.cover-pic {
		width: 100%;
		height: auto;
		min-height: 0;
		object-fit: contain;
		margin: auto 0;
	}

	.cover-foot {
		display: flex;
		justify-content: space-between;
		align-items: baseline;
		gap: 6mm;
		padding-top: 3mm;
		border-top: 0.3mm solid var(--navy);
		font-size: 9pt;
		color: var(--muted);
	}

	.cover-foot p {
		margin: 0;
	}

	.site {
		font-weight: 800;
		color: var(--navy);
	}

	/* -- welcome ------------------------------------------------------------- */

	.welcome h2 {
		margin-bottom: 6mm;
	}

	.para {
		max-width: 140mm;
		margin: 0 0 4mm;
		font-size: 10.5pt;
		line-height: 1.6;
	}

	.anatomy {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 1mm;
		width: 110mm;
		margin: 6mm 0 0;
		padding: 3mm;
		border: 0.3mm solid var(--rule);
		border-radius: 2mm;
	}

	.mini {
		display: grid;
		align-content: start;
		gap: 2mm;
		height: 62mm;
		padding: 4mm;
		border: 0.3mm solid var(--navy);
		background: #fff;
	}

	.mini b {
		font-family: var(--serif);
		color: var(--navy);
	}

	.mini small {
		margin-top: auto;
		font-size: 7.5pt;
		color: var(--muted);
	}

	.mini .bar {
		height: 2.4mm;
		border-radius: 1mm;
		background: var(--rule);
	}

	.w60 {
		width: 60%;
	}
	.w80 {
		width: 80%;
	}
	.w90 {
		width: 90%;
	}

	.mini .grid {
		height: 12mm;
		background:
			linear-gradient(var(--navy) 0 0) 0 0 / 100% 0.3mm no-repeat,
			repeating-linear-gradient(90deg, transparent 0 7mm, var(--rule) 7mm 7.3mm);
		border: 0.3mm solid var(--rule);
	}

	.mini .lines {
		height: 12mm;
		background: repeating-linear-gradient(transparent 0 3.7mm, var(--ink) 3.7mm 4mm);
	}

	.mini .ticks {
		height: 8mm;
		border: 0.3mm dashed var(--sage);
	}

	.name {
		display: flex;
		gap: 3mm;
		align-items: baseline;
		margin: auto 0 0;
		font-weight: 700;
	}

	.name span {
		flex: 1;
		border-bottom: 0.3mm solid var(--ink);
	}

	/* -- contents ------------------------------------------------------------ */

	.contents ol {
		margin: 6mm 0 0;
		padding: 0;
		list-style: none;
	}

	.contents li {
		display: flex;
		align-items: baseline;
		gap: 4mm;
		padding: 1.9mm 0;
		border-bottom: 0.25mm solid var(--rule);
	}

	.contents .dense {
		margin-top: 4mm;
	}

	.contents .dense li {
		padding: 1.1mm 0;
	}

	.contents .denser li {
		padding: 0.5mm 0;
	}

	.contents .no {
		width: 7mm;
		font-family: var(--serif);
		font-size: 14pt;
		font-weight: 800;
		color: var(--accent);
	}

	.contents .review .no,
	.contents .back .no {
		font-family: var(--sans);
		font-size: 12pt;
	}

	.contents .t {
		flex: 1;
	}

	.contents .t b {
		font-family: var(--serif);
		font-size: 12.5pt;
		color: var(--navy);
	}

	.contents .review b {
		font-style: italic;
	}

	.contents .t small {
		margin-left: 2mm;
		font-size: 8.5pt;
		color: var(--muted);
	}

	.contents .planned {
		opacity: 0.45;
	}

	.contents .planned .pg {
		font-size: 8pt;
		font-weight: 500;
	}

	.contents .pg {
		font-weight: 800;
		color: var(--navy);
	}

	/* -- learn opener -------------------------------------------------------- */

	.opener {
		display: grid;
		gap: 6mm;
		align-items: center;
		margin-bottom: 5mm;
	}

	.opener.with-hero {
		grid-template-columns: 1fr 60mm;
	}

	.opener h2 {
		font-size: 34pt;
	}

	.sub {
		margin: 1mm 0 0;
		font-size: 10pt;
		font-weight: 700;
		color: var(--navy);
	}

	.hook {
		margin: 3mm 0 0;
		font-family: var(--serif);
		font-size: 12pt;
		font-style: italic;
		line-height: 1.4;
	}

	.opener figure {
		margin: 0;
	}

	.opener img {
		display: block;
		width: 100%;
		height: auto;
		max-height: 48mm;
		object-fit: contain;
	}

	.opener figcaption {
		margin-top: -2mm;
		font-size: 7.5pt;
		font-style: italic;
		text-align: center;
		color: var(--muted);
	}

	/* -- practise ------------------------------------------------------------ */

	.bar-head {
		display: flex;
		justify-content: space-between;
		align-items: flex-end;
		margin-bottom: 3.5mm;
		padding-bottom: 2mm;
		border-bottom: 0.6mm solid var(--navy);
	}

	.qr {
		display: flex;
		align-items: center;
		gap: 2mm;
		margin: 0;
	}

	.qr :global(svg) {
		width: 15mm;
		height: 15mm;
	}

	.qr figcaption {
		font-size: 7.5pt;
		font-weight: 700;
		line-height: 1.3;
		color: var(--navy);
	}

	.qr figcaption span {
		font-weight: 500;
		color: var(--muted);
	}

	.can-do {
		margin-top: auto;
		padding: 3mm 4mm;
		border: 0.3mm solid var(--sage);
		border-radius: 2mm;
	}

	.can-do p {
		margin: 0 0 1.5mm;
		font-size: 10pt;
		color: var(--navy);
	}

	.can-do small {
		margin-left: 1mm;
		font-size: 8pt;
		color: var(--muted);
	}

	.can-do ul {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 1.2mm 6mm;
		margin: 0;
		padding: 0;
		list-style: none;
		font-size: 9.5pt;
	}

	.can-do li {
		display: flex;
		align-items: center;
		gap: 2mm;
	}

	.can-do .box {
		flex: none;
		width: 3.4mm;
		height: 3.4mm;
		border: 0.35mm solid var(--sage);
		border-radius: 0.6mm;
	}

	/* -- review -------------------------------------------------------------- */

	.review-hook {
		margin: -1mm 0 4mm;
		font-family: var(--serif);
		font-size: 11pt;
		font-style: italic;
	}

	/* -- overview ------------------------------------------------------------ */

	.overview h2 {
		margin-bottom: 4mm;
	}

	.flow.tight {
		gap: 3.5mm;
	}

	/* -- picture dictionary -------------------------------------------------- */

	.dict-note {
		margin: 1mm 0 4mm;
		font-size: 9.5pt;
		color: var(--muted);
	}

	.dict {
		display: grid;
		grid-template-columns: repeat(4, minmax(0, 1fr));
		gap: 3mm;
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.dict li {
		display: grid;
		justify-items: center;
		padding: 2mm 1mm 2.4mm;
		border-radius: 2mm;
		background: #fbf5e4;
		text-align: center;
	}

	.dict img {
		width: 26mm;
		height: 26mm;
		object-fit: contain;
	}

	.dict .de {
		margin-top: 1mm;
		font-size: 9.5pt;
		font-weight: 700;
	}

	.dict .en {
		font-size: 8pt;
		color: var(--muted);
	}

	.art.der {
		color: #2b5d9b;
	}

	.art.die {
		color: #b5452b;
	}

	.art.das {
		color: #3d7a4a;
	}

	/* -- notes --------------------------------------------------------------- */

	.ruled {
		flex: 1;
		margin: 6mm 0 4mm;
		background: repeating-linear-gradient(transparent 0 9.7mm, var(--rule) 9.7mm 10mm);
	}

	/* -- answers ------------------------------------------------------------- */

	.key {
		margin-top: 6mm;
		columns: 2;
		column-gap: 8mm;
		font-size: 8.5pt;
		line-height: 1.5;
	}

	.key section {
		break-inside: avoid;
		margin-bottom: 4mm;
	}

	.key h3 {
		margin: 0 0 1mm;
		font-family: var(--serif);
		font-size: 11pt;
		color: var(--navy);
	}

	.key h3 small {
		font-family: var(--sans);
		font-size: 7.5pt;
		font-weight: 500;
		color: var(--muted);
	}

	.key p {
		margin: 0 0 1mm;
	}

	.key b {
		display: inline-block;
		width: 4mm;
		color: var(--accent);
	}

	.key em {
		color: var(--muted);
	}

	/* One answer: the prompt quiet, the answer bold, a dot between answers. */
	.sep {
		color: var(--muted);
	}

	.ans .q {
		color: var(--muted);
	}

	.ans strong {
		font-weight: 700;
		color: var(--ink);
	}

	.credits {
		margin-top: auto;
		font-size: 7.5pt;
		color: var(--muted);
	}

	.credits p {
		margin: 0.5mm 0 0;
	}

	/* -- print --------------------------------------------------------------- */

	@media print {
		.companion {
			display: block;
			padding: 0;
		}

		.page {
			box-shadow: none;
			break-after: page;
		}

		/* No blank sheet after the last page. */
		.page:last-child {
			break-after: auto;
		}

		:global(.skip-link) {
			display: none;
		}
	}

	@media screen and (max-width: 222mm) {
		/* A phone shows the sheets scaled down rather than reflowed: this
		   is a preview of paper. */
		.companion {
			zoom: 0.45;
		}
	}
</style>
