<script lang="ts">
	// The mark a finished exercise carries: its medal ribbon when the streak
	// has earned one, a green tick when the last run passed, or a terracotta
	// "try again" when it went badly. One component, so every list draws the
	// same scale — nothing, in progress, retry, done, medal.
	import Icon from '$lib/icons/Icon.svelte';
	import RibbonBadge from './RibbonBadge.svelte';
	import type { QuizMark } from '$lib/domain/progress';

	let {
		mark,
		width = 14,
		/** Plays the ribbon's hoist-in — for a medal just earned. */
		animate = false
	}: { mark: QuizMark; width?: number; animate?: boolean } = $props();
</script>

{#if mark === 'done'}
	<span class="mark done" style:--size="{width * 1.3}px" title="Done" role="img" aria-label="Done">
		<Icon name="check" size="70%" />
	</span>
{:else if mark === 'retry'}
	<span class="mark retry" style:--size="{width * 1.3}px" title="Try again" role="img" aria-label="Try again">
		<Icon name="repeat" size="70%" />
	</span>
{:else}
	<RibbonBadge tier={mark} {width} {animate} />
{/if}

<style>
	.mark {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		flex: none;
		width: var(--size);
		height: var(--size);
		border-radius: 50%;
		color: #fff;
	}

	.mark.done {
		background: var(--right);
	}

	.mark.retry {
		background: var(--accent-ink);
	}
</style>
