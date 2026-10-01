<script lang="ts">
	// The "started, not finished" marker: a half-filled dot, with or without
	// its label. Sits where a finished exercise shows its medal ribbon, so the
	// two read as one scale — nothing, half, done.
	let { label = true, float = false }: {
		label?: boolean;
		/** Over a picture: a heavier pill with a shadow, so it reads on any art. */
		float?: boolean;
	} = $props();
</script>

<span class="in-progress" class:bare={!label} class:float title="In progress">
	<span class="dot" aria-hidden="true"></span>
	{#if label}In progress{:else}<span class="sr-only">In progress</span>{/if}
</span>

<style>
	.in-progress {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
		flex: none;
		padding: 0.15rem 0.6rem 0.15rem 0.45rem;
		border-radius: 999px;
		background: var(--accent);
		color: #fff;
		font-size: 0.72rem;
		font-weight: 800;
		letter-spacing: 0.02em;
		line-height: 1.4;
		white-space: nowrap;
	}

	.in-progress.bare {
		padding: 0.25rem;
	}

	.in-progress.float {
		padding: 0.3rem 0.8rem 0.3rem 0.6rem;
		font-size: 0.8rem;
		letter-spacing: 0.06em;
		text-transform: uppercase;
		box-shadow: 0 6px 16px -6px rgb(20 32 52 / 0.5);
	}

	/* Half a disc: begun, not complete. */
	.dot {
		width: 0.6rem;
		height: 0.6rem;
		border: 1.5px solid currentColor;
		border-radius: 50%;
		background: linear-gradient(90deg, currentColor 50%, transparent 50%);
	}

	.sr-only {
		position: absolute;
		width: 1px;
		height: 1px;
		overflow: hidden;
		clip: rect(0 0 0 0);
		white-space: nowrap;
	}
</style>
