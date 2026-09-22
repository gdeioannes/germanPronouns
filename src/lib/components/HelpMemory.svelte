<script lang="ts">
	// A quiz's Help Memory, in the three layers the course plan defines: the
	// intro frames the idea, the tips carry the rules and mnemonics, and the
	// table carries the reference data. Every quiz has one, and it auto-opens on
	// first visit so the rules are read before the first question rather than
	// discovered by failing.
	import Icon from '$lib/icons/Icon.svelte';
	import { rise } from '$lib/motion';
	import { slide } from 'svelte/transition';
	import { GENDER_COLORS } from '$lib/domain/gender';
	import { helpTableFor } from '$lib/domain/help-table';
	import { SettingsKeys } from '$lib/domain/keys';
	import { storage } from '$lib/services/storage';
	import type { Quiz } from '$lib/content/types';

	let { quiz }: { quiz: Quiz } = $props();

	const help = $derived(quiz.help);
	const quizId = $derived(quiz.id);
	const table = $derived(helpTableFor(quiz));

	let open = $state(false);

	$effect(() => {
		// First visit to this quiz opens the panel unprompted, so the rules are
		// read before the first question rather than discovered by failing.
		(async () => {
			const raw = await storage.get(SettingsKeys.seenHelpMemory);
			const seen: string[] = raw ? JSON.parse(raw) : [];
			if (!seen.includes(quizId)) {
				open = true;
				await storage.set(
					SettingsKeys.seenHelpMemory,
					JSON.stringify([...seen, quizId])
				);
			}
		})();
	});
</script>

{#if help?.intro || help?.tips?.length || table}
	<section class="help">
		<button class="toggle" onclick={() => (open = !open)} aria-expanded={open}>
			<Icon name="help" size="1.05em" />
			<span>How this works</span>
			<span class="chevron" class:open><Icon name="chevronDown" size="1em" /></span>
		</button>

		{#if open}
			<div class="body" transition:slide={{ duration: 220 }}>
				{#if help?.intro}
					<p class="intro">{help.intro}</p>
				{/if}
				{#each help?.tips ?? [] as tip, i (tip.text)}
					<!-- Tips stagger in, so the panel reads as a short list rather
					     than a wall that appears all at once. -->
					<div class="tip" in:rise={{ delay: 60 + i * 45 }}>
						{#if tip.title}<h4>{tip.title}</h4>{/if}
						<p>{tip.text}</p>
					</div>
				{/each}

				<!-- The reference layer: every form the exercise can ask for, laid
				     out to be scanned. It is the quiz's own answer key, so it can
				     never drift from the questions. -->
				{#if table}
					<div class="table-wrap">
						<table>
							<thead>
								<tr>
									<th scope="col">{table.subjectHeader}</th>
									{#each table.columns as column (column)}
										<th scope="col">{column}</th>
									{/each}
								</tr>
							</thead>
							<tbody>
								{#each table.rows as row (row.subject)}
									<tr>
										<th
											scope="row"
											style={table.colorByGender && row.gender
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
		color: var(--ink-muted);
	}

	.tip {
		padding: 0.75rem 0.9rem;
		margin-bottom: 0.6rem;
		border-left: 3px solid var(--accent);
		border-radius: 0 8px 8px 0;
		background: var(--surface-alt);
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

	/* The article is part of the word, so it sits with it rather than in a
	   column of its own — lighter, because the noun is what's being looked up. */
	.article {
		margin-right: 0.35ch;
		font-weight: 500;
		opacity: 0.85;
	}

	/* The meaning sits under the noun rather than in a column of its own, so the
	   forms stay side by side where they can be compared. */
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
</style>
