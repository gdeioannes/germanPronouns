<script lang="ts">
	// The home page's Wortblöcke card: the site's own card with a little
	// game screen on it, a well that PLAYS — words fall, a one-colour
	// row turns gold and bursts, then a word is matched with its English and
	// article. Above it the real record from the Bestenliste. The loop only runs
	// while the cabinet is on screen; with reduced motion it shows one still
	// frame (the golden row) instead.
	import { onMount } from 'svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import { ARTICLE_COLORS, WORT_PATH, parseScores } from '$lib/domain/wortbloecke';
	import { t } from '$lib/i18n/t';
	import { track } from '$lib/services/analytics';

	const COLS = 8;
	const ROWS = 7;

	interface Piece {
		id: number;
		de: string;
		color: string;
		r: number;
		c: number;
		gold?: boolean;
		gone?: boolean;
		picked?: boolean;
	}

	let pieces = $state<Piece[]>([]);
	let pts = $state(0);
	let shown = $state(0);
	let pop = $state<{ id: number; text: string; r: number; c: number } | null>(null);
	let ask = $state<{ r: number; c: number; en: string; art: string; stage: 0 | 1 | 2 } | null>(null);
	let flash = $state(false);
	let record = $state<{ pts: number; name: string } | null>(null);

	let el: HTMLElement;
	let running = false;
	let timers: ReturnType<typeof setTimeout>[] = [];
	let nextId = 1;

	const wait = (ms: number) =>
		new Promise<void>((done) => {
			timers.push(setTimeout(done, ms));
		});

	/** A word drops in from above the well and lands at (r, c). */
	async function drop(de: string, art: keyof typeof ARTICLE_COLORS, r: number, c: number) {
		const p: Piece = { id: nextId++, de, color: ARTICLE_COLORS[art], r: -2, c };
		pieces = [...pieces, p];
		await wait(40);
		pieces = pieces.map((x) => (x.id === p.id ? { ...x, r } : x));
		await wait(620);
		return p.id;
	}

	function set(id: number, patch: Partial<Piece>) {
		pieces = pieces.map((x) => (x.id === id ? { ...x, ...patch } : x));
	}

	function gain(n: number) {
		pts += n;
	}

	// The counter rolls up to the score like a cabinet's.
	$effect(() => {
		if (shown === pts) return;
		const step = Math.max(1, Math.ceil((pts - shown) / 12));
		const id = setTimeout(() => (shown = Math.min(pts, shown + step)), 28);
		return () => clearTimeout(id);
	});

	async function loop() {
		while (running) {
			pieces = [];
			pts = 0;
			shown = 0;
			await wait(500);
			const hund = await drop('HUND', 'der', 6, 0);
			if (!running) return;
			const tor = await drop('TOR', 'das', 5, 1);
			if (!running) return;
			const baum = await drop('BAUM', 'der', 6, 4);
			if (!running) return;
			// One colour, full row: gold!
			await wait(250);
			set(hund, { gold: true });
			set(baum, { gold: true });
			flash = true;
			await wait(900);
			flash = false;
			pop = { id: nextId++, text: '+150 Zeile!', r: 5, c: 1 };
			gain(150);
			set(hund, { gone: true });
			set(baum, { gone: true });
			await wait(420);
			pieces = pieces.filter((x) => !x.gone);
			set(tor, { r: 6 });
			await wait(500);
			if (!running) return;
			await drop('UHR', 'die', 6, 5);
			if (!running) return;
			// Then a match: the English, then the article.
			set(tor, { picked: true });
			ask = { r: 6, c: 1, en: 'gate', art: 'das', stage: 0 };
			await wait(700);
			if (ask) ask = { ...ask, stage: 1 };
			await wait(700);
			if (ask) ask = { ...ask, stage: 2 };
			await wait(500);
			ask = null;
			pop = { id: nextId++, text: '+30 ★ das Tor', r: 5, c: 0 };
			gain(30);
			set(tor, { gone: true });
			await wait(1600);
			if (!running) return;
			// Clear the well for the next round.
			pieces = pieces.map((x) => ({ ...x, gone: true }));
			await wait(700);
		}
	}

	/** Reduced motion: one still frame, the golden row about to burst. */
	function still() {
		pieces = [
			{ id: 1, de: 'TOR', color: ARTICLE_COLORS.das, r: 5, c: 1 },
			{ id: 2, de: 'UHR', color: ARTICLE_COLORS.die, r: 5, c: 4 },
			{ id: 3, de: 'HUND', color: ARTICLE_COLORS.der, r: 6, c: 0, gold: true },
			{ id: 4, de: 'BAUM', color: ARTICLE_COLORS.der, r: 6, c: 4, gold: true }
		];
		pts = shown = 150;
	}

	function start() {
		if (running) return;
		running = true;
		void loop();
	}

	function stop() {
		running = false;
		timers.forEach(clearTimeout);
		timers = [];
	}

	async function loadRecord() {
		try {
			const local = parseScores(localStorage.getItem('wortbloecke_scores'))[0];
			if (local) record = { pts: local.pts, name: local.name };
		} catch {
			/* no storage: the world board may still answer */
		}
		try {
			const { fetchWorldScores, worldBoardAvailable } = await import('$lib/services/wortScores');
			if (!worldBoardAvailable()) return;
			const top = (await fetchWorldScores())?.[0];
			if (top && (!record || top.pts > record.pts)) record = { pts: top.pts, name: top.name };
		} catch {
			/* offline: the local record stands */
		}
	}

	onMount(() => {
		const calm = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
		if (calm) still();
		let asked = false;
		const io = new IntersectionObserver(
			([entry]) => {
				if (entry.isIntersecting && !asked) {
					asked = true;
					void loadRecord();
				}
				if (calm) return;
				if (entry.isIntersecting && document.visibilityState === 'visible') start();
				else stop();
			},
			{ threshold: 0.25 }
		);
		io.observe(el);
		const vis = () => {
			if (document.visibilityState === 'hidden') stop();
		};
		document.addEventListener('visibilitychange', vis);
		return () => {
			stop();
			io.disconnect();
			document.removeEventListener('visibilitychange', vis);
		};
	});

	const pad = (n: number) => String(n).padStart(6, '0');
