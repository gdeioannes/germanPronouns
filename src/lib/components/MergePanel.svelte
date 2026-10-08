<script lang="ts">
	// The one question an account ever asks: "you have practised on two devices
	// — what should they become?"
	//
	// It appears once per account on this browser, at the first sign-in, and
	// only when both sides really hold progress that differs. Until it is
	// answered nothing has been written: the learner is looking at two intact
	// histories, not at a fait accompli they are being told about.
	//
	// "Keep both" is the recommended answer and the only one that discards
	// nothing. The other two exist because the learner may know something the
	// merge cannot — that one of these devices was a friend's, say — so they are
	// offered plainly, named for what they do, and never chosen automatically.
	import Icon from '$lib/icons/Icon.svelte';
	import { announce, inertOutside } from '$lib/a11y.svelte';
	import { account, type MergeChoice } from '$lib/state/account.svelte';
	import type { ProgressSummary } from '$lib/domain/sync-merge';

	let root = $state<HTMLElement>();
	let panel = $state<HTMLElement>();
	let busy = $state(false);

	const decision = $derived(account.pending);

	$effect(() => {
		if (!decision || !panel) return;
		const release = root ? inertOutside(root) : () => {};
		panel.focus({ preventScroll: true });
		announce('You have progress on two devices. Choose what to keep.');
		return release;
	});

	/** Medals as one line — "2 gold · 1 silver" — or null when there are none. */
	function medalLine(summary: ProgressSummary): string | null {
		const parts = (['gold', 'silver', 'bronze'] as const)
			.filter((tier) => summary.medals[tier] > 0)
			.map((tier) => `${summary.medals[tier]} ${tier}`);
		return parts.length ? parts.join(' · ') : null;
	}

	function lastActive(summary: ProgressSummary): string | null {
		if (!summary.lastActive) return null;
		const days = Math.floor((Date.now() - summary.lastActive) / 86_400_000);
		if (days <= 0) return 'practised today';
		if (days === 1) return 'practised yesterday';
		if (days < 31) return `practised ${days} days ago`;
		return `last practised ${new Date(summary.lastActive).toLocaleDateString()}`;
	}

	async function choose(choice: MergeChoice) {
		busy = true;
		await account.resolveMerge(choice);
		busy = false;
		announce(
			choice === 'merge'
				? 'Kept the best of both devices.'
				: choice === 'local'
					? 'Kept this device’s progress.'
					: 'Kept the progress from your other device.'
		);
	}
</script>

{#if decision}
	<div class="wrap" bind:this={root}>
		<div class="scrim"></div>
		<div
			class="panel"
			role="dialog"
			aria-modal="true"
			aria-labelledby="merge-title"
			aria-describedby="merge-lede"
			tabindex="-1"
			bind:this={panel}
		>
			<h2 id="merge-title">You have progress on two devices</h2>
			<p id="merge-lede" class="lede">
				This browser and your account both have practice saved. Nothing has
				changed yet — pick what your account should hold from now on.
			</p>

			<div class="columns">
				<section class="side">
					<h3><Icon name="compass" size="1em" /> This device</h3>
					{@render stats(decision.here)}
				</section>
				<section class="side">
					<h3><Icon name="cloud" size="1em" /> Your other device</h3>
					{@render stats(decision.cloud)}
				</section>
			</div>

			<div class="choices">
				<button class="btn" type="button" disabled={busy} onclick={() => choose('merge')}>
					<span class="label">Keep both</span>
					<span class="note">
						The better of the two everywhere: {decision.both.done} exercises finished,
						best streak {decision.both.bestStreak}. Nothing is lost.
					</span>
				</button>
				<button class="btn-quiet" type="button" disabled={busy} onclick={() => choose('local')}>
					<span class="label">Only this device</span>
					<span class="note">Replaces what your account holds.</span>
				</button>
				<button class="btn-quiet" type="button" disabled={busy} onclick={() => choose('remote')}>
					<span class="label">Only the other device</span>
					<span class="note">Replaces what this browser holds.</span>
				</button>
			</div>
		</div>
	</div>
{/if}

{#snippet stats(summary: ProgressSummary)}
	<ul>
		<li><strong>{summary.done}</strong> exercises finished</li>
		<li><strong>{summary.practised}</strong> started</li>
		<li>best streak <strong>{summary.bestStreak}</strong></li>
		{#if medalLine(summary)}
			<li class="medals"><Icon name="ribbon" size="1em" /> {medalLine(summary)}</li>
		{/if}
		{#if lastActive(summary)}
			<li class="when">{lastActive(summary)}</li>
		{/if}
	</ul>
{/snippet}

<style>
	.wrap {
		position: fixed;
		inset: 0;
		z-index: 200;
		display: grid;
		place-items: center;
		padding: 1rem;
	}

	.scrim {
		position: absolute;
		inset: 0;
		background: rgb(20 32 52 / 0.5);
	}

	.panel {
		position: relative;
		width: min(40rem, 100%);
		max-height: calc(100dvh - 2rem);
		overflow-y: auto;
		padding: 1.5rem;
		border-radius: var(--radius-sm);
		background: var(--surface);
		box-shadow: 0 24px 60px -24px rgb(20 32 52 / 0.55);
		outline: none;
	}

	h2 {
		margin: 0 0 0.5rem;
		font-size: var(--step-1);
	}

	.lede {
		margin: 0 0 1.2rem;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.columns {
		display: grid;
		gap: 0.8rem;
		grid-template-columns: repeat(auto-fit, minmax(13rem, 1fr));
		margin-bottom: 1.3rem;
	}

	.side {
		padding: 0.9rem 1rem;
		border: 1px solid var(--line);
		border-radius: var(--radius-sm);
	}

	h3 {
		display: flex;
		align-items: center;
		gap: 0.4rem;
		margin: 0 0 0.5rem;
		font-size: var(--step--1);
	}

	ul {
		margin: 0;
		padding: 0;
		list-style: none;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	li + li {
		margin-top: 0.2rem;
	}

	.medals,
	.when {
		display: flex;
		align-items: center;
		gap: 0.35rem;
		margin-top: 0.45rem;
	}

	.choices {
		display: flex;
		flex-direction: column;
		gap: 0.6rem;
	}

	.choices button {
		display: block;
		width: 100%;
		text-align: left;
	}

	.label {
		display: block;
		font-weight: 600;
	}

	.note {
		display: block;
		margin-top: 0.15rem;
		font-size: var(--step--1);
		font-weight: 400;
		opacity: 0.85;
	}
</style>
