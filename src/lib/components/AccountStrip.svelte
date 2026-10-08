<script lang="ts">
	// One quiet line under the deck: progress lives in this browser only, and
	// signing in is what carries it elsewhere.
	//
	// The course home is about the cards, so this is a strip rather than a
	// card, and it is dismissible — a learner who has decided no should be able
	// to say so once. Dismissal is per-browser and permanent, which is the
	// point: the alternative is nagging somebody on every visit about a thing
	// they do once.
	import Icon from '$lib/icons/Icon.svelte';
	import Sheet from '$lib/components/Sheet.svelte';
	import AccountCard from '$lib/components/AccountCard.svelte';
	import { SettingsKeys } from '$lib/domain/keys';
	import { account } from '$lib/state/account.svelte';
	import { storage } from '$lib/services/storage';

	// Its own sheet, not the progress panel: the link says "sign in", so what
	// opens has to be the sign-in. Sending it to the progress panel instead
	// made the learner hunt past every statistic for the form at the bottom.
	let signInOpen = $state(false);

	let dismissed = $state(true);

	// Starts hidden and appears only once storage has answered, so it can't
	// flash up for somebody who dismissed it long ago.
	$effect(() => {
		void (async () => {
			dismissed = (await storage.get(SettingsKeys.accountStripDismissed)) === '1';
		})();
	});

	async function dismiss() {
		dismissed = true;
		await storage.set(SettingsKeys.accountStripDismissed, '1');
	}
</script>

{#if account.available && !account.signedIn && !dismissed}
	<aside class="strip">
		<Icon name="cloud" size="1.1em" />
		<p>
			Your progress is saved on this device only.
			<button type="button" class="link" aria-haspopup="dialog" aria-controls="sign-in-panel"
			onclick={() => (signInOpen = true)}>Sign in to use it on your phone too</button>
		</p>
		<button type="button" class="x" onclick={dismiss} aria-label="Hide this">
			<Icon name="close" size="0.9em" />
		</button>
	</aside>
{/if}

<!-- Outside the strip's own `#if`, so dismissing the strip while the sheet is
     open doesn't tear the sheet out from under the learner. -->
{#if account.available}
	<Sheet bind:open={signInOpen} title="Save your progress" id="sign-in-panel">
		<AccountCard heading={false} />
		{#snippet footer()}
			<button type="button" class="close-btn" onclick={() => (signInOpen = false)}>
				Back to the deck
			</button>
		{/snippet}
	</Sheet>
{/if}

<style>
	.strip {
		display: flex;
		align-items: center;
		gap: 0.6rem;
		max-width: 46rem;
		margin: 1.25rem auto 0;
		padding: 0.6rem 0.9rem;
		border: 1px solid var(--line);
		border-radius: 999px;
		background: var(--surface-alt);
		color: var(--ink-muted);
		font-size: var(--step--1);
	}

	.strip p {
		flex: 1;
		margin: 0;
		max-width: none;
	}

	.link {
		padding: 0;
		border: 0;
		background: none;
		color: var(--accent-ink);
		font: inherit;
		font-weight: 600;
		text-decoration: underline;
		cursor: pointer;
	}

	.x {
		flex: none;
		display: inline-flex;
		padding: 0.3rem;
		border: 0;
		border-radius: 999px;
		background: none;
		color: var(--ink-muted);
		cursor: pointer;
	}

	.x:hover {
		color: var(--ink);
	}

	.close-btn {
		width: 100%;
		padding: 0.7rem 1rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		background: var(--surface);
		color: var(--ink);
		font: inherit;
		font-weight: 600;
		cursor: pointer;
	}

	/* On a phone the pill becomes two lines, so square the corners off. */
	@media (max-width: 34rem) {
		.strip {
			align-items: flex-start;
			border-radius: var(--radius);
		}
	}
</style>
