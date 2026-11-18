<script lang="ts">
	import { t } from '$lib/i18n/t';
	// "Your book": one line on the course home, once the reader has opened a
	// chapter of the printed book in the app (a page code, or the chapter
	// link). It leads back to that chapter, at the part they were on. The ×
	// forgets the place, so the line stays away until a chapter is opened
	// again.
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

	async function dismiss() {
		place = null;
		await storage.remove(BOOK_PLACE_KEY);
	}
</script>

{#if place}
	<aside class="strip">
		<a class="place" href="{courseHref}/book2/{place.level}/{place.chapter}{place.part ? `#${place.part}` : ''}">
			<Icon name="book" size="1.1em" />
			<span>
				<b>{t('Your book · {level}', { level: place.level })}</b>
				<span lang="de">Kapitel {place.n}: {place.title}</span>
			</span>
			<span class="go">{t('Continue')} <Icon name="arrowRight" size="1em" /></span>
		</a>
		<button type="button" class="x" onclick={dismiss} aria-label={t('Hide this')}>
			<Icon name="close" size="0.9em" />
		</button>
	</aside>
{/if}

<style>
	.strip {
		display: flex;
		align-items: center;
		gap: 0.4rem;
		max-width: 46rem;
		margin: 1.25rem auto 0;
		padding-block: 0.7rem;
		padding-inline: 1rem 0.6rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background: var(--surface);
		color: var(--ink);
		font-size: var(--step--1);
	}

	.place {
		display: flex;
		flex: 1;
		align-items: center;
		gap: 0.7rem;
		min-width: 0;
		color: inherit;
		text-decoration: none;
	}

	.place > span:not(.go) {
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
		margin-inline-start: auto;
		color: var(--accent-ink);
		font-weight: 700;
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
</style>
