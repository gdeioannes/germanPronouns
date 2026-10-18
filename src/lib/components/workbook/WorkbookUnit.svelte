<script lang="ts">
	// One unit of a level workbook, on paper: the lesson (the idea, the rules
	// with their highlighted examples, the words, the exchange), then the
	// checks and the practice, with the answers upside down at the foot — so
	// the page can be worked through without the app and checked without
	// peeking by accident. The same steps, in the same order, as Lesson.svelte.
	import { GENDER_COLORS } from '$lib/domain/gender';
	import { splitFocus } from '$lib/domain/lesson';
	import type { WorkbookUnit, WorkbookWord } from '$lib/domain/workbook';
	import LessonVisual from '$lib/components/lesson/LessonVisual.svelte';

	/** A QR code as inline SVG, with the short code printed under it. */
	export interface UnitQr {
		svg: string;
		code: string;
		label: string;
	}

	let {
		unit,
		qr = [],
		partNo = null,
		compact = false
	}: {
		unit: WorkbookUnit;
		/** The unit's codes: the exercise in the app, its audio. */
		qr?: UnitQr[];
		/** In a book: the part the unit is in, for "1.7" numbering. */
		partNo?: number | null;
		/**
		 * The printed book's setting: tighter type, the head in two columns,
		 * examples on one line, short word lists as a line, the recap table
		 * left to the grammar appendix. The on-screen workbook stays roomy.
		 */
		compact?: boolean;
	} = $props();

	const extra = $derived(unit.extra);
	/** The Listen code, drawn again beside the exercise that needs it. */
	const listenQr = $derived(qr.find((q) => q.label === 'Listen'));
	const unitNo = $derived(partNo ? `${partNo}.${unit.n}` : String(unit.n));

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
	// In the book a picture hunt's words are the objects already drawn in the
	// room, so their cards print without pictures.
	const noPics = $derived(compact && unit.extra?.kind === 'hunt');
	const pictured = $derived(noPics ? [] : unit.words.filter((w) => w.image));
	const plain = $derived(noPics ? unit.words : unit.words.filter((w) => !w.image));
	/** In the book, a short list of plain words runs as one line instead of a grid of cards. */
	const wordLine = $derived(compact && !pictured.length && plain.length <= 8);
	/** In the book, short examples sit two to a row. */
	const twin = (examples: { de: string; en: string }[]) =>
		compact && examples.length >= 2 && examples.every((e) => e.de.length <= 38 && e.en.length <= 48);

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

