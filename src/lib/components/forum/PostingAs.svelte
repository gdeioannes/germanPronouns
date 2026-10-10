<script lang="ts">
	// "Posting as <name>" with a change button. The name is public, the email
	// never is, so this is the one place the learner decides what others see.
	import { validName, LIMITS } from '$lib/domain/forum';
	import { forum } from '$lib/state/forum.svelte';

	let editing = $state(false);
	let draft = $state('');
	let bad = $state(false);

	function start() {
		draft = forum.name;
		bad = false;
		editing = true;
	}

	async function save(event: SubmitEvent) {
		event.preventDefault();
		if (!validName(draft)) {
			bad = true;
			return;
		}
		await forum.rename(draft);
		editing = false;
	}
</script>

{#if editing}
	<form class="rename" onsubmit={save}>
		<label>
			<span>Your public name</span>
			<input type="text" bind:value={draft} maxlength={LIMITS.name} autocomplete="nickname" required />
		</label>
		<button type="submit" class="btn">Save</button>
		<button type="button" class="btn-quiet" onclick={() => (editing = false)}>Cancel</button>
		{#if bad}<p class="bad">Two to {LIMITS.name} characters, and not an email address.</p>{/if}
	</form>
{:else}
	<p class="as">
		Posting as <strong>{forum.name || '…'}</strong>
		<button type="button" class="btn-quiet" onclick={start}>Change</button>
	</p>
{/if}

<style>
	.as {
		margin: 0;
		max-width: none;
		font-size: var(--step--1);
		color: var(--ink-muted);
		display: flex;
		align-items: baseline;
		gap: 0.5rem;
		flex-wrap: wrap;
	}

	.rename {
		display: flex;
		flex-wrap: wrap;
		align-items: flex-end;
		gap: 0.6rem;
	}

	.rename label span {
		display: block;
		margin-bottom: 0.3rem;
		font-size: var(--step--1);
		font-weight: 600;
	}

	.rename input {
		padding: 0.5rem 0.75rem;
		border: 1px solid var(--line-strong);
		border-radius: var(--radius-sm);
		background: var(--surface);
		color: var(--ink);
		font: inherit;
	}

	.rename .btn {
		padding: 0.5rem 1rem;
	}

	.bad {
		flex-basis: 100%;
		margin: 0;
		font-size: var(--step--1);
		color: var(--wrong);
	}
</style>
