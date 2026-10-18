<script lang="ts">
	// The Schreib mir! contacts as an icon in the top bar, where a dating app
	// keeps its chats: a heart with the number of characters who liked you,
	// opening the contact list. Before the first like, a learner who has met
	// someone in the deck gets the heart alone, opening their matches. Someone
	// who never met a character, or turned games off in Settings, sees nothing.
	// The bar outlives page changes, so it rereads after every navigation (a
	// chat may just have been won).
	import { afterNavigate } from '$app/navigation';
	import Icon from '$lib/icons/Icon.svelte';
	import { contacts, loadChat, MATCH_CHATS, MATCH_PATH, metChats } from '$lib/domain/matchChat';
	import { progress } from '$lib/state/progress.svelte';

	let total = $state(0);
	let met = $state(false);

	afterNavigate(() => {
		total = contacts().length;
		met = total > 0 || metChats().size > 0 || MATCH_CHATS.some((c) => loadChat(c.id));
	});
</script>

{#if progress.surprises && met}
	<a
		class="icon-link contacts"
		href={MATCH_PATH}
		aria-label={total > 0
			? `Schreib mir! contacts: ${total} ${total === 1 ? 'character' : 'characters'} liked you`
			: 'Schreib mir! matches'}
		title={total > 0 ? 'Your contacts' : 'Your matches'}
	>
		<Icon name="heart" size="1.15em" />
		{#if total > 0}<span class="badge tnum" aria-hidden="true">{total}</span>{/if}
	</a>
{/if}

<style>
	.contacts {
		position: relative;
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2.2rem;
		height: 2.2rem;
		border-radius: 50%;
		color: #c2364a;
		transition: background var(--fast) var(--ease-out);
	}
	.contacts:hover {
		background: var(--surface-alt);
	}
	.badge {
		position: absolute;
		top: 0.05rem;
		right: -0.05rem;
		min-width: 1rem;
		height: 1rem;
		padding: 0 0.2rem;
		border-radius: 999px;
		background: #c2364a;
		color: #fff;
		font-size: 0.62rem;
		font-weight: 800;
		line-height: 1rem;
		text-align: center;
	}
</style>
