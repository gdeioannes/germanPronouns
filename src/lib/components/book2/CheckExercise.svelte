<script lang="ts">
	import { lang } from '$lib/i18n/lang.svelte';
	import { t } from '$lib/i18n/t';
	// One exercise of the printed book, to check in the app: the reader puts in
	// what they wrote on paper and the app marks it against the book's key
	// (domain/bookStudy). Typed answers are marked leniently (spaces, closing
	// full stop, the euro sign); a typed answer the key does not know can be
	// the reader's own good one, so it can be counted right by hand.
	import Icon from '$lib/icons/Icon.svelte';
	import { rich, plain, type Exercise } from '$lib/domain/companion';
	import { markExercise, scoreOf, type Answers, type ItemResult } from '$lib/domain/bookStudy';

	let {
		ex,
		n,
		german = false,
		saved = null,
		onchecked
	}: {
		ex: Exercise;
		n: number;
		german?: boolean;
		/** The last result, shown until the reader checks again. */
		saved?: { right: number; total: number } | null;
		onchecked?: (score: { right: number; total: number }) => void;
	} = $props();

	let answers = $state<Answers>({});
	let results = $state<ItemResult[] | null>(null);
	/** Items the reader counted right by hand. */
	let ownRight = $state<Set<number>>(new Set());

	const typed = $derived(ex.kind === 'write' || ex.kind === 'gaps' || ex.kind === 'tags' || ex.kind === 'clocks');
	const score = $derived(
		results ? scoreOf(results.map((r, i) => (ownRight.has(i) ? { ...r, mark: 'right' as const } : r))) : null
	);

	function check() {
		results = markExercise(ex, answers);
		ownRight = new Set();
		if (results.length) onchecked?.(scoreOf(results));
	}

	function again() {
		results = null;
		ownRight = new Set();
	}

	function countRight(i: number) {
		ownRight = new Set([...ownRight, i]);
		if (results) onchecked?.(scoreOf(results.map((r, j) => (ownRight.has(j) ? { ...r, mark: 'right' as const } : r))));
	}

	const markOf = (i: number) => (results ? (ownRight.has(i) ? 'right' : results[i]?.mark) : null);
	const label = (s: string) => plain(s).replace(/\s+/g, ' ').trim();
</script>

