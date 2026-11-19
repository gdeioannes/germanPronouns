<script lang="ts">
	// The feedback card in the corner and the panel with the text boxes.
	// Mounted once, in the root layout; state/feedback.svelte.ts decides what
	// shows and when.
	//
	// The card never blocks the page (no scrim, no focus grab): it is a
	// question on the side, and the × is always there. Three kinds:
	//   site      "How do you like the site so far?" — one tap on the stars;
	//   audience  "Your book is downloading. Who is it for?" — one tap;
	//   book      "How is the A1.1 book going?" — one tap on the stars.
	// A 1–3 tap opens the panel; a 4–5 tap says thanks (and, for a book,
	// offers sharing and a quote).
	import Sheet from '$lib/components/Sheet.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { announce } from '$lib/a11y.svelte';
	import { feedback } from '$lib/state/feedback.svelte';
	import { NAME_MAX, QUOTE_MAX, SCHOOL_MAX, TEXT_MAX } from '$lib/services/feedback';
	import type { Audience } from '$lib/domain/bookAsk';
	import { fly } from 'svelte/transition';
	import { untrack } from 'svelte';
	import { cubicOut } from 'svelte/easing';
	import { prefersReducedMotion } from '$lib/motion';

	const STARS = [1, 2, 3, 4, 5];
	const WORDS = ['', 'Not good', 'Okay', 'Good', 'Very good', 'Love it'];
	const WHO: { id: Audience; label: string }[] = [
		{ id: 'me', label: 'Me' },
		{ id: 'class', label: 'My class' },
		{ id: 'child', label: 'My child' },
		{ id: 'other', label: 'Someone else' }
	];

	let comment = $state('');
	let wish = $state('');
	let mistake = $state('');
	let quote = $state('');
	let name = $state('');
	let quoteOk = $state(false);
	let school = $state('');
	let hover = $state(0);

	const cardTitle = $derived(
		feedback.kind === 'book' ? `How is the ${feedback.book} book going?` : 'How do you like the site so far?'
	);

	const panelTitle = $derived(
		{
			low: 'Sorry to hear that. What could be better?',
			wish: 'Tell us what you need :)',
			menu: 'Rate the site',
			bookLow: `What would make the ${feedback.book} book better?`,
			quote: 'Can we quote you?'
		}[feedback.mode]
	);

	const canSend = $derived(
		!feedback.sending &&
			(feedback.mode === 'menu'
				? feedback.rating > 0
				: feedback.mode === 'wish'
					? Boolean(wish.trim())
					: feedback.mode === 'quote'
						? Boolean(quote.trim()) && quoteOk
						: true)
	);

	// A fresh panel starts with empty boxes.
	$effect(() => {
		if (feedback.panel) {
			comment = wish = mistake = quote = name = '';
			quoteOk = false;
		}
	});

	$effect(() => {
		if (!feedback.card || feedback.thanked || feedback.askSchool) return;
		const words = `${cardTitle} Answer with one tap, or close.`;
		// Untracked: announce() reads and bumps its own counter, which would
		// make this effect re-run itself without end.
		untrack(() => announce(words));
	});

	async function submit(event: SubmitEvent) {
		event.preventDefault();
		if (await feedback.send({ comment, wish, mistake, quote, name, quoteOk })) announce('Thank you. Your feedback was sent.');
	}

	function sendSchool(event: SubmitEvent) {
		event.preventDefault();
		void feedback.sendSchool(school);
		school = '';
	}

	// The download panel opens fresh: an empty school line.
	$effect(() => {
		if (feedback.dlOpen) school = '';
	});

	const dur = () => (prefersReducedMotion() ? 0 : 220);
</script>

