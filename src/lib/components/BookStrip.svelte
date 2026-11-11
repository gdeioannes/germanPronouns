<script lang="ts">
	import { t } from '$lib/i18n/t';
	// "Your book": one line on the course home, once the reader has opened a
	// chapter of the printed book in the app (a page code, or the chapter
	// link). It leads back to that chapter, at the part they were on.
	import { onMount } from 'svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { storage } from '$lib/services/storage';
	import { BOOK_PLACE_KEY, parsePlace, type BookPlace } from '$lib/domain/bookStudy';

	let { courseHref }: { courseHref: string } = $props();
	let place = $state<BookPlace | null>(null);

	onMount(() => {
		void (async () => {
			place = parsePlace(await storage.get(BOOK_PLACE_KEY));
		})();
	});
</script>

{#if place}
	<a class="strip" href="{courseHref}/book2/{place.level}/{place.chapter}{place.part ? `#${place.part}` : ''}">
		<Icon name="book" size="1.1em" />
		<span>
			<b>{t('Your book · {level}', { level: place.level })}</b>
			<span lang="de">Kapitel {place.n}: {place.title}</span>
		</span>
		<span class="go">{t('Continue')} <Icon name="arrowRight" size="1em" /></span>
	</a>
{/if}

<style>
	.strip {
		display: flex;
		align-items: center;
		gap: 0.7rem;
		max-width: 46rem;
		margin: 1.25rem auto 0;
		padding: 0.7rem 1rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
		color: var(--ink);
		font-size: var(--step--1);
		text-decoration: none;
	}

	.strip > span:not(.go) {
		display: flex;
		flex-direction: column;
	}

	.strip b {
		color: var(--heading);
	}

	.go {
		display: inline-flex;
		align-items: center;
		gap: 0.3rem;
		margin-left: auto;
		color: var(--accent-ink);
		font-weight: 700;
	}
</style>
