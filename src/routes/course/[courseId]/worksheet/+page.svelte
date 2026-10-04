<script lang="ts">
	import Seo from '$lib/components/Seo.svelte';
	// The printable exercise worksheet — the port of the Flutter PDF export
	// (lib/theme/exercise_sheet_pdf.dart), laid out in HTML and printed by the
	// browser. "Save as PDF" in the print dialog produces the same artefact the
	// Dart build shared, and the sheet costs nothing in the app bundle.
	//
	// Everything above the sheet is `no-print`: what the printer sees is the
	// header, the exercises, and the answers wherever the learner put them.
	import Icon from '$lib/icons/Icon.svelte';
	import { track } from '$lib/services/analytics';
	import { progress } from '$lib/state/progress.svelte';
	import { DEFAULT_GATING } from '$lib/domain/progress';
	import {
		buildWorksheet,
		countItems,
		MAX_SHEET_ITEMS,
		NO_HISTORY,
		type AnswerPlacement,
		type ExerciseScope,
		type ExerciseSection,
		type QuizHistory
	} from '$lib/domain/worksheet';
	import type { Quiz } from '$lib/content/types';
	import { workbookCards, workbookFile } from '$lib/domain/workbook';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();
	const course = $derived(data.course);

	// What tool/gen-workbooks.mjs wrote: the glob is empty until it has run,
	// and a level without a PDF still opens and prints from its page.
	const pdfs = Object.values(
		import.meta.glob<Record<string, { pages: number; bytes: number }>>('/static/workbooks/manifest.json', {
			eager: true,
			import: 'default'
		})
	)[0] ?? {};
	const cards = $derived(
		workbookCards(course).map((card) => {
			const file = workbookFile(course.id, card.level);
			return { ...card, pdf: pdfs[file] ? { href: `/workbooks/${file}`, ...pdfs[file] } : null };
		})
	);

	const SCOPES: { value: ExerciseScope; label: string; note: string }[] = [
		{ value: 'fullCourse', label: 'The whole course', note: 'Every printable exercise' },
		{ value: 'achieved', label: 'What I have finished', note: 'Revision of completed levels' },
		{ value: 'weakSpots', label: 'My weak spots', note: 'Ranked by what you get wrong' }
	];

	const SIZES: { value: number | null; label: string }[] = [
		{ value: 20, label: '20 exercises' },
		{ value: 50, label: '50 exercises' },
		{ value: 100, label: '100 exercises' },
		{ value: null, label: `Everything (max ${MAX_SHEET_ITEMS})` }
	];

	const PLACEMENTS: { value: AnswerPlacement; label: string; note: string }[] = [
		{ value: 'side', label: 'Fold-away column', note: 'Beside each exercise; fold to hide' },
		{ value: 'pageEnd', label: 'After each section', note: 'A small key per exercise group' },
		{ value: 'documentEnd', label: 'Answer key at the end', note: 'One key on the last page' }
	];

	let scope = $state<ExerciseScope>('fullCourse');
	let size = $state<number | null>(20);
	let placement = $state<AnswerPlacement>('side');
	let sections = $state<ExerciseSection[] | null>(null);
	let building = $state(false);

	/**
	 * The learner's per-quiz history, read once per build. `progress` must be
	 * loaded first or every quiz would read as unfinished and the "what I have
	 * finished" scope would come back empty.
	 */
	async function histories(): Promise<Map<string, QuizHistory>> {
		if (!progress.loaded) await progress.load(course.gating ?? DEFAULT_GATING);
		const map = new Map<string, QuizHistory>();
		for (const quiz of course.quizzes) {
			await progress.statsFor(quiz.storageKeyPrefix);
			const history = await progress.historyFor(quiz.storageKeyPrefix);
			map.set(quiz.id, {
				...history,
				done: progress.isCompleted(quiz.type, quiz.id, quiz.storageKeyPrefix)
			});
		}
		return map;
	}

	async function build() {
		building = true;
		const map = await histories();
		const lookup = (quiz: Quiz) => map.get(quiz.id) ?? NO_HISTORY;
		sections = buildWorksheet(course, lookup, { scope, maxItems: size });
		building = false;
		track('worksheet_built', {
			course: course.id,
			scope,
			size: size ?? 0,
			placement,
			exercises: countItems(sections)
		});
	}

	function print() {
		track('worksheet_print', { course: course.id, scope, placement });
		window.print();
	}

	const total = $derived(sections ? countItems(sections) : 0);

	/** Running exercise numbers, so the answer keys can refer to them. */
	const numbering = $derived.by(() => {
		const starts: number[] = [];
		let next = 1;
		for (const section of sections ?? []) {
			starts.push(next);
			next += section.items.length;
		}
		return starts;
	});

	/**
	 * A big-text passage split on its `{{n}}` markers, so each gap can print as
	 * a numbered writing line inside the text rather than as a literal marker.
	 */
	function inlineParts(passage: string): { text: string; blank: number | null }[] {
		const parts: { text: string; blank: number | null }[] = [];
		const pattern = /\{\{(\d+)\}\}/g;
		let last = 0;
		let match: RegExpExecArray | null;
		while ((match = pattern.exec(passage)) !== null) {
			parts.push({ text: passage.slice(last, match.index), blank: Number(match[1]) });
			last = match.index + match[0].length;
		}
		parts.push({ text: passage.slice(last), blank: null });
		return parts;
	}

	const scopeLabel = $derived(SCOPES.find((s) => s.value === scope)?.label ?? '');
	const today = new Date().toLocaleDateString(undefined, {
		year: 'numeric',
		month: 'long',
		day: 'numeric'
	});