{#snippet closeButton(onclick: () => void)}
	<button type="button" class="x" aria-label="Close" {onclick}>
		<Icon name="close" size="1em" />
	</button>
{/snippet}

{#if feedback.card}
	<aside
		class="card"
		aria-labelledby="feedback-card-title"
		transition:fly={{ y: 24, duration: dur(), easing: cubicOut }}
	>
		{#if feedback.thanked}
			<div class="head">
				<p id="feedback-card-title" class="title thanks" lang="de">Danke schön!</p>
				{@render closeButton(() => (feedback.card = false))}
			</div>
			{#if feedback.kind === 'book'}
				<p class="sub">
					{feedback.sent
						? 'We read every message. Mistakes you report get fixed in the next edition.'
						: 'Glad the book helps.'}
				</p>
				<div class="row">
					<button type="button" class="pill" onclick={() => void feedback.share()}>
						<Icon name="external" size="1em" />
						{feedback.copied ? 'Link copied' : 'Share the books'}
					</button>
				</div>
				{#if !feedback.sent}
					<button type="button" class="link" onclick={() => feedback.openQuote()}>
						Can we quote you on the website?
					</button>
				{/if}
			{:else}
				<p class="sub">
					{feedback.sent
						? 'We read every message. Wishes that come up often get built first.'
						: 'Glad you like it. Your rating is saved.'}
				</p>
				{#if !feedback.sent}
					<button type="button" class="link" onclick={() => feedback.openWish()}>
						Tell us what you need to learn better
					</button>
				{/if}
			{/if}
		{:else}
			<div class="head">
				<p id="feedback-card-title" class="title">{cardTitle}</p>
				{@render closeButton(() => feedback.dismiss())}
			</div>
			<p class="sub">
					{feedback.kind === 'book'
						? 'One tap. It helps us make the next books better.'
						: "One tap. It's made by one person, and your rating really helps."}
				</p>
				<div class="stars" role="group" aria-label="Your rating" onpointerleave={() => (hover = 0)}>
					{#each STARS as n (n)}
						<button
							type="button"
							class="star"
							class:on={n <= hover}
							aria-label="{n} of 5 stars — {WORDS[n]}"
							onpointerenter={() => (hover = n)}
							onfocus={() => (hover = n)}
							onblur={() => (hover = 0)}
							onclick={() => void feedback.tapStar(n)}
						>
							<Icon name="star" size="1.9em" />
						</button>
					{/each}
				</div>
				<div class="ends" aria-hidden="true"><span>Not good</span><span>Love it</span></div>
		{/if}
	</aside>
{/if}

<!-- Every PDF button opens this first: the question, and the download one
     tap away whether they answer or not. -->
<Sheet bind:open={feedback.dlOpen} title="Your free PDF" id="download-panel">
	{#if feedback.dl}
		<div class="dl">
			{#if !feedback.dlAnswered}
				<p class="dl-q">Who is this book for?</p>
				<p class="sub">One tap, and your download starts. It helps us make the books better.</p>
				<div class="who">
					{#each WHO as w (w.id)}
						<button type="button" class="pill" onclick={() => void feedback.pickAudience(w.id)}>{w.label}</button>
					{/each}
				</div>
				<p class="or"><span>or</span></p>
				<a
					class="send"
					href={feedback.dl.href}
					download={feedback.dl.filename ?? ''}
					onclick={() => feedback.skippedQuestion()}
				>
					<Icon name="download" size="1.05em" /> Start the download
				</a>
				<p class="note">Answering is optional. The PDF is free either way.</p>
			{:else}
				<p class="dl-q thanks" lang="de">Danke schön!</p>
				<p class="sub">Your download has started. <span lang="de">Viel Spaß mit dem Buch!</span></p>
				{#if feedback.askSchool}
					<form class="school" onsubmit={sendSchool}>
						<label for="feedback-school">Which school or course? <span class="opt">(optional — it tells us where the books are used)</span></label>
						<input id="feedback-school" type="text" maxlength={SCHOOL_MAX} autocomplete="organization" bind:value={school} />
						<div class="row">
							<button type="submit" class="pill solid">Send</button>
						</div>
					</form>
				{:else}
					<button type="button" class="pill" onclick={() => (feedback.dlOpen = false)}>Back to the page</button>
				{/if}
				<p class="note">
					Nothing happening? <a href={feedback.dl.href} download={feedback.dl.filename ?? ''}>Start the download here</a>.
				</p>
			{/if}
		</div>
	{/if}
</Sheet>

<Sheet bind:open={feedback.panel} title={panelTitle} id="feedback-panel">
	<form class="form" onsubmit={submit}>
		{#if feedback.mode === 'menu'}
			<fieldset class="pick">
				<legend>How do you like the site?</legend>
				<div class="stars big" role="group" aria-label="Stars" onpointerleave={() => (hover = 0)}>
					{#each STARS as n (n)}
						<button
							type="button"
							class="star"
							class:on={n <= (hover || feedback.rating)}
							aria-label="{n} of 5 stars — {WORDS[n]}"
							aria-pressed={feedback.rating === n}
							onpointerenter={() => (hover = n)}
							onclick={() => (feedback.rating = n)}
						>
							<Icon name="star" size="2em" />
						</button>
					{/each}
					<span class="word">{WORDS[hover || feedback.rating]}</span>
				</div>
			</fieldset>
		{:else if feedback.rating && feedback.mode !== 'quote'}
			<p class="given">
				Your rating: <strong class="tnum">{feedback.rating} of 5</strong> — saved.
			</p>
		{/if}

		{#if feedback.mode === 'quote'}
			<label for="feedback-quote">One or two sentences about the book</label>
			<textarea
				id="feedback-quote"
				rows="3"
				maxlength={QUOTE_MAX}
				placeholder="What did it do for your German?"
				bind:value={quote}
			></textarea>
			<label for="feedback-name">Your first name <span class="opt">(optional — empty shows "a reader")</span></label>
			<input id="feedback-name" type="text" maxlength={NAME_MAX} autocomplete="given-name" bind:value={name} />
			<label class="agree">
				<input type="checkbox" bind:checked={quoteOk} />
				<span>You may show this sentence, with my first name, on the website.</span>
			</label>
		{:else if feedback.mode === 'bookLow'}
			<label for="feedback-comment">What's missing in the book, or could be better? <span class="opt">(optional)</span></label>
			<textarea
				id="feedback-comment"
				rows="4"
				maxlength={TEXT_MAX}
				placeholder="Too hard, too easy, a topic you need…"
				bind:value={comment}
			></textarea>
			<label for="feedback-mistake">Found a mistake? Tell us what's wrong <span class="opt">(optional)</span></label>
			{#if feedback.code}
				<p class="note">We know which page you came from (code {feedback.code}), so just say what's wrong.</p>
			{/if}
			<textarea
				id="feedback-mistake"
				rows="3"
				maxlength={TEXT_MAX}
				placeholder="Exercise 3: the answer key says…"
				bind:value={mistake}
			></textarea>
		{:else}
			{#if feedback.mode !== 'wish'}
				<label for="feedback-comment">
					{feedback.mode === 'low' ? "What didn't work for you?" : 'Anything you want to tell us?'}
					<span class="opt">(optional)</span>
				</label>
				<textarea
					id="feedback-comment"
					rows="4"
					maxlength={TEXT_MAX}
					placeholder="Something confusing, broken, boring… or something you love"
					bind:value={comment}
				></textarea>
			{/if}
			<label for="feedback-wish">
				What would help you learn German better? Tell us what you need :)
				<span class="opt">(optional)</span>
			</label>
			<textarea
				id="feedback-wish"
				rows="4"
				maxlength={TEXT_MAX}
				placeholder="More listening? A topic? A game?"
				bind:value={wish}
			></textarea>
		{/if}

		<p class="note">
			{feedback.mode === 'quote'
				? 'Nothing is shown before the person who makes the site reads it and chooses it.'
				: 'Anonymous. No login needed. Only the person who makes the site reads it.'}
		</p>
		{#if feedback.failed}
			<p class="err" role="alert">That didn't go through. Are you online? Try once more.</p>
		{/if}
		<button type="submit" class="send" disabled={!canSend}>
			{feedback.sending ? 'Sending…' : 'Send'}
		</button>
		{#if feedback.mode === 'menu' && !feedback.rating}
			<p class="note">Pick the stars first.</p>
		{/if}
	</form>
</Sheet>

<style>
	.card {
		position: fixed;
		z-index: 90;
		inset-inline-end: 1rem;
		bottom: calc(1rem + env(safe-area-inset-bottom));
		width: min(20rem, calc(100vw - 2rem));
		box-sizing: border-box;
		padding: 1rem 1.1rem 0.9rem;
		background: var(--surface);
		border: 1px solid var(--line);
		border-radius: 14px;
		box-shadow: 0 12px 32px rgb(31 58 95 / 0.16);
	}

	.head {
		display: flex;
		align-items: flex-start;
		justify-content: space-between;
		gap: 0.5rem;
	}

	.title {
		margin: 0;
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-weight: 600;
		font-size: 1.15rem;
		line-height: 1.25;
		color: var(--heading);
	}

	.title.thanks {
		color: var(--right);
		font-size: 1.3rem;
	}

	.x {
		flex: none;
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2.75rem;
		height: 2.75rem;
		margin: -0.6rem -0.7rem 0 0;
		border: 0;
		border-radius: 50%;
		background: transparent;
		color: var(--ink-muted);
		cursor: pointer;
	}

	.x:hover {
		color: var(--ink);
		background: var(--surface-alt);
	}

	.sub {
		display: block;
		margin: 0.35rem 0 0.5rem;
		font-size: 0.85rem;
		line-height: 1.5;
		color: var(--ink-muted);
	}

	.stars {
		display: flex;
		justify-content: space-between;
		align-items: center;
	}

	.stars.big {
		justify-content: flex-start;
		gap: 0.15rem;
	}

	.star {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 3rem;
		height: 3rem;
		padding: 0;
		border: 0;
		border-radius: 50%;
		background: transparent;
		color: #a89f94;
		cursor: pointer;
		transition: color var(--fast, 120ms) ease-out, transform var(--fast, 120ms) ease-out;
	}

	.star.on {
		color: var(--accent-ink);
	}

	.star.on :global(svg) {
		fill: var(--accent);
	}

	.star:active {
		transform: scale(0.92);
	}

	.word {
		margin-inline-start: 0.5rem;
		font-size: 0.9rem;
		color: var(--ink-muted);
	}

	.ends {
		display: flex;
		justify-content: space-between;
		padding: 0 0.4rem;
		font-size: 0.75rem;
		color: var(--ink-muted);
	}

	.who {
		display: grid;
		grid-template-columns: repeat(2, minmax(0, 1fr));
		gap: 0.5rem;
	}

	.row {
		display: flex;
		flex-wrap: wrap;
		gap: 0.5rem;
		margin-top: 0.2rem;
	}

	.pill {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		gap: 0.4rem;
		min-height: 2.75rem;
		padding: 0 0.9rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		background: var(--surface);
		color: var(--ink);
		font: inherit;
		font-weight: 600;
		cursor: pointer;
	}

	.pill:hover {
		border-color: var(--accent);
		color: var(--accent-ink);
	}

	.pill.solid {
		border-color: transparent;
		background: var(--accent-ink);
		color: #fff;
	}

	.school input,
	.form input[type='text'] {
		box-sizing: border-box;
		width: 100%;
		min-height: 2.75rem;
		padding: 0.5rem 0.75rem;
		font: inherit;
		color: var(--ink);
		background: var(--surface);
		border: 1px solid var(--line-strong);
		border-radius: 10px;
	}

	.school input {
		margin-bottom: 0.5rem;
	}

	.link {
		display: block;
		min-height: 2.75rem;
		padding: 0;
		border: 0;
		background: transparent;
		font: inherit;
		font-weight: 600;
		color: var(--accent-ink);
		text-decoration: underline;
		text-align: start;
		cursor: pointer;
	}

	.dl {
		display: flex;
		flex-direction: column;
		gap: 0.7rem;
	}

	.dl-q {
		margin: 0;
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-weight: 600;
		font-size: var(--step-2);
		color: var(--heading);
	}

	.dl-q.thanks {
		color: var(--right);
	}

	.dl .sub {
		margin: 0;
		font-size: 0.95rem;
	}

	.dl .send {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		gap: 0.5rem;
		text-decoration: none;
	}

	.or {
		display: flex;
		align-items: center;
		gap: 0.75rem;
		margin: 0.3rem 0 0;
		color: var(--ink-muted);
		font-size: 0.85rem;
	}

	.or::before,
	.or::after {
		content: '';
		flex: 1;
		border-top: 1px solid var(--line);
	}

	.school {
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
	}

	.school label {
		font-weight: 600;
		line-height: 1.4;
	}

	.dl .note a {
		color: var(--accent-ink);
		font-weight: 600;
	}

	.form {
		display: flex;
		flex-direction: column;
		gap: 0.6rem;
	}

	.pick {
		margin: 0 0 0.5rem;
		padding: 0;
		border: 0;
	}

	.pick legend {
		margin-bottom: 0.3rem;
		font-weight: 600;
	}

	.given {
		margin: 0 0 0.4rem;
		color: var(--ink-muted);
	}

	.form label {
		font-weight: 600;
		font-size: 0.95rem;
		line-height: 1.4;
		margin-top: 0.4rem;
	}

	.form label.agree {
		display: flex;
		gap: 0.6rem;
		align-items: flex-start;
		font-weight: 400;
	}

	.agree input {
		width: 1.25rem;
		height: 1.25rem;
		margin-top: 0.1rem;
		flex: none;
	}

	.opt {
		font-weight: 400;
		color: var(--ink-muted);
	}

	textarea {
		box-sizing: border-box;
		width: 100%;
		padding: 0.6rem 0.75rem;
		font: inherit;
		color: var(--ink);
		background: var(--surface);
		border: 1px solid var(--line-strong);
		border-radius: 10px;
		resize: vertical;
	}

	textarea:focus-visible,
	input:focus-visible {
		outline: 2px solid var(--accent);
		outline-offset: 1px;
	}

	.note {
		margin: 0.2rem 0 0;
		font-size: 0.8rem;
		color: var(--ink-muted);
	}

	.err {
		margin: 0;
		color: var(--wrong);
		font-size: 0.9rem;
	}

	.send {
		min-height: 2.9rem;
		margin-top: 0.4rem;
		border: 0;
		border-radius: 999px;
		background: var(--accent-ink);
		color: #fff;
		font: inherit;
		font-weight: 600;
		cursor: pointer;
	}

	.send:disabled {
		opacity: 0.5;
		cursor: default;
	}

	@media print {
		.card {
			display: none;
		}
	}
</style>
