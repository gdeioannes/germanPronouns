<script lang="ts">
	// The medal ladder over a drill, kept as quiet as the mode switch it
	// replaced: three ways of answering, easiest first. Each pill carries a
	// slot for its medal — an outline until it is won, the metal after. On
	// the LADDER_PASSth right answer on a step in a run the run is passed,
	// the stamp shows the medal, and the medal flies here and drops into its
	// slot (motion/fx). What each step is worth is otherwise told in the run
	// summary, not printed here.
	import RibbonBadge from '../RibbonBadge.svelte';
	import {
		LADDER_PASS,
		LADDER_TIERS,
		ladderStepEarned,
		TIER_COLORS,
		TIER_LABELS,
		type LadderRecord,
		type RibbonTier
	} from '$lib/domain/progress';
	import { effectsCalm, fx } from '$lib/motion/fx.svelte';
	import type { Snippet } from 'svelte';

	let {
		steps,
		record,
		active,
		right,
		counting = true,
		disabled = false,
		onpick,
		children
	}: {
		/** One per rung, easiest first: what the learner does there. */
		steps: { label: string; hint: string }[];
		record: LadderRecord;
		active: number;
		/** Right answers on the step in play, this run. */
		right: number;
		/** False when this run earns no medal (the repeat list): the label says so. */
		counting?: boolean;
		disabled?: boolean;
		onpick: (step: number) => void;
		/**
		 * More controls carried at the bar's right end, after a divider — the
		 * deck's "to repeat" filter — so the row is one control, not two.
		 */
		children?: Snippet;
	} = $props();

	/** The sparkles thrown out round a pill as its medal lands. */
	const SPARKS = Array.from({ length: 10 }, (_, i) => (i * 360) / 10);

	/** Pops the pill when its medal lands: a bounce and a ring in its metal. */
	function popOn(node: HTMLElement, args: { tier: RibbonTier; landed: typeof fx.landed }) {
		let seen = args.landed?.id;
		return {
			update(next: { tier: RibbonTier; landed: typeof fx.landed }) {
				const landed = next.landed;
				if (!landed || landed.id === seen) return;
				seen = landed.id;
				if (landed.tier !== next.tier || effectsCalm()) return;
				const ring = TIER_COLORS[next.tier];
				node.animate(
					[
						{ transform: 'scale(1)', boxShadow: `0 0 0 0 ${ring}00` },
						{ transform: 'scale(1.18)', boxShadow: `0 0 0 4px ${ring}aa`, offset: 0.3 },
						{ transform: 'scale(0.96)', boxShadow: `0 0 0 10px ${ring}33`, offset: 0.6 },
						{ transform: 'scale(1)', boxShadow: `0 0 0 16px ${ring}00` }
					],
					{ duration: 700, easing: 'cubic-bezier(0.34, 1.56, 0.64, 1)' }
				);
			}
		};
	}
</script>

