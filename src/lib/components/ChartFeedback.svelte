<script lang="ts">
	// "How is this chart?" on a grammar chart's page (and, for the whole book, on
	// /charts): the stars save on the tap, the text box follows, like the site's
	// feedback card. The answer goes to the same `feedback` collection, as a menu
	// answer whose `page` and `code` name the chart, so the owner sees which one.
	// Beside it: the share card for this page (ChartShare).
	import Icon from '$lib/icons/Icon.svelte';
	import ChartShare from '$lib/components/ChartShare.svelte';
	import { announce } from '$lib/a11y.svelte';
	import { lang } from '$lib/i18n/lang.svelte';
	import { NO_TEXTS, TEXT_MAX, addFeedbackText, feedbackAvailable, submitFeedback } from '$lib/services/feedback';
	import { track } from '$lib/services/analytics';

	let {
		path,
		code,
		title,
		shareText,
		share = true
	}: {
		/** The page the answer is about, e.g. "/charts/imperative". */
		path: string;
		/** A short tag stored with the answer, e.g. "chart-imperative". */
		code: string;
		/** The question, e.g. "How is this chart?". */
		title: string;
		/** The line sent with the link when the page is shared. */
		shareText: string;
		/** False where the share card already sits elsewhere on the page. */
		share?: boolean;
	} = $props();

	const STARS = [1, 2, 3, 4, 5];
	const WORDS = ['', 'Not good', 'Okay', 'Good', 'Very good', 'Love it'];

	let rating = $state(0);
	let hover = $state(0);
	let id = $state<string | null>(null);
	let text = $state('');
	let step = $state<'stars' | 'text' | 'thanks'>('stars');
	let busy = $state(false);
	const low = $derived(rating > 0 && rating <= 3);

	async function rate(n: number) {
		if (busy || step !== 'stars') return;
		rating = n;
		busy = true;
		track('chart_feedback', { code, rating: n });
		id = feedbackAvailable() ? await submitFeedback({ rating: n, page: path, source: 'menu', code, lang: lang.current }) : null;
		busy = false;
		step = 'text';
		announce(`${WORDS[n]}. Thank you.`);
	}

	async function send() {
		const words = text.trim();
		if (!words || busy) return;
		busy = true;
		// A low rating's words are a problem to fix; a high one's are a comment.
		if (id) await addFeedbackText(id, { ...NO_TEXTS, [low ? 'mistake' : 'comment']: words });
		busy = false;
		step = 'thanks';
		announce('Sent. Thank you.');
	}
</script>

<section class="fb" class:alone={!share} id="feedback" aria-label={title}>
	<div class="ask">
		{#if step === 'thanks'}
			<h2>Thank you!</h2>
			<p>We read every answer. What you wrote goes into the next edition.</p>
		{:else}
			<h2>{title}</h2>
			<div class="stars" role="group" aria-label="Rate from 1 to 5 stars">
				{#each STARS as n (n)}
					<button
						type="button"
						class:on={n <= (hover || rating)}
						disabled={step !== 'stars' || busy}
						aria-label="{n} of 5: {WORDS[n]}"
						aria-pressed={rating === n}
						onmouseenter={() => (hover = n)}
						onmouseleave={() => (hover = 0)}
						onclick={() => rate(n)}
					>
						<Icon name="star" size="1.6em" />
					</button>
				{/each}
				<span class="word">{WORDS[hover || rating] || 'Tap a star'}</span>
			</div>
			{#if step === 'text'}
				<label>
					<span>{low ? 'What is wrong or unclear on it? Say where, if you can.' : 'Anything wrong on it, or anything you love? (optional)'}</span>
					<textarea bind:value={text} maxlength={TEXT_MAX} rows="3"></textarea>
				</label>
				<button type="button" class="send" disabled={!text.trim() || busy} onclick={send}>Send</button>
			{/if}
			<p class="legal">No account, no name: only the stars and what you write are stored. <a href="/legal#feedback">Privacy notice</a></p>
		{/if}
	</div>
	{#if share}<ChartShare {path} {code} text={shareText} />{/if}
</section>

<style>
	.fb {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 1rem;
		margin-top: 2rem;
	}
	.fb.alone {
		grid-template-columns: minmax(0, 28rem);
	}
	.ask {
		border: 1px solid var(--line-strong);
		border-radius: calc(var(--radius) + 4px);
		padding: 1rem 1.1rem 1.1rem;
		background: var(--surface, #fff);
		min-width: 0;
	}
	h2 {
		margin: 0 0 0.5rem;
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: 1.2rem;
		font-weight: 600;
		line-height: 1.25;
		color: var(--heading);
	}
	p {
		margin: 0;
		color: var(--ink-muted);
		font-size: var(--step--1);
		line-height: 1.45;
	}
	.legal {
		margin-top: 0.6rem;
		font-size: 0.8rem;
	}
	.legal a {
		color: inherit;
	}
	.stars {
		display: flex;
		align-items: center;
		flex-wrap: wrap;
		gap: 0.15rem;
	}
	.stars button {
		min-width: 2.75rem;
		min-height: 2.75rem;
		display: inline-flex;
		align-items: center;
		justify-content: center;
		border: 0;
		background: none;
		color: var(--line-strong);
		cursor: pointer;
		border-radius: 8px;
	}
	.stars button.on {
		color: #d99a00;
	}
	.stars button:disabled {
		cursor: default;
	}
	.word {
		margin-inline-start: 0.5rem;
		font-size: var(--step--1);
		font-weight: 700;
		color: var(--ink-muted);
	}
	label {
		display: block;
		margin-top: 0.7rem;
	}
	label span {
		display: block;
		font-size: var(--step--1);
		font-weight: 600;
		margin-bottom: 0.3rem;
	}
	textarea {
		width: 100%;
		box-sizing: border-box;
		font: inherit;
		padding: 0.55rem 0.65rem;
		border: 1px solid var(--line-strong);
		border-radius: 8px;
		resize: vertical;
	}
	.send {
		margin-top: 0.6rem;
		min-height: 2.75rem;
		padding: 0 1.3rem;
		border: 0;
		border-radius: 999px;
		background: var(--navy);
		color: #fff;
		font: inherit;
		font-weight: 700;
		cursor: pointer;
	}
	.send:disabled {
		opacity: 0.5;
		cursor: default;
	}
	@media (max-width: 40rem) {
		.fb {
			grid-template-columns: 1fr;
		}
	}
</style>
