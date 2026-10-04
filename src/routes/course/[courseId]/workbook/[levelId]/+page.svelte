<script lang="ts">
	// A level's workbook (see domain/workbook): a cover, one unit per exercise,
	// a page of words in pictures. On screen it reads as a stack of paper; in
	// print, every unit starts a new A4 page. The same page is what
	// tool/gen-workbooks.mjs prints to the PDF the Download button serves.
	import Seo from '$lib/components/Seo.svelte';
	import WorkbookUnit from '$lib/components/workbook/WorkbookUnit.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { track } from '$lib/services/analytics';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();
	const wb = $derived(data.workbook);

	const footer = $derived(`${wb.courseName} · ${wb.level} ${wb.title}`);
	// Running footer and page numbers, set in the page margins by the print
	// engine. A CSS string can't hold a raw quote or backslash.
	const pageStyle = $derived(
		`<style>@page { size: A4; margin: 13mm 13mm 15mm; @bottom-left { content: "${footer.replace(/["\\]/g, '')}"; font: 600 7pt Inter, sans-serif; color: #6e6458; } @bottom-right { content: counter(page); font: 800 8pt Inter, sans-serif; color: #1f3a5f; } } @page :first { @bottom-left { content: none; } @bottom-right { content: none; } }</style>`
	);


	function print() {
		track('workbook_print', { level: wb.level });
		window.print();
	}

	const megabytes = (bytes: number) => `${(bytes / 1_000_000).toFixed(1)} MB`;
</script>

<svelte:head>
	{@html pageStyle}
</svelte:head>

<Seo
	title="{wb.level} workbook — {wb.title}"
	description="A printable German workbook for {wb.level}: the rules, the words and the exercises of every unit, with answers."
	path="/course/{wb.courseId}/workbook/{wb.level}"
	noindex
/>

