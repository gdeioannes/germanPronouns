<script lang="ts">
	// The grammar charts' download button with its clock. The download is a test
	// run, open for a few days: while it is open the button sits over a
	// countdown in large figures; when the date in
	// charts.json (downloadUntil) has passed, the button is gone and a line says
	// so. With no date the button is simply always there.
	//
	// The page is prerendered, so the clock runs in the visitor's browser: this
	// stops the download from the page, it does not take the file off the server.
	import { onMount } from 'svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { feedback } from '$lib/state/feedback.svelte';
	import { track } from '$lib/services/analytics';
	import { CHARTS_BOOK, CHARTS_FILENAME, chartsDownloadEnds, timeLeft } from '$lib/content/charts';

	let { from, label = 'Download the test edition' }: { /** For analytics: where the button sits. */ from: string; label?: string } = $props();

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
	/** The time left as figures for the tiles: days, hours, minutes, seconds. */
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

	function onclick(e: MouseEvent) {
		track('charts_download', { from });
		feedback.beforeDownload(e, { href: CHARTS_BOOK.pdf, filename: CHARTS_FILENAME, book: 'Grammar charts' });
	}
</script>

{#if open}
	<a class="primary" href={CHARTS_BOOK.pdf} download={CHARTS_FILENAME} {onclick}>
		<Icon name="download" size="1.05em" />
		{label}
	</a>
	{#if ends !== null}
		<div class="clock" role="timer" aria-live="off" aria-label="Test run: the download closes in {left}">
			<p class="clock-head"><span class="badge">Test run</span> The download closes in</p>
			<div class="tiles" aria-hidden="true">
				{#each parts as p (p.unit)}
					<span class="tile"><strong>{p.n}</strong><small>{p.unit}</small></span>
				{/each}
			</div>
		</div>
	{/if}
{:else}
	<p class="ended"><Icon name="calendar" size="1.05em" /> <span><strong>The test run has ended.</strong> The charts stay here to look at, and a new edition is on the way.</span></p>
{/if}

<style>
	.primary {
		display: inline-flex;
		align-items: center;
		gap: 0.5rem;
		padding: 0.8rem 1.4rem;
		border-radius: 6px;
		background: var(--accent-ink);
		color: #fff;
		font-weight: 700;
		text-decoration: none;
	}
	/* The countdown: a dark block with the time in large figures, so nobody
	   misses that the download is a test run with an end. */
	.clock {
		width: fit-content;
		max-width: 100%;
		margin: 0.9rem 0 0;
		padding: 0.9rem 1rem 1rem;
		border-radius: 12px;
		background: var(--navy);
		color: #fff;
	}
	.clock-head {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 0.5rem;
		margin: 0 0 0.7rem;
		font-size: var(--step--1);
		font-weight: 700;
		color: #fff;
	}
	.badge {
		padding: 0.2rem 0.55rem;
		border-radius: 999px;
		background: var(--terracotta);
		color: #fff;
		font-size: 0.72rem;
		letter-spacing: 0.08em;
		text-transform: uppercase;
	}
	.tiles {
		display: flex;
		gap: 0.45rem;
	}
	.tile {
		display: flex;
		flex-direction: column;
		align-items: center;
		min-width: 3.6rem;
		padding: 0.5rem 0.4rem 0.4rem;
		border-radius: 8px;
		background: rgb(255 255 255 / 0.1);
	}
	.tile strong {
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: 2rem;
		line-height: 1;
		font-variant-numeric: tabular-nums;
		color: #fff;
	}
	.tile small {
		margin-top: 0.3rem;
		font-size: 0.68rem;
		font-weight: 700;
		letter-spacing: 0.08em;
		text-transform: uppercase;
		color: rgb(255 255 255 / 0.7);
	}
	/* The seconds tile is the one that moves: it carries the accent. */
	.tile:last-child {
		background: var(--terracotta);
	}
	.tile:last-child small {
		color: #fff;
	}
	@media (max-width: 24rem) {
		.tile {
			min-width: 0;
			flex: 1;
		}
		.tile strong {
			font-size: 1.6rem;
		}
	}
	.ended {
		display: flex;
		align-items: flex-start;
		gap: 0.5rem;
		margin: 0;
		padding: 0.8rem 1rem;
		border-radius: 8px;
		background: var(--accent-soft);
		color: var(--heading);
		line-height: 1.4;
	}
</style>
