<script lang="ts">
	import { t } from '$lib/i18n/t';
	// Where a printed QR code lands. The code is permanent; this page sends the
	// reader to wherever the code points today, and says so, so a reader whose
	// phone blocked the redirect still has a link to tap.
	//
	// A book page with app quizzes asks once: Book (the page on the web) or App
	// (its quiz list). The answer is remembered and the next code goes straight
	// there (state/bookOpen).
	import { onMount } from 'svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { getSide, setSide, type BookSide } from '$lib/state/bookOpen';
	let { data } = $props();

	let asking = $state(false);
	/** From B1 the book speaks German, and so does this question. */
	const g = (de: string, en: string) => (data.german ? de : en);

	onMount(() => {
		if (!data.target) return;
		if (!data.app) {
			location.replace(data.target);
			return;
		}
		void (async () => {
			const side = await getSide();
			if (side) location.replace(side === 'app' ? data.app! : data.target!);
			else asking = true;
		})();
	});

	async function choose(side: BookSide) {
		await setSide(side);
		location.replace(side === 'app' ? data.app! : data.target!);
	}
</script>

<svelte:head>
	<title>{t('From the book')}</title>
	<meta name="robots" content="noindex" />
	{#if data.target && !data.app}<meta http-equiv="refresh" content="0;url={data.target}" />{/if}
</svelte:head>

<main class="land">
	{#if data.target && data.app}
		<p class="eyebrow">{t('From the book · {code}', { code: data.code })}</p>
		{#if asking}
			<h1>{g('Wie möchtest du weitermachen?', t('How do you want to go on?'))}</h1>
			<div class="choices">
				<button type="button" class="choice" onclick={() => choose('book')}>
					<Icon name="book" size="1.6em" />
					<b>{g('Buch', t('Book'))}</b>
					<span>{g('Diese Seite im Web: prüfen, hören, Wortkarten', t('This page on the web: check it, hear it, word cards'))}</span>
				</button>
				<button type="button" class="choice app" onclick={() => choose('app')}>
					<Icon name="cards" size="1.6em" />
					<b>App</b>
					<span>{g('Die Quizze der App zu dieser Seite, mit Medaillen', t('The app exercises for this page, with pictures and medals'))}</span>
				</button>
			</div>
			<p class="hint">{g('Wir merken uns deine Wahl für den nächsten Code. Oben auf jeder Seite kannst du wechseln.', t('Your choice is remembered for the next code. You can switch at the top of every page.'))}</p>
		{:else}
			<h1>{t('One moment …')}</h1>
		{/if}
	{:else if data.target}
		<p class="eyebrow">{t('From the book · {code}', { code: data.code })}</p>
		<h1>{t('One moment …')}</h1>
		<p>{t('If nothing happens,')} <a href={data.target}>{t('tap here')}</a>.</p>
	{:else}
		<p class="eyebrow">{t('From the book · {code}', { code: data.code })}</p>
		<h1>{t('This code is not in use yet')}</h1>
		<p>{t('It may be from a newer printing than this site knows.')} <a href="/">{t('Go to the start page')}</a> {t('and pick your level there.')}</p>
	{/if}
</main>

<style>
	.land {
		max-width: 32rem;
		margin: 4rem auto;
		padding: 0 1rem;
		text-align: center;
	}
	.eyebrow {
		font-size: 0.75rem;
		font-weight: 800;
		letter-spacing: 0.08em;
		text-transform: uppercase;
		color: var(--accent-ink);
	}
	.choices {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 0.75rem;
		margin-top: 1.5rem;
	}
	.choice {
		display: flex;
		flex-direction: column;
		align-items: center;
		gap: 0.4rem;
		padding: 1.4rem 0.9rem;
		border-radius: 16px;
		border: 2px solid var(--line-strong);
		background: var(--surface);
		color: var(--ink);
		font: inherit;
		cursor: pointer;
	}
	.choice b {
		font-size: var(--step-1);
	}
	.choice span {
		font-size: var(--step--1);
		color: var(--ink-muted);
	}
	.choice.app {
		background: var(--navy);
		border-color: var(--navy);
		color: #fff;
	}
	.choice.app span {
		color: #dbe4f0;
	}
	.choice:focus-visible {
		outline: 3px solid var(--accent);
		outline-offset: 2px;
	}
	.hint {
		margin-top: 1rem;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}
	@media (max-width: 360px) {
		.choices {
			grid-template-columns: 1fr;
		}
	}
</style>
