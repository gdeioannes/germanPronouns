<script lang="ts">
	// The back office's door, for its analytics pages: only the account with a
	// site_owners/{uid} document sees what is inside. The pages behind it fetch
	// nothing, so this keeps them out of sight; it is not what protects data
	// (the Firestore rules do that, for the pages that read any).
	//
	// On the dev server it stands open: there is no visitor there to keep out.
	import type { Snippet } from 'svelte';
	import { dev } from '$app/environment';
	import { account } from '$lib/state/account.svelte';
	import { openSignIn } from '$lib/state/signin.svelte';
	import { isSiteOwner } from '$lib/services/feedback';

	let { children }: { children: Snippet } = $props();

	type Gate = 'checking' | 'signed-out' | 'not-owner' | 'owner' | 'unavailable';
	let gate = $state<Gate>('checking');

	$effect(() => {
		if (dev) {
			gate = 'owner';
			return;
		}
		const uid = account.userId;
		if (!account.available) {
			gate = 'unavailable';
			return;
		}
		if (!uid) {
			// A session is being restored for a moment after load.
			gate = 'checking';
			const t = setTimeout(() => {
				if (!account.userId) gate = 'signed-out';
			}, 2500);
			return () => clearTimeout(t);
		}
		gate = 'checking';
		void isSiteOwner(uid).then((owner) => {
			if (account.userId === uid) gate = owner ? 'owner' : 'not-owner';
		});
	});
</script>

{#if gate === 'checking'}
	<p class="muted" role="status">Checking your account…</p>
{:else if gate === 'unavailable'}
	<p class="muted">This build has no Firebase project configured.</p>
{:else if gate === 'signed-out'}
	<p class="muted">Sign in with the owner's account to see this page.</p>
	<button type="button" class="btn" onclick={openSignIn}>Sign in</button>
{:else if gate === 'not-owner'}
	<p class="muted">Not available.</p>
{:else}
	{@render children()}
{/if}

<style>
	.muted {
		color: var(--ink-muted);
	}

	.btn {
		min-height: 2.75rem;
		padding: 0 1.1rem;
		border: 0;
		border-radius: 999px;
		background: var(--heading);
		color: #fff;
		font: inherit;
		font-weight: 600;
		cursor: pointer;
	}
</style>
