<script lang="ts">
	// The one sign-in sheet, mounted once in the root layout and opened from
	// anywhere via `openSignIn()`. The emailed link brings the learner back to
	// the page they opened it from.
	import { page } from '$app/state';
	import Sheet from '$lib/components/Sheet.svelte';
	import AccountCard from '$lib/components/AccountCard.svelte';
	import { account } from '$lib/state/account.svelte';
	import { signInPanel } from '$lib/state/signin.svelte';

	// The pathname alone at prerender time (the query string is off limits
	// there, and unknown anyway); the full address once in the browser.
	const returnTo = $derived(
		typeof window === 'undefined' ? page.url.pathname : page.url.pathname + page.url.search
	);
</script>

{#if account.available}
	<Sheet bind:open={signInPanel.open} title={account.signedIn ? 'Your account' : 'Sign in'} id="sign-in-sheet">
		<p class="why">
			Everything works without an account. Signing in backs your progress
			up, carries it to your phone, and lets you post on the forum.
		</p>
		<AccountCard heading={false} {returnTo} reason="One email, no password." />
		{#snippet footer()}
			<button type="button" class="btn btn-ghost close" onclick={() => (signInPanel.open = false)}>
				{account.signedIn ? 'Done' : 'Not now'}
			</button>
		{/snippet}
	</Sheet>
{/if}

<style>
	.why {
		margin: 0 0 1rem;
		max-width: none;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.close {
		width: 100%;
	}
</style>
