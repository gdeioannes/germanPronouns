<script lang="ts">
	// A quiz's Help Memory — the "How it works" panel — in the seven layers the
	// content plan defines (docs/content_master_plan.md §4): the idea, the rule
	// cards with their examples, how to remember it, the reference table, the
	// words, a short text in context, and the exam it feeds — plus the mistakes
	// English speakers make. Every quiz has one, and it auto-opens on first
	// visit so the rules are read before the first question rather than
	// discovered by failing.
	import Icon from '$lib/icons/Icon.svelte';
	import SpeakButton from './SpeakButton.svelte';
	import { rise } from '$lib/motion';
	import { slide } from 'svelte/transition';
	import { GENDER_COLORS } from '$lib/domain/gender';
	import { helpTableFor } from '$lib/domain/help-table';
	import { vocabFor, type SharedNoun } from '$lib/domain/vocab';
	import { SettingsKeys } from '$lib/domain/keys';
	import { storage } from '$lib/services/storage';
	import type { Quiz } from '$lib/content/types';

	let { quiz, locale = 'de-DE' }: { quiz: Quiz; locale?: string } = $props();

	const help = $derived(quiz.help);
	const quizId = $derived(quiz.id);
	// An authored table wins; the grid's own answer key is the fallback.
	const derivedTable = $derived(help?.table ? null : helpTableFor(quiz));

	// The noun collection is 759 entries and only the text-based quizzes need
	// it, so it is fetched when one is opened rather than shipped with every
	// quiz page.
	let nouns = $state<SharedNoun[]>([]);
	$effect(() => {
		if (derivedTable || help?.vocab?.length) return;
		(async () => {
			const module = await import('$content/shared/nouns/de.json');
			nouns = module.default.nouns as SharedNoun[];
		})();
	});
	const derivedVocab = $derived(derivedTable || help?.vocab?.length ? [] : vocabFor(quiz, nouns));

	const hasContent = $derived(
		!!(
			help?.intro ||
			help?.tips?.length ||
			help?.table ||
			derivedTable ||
			help?.vocab?.length ||
			derivedVocab.length ||
			help?.remember?.length ||
			help?.context ||
			help?.mistakes?.length ||
			help?.exam
		)
	);

	let open = $state(false);

	$effect(() => {
		// First visit to this quiz opens the panel unprompted.
		(async () => {
			const raw = await storage.get(SettingsKeys.seenHelpMemory);
			const seen: string[] = raw ? JSON.parse(raw) : [];
			if (!seen.includes(quizId)) {
				open = true;
				await storage.set(SettingsKeys.seenHelpMemory, JSON.stringify([...seen, quizId]));
			}
		})();
	});
</script>

