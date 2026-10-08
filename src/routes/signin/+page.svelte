<script lang="ts">
	// Where the emailed sign-in link lands.
	//
	// The page is prerendered like every other, and does its work in the
	// browser from the link's own query string — there is no server to hand the
	// code to. Firebase verifies it directly.
	import { goto } from '$app/navigation';
	import Seo from '$lib/components/Seo.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { announce } from '$lib/a11y.svelte';
	import { account } from '$lib/state/account.svelte';

	type Stage = 'working' | 'needsEmail' | 'done' | 'failed';

	let stage = $state<Stage>('working');
	let email = $state('');
	let message = $state('');

	$effect(() => {
		void attempt();
	});

	async function attempt(typed?: string) {
		stage = 'working';
		const ok = await account.completeLinkSignIn(window.location.href, typed);
		if (ok) {
			stage = 'done';
			message = 'Signed in. Your progress is being saved to your account.';
			announce(message);
			// Nothing on this page is worth keeping in the history: send them on.
			setTimeout(() => void goto('/settings', { replaceState: true }), 1600);
			return;
		}
		// The one recoverable failure: the link was opened in a browser that
		// never asked for it, so Firebase wants the address confirmed.
		if (account.error === 'needs-email') {
			stage = 'needsEmail';
			message = '';
			return;
		}
		stage = 'failed';
		message = account.error ?? 'That link could not be used.';
		announce(message);
	}
</script>

<Seo
	title="Signing in — Language Quiz"
	description="Finishing sign-in to your Language Quiz account."
	path="/signin"
	noindex
/>

<main class="page">
	<h1>Signing in</h1>

	{#if !account.available}
		<p class="lede">
			Accounts aren't switched on for this site. Your progress is saved in this
			browser, as it always has been.
		</p>
		<a class="btn" href="/">Back to the course</a>
	{:else if stage === 'working'}
		<p class="lede" role="status">One moment — checking your link…</p>
	{:else if stage === 'done'}
		<p class="ok">
			<Icon name="check" size="1.1em" />
			<span>{message}</span>
		</p>
		<a class="btn" href="/settings">Go to settings</a>
	{:else if stage === 'needsEmail'}
		<p class="lede">
			This link was opened in a different browser from the one that asked for
			it. Type the address you asked from, to confirm it's you.
		</p>
		<form
			onsubmit={(event) => {
				event.preventDefault();
				void attempt(email.trim());
			}}
		>
			<label>
				<span>Your email address</span>
				<input type="email" bind:value={email} required autocomplete="email" />
			</label>
			<button class="btn" type="submit" disabled={account.busy}>Confirm</button>
		</form>
	{:else}
		<p class="bad">
			<Icon name="info" size="1.1em" />
			<span>{message}</span>
		</p>
		<p class="lede">
			Nothing is lost: your progress is in this browser either way. You can ask
			for a fresh link from settings.
		</p>
		<a class="btn" href="/settings">Back to settings</a>
	{/if}
</main>

<style>
	h1 {
		margin: 0 0 1rem;
	}

	.lede {
		margin: 0 0 1.2rem;
		color: var(--ink-muted);
	}

	.ok,
	.bad {
		display: flex;
		align-items: flex-start;
		gap: 0.5rem;
		max-width: none;
		padding: 0.85rem 1.05rem;
		margin: 0 0 1.2rem;
		border-radius: var(--radius-sm);
		border: 1px solid var(--right);
		background: var(--right-bg);
		color: var(--right);
	}

	.bad {
		border-color: var(--wrong);
		background: var(--wrong-bg);
		color: var(--wrong);
	}

	form {
		display: flex;
		flex-direction: column;
		gap: 0.8rem;
		align-items: flex-start;
		margin-bottom: 1.2rem;
	}

	label span {
		display: block;
		margin-bottom: 0.3rem;
		font-size: var(--step--1);
		font-weight: 600;
	}

	input {
		min-width: min(22rem, 100%);
		padding: 0.55rem 0.8rem;
		border: 1px solid var(--line-strong);
		border-radius: var(--radius-sm);
		background: var(--surface);
		color: var(--ink);
		font: inherit;
	}

	.btn {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		padding: 0.55rem 1.2rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		background: var(--surface);
		color: var(--ink);
		font: inherit;
		font-weight: 600;
		text-decoration: none;
		cursor: pointer;
	}

	.btn:hover {
		border-color: var(--accent);
		color: var(--accent-ink);
	}
</style>
