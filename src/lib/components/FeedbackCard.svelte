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
	import { t, tk } from '$lib/i18n/t';
	import Icon from '$lib/icons/Icon.svelte';
	import { announce } from '$lib/a11y.svelte';
	import { feedback } from '$lib/state/feedback.svelte';
	import { NAME_MAX, QUOTE_MAX, SCHOOL_MAX, TEXT_MAX } from '$lib/services/feedback';
	import type { Audience } from '$lib/domain/bookAsk';
	import { fly } from 'svelte/transition';
	import { untrack } from 'svelte';
	import { cubicOut } from 'svelte/easing';
	import { prefersReducedMotion } from '$lib/motion';
	import { ARTICLE_COLORS } from '$lib/domain/wortbloecke';

	const STARS = [1, 2, 3, 4, 5];
	const WORDS = ['', 'Not good', 'Okay', 'Good', 'Very good', 'Love it'];
	const WHO: { id: Audience; label: string }[] = [
		{ id: 'me', label: tk('Me') },
		{ id: 'class', label: tk('My class') },
		{ id: 'child', label: tk('My child') },
		{ id: 'other', label: tk('Someone else') }
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

	/** The Wortblöcke card's picture: a little board, bottom row golden. */
	const BLOCK_ROWS: { de: string; art: keyof typeof ARTICLE_COLORS; gold?: boolean }[][] = [
		[{ de: 'UHR', art: 'die' }],
		[{ de: 'HUND', art: 'der' }, { de: 'TOR', art: 'das' }],
		[{ de: 'LAMPE', art: 'die' }, { de: 'ROT', art: 'none' }],
		[{ de: 'HAUS', art: 'das', gold: true }, { de: 'BAUM', art: 'der', gold: true }]
	];
	const LEVELS = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

	/** "Deutsch A1.2", or the classic's own title. */
	const bookName = (book: string) => (book === 'Kafka' ? 'Die Verwandlung' : `Deutsch ${book}`);
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

{#snippet bridge()}
	{@const c = feedback.dlCompanion}
	{#if c && feedback.dl}
		<!-- The book's other half: its first chapter in the app, where the
		     recordings and the answer check are. -->
		<a class="promo" href={c.href} onclick={() => feedback.bridgeClicked()}>
			<span class="promo-body">
				<span class="promo-k">{t('This book continues in the app')}</span>
				<strong class="promo-hook" lang="de">{c.title}</strong>
				<span class="promo-line">{t('Chapter 1 is ready: hear its dialogues, check your answers and practise its words. Free, no account.')}</span>
				<span class="promo-btn">{t('Open chapter 1')} <Icon name="arrowRight" size="1em" /></span>
			</span>
		</a>
	{/if}
{/snippet}

<!-- Every PDF button opens this first: the question, and the download one
     tap away whether they answer or not. The panel is in the interface
     language; the star card and the text boxes below are English only. -->
<Sheet bind:open={feedback.dlOpen} title={t('Your free PDF')} id="download-panel">
	{#if feedback.dl}
		<div class="dl">
			{#if feedback.dlStarted && feedback.dlCompanion}
				<!-- Downloading, and not answering the question (a later book, or
				     the first one skipped): the book's chapter in the app. -->
				<p class="dl-ok">
					<span class="tick" aria-hidden="true"><Icon name="check" size="0.8em" /></span>
					<span>{t('{book} is downloading.', { book: bookName(feedback.dl.book) })}</span>
					<a href={feedback.dl.href} download={feedback.dl.filename ?? ''}>{t('Not starting?')}</a>
				</p>
				{@render bridge()}
				<button type="button" class="later" onclick={() => (feedback.dlOpen = false)}>{t('Not now')}</button>
			{:else if feedback.dlPromo}
				{@const p = feedback.dlPromo}
				<!-- Not the first book: it is already downloading; one card
				     about the rest of the site, a different one each time. -->
				<p class="dl-ok">
					<span class="tick" aria-hidden="true"><Icon name="check" size="0.8em" /></span>
					<span>{t('{book} is downloading.', { book: bookName(feedback.dl.book) })}</span>
					<a href={feedback.dl.href} download={feedback.dl.filename ?? ''}>{t('Not starting?')}</a>
				</p>
				<a class="promo" href={p.href} onclick={() => feedback.promoClicked()}>
					<span class="pic" class:dark={typeof p.visual !== 'object' || p.visual.book} aria-hidden="true">
						{#if typeof p.visual === 'object'}
							<img src={p.visual.img} alt="" class:book={p.visual.book} />
						{:else if p.visual === 'blocks'}
							<span class="blocks">
								{#each BLOCK_ROWS as row, r (r)}
									<span class="brow">
										{#each row as w, i (i)}
											<span class="bword">
												{#each w.de as ch, k (k)}<span class="bsq" class:gold={w.gold} style:background={w.gold ? null : ARTICLE_COLORS[w.art]}>{ch}</span>{/each}
											</span>
										{/each}
									</span>
								{/each}
							</span>
						{:else if p.visual === 'chat'}
							<span class="chat">
								<span class="bubble in" lang="de">Hallo! Bist du neu in Berlin? 👋</span>
								<span class="bubble out" lang="de">Ja! Seit gestern 😅</span>
								<span class="bubble in typing"><i></i><i></i><i></i></span>
							</span>
						{:else}
							<span class="ladder">
								{#each LEVELS as l, i (l)}
									<span class="step" style:height="{30 + i * 12}%" class:you={i === 2}>{l}{#if i === 2}<b>you?</b>{/if}</span>
								{/each}
							</span>
						{/if}
					</span>
					<span class="promo-body">
						<span class="promo-k">Also free on Language Quiz</span>
						<strong class="promo-hook">{p.hook}</strong>
						<span class="promo-line">{p.line}</span>
						<span class="promo-btn">{p.cta} <Icon name="arrowRight" size="1em" /></span>
					</span>
				</a>
				<button type="button" class="later" onclick={() => (feedback.dlOpen = false)}>{t('Not now')}</button>
			{:else if !feedback.dlAnswered}
				<p class="dl-q">{t('Who is this book for?')}</p>
				<p class="sub">{t('One tap, and your download starts. It helps us make the books better.')}</p>
				<div class="who">
					{#each WHO as w (w.id)}
						<button type="button" class="pill" onclick={() => void feedback.pickAudience(w.id)}>{t(w.label)}</button>
					{/each}
				</div>
				<p class="or"><span>{t('or')}</span></p>
				<a
					class="send"
					href={feedback.dl.href}
					download={feedback.dl.filename ?? ''}
					onclick={() => feedback.skippedQuestion()}
				>
					<Icon name="download" size="1.05em" /> {t('Start the download')}
				</a>
				<p class="note">{t('Answering is optional. The PDF is free either way.')}</p>
			{:else}
				<p class="dl-q thanks" lang="de">Danke schön!</p>
				<p class="sub">{t('Your download has started.')} <span lang="de">Viel Spaß mit dem Buch!</span></p>
				{#if feedback.askSchool}
					<form class="school" onsubmit={sendSchool}>
						<label for="feedback-school">{t('Which school or course?')} <span class="opt">{t('(optional — it tells us where the books are used)')}</span></label>
						<input id="feedback-school" type="text" maxlength={SCHOOL_MAX} autocomplete="organization" bind:value={school} />
						<div class="row">
							<button type="submit" class="pill solid">{t('Send')}</button>
						</div>
					</form>
				{:else if feedback.dlCompanion}
					{@render bridge()}
					<button type="button" class="later" onclick={() => (feedback.dlOpen = false)}>{t('Not now')}</button>
				{:else}
					<button type="button" class="pill" onclick={() => (feedback.dlOpen = false)}>{t('Back to the page')}</button>
				{/if}
				<p class="note">
					{t('Nothing happening?')} <a href={feedback.dl.href} download={feedback.dl.filename ?? ''}>{t('Start the download here')}</a>.
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

	.tick {
		display: inline-grid;
		place-items: center;
		width: 1.4em;
		height: 1.4em;
		margin-inline-end: 0.2em;
		border-radius: 50%;
		background: var(--right);
		color: #fff;
		vertical-align: 0.1em;
		font-size: 0.8em;
	}

	/* After the first book: one quiet line says it is downloading, and one
	   card about the site wants to be tapped — a picture, a hook, a button. */
	.dl-ok {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 0.4rem;
		margin: 0;
		color: var(--ink-muted);
		font-size: 0.92rem;
	}

	.dl-ok a {
		color: var(--ink-muted);
	}

	.promo {
		display: flex;
		flex-direction: column;
		overflow: hidden;
		border-radius: calc(var(--radius) + 4px);
		background: var(--surface);
		color: inherit;
		text-decoration: none;
		box-shadow:
			0 0 0 1px var(--line),
			0 18px 36px -22px rgba(31, 58, 95, 0.55);
		transition:
			transform var(--fast) var(--ease-out),
			box-shadow var(--fast) var(--ease-out);
	}

	.promo:hover {
		transform: translateY(-3px);
		box-shadow:
			0 0 0 1px var(--line-strong),
			0 24px 44px -22px rgba(31, 58, 95, 0.6);
	}

	.promo:focus-visible {
		outline: 3px solid var(--heading);
		outline-offset: 3px;
	}

	.pic {
		display: grid;
		place-items: center;
		height: 9.5rem;
		overflow: hidden;
		background: var(--accent-soft);
	}

	.pic.dark {
		background:
			radial-gradient(circle at 25% 0%, rgba(226, 176, 74, 0.25), transparent 60%),
			var(--navy);
	}

	.pic img {
		width: 100%;
		height: 100%;
		object-fit: cover;
		transition: transform var(--slow) var(--ease-out);
	}

	.pic img.book {
		width: auto;
		height: 118%;
		object-fit: contain;
		transform: rotate(-5deg) translateY(10%);
		box-shadow: 0 16px 30px -10px rgba(0, 0, 0, 0.6);
	}

	.promo:hover .pic img:not(.book) {
		transform: scale(1.04);
	}

	.blocks {
		display: flex;
		flex-direction: column;
		align-items: flex-start;
		gap: 3px;
	}

	.brow,
	.bword {
		display: flex;
	}

	.brow {
		gap: 3px;
	}

	.bsq {
		display: grid;
		place-items: center;
		width: 1.55rem;
		height: 1.55rem;
		color: #fff;
		font-weight: 800;
		font-size: 0.8rem;
		box-shadow:
			inset 0 0 0 1px rgba(0, 0, 0, 0.2),
			inset 0 -3px 0 rgba(0, 0, 0, 0.15);
	}

	.bword .bsq:first-child {
		border-start-start-radius: 4px;
		border-end-start-radius: 4px;
	}

	.bword .bsq:last-child {
		border-start-end-radius: 4px;
		border-end-end-radius: 4px;
	}

	.bsq.gold {
		background: linear-gradient(160deg, #f3d27f, #c9952f);
		color: #4a3508;
		box-shadow: 0 0 12px rgba(226, 176, 74, 0.7);
	}

	.chat {
		display: flex;
		flex-direction: column;
		gap: 0.35rem;
		width: min(18rem, 86%);
	}

	.bubble {
		max-width: 80%;
		padding: 0.4rem 0.7rem;
		border-radius: 14px;
		font-size: 0.85rem;
		line-height: 1.3;
	}

	.bubble.in {
		align-self: flex-start;
		border-end-start-radius: 4px;
		background: #fff;
		color: var(--navy);
	}

	.bubble.out {
		align-self: flex-end;
		border-end-end-radius: 4px;
		background: #e2b04a;
		color: #2b1d02;
	}

	.typing {
		display: flex;
		gap: 3px;
	}

	.typing i {
		width: 6px;
		height: 6px;
		border-radius: 50%;
		background: var(--navy);
		opacity: 0.5;
		animation: dot 1.2s infinite;
	}

	.typing i:nth-child(2) {
		animation-delay: 0.2s;
	}

	.typing i:nth-child(3) {
		animation-delay: 0.4s;
	}

	@keyframes dot {
		50% {
			opacity: 1;
			transform: translateY(-2px);
		}
	}

	.ladder {
		display: flex;
		align-items: flex-end;
		gap: 5px;
		height: 75%;
	}

	.step {
		position: relative;
		display: grid;
		place-items: end center;
		width: 2.2rem;
		padding-bottom: 0.3rem;
		border-radius: 5px 5px 0 0;
		background: rgba(255, 255, 255, 0.18);
		color: #fff;
		font-weight: 800;
		font-size: 0.8rem;
	}

	.step.you {
		background: #e2b04a;
		color: #2b1d02;
	}

	.step b {
		position: absolute;
		bottom: 100%;
		margin-bottom: 0.3rem;
		color: #e2b04a;
		font-size: 0.8rem;
		white-space: nowrap;
	}

	.promo-body {
		display: flex;
		flex-direction: column;
		align-items: flex-start;
		gap: 0.35rem;
		padding: 1rem 1.1rem 1.15rem;
	}

	.promo-k {
		color: var(--accent-ink);
		font-size: 0.7rem;
		font-weight: 800;
		letter-spacing: 0.09em;
		text-transform: uppercase;
	}

	.promo-hook {
		color: var(--heading);
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', ui-serif, Georgia, serif;
		font-size: 1.35rem;
		line-height: 1.2;
		text-wrap: balance;
	}

	.promo-line {
		color: var(--ink-muted);
		font-size: 0.92rem;
		line-height: 1.5;
	}

	.promo-btn {
		display: inline-flex;
		align-items: center;
		gap: 0.45rem;
		margin-top: 0.45rem;
		padding: 0.7rem 1.3rem;
		border-radius: 6px;
		background: var(--accent-ink);
		color: #fff;
		font-weight: 700;
		box-shadow: 0 12px 24px -14px rgba(201, 104, 59, 0.9);
	}

	.later {
		align-self: center;
		padding: 0.3rem 0.8rem;
		border: none;
		background: none;
		color: var(--ink-muted);
		font: inherit;
		font-size: 0.9rem;
		text-decoration: underline;
		cursor: pointer;
	}

	@media (prefers-reduced-motion: reduce) {
		.typing i {
			animation: none;
		}
		.promo,
		.pic img {
			transition: none;
		}
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