</script>

<Seo title="Workbooks — {course.name}" description="Printable German workbooks, one per level, with rules, words, pictures and exercises." path="/course/{course.id}/worksheet" noindex />

<main class="page-wide sheet-page">
	<div class="no-print">
		<a class="back-link" href="/course/{course.id}">
			<Icon name="arrowLeft" size="1em" /> {course.name}
		</a>

		<header class="head">
			<h1>Printable workbooks</h1>
			<p class="lede">
				One workbook per level: every unit's rules with examples, the words with
				pictures, check-yourself questions and written practice — answers upside
				down at the foot of each unit. Download the PDF, or open it to print.
			</p>
		</header>

		<ol class="books">
			{#each cards as card (card.level)}
				<li>
					<a class="book" href="/course/{course.id}/workbook/{card.level}">
						{#if card.cover}<img src="/img/{card.cover}.webp" alt="" width="1024" height="768" loading="lazy" />{/if}
						<span class="code">{card.level}</span>
						<span class="name">{card.title}</span>
						<small class="tnum">{card.units} units{#if card.pdf}{' · '}{card.pdf.pages} pages{/if}</small>
					</a>
					{#if card.pdf}
						<a
							class="pdf"
							href={card.pdf.href}
							download="German {card.level} workbook.pdf"
							aria-label="Download the {card.level} workbook as PDF"
							onclick={() => track('workbook_download', { level: card.level, from: 'list' })}
						>
							<Icon name="download" size="1em" /> PDF
						</a>
					{/if}
				</li>
			{/each}
		</ol>

		<header class="head custom">
			<h2>Or build your own sheet</h2>
			<p class="lede">
				Pick exercises from across the course — everything, what you have
				finished, or your weak spots — and print them with the answers where you
				want them.
			</p>
		</header>

		<form class="options" onsubmit={(event) => { event.preventDefault(); build(); }}>
			<fieldset>
				<legend>What to practise</legend>
				{#each SCOPES as option (option.value)}
					<label class="choice">
						<input type="radio" bind:group={scope} value={option.value} />
						<span><strong>{option.label}</strong><small>{option.note}</small></span>
					</label>
				{/each}
			</fieldset>

			<fieldset>
				<legend>How long</legend>
				{#each SIZES as option (option.label)}
					<label class="choice">
						<input type="radio" bind:group={size} value={option.value} />
						<span><strong>{option.label}</strong></span>
					</label>
				{/each}
			</fieldset>

			<fieldset>
				<legend>Where the answers go</legend>
				{#each PLACEMENTS as option (option.value)}
					<label class="choice">
						<input type="radio" bind:group={placement} value={option.value} />
						<span><strong>{option.label}</strong><small>{option.note}</small></span>
					</label>
				{/each}
			</fieldset>

			<div class="actions">
				<button type="submit" class="primary" disabled={building}>
					{building ? 'Building…' : sections ? 'Rebuild sheet' : 'Build sheet'}
				</button>
				{#if sections && total > 0}
					<button type="button" onclick={print}>
						<Icon name="printer" size="1.1em" /> Print
					</button>
					<span class="count tnum">{total} exercises</span>
				{/if}
			</div>
		</form>

		{#if sections && total === 0}
			<p class="empty">
				{scope === 'achieved'
					? 'Nothing is finished yet — do an exercise or two, then come back.'
					: scope === 'weakSpots'
						? 'No answers recorded yet, so there are no weak spots to drill.'
						: 'This course has no printable exercises.'}
			</p>
		{/if}
	</div>

	{#if sections && total > 0}
		<article class="sheet" class:folded={placement === 'side'}>
			<header class="sheet-head">
				<div>
					<h2>{course.name}</h2>
					<p>{scopeLabel} · {total} exercises</p>
				</div>
				<p class="name-line">Name ______________________ &nbsp; {today}</p>
			</header>

			{#each sections as section, s (section.quizTitle + s)}
				<section class="block">
					<h3>{#if section.level}<span class="lvl tnum">{section.level}</span>{/if}{section.quizTitle}</h3>

					<!-- The rules travel with the questions: on paper there is no
					     panel to open, so a sheet without them can't be worked
					     away from the app. -->
					{#if section.help?.hook || section.help?.intro || section.help?.tips?.length || section.table}
						<!-- The lesson's cheat sheet, not the whole lesson: a picked
						     exercise or two must not sit under a page of rules. The
						     level workbooks carry the full lessons. -->
						<div class="help">
							<p class="help-intro">{section.help?.hook ?? section.help?.intro}</p>
							{#if section.help?.tips?.length}
								<ul class="help-points">
									{#each section.help.tips as tip, t (t)}
										<li>{tip.title ?? tip.text}</li>
									{/each}
								</ul>
							{/if}
							{#if section.help?.remember?.length}
								<p class="help-tip"><strong>Remember:</strong> {section.help.remember.join(' · ')}</p>
							{/if}
							{#if section.table}
								<table class="help-table">
									<thead>
										<tr>
											<th>{section.table.subjectHeader}</th>
											{#each section.table.columns as column, c (c)}
												<th>{column}</th>
											{/each}
										</tr>
									</thead>
									<tbody>
										{#each section.table.rows as row, r (r)}
											<tr>
												<th>
													{#if row.article}{row.article}{' '}{/if}{row.subject}{#if row.english}<small>{' · '}{row.english}</small>{/if}
												</th>
												{#each row.cells as cell, c (c)}
													<td>{cell}</td>
												{/each}
											</tr>
										{/each}
									</tbody>
								</table>
							{/if}
						</div>
					{/if}

					{#if section.kind === 'reading' && section.passage}
						<div class="passage">{section.passage}</div>
					{/if}

					{#if section.kind === 'inlineCloze' && section.passage}
						<div class="passage">
							{#each inlineParts(section.passage) as part, p (p)}{part.text}{#if part.blank !== null}<span
									class="inline-gap"><sup class="tnum">{numbering[s] + part.blank}</sup><span class="gap"></span></span
								>{/if}{/each}
						</div>
					{/if}

					<ol class="items" class:hints={section.kind === 'inlineCloze'} start={numbering[s]}>
						{#each section.items as item, i (i)}
							<li>
								<div class="prompt">
									{#if item.secondary}<span class="secondary">{item.secondary}</span>{/if}
									<span class="text" lang={section.kind === 'reading' ? undefined : 'de'}
										>{#each (item.prompt || `Blank ${i + 1}`).split('____') as piece, g (g)}{#if g > 0}<span
													class="gap"
												></span>{/if}{piece}{/each}</span
									>
									{#if item.options.length > 0}
										<span class="options-line">
											{#each item.options as option, o (o)}
												<span class="option"
													><span class="box" aria-hidden="true"></span>{String.fromCharCode(0x61 + o)}) {option}</span
												>
											{/each}
										</span>
									{:else if section.kind !== 'inlineCloze' && !item.prompt.includes('____')}
										<span class="write-line"></span>
									{/if}
								</div>
								{#if placement === 'side'}
									<div class="side-answer">
										<span class="answer-text">{item.answer}</span>
										{#if item.categoryLabel}<small>{item.categoryLabel}</small>{/if}
									</div>
								{/if}
							</li>
						{/each}
					</ol>

					{#if placement === 'pageEnd'}
						<div class="key">
							<p class="key-title">Answers</p>
							<ul>
								{#each section.items as item, i (i)}
									<li><span class="tnum">{numbering[s] + i}.</span> {item.answer}</li>
								{/each}
							</ul>
						</div>
					{/if}
				</section>
			{/each}

			{#if placement === 'documentEnd'}
				<section class="block answer-key">
					<h3>Answer key</h3>
					<ul class="key-grid">
						{#each sections as section, s (section.quizTitle + s)}
							{#each section.items as item, i (i)}
								<li><span class="tnum">{numbering[s] + i}.</span> {item.answer}</li>
							{/each}
						{/each}
					</ul>
				</section>
			{/if}
		</article>
	{/if}
</main>

<style>
	.head {
		margin-bottom: 1.5rem;
	}

	.head.custom {
		margin-top: 3rem;
		padding-top: 2rem;
		border-top: 1px solid var(--line);
	}

	.head.custom h2 {
		margin: 0 0 0.4rem;
		color: var(--heading);
	}

	/* -- level workbooks: a shelf of covers -------------------------------- */

	.books {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(11.5rem, 1fr));
		gap: 1rem;
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.books li {
		position: relative;
	}

	.book {
		display: grid;
		gap: 0.15rem;
		height: 100%;
		box-sizing: border-box;
		padding: 0 0 3.3rem;
		overflow: hidden;
		border: 1px solid var(--line);
		border-top: 5px solid var(--accent);
		border-radius: var(--radius-sm);
		background: var(--surface);
		color: var(--ink);
		text-decoration: none;
		transition:
			transform var(--fast) var(--ease-out),
			box-shadow var(--fast) var(--ease-out);
	}

	.book:hover {
		transform: translateY(-3px);
		box-shadow: 0 10px 24px rgb(0 0 0 / 0.08);
	}

	.book img {
		width: 100%;
		height: auto;
		aspect-ratio: 4 / 3;
		object-fit: cover;
		margin-bottom: 0.5rem;
		background: #fbf5e4;
	}

	.book .code,
	.book .name,
	.book small {
		padding: 0 0.9rem;
	}

	.book .code {
		font-family: 'Source Serif 4 Variable', serif;
		font-size: 1.9rem;
		font-weight: 800;
		line-height: 1;
		color: var(--accent-ink);
	}

	.book .name {
		font-family: 'Source Serif 4 Variable', serif;
		font-weight: 700;
		color: var(--heading);
	}

	.book small {
		color: var(--ink-muted);
		font-size: var(--step--1);
	}

	.pdf {
		position: absolute;
		left: 0.9rem;
		bottom: 0.8rem;
		display: inline-flex;
		align-items: center;
		gap: 0.3rem;
		padding: 0.3rem 0.65rem;
		border-radius: 999px;
		background: var(--navy);
		color: #fff;
		font-size: var(--step--1);
		font-weight: 700;
		text-decoration: none;
	}

	.options {
		display: grid;
		gap: 1.25rem;
		grid-template-columns: repeat(auto-fit, minmax(15rem, 1fr));
		margin-bottom: 1.5rem;
	}

	fieldset {
		border: 1px solid var(--line);
		border-radius: var(--radius-sm);
		padding: 0.75rem 1rem 1rem;
		margin: 0;
	}

	legend {
		font-weight: 650;
		font-size: var(--step--1);
		color: var(--heading);
		padding: 0 0.35rem;
	}

	.choice {
		display: flex;
		gap: 0.6rem;
		align-items: flex-start;
		padding: 0.35rem 0;
		cursor: pointer;
	}

	.choice small {
		display: block;
		color: var(--ink-muted);
		font-size: var(--step--1);
	}

	.actions {
		grid-column: 1 / -1;
		display: flex;
		align-items: center;
		gap: 0.75rem;
		flex-wrap: wrap;
	}

	button {
		font: inherit;
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		padding: 0.6rem 1.1rem;
		border-radius: var(--radius-sm);
		border: 1px solid var(--line-strong);
		background: var(--surface);
		color: var(--ink);
		cursor: pointer;
	}

	button.primary {
		background: var(--accent-ink);
		border-color: var(--accent);
		color: #fff;
		font-weight: 650;
	}

	button[disabled] {
		opacity: 0.6;
		cursor: progress;
	}

	.count,
	.empty {
		color: var(--ink-muted);
	}

	/* ── The sheet itself ───────────────────────────────────────────────── */

	.sheet {
		--serif: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		--cream: #fbf5e4;
		max-width: 210mm;
		margin: 0 auto;
		background: var(--surface);
		border-top: 6px solid var(--accent);
		border-radius: 4px;
		padding: 13mm;
		font-size: 10pt;
		box-shadow: 0 8px 28px rgb(0 0 0 / 0.07);
		-webkit-print-color-adjust: exact;
		print-color-adjust: exact;
	}

	.sheet h2,
	.block h3 {
		font-family: var(--serif);
	}

	.text[lang='de'],
	.passage {
		font-family: var(--serif);
	}

	.text[lang='de'] {
		font-size: 11pt;
	}

	.gap {
		display: inline-block;
		width: 5em;
		height: 0.95em;
		margin: 0 0.15em;
		border-bottom: 1px solid var(--ink);
	}

	.inline-gap sup {
		font-size: 7pt;
		font-weight: 800;
		color: var(--accent-ink);
	}

	.box {
		display: inline-block;
		width: 3mm;
		height: 3mm;
		margin-right: 1.2mm;
		border: 1px solid var(--ink);
		border-radius: 0.6mm;
		vertical-align: -0.3mm;
	}

	/* A text's gap hints are a key to the passage, not exercises of their own. */
	.items.hints {
		display: flex;
		flex-wrap: wrap;
		gap: 0.2rem 1.6rem;
		font-size: 0.9em;
	}

	.items.hints li {
		padding: 0;
	}

	.items li::marker {
		font-weight: 800;
		color: var(--navy);
	}

	.sheet-head {
		display: flex;
		justify-content: space-between;
		align-items: baseline;
		gap: 1rem;
		flex-wrap: wrap;
		border-bottom: 1.5px solid var(--line-strong);
		padding-bottom: 0.6rem;
		margin-bottom: 1.25rem;
	}

	.sheet-head h2 {
		margin: 0;
		font-size: var(--step-1);
	}

	.sheet-head p {
		margin: 0.15rem 0 0;
		color: var(--ink-muted);
		font-size: var(--step--1);
	}

	.block {
		margin-bottom: 1.5rem;
		/* A section header must not be stranded at the foot of a page. */
		break-inside: auto;
	}

	.block h3 {
		font-size: 14pt;
		color: var(--heading);
		margin: 0 0 0.6rem;
		padding-bottom: 1.5mm;
		border-bottom: 0.4mm solid var(--navy);
		break-after: avoid;
	}

	.block h3 .lvl {
		margin-right: 0.6em;
		color: var(--accent-ink);
		font-family: Inter, system-ui, sans-serif;
		font-size: 7.5pt;
		font-weight: 800;
		letter-spacing: 0.08em;
		vertical-align: 0.2em;
	}

	.passage {
		background: var(--cream);
		border-radius: 2.5mm;
		padding: 0.75rem 0.9rem;
		margin-bottom: 0.9rem;
		white-space: pre-wrap;
		line-height: 1.75;
	}

	.inline-gap {
		font-variant-numeric: tabular-nums;
		white-space: nowrap;
	}

	.items {
		margin: 0;
		padding-left: 1.6rem;
	}

	.items li {
		break-inside: avoid;
		padding: 0.35rem 0;
	}

	/* The fold: the exercise lives left of it, its answer right of it. */
	.folded .items li {
		display: grid;
		grid-template-columns: 78% 1fr;
		gap: 0.75rem;
		border-right: 0;
	}

	.folded .side-answer {
		border-left: 1px dashed var(--line-strong);
		padding-left: 0.7rem;
		color: var(--ink-muted);
		font-size: 0.9em;
	}

	.side-answer .answer-text {
		color: var(--heading);
	}

	.side-answer small {
		display: block;
		font-size: 0.75em;
		color: var(--ink-muted);
	}

	.secondary {
		display: block;
		color: var(--ink-muted);
		font-size: 0.85em;
	}

	.options-line {
		display: flex;
		flex-wrap: wrap;
		gap: 0.25rem 1.1rem;
		margin-top: 0.2rem;
		font-size: 0.92em;
	}

	/* The handwriting line the exercise is answered on. */
	.write-line {
		display: block;
		border-bottom: 1px solid var(--line-strong);
		height: 1.15rem;
		margin-top: 0.15rem;
	}

	.key {
		border: 1px solid var(--line);
		border-radius: var(--radius-sm);
		padding: 0.55rem 0.8rem;
		margin-top: 0.5rem;
		font-size: 0.85em;
		color: var(--ink-muted);
		break-inside: avoid;
	}

	.key-title {
		margin: 0 0 0.25rem;
		font-weight: 650;
		text-transform: uppercase;
		letter-spacing: 0.06em;
		font-size: 0.8em;
	}

	.key ul,
	.key-grid {
		list-style: none;
		margin: 0;
		padding: 0;
		columns: 3;
		column-gap: 1.5rem;
	}

	.key-grid li,
	.key li {
		break-inside: avoid;
	}

	.answer-key {
		break-before: page;
	}

	@media (max-width: 640px) {
		.folded .items li {
			grid-template-columns: 1fr;
		}

		.key ul,
		.key-grid {
			columns: 2;
		}
	}

	/* ── Print ──────────────────────────────────────────────────────────── */

	@media print {
		.sheet {
			border: 0;
			border-radius: 0;
			padding: 0;
			font-size: 10.5pt;
		}

		.block {
			break-inside: auto;
		}
	}

	/* The Help Memory on paper. Printed in grey on a tinted ground so it reads
	   as reference beside the exercises rather than as more questions — and
	   never colour-coded, because most sheets come off a mono printer. */
	.help {
		margin: 0 0 0.9rem;
		padding: 3mm 4mm;
		border: 0.35mm solid var(--navy);
		border-radius: 2.5mm;
		font-size: 9pt;
		break-inside: avoid;
	}

	.help-intro {
		margin: 0;
		font-family: var(--serif);
		font-size: 11pt;
		font-weight: 700;
		color: var(--navy);
	}

	.help-points {
		margin: 0.35rem 0 0;
		padding-left: 1.1rem;
	}

	.help-points li::marker {
		color: var(--accent-ink);
	}

	.help-tip {
		margin: 0.35rem 0 0;
		color: var(--ink-muted);
	}

	.help-table {
		margin-top: 0.6rem;
		border-collapse: collapse;
		width: 100%;
		font-size: 0.76rem;
	}

	.help-table th,
	.help-table td {
		padding: 0.18rem 0.45rem;
		text-align: left;
		border: 1px solid var(--line);
	}

	.help-table thead th {
		font-weight: 700;
	}

	.help-table small {
		font-weight: 400;
		color: var(--ink-muted);
	}

	@media print {
		.sheet {
			max-width: none;
			padding: 0;
			box-shadow: none;
		}
	}
</style>
