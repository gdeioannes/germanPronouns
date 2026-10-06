<script lang="ts">
	// The bar over a drill: a chevron track, one step per answer of the run,
	// each step carrying its German number word — eins, zwei, drei … zehn —
	// so even the progress bar teaches something. A step turns green for a
	// right answer and red for a miss (it only ever fills), the live
	// one is navy. Then the streak with its flame, the next medal it is
	// heading for, and the best. Shared by the fill-blank and flashcard
	// quizzes so the two never drift.
	import Icon from '$lib/icons/Icon.svelte';
	import RibbonBadge from '../RibbonBadge.svelte';
	import { medalForStreak, nextMedal, TIER_LABELS } from '$lib/domain/progress';
	import { bumpOn, heat } from '$lib/motion/fx.svelte';

	let {
		results,
		total,
		streak,
		best
	}: { results: ('right' | 'wrong')[]; total: number; streak: number; best: number } = $props();

	const answered = $derived(results.length);

	/** The German number words a ten-step run counts in. */
	const WORDS = ['eins', 'zwei', 'drei', 'vier', 'fünf', 'sechs', 'sieben', 'acht', 'neun', 'zehn'];
	const word = (i: number) => WORDS[i] ?? String(i + 1);
	/** The live step's word, for the eyebrow — on a phone the steps show digits. */
	const nowWord = $derived(answered < total ? word(answered) : WORDS[total - 1] ?? String(total));
	const medal = $derived(medalForStreak(best));
	const next = $derived(nextMedal(streak));
</script>

