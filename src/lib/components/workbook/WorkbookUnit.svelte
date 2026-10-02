<script lang="ts">
	// One unit of a level workbook, on paper: the lesson (the idea, the rules
	// with their highlighted examples, the words, the exchange), then the
	// checks and the practice, with the answers upside down at the foot — so
	// the page can be worked through without the app and checked without
	// peeking by accident. The same steps, in the same order, as Lesson.svelte.
	import { GENDER_COLORS } from '$lib/domain/gender';
	import { splitFocus } from '$lib/domain/lesson';
	import type { WorkbookUnit, WorkbookWord } from '$lib/domain/workbook';

	let { unit }: { unit: WorkbookUnit } = $props();

	const KIND_LABEL: Record<string, string> = {
		rule: 'Rule',
		warning: 'Watch out',
		mnemonic: 'Memory trick',
		exam: 'Good to know'
	};

	const letter = (i: number) => String.fromCharCode(0x61 + i);

	const practice = $derived(unit.practice);
	// Pictured words get cards of their own: one picture in a row of plain
	// tiles would stretch every tile beside it.
	const pictured = $derived(unit.words.filter((w) => w.image));
	const plain = $derived(unit.words.filter((w) => !w.image));

	/** A big-text template split on its `{{n}}` markers. */
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

	/** Long answers get a longer line to write on. */
	const gapWidth = (answer: string) => `${Math.min(14, Math.max(4.5, answer.length * 0.62 + 1.5))}em`;
</script>