<div class="toolbar no-print">
	<div class="bar">
		<a class="back" href="/course/{wb.courseId}/worksheet"><Icon name="arrowLeft" size="1em" /> Workbooks</a>
		<nav class="levels" aria-label="Other levels">
			{#if data.previous}<a href="/course/{wb.courseId}/workbook/{data.previous}" aria-label="Previous level"><Icon name="arrowLeft" size="0.9em" /> {data.previous}</a>{/if}
			<strong>{wb.level}</strong>
			{#if data.next}<a href="/course/{wb.courseId}/workbook/{data.next}" aria-label="Next level">{data.next} <Icon name="arrowRight" size="0.9em" /></a>{/if}
		</nav>
		<div class="actions">
			<button type="button" onclick={print}><Icon name="printer" size="1.05em" /> Print</button>
			{#if data.pdf}
				<a
					class="primary"
					href={data.pdf.href}
					download="German {wb.level} workbook.pdf"
					onclick={() => track('workbook_download', { level: wb.level })}
				>
					<Icon name="download" size="1.05em" /> Download PDF
					<small>{data.pdf.pages} pages · {megabytes(data.pdf.bytes)}</small>
				</a>
			{/if}
		</div>
	</div>
</div>

<main class="booklet">
	<!-- The cover: the level, what it is called, what is in it. -->
	<section class="sheet cover">
		<p class="kicker">{wb.courseName} · Workbook</p>
		<p class="code">{wb.level}</p>
		<h1>{wb.title}</h1>
		{#if wb.cover}
			<img class="cover-pic" src="/img/{wb.cover}.webp" alt="" width="1024" height="768" />
		{/if}

		<div class="contents">
			<p class="eyebrow">In this workbook</p>
			<ol>
				{#each wb.units as unit (unit.n)}
					<li><span class="tnum">{unit.n}</span> <span class="t">{unit.title}</span> <small>{unit.kindLabel}</small></li>
				{/each}
				{#if wb.pictures.length}
					<li><span class="tnum">★</span> <span class="t">Words in pictures</span> <small>Vocabulary</small></li>
				{/if}
			</ol>
		</div>

		<div class="how">
			<p><strong>How it works.</strong> Every unit runs the same way: <b>learn</b> the rules from the examples, look over the <b>words</b>, tick the boxes in <b>check yourself</b>, then <b>practise</b> in writing. The answers sit upside down at the foot of each unit — fold the page or cover them until you are done.</p>
			<p class="name">Name <span></span> Started <span></span></p>
		</div>
	</section>

	{#each wb.units as unit (unit.n)}
		<div class="sheet">
			<WorkbookUnit {unit} />
		</div>
	{/each}

	{#if wb.pictures.length}
		<section class="sheet pictures">
			<header>
				<p class="eyebrow">{wb.level} · Vocabulary</p>
				<h2>Words in pictures</h2>
				<p class="lede">What is it? Write each word with its article: <b>der</b>, <b>die</b> or <b>das</b>.</p>
			</header>
			<ol class="pic-grid">
				{#each wb.pictures as pic (pic.n)}
					<li>
						<span class="n tnum">{pic.n}</span>
						<img src="/img/{pic.image}.webp" alt="" width="512" height="512" />
						{#if pic.en}<small class="hint">{pic.en}</small>{/if}
						<span class="line"></span>
					</li>
				{/each}
			</ol>
			<footer class="answers">
				<p>
					<strong>Answers</strong>
					{#each wb.pictures as pic (pic.n)}<span class="a"><span class="tnum">{pic.n}</span>&nbsp;{pic.article ? `${pic.article} ` : ''}{pic.de}</span>{/each}
				</p>
			</footer>
		</section>
	{/if}
</main>

<style>
	:global(body) {
		background: var(--paper-mid);
	}

	/* -- toolbar ----------------------------------------------------------- */

	.toolbar {
		position: sticky;
		top: 0;
		z-index: 5;
		background: color-mix(in srgb, var(--paper-mid) 88%, transparent);
		backdrop-filter: blur(8px);
		border-bottom: 1px solid var(--line);
	}

	.bar {
		display: flex;
		align-items: center;
		gap: 0.75rem 1.25rem;
		flex-wrap: wrap;
		max-width: 210mm;
		margin: 0 auto;
		padding: 0.7rem 1rem;
	}

	.back,
	.levels a {
		display: inline-flex;
		align-items: center;
		gap: 0.3rem;
		color: var(--ink-muted);
		font-weight: 600;
		text-decoration: none;
	}

	.levels {
		display: flex;
		align-items: center;
		gap: 0.9rem;
	}

	.levels strong {
		font-family: 'Source Serif 4 Variable', serif;
		font-size: 1.2rem;
		color: var(--navy);
	}

	.actions {
		display: flex;
		gap: 0.6rem;
		margin-left: auto;
	}

	.actions button,
	.actions a {
		display: inline-flex;
		align-items: center;
		gap: 0.45rem;
		padding: 0.6rem 1.05rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		background: var(--surface);
		color: var(--ink);
		font: inherit;
		font-weight: 700;
		text-decoration: none;
		cursor: pointer;
	}

	.actions .primary {
		border-color: var(--navy);
		background: var(--navy);
		color: #fff;
	}

	.actions button,
	.actions a {
		white-space: nowrap;
	}

	.actions small {
		font-weight: 500;
		opacity: 0.75;
	}

	@media (max-width: 34rem) {
		.actions {
			width: 100%;
		}
		.actions .primary {
			flex: 1;
			justify-content: center;
		}
		.actions small {
			display: none;
		}
		/* Two columns of contents don't fit a phone. */
		.contents ol {
			columns: 1;
		}
	}

	/* -- paper ------------------------------------------------------------- */

	.booklet {
		--serif: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		--cream: #fbf5e4;
		display: grid;
		grid-template-columns: minmax(0, 210mm);
		gap: 8mm;
		justify-content: center;
		padding: 8mm 0 16mm;
		-webkit-print-color-adjust: exact;
		print-color-adjust: exact;
	}

	.sheet {
		box-sizing: border-box;
		width: 100%;
		padding: 13mm 13mm 15mm;
		background: #fff;
		box-shadow:
			0 1px 2px rgb(0 0 0 / 0.06),
			0 8px 28px rgb(0 0 0 / 0.07);
	}

	.eyebrow {
		margin: 0;
		font-size: 7.2pt;
		font-weight: 800;
		letter-spacing: 0.09em;
		text-transform: uppercase;
		color: var(--accent);
	}

	/* -- cover ------------------------------------------------------------- */

	.cover {
		display: flex;
		flex-direction: column;
		min-height: 297mm;
		border-top: 6mm solid var(--accent);
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
		margin: 6mm 0 0;
		font-family: var(--serif);
		font-size: 92pt;
		font-weight: 800;
		line-height: 0.9;
		letter-spacing: -0.03em;
		color: var(--accent);
	}

	h1 {
		margin: 3mm 0 0;
		font-family: var(--serif);
		font-size: 30pt;
		line-height: 1.05;
		color: var(--navy);
	}

	.cover-pic {
		flex: 1 1 0;
		min-height: 34mm;
		width: 100%;
		max-height: 92mm;
		object-fit: contain;
		margin: 7mm 0 4mm;
		border-radius: 4mm;
		background: var(--cream);
	}

	.contents ol {
		columns: 2;
		column-gap: 8mm;
		margin: 2mm 0 0;
		padding: 0;
		list-style: none;
		font-size: 9pt;
	}

	.contents li {
		display: flex;
		align-items: baseline;
		gap: 2mm;
		padding: 0.9mm 0;
		border-bottom: 0.2mm solid var(--line);
		break-inside: avoid;
	}

	.contents .tnum {
		flex: none;
		width: 5mm;
		font-weight: 800;
		color: var(--accent);
	}

	.contents .t {
		min-width: 0;
		overflow-wrap: break-word;
		font-family: var(--serif);
		font-weight: 650;
		color: var(--navy);
	}

	.contents small {
		margin-left: auto;
		flex: none;
		font-size: 7pt;
		color: var(--ink-muted);
	}

	.how {
		margin-top: auto;
		padding-top: 6mm;
		font-size: 9pt;
		line-height: 1.5;
		color: var(--ink-muted);
	}

	.how p {
		margin: 0;
	}

	.how b,
	.how strong {
		color: var(--ink);
	}

	.name {
		display: flex;
		align-items: baseline;
		gap: 2mm;
		margin-top: 5mm !important;
		font-weight: 700;
		color: var(--ink) !important;
	}

	.name span {
		flex: 1;
		border-bottom: 0.3mm solid var(--ink);
	}

	.name span:first-child {
		flex: 2;
	}

	/* -- words in pictures ------------------------------------------------- */

	.pictures header {
		padding-top: 4mm;
		border-top: 2.2mm solid var(--accent);
	}

	.pictures h2 {
		margin: 1mm 0 0;
		font-family: var(--serif);
		font-size: 22pt;
		color: var(--navy);
	}

	.lede {
		margin: 1mm 0 0;
		color: var(--ink-muted);
	}

	.pic-grid {
		display: grid;
		grid-template-columns: repeat(4, minmax(0, 1fr));
		gap: 4mm 4mm;
		margin: 5mm 0 0;
		padding: 0;
		list-style: none;
	}

	.pic-grid li {
		position: relative;
		display: grid;
		gap: 1.5mm;
		padding: 2mm 2mm 3mm;
		border-radius: 3mm;
		background: var(--cream);
		break-inside: avoid;
	}

	.pic-grid img {
		width: 62%;
		height: auto;
		justify-self: center;
	}

	.pic-grid .n {
		position: absolute;
		top: 2mm;
		left: 2mm;
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 5.4mm;
		height: 5.4mm;
		border-radius: 50%;
		background: var(--navy);
		color: #fff;
		font-size: 7.5pt;
		font-weight: 800;
	}

	.hint {
		min-height: 2.4em;
		line-height: 1.2;
		text-align: center;
		font-size: 7.5pt;
		color: var(--ink-muted);
	}

	.line {
		height: 7mm;
		margin: 0 1.5mm;
		border-bottom: 0.35mm solid var(--ink);
	}

	.answers {
		margin-top: 6mm;
		padding-top: 2mm;
		border-top: 0.25mm dashed var(--line-strong);
	}

	.answers p {
		margin: 0;
		transform: rotate(180deg);
		font-size: 7.6pt;
		line-height: 1.6;
		color: var(--ink-muted);
	}

	.answers strong {
		margin-right: 2mm;
		color: var(--navy);
	}

	.a {
		display: inline-block;
		margin-right: 3mm;
	}

	.a .tnum {
		font-weight: 800;
		color: var(--ink);
	}

	/* -- print ------------------------------------------------------------- */

	@media print {
		:global(body) {
			background: #fff;
		}

		.booklet {
			display: block;
			padding: 0;
		}

		.sheet {
			width: auto;
			padding: 0;
			box-shadow: none;
		}

		/* Units run on, a clear gap and the opener's bar between them, so a
		   short unit doesn't cost a half-empty page. */
		.sheet + .sheet {
			margin-top: 12mm;
		}

		/* The cover is the first page exactly: 297mm less the 28mm margins. */
		.cover {
			box-sizing: border-box;
			height: 268mm;
			min-height: 0;
			overflow: hidden;
			break-after: page;
		}

		.pictures {
			break-before: page;
			margin-top: 0 !important;
		}
	}

	@media (max-width: 40rem) {
		.sheet {
			padding: 8mm 5mm;
		}
		.code {
			font-size: 64pt;
		}
		.contents ol {
			columns: 1;
		}
		.pic-grid {
			grid-template-columns: repeat(2, minmax(0, 1fr));
		}
	}
</style>