<section class="tracker" aria-label="Your run">
	<div class="run">
		<span class="eyebrow tnum">Question {Math.min(answered + 1, total)} of {total} <span class="now-word" lang="de">· {nowWord}</span></span>
		<div
			class="bar"
			role="progressbar"
			aria-label="Run progress"
			aria-valuemin={0}
			aria-valuemax={total}
			aria-valuenow={answered}
		>
			{#each { length: total } as _, i (i)}
				<span
					class="step"
					class:right={results[i] === 'right'}
					class:wrong={results[i] === 'wrong'}
					class:now={i === answered}
					style:z-index={total - i}
					lang="de"
					><span class="word">{word(i)}</span><span class="digit tnum">{i + 1}</span></span
				>
			{/each}
		</div>
	</div>

	<div class="streak">
		<span class="flame" class:hot={streak > 0} data-heat={heat(streak)}><Icon name="flame" size="1.1em" /></span>
		<span class="value tnum" use:bumpOn={streak}>{streak}</span>
		<span class="label">in a row</span>
	</div>

	<!-- Where the streak is heading: the medal it earns next, or that it has them all. -->
	<span class="next tnum">
		{#if next}
			{next.at - streak} more for {TIER_LABELS[next.tier].toLowerCase()}
		{:else}
			Gold — keep it burning
		{/if}
	</span>

	<span class="best tnum" title="Your best streak here">
		{#if medal}<RibbonBadge tier={medal} width={11} />{/if}
		Best {best}
	</span>
</section>

<style>
	.tracker {
		flex: none;
		display: grid;
		grid-template-columns: 1fr auto auto;
		grid-template-areas:
			'run run run'
			'streak next best';
		align-items: center;
		column-gap: 0.85rem;
		row-gap: 0.45rem;
		padding: 0.6rem 1rem 0.65rem;
		margin-bottom: 1rem;
		border: 1px solid var(--line);
		border-radius: var(--radius-sm);
		background: var(--surface-alt);
	}

	.run {
		grid-area: run;
		display: flex;
		flex-direction: column;
		gap: 0.3rem;
	}

	.eyebrow {
		font-size: 0.66rem;
	}

	/* The run bar: a chevron track, one step per answer. Each step is an
	   arrow that tucks into the next (the notch is cut by clip-path and the
	   steps overlap by the arrow's depth). A step lights when its answer is
	   given — right or wrong, it stays lit — so the bar never empties. */
	.bar {
		--arrow: 0.6rem;
		position: relative;
		display: flex;
		height: 1.65rem;
		padding-right: 0;
		overflow: hidden;
		border-radius: 999px;
	}

	.step {
		position: relative;
		flex: 1 1 0;
		min-width: 0;
		display: inline-flex;
		align-items: center;
		justify-content: center;
		margin-right: calc(var(--arrow) * -1 + 1px);
		padding: 0 calc(var(--arrow) + 0.15rem) 0 calc(var(--arrow) + 0.3rem);
		background: var(--paper-highest, var(--surface-alt));
		box-shadow: inset 0 0 0 1px var(--line);
		color: var(--ink-muted);
		font-size: 0.7rem;
		font-weight: 800;
		letter-spacing: 0.07em;
		text-transform: uppercase;
		white-space: nowrap;
		clip-path: polygon(
			0 0,
			calc(100% - var(--arrow)) 0,
			100% 50%,
			calc(100% - var(--arrow)) 100%,
			0 100%,
			var(--arrow) 50%
		);
		transition:
			background var(--medium) var(--ease-out),
			color var(--medium) var(--ease-out);
	}

	/* The first step has a flat start; the last a flat end. */
	.step:first-child {
		clip-path: polygon(0 0, calc(100% - var(--arrow)) 0, 100% 50%, calc(100% - var(--arrow)) 100%, 0 100%);
		padding-left: 0.45rem;
	}

	.step:last-child {
		margin-right: 0;
		padding-right: 0.6rem;
		clip-path: polygon(0 0, 100% 0, 100% 100%, 0 100%, var(--arrow) 50%);
	}

	/* Flat colour, nothing else: green for right, red for a miss, navy for
	   the step in play. */
	.step.right {
		background: var(--right);
		box-shadow: none;
		color: #fff;
	}

	.step.wrong {
		background: var(--wrong);
		box-shadow: none;
		color: #fff;
	}

	.step.now {
		background: var(--navy);
		box-shadow: none;
		color: var(--paper);
	}

	.step .word {
		overflow: hidden;
		text-overflow: clip;
	}

	.step .digit,
	.now-word {
		display: none;
	}

	/* On a phone ten words will not fit: the steps show digits and the live
	   word moves up into the eyebrow, so the German is still there. */
	@media (max-width: 40rem) {
		.step .word {
			display: none;
		}
		.step .digit {
			display: inline;
		}
		.now-word {
			display: inline;
			font-weight: 700;
			letter-spacing: 0.02em;
			text-transform: none;
			color: var(--accent-ink);
		}
		.bar {
			--arrow: 0.45rem;
			height: 1.35rem;
		}
		.step {
			padding: 0 calc(var(--arrow) + 0.05rem) 0 calc(var(--arrow) + 0.1rem);
		}
	}

	.streak {
		grid-area: streak;
		display: flex;
		align-items: baseline;
		gap: 0.35rem;
	}

	.flame {
		display: inline-flex;
		align-self: center;
		color: var(--outline);
		transition: color var(--medium) var(--ease-out);
	}

	.flame.hot {
		color: var(--accent-ink);
	}

	.value {
		font-size: var(--step-2);
		font-weight: 800;
		line-height: 1;
		color: var(--heading);
		font-variant-numeric: tabular-nums;
	}

	.label,
	.next,
	.best {
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.next {
		grid-area: next;
		font-weight: 600;
	}

	.best {
		grid-area: best;
		display: inline-flex;
		align-items: center;
		gap: 0.3rem;
		justify-self: end;
	}

	@media (max-width: 36rem) {
		.tracker {
			column-gap: 0.6rem;
			row-gap: 0.35rem;
			padding: 0.45rem 0.75rem 0.5rem;
			margin-bottom: 0.6rem;
		}
		.value {
			font-size: var(--step-1);
		}
	}
</style>