{#snippet german(text: string, focus?: string[])}
	{#each splitFocus(text, focus) as part, p (p)}{#if part.hit}<mark>{part.text}</mark>{:else}{part.text}{/if}{/each}
{/snippet}

{#snippet gapped(text: string, width = '4.5em')}
	{#each text.split('____') as piece, p (p)}{#if p > 0}<span class="gap" style="width:{width}" aria-label="blank"></span>{/if}{piece}{/each}
{/snippet}

{#snippet ticks(options: string[], german: boolean)}
	<ul class="ticks" class:stack={options.some((o) => o.length > 22)} class:german>
		{#each options as option, o (o)}
			<li><span class="box" aria-hidden="true"></span><span class="letter">{letter(o)}</span>{option}</li>
		{/each}
	</ul>
{/snippet}

<section class="unit" id="unit-{unit.n}">
	<header class="head" class:pictured={!!unit.image}>
		<div class="head-text">
			<p class="eyebrow"><span class="unit-no tnum">Unit {unit.n}</span> · {unit.kindLabel}</p>
			<h2 class="title">{unit.title}</h2>
			<p class="hook">{unit.hook}</p>
		</div>
		{#if unit.image}
			<img class="head-pic" src="/img/{unit.image}.webp" alt="" width="1024" height="768" />
		{/if}
	</header>

	{#if unit.intro}
		<p class="intro">{unit.intro}</p>
	{/if}

	{#if unit.rules.length}
		<h3 class="part"><span class="part-no">1</span>Learn</h3>
		<div class="rules">
			{#each unit.rules as rule (rule.number)}
				<article class="rule" data-tone={rule.kind}>
					<p class="eyebrow tone">{KIND_LABEL[rule.kind] ?? 'Rule'} {rule.number}</p>
					{#if rule.title}<h4>{rule.title}</h4>{/if}
					<p class="rule-text">{rule.text}</p>
					{#if rule.examples.length}
						<ul class="examples">
							{#each rule.examples as ex, e (e)}
								<li>
									<span class="de" lang="de">{@render german(ex.de, ex.focus)}</span>
									<span class="en">{ex.en}</span>
								</li>
							{/each}
						</ul>
					{/if}
					{#if rule.trap}
						<p class="trap"><strong>Trap ·</strong> {rule.trap}</p>
					{/if}
				</article>
			{/each}
		</div>
	{/if}

	{#snippet word(w: WorkbookWord)}
		<span class="w-de" lang="de">{#if w.article}<span class="article">{w.article}</span>{' '}{/if}{w.de}</span>
		<span class="w-en">{w.en}{#if w.plural && w.plural !== '—'}{' · pl. '}<b lang="de">{w.plural}</b>{/if}</span>
	{/snippet}

	{#if unit.words.length}
		<h3 class="part"><span class="part-no">2</span>Words
			{#if unit.words.some((w) => w.gender)}
				<small class="legend">
					<span style="--g:{GENDER_COLORS.m}">der</span>
					<span style="--g:{GENDER_COLORS.f}">die</span>
					<span style="--g:{GENDER_COLORS.n}">das</span>
				</small>
			{/if}
		</h3>
		{#if pictured.length}
			<ul class="words pics">
				{#each pictured as w, k (k)}
					<li style={w.gender ? `--g:${GENDER_COLORS[w.gender]}` : ''}>
						<img src="/img/{w.image}.webp" alt="" width="512" height="512" />
						{@render word(w)}
					</li>
				{/each}
			</ul>
		{/if}
		{#if plain.length}
			<ul class="words">
				{#each plain as w, k (k)}
					<li style={w.gender ? `--g:${GENDER_COLORS[w.gender]}` : ''}>{@render word(w)}</li>
				{/each}
			</ul>
		{/if}
	{/if}

	{#if unit.context}
		<div class="context">
			<p class="eyebrow">In context</p>
			<p class="de" lang="de">{@render german(unit.context.de, unit.context.focus)}</p>
			<p class="en">{unit.context.en}</p>
		</div>
	{/if}

	{#if unit.checks.length}
		<h3 class="part"><span class="part-no">3</span>Check yourself <small>Tick one box each</small></h3>
		<ol class="checks">
			{#each unit.checks as check (check.n)}
				<li>
					<span class="n tnum">{check.n}</span>
					<div>
						<p class="q-eyebrow">{check.eyebrow}</p>
						<p class="q" lang={check.question.includes('____') ? 'de' : undefined}>{@render gapped(check.question)}</p>
						{@render ticks(check.options, true)}
					</div>
				</li>
			{/each}
		</ol>
	{/if}

	{#if unit.remember.length || unit.table || unit.derived}
		<div class="cheat">
			<p class="eyebrow">Cheat sheet</p>
			{#if unit.remember.length}
				<ul class="remember">
					{#each unit.remember as aid, a (a)}<li>{aid}</li>{/each}
				</ul>
			{/if}
			{#if unit.table}
				<table>
					{#if unit.table.caption}<caption>{unit.table.caption}</caption>{/if}
					<thead><tr>{#each unit.table.columns as col, c (c)}<th scope="col">{col}</th>{/each}</tr></thead>
					<tbody>
						{#each unit.table.rows as row, r (r)}
							<tr style={row.gender ? `color:${GENDER_COLORS[row.gender]}` : ''}>
								{#each row.cells as cell, c (c)}{#if c === 0}<th scope="row">{cell}</th>{:else}<td>{cell}</td>{/if}{/each}
							</tr>
						{/each}
					</tbody>
				</table>
			{:else if unit.derived}
				<table>
					<thead>
						<tr>
							<th scope="col">{unit.derived.subjectHeader}</th>
							{#each unit.derived.columns as col, c (c)}<th scope="col">{col}</th>{/each}
						</tr>
					</thead>
					<tbody>
						{#each unit.derived.rows as row, r (r)}
							<tr>
								<th scope="row" style={unit.derived.colorByGender && row.gender ? `color:${GENDER_COLORS[row.gender]}` : ''}>
									{#if row.article}<span class="article">{row.article}</span>{' '}{/if}{row.subject}
								</th>
								{#each row.cells as cell, c (c)}<td>{cell}</td>{/each}
							</tr>
						{/each}
					</tbody>
				</table>
			{/if}
		</div>
	{/if}

	{#if practice}
		<h3 class="part"><span class="part-no">4</span>Practise
			<small>
				{practice.kind === 'reading'
					? 'Read the text, then tick the right answer'
					: practice.kind === 'inlineCloze'
						? 'Fill each numbered gap'
						: 'Write the missing word'}
			</small>
		</h3>

		{#if practice.kind === 'reading'}
			<div class="passage">
				{#if practice.passage}<p lang="de">{practice.passage}</p>{/if}
			</div>
			<ol class="checks">
				{#each practice.items as item, i (i)}
					<li>
						<span class="n tnum">{unit.practiceFrom + i}</span>
						<div>
							<p class="q">{item.prompt}</p>
							{@render ticks(item.options, true)}
						</div>
					</li>
				{/each}
			</ol>
		{:else if practice.kind === 'inlineCloze'}
			<div class="passage">
				<p lang="de">
					{#each inlineParts(practice.passage ?? '') as part, p (p)}{part.text}{#if part.blank !== null}{@const item = practice.items[part.blank]}<span
							class="inline-gap"><span class="tnum">{unit.practiceFrom + part.blank}</span><span
								class="gap"
								style="width:{gapWidth(item?.answer ?? '')}"
							></span>{#if item?.prompt}<small>({item.prompt})</small>{/if}</span
						>{/if}{/each}
				</p>
			</div>
			{#if practice.items.some((item) => item.options.length)}
				<ul class="choices">
					{#each practice.items as item, i (i)}
						{#if item.options.length}
							<li><span class="tnum">{unit.practiceFrom + i}</span> {item.options.join(' / ')}</li>
						{/if}
					{/each}
				</ul>
			{/if}
		{:else}
			<ol class="cloze">
				{#each practice.items as item, i (i)}
					<li>
						<span class="n tnum">{unit.practiceFrom + i}</span>
						<div>
							<p class="sentence" lang="de">
								{@render gapped(item.prompt, gapWidth(item.answer))}{#if !item.prompt.includes('____')}<span
										class="gap"
										style="width:{gapWidth(item.answer)}"
									></span>{/if}
							</p>
							{#if item.secondary}<p class="en">{item.secondary}</p>{/if}
						</div>
					</li>
				{/each}
			</ol>
		{/if}
	{/if}

	{#if unit.answers.length}
		<!-- Upside down, as a printed workbook does it: there to check against,
		     not there to read by accident. -->
		<footer class="answers">
			<p>
				<strong>Answers · Unit {unit.n}</strong>
				{#each unit.answers as a (a.n)}<span class="a"><span class="tnum">{a.n}</span>&nbsp;{a.text}</span>{/each}
			</p>
		</footer>
	{/if}
</section>

<style>
	.unit {
		--serif: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		--cream: #fbf5e4;
		display: flex;
		flex-direction: column;
		gap: 4.2mm;
		font-size: 10pt;
		line-height: 1.45;
		color: var(--ink);
	}

	.eyebrow {
		margin: 0;
		font-size: 7.2pt;
		font-weight: 800;
		letter-spacing: 0.09em;
		text-transform: uppercase;
		color: var(--accent);
	}

	/* -- opener ------------------------------------------------------------ */

	.head {
		display: grid;
		grid-template-columns: 1fr;
		gap: 6mm;
		align-items: center;
		padding-top: 4mm;
		border-top: 2.2mm solid var(--accent);
		break-inside: avoid;
		break-after: avoid;
	}

	.head.pictured {
		grid-template-columns: 1fr 58mm;
	}

	.unit-no {
		color: var(--navy);
	}

	.title {
		margin: 1mm 0 0;
		font-family: var(--serif);
		font-size: 13pt;
		font-weight: 700;
		color: var(--ink-muted);
	}

	.hook {
		margin: 1.5mm 0 0;
		font-family: var(--serif);
		font-size: 19pt;
		font-weight: 700;
		line-height: 1.16;
		color: var(--navy);
		text-wrap: balance;
	}

	.head-pic {
		width: 58mm;
		height: auto;
		border-radius: 3mm;
		background: var(--cream);
	}

	.intro {
		margin: 0;
		color: var(--ink-muted);
		font-size: 9.5pt;
		line-height: 1.55;
	}

	/* -- part headings ----------------------------------------------------- */

	.part {
		display: flex;
		align-items: center;
		gap: 2.5mm;
		margin: 2mm 0 0;
		padding-bottom: 1.5mm;
		border-bottom: 0.4mm solid var(--navy);
		font-family: var(--serif);
		font-size: 13pt;
		color: var(--navy);
		break-after: avoid;
	}

	.part small {
		margin-left: auto;
		font-family: Inter, system-ui, sans-serif;
		font-size: 8pt;
		font-weight: 600;
		color: var(--ink-muted);
	}

	.part-no {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 6mm;
		height: 6mm;
		border-radius: 50%;
		background: var(--navy);
		color: #fff;
		font-family: Inter, system-ui, sans-serif;
		font-size: 8.5pt;
	}

	/* -- rules ------------------------------------------------------------- */

	.rules {
		display: grid;
		gap: 4mm;
	}

	.rule {
		padding-left: 3.5mm;
		border-left: 1mm solid var(--accent);
	}

	.rule > * + * {
		margin-top: 1.6mm;
	}

	.rule > h4,
	.rule > .eyebrow {
		break-after: avoid;
	}

	.examples li,
	.trap {
		break-inside: avoid;
	}

	.rule[data-tone='warning'] {
		border-left-color: var(--wrong);
	}
	.rule[data-tone='warning'] .tone {
		color: var(--wrong);
	}
	.rule[data-tone='mnemonic'] {
		border-left-color: var(--ochre);
	}
	.rule[data-tone='mnemonic'] .tone {
		color: var(--ochre);
	}

	h4 {
		margin: 0;
		font-family: var(--serif);
		font-size: 12.5pt;
		line-height: 1.25;
		color: var(--heading);
	}

	.rule-text {
		margin: 0;
	}

	.examples {
		display: grid;
		gap: 1.4mm;
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.examples li {
		display: grid;
		gap: 0.3mm;
		padding: 2mm 3mm;
		border-radius: 2mm;
		background: var(--cream);
	}

	.de {
		font-family: var(--serif);
		font-size: 11.5pt;
		line-height: 1.35;
		color: var(--ink);
	}

	.en {
		margin: 0;
		font-size: 8.5pt;
		color: var(--ink-muted);
	}

	mark {
		padding: 0 0.1em;
		border-radius: 1px;
		background: var(--accent-soft);
		color: var(--accent);
		font-weight: 700;
		box-shadow: inset 0 -0.45mm 0 var(--accent);
	}

	.trap {
		margin: 0;
		padding: 1.8mm 3mm;
		border-radius: 2mm;
		background: var(--wrong-bg);
		color: var(--wrong);
		font-size: 9pt;
		font-weight: 600;
	}

	/* -- words ------------------------------------------------------------- */

	.words {
		display: grid;
		grid-template-columns: repeat(4, minmax(0, 1fr));
		gap: 2mm;
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.words li {
		display: grid;
		align-content: start;
		gap: 0.3mm;
		padding: 1.8mm 2.4mm;
		border: 0.25mm solid var(--line-strong);
		border-left: 1.1mm solid var(--g, var(--line-strong));
		border-radius: 1.6mm;
		break-inside: avoid;
	}

	.words.pics {
		grid-template-columns: repeat(5, minmax(0, 1fr));
	}

	.words.pics li {
		border-left-width: 0.25mm;
		border-bottom: 1.1mm solid var(--g, var(--line-strong));
		background: var(--cream);
		text-align: center;
	}

	.words.pics img {
		width: 80%;
		height: auto;
		justify-self: center;
		margin-bottom: 0.6mm;
	}

	.w-de {
		overflow-wrap: anywhere;
		font-family: var(--serif);
		font-size: 11pt;
		font-weight: 650;
		line-height: 1.2;
		color: var(--g, var(--ink));
	}

	.article {
		font-weight: 400;
	}

	.w-en {
		font-size: 8pt;
		color: var(--ink-muted);
	}

	.w-en b {
		color: var(--ink);
	}

	.part .legend {
		display: flex;
		gap: 3.5mm;
	}

	.legend span {
		display: inline-flex;
		align-items: center;
		gap: 1.2mm;
		color: var(--g);
		font-weight: 700;
	}

	.legend span::before {
		content: '';
		width: 2.4mm;
		height: 2.4mm;
		border-radius: 0.5mm;
		background: var(--g);
	}

	/* -- context ----------------------------------------------------------- */

	.context {
		display: grid;
		gap: 1.4mm;
		padding: 3mm 4mm;
		border-radius: 2.5mm;
		background: var(--cream);
		break-inside: avoid;
	}

	.context .de {
		margin: 0;
		line-height: 1.5;
	}

	/* -- checks & reading questions ---------------------------------------- */

	.checks,
	.cloze {
		display: grid;
		gap: 3mm;
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.checks {
		grid-template-columns: repeat(2, minmax(0, 1fr));
		gap: 3.5mm 6mm;
	}

	.checks li,
	.cloze li {
		display: grid;
		grid-template-columns: 6mm 1fr;
		gap: 2mm;
		align-items: start;
		break-inside: avoid;
	}

	.n {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 5.4mm;
		height: 5.4mm;
		border: 0.35mm solid var(--navy);
		border-radius: 50%;
		color: var(--navy);
		font-size: 7.5pt;
		font-weight: 800;
	}

	.q-eyebrow {
		margin: 0 0 0.4mm;
		font-size: 6.6pt;
		font-weight: 800;
		letter-spacing: 0.08em;
		text-transform: uppercase;
		color: var(--ink-muted);
	}

	.q {
		margin: 0 0 1.4mm;
		font-weight: 600;
		line-height: 1.35;
	}

	.q[lang='de'] {
		font-family: var(--serif);
		font-size: 11pt;
	}

	.gap {
		display: inline-block;
		height: 0.95em;
		margin: 0 0.15em;
		border-bottom: 0.35mm solid var(--ink);
		vertical-align: baseline;
	}

	.ticks {
		display: flex;
		flex-wrap: wrap;
		gap: 1.2mm 4.5mm;
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.ticks.stack {
		display: grid;
		gap: 1.2mm;
	}

	.ticks li {
		display: inline-flex;
		align-items: baseline;
		gap: 1.3mm;
	}

	.ticks.german li {
		font-family: var(--serif);
		font-size: 10.5pt;
	}

	.box {
		flex: none;
		align-self: center;
		width: 3.2mm;
		height: 3.2mm;
		border: 0.3mm solid var(--ink);
		border-radius: 0.6mm;
	}

	.letter {
		font-family: Inter, system-ui, sans-serif;
		font-size: 7.5pt;
		font-weight: 700;
		color: var(--ink-muted);
	}

	/* -- cheat sheet ------------------------------------------------------- */

	.cheat {
		display: grid;
		gap: 2mm;
		padding: 3mm 4mm;
		border: 0.35mm solid var(--navy);
		border-radius: 2.5mm;
		break-inside: avoid;
	}

	.cheat .eyebrow {
		color: var(--navy);
	}

	.remember {
		margin: 0;
		padding-left: 4mm;
		font-size: 9pt;
	}

	.remember li::marker {
		color: var(--ochre);
	}

	table {
		border-collapse: collapse;
		width: 100%;
		font-size: 8.8pt;
	}

	caption {
		text-align: left;
		font-size: 7.5pt;
		font-weight: 700;
		color: var(--ink-muted);
		padding-bottom: 1mm;
	}

	th,
	td {
		padding: 0.9mm 2mm;
		text-align: left;
		border-bottom: 0.2mm solid var(--line-strong);
	}

	thead th {
		font-size: 6.8pt;
		font-weight: 800;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--ink-muted);
		border-bottom: 0.35mm solid var(--navy);
	}

	tbody th {
		font-family: var(--serif);
		font-size: 9.8pt;
	}

	/* -- practice ---------------------------------------------------------- */

	.passage {
		padding: 3.5mm 4.5mm;
		border-radius: 2.5mm;
		background: var(--cream);
	}

	.passage p {
		margin: 0;
		font-family: var(--serif);
		font-size: 10.8pt;
		line-height: 1.75;
		white-space: pre-wrap;
	}

	.inline-gap {
		white-space: nowrap;
	}

	.inline-gap .tnum {
		font-family: Inter, system-ui, sans-serif;
		font-size: 7pt;
		font-weight: 800;
		color: var(--accent);
		vertical-align: super;
	}

	.inline-gap small {
		font-family: Inter, system-ui, sans-serif;
		font-size: 7.5pt;
		color: var(--ink-muted);
	}

	.choices {
		display: flex;
		flex-wrap: wrap;
		gap: 1mm 5mm;
		margin: 0;
		padding: 0;
		list-style: none;
		font-size: 9pt;
	}

	.choices .tnum {
		font-weight: 800;
		color: var(--accent);
	}

	.cloze {
		grid-template-columns: repeat(2, minmax(0, 1fr));
		gap: 3.5mm 6mm;
	}

	.sentence {
		margin: 0;
		font-family: var(--serif);
		font-size: 11pt;
		line-height: 1.55;
	}

	/* -- answers ----------------------------------------------------------- */

	.answers {
		margin-top: 2mm;
		padding-top: 2mm;
		border-top: 0.25mm dashed var(--line-strong);
		break-inside: avoid;
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

	@media (max-width: 40rem) {
		.head.pictured {
			grid-template-columns: 1fr;
		}
		.head-pic {
			width: 100%;
		}
		.words,
		.words.pics {
			grid-template-columns: repeat(2, minmax(0, 1fr));
		}
		.checks,
		.cloze {
			grid-template-columns: 1fr;
		}
	}
</style>
