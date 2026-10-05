<script lang="ts">
	// Build a line from word tiles, the story's version of the quiz word-order
	// gap (FillBlankQuiz): tap a tile to place it, tap a placed one to take it
	// back, rearrange freely, then Check. A wrong order keeps the tiles where
	// they are, so the learner fixes it instead of starting over.
	let {
		tiles,
		target,
		bubbles = false,
		onright,
		onwrong,
		ontap
	}: {
		/** The tiles on offer, already shuffled and resolved. */
		tiles: string[];
		/** The right order. */
		target: string[];
		bubbles?: boolean;
		onright: (el: Element | null) => void;
		onwrong: (el: Element | null) => void;
		ontap?: () => void;
	} = $props();

	/** Indices into `tiles`, in the order placed. */
	let built = $state<number[]>([]);
	let solved = $state(false);
	let wrong = $state(false);
	const full = $derived(built.length === target.length);

	function place(i: number) {
		if (solved || built.includes(i) || full) return;
		built = [...built, i];
		wrong = false;
		ontap?.();
	}
	function takeBack(pos: number) {
		if (solved) return;
		built = built.filter((_, p) => p !== pos);
		wrong = false;
		ontap?.();
	}
	function check(e: MouseEvent) {
		const el = e.currentTarget as Element;
		if (built.every((i, p) => tiles[i] === target[p])) {
			solved = true;
			onright(el);
		} else {
			wrong = true;
			onwrong(el);
		}
	}
	function onkey(e: KeyboardEvent) {
		if (e.key === 'Backspace' && built.length && !solved) {
			e.preventDefault();
			takeBack(built.length - 1);
		}
	}
</script>

<!-- svelte-ignore a11y_no_static_element_interactions -->
<div class="builder" onkeydown={onkey}>
	<div class="answer" class:wrong class:solved lang="de" aria-live="polite">
		{#if !built.length}
			<span class="empty">…</span>
		{/if}
		{#each built as i, pos (i)}
			<button
				class="tile placed"
				class:bubble={bubbles}
				disabled={solved}
				aria-label="{tiles[i]}, take back"
				onclick={() => takeBack(pos)}>{tiles[i]}</button>
		{/each}
	</div>
	<div class="bank" role="group" aria-label="Word tiles">
		{#each tiles as t, i (i)}
			<button class="tile" class:bubble={bubbles} lang="de" disabled={solved || built.includes(i)} onclick={() => place(i)}
				>{t}</button>
		{/each}
	</div>
	{#if !solved}
		<p class="hint">Tap a placed word to take it back.</p>
		{#if full}
			<button class="btn check" onclick={check}>Check</button>
		{/if}
	{/if}
</div>

<style>
	.builder {
		display: grid;
		gap: 0.6rem;
		width: 100%;
	}
	.answer {
		display: flex;
		flex-wrap: wrap;
		gap: 0.4rem;
		min-height: 3.1rem;
		align-items: center;
		padding: 0.45rem 0.55rem;
		border-bottom: 2px dashed var(--line-strong);
		transition: border-color 160ms ease, background 160ms ease;
	}
	.answer.wrong {
		border-color: var(--wrong);
		background: var(--wrong-bg);
		animation: shake 320ms ease;
	}
	.answer.solved {
		border-color: var(--right);
		border-bottom-style: solid;
		background: var(--right-bg);
	}
	.empty {
		color: var(--ink-muted);
		font-size: var(--step-1);
	}
	.bank {
		display: flex;
		flex-wrap: wrap;
		gap: 0.5rem;
	}
	.tile {
		background: var(--surface);
		border: 1.5px solid var(--line-strong);
		border-radius: var(--radius-sm);
		padding: 0.6rem 1rem;
		cursor: pointer;
		font-size: var(--step-0);
		font-weight: 600;
		color: var(--heading);
		box-shadow: 0 2px 0 var(--paper-highest), 0 4px 10px rgb(31 58 95 / 0.08);
		transition: transform 110ms ease, border-color 110ms ease, opacity 110ms ease;
	}
	.tile.bubble {
		border-radius: 999px;
	}
	.tile:hover:not(:disabled) {
		transform: translateY(-2px);
		border-color: var(--accent);
	}
	.tile:active:not(:disabled) {
		transform: translateY(1px);
	}
	/* Used tiles keep their place in the bank, so it never reflows. */
	.bank .tile:disabled {
		opacity: 0.28;
		cursor: default;
		box-shadow: none;
	}
	.tile.placed {
		background: #fbf1dc;
		border-color: #d9a441;
		padding: 0.45rem 0.8rem;
	}
	.tile.placed:disabled {
		opacity: 1;
		cursor: default;
	}
	.hint {
		margin: 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}
	.check {
		justify-self: start;
	}
	@keyframes shake {
		25% {
			transform: translateX(-4px);
		}
		75% {
			transform: translateX(4px);
		}
	}
	@media (prefers-reduced-motion: reduce) {
		.answer.wrong {
			animation: none;
		}
	}
</style>
