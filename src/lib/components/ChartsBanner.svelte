<script lang="ts">
	// The grammar charts (the diagram book) announced at the top of /books while
	// its test-run download is open. It disappears by itself once downloadUntil in
	// charts.json has passed. English only, like the charts themselves.
	import { onMount } from 'svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { track } from '$lib/services/analytics';
	import { feedback } from '$lib/state/feedback.svelte';
	import { CHARTS_BOOK, CHARTS_FILENAME, chartsDownloadEnds, timeLeft } from '$lib/content/charts';

	const ends = chartsDownloadEnds();
	let now = $state(Date.now());
	onMount(() => {
		now = Date.now();
		if (ends === null) return;
		const id = setInterval(() => (now = Date.now()), 1000);
		return () => clearInterval(id);
	});
	const open = $derived(ends === null || now < ends);
	const left = $derived(ends === null ? '' : timeLeft(ends - now));
	/** The time left as figures for the tiles, like the clock on /charts. */
	const parts = $derived.by(() => {
		const sec = Math.max(0, Math.floor(((ends ?? now) - now) / 1000));
		const two = (n: number) => String(n).padStart(2, '0');
		return [
			{ n: String(Math.floor(sec / 86400)), unit: 'days' },
			{ n: two(Math.floor(sec / 3600) % 24), unit: 'hours' },
			{ n: two(Math.floor(sec / 60) % 60), unit: 'min' },
			{ n: two(sec % 60), unit: 'sec' }
		];
	});

	function download(e: MouseEvent) {
		track('charts_download', { from: 'books_banner' });
		feedback.beforeDownload(e, { href: CHARTS_BOOK.pdf, filename: CHARTS_FILENAME, book: 'Grammar charts' });
	}
</script>