{#snippet verdict(i: number)}
	{@const m = markOf(i)}
	{#if m && m !== 'open'}
		<span class="verdict {m}">
			{#if m === 'right'}
				<Icon name="check" size="1em" stroke={2.5} /><span class="sr">{t('Right')}</span>
			{:else if m === 'capitals'}
				<Icon name="check" size="1em" stroke={2.5} /> <span>{t('Mind the capitals:')} <b lang="de">{results![i].expected}</b></span>
			{:else}
				<Icon name="close" size="0.9em" stroke={2.5} />
				<span><span class="sr">{t('Not quite.')} </span>{german ? 'Lösung' : t('Answer')}: <b lang="de">{results![i].expected}</b></span>
				{#if typed && results![i].given}
					<button type="button" class="own" onclick={() => countRight(i)}>{german ? 'Meine war auch richtig' : t('Mine was right too')}</button>
				{/if}
			{/if}
		</span>
	{:else if m === 'open'}
		<span class="verdict open">{german ? 'Deine eigene Antwort' : t('Your own answer')}</span>
	{/if}
{/snippet}

<section class="ex" aria-labelledby="ex-{n}-{ex.title}">
	<header>
		<span class="n">{n}</span>
		<div>
			<h3 id="ex-{n}-{ex.title}" lang="de">{ex.title}</h3>
			<p class="how">{@html rich(ex.instruction)}</p>
		</div>
		{#if score}
			<span class="score" class:full={score.right === score.total}>{score.right}/{score.total}</span>
		{:else if saved}
			<span class="score last" title="Last time">{saved.right}/{saved.total}</span>
		{/if}
	</header>

	{#if ex.image}<img class="ex-img" src="/img/{ex.image}.webp" alt="" loading="lazy" />{/if}

	<ol class="items" lang="de">
		{#if ex.kind === 'write'}
			{#each ex.items as it, i (i)}
				<li>
					<label><span class="prompt">{@html rich(it.prompt)}</span>
						<input type="text" bind:value={answers[i]} disabled={!!results} autocomplete="off" autocapitalize="off" spellcheck="false" aria-label={label(it.prompt)} />
					</label>
					{@render verdict(i)}
				</li>
			{/each}
		{:else if ex.kind === 'gaps'}
			{#each ex.items as it, i (i)}
				<li>
					<span class="line">{@html rich(it.before)}
						<input class="gap" type="text" bind:value={answers[i]} disabled={!!results} autocomplete="off" autocapitalize="off" spellcheck="false" aria-label="Gap: {label(it.before)} … {label(it.after ?? '')}" />
						{#if it.after}{@html rich(it.after)}{/if}</span>
					{@render verdict(i)}
				</li>
			{/each}
		{:else if ex.kind === 'tags'}
			{#each ex.items as it, i (i)}
				<li class="tag">
					<img src="/img/{it.image}.webp" alt="" loading="lazy" />
					<span class="line">{#if it.label}<span>{it.label}</span>{/if}
						<input type="text" bind:value={answers[i]} disabled={!!results} autocomplete="off" autocapitalize="off" spellcheck="false" aria-label="Picture {i + 1}{it.label ? `: ${it.label}` : ''}" />{#if ex.unit}&nbsp;{ex.unit}{/if}</span>
					{@render verdict(i)}
				</li>
			{/each}
		{:else if ex.kind === 'clocks'}
			{#each ex.items as it, i (i)}
				<li>
					<label><span class="prompt">{ex.draw ? it.de : it.time}</span>
						<input type="text" bind:value={answers[i]} disabled={!!results} placeholder={ex.draw ? '00:00' : ''} autocomplete="off" aria-label={ex.draw ? t('The time for {de}', { de: it.de }) : t('The German for {time}', { time: it.time })} />
					</label>
					{@render verdict(i)}
				</li>
			{/each}
		{:else if ex.kind === 'circle'}
			{#each ex.items as it, i (i)}
				<li>
					<span class="line">{@html rich(it.before)}
						<span class="options" role="radiogroup" aria-label="Choose">
							{#each it.options as o (o)}
								<button type="button" role="radio" aria-checked={answers[i] === o} class:picked={answers[i] === o} disabled={!!results} onclick={() => (answers[i] = o)}>{o}</button>
							{/each}
						</span>
						{#if it.after}{@html rich(it.after)}{/if}</span>
					{@render verdict(i)}
				</li>
			{/each}
		{:else if ex.kind === 'match'}
			{#each ex.left as l, i (i)}
				<li>
					<label><span class="prompt">{@html rich(l)}</span>
						<select bind:value={answers[i]} disabled={!!results}>
							<option value="">…</option>
							{#each ex.right as r, j (j)}<option value={String(j)}>{plain(r)}</option>{/each}
						</select>
					</label>
					{@render verdict(i)}
				</li>
			{/each}
		{:else if ex.kind === 'sort'}
			{#each ex.words as w, i (i)}
				<li>
					<span class="line"><span class="prompt">{w}</span>
						<span class="options" role="radiogroup" aria-label={t('Column for {w}', { w })}>
							{#each ex.columns as col, j (j)}
								<button type="button" role="radio" aria-checked={answers[i] === String(j)} class:picked={answers[i] === String(j)} disabled={!!results} onclick={() => (answers[i] = String(j))}>{col}</button>
							{/each}
						</span></span>
					{@render verdict(i)}
				</li>
			{/each}
		{:else if ex.kind === 'colour'}
			{#each ex.sentences as s (s)}<li>{@html rich(s)}</li>{/each}
		{/if}
	</ol>

	{#if ex.kind === 'colour'}
		<p class="note" lang={lang.current}>{t('Check your picture against each sentence: this one only paper can mark.')}</p>
	{:else if results}
		<button type="button" class="btn ghost" onclick={again}><Icon name="repeat" size="1em" /> {german ? 'Noch einmal' : t('Try again')}</button>
	{:else}
		<button type="button" class="btn" onclick={check}>{german ? 'Prüfen' : t('Check')}</button>
	{/if}
</section>

<style>
	.ex {
		padding: 1.1rem 0 1.4rem;
		border-top: 1px solid var(--line);
	}

	header {
		display: grid;
		grid-template-columns: auto minmax(0, 1fr) auto;
		gap: 0.75rem;
		align-items: start;
	}

	.n {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 1.8rem;
		height: 1.8rem;
		border-radius: 4px;
		background: var(--heading);
		color: #fff;
		font-weight: 800;
		font-size: 0.9rem;
	}

	h3 {
		margin: 0;
		font-size: 1.05rem;
		color: var(--heading);
	}

	.how {
		margin: 0.15rem 0 0;
		color: var(--ink-muted);
		font-size: var(--step--1);
	}

	.score {
		padding: 0.15rem 0.5rem;
		border-radius: 4px;
		background: var(--wrong-bg);
		color: var(--wrong);
		font-weight: 800;
		font-variant-numeric: tabular-nums;
	}

	.score.full {
		background: var(--right-bg);
		color: var(--right);
	}

	.score.last {
		background: var(--surface-alt);
		color: var(--ink-muted);
		font-weight: 600;
	}

	.ex-img {
		display: block;
		max-width: 16rem;
		margin: 0.8rem 0 0;
		border-radius: 6px;
	}

	.items {
		display: grid;
		gap: 0.7rem;
		margin: 1rem 0;
		padding: 0;
		list-style: none;
	}

	.items li {
		display: flex;
		flex-direction: column;
		gap: 0.3rem;
	}

	label {
		display: flex;
		flex-wrap: wrap;
		gap: 0.4rem 0.75rem;
		align-items: center;
	}

	.prompt {
		min-width: 8rem;
	}

	.line {
		display: inline;
		line-height: 2.3;
	}

	input,
	select {
		min-height: 2.4rem;
		padding: 0.3rem 0.6rem;
		border: 1px solid var(--line-strong);
		border-radius: 6px;
		background: var(--surface);
		color: var(--ink);
		font: inherit;
	}

	label input {
		flex: 1 1 12rem;
	}

	input.gap {
		width: 9rem;
		max-width: 100%;
	}

	input:focus-visible,
	select:focus-visible {
		outline: 2px solid var(--accent-ink);
		outline-offset: 1px;
	}

	.tag {
		display: grid !important;
		grid-template-columns: 4.5rem minmax(0, 1fr);
		align-items: center;
		column-gap: 0.75rem;
	}

	.tag img {
		grid-row: span 2;
		width: 4.5rem;
		height: 4.5rem;
		object-fit: contain;
	}

	.options {
		display: inline-flex;
		flex-wrap: wrap;
		gap: 0.3rem;
		margin: 0 0.3rem;
		vertical-align: middle;
	}

	.options button {
		min-height: 2.2rem;
		padding: 0.2rem 0.7rem;
		border: 1px solid var(--line-strong);
		border-radius: 6px;
		background: var(--surface);
		color: var(--ink);
		font: inherit;
		cursor: pointer;
	}

	.options button.picked {
		border-color: var(--heading);
		background: var(--heading);
		color: #fff;
	}

	.options button:disabled {
		cursor: default;
	}

	.verdict {
		display: inline-flex;
		flex-wrap: wrap;
		gap: 0.3rem 0.5rem;
		align-items: center;
		font-size: var(--step--1);
	}

	.verdict.right {
		color: var(--right);
	}

	.verdict.capitals {
		color: var(--ochre-ink);
	}

	.verdict.wrong {
		color: var(--wrong);
	}

	.verdict.open {
		color: var(--ink-muted);
	}

	.verdict b {
		color: var(--ink);
	}

	.own {
		padding: 0.1rem 0.5rem;
		border: 1px solid var(--line-strong);
		border-radius: 4px;
		background: none;
		color: var(--ink-muted);
		font: inherit;
		font-size: 0.8rem;
		cursor: pointer;
	}

	.note {
		color: var(--ink-muted);
		font-size: var(--step--1);
	}

	.btn {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		min-height: 2.75rem;
		padding: 0 1.4rem;
		border: 2px solid var(--accent-ink);
		border-radius: 8px;
		background: var(--accent-ink);
		color: #fff;
		font: inherit;
		font-weight: 700;
		cursor: pointer;
	}

	.btn.ghost {
		background: transparent;
		color: var(--accent-ink);
	}

	.sr {
		position: absolute;
		width: 1px;
		height: 1px;
		overflow: hidden;
		clip: rect(0 0 0 0);
	}
</style>
