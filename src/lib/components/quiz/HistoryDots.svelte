<script lang="ts">
	// How the learner has done on this very question before: one dot per past
	// answer, oldest left, newest right (ringed). Nothing when it's new, so a
	// first-timer's card looks as it always did. Static — no motion to calm.
	import type { Verdict } from '$lib/domain/questionHistory';
	import { t, tn } from '$lib/i18n/t';

	let { verdicts }: { verdicts: Verdict[] } = $props();

	const label = $derived(
		tn(verdicts.length, 'Seen once before: {list}', 'Seen {n} times before: {list}', {
			list: verdicts.map((v) => (v.c ? t('right') : t('wrong'))).join(', ')
		})
	);
</script>

{#if verdicts.length}
	<span class="dots" role="img" aria-label={label} title={label}>
		{#each verdicts as v, i (i)}
			<i class:right={v.c} class:wrong={!v.c} class:last={i === verdicts.length - 1}></i>
		{/each}
	</span>
{/if}

<style>
	.dots {
		display: inline-flex;
		align-items: center;
		gap: 5px;
		padding: 0 2px;
		/* Same height as the chips it sits beside, so the row never jumps. */
		min-height: 1.6rem;
	}
	i {
		display: block;
		width: 7px;
		height: 7px;
		border-radius: 50%;
		background: var(--line-strong);
	}
	i.right {
		background: var(--right);
	}
	i.wrong {
		background: var(--wrong);
	}
	i.last {
		box-shadow:
			0 0 0 2px var(--surface),
			0 0 0 3px currentColor;
		color: var(--line-strong);
	}
	i.last.right {
		color: var(--right);
	}
	i.last.wrong {
		color: var(--wrong);
	}
</style>