{#if open}
	<section class="charts-banner" aria-labelledby="charts-banner-title">
		<a class="pic" href="/charts" tabindex="-1" aria-hidden="true" onclick={() => track('charts_banner_click')}
			><img src={CHARTS_BOOK.cover} alt="" width="1280" height="905" /></a
		>
		<span class="copy">
			<span class="badge">New · test run</span>
			<a class="title" id="charts-banner-title" href="/charts" onclick={() => track('charts_banner_click')}
				>German Grammar Charts</a
			>
			<span class="sub"
				>{CHARTS_BOOK.charts.length} wall charts to print and hang up: the cases, word order, adjective
				endings, the tenses. One free PDF.</span
			>
			<a class="more" href="/charts" onclick={() => track('charts_banner_click')}
				>See the charts <Icon name="arrowRight" size="1em" /></a
			>
		</span>
		<span class="act">
			{#if ends !== null}
				<span class="clock" role="timer" aria-label="The free download closes in {left}">
					<span class="clock-head" aria-hidden="true">The download closes in</span>
					<span class="tiles" aria-hidden="true">
						{#each parts as p (p.unit)}
							<span class="tile"><strong>{p.n}</strong><small>{p.unit}</small></span>
						{/each}
					</span>
				</span>
			{/if}
			<a class="go" href={CHARTS_BOOK.pdf} download={CHARTS_FILENAME} onclick={download}
				><Icon name="download" size="1.05em" /> Download the test run</a
			>
		</span>
	</section>
{/if}

<style>
	.charts-banner {
		display: grid;
		grid-template-columns: auto minmax(0, 1fr) auto;
		align-items: center;
		gap: 1rem 1.5rem;
		margin: 0 0 1.5rem;
		padding: 1rem 1.75rem 1rem 1.25rem;
		border-radius: 1.5rem;
		background: #ffe14d;
		color: #2b2a25;
		box-shadow: 0 14px 34px -18px rgb(31 58 95 / 0.55);
	}
	.charts-banner a:focus-visible {
		outline: 3px solid var(--navy, #1f3a5f);
		outline-offset: 3px;
	}
	.pic {
		display: block;
		width: 9rem;
		transform: rotate(-3deg);
		transition: transform 0.2s ease;
	}
	.pic:hover {
		transform: rotate(-1deg) translateY(-3px);
	}
	.pic img {
		display: block;
		width: 100%;
		height: auto;
		border-radius: 0.35rem;
		box-shadow: 0 8px 18px -8px rgb(0 0 0 / 0.45);
	}
	.copy {
		display: flex;
		flex-direction: column;
		align-items: flex-start;
		gap: 0.3rem;
	}
	.badge {
		background: var(--navy, #1f3a5f);
		color: #fff;
		border-radius: 999px;
		padding: 0.15rem 0.65rem;
		font-size: 0.75rem;
		font-weight: 700;
		letter-spacing: 0.04em;
		text-transform: uppercase;
	}
	.title {
		font-family: var(--font-serif, Georgia, serif);
		font-size: clamp(1.35rem, 2.4vw, 1.8rem);
		line-height: 1.15;
		color: var(--navy, #1f3a5f);
		font-weight: 700;
		text-decoration: none;
	}
	.title:hover,
	.more:hover {
		text-decoration: underline;
	}
	.more {
		display: inline-flex;
		align-items: center;
		gap: 0.25rem;
		font-weight: 700;
		color: var(--navy, #1f3a5f);
		text-decoration: none;
	}
	.sub {
		line-height: 1.4;
	}
	.act {
		display: flex;
		flex-direction: column;
		align-items: stretch;
		gap: 0.6rem;
	}
	.clock {
		display: block;
		padding: 0.7rem 0.8rem 0.8rem;
		border-radius: 12px;
		background: var(--navy, #1f3a5f);
		color: #fff;
	}
	.clock-head {
		display: block;
		margin: 0 0 0.5rem;
		font-size: 0.78rem;
		font-weight: 700;
		letter-spacing: 0.04em;
		text-transform: uppercase;
		color: rgb(255 255 255 / 0.85);
	}
	.tiles {
		display: flex;
		gap: 0.4rem;
	}
	.tile {
		display: flex;
		flex-direction: column;
		align-items: center;
		flex: 1;
		min-width: 3.2rem;
		padding: 0.45rem 0.35rem 0.35rem;
		border-radius: 8px;
		background: rgb(255 255 255 / 0.1);
	}
	.tile strong {
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: 1.75rem;
		line-height: 1;
		font-variant-numeric: tabular-nums;
	}
	.tile small {
		margin-top: 0.25rem;
		font-size: 0.65rem;
		font-weight: 700;
		letter-spacing: 0.08em;
		text-transform: uppercase;
		color: rgb(255 255 255 / 0.7);
	}
	/* The seconds tile is the one that moves: it carries the accent. */
	.tile:last-child {
		background: var(--terracotta, #b5532f);
	}
	.tile:last-child small {
		color: #fff;
	}
	.go {
		text-decoration: none;
		justify-content: center;
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
		padding: 0.75rem 1.3rem;
		border-radius: 999px;
		background: var(--navy, #1f3a5f);
		color: #fff;
		font-weight: 700;
		white-space: nowrap;
	}
	.go:hover {
		filter: brightness(1.15);
	}

	/* Phones: a short card. A small cover beside the badge and title, the
	   description and the extra link left out (cover and title open /charts),
	   the clock as one slim line, and a lower button. */
	@media (max-width: 44rem) {
		.charts-banner {
			grid-template-columns: 4.5rem minmax(0, 1fr);
			align-items: center;
			gap: 0.6rem 0.75rem;
			padding: 0.8rem;
			border-radius: 1rem;
		}
		.pic {
			width: 4.5rem;
		}
		.copy {
			gap: 0.2rem;
		}
		.badge {
			font-size: 0.6rem;
			padding: 0.1rem 0.45rem;
		}
		.title {
			font-size: 1.1rem;
		}
		.sub,
		.more {
			display: none;
		}
		.act {
			grid-column: 1 / -1;
			width: 100%;
			gap: 0.45rem;
		}
		.clock {
			display: flex;
			align-items: center;
			gap: 0.5rem;
			padding: 0.35rem 0.4rem 0.35rem 0.65rem;
			border-radius: 9px;
		}
		.clock-head {
			flex: 0 1 auto;
			margin: 0;
			font-size: 0.62rem;
			line-height: 1.2;
		}
		.tiles {
			flex: 1 1 auto;
			gap: 0.25rem;
		}
		.tile {
			min-width: 0;
			padding: 0.2rem 0.15rem;
			border-radius: 5px;
		}
		.tile strong {
			font-size: 1rem;
		}
		.tile small {
			margin-top: 0.05rem;
			font-size: 0.5rem;
			letter-spacing: 0.04em;
		}
		.go {
			padding: 0.5rem 0.9rem;
			font-size: 0.9rem;
		}
	}
</style>
