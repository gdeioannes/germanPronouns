<script lang="ts">
	// "Ja oder Nein?" — ten quick questions about life in Germany, swiped right
	// for Ja and left for Nein against a sky that will not sit still. Nothing
	// is marked; the reward is who you turn out to be and the row of squares
	// to send to someone (see domain/janein). Swipe, the two buttons, or the
	// arrow keys all answer; the sky calms down under "Calm effects" and
	// reduced motion.
	import Seo from '$lib/components/Seo.svelte';
	import SpeakButton from '$lib/components/SpeakButton.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { absoluteUrl, breadcrumbLd } from '$lib/seo';
	import {
		dealJaNein,
		isPair,
		JA_NEIN_PATH,
		JA_NEIN_QUESTIONS,
		markJaNeinPlayed,
		markSeenJaNein,
		scoreJaNein,
		shareText,
		whatsappHref,
		type Answer,
		type JaNeinQuestion,
		type JaNeinResult,
		type ShareLang
	} from '$lib/domain/janein';
	import { announce } from '$lib/a11y.svelte';
	import { celebrate } from '$lib/motion/fx.svelte';
	import { track } from '$lib/services/analytics';
	import { onMount } from 'svelte';
	import { page } from '$app/state';

	const LOCALE = 'de-DE';
	/** Where the card came from, and where both ways out lead: the course deck. */
	const DECK = '/course/de_cert_a1';
	const SHARE_URL = absoluteUrl(JA_NEIN_PATH);

	let questions = $state<JaNeinQuestion[]>([]);
	let answers = $state<Answer[]>([]);
	let phase = $state<'intro' | 'play' | 'done'>('intro');
	let result = $state<JaNeinResult | null>(null);

	const index = $derived(answers.length);
	const current = $derived<JaNeinQuestion | undefined>(questions[index]);
	/** The sky's hue walks a third of the wheel over a round; each answer shifts it. */
	const hue = $derived(200 + index * 36);

	// -- the gesture -----------------------------------------------------------
	let dx = $state(0);
	let dy = $state(0);
	let dragging = $state(false);
	/** The card flying off: which way, until the next question is up. */
	let leaving = $state<Answer | null>(null);
	let startX = 0;
	let startY = 0;
	let pointerId: number | null = null;
	const THRESHOLD = 90;
	const lean = $derived(Math.max(-1, Math.min(1, dx / THRESHOLD)));

	/** "?q=12" (1-based, from the dev review page) deals that question first. */
	function requested(): JaNeinQuestion | undefined {
		const n = Number(page.url.searchParams.get('q'));
		return n >= 1 ? JA_NEIN_QUESTIONS[n - 1] : undefined;
	}

	onMount(() => {
		const first = requested();
		questions = dealJaNein(Math.random, undefined, undefined, first);
		if (first) begin();
	});

	function begin() {
		phase = 'play';
		track('janein', { step: 'start' });
	}

	function onDown(e: PointerEvent) {
		if (phase !== 'play' || leaving) return;
		// A tap on the speak button is the button's, not the start of a swipe:
		// capturing the pointer here would swallow its click.
		if ((e.target as Element).closest('button')) return;
		pointerId = e.pointerId;
		startX = e.clientX;
		startY = e.clientY;
		dragging = true;
		(e.currentTarget as HTMLElement).setPointerCapture(e.pointerId);
	}

	function onMove(e: PointerEvent) {
		if (!dragging || e.pointerId !== pointerId) return;
		dx = e.clientX - startX;
		dy = (e.clientY - startY) * 0.4;
	}

	function onUp(e: PointerEvent) {
		if (!dragging || e.pointerId !== pointerId) return;
		dragging = false;
		pointerId = null;
		if (Math.abs(dx) >= THRESHOLD) answer(dx > 0 ? 'ja' : 'nein');
		else {
			dx = 0;
			dy = 0;
		}
	}

	function onCancel() {
		dragging = false;
		pointerId = null;
		dx = 0;
		dy = 0;
	}

	function onKey(e: KeyboardEvent) {
		if (phase !== 'play') return;
		if (e.key === 'ArrowRight' || e.key === 'Enter') answer('ja');
		else if (e.key === 'ArrowLeft') answer('nein');
		else return;
		e.preventDefault();
	}

	let timer: ReturnType<typeof setTimeout> | undefined;
	$effect(() => () => clearTimeout(timer));

	function answer(a: Answer) {
		if (phase !== 'play' || leaving || !current) return;
		leaving = a;
		dx = a === 'ja' ? 520 : -520;
		announce(a === 'ja' ? 'Ja!' : 'Nein!');
		timer = setTimeout(() => {
			answers = [...answers, a];
			leaving = null;
			dx = 0;
			dy = 0;
			if (answers.length >= questions.length) finish();
		}, 260);
	}

	function finish() {
		result = scoreJaNein(questions, answers);
		phase = 'done';
		markJaNeinPlayed();
		markSeenJaNein(questions);
		celebrate('Das bist du!');
		announce(`You are ${result.persona.title}. ${result.persona.line}`);
		track('janein', { step: 'finish', persona: result.persona.vibe, ja: result.ja });
	}

	// -- sharing ---------------------------------------------------------------
	/** The share's language: German is the native one, English for a friend who reads none. */
	let shareLang = $state<ShareLang>('de');
	const text = $derived(result ? shareText(result, SHARE_URL, shareLang) : '');
	let copied = $state(false);
	const canShare = $derived(typeof navigator !== 'undefined' && typeof navigator.share === 'function');

	async function share() {
		track('janein', { step: 'share', via: 'native' });
		try {
			await navigator.share({ text });
		} catch {
			/* dismissed */
		}
	}

	async function copy() {
		track('janein', { step: 'share', via: 'copy' });
		try {
			await navigator.clipboard.writeText(text);
			copied = true;
			announce('Copied.');
			setTimeout(() => (copied = false), 1800);
		} catch {
			/* no clipboard: the text is on screen to select */
		}
	}