{#if hasContent}
	<section class="help">
		<button class="toggle" onclick={() => (open = !open)} aria-expanded={open}>
			<Icon name="help" size="1.05em" />
			<span>How this works</span>
			<span class="chevron" class:open><Icon name="chevronDown" size="1em" /></span>
		</button>

		{#if open}
			<div class="body" transition:slide={{ duration: 220 }}>
				<!-- 1 · The idea -->
				{#if help?.intro}
					<p class="intro">{help.intro}</p>
				{/if}

				<!-- 2 · Rule cards. They stagger in, so the panel reads as a short
				     list rather than a wall that appears all at once. -->
				{#each help?.tips ?? [] as tip, i (tip.text)}
					<div class="tip" data-kind={tip.kind ?? 'rule'} in:rise={{ delay: 60 + i * 45 }}>
						{#if tip.title}<h4>{tip.title}</h4>{/if}
						<p>{tip.text}</p>
						{#if tip.examples?.length}
							<ul class="examples">
								{#each tip.examples as ex (ex.de)}
									<li>
										<span class="de" lang={locale}>{ex.de}</span>
										<span class="en">{ex.en}</span>
									</li>
								{/each}
							</ul>
						{/if}
						{#if tip.trap}
							<p class="trap"><Icon name="close" size="0.95em" /> <span>{tip.trap}</span></p>
						{/if}
					</div>
				{/each}

				<!-- 5 · How to remember it (shown before the table: the aid is what
				     makes the table stick). -->
				{#if help?.remember?.length}
					<h4 class="section-head">How to remember it</h4>
					<ul class="remember">
						{#each help.remember as aid (aid)}
							<li>{aid}</li>
						{/each}
					</ul>
				{/if}

				<!-- 3 · The reference table: authored, or the quiz's own answer key
				     seen sideways, so it can never drift from the questions. -->
				{#if help?.table}
					<div class="table-wrap">
						{#if help.table.caption}<h4 class="section-head">{help.table.caption}</h4>{/if}
						<table>
							<thead>
								<tr>
									{#each help.table.columns as column (column)}
										<th scope="col">{column}</th>
									{/each}
								</tr>
							</thead>
							<tbody>
								{#each help.table.rows as row, r (r)}
									<tr style={row.gender ? `color:${GENDER_COLORS[row.gender]}` : ''}>
										{#each row.cells as cell, c (c)}
											{#if c === 0}<th scope="row">{cell}</th>{:else}<td>{cell}</td>{/if}
										{/each}
									</tr>
								{/each}
							</tbody>
						</table>
					</div>
				{:else if derivedTable}
					<div class="table-wrap">
						<table>
							<thead>
								<tr>
									<th scope="col">{derivedTable.subjectHeader}</th>
									{#each derivedTable.columns as column (column)}
										<th scope="col">{column}</th>
									{/each}
								</tr>
							</thead>
							<tbody>
								{#each derivedTable.rows as row (row.subject)}
									<tr>
										<th
											scope="row"
											style={derivedTable.colorByGender && row.gender
												? `color:${GENDER_COLORS[row.gender]}`
												: ''}
										>
											{#if row.article}<span class="article">{row.article}</span>{/if}{row.subject}
											{#if row.english}<small>{row.english}</small>{/if}
										</th>
										{#each row.cells as cell, i (i)}
											<td>{cell}</td>
										{/each}
									</tr>
								{/each}
							</tbody>
						</table>
					</div>
				{/if}

				<!-- 4 · Words you need: authored, else pulled from the shared noun
				     collection for text-based quizzes — article first, because that
				     is the half a learner forgets. -->
				{#if help?.vocab?.length}
					<h4 class="section-head">Words you need</h4>
					<ul class="vocab">
						{#each help.vocab as word (word.de)}
							<li>
								<span>
									{#if word.article}<span class="article">{word.article}</span>{/if}{word.de}{#if word.plural}<small class="plural">, {word.plural}</small>{/if}
								</span>
								<small>{word.en}</small>
							</li>
						{/each}
					</ul>
				{:else if derivedVocab.length > 0}
					<h4 class="section-head">Words in this text</h4>
					<ul class="vocab">
						{#each derivedVocab as word (word.noun)}
							<li>
								<span style="color:{GENDER_COLORS[word.gender]}">
									<span class="article">{word.article}</span>{word.noun}
								</span>
								<small>{word.english}</small>
							</li>
						{/each}
					</ul>
				{/if}

				<!-- 6 · In context, with audio: hear it before you drill it. -->
				{#if help?.context}
					<h4 class="section-head">In context</h4>
					<div class="context">
						<p class="de" lang={locale}>{help.context.de} <SpeakButton text={help.context.de} {locale} /></p>
						<p class="en">{help.context.en}</p>
					</div>
				{/if}

				<!-- Common mistakes -->
				{#if help?.mistakes?.length}
					<h4 class="section-head">Mistakes English speakers make</h4>
					<ul class="mistakes">
						{#each help.mistakes as m (m.wrong)}
							<li>
								<span class="wrong" lang={locale}>{m.wrong}</span>
								<span class="arrow">→</span>
								<span class="right" lang={locale}>{m.right}</span>
								<small>{m.why}</small>
							</li>
						{/each}
					</ul>
				{/if}

				<!-- 7 · In the exam -->
				{#if help?.exam}
					<p class="exam"><Icon name="trophy" size="1em" /> <span>{help.exam}</span></p>
				{/if}
			</div>
		{/if}
	</section>
{/if}

<style>
	.help {
		margin: 0 0 1.5rem;
		border: 1px solid var(--line);
		border-radius: 14px;
		background: var(--surface);
		overflow: hidden;
	}

	.toggle {
		display: flex;
		width: 100%;
		align-items: center;
		gap: 0.55rem;
		padding: 0.85rem 1rem;
		border: 0;
		background: none;
		font: inherit;
		font-weight: 700;
		color: var(--ink);
		cursor: pointer;
		transition: color var(--fast) var(--ease-out);
	}

	.toggle:hover {
		color: var(--accent);
	}

	.chevron {
		display: inline-flex;
		margin-left: auto;
		color: var(--ink-muted);
		transition: transform var(--medium) var(--ease-out);
	}

	.chevron.open {
		transform: rotate(180deg);
	}

	.body {
		padding: 0 1rem 1rem;
	}

	.intro {
		margin: 0 0 1rem;
		color: var(--ink);
		line-height: 1.6;
	}

	.section-head {
		margin: 1.2rem 0 0.5rem;
		font-size: 0.72rem;
		font-weight: 800;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--ink-muted);
	}

	/* Rule cards, tinted by kind so a warning is never mistaken for a rule. */
	.tip {
		padding: 0.75rem 0.9rem;
		margin-bottom: 0.6rem;
		border-left: 3px solid var(--accent);
		border-radius: 0 8px 8px 0;
		background: var(--surface-alt);
	}

	.tip[data-kind='warning'] {
		border-left-color: var(--wrong);
	}

	.tip[data-kind='mnemonic'] {
		border-left-color: var(--ochre, #b8860b);
	}

	.tip[data-kind='exam'] {
		border-left-color: var(--forest, #3f7d4e);
	}

	.tip h4 {
		margin: 0 0 0.25rem;
		font-size: var(--step-0);
		color: var(--heading);
	}

	.tip p {
		margin: 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	/* Examples: the German in serif on its own line, the English quietly under
	   it — the pairing is the teaching, so the two never sit on one line. */
	.examples {
		margin: 0.55rem 0 0;
		padding: 0;
		list-style: none;
		display: grid;
		gap: 0.4rem;
	}

	.examples li {
		display: grid;
		gap: 0.1rem;
		padding-left: 0.6rem;
		border-left: 2px solid var(--line-strong);
	}

	.de {
		font-family: 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-0);
		color: var(--ink);
	}

	.en {
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.trap {
		display: flex;
		gap: 0.4rem;
		align-items: baseline;
		margin: 0.55rem 0 0 !important;
		color: var(--wrong) !important;
		font-weight: 600;
	}

	.remember {
		margin: 0;
		padding: 0 0 0 1.1rem;
		font-size: var(--step--1);
		color: var(--ink);
	}

	.remember li {
		margin-bottom: 0.3rem;
	}

	/* The table is the one thing here that may be wider than the page, so it
	   scrolls inside its own box rather than pushing the layout sideways. */
	.table-wrap {
		margin-top: 1rem;
		overflow-x: auto;
	}

	table {
		border-collapse: collapse;
		width: 100%;
		font-size: var(--step--1);
	}

	th,
	td {
		padding: 0.4rem 0.7rem;
		text-align: left;
		border-bottom: 1px solid var(--line);
		white-space: nowrap;
	}

	thead th {
		position: sticky;
		top: 0;
		background: var(--surface);
		font-size: 0.72rem;
		font-weight: 800;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		color: var(--ink-muted);
	}

	tbody th {
		font-weight: 700;
	}

	.article {
		margin-right: 0.35ch;
		font-weight: 500;
		opacity: 0.85;
	}

	tbody th small {
		display: block;
		font-weight: 400;
		font-size: 0.75em;
		color: var(--ink-muted);
	}

	tbody tr:last-child th,
	tbody tr:last-child td {
		border-bottom: 0;
	}

	/* A wrapping grid rather than a table: it is a word list, and it has to stay
	   readable at phone width. */
	.vocab {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(11rem, 1fr));
		gap: 0.3rem 1rem;
		margin: 0;
		padding: 0;
		list-style: none;
		font-size: var(--step--1);
	}

	.vocab li {
		display: flex;
		align-items: baseline;
		gap: 0.4rem;
		padding: 0.15rem 0;
		border-bottom: 1px solid var(--line);
	}

	.vocab li > span {
		font-weight: 700;
	}

	.vocab small {
		color: var(--ink-muted);
	}

	.plural {
		font-weight: 400;
	}

	.context {
		padding: 0.75rem 0.9rem;
		border-radius: 10px;
		background: var(--surface-alt);
	}

	.context p {
		margin: 0;
	}

	.context .de {
		line-height: 1.55;
	}

	.context .en {
		margin-top: 0.4rem;
	}

	.mistakes {
		margin: 0;
		padding: 0;
		list-style: none;
		display: grid;
		gap: 0.5rem;
		font-size: var(--step--1);
	}

	.mistakes li {
		display: grid;
		grid-template-columns: auto auto 1fr;
		gap: 0.2rem 0.5rem;
		align-items: baseline;
	}

	.mistakes .wrong {
		color: var(--wrong);
		text-decoration: line-through;
	}

	.mistakes .right {
		color: var(--right);
		font-weight: 700;
	}

	.mistakes small {
		grid-column: 1 / -1;
		color: var(--ink-muted);
	}

	.exam {
		display: flex;
		gap: 0.5rem;
		align-items: baseline;
		margin: 1.2rem 0 0;
		padding: 0.6rem 0.8rem;
		border-radius: 10px;
		background: var(--accent-soft);
		color: var(--accent);
		font-size: var(--step--1);
		font-weight: 600;
	}
</style>