{#snippet listen(hint: string)}
	{#if listenQr}
		<div class="listen-box">
			<span class="qr">{@html listenQr.svg}</span>
			<span class="qr-text"><b>Scan to listen</b><br />languagequiz.org/b/{listenQr.code}<br />{hint}</span>
		</div>
	{/if}
{/snippet}

{#snippet codes()}
	{#if qr.length}
		<ul class="qrs">
			{#each qr as q (q.code)}
				<li>
					<span class="qr">{@html q.svg}</span>
					<span class="qr-text"><b>{q.label}</b><br />languagequiz.org/b/{q.code}</span>
				</li>
			{/each}
		</ul>
	{/if}
{/snippet}

<section class="unit" class:compact id="unit-{unit.n}">
	<header class="head" class:pictured={!!unit.image && !compact} class:split={compact}>
		<div class="head-text">
			<p class="eyebrow"><span class="unit-no tnum">Unit {unitNo}</span> · {unit.kindLabel}</p>
			<h2 class="title">{unit.title}</h2>
			<p class="hook">{unit.hook}</p>
		</div>
		{#if compact && unit.image}
			<!-- The book: the picture beside the hook; the codes follow with the intro. -->
			<img class="head-pic" src="/img/{unit.image}.webp" alt="" width="1024" height="768" />
		{:else if compact}
			<div class="aside narrow">{@render codes()}</div>
		{:else if unit.image}
			<img class="head-pic" src="/img/{unit.image}.webp" alt="" width="1024" height="768" />
		{/if}
	</header>

	{#if compact && unit.image}
		<div class="meta">
			{#if unit.intro}<p class="intro">{unit.intro}</p>{/if}
			{@render codes()}
		</div>
	{:else if !compact}
		{@render codes()}
	{/if}

	{#if unit.recall}
		<dl class="recall">
			<div><dt>You already know</dt><dd>{unit.recall.known}</dd></div>
			<div><dt>New here</dt><dd>{unit.recall.today}</dd></div>
		</dl>
	{/if}

	{#if unit.intro && !(compact && unit.image)}
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
						<ul class="examples" class:twin={twin(rule.examples)}>
							{#each rule.examples as ex, e (e)}
								<li>
									<span class="de" lang="de">{@render german(ex.de, ex.focus)}</span>
									<span class="en">{ex.en}</span>
								</li>
							{/each}
						</ul>
					{/if}
					{#if rule.visual}
						<div class="visual"><LessonVisual visual={rule.visual} /></div>
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
		{#if wordLine}
			<p class="wordline">
				{#each plain as w, k (k)}<span class="wl" style={w.gender ? `--g:${GENDER_COLORS[w.gender]}` : ''}>{@render word(w)}</span>{/each}
			</p>
		{:else if plain.length}
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
				<div class="table-scroll">
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
				</div>
			{:else if unit.derived}
				<div class="table-scroll">
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
				</div>
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
						: practice.items.every((item) => item.ordered)
							? 'Write the words in brackets into the gap, in the right order'
							: practice.items.some((item) => item.ordered)
								? 'Fill each gap — where words are given in brackets, put them in order'
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
							></span></span
						>{#if item?.prompt} <small class="gap-hint">({item.prompt})</small>{/if}{/if}{/each}
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

	{#if extra}
		{#if extra.kind === 'listening'}
			<h3 class="part"><span class="part-no">4</span>Listen <small>Scan the audio code, listen twice, then tick one box each</small></h3>
			{#if extra.title}<p class="passage-title">{extra.title}</p>{/if}
			{@render listen('Play it twice before you answer.')}
			<ol class="checks">
				{#each extra.questions as item (item.n)}
					<li>
						<span class="n tnum">{item.n}</span>
						<div>
							<p class="q" lang="de">{item.q}</p>
							{@render ticks(item.options, true)}
						</div>
					</li>
				{/each}
			</ol>
			<div class="notes"><p class="eyebrow">Notes while you listen</p>{#each Array(3) as _, i (i)}<span class="ruled"></span>{/each}</div>
			<p class="key-note">The transcript is in the key at the back of the book.</p>
		{:else if extra.kind === 'dictation'}
			<h3 class="part"><span class="part-no">4</span>Write what you hear <small>Play each sentence as often as you need, then write it in one go</small></h3>
			{@render listen('Every sentence is a track; replay as often as you need.')}
			<ol class="dictation">
				{#each extra.lines as line (line.n)}
					<li><span class="n tnum">{line.n}</span><span class="ruled"></span></li>
				{/each}
			</ol>
			<p class="key-note">The sentences are in the key at the back of the book.</p>
		{:else if extra.kind === 'phrases'}
			<h3 class="part"><span class="part-no">4</span>Repeat after the voice <small>Listen, say it, listen again; tick the box when it sounds right</small></h3>
			{@render listen('Each phrase is a track; say it after the voice.')}
			<ol class="phrases">
				{#each extra.lines as line (line.n)}
					<li>
						<span class="n tnum">{line.n}</span>
						<div><p class="de" lang="de">{line.de}</p>{#if line.en}<p class="en">{line.en}</p>{/if}</div>
						<span class="box" aria-hidden="true"></span>
					</li>
				{/each}
			</ol>
		{:else if extra.kind === 'speaking'}
			<h3 class="part"><span class="part-no">4</span>Talk <small>{extra.minutes ? `About ${extra.minutes} minutes` : 'Out loud'} · with the tutor in the app, or with anyone who speaks German</small></h3>
			<div class="task">
				<p class="topic">{extra.topic}</p>
				{#if extra.material}<p class="material">{extra.material}</p>{/if}
			</div>
			<div class="two">
				{#if extra.vocabulary.length}
					<div><p class="eyebrow">Have ready</p><ul class="chips">{#each extra.vocabulary as v, i (i)}<li lang="de">{v}</li>{/each}</ul></div>
				{/if}
				{#if extra.points.length}
					<div><p class="eyebrow">Practise</p><ul class="plain">{#each extra.points as pt, i (i)}<li>{pt}</li>{/each}</ul></div>
				{/if}
			</div>
			{#if extra.criteria.length}
				<div class="selfcheck"><p class="eyebrow">Afterwards, tick what went well</p><ul class="ticks stack">{#each extra.criteria as c, i (i)}<li><span class="box" aria-hidden="true"></span>{c}</li>{/each}</ul></div>
			{/if}
		{:else if extra.kind === 'writing'}
			<h3 class="part"><span class="part-no">4</span>Write <small>{extra.charMax ? `Up to about ${extra.charMax} characters` : 'A short text'}</small></h3>
			<div class="task"><p class="topic">{extra.topic}</p></div>
			<div class="two">
				{#if extra.vocabulary.length}
					<div><p class="eyebrow">Useful</p><ul class="chips">{#each extra.vocabulary as v, i (i)}<li lang="de">{v}</li>{/each}</ul></div>
				{/if}
				{#if extra.points.length}
					<div><p class="eyebrow">Remember to</p><ul class="plain">{#each extra.points as pt, i (i)}<li>{pt}</li>{/each}</ul></div>
				{/if}
			</div>
			<div class="writing-lines">{#each Array(compact ? 14 : 16) as _, i (i)}<span class="ruled"></span>{/each}</div>
			{#if extra.criteria.length}
				<div class="selfcheck"><p class="eyebrow">Check your text</p><ul class="ticks stack">{#each extra.criteria as c, i (i)}<li><span class="box" aria-hidden="true"></span>{c}</li>{/each}</ul></div>
			{/if}
		{:else if extra.kind === 'hunt'}
			<h3 class="part"><span class="part-no">4</span>Find and name <small>Find each thing in the picture and write it with its article</small></h3>
			{@render listen('Hear every word with its article.')}
			<img class="scene" src="/img/{extra.scene}.webp" alt="" width="1024" height="1024" />
			<ol class="hunt">
				{#each extra.spots as spot (spot.n)}
					<li><span class="n tnum">{spot.n}</span><small>{spot.en}</small><span class="ruled"></span></li>
				{/each}
			</ol>
			<p class="key-note">The words are in the key at the back of the book.</p>
		{:else if extra.kind === 'deck'}
			<h3 class="part"><span class="part-no">4</span>Picture dictionary <small>Every word of this part, by the unit it came from</small></h3>
			{#each extra.groups as group, g (g)}
				<div class="deck-group">
					<p class="group-title">{group.title}</p>
					<ul class="deck">
						{#each group.cards as card (card.n)}
							<li class:pic={!!card.image && !compact} style={card.article ? `--g:${GENDER_COLORS[card.article === 'der' ? 'm' : card.article === 'die' ? 'f' : 'n']}` : ''}>
								{#if card.image && !compact}<img src="/img/{card.image}.webp" alt="" width="512" height="512" />{/if}
								<span class="w-de" lang="de">{#if card.article}<span class="article">{card.article}</span>{' '}{/if}{card.de}</span>
								<span class="w-en">{card.en}{#if card.plural && card.plural !== '—'}{' · pl. '}<b lang="de">{card.plural}</b>{/if}</span>
							</li>
						{/each}
					</ul>
				</div>
			{/each}
			{#if compact}
				<!-- The book: one picture card would stretch its whole row of text
				     cards, so the pictures come together at the end, small. -->
				{@const picturedCards = extra.groups.flatMap((g) => g.cards.filter((c) => c.image))}
				{#if picturedCards.length}
					<div class="deck-group">
						<p class="group-title">In pictures</p>
						<ul class="deck-pics">
							{#each picturedCards as card (card.n)}
								<li style={card.article ? `--g:${GENDER_COLORS[card.article === 'der' ? 'm' : card.article === 'die' ? 'f' : 'n']}` : ''}>
									<img src="/img/{card.image}.webp" alt="" width="512" height="512" />
									<span class="w-de" lang="de">{#if card.article}<span class="article">{card.article}</span>{' '}{/if}{card.de}</span>
								</li>
							{/each}
						</ul>
					</div>
				{/if}
			{/if}
		{/if}
	{/if}

	{#if unit.answers.length}
		<!-- Upside down, as a printed workbook does it: there to check against,
		     not there to read by accident. -->
		<footer class="answers">
			<p>
				<strong>Answers · Unit {unitNo}</strong>
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
		break-inside: avoid;
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
		/* minmax(0, …) + break-word: long German compounds
		   (zweihundertsechsundsiebzig) wrap instead of widening a phone screen. */
		grid-template-columns: 6mm minmax(0, 1fr);
		gap: 2mm;
		overflow-wrap: break-word;
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
		grid-template-columns: minmax(0, 1fr);
		gap: 1.2mm;
	}

	/* anywhere (not break-word): it also lowers the min-content width, so a
	   long compound can't force the option wider than a phone screen. */
	.ticks li {
		max-width: 100%;
		overflow-wrap: anywhere;
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
		/* minmax(0, …): a wide table can't stretch the card past a phone
		   screen (an implicit auto track grows to the table's min-content). */
		grid-template-columns: minmax(0, 1fr);
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

	/* On a phone the table scrolls inside the card; on paper it always fits. */
	@media screen {
		.table-scroll {
			overflow-x: auto;
		}
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

	/* The hint sits outside .inline-gap so the line can break before it. */
	.gap-hint {
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

	/* -- QR codes and recall ------------------------------------------------ */

	.qrs {
		display: flex;
		flex-wrap: wrap;
		gap: 3mm 8mm;
		margin: 0;
		padding: 0;
		list-style: none;
		break-inside: avoid;
	}
	.qrs li {
		display: inline-flex;
		align-items: center;
		gap: 2.5mm;
	}
	.qr {
		display: block;
		width: 19mm;
		height: 19mm;
	}
	.qr :global(svg) {
		width: 100%;
		height: 100%;
		display: block;
	}
	.qr-text {
		font-size: 7.5pt;
		line-height: 1.4;
		color: var(--ink-muted);
	}
	.qr-text b {
		color: var(--navy);
	}
	.recall {
		margin: 0;
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 4mm;
		padding: 2.5mm 3.5mm;
		border: 0.25mm solid var(--line-strong);
		border-radius: 2mm;
		break-inside: avoid;
	}
	.recall dt {
		font-size: 6.8pt;
		font-weight: 800;
		letter-spacing: 0.08em;
		text-transform: uppercase;
		color: var(--ink-muted);
	}
	.recall div + div dt {
		color: var(--accent);
	}
	.recall dd {
		margin: 0.5mm 0 0;
		font-size: 9pt;
		line-height: 1.45;
	}

	/* -- diagrams ----------------------------------------------------------- */

	.visual {
		break-inside: avoid;
		font-size: 9.5pt;
	}
	.visual :global(.visual) {
		background: #fff;
		border-color: var(--line-strong);
	}
	.visual :global(.scroll) {
		overflow: visible;
		background: none;
	}
	.visual :global(.b-cell),
	.visual :global(.grid td) {
		white-space: normal;
	}

	.listen-box {
		display: inline-flex;
		align-items: center;
		gap: 3mm;
		padding: 2.5mm 3.5mm;
		border: 0.35mm solid var(--navy);
		border-radius: 2mm;
		break-inside: avoid;
	}
	.listen-box .qr {
		width: 22mm;
		height: 22mm;
	}

	/* -- the exercise pages --------------------------------------------------- */

	.ruled {
		display: block;
		height: 8.5mm;
		border-bottom: 0.25mm solid var(--line-strong);
	}
	.notes {
		break-inside: avoid;
	}
	.key-note {
		margin: 0;
		font-size: 8pt;
		font-style: italic;
		color: var(--ink-muted);
	}
	.passage-title {
		margin: 0;
		font-family: var(--serif);
		font-size: 12pt;
		font-weight: 700;
		color: var(--heading);
	}
	.dictation,
	.phrases,
	.hunt {
		margin: 0;
		padding: 0;
		list-style: none;
		display: grid;
		gap: 1.2mm;
	}
	.dictation li {
		display: grid;
		grid-template-columns: 6mm 1fr;
		gap: 2mm;
		align-items: end;
		break-inside: avoid;
	}
	.phrases {
		gap: 2mm;
	}
	.phrases li {
		display: grid;
		grid-template-columns: 6mm 1fr auto;
		gap: 2.5mm;
		align-items: center;
		padding: 1.6mm 2.5mm;
		border-radius: 2mm;
		background: var(--cream);
		break-inside: avoid;
	}
	.phrases .de {
		margin: 0;
	}
	.task {
		padding: 3mm 4mm;
		border-left: 1mm solid var(--navy);
		background: var(--cream);
		break-inside: avoid;
	}
	.topic {
		margin: 0;
		font-family: var(--serif);
		font-size: 11.5pt;
		line-height: 1.4;
		color: var(--ink);
	}
	.material {
		margin: 1.5mm 0 0;
		font-size: 9pt;
		color: var(--ink-muted);
	}
	.two {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 5mm;
	}
	.chips {
		display: flex;
		flex-wrap: wrap;
		gap: 1.5mm;
		margin: 1mm 0 0;
		padding: 0;
		list-style: none;
	}
	.chips li {
		padding: 0.8mm 2.2mm;
		border: 0.25mm solid var(--line-strong);
		border-radius: 3mm;
		font-family: var(--serif);
		font-size: 9.5pt;
	}
	.plain {
		margin: 1mm 0 0;
		padding-left: 4mm;
		font-size: 9pt;
	}
	.selfcheck {
		break-inside: avoid;
	}
	.writing-lines {
		display: grid;
	}
	.scene {
		width: 100%;
		height: auto;
		border-radius: 2mm;
		break-inside: avoid;
	}
	.hunt {
		grid-template-columns: repeat(2, minmax(0, 1fr));
		gap: 1.5mm 6mm;
	}
	.hunt li {
		display: grid;
		grid-template-columns: 6mm auto 1fr;
		gap: 2mm;
		align-items: end;
	}
	.hunt small {
		font-size: 7.5pt;
		color: var(--ink-muted);
		padding-bottom: 0.8mm;
	}
	.hunt .ruled {
		height: 6.5mm;
	}
	.deck-group {
		break-inside: avoid-page;
	}
	.group-title {
		margin: 2mm 0 1.5mm;
		font-family: var(--serif);
		font-size: 11pt;
		font-weight: 700;
		color: var(--navy);
		break-after: avoid;
	}
	.deck {
		display: grid;
		grid-template-columns: repeat(4, minmax(0, 1fr));
		gap: 1.6mm;
		margin: 0;
		padding: 0;
		list-style: none;
	}
	.deck li {
		display: grid;
		align-content: start;
		gap: 0.2mm;
		padding: 1.4mm 2mm;
		border: 0.25mm solid var(--line-strong);
		border-left: 1.1mm solid var(--g, var(--line-strong));
		border-radius: 1.6mm;
		break-inside: avoid;
	}
	.deck li.pic {
		text-align: center;
		background: var(--cream);
		border-left-width: 0.25mm;
		border-bottom: 1.1mm solid var(--g, var(--line-strong));
	}
	.deck li img {
		width: 70%;
		height: auto;
		justify-self: center;
	}

	/* -- the book: compact ------------------------------------------------
	   Every size here is the on-screen value made tighter for the press. The
	   unit flows on from the previous one; only chapters start a page. */

	.unit.compact {
		gap: 2.8mm;
		font-size: 9.8pt;
		line-height: 1.38;
	}
	.compact .head {
		gap: 5mm;
		align-items: start;
		padding-top: 2.5mm;
		border-top-width: 1.6mm;
	}
	.compact .head.split {
		grid-template-columns: minmax(0, 1fr) auto;
	}
	/* No picture: the codes alone, stacked beside the hook. */
	.compact .aside.narrow .qrs {
		flex-direction: column;
		gap: 1.5mm;
	}
	/* A picture: 46 mm beside the hook, then the intro with the codes at its side. */
	.compact .head.split .head-pic {
		width: 46mm;
	}
	.compact .meta {
		display: grid;
		grid-template-columns: minmax(0, 1fr) auto;
		gap: 5mm;
		align-items: start;
	}
	.compact .meta .qrs {
		flex-direction: column;
		gap: 1.5mm;
	}
	.compact .intro {
		font-size: 9.2pt;
		line-height: 1.4;
		margin-top: -0.5mm;
	}
	.compact .head-pic {
		width: 100%;
		border-radius: 2mm;
	}
	.compact .title {
		font-size: 11.5pt;
	}
	.compact .hook {
		font-size: 14pt;
		line-height: 1.18;
	}
	.compact .qrs {
		gap: 2mm 5mm;
	}
	/* 20 mm: the smallest size that still reads from a phone across a desk. */
	.compact .qr {
		width: 20mm;
		height: 20mm;
	}
	.compact .qr-text {
		font-size: 6.8pt;
		line-height: 1.3;
	}
	.compact .part {
		gap: 2mm;
		margin-top: 0.5mm;
		padding-bottom: 1mm;
		font-size: 11pt;
	}
	.compact .part-no {
		width: 4.8mm;
		height: 4.8mm;
		font-size: 7.5pt;
	}
	.compact .part small {
		font-size: 7.4pt;
	}
	.compact .rules {
		gap: 2.6mm;
	}
	.compact .rule > * + * {
		margin-top: 1.1mm;
	}
	.compact h4 {
		font-size: 11pt;
	}
	.compact .examples {
		gap: 1mm;
	}
	.compact .examples.twin {
		grid-template-columns: repeat(2, minmax(0, 1fr));
		column-gap: 2.5mm;
	}
	/* German and its English on one line: the box halves in height. */
	.compact .examples li {
		display: block;
		padding: 1.1mm 2.4mm;
	}
	.compact .examples .de {
		font-size: 10.5pt;
		line-height: 1.3;
	}
	.compact .examples .en {
		font-size: 8pt;
	}
	.compact .examples .en::before {
		content: '  ·  ';
		white-space: pre;
		color: var(--line-strong);
	}
	.compact .trap {
		padding: 1.2mm 2.4mm;
		font-size: 8.5pt;
	}
	.compact .visual {
		font-size: 9.2pt;
	}
	.compact .words {
		grid-template-columns: repeat(6, minmax(0, 1fr));
		gap: 1.4mm;
	}
	.compact .words.pics {
		grid-template-columns: repeat(7, minmax(0, 1fr));
	}
	.compact .words li {
		padding: 1.1mm 1.8mm;
	}
	.compact .w-de {
		font-size: 9.8pt;
	}
	.compact .w-en {
		font-size: 7.4pt;
	}
	.wordline {
		margin: 0;
		line-height: 1.6;
	}
	.wordline .wl {
		display: inline;
		white-space: nowrap;
	}
	.wordline .wl + .wl::before {
		content: '   ·   ';
		white-space: pre;
		color: var(--line-strong);
	}
	.wordline .w-de,
	.wordline .w-en {
		display: inline;
	}
	.wordline .w-en::before {
		content: ' ';
	}
	.compact .context {
		gap: 1mm;
		padding: 2mm 3mm;
	}
	.compact .context .de {
		line-height: 1.4;
	}
	.compact .checks {
		gap: 2.2mm 5mm;
	}
	.compact .q {
		margin-bottom: 1mm;
	}
	.compact .q[lang='de'] {
		font-size: 10pt;
	}
	.compact .ticks.german li {
		font-size: 10pt;
	}
	.compact .cheat {
		gap: 1.4mm;
		padding: 2mm 3mm;
	}
	.compact .remember {
		font-size: 8.6pt;
	}
	.compact th,
	.compact td {
		padding: 0.6mm 1.5mm;
	}
	.compact table {
		font-size: 8.2pt;
	}
	.compact .passage {
		padding: 2.5mm 3.5mm;
	}
	.compact .passage p {
		font-size: 10.2pt;
		line-height: 1.6;
	}
	.compact .cloze {
		gap: 2.2mm 5mm;
	}
	.compact .sentence {
		font-size: 10pt;
		line-height: 1.45;
	}
	.compact .answers {
		margin-top: 1mm;
		padding-top: 1.2mm;
	}
	.compact .ruled {
		height: 8mm;
	}
	.compact .phrases {
		gap: 1.4mm;
	}
	.compact .phrases li {
		padding: 1.1mm 2mm;
	}
	.compact .deck {
		grid-template-columns: repeat(6, minmax(0, 1fr));
		gap: 1.2mm;
	}
	.compact .deck li {
		padding: 1mm 1.6mm;
	}
	.compact .deck-group {
		break-inside: auto;
	}
	.compact .group-title {
		margin: 1.5mm 0 1mm;
		font-size: 9.5pt;
	}
	.deck-pics {
		display: grid;
		grid-template-columns: repeat(8, minmax(0, 1fr));
		gap: 1.2mm;
		margin: 0;
		padding: 0;
		list-style: none;
	}
	.deck-pics li {
		display: grid;
		gap: 0.3mm;
		padding: 1mm;
		border-bottom: 0.9mm solid var(--g, var(--line-strong));
		background: var(--cream);
		border-radius: 1.4mm;
		text-align: center;
		break-inside: avoid;
	}
	.deck-pics img {
		width: 78%;
		height: auto;
		justify-self: center;
	}
	.deck-pics .w-de {
		font-size: 8.2pt;
		line-height: 1.15;
	}
	.compact .hunt {
		grid-template-columns: repeat(3, minmax(0, 1fr));
		gap: 1mm 5mm;
	}
	.compact .hunt .ruled {
		height: 5.5mm;
	}
	.compact .scene {
		width: 135mm;
		align-self: center;
	}

	@media (max-width: 40rem) {
		.two,
		.hunt {
			grid-template-columns: 1fr;
		}
		.deck {
			grid-template-columns: repeat(2, minmax(0, 1fr));
		}
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
