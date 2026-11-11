<script lang="ts">
	// The front page's hero: a carousel the visitor moves (swipe, arrows, dots,
	// keyboard; never by itself). Slide one is the message on the Bergmannstraße
	// photo, the page's only h1; the others each show one thing the course gives
	// you (levels, corrections, the books, the voice, open access) on a bright
	// moment of life in Germany.
	// Photos: the books' Commons photos, warm-graded into static/img/hero/
	// (credits on each slide; sources in assets/content/book2/de_cert_a1/_photos.json).
	import { onMount } from 'svelte';
	import SpeakButton from '$lib/components/SpeakButton.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { account } from '$lib/state/account.svelte';
	import { openSignIn } from '$lib/state/signin.svelte';

	type Card = 'levels' | 'fix' | 'books' | 'voice' | 'open';

	interface Slide {
		img: string;
		alt: string;
		/** Where the subject sits, for the crop. */
		focus: string;
		place: string;
		/** Small line above the title. */
		kicker: string;
		title: string;
		text: string;
		/** What the slide shows of the course. */
		card?: Card;
		/** The slide's own way in; the start link when left out. */
		cta?: { label: string; href: string };
		pins?: { a: 'der' | 'die' | 'das'; w: string; en: string; x: number; y: number }[];
		credit: string;
	}

	// Slide one says why; the others say what the course gives you, each on a
	// moment of life in Germany.
	const SLIDES: Slide[] = [
		{
			img: 'bergmannstrasse',
			alt: 'Friends at an outdoor café on a summer evening in Berlin-Kreuzberg',
			focus: '60% 60%',
			place: 'Bergmannstraße, Berlin',
			kicker: 'German for English speakers · A1 to C2',
			title: 'Learn German. Live better in Germany.',
			text: 'The German you need for the café, the flat, the doctor and the neighbours.',
			pins: [
				{ a: 'der', w: 'Baum', en: 'tree', x: 58, y: 18 },
				{ a: 'das', w: 'Café', en: 'café', x: 80, y: 44 },
				{ a: 'die', w: 'Freunde', en: 'friends', x: 66, y: 70 }
			],
			credit: 'JoachimKohler-HB, CC BY-SA 4.0'
		},
		{
			img: 'ostsee',
			alt: 'Blue beach chairs on the Baltic beach at Rostock',
			focus: '50% 60%',
			place: 'Warnemünde, Ostsee',
			kicker: 'Twelve levels, all open',
			title: 'Start at your level.',
			text: 'From your first Hallo to C2. A short check tells you where to begin, and you can move up or back whenever you like.',
			card: 'levels',
			cta: { label: 'Find my level', href: '/level-check/test' },
			credit: 'Bundesanstalt für Wasserbau, CC BY 2.0'
		},
		{
			img: 'markt',
			alt: 'Fruit and vegetables piled high at the Viktualienmarkt in Munich',
			focus: '50% 55%',
			place: 'Viktualienmarkt, München',
			kicker: 'Learn the rule, then use it',
			title: 'Every mistake explained.',
			text: 'Short lessons, then practice. A wrong answer is never just red: you see the right one and why.',
			card: 'fix',
			cta: { label: 'Try an exercise', href: '/course/de_cert_a1/quiz/quest_a1_1_artikel' },
			credit: 'Henning Schlottmann, CC BY-SA 4.0'
		},
		{
			img: 'hochzeit',
			alt: 'A wedding party with balloons outside Düsseldorf city hall',
			focus: '50% 60%',
			place: 'Rathaus, Düsseldorf',
			kicker: 'On paper too',
			title: 'A book for every level.',
			text: 'Twelve books, each chapter a real place in Germany. Do a page with a pencil, scan its code, and the app checks it.',
			card: 'books',
			cta: { label: 'See the books', href: '/books' },
			credit: 'Kürschner, CC0'
		},
		{
			img: 'oktoberfest',
			alt: 'Women and men in traditional dress at the Oktoberfest parade in Munich',
			focus: '65% 55%',
			place: 'Oktoberfest, München',
			kicker: 'Listening and speaking',
			title: 'Hear it. Say it.',
			text: 'Every sentence read aloud, as often as you need, and speaking practice in every chapter.',
			card: 'voice',
			credit: 'Jordiferrer, CC BY-SA 3.0'
		},
		{
			img: 'chiemsee',
			alt: 'A jetty on the Chiemsee with the Alps behind',
			focus: '50% 50%',
			place: 'Chiemsee, Bayern',
			kicker: 'Your pace, your order',
			title: 'Open to everyone.',
			text: 'Five minutes a day or a whole Sunday. Skip what you know, repeat what you don’t.',
			card: 'open',
			credit: 'SimonWaldherr, CC BY-SA 4.0'
		}
	];

	const LEVELS = ['A1.1', 'A1.2', 'A2.1', 'A2.2', 'B1.1', 'B1.2', 'B2.1', 'B2.2', 'C1.1', 'C1.2', 'C2.1', 'C2.2'];
	const COVERS = ['a1-1', 'b1-1', 'c2-2'];

	let { startHref = '/start', returning = false }: { startHref?: string; returning?: boolean } = $props();

	let track = $state<HTMLElement>();
	let index = $state(0);

	function go(i: number) {
		if (!track) return;
		const to = Math.max(0, Math.min(SLIDES.length - 1, i));
		const reduce = matchMedia('(prefers-reduced-motion: reduce)').matches;
		track.scrollTo({ left: to * track.clientWidth, behavior: reduce ? 'auto' : 'smooth' });
	}

	onMount(() => {
		if (!track) return;
		const onScroll = () => (index = Math.round(track!.scrollLeft / track!.clientWidth));
		track.addEventListener('scroll', onScroll, { passive: true });
		return () => track?.removeEventListener('scroll', onScroll);
	});

	// Swipe with a mouse too. Touch already swipes through scroll-snap, so only
	// mouse drags are handled here: the track follows the pointer, then snaps to
	// the next or previous slide once the drag passes 50px.
	let drag: { x: number; left: number; moved: boolean } | null = null;
	let justDragged = false;

	function onDown(e: PointerEvent) {
		if (e.pointerType !== 'mouse' || e.button !== 0 || !track) return;
		drag = { x: e.clientX, left: track.scrollLeft, moved: false };
	}

	function onMove(e: PointerEvent) {
		if (!drag || !track) return;
		const dx = e.clientX - drag.x;
		if (!drag.moved && Math.abs(dx) < 6) return;
		if (!drag.moved) {
			drag.moved = true;
			track.style.scrollSnapType = 'none';
			track.setPointerCapture(e.pointerId);
		}
		track.scrollLeft = drag.left - dx;
	}

	function onUp(e: PointerEvent) {
		if (!drag || !track) return;
		const dx = e.clientX - drag.x;
		const moved = drag.moved;
		const from = Math.round(drag.left / track.clientWidth);
		drag = null;
		if (!moved) return;
		justDragged = true;
		setTimeout(() => (justDragged = false));
		track.style.scrollSnapType = '';
		go(dx < -50 ? from + 1 : dx > 50 ? from - 1 : from);
	}

	/** A drag that ends on a link must not also follow it. */
	function onClickCapture(e: MouseEvent) {
		if (justDragged) {
			e.preventDefault();
			e.stopPropagation();
		}
	}

	function onKey(e: KeyboardEvent) {
		if (e.key === 'ArrowRight') go(index + 1);
		else if (e.key === 'ArrowLeft') go(index - 1);
	}