<div class="ladder" class:wide={children} role="group" aria-label="Cards">
	{#each steps as step, i (step.label)}
		{@const tier = LADDER_TIERS[i]}
		{@const won = ladderStepEarned(record, i)}
		<!-- In flight, the medal is not here yet: the slot stays empty till it lands. -->
		{@const shown = won && fx.landing !== tier}
		<button
			type="button"
			class="step"
			class:last={i === steps.length - 1}
			class:won={shown}
			style:--metal={TIER_COLORS[tier]}
			aria-pressed={i === active}
			aria-label="{step.label}: {step.hint} {won
				? `${TIER_LABELS[tier]} medal earned.`
				: `${LADDER_PASS} right in a run earns ${TIER_LABELS[tier].toLowerCase()}${i === active && counting ? `; ${right} so far` : ''}.`}"
			title={step.hint}
			{disabled}
			onclick={() => onpick(i)}
			use:popOn={{ tier, landed: fx.landed }}
		>
			<span class="slot" data-medal-slot={tier}>
				{#if shown}
					<RibbonBadge {tier} width={10} />
				{:else}
					<svg class="empty" width="10" height="18" viewBox="0 0 22 40" aria-hidden="true">
						<path d="M1.5 1.5 H20.5 V37 L11 29 L1.5 37 Z" />
					</svg>
				{/if}
			</span>
			{step.label}
			{#if fx.landed?.tier === tier}
				{#key fx.landed.id}
					<span class="sparks" aria-hidden="true">
						{#each SPARKS as angle (angle)}
							<i style:--angle="{angle}deg"></i>
						{/each}
					</span>
				{/key}
			{/if}
		</button>
	{/each}
	{#if children}
		<span class="divider" aria-hidden="true"></span>
		{@render children()}
	{/if}
</div>

<style>
	.ladder {
		display: inline-flex;
		align-items: stretch;
		padding: 0.2rem;
		border: 1px solid var(--line);
		border-radius: 999px;
		background: var(--surface-alt);
	}

	/* Carrying more controls, the bar spans the row: the steps on the left,
	   the extras pushed to the right end. */
	.ladder.wide {
		display: flex;
		width: 100%;
	}

	.divider {
		flex: none;
		width: 1px;
		margin: 0.35rem 0.25rem 0.35rem auto;
		background: var(--line-strong);
	}

	.step {
		position: relative;
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		padding: 0.38rem 0.85rem 0.38rem 0.7rem;
		border: 1px solid transparent;
		border-radius: 999px;
		background: none;
		color: var(--ink-muted);
		font-size: 0.78rem;
		font-weight: 700;
		letter-spacing: 0.03em;
		cursor: pointer;
		transition:
			background var(--fast) var(--ease-out),
			color var(--fast) var(--ease-out);
	}

	/* A won step keeps a faint wash of its metal, so the ladder reads at a glance. */
	.step.won {
		background: color-mix(in srgb, var(--metal) 14%, transparent);
		color: var(--ink);
	}

	.step[aria-pressed='true'] {
		background: var(--heading);
		color: var(--paper);
		box-shadow: 0 1px 2px rgb(0 0 0 / 0.12);
	}

	.step:disabled {
		cursor: default;
	}

	/* One segmented bar: round only at its two ends, straight between, so
	   a middle step in play is a clean block rather than a lozenge. */
	.step {
		border-radius: 0;
	}

	.step:first-child {
		border-radius: 999px 0 0 999px;
	}

	/* The top step is rounded on its right too, even with more controls
	   after the divider: the ladder's own end. */
	.step.last {
		border-radius: 0 999px 999px 0;
	}

	.slot {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 10px;
		height: 18px;
	}

	/* A medal still to win: just its outline, dashed, in the pill's own ink. */
	.empty path {
		fill: none;
		stroke: currentColor;
		stroke-width: 2.5;
		stroke-dasharray: 4 3;
		opacity: 0.5;
	}

	/* The landing: sparks in the metal thrown out from the slot. */
	.sparks {
		position: absolute;
		left: calc(0.7rem + 5px);
		top: 50%;
		pointer-events: none;
	}

	.sparks i {
		position: absolute;
		width: 4px;
		height: 4px;
		margin: -2px;
		border-radius: 50%;
		background: var(--metal);
		animation: spark 650ms cubic-bezier(0.2, 0.7, 0.3, 1) forwards;
	}

	.sparks i:nth-child(even) {
		background: color-mix(in srgb, var(--metal) 40%, #fff);
	}

	@keyframes spark {
		from {
			opacity: 1;
			transform: rotate(var(--angle)) translateX(0) scale(1.3);
		}
		to {
			opacity: 0;
			transform: rotate(var(--angle)) translateX(26px) scale(0.4);
		}
	}

	:global(html[data-effects='calm']) .sparks {
		display: none;
	}

	@media (prefers-reduced-motion: reduce) {
		.sparks {
			display: none;
		}
	}

	@media (max-width: 36rem) {
		.step {
			gap: 0.3rem;
			padding: 0.34rem 0.6rem 0.34rem 0.5rem;
			letter-spacing: 0.01em;
		}
		.sparks {
			left: calc(0.5rem + 5px);
		}
	}
</style>
