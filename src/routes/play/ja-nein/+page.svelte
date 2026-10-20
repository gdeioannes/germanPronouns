<script lang="ts">
	import PageHelp from '$lib/components/PageHelp.svelte';
	// "Ja oder Nein?" — a themed round of twelve quick questions, one angle on a
	// Germany (see domain/janeinRounds for the shelves of rounds), swiped right
	// for Ja and left for Nein against a sky that will not sit still. Nothing
	// is marked; the reward is who you turn out to be and the row of squares
	// to send to someone (see domain/janein). Swipe, the two buttons, or the
	// arrow keys all answer; the sky calms down under "Calm effects" and
	// reduced motion.
	import Seo from '$lib/components/Seo.svelte';
	import SpeakButton from '$lib/components/SpeakButton.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { absoluteUrl, breadcrumbLd, gameLd } from '$lib/seo';
	import {
		decodeAnswers,
		encodeAnswers,
		isPair,
		JA_NEIN_PATH,
		plainText,
		shareText,
		whatsappHref,
		type Answer,
		type JaNeinQuestion,
		type ShareLang
	} from '$lib/domain/janein';
	import {
		categoryOf,
		collectionCount,
		earnPersona,
		findRound,
		markRoundPlayed,
		nextRound,
		resultStats,
		scoreRound,
		shuffled,
		type JaNeinRound,
		type RoundResult
	} from '$lib/domain/janeinRounds';
	import { announce } from '$lib/a11y.svelte';
	import { celebrate } from '$lib/motion/fx.svelte';
	import { track } from '$lib/services/analytics';
	import { onMount } from 'svelte';
	import { page } from '$app/state';

	const LOCALE = 'de-DE';
	/** Where the card came from, and where both ways out lead: the course deck. */
	const DECK = '/course/de_cert_a1';

	let round = $state<JaNeinRound | null>(null);
	let questions = $state<JaNeinQuestion[]>([]);
	let answers = $state<Answer[]>([]);
	/** 'shared': the page was opened from a friend's link and shows their card first. */
	let phase = $state<'intro' | 'play' | 'done' | 'shared'>('intro');
	let result = $state<RoundResult | null>(null);
	/** The result carried in the link, when someone sent theirs. */
	let friend = $state<RoundResult | null>(null);
	/** The card on screen: the friend's before playing, yours after. */
	const shown = $derived(phase === 'shared' ? friend : result);
	/** The persona just earned was not on the shelf before. */
	let fresh = $state(false);
	let shelf = $state({ earned: 0, total: 0 });

	const category = $derived(round ? categoryOf(round) : null);
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

	onMount(() => {
		// "?round=teller/brot" (the shelf page, the dev table) plays that round;
		// otherwise the next one in the tour, the same the deck card showed.
		const asked = findRound(page.url.searchParams.get('round'));
		round = asked ?? nextRound();
		if (round) questions = shuffled(round);
		shelf = collectionCount();
		// "&a=jnjj…": a friend's answers; their card comes first, then the dare.
		const theirs = asked && decodeAnswers(page.url.searchParams.get('a'), asked.questions.length);
		if (asked && theirs) {
			friend = scoreRound(asked, asked.questions, theirs);
			phase = 'shared';
			track('janein', { step: 'open_shared', round: asked.key, persona: friend.persona.id });
		} else if (asked && page.url.searchParams.has('go')) begin();
	});

	function begin() {
		phase = 'play';
		track('janein', { step: 'start', round: round?.key ?? '' });
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
		if (!round) return;
		result = scoreRound(round, questions, answers);
		phase = 'done';
		markRoundPlayed(round.key);
		fresh = earnPersona(result);
		shelf = collectionCount();
		celebrate(fresh ? 'Neu!' : 'Das bist du!');
		announce(
			`${result.category.en} You are ${result.persona.title}, ${Math.round(result.mix[0].share * 100)} percent. ${result.persona.line}${fresh ? ' New on your shelf.' : ''}`
		);
		track('janein', { step: 'finish', round: round.key, persona: result.persona.id, ja: result.ja, fresh });
	}

	// -- sharing ---------------------------------------------------------------
	/** The share's language: German is the native one, English for a friend who reads none. */
	let shareLang = $state<ShareLang>('de');
	/** Where the "you" pin sits: the centre of your slice of the fixed-order bar. */
	const pin = $derived.by(() => {
		const r = shown;
		if (!r) return { slice: 0, at: 0 };
		const slice = r.slices.findIndex((m) => m.persona.id === r.persona.id);
		const before = r.slices.slice(0, slice).reduce((n, m) => n + m.share, 0);
		return { slice, at: (before + r.mix[0].share / 2) * 100 };
	});
	const stats = $derived(shown ? resultStats(shown, shareLang) : { verdict: '', style: '', streak: { answer: 'ja' as Answer, length: 0 } });
	/** The link carries the round, so whoever gets the message plays the same twelve and can answer back. */
	const shareUrl = $derived(
		absoluteUrl(
			round && result
				? `${JA_NEIN_PATH}?round=${round.key}&a=${encodeAnswers(round.questions, questions, answers)}`
				: round
					? `${JA_NEIN_PATH}?round=${round.key}`
					: JA_NEIN_PATH
		)
	);
	const text = $derived(result ? shareText(result, shareUrl, shareLang) : '');
	let copied = $state(false);
	/** A desktop: WhatsApp Desktop breaks emoji in links, so it gets the plain message (and the full one on the clipboard). */
	const desktop = $derived(typeof matchMedia !== 'undefined' && matchMedia('(hover: hover) and (pointer: fine)').matches);
	const waText = $derived(desktop ? plainText(text) : text);

	function onWhatsapp() {
		track('janein', { step: 'share', via: desktop ? 'whatsapp-desktop' : 'whatsapp' });
		if (desktop) navigator.clipboard?.writeText(text).catch(() => {});
	}
	async function copy() {
		track('janein', { step: 'share', via: 'copy' });
		try {
			await navigator.clipboard.writeText(text);
			copied = true;
			announce(shareLang === 'de' ? 'Kopiert.' : 'Copied.');
			setTimeout(() => (copied = false), 1800);
		} catch {
			/* no clipboard */
		}
	}