</script>

<!-- svelte-ignore a11y_no_noninteractive_element_interactions -->
<section class="carousel" aria-roledescription="carousel" aria-label="Life in Germany" onkeydown={onKey}>
	<!-- svelte-ignore a11y_no_static_element_interactions -->
	<div
		class="track"
		bind:this={track}
		aria-live="polite"
		onpointerdown={onDown}
		onpointermove={onMove}
		onpointerup={onUp}
		onpointercancel={onUp}
		onclickcapture={onClickCapture}
		ondragstart={(e) => e.preventDefault()}
	>
		{#each SLIDES as s, i (s.img)}
			<div class="slide" class:main={i === 0} role="group" aria-roledescription="slide" aria-label="{i + 1} of {SLIDES.length}">
				<img
					class="bg"
					src="/img/hero/{s.img}-2400.webp"
					srcset="/img/hero/{s.img}-1200.webp 1200w, /img/hero/{s.img}-2400.webp 2400w"
					sizes="100vw"
					alt={s.alt}
					style:object-position={s.focus}
					loading={i === 0 ? 'eager' : 'lazy'}
					fetchpriority={i === 0 ? 'high' : 'auto'}
				/>
				<div class="shade"></div>
				{#each s.pins ?? [] as p (p.w)}
					<span class="pin" style:left="{p.x}%" style:top="{p.y}%" lang="de"><span><b class={p.a}>{p.a}</b> {p.w}</span><small lang="en">{p.en}</small></span>
				{/each}
					<div class="copy">
						<p class="eyebrow">{s.kicker}</p>
						{#if i === 0}<h1>{s.title}</h1>{:else}<h2>{s.title}</h2>{/if}
						<!-- The action comes first, right under the headline, not after the reading. -->
						<div class="actions">
							<a class="btn" href={s.cta?.href ?? startHref} tabindex={i === index ? 0 : -1}>{s.cta?.label ?? (returning ? 'Keep learning' : 'Start learning German')} <Icon name="arrowRight" size="1em" /></a>
							<!-- Slide one only: the way back in for someone already learning elsewhere. -->
							{#if i === 0 && account.available && !account.signedIn}
								<p class="have-account">
									Already learning on another device?
									<button type="button" onclick={openSignIn} tabindex={i === index ? 0 : -1}>Sign in</button>
								</p>
							{/if}
						</div>
						<p class="lede">{s.text}</p>
						{#if s.card === 'levels'}
							<ul class="card levels" aria-label="The twelve levels">
								{#each LEVELS as l (l)}<li class:you={l === 'B1.1'}>{l}{#if l === 'B1.1'}<small>your level</small>{/if}</li>{/each}
							</ul>
						{:else if s.card === 'fix'}
							<div class="card fix">
								<p lang="de">Ich gehe in <s>der</s> Supermarkt.</p>
								<p class="ok" lang="de"><Icon name="check" size="0.95em" stroke={2.5} /> Ich gehe in <b>den</b> Supermarkt.</p>
								<p class="why"><b>Why:</b> <i lang="de">in</i> + where you go → accusative.</p>
							</div>
						{:else if s.card === 'books'}
							<div class="card books">
								<span class="covers">{#each COVERS as c (c)}<img src="/img/book-{c}-front.webp" alt="" loading="lazy" />{/each}</span>
								<span class="steps"><b>Scan a page</b> → checked · read aloud · flashcards</span>
							</div>
						{:else if s.card === 'voice'}
							<div class="card voice">
								<p lang="de">„Entschuldigung, ist hier noch frei?“ <SpeakButton text="Entschuldigung, ist hier noch frei?" locale="de-DE" label="Listen" /></p>
								<small>Excuse me, is this seat free?</small>
							</div>
						{:else if s.card === 'open'}
							<ul class="card open">
								<li><Icon name="check" size="1em" stroke={2.5} /> Every level open from day one</li>
								<li><Icon name="check" size="1em" stroke={2.5} /> No account needed</li>
								<li><Icon name="check" size="1em" stroke={2.5} /> Your first lesson takes five minutes</li>
							</ul>
						{/if}
					</div>
				<p class="credit">{s.place} · {s.credit}</p>
			</div>
		{/each}
	</div>

	<button type="button" class="arrow prev" onclick={() => go(index - 1)} disabled={index === 0} aria-label="Previous">
		<Icon name="arrowLeft" size="1.2em" />
	</button>
	<button type="button" class="arrow next" onclick={() => go(index + 1)} disabled={index === SLIDES.length - 1} aria-label="Next">
		<Icon name="arrowRight" size="1.2em" />
	</button>

	<div class="dots">
		{#each SLIDES as s, i (s.img)}
			<button type="button" class:on={i === index} onclick={() => go(i)} aria-label="Slide {i + 1}: {s.title}" aria-current={i === index}></button>
		{/each}
		{#if index === 0}<span class="hint">Swipe for more <Icon name="arrowRight" size="0.9em" /></span>{/if}
	</div>
</section>

<style>
	.carousel {
		position: relative;
		font-family: 'Inter Variable', Inter, system-ui, sans-serif;
	}

	.track {
		display: flex;
		height: min(42rem, 88vh);
		overflow-x: auto;
		overscroll-behavior-x: contain;
		scroll-snap-type: x mandatory;
		scrollbar-width: none;
		cursor: grab;
	}

	.track:active {
		cursor: grabbing;
	}

	.track::-webkit-scrollbar {
		display: none;
	}

	.track:focus-visible {
		outline: 3px solid #e8a33d;
		outline-offset: -3px;
	}

	.slide {
		position: relative;
		flex: 0 0 100%;
		display: flex;
		align-items: flex-end;
		scroll-snap-align: start;
		/* One swipe = one slide, however fast the flick. */
		scroll-snap-stop: always;
		overflow: hidden;
	}

	.bg {
		position: absolute;
		inset: 0;
		width: 100%;
		height: 100%;
		object-fit: cover;
	}

	.shade {
		position: absolute;
		inset: 0;
		background: linear-gradient(90deg, rgba(20, 22, 26, 0.7) 0%, rgba(20, 22, 26, 0.38) 38%, rgba(20, 22, 26, 0) 62%);
	}

	.copy {
		position: relative;
		width: 100%;
		max-width: 76rem;
		margin: 0 auto;
		padding: 2rem 5.5rem 5rem;
		color: #fff;
	}

	.copy h1,
	.copy h2,
	.copy .lede,
	.copy .eyebrow {
		text-shadow: 0 1px 2px rgba(0, 0, 0, 0.45), 0 2px 18px rgba(0, 0, 0, 0.45);
	}

	.eyebrow {
		color: #fff;
		margin: 0 0 0.8rem;
		font-size: 0.8rem;
		font-weight: 700;
		letter-spacing: 0.06em;
		text-transform: uppercase;
	}

	h1,
	h2 {
		max-width: 14ch;
		margin: 0 0 1rem;
		font-size: clamp(2.3rem, 1.4rem + 3.2vw, 4rem);
		line-height: 1.03;
		letter-spacing: -0.02em;
		color: #fff;
	}

	.lede {
		max-width: 32rem;
		margin: 0 0 1.5rem;
		font-size: 1.15rem;
		line-height: 1.55;
	}

	/* What the slide shows of the course: a white card under the words. */
	.card {
		max-width: 30rem;
		margin: 0 0 1.5rem;
		padding: 0.8rem 1rem;
		border-radius: var(--radius);
		background: rgba(255, 255, 255, 0.96);
		color: #14161a;
		box-shadow: 0 16px 36px -18px rgba(0, 0, 0, 0.6);
		text-shadow: none;
	}

	ul.card {
		list-style: none;
	}

	.levels {
		display: grid;
		grid-template-columns: repeat(6, minmax(0, 1fr));
		gap: 0.35rem;
	}

	.levels li {
		display: flex;
		flex-direction: column;
		align-items: center;
		padding: 0.3rem 0;
		border: 1px solid #ddd6cc;
		border-radius: 6px;
		font-size: 0.85rem;
		font-weight: 700;
	}

	.levels li.you {
		border-color: #a24c26;
		background: #a24c26;
		color: #fff;
	}

	.levels small {
		font-size: 0.6rem;
		font-weight: 600;
	}

	.fix p {
		margin: 0 0 0.3rem;
	}

	.fix s {
		color: #b4452f;
	}

	.fix .ok {
		display: flex;
		gap: 0.35rem;
		align-items: center;
		color: #3f7d4a;
		font-weight: 700;
	}

	.fix .why {
		margin: 0.5rem 0 0;
		padding-top: 0.5rem;
		border-top: 1px solid #eee;
		font-size: 0.9rem;
		color: #6e6458;
	}

	.books {
		display: flex;
		gap: 0.9rem;
		align-items: center;
	}

	.covers {
		display: flex;
		flex: none;
	}

	.covers img {
		width: 2.6rem;
		height: auto;
		margin-right: -0.7rem;
		border-radius: 2px;
		box-shadow: 0 4px 10px -4px rgba(0, 0, 0, 0.5);
	}

	.steps {
		margin-left: 0.6rem;
		font-size: 0.92rem;
	}

	.voice p {
		margin: 0;
		font-size: 1.1rem;
		font-weight: 700;
	}

	.voice small {
		color: #6e6458;
	}

	.open {
		display: grid;
		gap: 0.4rem;
		font-weight: 600;
	}

	.open li {
		display: flex;
		gap: 0.45rem;
		align-items: center;
	}

	.open :global(.icon) {
		color: #3f7d4a;
	}

	.btn {
		display: inline-flex;
		align-items: center;
		gap: 0.5rem;
		min-height: 3.3rem;
		padding: 0 1.8rem;
		border-radius: 6px;
		background: #a24c26;
		color: #fff;
		font-weight: 700;
		font-size: 1.05rem;
		text-decoration: none;
		box-shadow: 0 14px 30px -14px rgba(0, 0, 0, 0.6);
		margin: 0 0 1.1rem;
	}

	/* The start button with, on slide one, the sign-in for returning learners beside it. */
	.actions {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: 0 1.25rem;
		margin: 0 0 1.1rem;
	}

	.actions .btn {
		margin: 0;
	}

	.have-account {
		margin: 0.6rem 0;
		font-size: 0.95rem;
		color: #fff;
		text-shadow: 0 1px 2px rgba(0, 0, 0, 0.6);
	}

	.have-account button {
		padding: 0;
		border: 0;
		background: none;
		color: #fff;
		font: inherit;
		font-weight: 700;
		text-decoration: underline;
		text-underline-offset: 3px;
		cursor: pointer;
	}

	.have-account button:hover {
		text-decoration-thickness: 2px;
	}

	.pin {
		position: absolute;
		z-index: 1;
		display: flex;
		flex-direction: column;
		padding: 0.35rem 0.65rem;
		border-radius: 6px;
		background: #fff;
		box-shadow: 0 8px 18px -8px rgba(0, 0, 0, 0.45);
		font-weight: 700;
		font-size: 0.9rem;
		color: #14161a;
		white-space: nowrap;
	}

	.pin small {
		font-weight: 400;
		font-size: 0.7rem;
		color: #6e6458;
	}

	.der {
		color: #1f5fa8;
	}

	.die {
		color: #b4452f;
	}

	.das {
		color: #3f7d4a;
	}

	.credit {
		position: absolute;
		right: 0.75rem;
		bottom: 0.5rem;
		margin: 0;
		font-size: 0.68rem;
		color: rgba(255, 255, 255, 0.8);
		text-shadow: 0 1px 2px rgba(0, 0, 0, 0.6);
	}

	.arrow {
		position: absolute;
		top: 50%;
		z-index: 2;
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 3rem;
		height: 3rem;
		border: 0;
		border-radius: 50%;
		background: rgba(255, 255, 255, 0.9);
		color: #14161a;
		box-shadow: 0 8px 20px -8px rgba(0, 0, 0, 0.5);
		cursor: pointer;
		transform: translateY(-50%);
	}

	.arrow:disabled {
		opacity: 0;
		pointer-events: none;
	}

	.prev {
		left: 1rem;
	}

	.next {
		right: 1rem;
	}

	.dots {
		position: absolute;
		left: 50%;
		bottom: 2rem;
		z-index: 2;
		display: flex;
		gap: 0.5rem;
		align-items: center;
		transform: translateX(-50%);
	}

	.dots button {
		width: 0.65rem;
		height: 0.65rem;
		padding: 0;
		border: 0;
		border-radius: 999px;
		background: rgba(255, 255, 255, 0.55);
		cursor: pointer;
		transition: width 200ms ease;
	}

	.dots button.on {
		width: 1.8rem;
		background: #fff;
	}

	.hint {
		display: inline-flex;
		align-items: center;
		gap: 0.3rem;
		margin-left: 0.4rem;
		color: #fff;
		font-size: 0.8rem;
		font-weight: 600;
		/* Solid-enough backing: white text needs 4.5:1 whatever photo is behind. */
		background: rgba(0, 0, 0, 0.6);
		padding: 0.15rem 0.55rem;
		border-radius: 999px;
	}

	/* Phone: the photo on top, the words on dark under it; swipe to move. */
	@media (max-width: 52rem) {
		.track {
			height: auto;
		}
		.slide {
			display: block;
			background: #1d2026;
		}
		.bg {
			position: static;
			display: block;
			height: 19rem;
		}
		.shade,
		.pin {
			display: none;
		}
		.copy {
			padding: 1.5rem 1.25rem 2rem;
		}
		/* On a phone the carousel must say it is one: dots, the hint and small
		   arrows sit on the photo, where the thumb already is, not at the foot
		   of the slide under the page's floating buttons. */
		.arrow {
			top: 9.5rem;
			width: 2.4rem;
			height: 2.4rem;
			background: rgb(255 255 255 / 0.85);
		}
		.prev {
			left: 0.6rem;
		}
		.next {
			right: 0.6rem;
		}
		.dots {
			top: 16.6rem;
			bottom: auto;
			white-space: nowrap;
			padding: 0.3rem 0.7rem;
			border-radius: 999px;
			background: rgb(0 0 0 / 0.35);
		}
		.credit {
			top: 0.5rem;
			bottom: auto;
			right: 0.6rem;
		}
	}
</style>
