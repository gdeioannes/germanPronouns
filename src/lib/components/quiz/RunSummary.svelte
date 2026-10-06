<script lang="ts">
	// The card a drill ends on: how the run went, where the streak stands,
	// and the slips worth another look. The run is over whatever the score —
	// that is the point of it — and the exercise is marked either way: a done
	// tick from eight of ten, a "try again" mark below that, and the medal
	// once the streak has earned one. The way on (try again, next quiz, the
	// deck) is the page's finish bar, the same for every kind of exercise.
	import Icon from '$lib/icons/Icon.svelte';
	import RibbonBadge from '../RibbonBadge.svelte';
	import { pop } from '$lib/motion';
	import { nextMedal, RUN_PASS_MARK, TIER_LABELS, type RibbonTier } from '$lib/domain/progress';

	let {
		right,
		total,
		bestInRun,
		streak,
		earned,
		medal,
		missed = [],
		locale,
		passed
	}: {
		right: number;
		total: number;
		/** The longest streak inside this run. */
		bestInRun: number;
		/** The streak as it stands now, carried into the next run. */
		streak: number;
		/** A medal earned during this run, if one was. */
		earned: RibbonTier | null;
		/** The medal the exercise holds overall. */
		medal: RibbonTier | null;
		/** The answers that were missed, in the learner's own language order. */
		missed?: string[];
		locale: string;
		/** Eight of ten or better: the exercise is done. Otherwise it was a try. */
		passed: boolean;
	} = $props();

	const next = $derived(nextMedal(streak));
	/** A sentence missed twice (it came back round) is listed once. */
	const slips = $derived([...new Set(missed)]);
	const title = $derived(
		right === total ? 'Every one right!' : passed ? 'Exercise done.' : 'Not this time — try again.'
	);
</script>

<section class="summary" in:pop aria-live="polite">
	<p class="eyebrow">{passed ? 'Exercise done' : 'Run finished'}</p>
	<h2>{title}</h2>
	{#if !passed}
		<p class="need">The exercise is marked for a retry — {RUN_PASS_MARK} of {total} right earns the tick. The run is on record, and the streak stands.</p>
	{/if}

	<dl class="score">
		<div>
			<dt>Right</dt>
			<dd class="tnum">{right} <span class="of">of {total}</span></dd>
		</div>
		<div>
			<dt>Best streak this run</dt>
			<dd class="tnum">{bestInRun}</dd>
		</div>
		<div>
			<dt>Medal</dt>
			<dd>
				{#if medal}
					<RibbonBadge tier={medal} width={13} animate={earned !== null} />
					{TIER_LABELS[medal]}
				{:else}
					<span class="none">none yet</span>
				{/if}
			</dd>
		</div>
	</dl>

	{#if earned}
		<p class="medal-line">
			<Icon name="flame" size="1em" />
			You earned the {TIER_LABELS[earned].toLowerCase()} medal in this run.
		</p>
	{/if}

	<p class="streak-line">
		{#if streak > 0 && next}
			Your streak stands at <strong class="tnum">{streak}</strong> — <strong class="tnum">{next.at - streak}</strong> more in a row for {TIER_LABELS[next.tier].toLowerCase()}. It carries on into the next run.
		{:else if streak > 0}
			Your streak stands at <strong class="tnum">{streak}</strong>. Gold is yours; the flame just keeps burning.
		{:else if next}
			The streak starts fresh: <strong class="tnum">{next.at}</strong> in a row earns {TIER_LABELS[next.tier].toLowerCase()}.
		{:else}
			Gold is yours. The next run is for the sentences themselves.
		{/if}
	</p>

	{#if slips.length}
		<!-- The slips, kept: they are what the next run is for. -->
		<div class="missed">
			<p class="missed-head">Worth another look</p>
			<ul lang={locale}>
				{#each slips as text (text)}
					<li>{text}</li>
				{/each}
			</ul>
		</div>
	{/if}

	<p class="note">Try again and the bar starts fresh; your streak carries on.</p>
</section>

<style>
	/* A column that takes the exercise's room and no more: the slips scroll
	   inside it, so the way on is always in view and the page never scrolls. */
	.summary {
		position: relative;
		display: flex;
		flex-direction: column;
		flex: 1 1 auto;
		min-height: 0;
		padding: 1.5rem 1.75rem 1.6rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
	}

	.summary > * {
		flex: none;
	}

	h2 {
		margin: 0.2rem 0 0;
		font-size: var(--step-3);
		line-height: 1.1;
	}

	.score {
		display: flex;
		flex-wrap: wrap;
		gap: 1.4rem 2rem;
		margin: 1rem 0 0;
	}

	.score div {
		display: flex;
		flex-direction: column;
		gap: 0.15rem;
	}

	dt {
		font-size: 0.7rem;
		font-weight: 700;
		letter-spacing: 0.07em;
		text-transform: uppercase;
		color: var(--ink-muted);
	}

	dd {
		display: flex;
		align-items: center;
		gap: 0.4rem;
		margin: 0;
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-2);
		font-weight: 700;
		line-height: 1;
		color: var(--heading);
	}

	.of,
	.none {
		font-family: Inter, ui-sans-serif, system-ui, sans-serif;
		font-size: var(--step--1);
		font-weight: 500;
		color: var(--ink-muted);
	}

	.need {
		margin: 0.6rem 0 0;
		color: var(--ink-muted);
	}

	.medal-line {
		display: flex;
		align-items: center;
		gap: 0.4rem;
		margin: 1rem 0 0;
		font-weight: 700;
		color: var(--accent-ink);
	}

	.streak-line {
		margin: 0.8rem 0 0;
		font-size: var(--step-0);
		color: var(--ink);
	}

	.missed {
		flex: 0 1 auto;
		min-height: 0;
		overflow-y: auto;
		margin: 1rem 0 0;
		padding: 0.75rem 0.95rem;
		border-radius: var(--radius-sm);
		background: var(--surface-alt);
	}

	.missed-head {
		margin: 0 0 0.35rem;
		font-size: 0.7rem;
		font-weight: 700;
		letter-spacing: 0.07em;
		text-transform: uppercase;
		color: var(--ink-muted);
	}

	.missed ul {
		margin: 0;
		padding-left: 1.1rem;
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-0);
		font-weight: 600;
		color: var(--ink);
	}

	.missed li + li {
		margin-top: 0.2rem;
	}

	.note {
		margin: 1rem 0 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	@media (max-width: 36rem) {
		.summary {
			padding: 1.1rem 1rem 1.1rem;
		}
		h2 {
			font-size: var(--step-2);
		}
		.score {
			gap: 0.9rem 1.4rem;
		}
	}
</style>
