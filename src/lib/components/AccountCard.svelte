<script lang="ts">
	// The optional account, wherever it is asked for: settings, the progress
	// panel, and (as the strip below the deck) the course home.
	//
	// One component rather than three forms, because the wording is the
	// promise. "Optional, and it stays optional" has to be true everywhere it
	// appears, and the honest reason to sign in — a second device — has to be
	// stated in the same breath, not buried.
	import Icon from '$lib/icons/Icon.svelte';
	import { announce } from '$lib/a11y.svelte';
	import { account } from '$lib/state/account.svelte';

	let {
		/** Omits the heading where the surrounding panel already has one. */
		heading = true
	}: { heading?: boolean } = $props();

	let email = $state('');
	let sent = $state('');

	/** "Last synced" as something readable, or null before the first sync. */
	const syncedAgo = $derived.by(() => {
		if (!account.lastSyncedAt) return null;
		const minutes = Math.round((Date.now() - account.lastSyncedAt) / 60000);
		if (minutes < 1) return 'just now';
		if (minutes < 60) return `${minutes} minute${minutes === 1 ? '' : 's'} ago`;
		return new Date(account.lastSyncedAt).toLocaleString();
	});

	async function sendLink(event: SubmitEvent) {
		event.preventDefault();
		const address = email.trim();
		if (!address) return;
		if (await account.sendLink(address)) {
			sent = `Check ${address} for a sign-in link.`;
			announce(sent);
			email = '';
		}
	}

	async function signOut() {
		await account.signOut();
		sent = '';
		announce('Signed out. Your progress is still here in this browser.');
	}
</script>

{#if account.available}
	<div class="account">
		{#if heading}<h3>Save your progress</h3>{/if}

		{#if account.signedIn}
			<p class="lede">
				Signed in as <strong>{account.email}</strong>. Your scores, streaks and
				medals are backed up, and open the same on any device you sign in on.
			</p>
			<p class="sync" role="status">
				<Icon name="cloud" size="1.05em" />
				<span>
					{#if account.sync === 'syncing'}
						Syncing…
					{:else if account.sync === 'error'}
						Couldn't reach your account. Everything is still saved in this
						browser, and will sync when you're back online.
					{:else if syncedAgo}
						Last synced {syncedAgo}.
					{:else}
						Ready to sync.
					{/if}
				</span>
			</p>
			<div class="actions">
				<button class="btn-quiet" onclick={() => account.syncNow()} disabled={account.busy}>
					Sync now
				</button>
				<button class="btn-quiet" onclick={signOut} disabled={account.busy}>Sign out</button>
			</div>
		{:else if account.linkSent}
			<p class="lede">
				{sent || 'A sign-in link is on its way.'} Open it on this device, or on the
				one you want your progress on — there's no password to remember.
			</p>
			<button class="btn-quiet" onclick={() => account.cancelLink()}>
				Use a different address
			</button>
		{:else}
			<p class="lede">
				Your progress is already saved in this browser, and everything works
				signed out. Signing in is the only way to carry it to another device —
				and your only copy if this browser is cleared. We email you a one-time
				link: no password, and nothing is shared with anyone.
			</p>
			<form onsubmit={sendLink}>
				<label>
					<span>Your email address</span>
					<input type="email" bind:value={email} required autocomplete="email" />
				</label>
				<button class="btn-quiet" type="submit" disabled={account.busy}>
					{account.busy ? 'Sending…' : 'Email me a sign-in link'}
				</button>
			</form>
		{/if}

		{#if account.error && account.error !== 'needs-email'}
			<p class="bad">
				<Icon name="info" size="1.05em" />
				<span>{account.error}</span>
			</p>
		{/if}
	</div>
{/if}

<style>
	h3 {
		margin: 0 0 0.6rem;
		font-size: 1.05rem;
	}

	.lede {
		margin: 0 0 1rem;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.sync {
		display: flex;
		align-items: flex-start;
		gap: 0.5rem;
		max-width: none;
		margin: 0 0 1rem;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.bad {
		display: flex;
		align-items: flex-start;
		gap: 0.5rem;
		max-width: none;
		padding: 0.7rem 1rem;
		margin: 1rem 0 0;
		border: 1px solid var(--wrong);
		border-radius: var(--radius-sm);
		background: var(--wrong-bg);
		color: var(--wrong);
		font-size: var(--step--1);
	}

	.actions {
		display: flex;
		flex-wrap: wrap;
		gap: 0.6rem;
	}

	form {
		display: flex;
		flex-direction: column;
		gap: 0.8rem;
		align-items: flex-start;
	}

	form label span {
		display: block;
		margin-bottom: 0.3rem;
		font-size: var(--step--1);
		font-weight: 600;
	}

	form input {
		min-width: min(22rem, 100%);
		padding: 0.55rem 0.8rem;
		border: 1px solid var(--line-strong);
		border-radius: var(--radius-sm);
		background: var(--surface);
		color: var(--ink);
		font: inherit;
	}
</style>
