<script lang="ts">
	// The app's one way to offer "pick one of these answers": the serif choice
	// buttons with their little number chips, as the course quizzes draw them.
	// The level check uses it too, so a question looks the same everywhere —
	// it adds a selected state (a test acknowledges, it does not mark) and an
	// optional full-width "I don't know" at the end.
	let {
		choices,
		onpick,
		locale,
		label = 'Choose the answer',
		keys = true,
		radio = false,
		locked = false,
		right = null,
		wrong = null,
		selected,
		idk = null
	}: {
		choices: string[];
		/** Called with the option, or null for the "I don't know" button. */
		onpick: (option: string | null) => void;
		locale?: string;
		label?: string;
		/** Show the 1–4 keyboard chips (the caller wires the actual keys). */
		keys?: boolean;
		/** Radio semantics for a selection that stays on screen. */
		radio?: boolean;
		locked?: boolean;
		/** When locked: the right answer, and the wrong one that was picked. */
		right?: string | null;
		wrong?: string | null;
		/** The current selection: an option, null for "I don't know", undefined for none. */
		selected?: string | null;
		/** Label for the extra "I don't know" option; omit it to leave it out. */
		idk?: string | null;
	} = $props();
</script>

<div class="choices" role={radio ? 'radiogroup' : 'group'} aria-label={label}>
	{#each choices as option, i (i)}
		<button
			type="button"
			class="choice"
			role={radio ? 'radio' : undefined}
			aria-checked={radio ? selected === option : undefined}
			class:picked={!locked && selected === option}
			class:right={locked && option === right}
			class:wrong={locked && option === wrong}
			disabled={locked}
			lang={locale}
			onclick={() => onpick(option)}
			>{#if keys}<span class="key" aria-hidden="true">{i + 1}</span>{/if}{option}</button
		>
	{/each}
	{#if idk}
		<button
			type="button"
			class="choice idk"
			role={radio ? 'radio' : undefined}
			aria-checked={radio ? selected === null && selected !== undefined : undefined}
			class:picked={!locked && selected === null && selected !== undefined}
			disabled={locked}
			onclick={() => onpick(null)}>{idk}</button
		>
	{/if}
</div>

<style>
	/* Two by two, in the sentence's type — the quizzes' choose step. */
	.choices {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 0.5rem;
		margin: 1rem 0 0;
	}

	.choice {
		display: flex;
		align-items: center;
		gap: 0.6rem;
		min-height: 2.9rem;
		padding: 0.55rem 0.8rem;
		border: 1.5px solid var(--line-strong);
		border-radius: var(--radius-sm);
		background: var(--surface);
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: var(--step-0);
		font-weight: 600;
		color: var(--ink);
		text-align: left;
		cursor: pointer;
		transition:
			border-color var(--fast) var(--ease-out),
			background var(--fast) var(--ease-out),
			transform var(--fast) var(--ease-spring);
	}

	.choice:hover:not(:disabled) {
		border-color: var(--heading);
		transform: translateY(-1px);
	}

	.choice:active:not(:disabled) {
		transform: scale(0.97);
	}

	.choice:disabled {
		cursor: default;
	}

	.choice .key {
		flex: none;
		display: inline-grid;
		place-items: center;
		width: 1.35rem;
		height: 1.35rem;
		border-radius: 50%;
		background: var(--surface-alt);
		font-family: Inter, ui-sans-serif, system-ui, sans-serif;
		font-size: 0.7rem;
		font-weight: 800;
		color: var(--ink-muted);
	}

	/* A selection with no verdict: the placement test's "that landed". */
	.choice.picked {
		border-color: var(--heading);
		background: var(--heading);
		color: var(--surface);
	}

	.choice.picked .key {
		background: rgb(255 255 255 / 0.18);
		color: var(--surface);
	}

	/* After the answer: the right one green, a wrong pick red, the rest faded. */
	.choice.right {
		border-color: var(--right);
		background: var(--right-bg);
		color: var(--right);
	}

	.choice.wrong {
		border-color: var(--wrong);
		background: var(--wrong-bg);
		color: var(--wrong);
	}

	.choice:disabled:not(.right):not(.wrong) {
		opacity: 0.45;
	}

	/* The honest way out, quieter than the answers and spanning the row. */
	.choice.idk {
		grid-column: 1 / -1;
		justify-content: center;
		border-style: dashed;
		font-family: Inter, ui-sans-serif, system-ui, sans-serif;
		font-size: var(--step--1);
		font-weight: 600;
		color: var(--ink-muted);
	}
</style>
