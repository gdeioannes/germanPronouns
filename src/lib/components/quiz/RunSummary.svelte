<script lang="ts">
	import { boldNumbers } from '$lib/i18n/t';
	import { lang } from '$lib/i18n/lang.svelte';
	/** A medal name, translated and lower-cased for the middle of a sentence. */
	const low = (tier: string) => t(tier).toLocaleLowerCase(lang.current);
	import { t } from '$lib/i18n/t';
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
		passed,
		ladder = null,
		medalRule = null
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
		/**
		 * A medal-ladder drill: the step just played, its right answers this
		 * run against the pass that earns its medal, whether this run could
		 * earn one at all, and the step above it with a way straight up.
		 */
		ladder?: {
			label: string;
			tier: RibbonTier;
			right: number;
			at: number;
			counting: boolean;
			earned: boolean;
			up: { label: string; tier: RibbonTier; hint: string; onClimb: () => void } | null;
		} | null;
		/** A drill whose medal is its run's score: the rule, said instead of the streak's. */
		medalRule?: string | null;
	} = $props();

	const next = $derived(nextMedal(streak));
	/** A sentence missed twice (it came back round) is listed once. */
	const slips = $derived([...new Set(missed)]);
	const title = $derived(
		right === total ? t('Every one right!') : passed ? t('Exercise done.') : t('Not this time — try again.')
	);
</script>

<section class="summary" in:pop aria-live="polite">
	<p class="eyebrow">{passed ? t('Exercise done') : t('Run finished')}</p>
	<h2>{title}</h2>
	{#if !passed}
		<p class="need">{t('The exercise is marked for a retry — {pass} of {total} right earns the tick. The run is on record, and the streak stands.', { pass: RUN_PASS_MARK, total })}</p>
	{/if}

	<dl class="score">
		<div>
			<dt>{t('Right')}</dt>
			<dd class="tnum">{right} <span class="of">{t('of {total}', { total })}</span></dd>
		</div>
		<div>
			<dt>{t('Best streak this run')}</dt>
			<dd class="tnum">{bestInRun}</dd>
		</div>
		<div>
			<dt>{t('Medal')}</dt>
			<dd>
				{#if medal}
					<RibbonBadge tier={medal} width={13} animate={earned !== null} />
					{t(TIER_LABELS[medal])}
				{:else}
					<span class="none">{t('none yet')}</span>
				{/if}
			</dd>
		</div>
	</dl>

	{#if earned}
		<p class="medal-line">
			<Icon name="flame" size="1em" />
			{t('You earned the {tier} medal in this run.', { tier: low(TIER_LABELS[earned]) })}
		</p>
	{/if}

	{#if ladder}
		{#if ladder.earned && ladder.up}
			<!-- The way up is the finish bar's first button, "Try for silver". -->
			<div class="climb">
				<p>
					<RibbonBadge tier={ladder.up.tier} width={12} />
					<span><strong>{t('{tier} is next:', { tier: t(TIER_LABELS[ladder.up.tier]) })}</strong> {ladder.up.hint}</span>
				</p>
			</div>
		{:else if ladder.earned}
			<p class="streak-line">
				{t('Gold is yours: you write them from memory. Come back now and then to keep them fresh.')}
			</p>
		{:else if !ladder.counting}
			<p class="streak-line">
				{t('A run on just some of the words practises them; the medals are for passing the whole deck.')}
			</p>
		{:else}
			<p class="streak-line">
				{@html boldNumbers(t('{at} right on {step} in one run earns {tier} — this run had {right}.', { at: ladder.at, step: ladder.label, tier: low(TIER_LABELS[ladder.tier]), right: ladder.right }))}
			</p>
		{/if}
	{:else if medalRule}
		<p class="streak-line">{medalRule}</p>
	{:else}
		<p class="streak-line">
			{#if streak > 0 && next}
				{@html boldNumbers(t('Your streak stands at {streak} — {more} more in a row for {tier}. It carries on into the next run.', { streak, more: next.at - streak, tier: low(TIER_LABELS[next.tier]) }))}
			{:else if streak > 0}
				{@html boldNumbers(t('Your streak stands at {streak}. Gold is yours; the flame just keeps burning.', { streak }))}
			{:else if next}
				{@html boldNumbers(t('The streak starts fresh: {at} in a row earns {tier}.', { at: next.at, tier: low(TIER_LABELS[next.tier]) }))}
			{:else}
				{t('Gold is yours. The next run is for the sentences themselves.')}
			{/if}
		</p>
	{/if}

	{#if slips.length}
		<!-- The slips, kept: they are what the next run is for. -->
		<div class="missed">
			<p class="missed-head">{t('Worth another look')}</p>
			<ul lang={locale}>
				{#each slips as text (text)}
					<li>{text}</li>
				{/each}
			</ul>
		</div>
	{/if}

	{#if ladder?.earned && ladder.up}
		<p class="note">{t('Try for {tier} and a fresh run starts on {step}.', { tier: low(TIER_LABELS[ladder.up.tier]), step: ladder.up.label })}</p>
	{:else}
		<p class="note">{ladder || medalRule ? t('Try again and the bar starts fresh.') : t('Try again and the bar starts fresh; your streak carries on.')}</p>
	{/if}
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

	.climb {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		justify-content: space-between;
		gap: 0.6rem 1rem;
		margin: 1rem 0 0;
		padding: 0.75rem 0.95rem;
		border: 1px solid var(--line-strong);
		border-radius: var(--radius-sm);
		background: var(--surface-alt);
	}

	.climb p {
		display: flex;
		align-items: center;
		gap: 0.55rem;
		margin: 0;
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