</script>

<section class="cab" id="game" aria-labelledby="cab-title" bind:this={el}>
	<div class="screen">
		<div class="hud" aria-hidden="true">
			<span><small>Punkte</small><b class="tnum">{pad(shown)}</b></span>
			<span class="rec"><small>Rekord</small><b class="tnum">{record ? pad(record.pts) : '------'}</b>{#if record}<i>{record.name}</i>{/if}</span>
		</div>
		<a class="well" class:flash href={WORT_PATH} tabindex="-1" aria-hidden="true" style="--cols: {COLS}; --rows: {ROWS}">
			{#each pieces as p (p.id)}
				<span
					class="piece"
					class:gold={p.gold}
					class:gone={p.gone}
					class:picked={p.picked}
					style="--r: {p.r}; --c: {p.c}; --bc: {p.color}"
				>
					{#each p.de as ch, i (i)}<span class="sq">{ch}</span>{/each}
				</span>
			{/each}
			{#if ask}
				<span class="ask" style="--r: {ask.r}; --c: {ask.c}">
					<span class="chip" class:on={ask.stage >= 1}>{ask.en}</span>
					{#if ask.stage >= 1}<span class="art" class:on={ask.stage >= 2}>{ask.art}</span>{/if}
				</span>
			{/if}
			{#if pop}
				{#key pop.id}
					<span class="pop" style="--r: {pop.r}; --c: {pop.c}">{pop.text}</span>
				{/key}
			{/if}
		</a>
	</div>

	<div class="copy">
		<p class="kicker">{t('Arcade · free word game')}</p>
		<h2 id="cab-title" lang="de">Wortblöcke</h2>
		<p class="tag">{t('Match the word. Name the article. Turn the row gold.')}</p>
		<ul class="facts">
			<li lang="de"><b style:color={ARTICLE_COLORS.der}>der</b> · <b style:color={ARTICLE_COLORS.die}>die</b> · <b style:color={ARTICLE_COLORS.das}>das</b></li>
			<li>A1 → C2</li>
			<li>{t('No sign-up')}</li>
		</ul>
		<a class="play" href={WORT_PATH} onclick={() => track('wortbloecke_open', { from: 'home' })}>
			<span class="coin" aria-hidden="true">★</span>
			{t('Play Wortblöcke')}
			<Icon name="arrowRight" size="1.05em" />
		</a>
	</div>
</section>

<style>
	/* The site's own card (like the book offers), with one dark thing on it:
	   the game screen, in the site's navy. Gold is kept for the game's gold. */
	.cab {
		--screen: var(--navy);
		--screen-deep: #16304f;
		--gold: #e2b04a;
		--cs: clamp(1.45rem, 4.2vw, 2.05rem);

		display: grid;
		grid-template-columns: auto minmax(0, 1fr);
		align-items: center;
		gap: clamp(1.5rem, 5vw, 3rem);
		margin-top: 1.5rem;
		padding: 2rem 2.5rem;
		border: 1px solid var(--line);
		border-radius: var(--radius);
		background:
			radial-gradient(circle at 8% 90%, rgba(226, 176, 74, 0.18), transparent 45%),
			var(--surface);
		scroll-margin-top: 5rem;
	}

	.screen {
		display: flex;
		flex-direction: column;
		gap: 0.55rem;
		padding: 0.65rem;
		border-radius: 10px;
		background: var(--screen);
		box-shadow: 0 30px 50px -28px rgba(31, 58, 95, 0.7);
		transform: rotate(-2deg);
		transition: transform var(--medium) var(--ease-out);
	}

	.screen:hover {
		transform: rotate(-0.5deg) translateY(-3px);
	}

	.hud {
		display: flex;
		justify-content: space-between;
		gap: 1rem;
		padding: 0 0.15rem;
	}

	.hud span {
		display: flex;
		flex-direction: column;
		line-height: 1.15;
	}

	.hud small {
		color: rgba(255, 255, 255, 0.6);
		font-size: 0.62rem;
		font-weight: 700;
		letter-spacing: 0.12em;
		text-transform: uppercase;
	}

	.hud b {
		color: var(--gold);
		font-size: 1.05rem;
		font-variant-numeric: tabular-nums;
		letter-spacing: 0.06em;
	}

	.hud .rec {
		align-items: flex-end;
	}

	.hud .rec b {
		color: #fff;
	}

	.hud i {
		color: rgba(255, 255, 255, 0.6);
		font-style: normal;
		font-size: 0.66rem;
		font-weight: 700;
		letter-spacing: 0.1em;
	}

	.well {
		position: relative;
		display: block;
		width: calc(var(--cs) * var(--cols));
		height: calc(var(--cs) * var(--rows));
		overflow: hidden;
		border-radius: 6px;
		background:
			linear-gradient(rgba(255, 255, 255, 0.05) 1px, transparent 1px) 0 0 / var(--cs) var(--cs),
			linear-gradient(90deg, rgba(255, 255, 255, 0.05) 1px, transparent 1px) 0 0 / var(--cs) var(--cs),
			var(--screen-deep);
		text-decoration: none;
	}

	.well.flash {
		animation: flash 0.9s ease;
	}

	@keyframes flash {
		30% {
			box-shadow: inset 0 0 36px rgba(226, 176, 74, 0.45);
		}
	}

	.piece {
		position: absolute;
		left: 0;
		top: 0;
		display: flex;
		transform: translate(calc(var(--c) * var(--cs)), calc(var(--r) * var(--cs)));
		transition:
			transform 0.6s cubic-bezier(0.34, 1.25, 0.64, 1),
			opacity 0.4s ease;
	}

	.sq {
		display: grid;
		place-items: center;
		width: var(--cs);
		height: var(--cs);
		background: var(--bc);
		color: #fff;
		font-weight: 800;
		font-size: calc(var(--cs) * 0.46);
		box-shadow:
			inset 0 0 0 1px rgba(0, 0, 0, 0.18),
			inset 0 -3px 0 rgba(0, 0, 0, 0.15);
	}

	.sq:first-child {
		border-start-start-radius: 4px;
		border-end-start-radius: 4px;
	}

	.sq:last-child {
		border-start-end-radius: 4px;
		border-end-end-radius: 4px;
	}

	.piece.gold .sq {
		background: linear-gradient(160deg, #f3d27f, #c9952f);
		color: #4a3508;
		box-shadow:
			inset 0 0 0 1px rgba(120, 80, 0, 0.35),
			0 0 14px rgba(226, 176, 74, 0.55);
		animation: shimmer 0.9s ease;
	}

	@keyframes shimmer {
		from {
			filter: brightness(1.6);
		}
	}

	.piece.picked .sq {
		box-shadow:
			inset 0 0 0 2px #fff,
			0 0 12px rgba(255, 255, 255, 0.45);
	}

	.piece.gone {
		opacity: 0;
		transform: translate(calc(var(--c) * var(--cs)), calc(var(--r) * var(--cs))) scale(1.25);
	}

	.ask {
		position: absolute;
		left: 0;
		top: 0;
		display: flex;
		gap: 4px;
		transform: translate(calc(var(--c) * var(--cs)), calc((var(--r) - 1.25) * var(--cs)));
	}

	.chip,
	.art {
		padding: 0.15rem 0.5rem;
		border-radius: var(--radius-sm);
		font-size: 0.75rem;
		font-weight: 800;
		animation: rise 0.25s cubic-bezier(0.34, 1.56, 0.64, 1);
	}

	.chip {
		background: #fff;
		color: var(--navy);
	}

	.art {
		background: #3f7d4e;
		color: #fff;
	}

	.chip.on,
	.art.on {
		box-shadow: 0 0 0 2px var(--gold);
	}

	@keyframes rise {
		from {
			opacity: 0;
			transform: translateY(6px) scale(0.7);
		}
	}

	.pop {
		position: absolute;
		left: 0;
		top: 0;
		transform: translate(calc(var(--c) * var(--cs)), calc(var(--r) * var(--cs)));
		color: var(--gold);
		font-weight: 900;
		font-size: 0.95rem;
		white-space: nowrap;
		animation: float-up 1.3s ease forwards;
		pointer-events: none;
	}

	@keyframes float-up {
		to {
			opacity: 0;
			transform: translate(calc(var(--c) * var(--cs)), calc((var(--r) - 2) * var(--cs)));
		}
	}

	.copy {
		display: flex;
		flex-direction: column;
		align-items: flex-start;
		gap: 0.8rem;
	}

	.kicker {
		margin: 0;
		color: var(--accent-ink);
		font-size: 0.75rem;
		font-weight: 800;
		letter-spacing: 0.09em;
		text-transform: uppercase;
	}

	h2 {
		margin: 0;
		color: var(--heading);
		font-size: var(--step-3);
		line-height: 1.1;
	}

	.tag {
		margin: 0;
		max-width: 28rem;
		color: var(--ink-muted);
		font-size: 1.05rem;
		line-height: 1.6;
		text-wrap: balance;
	}

	.facts {
		display: flex;
		flex-wrap: wrap;
		gap: 0.45rem;
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.facts li {
		padding: 0.2rem 0.65rem;
		border: 1px solid var(--line-strong);
		border-radius: 999px;
		color: var(--ink-muted);
		font-size: 0.85rem;
	}

	.facts b {
		font-weight: 800;
	}

	/* The site's primary button, with a gold coin for the game. */
	.play {
		display: inline-flex;
		align-items: center;
		gap: 0.6rem;
		margin-top: 0.3rem;
		padding: 0.95rem 1.8rem;
		border-radius: 6px;
		background: var(--accent-ink);
		color: #fff;
		font-size: var(--step-0);
		font-weight: 700;
		text-decoration: none;
		box-shadow: 0 14px 30px -16px rgba(201, 104, 59, 0.8);
		transition: transform var(--medium) var(--ease-out);
	}

	.play:hover {
		transform: translateY(-2px);
	}

	.play:focus-visible {
		outline: 3px solid var(--heading);
		outline-offset: 3px;
	}

	.coin {
		display: grid;
		place-items: center;
		width: 1.45em;
		height: 1.45em;
		border-radius: 50%;
		background: var(--gold);
		color: #4a3508;
		font-size: 0.8em;
	}

	@media (max-width: 44rem) {
		.cab {
			grid-template-columns: minmax(0, 1fr);
			justify-items: center;
			padding: 1.5rem 1.25rem;
			text-align: center;
		}
		.copy {
			align-items: center;
		}
		.facts {
			justify-content: center;
		}
	}

	@media (prefers-reduced-motion: reduce) {
		.piece,
		.play,
		.screen {
			transition: none;
		}
		.well.flash,
		.piece.gold .sq,
		.pop,
		.chip,
		.art {
			animation: none;
		}
	}
</style>