</script>

<Seo
	title="Ja oder Nein? A German yes-or-no swipe game | Language Quiz"
	description="Which German city are you? Which animal, which drink? Twelve quick swipes in easy German, your type in percent at the end, fifty personas to collect. Free, no sign-up."
	path={JA_NEIN_PATH}
	jsonLd={[
		gameLd({
			name: 'Ja oder Nein?',
			description: 'Personality quizzes in easy German: twelve swipes, then your type in percent.',
			path: JA_NEIN_PATH,
			level: 'A1'
		}),
		breadcrumbLd([{ name: 'Home', path: '/' }, { name: 'Ja oder Nein?', path: JA_NEIN_PATH }])
	]}
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
		<span class="help-slot"><PageHelp topic="/play/ja-nein" tone="light" /></span>
	</header>

	{#if phase === 'intro' && round && category}
		<section class="card intro">
			<p class="eyebrow">Ja oder Nein? · {round.en}</p>
			<h1 lang="de">{category.title}</h1>
			<p class="angle"><span lang="de">{round.title}</span> · {category.en}</p>
			<p class="lead">
				{round.hook} Twelve questions: swipe right for <strong lang="de">Ja</strong>, left for
				<strong lang="de">Nein</strong>, or towards the side you'd pick. No marks, no wrong answers. At the
				end you find out which one you are, in percent, and it goes on your shelf.
			</p>
			<button type="button" class="btn start" onclick={begin}>
				Let's go <Icon name="arrowRight" size="1em" />
			</button>
			<p class="meta">≈ 1 minute · a little German sneaks in · <a href="{JA_NEIN_PATH}/personas">your personas: {shelf.earned} of {shelf.total}</a></p>
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
	{:else if (phase === 'done' && result) || (phase === 'shared' && friend)}
		{@const r = shown!}
		{@const theirs = phase === 'shared'}
		{@const de = shareLang === 'de'}
		{@const pct = Math.round(r.mix[0].share * 100)}
		<!-- One phone screen, no scrolling, everything in one card: the share
		     row, a tinted band with the type, the profile, the mix as one
		     stacked bar with a legend, two lines on your tendencies, who you
		     go with, and the word. -->
		<section class="card verdict" class:theirs lang={de ? 'de' : 'en'}>
			<div class="share">
				<span class="langs" role="group" aria-label="Language">
					<button type="button" class:on={de} aria-pressed={de} onclick={() => (shareLang = 'de')}>DE</button>
					<button type="button" class:on={!de} aria-pressed={!de} onclick={() => (shareLang = 'en')}>EN</button>
				</span>
				{#if theirs}
					<button type="button" class="btn dare" onclick={begin}>
						{de ? 'Und du? Die 12 Fragen' : 'And you? The 12 questions'} <Icon name="arrowRight" size="1em" />
					</button>
				{:else}
				<span class="send" role="group" aria-label={de ? 'Teilen' : 'Share'}>
					<a class="wa" href={whatsappHref(waText)} target="_blank" rel="noopener" onclick={onWhatsapp}>
						<svg viewBox="0 0 24 24" width="18" height="18" fill="currentColor" aria-hidden="true"><path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413Z"/></svg>
						<span>WhatsApp</span>
					</a>
					<button type="button" class="ic" class:done={copied} onclick={copy} aria-label={copied ? (de ? 'Kopiert' : 'Copied') : de ? 'Text kopieren' : 'Copy text'} title={copied ? (de ? 'Kopiert!' : 'Copied!') : de ? 'Text kopieren' : 'Copy text'}>
						<Icon name={copied ? 'check' : 'copy'} size="1em" />
					</button>
				</span>
				{/if}
			</div>

			<header class="band">
				<p class="eyebrow" lang="de">{r.category.title}</p>
				<span class="big" aria-hidden="true">{r.persona.emoji}</span>
				<p class="youare">
					{#if theirs}{de ? 'Jemand hat dir das geschickt. Diese Person ist' : 'Someone sent you this. They are'}{:else}{fresh ? (de ? 'Neu im Regal! Du bist' : 'New on your shelf! You are') : de ? 'Du bist' : 'You are'}{/if}
				</p>
				<h1 lang="de">{r.persona.title}</h1>
				<p class="pct tnum">{de ? `zu ${pct} %` : `${pct} %`}</p>
			</header>

			<p class="tagline">{de ? r.persona.de.line : r.persona.line}</p>
			<ul class="traits" aria-label={de ? 'Deine Eigenschaften' : 'Your traits'}>
				{#each de ? r.persona.de.traits : r.persona.traits as t (t)}<li>{t}</li>{/each}
			</ul>
			<p class="profile">{de ? r.persona.de.profile : r.persona.profile}</p>

			<div class="mix" aria-label={de ? 'Dein Mix' : 'Your mix'}>
				<!-- Five slices in the theme's fixed order and colours; the pin sits on
				     the one you won, so it moves with your answers. -->
				<div class="barwrap" aria-hidden="true">
					<span class="pin s{pin.slice}" style:left="{pin.at}%">
						<span class="pinlabel"><span>{r.persona.emoji}</span> {theirs ? (de ? 'sie' : 'them') : de ? 'du' : 'you'}</span>
						<span class="pintip"></span>
					</span>
					<div class="bar">
						{#each r.slices as m, i (m.persona.id)}
							<span class="s{i}" style:width="{m.share * 100}%"></span>
						{/each}
					</div>
				</div>
				<ul class="legend">
					{#each r.slices as m, i (m.persona.id)}
						<li class="s{i}" class:top={m.persona.id === r.persona.id}>
							<span class="dot" aria-hidden="true"></span>
							<span aria-hidden="true">{m.persona.emoji}</span>
							<span class="nm" lang="de">{m.persona.title}</span>
							<span class="n tnum">{Math.round(m.share * 100)} %</span>
						</li>
					{/each}
				</ul>
			</div>

			<ul class="stats">
				<li>{stats.verdict}</li>
				<li>{stats.style}{#if stats.streak.length >= 4}{' '}{de ? 'Längste Serie' : 'Longest run'}: {stats.streak.length}× <span lang="de">{stats.streak.answer === 'ja' ? 'Ja' : 'Nein'}</span>.{/if}</li>
			</ul>

			{#if !theirs && friend}
				<!-- The two of you: what came in the link against what you just got. -->
				<p class="duo">
					<span><span aria-hidden="true">{friend.persona.emoji}</span> <strong lang="de">{friend.persona.title}</strong> {Math.round(friend.mix[0].share * 100)} %</span>
					<span class="vs">{de ? 'gegen' : 'vs'}</span>
					<span><span aria-hidden="true">{r.persona.emoji}</span> <strong lang="de">{r.persona.title}</strong> {pct} %</span>
					<span class="verdict-duo">
						{#if friend.persona.id === r.persona.id}{de ? 'Zwillinge.' : 'Twins.'}
						{:else if friend.persona.id === r.match.id}{de ? 'Ihr passt zusammen.' : 'You two get on.'}
						{:else if friend.persona.id === r.clash.id}{de ? 'Clash! Das wird lustig.' : 'A clash. This will be fun.'}
						{:else}{de ? 'Verschieden, aber okay.' : 'Different, and fine.'}{/if}
					</span>
				</p>
			{/if}

			<div class="pals">
				<p class="pal">
					<span class="k">{de ? 'Passt zu' : 'Gets on with'}</span>
					<span class="v"><span aria-hidden="true">{r.match.emoji}</span> <strong lang="de">{r.match.title}</strong></span>
				</p>
				<p class="pal clash">
					<span class="k">{de ? 'Clash mit' : 'Clashes with'}</span>
					<span class="v"><span aria-hidden="true">{r.clash.emoji}</span> <strong lang="de">{r.clash.title}</strong></span>
				</p>
			</div>

			<footer class="foot">
				<span class="word">
					<strong lang="de">{r.persona.word.de}</strong>
					<SpeakButton text={r.persona.word.de} locale={LOCALE} />
					{#if !de}<span class="gloss" lang="en">{r.persona.word.en}</span>{/if}
				</span>
				<span class="links">
					{#if theirs}
						<a href="{JA_NEIN_PATH}/personas">{de ? 'Alle 50 Typen' : 'All 50 types'}</a>
					{:else}
						<a href="{JA_NEIN_PATH}/personas">{de ? 'Regal' : 'Shelf'} {shelf.earned}/{shelf.total}</a>
						<a href={DECK}>{de ? 'Deck' : 'Deck'}</a>
					{/if}
				</span>
			</footer>
		</section>
	{:else if !round}
		<!-- What the prerendered page (and a crawler) shows: the round is picked
		     in the browser, from this learner's tour. -->
		<section class="card intro">
			<p class="eyebrow">A swipe game in easy German</p>
			<h1 lang="de">Ja oder Nein?</h1>
			<p class="lead">
				Which German city are you, which animal, which drink? Twelve quick questions: swipe right for <strong lang="de">Ja</strong>, left for
				<strong lang="de">Nein</strong>. No marks, no wrong answers. At the end you get your type in percent,
				your mix, and what your answers say about you, and the persona goes on your shelf. There are a
				hundred rounds and fifty personas to collect.
			</p>
			<p class="meta">≈ 1 minute · <a href="{JA_NEIN_PATH}/personas">all the personas</a></p>
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

	.angle {
		margin: 0.3rem 0 0;
		font-size: var(--step--1);
		font-weight: 600;
		color: var(--ink-muted);
	}

	/* -- the verdict: one card, one phone screen ------------------------------ */
	.verdict {
		--h: var(--hue, 272);
		/* the five slices of the mix, one hue step apart, strongest first */
		--c0: hsl(var(--h) 70% 48%);
		--c1: hsl(calc(var(--h) + 45) 70% 58%);
		--c2: hsl(calc(var(--h) + 95) 60% 56%);
		--c3: hsl(calc(var(--h) + 150) 55% 58%);
		--c4: hsl(calc(var(--h) + 210) 50% 62%);
		max-width: 24rem;
		padding: 0.6rem 0.9rem 0.7rem;
		overflow: hidden;
		font-size: 0.78rem;
		line-height: 1.35;
	}

	/* -- share row ---------------------------------------------------------- */
	.share {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 0.5rem;
	}

	.send {
		display: inline-flex;
		gap: 0.3rem;
	}

	.ic {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2rem;
		height: 2rem;
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

	.wa {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
		height: 2rem;
		padding: 0 0.8rem 0 0.6rem;
		border-radius: 999px;
		background: #25d366;
		color: #fff;
		font-size: 0.74rem;
		font-weight: 800;
		text-decoration: none;
		white-space: nowrap;
		box-shadow: 0 8px 18px -10px #25d366;
		transition: transform var(--fast) var(--ease-spring);
	}

	.wa:hover {
		transform: translateY(-1px) scale(1.03);
	}

	.ic.done {
		border-color: var(--right);
		color: var(--right);
	}


	.langs {
		display: inline-flex;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		overflow: hidden;
		font-size: 0.7rem;
	}

	.langs button {
		padding: 0.3rem 0.65rem;
		border: 0;
		background: transparent;
		color: var(--ink);
		font: inherit;
		font-size: inherit;
		font-weight: 700;
		cursor: pointer;
	}

	.langs button.on {
		background: var(--navy);
		color: var(--paper);
	}

	.dare {
		padding: 0.4rem 0.9rem;
		font-size: 0.78rem;
	}

	.duo {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		justify-content: center;
		gap: 0.2rem 0.5rem;
		margin: 0.5rem 0 0;
		padding: 0.35rem 0.6rem;
		border-radius: var(--radius-sm);
		background: hsl(var(--h) 50% 95%);
		font-size: 0.76rem;
	}

	.duo .vs {
		font-size: 0.64rem;
		font-weight: 700;
		letter-spacing: 0.04em;
		text-transform: uppercase;
		color: var(--ink-muted);
	}

	.duo .verdict-duo {
		flex-basis: 100%;
		font-weight: 700;
		color: hsl(var(--h) 60% 32%);
	}

	/* -- the band ------------------------------------------------------------ */
	.band {
		margin: 0.5rem -0.9rem 0;
		padding: 0.6rem 0.9rem 0.55rem;
		background: linear-gradient(180deg, hsl(var(--h) 80% 92%), hsl(var(--h) 80% 97%) 70%, transparent);
	}

	.band .eyebrow {
		font-size: 0.66rem;
		color: hsl(var(--h) 60% 32%);
	}

	.band .big {
		display: block;
		margin: 0.25rem 0 0;
		font-size: 2.8rem;
		line-height: 1;
		filter: drop-shadow(0 6px 10px hsl(var(--h) 60% 40% / 0.3));
	}

	.youare {
		margin: 0.2rem 0 0;
		font-size: 0.7rem;
		color: var(--ink-muted);
	}

	.verdict h1 {
		margin: 0;
		font-size: var(--step-3);
		line-height: 1;
	}

	.pct {
		margin: 0.1rem 0 0;
		font-family: var(--font-display, inherit);
		font-size: var(--step-1);
		font-weight: 800;
		line-height: 1.1;
		color: hsl(var(--h) 65% 38%);
	}

	.tagline {
		margin: 0.4rem 0 0;
		font-size: 0.86rem;
		font-weight: 600;
		line-height: 1.25;
		color: var(--heading);
		text-wrap: balance;
	}

	.traits {
		display: flex;
		flex-wrap: wrap;
		justify-content: center;
		gap: 0.25rem;
		margin: 0.35rem 0 0;
		padding: 0;
		list-style: none;
	}

	.traits li {
		padding: 0.1rem 0.5rem;
		border-radius: 999px;
		background: hsl(var(--h) 50% 94%);
		color: hsl(var(--h) 60% 30%);
		font-size: 0.6rem;
		font-weight: 700;
		letter-spacing: 0.05em;
		text-transform: uppercase;
	}

	.profile {
		margin: 0.45rem 0 0;
		color: var(--ink);
		text-align: left;
	}

	/* -- the mix: one stacked bar and its legend ------------------------------ */
	.mix {
		margin-top: 0.55rem;
	}

	.barwrap {
		position: relative;
		padding-top: 1.45rem;
	}

	.pin {
		position: absolute;
		top: 0;
		display: flex;
		flex-direction: column;
		align-items: center;
		transform: translateX(-50%);
		transition: left 700ms var(--ease-out);
	}

	.pin.s0 { --seg: var(--c0); }
	.pin.s1 { --seg: var(--c1); }
	.pin.s2 { --seg: var(--c2); }
	.pin.s3 { --seg: var(--c3); }
	.pin.s4 { --seg: var(--c4); }

	.pinlabel {
		display: inline-flex;
		align-items: center;
		gap: 0.2rem;
		padding: 0.05rem 0.45rem;
		border-radius: 999px;
		background: var(--seg);
		color: #fff;
		font-size: 0.66rem;
		font-weight: 800;
		letter-spacing: 0.03em;
		white-space: nowrap;
		box-shadow: 0 4px 10px -4px var(--c0);
	}

	.pintip {
		width: 0;
		height: 0;
		border-left: 0.3rem solid transparent;
		border-right: 0.3rem solid transparent;
		border-top: 0.35rem solid var(--seg);
	}

	.bar {
		display: flex;
		height: 0.7rem;
		border-radius: 999px;
		overflow: hidden;
		background: var(--surface-alt);
	}

	.bar > span {
		display: block;
		height: 100%;
		background: var(--seg);
		transition: width 700ms var(--ease-out);
	}

	.s0 {
		--seg: var(--c0);
	}

	.s1 {
		--seg: var(--c1);
	}

	.s2 {
		--seg: var(--c2);
	}

	.s3 {
		--seg: var(--c3);
	}

	.s4 {
		--seg: var(--c4);
	}

	.legend {
		display: flex;
		flex-wrap: wrap;
		justify-content: center;
		gap: 0.2rem 0.55rem;
		margin: 0.35rem 0 0;
		padding: 0;
		list-style: none;
		font-size: 0.7rem;
		color: var(--ink-muted);
	}

	.legend li {
		display: inline-flex;
		align-items: center;
		gap: 0.25rem;
	}

	.legend li.top {
		color: var(--heading);
		font-weight: 700;
	}

	.legend .dot {
		width: 0.5rem;
		height: 0.5rem;
		border-radius: 50%;
		background: var(--seg);
	}

	/* -- tendencies, pals, foot ---------------------------------------------- */
	.stats {
		margin: 0.5rem 0 0;
		padding: 0;
		list-style: none;
		font-size: 0.74rem;
		color: var(--ink);
		text-align: left;
	}

	.stats li {
		position: relative;
		padding-left: 0.9rem;
	}

	.stats li::before {
		content: '';
		position: absolute;
		left: 0.1rem;
		top: 0.45em;
		width: 0.4rem;
		height: 0.4rem;
		border-radius: 50%;
		background: var(--c0);
	}

	.pals {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 0.4rem;
		margin-top: 0.5rem;
	}

	.pal {
		display: flex;
		flex-direction: column;
		margin: 0;
		padding: 0.3rem 0.5rem;
		border-radius: var(--radius-sm);
		background: hsl(var(--h) 50% 95%);
		font-size: 0.74rem;
		line-height: 1.2;
	}

	.pal .k {
		font-size: 0.62rem;
		font-weight: 700;
		letter-spacing: 0.04em;
		text-transform: uppercase;
		color: hsl(var(--h) 55% 35%);
	}

	.pal.clash {
		background: var(--wrong-bg, #fdecec);
	}

	.pal.clash .k {
		color: var(--wrong);
	}

	.foot {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 0.5rem;
		margin-top: 0.5rem;
		padding-top: 0.45rem;
		border-top: 1px solid var(--line);
		font-size: 0.74rem;
	}

	.word {
		display: inline-flex;
		align-items: center;
		gap: 0.3rem;
		min-width: 0;
	}

	.word .gloss {
		font-size: inherit;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
	}

	.links {
		display: inline-flex;
		gap: 0.6rem;
		white-space: nowrap;
	}

	.links a {
		color: var(--accent-ink);
		font-weight: 600;
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