</script>

<Seo
	title="Ja oder Nein? Ten swipes, one verdict"
	description="Ten quick yes-or-no questions about life in Germany, in easy German. Swipe, find out who you are tonight, and send the result to a friend."
	path={JA_NEIN_PATH}
	jsonLd={[breadcrumbLd([{ name: 'Home', path: '/' }, { name: 'Ja oder Nein?', path: JA_NEIN_PATH }])]}
/>

<div class="sky" style:--hue={hue} aria-hidden="true">
	<span class="blob a"></span>
	<span class="blob b"></span>
	<span class="blob c"></span>
	<span class="rays"></span>
</div>

<main class="janein" data-phase={phase}>
	<header class="top">
		<a class="back" href={DECK} aria-label="Back to your deck">
			<Icon name="arrowLeft" size="1em" /> Back
		</a>
		{#if phase === 'play'}
			<ol class="dots" aria-label="Question {index + 1} of {questions.length}">
				{#each questions as _, i (i)}
					<li class:done={i < index} class:now={i === index} data-answer={answers[i]}></li>
				{/each}
			</ol>
		{/if}
	</header>

	{#if phase === 'intro'}
		<section class="card intro">
			<p class="eyebrow">Surprise!</p>
			<h1>Ja oder Nein?</h1>
			<p class="lead">
				Ten questions about life in Germany. Swipe right for <strong lang="de">Ja</strong>, left for
				<strong lang="de">Nein</strong>, or towards the side you'd pick: <span lang="de">Oktoberfest oder
				Weihnachtsmarkt?</span> No marks, no wrong answers. At the end you find out who you are tonight,
				and you can send it to someone.
			</p>
			<button type="button" class="btn start" onclick={begin}>
				Let's go <Icon name="arrowRight" size="1em" />
			</button>
			<p class="meta">≈ 1 minute · a little German sneaks in</p>
		</section>
	{:else if phase === 'play' && current}
		<section class="stage">
			<!-- A stack of two: the question in hand on top, the next one waiting
			     underneath, smaller. An answered card flies off and is dropped from
			     the DOM, never to slide back; the one beneath grows into its place. -->
			<div class="stack">
				{#each [index + 1, index] as i (i)}
					{#if questions[i]}
						{@const q = questions[i]}
						{@const top = i === index}
						<div
							class="card question"
							class:top
							class:under={!top}
							class:dragging={top && dragging}
							class:leaving={top && leaving}
							style={top ? `transform: translate(${dx}px, ${dy}px) rotate(${dx / 16}deg);` : undefined}
							role="button"
							aria-roledescription="swipe card"
							aria-label="{q.de} ({q.en}). Right arrow or Enter for Ja, left arrow for Nein."
							aria-hidden={top ? undefined : 'true'}
							tabindex={top ? 0 : -1}
							onpointerdown={top ? onDown : undefined}
							onpointermove={top ? onMove : undefined}
							onpointerup={top ? onUp : undefined}
							onpointercancel={top ? onCancel : undefined}
							onkeydown={top ? onKey : undefined}
						>
							{#if top}
								<span class="stamp nein" class:pair={isPair(q)} style="opacity:{Math.max(0, -lean)}">{q.left?.de ?? 'Nein'}</span>
								<span class="stamp ja" class:pair={isPair(q)} style="opacity:{Math.max(0, lean)}">{q.right?.de ?? 'Ja'}</span>
							{/if}
							<p class="count tnum">{i + 1} / {questions.length}</p>
							{#if isPair(q)}
								<!-- This or that: the card itself shows which side is which. -->
								<div class="split" aria-hidden="true">
									<span class="side l">
										<span class="arrow">←</span>
										<span class="name" class:long={q.left.de.length > 11} lang="de">{q.left.de}</span>
										{#if q.left.en.toLowerCase() !== q.left.de.toLowerCase()}<span class="en">{q.left.en}</span>{/if}
									</span>
									<span class="oder" lang="de">oder</span>
									<span class="side r">
										<span class="arrow">→</span>
										<span class="name" class:long={q.right.de.length > 11} lang="de">{q.right.de}</span>
										{#if q.right.en.toLowerCase() !== q.right.de.toLowerCase()}<span class="en">{q.right.en}</span>{/if}
									</span>
								</div>
								<p class="gloss">Swipe left or right. Which one is you?</p>
							{:else}
								<p class="q" lang="de">{q.de}</p>
								<p class="gloss">{q.en}</p>
							{/if}
							<div class="hear">{#if top}<SpeakButton text={q.de} locale={LOCALE} />{/if}</div>
						</div>
					{/if}
				{/each}
			</div>
			{#if isPair(current)}
				<!-- This or that: the two options are the two buttons, left and right. -->
				<div class="answers">
					<button type="button" class="pick left" onclick={() => answer('nein')} aria-label="{current.left.de} ({current.left.en})">
						<span class="x" aria-hidden="true">←</span>
						<span class="opt"><span lang="de" class:long={current.left.de.length > 11}>{current.left.de}</span>{#if current.left.en.toLowerCase() !== current.left.de.toLowerCase()}<small>{current.left.en}</small>{/if}</span>
					</button>
					<button type="button" class="pick right" onclick={() => answer('ja')} aria-label="{current.right.de} ({current.right.en})">
						<span class="opt"><span lang="de" class:long={current.right.de.length > 11}>{current.right.de}</span>{#if current.right.en.toLowerCase() !== current.right.de.toLowerCase()}<small>{current.right.en}</small>{/if}</span>
						<span class="x" aria-hidden="true">→</span>
					</button>
				</div>
				<p class="hint">Pick one: swipe towards it, tap it, or use the arrow keys.</p>
			{:else}
				<div class="answers">
					<button type="button" class="pick nein" onclick={() => answer('nein')} aria-label="Nein">
						<span class="x" aria-hidden="true">✕</span> <span lang="de">Nein</span>
					</button>
					<button type="button" class="pick ja" onclick={() => answer('ja')} aria-label="Ja">
						<span lang="de">Ja</span> <span class="x" aria-hidden="true">♥</span>
					</button>
				</div>
				<p class="hint">Swipe, tap, or use the arrow keys.</p>
			{/if}
		</section>
	{:else if phase === 'done' && result}
		<section class="card verdict">
			<p class="eyebrow">Tonight you are</p>
			<p class="big" aria-hidden="true">{result.persona.emoji}</p>
			<h1 lang="de">{result.persona.title}</h1>
			<p class="lead">{result.persona.line}</p>
			<p class="word">
				Your word: <strong lang="de">{result.persona.word.de}</strong>
				<SpeakButton text={result.persona.word.de} locale={LOCALE} /> <span class="gloss">{result.persona.word.en}</span>
			</p>

			<!-- One row: the three ways to send it, and the language it goes in. -->
			<div class="share">
				<a class="ic wa" href={whatsappHref(text)} target="_blank" rel="noopener" aria-label="Send on WhatsApp" title="Send on WhatsApp" onclick={() => track('janein', { step: 'share', via: 'whatsapp' })}>
					<svg viewBox="0 0 24 24" width="22" height="22" fill="currentColor" aria-hidden="true"><path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413Z"/></svg>
				</a>
				{#if canShare}
					<button type="button" class="ic" onclick={share} aria-label="Share…" title="Share…"><Icon name="external" size="1.15em" /></button>
				{/if}
				<button type="button" class="ic" class:done={copied} onclick={copy} aria-label={copied ? 'Copied' : 'Copy'} title={copied ? 'Copied!' : 'Copy'}>
					<Icon name={copied ? 'check' : 'copy'} size="1.15em" />
				</button>
				<span class="langs" role="group" aria-label="Language of the message">
					<button type="button" class:on={shareLang === 'de'} aria-pressed={shareLang === 'de'} onclick={() => (shareLang = 'de')}>Deutsch</button>
					<button type="button" class:on={shareLang === 'en'} aria-pressed={shareLang === 'en'} onclick={() => (shareLang = 'en')}>English</button>
				</span>
			</div>
			<pre class="preview" lang={shareLang} aria-label="What you will send">{text}</pre>

			<div class="after">
				<a class="btn btn-ghost" href={DECK}>Back to your deck</a>
			</div>
		</section>
	{/if}
</main>

<style>
	/* -- the sky ------------------------------------------------------------- */
	.sky {
		position: fixed;
		inset: 0;
		z-index: -1;
		overflow: hidden;
		background: hsl(var(--hue, 200) 70% 12%);
		transition: background 900ms var(--ease-out);
		filter: saturate(1.25);
	}

	.blob {
		position: absolute;
		width: 70vmax;
		height: 70vmax;
		border-radius: 50%;
		filter: blur(60px);
		opacity: 0.85;
		mix-blend-mode: screen;
		transition: background 900ms var(--ease-out);
		animation: drift 18s ease-in-out infinite alternate;
	}

	.blob.a {
		top: -20vmax;
		left: -15vmax;
		background: radial-gradient(circle at 40% 40%, hsl(calc(var(--hue) + 40) 95% 60%), transparent 65%);
	}

	.blob.b {
		right: -20vmax;
		top: 10vmax;
		background: radial-gradient(circle at 60% 50%, hsl(calc(var(--hue) + 140) 95% 55%), transparent 65%);
		animation-duration: 23s;
		animation-delay: -7s;
	}

	.blob.c {
		left: 10vmax;
		bottom: -30vmax;
		background: radial-gradient(circle at 50% 40%, hsl(calc(var(--hue) + 260) 95% 58%), transparent 65%);
		animation-duration: 27s;
		animation-delay: -13s;
	}

	.rays {
		position: absolute;
		inset: -50%;
		background: conic-gradient(
			from 0deg,
			hsl(calc(var(--hue) + 0) 90% 60% / 0.18),
			transparent 12%,
			hsl(calc(var(--hue) + 90) 90% 60% / 0.18) 25%,
			transparent 37%,
			hsl(calc(var(--hue) + 180) 90% 60% / 0.18) 50%,
			transparent 62%,
			hsl(calc(var(--hue) + 270) 90% 60% / 0.18) 75%,
			transparent 87%,
			hsl(calc(var(--hue) + 0) 90% 60% / 0.18)
		);
		animation: spin 60s linear infinite;
	}

	@keyframes drift {
		from {
			transform: translate(0, 0) scale(1);
		}
		to {
			transform: translate(12vmax, 8vmax) scale(1.25);
		}
	}

	@keyframes spin {
		to {
			transform: rotate(360deg);
		}
	}

	:global(html[data-effects='calm']) .blob,
	:global(html[data-effects='calm']) .rays {
		animation: none;
	}

	@media (prefers-reduced-motion: reduce) {
		.blob,
		.rays {
			animation: none;
		}
	}

	/* -- the page ------------------------------------------------------------ */
	.janein {
		display: flex;
		flex-direction: column;
		min-height: 100dvh;
		padding: max(0.8rem, env(safe-area-inset-top)) 1rem max(1rem, env(safe-area-inset-bottom));
		color: #fff;
	}

	.top {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 1rem;
		min-height: 2.4rem;
	}

	.back {
		display: inline-flex;
		align-items: center;
		gap: 0.3rem;
		color: rgb(255 255 255 / 0.85);
		font-weight: 600;
		text-decoration: none;
	}

	.back:hover {
		color: #fff;
	}

	.dots {
		display: flex;
		gap: 0.3rem;
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.dots li {
		width: 0.55rem;
		height: 0.55rem;
		border-radius: 50%;
		background: rgb(255 255 255 / 0.3);
		transition: transform var(--fast) var(--ease-spring);
	}

	.dots li.now {
		background: #fff;
		transform: scale(1.3);
	}

	.dots li[data-answer='ja'] {
		background: #5ee2a0;
	}

	.dots li[data-answer='nein'] {
		background: #ff6b8a;
	}

	.card {
		position: relative;
		width: 100%;
		max-width: 26rem;
		margin: auto;
		padding: 1.6rem 1.4rem;
		border-radius: 22px;
		background: rgb(255 255 255 / 0.92);
		color: var(--ink);
		box-shadow:
			0 30px 60px -30px rgb(0 0 0 / 0.6),
			0 0 0 1px rgb(255 255 255 / 0.5) inset;
		backdrop-filter: blur(8px);
		text-align: center;
	}

	h1 {
		margin: 0.2rem 0 0;
		font-size: var(--step-4);
		line-height: 1.05;
		color: var(--heading);
	}

	.eyebrow {
		margin: 0;
		font-size: 0.75rem;
		font-weight: 700;
		letter-spacing: 0.1em;
		text-transform: uppercase;
		color: var(--accent-ink);
	}

	.lead {
		margin: 0.8rem 0 0;
		color: var(--ink);
	}

	.meta {
		margin: 0.6rem 0 0;
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.start {
		margin-top: 1.2rem;
		padding: 0.85rem 2.2rem;
		font-size: var(--step-1);
	}

	/* -- the question card --------------------------------------------------- */
	.stage {
		display: flex;
		flex: 1;
		flex-direction: column;
		align-items: center;
		justify-content: center;
		gap: 1rem;
	}

	/* Both cards in one cell, so the one underneath peeks out below the top. */
	.stack {
		display: grid;
		width: 100%;
		max-width: 26rem;
	}

	.stack > .question {
		grid-area: 1 / 1;
		margin: 0;
	}

	.question.under {
		transform: translateY(14px) scale(0.94);
		opacity: 0.8;
		pointer-events: none;
	}

	.question {
		min-height: 20rem;
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
		gap: 0.6rem;
		touch-action: pan-y;
		user-select: none;
		cursor: grab;
		transition: transform 320ms var(--ease-out);
		will-change: transform;
	}

	.question.dragging {
		transition: none;
		cursor: grabbing;
	}

	.question.leaving {
		transition: transform 260ms ease-in;
		pointer-events: none;
	}

	.question:focus-visible {
		outline: 3px solid #fff;
		outline-offset: 4px;
	}

	.count {
		position: absolute;
		top: 1rem;
		left: 0;
		right: 0;
		margin: 0;
		font-size: var(--step--1);
		font-weight: 600;
		color: var(--ink-muted);
	}

	.q {
		margin: 0.6rem 0 0;
		font-family: var(--font-display, inherit);
		font-size: var(--step-3);
		font-weight: 700;
		line-height: 1.15;
		color: var(--heading);
		text-wrap: balance;
	}

	.gloss {
		margin: 0;
		font-size: var(--step-0);
		color: var(--ink-muted);
	}

	.hear {
		margin-top: 0.2rem;
	}

	.stamp {
		position: absolute;
		top: 1.2rem;
		padding: 0.2rem 0.7rem;
		border: 3px solid currentColor;
		border-radius: 8px;
		font-size: var(--step-1);
		font-weight: 900;
		letter-spacing: 0.08em;
		text-transform: uppercase;
		pointer-events: none;
	}

	.stamp.nein {
		right: 1.2rem;
		color: var(--wrong);
		transform: rotate(12deg);
	}

	.stamp.ja {
		left: 1.2rem;
		color: var(--right);
		transform: rotate(-12deg);
	}

	.answers {
		display: flex;
		gap: 1rem;
		width: 100%;
		max-width: 26rem;
	}

	.pick {
		flex: 1;
		display: inline-flex;
		align-items: center;
		justify-content: center;
		gap: 0.5rem;
		padding: 0.9rem 1rem;
		border: 0;
		border-radius: 999px;
		font: inherit;
		font-size: var(--step-1);
		font-weight: 800;
		color: #fff;
		cursor: pointer;
		box-shadow: 0 12px 30px -14px rgb(0 0 0 / 0.7);
		transition: transform var(--fast) var(--ease-spring);
	}

	.pick:hover {
		transform: translateY(-2px) scale(1.03);
	}

	.pick:active {
		transform: scale(0.97);
	}

	.pick.nein {
		background: linear-gradient(135deg, #ff4d6d, #c9184a);
	}

	.pick.ja {
		background: linear-gradient(135deg, #38d39f, #1b998b);
	}

	/* This or that: two equal choices, neither the "good" one. */
	.pick.left {
		background: linear-gradient(135deg, #ff9f43, #ee5a24);
	}

	.pick.right {
		background: linear-gradient(135deg, #4cc9f0, #4361ee);
	}

	.pick.left,
	.pick.right {
		min-width: 0;
		padding-inline: 0.7rem;
		font-size: var(--step-0);
	}

	.pick .opt {
		display: flex;
		flex-direction: column;
		align-items: center;
		min-width: 0;
		line-height: 1.1;
	}

	.pick .opt > span:first-child {
		max-width: 100%;
		overflow-wrap: anywhere;
	}

	.pick .opt > span.long {
		font-size: 0.8em;
		letter-spacing: -0.01em;
	}

	.pick .opt small {
		font-size: 0.68rem;
		font-weight: 600;
		opacity: 0.85;
	}

	/* The this-or-that face of the card: two sides, an arrow on each. */
	.split {
		display: grid;
		grid-template-columns: minmax(0, 1fr) auto minmax(0, 1fr);
		align-items: center;
		gap: 0.4rem;
		width: 100%;
		margin-top: 0.6rem;
	}

	.side {
		display: flex;
		flex-direction: column;
		align-items: center;
		gap: 0.1rem;
		min-width: 0;
	}

	.side .arrow {
		font-size: var(--step-2);
		font-weight: 800;
		line-height: 1;
	}

	.side .name {
		max-width: 100%;
		font-family: var(--font-display, inherit);
		/* Weihnachtsmarkt has to fit beside its rival on a phone: the size
		   follows the screen, and a word that still will not fit breaks. */
		font-size: clamp(1.05rem, 5.2vw, var(--step-2));
		font-weight: 700;
		line-height: 1.1;
		overflow-wrap: anywhere;
	}

	/* One long word (Weihnachtsmarkt) fits whole at a smaller size rather
	   than breaking somewhere in the middle. */
	.side .name.long {
		font-size: clamp(0.85rem, 3.7vw, var(--step-1));
		letter-spacing: -0.01em;
	}

	.side .en {
		font-size: var(--step--1);
		color: var(--ink-muted);
	}

	.side.l {
		color: #c2410c;
	}

	.side.r {
		color: #3730a3;
	}

	.oder {
		font-size: var(--step--1);
		font-style: italic;
		color: var(--ink-muted);
	}

	.stamp.pair {
		font-size: var(--step-0);
		letter-spacing: 0.04em;
		text-transform: none;
	}

	.stamp.nein.pair {
		color: #ee5a24;
	}

	.stamp.ja.pair {
		color: #4361ee;
	}

	.pick .x {
		font-size: 1.1em;
	}

	.hint {
		margin: 0;
		font-size: var(--step--1);
		color: rgb(255 255 255 / 0.75);
	}

	/* -- the verdict --------------------------------------------------------- */
	.verdict {
		padding: 1.2rem 1.1rem 1rem;
	}

	.verdict h1 {
		font-size: var(--step-3);
	}

	.verdict .lead {
		margin-top: 0.4rem;
		font-size: var(--step--1);
	}

	.verdict .big {
		margin: 0.2rem 0 0;
		font-size: 2rem;
		line-height: 1;
	}

	.word {
		display: inline-flex;
		flex-wrap: wrap;
		align-items: center;
		justify-content: center;
		gap: 0.35rem;
		margin: 0.6rem 0 0;
		padding: 0.35rem 0.8rem;
		border-radius: 999px;
		background: var(--accent-soft);
		font-size: var(--step--1);
	}

	.word .gloss {
		font-size: inherit;
	}

	.share {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		justify-content: center;
		gap: 0.45rem;
		margin-top: 0.9rem;
	}

	.ic {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2.6rem;
		height: 2.6rem;
		border: 1px solid var(--line-strong);
		border-radius: 50%;
		background: var(--surface);
		color: var(--heading);
		cursor: pointer;
		transition: transform var(--fast) var(--ease-spring);
	}

	.ic:hover {
		transform: translateY(-1px) scale(1.05);
	}

	.ic.wa {
		border-color: #25d366;
		background: #25d366;
		color: #fff;
	}

	.ic.done {
		border-color: var(--right);
		color: var(--right);
	}

	.langs {
		display: inline-flex;
		gap: 0.25rem;
		margin-left: 0.35rem;
		font-size: var(--step--1);
	}

	.langs button {
		padding: 0.25rem 0.7rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		background: var(--surface);
		color: var(--ink);
		font: inherit;
		font-size: inherit;
		font-weight: 600;
		cursor: pointer;
	}

	.langs button.on {
		border-color: var(--navy);
		background: var(--navy);
		color: var(--paper);
	}

	.preview {
		margin: 0.5rem 0 0;
		padding: 0.55rem 0.75rem;
		border-radius: var(--radius-sm);
		background: var(--surface-alt);
		font: inherit;
		font-size: 0.78rem;
		line-height: 1.35;
		color: var(--ink);
		text-align: left;
		white-space: pre-wrap;
		overflow-wrap: anywhere;
	}

	.after {
		display: flex;
		flex-wrap: wrap;
		justify-content: center;
		gap: 0.5rem;
		margin-top: 0.8rem;
	}

	.after .btn {
		padding-block: 0.55rem;
	}

	@media (max-width: 36rem) {
		.card {
			padding: 1.3rem 1.1rem;
		}
		.question {
			min-height: 17rem;
		}
	}
</style>
