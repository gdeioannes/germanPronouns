<script lang="ts">
	// The streak bar over a streak-driven quiz: flame, count against the
	// goal, lap pips, the three lives, and the personal best. Shared by the
	// fill-blank and flashcard quizzes so the two never drift apart.
	import Icon from '$lib/icons/Icon.svelte';
	import { STREAK_LAP_SIZE, STREAK_MISSES_ALLOWED } from '$lib/domain/progress';
	import { bumpOn, heat } from '$lib/motion/fx.svelte';

	let {
		streak,
		misses,
		best,
		goal
	}: { streak: number; misses: number; best: number; goal: number } = $props();

	const lapProgress = $derived(streak % STREAK_LAP_SIZE);
</script>

<section class="tracker">
	<span class="flame" class:hot={streak > 0} data-heat={heat(streak)}><Icon name="flame" size="1.1em" /></span>
	<div class="streak">
		<span class="eyebrow">Streak</span>
		<span class="value tnum" use:bumpOn={streak}>{streak}</span>
		<span class="goal tnum">/ {goal}</span>
	</div>
	<div class="pips" aria-hidden="true">
		{#each { length: STREAK_LAP_SIZE } as _, i (i)}
			<span class="pip" class:lit={i < lapProgress || (streak > 0 && lapProgress === 0)}></span>
		{/each}
	</div>
	<span class="lives tnum" title="Mistakes this run">
		<span class="sr-only">{misses} of {STREAK_MISSES_ALLOWED} mistakes used</span>
		{#each { length: STREAK_MISSES_ALLOWED } as _, i (i)}
			<span class="life" class:lost={i < misses} aria-hidden="true">×</span>
		{/each}
	</span>
	<span class="best tnum">Best {best}</span>
</section>

<style>
	.tracker {
		display: flex;
		align-items: center;
		gap: 0.85rem;
		padding: 0.7rem 1rem;
		margin-bottom: 1rem;
		border: 1px solid var(--line);
		border-radius: var(--radius-sm);
		background: var(--surface-alt);
	}

	.flame {
		display: inline-flex;
		color: var(--outline);
		transition: color var(--medium) var(--ease-out);
	}

	.flame.hot {
		color: var(--accent-ink);
	}

	.streak {
		display: flex;
		align-items: baseline;
		gap: 0.35rem;
	}

	.streak .eyebrow {
		font-size: 0.66rem;
	}

	.value {
		font-size: var(--step-2);
		font-weight: 800;
		line-height: 1;
		color: var(--heading);
		font-variant-numeric: tabular-nums;
	}

	.goal,
	.best {
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.best {
		margin-left: auto;
	}

	/* The three slips a run survives: a cross lights up for each one used. */
	.lives {
		display: inline-flex;
		gap: 0.15rem;
		font-size: var(--step--1);
		font-weight: 800;
		line-height: 1;
		color: var(--outline);
	}

	.life.lost {
		color: var(--wrong);
	}

	.pips {
		display: flex;
		gap: 0.28rem;
	}

	.pip {
		width: 0.46rem;
		height: 0.46rem;
		border-radius: 50%;
		background: var(--outline);
		transition:
			background var(--medium) var(--ease-spring),
			transform var(--medium) var(--ease-spring);
	}

	.pip.lit {
		background: var(--accent);
		transform: scale(1.25);
	}

	@media (max-width: 36rem) {
		.tracker {
			gap: 0.6rem;
			padding: 0.4rem 0.75rem;
			margin-bottom: 0.6rem;
		}
		.value {
			font-size: var(--step-1);
		}
	}
</style>
