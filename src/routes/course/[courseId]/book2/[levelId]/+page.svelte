<script lang="ts">
	import Seo from '$lib/components/Seo.svelte';
	import Book2 from '$lib/components/book2/Book2.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import { returnTo, returnLabel } from '$lib/state/returnTo.svelte';
	import { page } from '$app/state';
	import type { PageData } from './$types';
	import { t } from '$lib/i18n/t';
	import { lang } from '$lib/i18n/lang.svelte';
	import { inLangBookFront, inLangChapter } from '$lib/i18n/content.svelte';
	import { BOOKS, bookPdf, hasLocalPdf } from '$lib/content/books';

	import { onMount, tick } from 'svelte';
	let { data }: { data: PageData } = $props();
	// In Turkish the book comes through its level's overlay: the explanations,
	// the word meanings and the translations change; the German stays.
	const book = $derived(
		lang.limited
			? {
					...inLangBookFront(data.book, data.book.level),
					chapters: data.book.chapters.map((c) => inLangChapter(c, data.book.level))
				}
			: data.book
	);
	const entry = $derived(BOOKS.find((b) => b.level === data.book.level));
	// ?cover prints the wraparound cover sheet, ?spine=7.5 its spine width, and
	// ?hd the print originals (tool/gen-book2.mjs). Read in the browser: the
	// page is prerendered, so the query string does not exist at build time.
	let cover = $state(false);
	let spine = $state(7.4);
	let hd = $state(false);
	let ready = $state(false);
	// The way back: the books list when it sent you here (?from=books), else
	// wherever the trip started (home or the deck), like any side trip.
	let fromBooks = $state(false);
	const courseHref = $derived(page.data.site?.courseHref ?? '/');
	const back = $derived(fromBooks ? { href: '/books', label: t('The books') } : { href: returnTo.path, label: returnLabel(returnTo.path) });
	onMount(() => {
		const q = new URLSearchParams(window.location.search);
		fromBooks = q.get('from') === 'books';
		cover = q.has('cover');
		spine = Number(q.get('spine') ?? 7.4);
		hd = q.has('hd');
		// The PDF printer (an automated browser) gets the book as it prints: one page, full size.
		if (!navigator.webdriver) {
			let saved: string | null = null;
			let savedFit: string | null = null;
			try { saved = localStorage.getItem(VIEW_KEY); savedFit = localStorage.getItem(FIT_KEY); } catch { /* private mode */ }
			spread = saved ? saved === 'spread' : window.innerWidth >= 1200;
			// A phone reads across the width; a big screen sees the whole page (or spread) at once.
			fit = savedFit === 'width' || savedFit === 'page' ? savedFit : window.innerWidth >= 1200 ? 'page' : 'width';
		}
		ready = true;
	});

	// The page view: one page or facing pages (the cover alone, as the book
	// opens), and a zoom. Fit width: the page, or both pages of a spread,
	// across the screen. Fit page: one whole page, or the whole spread, on
	// the screen top to bottom. The + and − steps go anywhere in between.
	const VIEW_KEY = 'book2.view';
	const FIT_KEY = 'book2.fit';
	const PX_PER_MM = 96 / 25.4;
	const STEPS = [0.25, 0.33, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 1.1, 1.25, 1.5, 1.75, 2, 2.5, 3];
	let spread = $state(false);
	let fit = $state<'width' | 'page' | null>(null);
	let manual = $state(1);
	let viewerWidth = $state(0);
	let innerHeight = $state(0);
	let barHeight = $state(0);
	let bar = $state<HTMLElement>();
	const clampScale = (s: number) => Math.min(STEPS[STEPS.length - 1], Math.max(0.2, s));
	/** 16 px of screen kept on each side of the book. */
	const widthScale = $derived(viewerWidth ? clampScale((viewerWidth - 32) / ((spread ? 420 : 210) * PX_PER_MM)) : 1);
	/** The whole sheet under the bar, 12 px clear above and below; never wider than the width fit. */
	const pageScale = $derived(innerHeight ? Math.min(widthScale, clampScale((innerHeight - barHeight - 24) / (297 * PX_PER_MM))) : widthScale);
	const scale = $derived(fit === 'width' ? widthScale : fit === 'page' ? pageScale : manual);
	/** No print run (navigator.webdriver) sets a fit: it stays at 100%. */
	const fitScale = $derived(Math.min(widthScale, pageScale));

	/** Scrolls the page at once: app.css scrolls smoothly, which would lag every jump and drag step. */
	function jumpBy(dy: number) {
		const html = document.documentElement;
		const was = html.style.scrollBehavior;
		html.style.scrollBehavior = 'auto';
		window.scrollBy(0, dy);
		html.style.scrollBehavior = was;
	}

	/**
	 * Keeps what the reader is looking at while the view changes under it:
	 * the spot of the page at the centre of the screen (so far down, so far
	 * across that page) is at the centre again afterwards. Fit page instead
	 * brings that whole page (or spread) onto the screen, its top under the bar.
	 * Then the change is shown as a zoom from the old view to the new one around
	 * that spot: one transform on the viewer (FLIP), so no page is laid out
	 * again while it plays.
	 */
	async function keepPlace(change: () => void, relayout = false) {
		if (!viewer) return change();
		const barBottom = bar?.getBoundingClientRect().bottom ?? 0;
		const cy = (barBottom + window.innerHeight) / 2;
		// The centre of the book's own box: the window's scrollbar is not part of it.
		const vr = viewer.getBoundingClientRect();
		const cx = vr.left + viewer.clientWidth / 2;
		const before = scale;
		const pages = [...document.querySelectorAll<HTMLElement>('.book2 > .page')];
		// The page under the centre, across and down: in a spread the right-hand
		// page is a different page from the left. In a gap, the nearest page.
		const dist = (p: HTMLElement) => {
			const b = p.getBoundingClientRect();
			return Math.hypot(Math.max(b.left - cx, 0, cx - b.right), Math.max(b.top - cy, 0, cy - b.bottom));
		};
		let at: HTMLElement | undefined;
		let best = Infinity;
		for (const p of pages) {
			const b = p.getBoundingClientRect();
			if (b.bottom < cy - window.innerHeight || b.top > cy + window.innerHeight) continue;
			const d = dist(p);
			if (d < best) { best = d; at = p; }
			if (d === 0) break;
		}
		const r = at?.getBoundingClientRect();
		const down = r ? Math.min(1, Math.max(0, (cy - r.top) / r.height)) : 0;
		const across = r ? Math.min(1, Math.max(0, (cx - r.left) / r.width)) : 0.5;
		viewer.getAnimations().forEach((a) => a.finish());
		change();
		await tick();
		if (!at) return;
		let n = at.getBoundingClientRect();
		if (fit === 'page') jumpBy(n.top - (bar?.getBoundingClientRect().bottom ?? 0) - 12);
		else {
			jumpBy(n.top + down * n.height - cy);
			viewer.scrollLeft += n.left + across * n.width - cx;
		}
		// Where the reader's spot is now; play from where it was, at the old size.
		n = at.getBoundingClientRect();
		const px = n.left + across * n.width;
		const py = n.top + down * n.height;
		const k = scale / before;
		if (window.matchMedia('(prefers-reduced-motion: reduce)').matches || (Math.abs(k - 1) < 0.01 && Math.hypot(cx - px, cy - py) < 2)) return;
		// One page ⇄ two: the pages change rows, so no zoom can carry the eye
		// from one layout to the other. A short fade instead of a slide.
		if (relayout) {
			viewer.animate([{ opacity: 0.25 }, { opacity: 1 }], { duration: 220, easing: 'ease-out' });
			return;
		}
		const v = viewer.getBoundingClientRect();
		// The reader's spot moved from (cx, cy) to (px, py) and the book grew by
		// k: zooming about the spot would carry it along, a slide. Any zoom plus
		// a shift is a pure zoom about one still point, f = spot + shift / (1 − 1/k):
		// the eye sees the pages grow or shrink in place, nothing travels.
		// Only when there is hardly any zoom (a pure shift) does the shift play as one.
		const s = 1 / k;
		const pure = Math.abs(1 - s) > 0.04;
		const fx = pure ? px + (cx - px) / (1 - s) : px;
		const fy = pure ? py + (cy - py) / (1 - s) : py;
		const origin = `${fx - v.left}px ${fy - v.top}px`;
		const from = pure ? `scale(${s})` : `translate(${cx - px}px, ${cy - py}px) scale(${s})`;
		viewer.animate(
			[
				{ transformOrigin: origin, transform: from },
				{ transformOrigin: origin, transform: 'none' }
			],
			// Ease in and out: the zoom is seen travelling, not a jump with a wobble at its end.
			{ duration: 340, easing: 'cubic-bezier(0.4, 0, 0.2, 1)' }
		);
	}
	function setSpread(on: boolean) {
		if (on === spread) return;
		keepPlace(() => (spread = on), true);
		try { localStorage.setItem(VIEW_KEY, on ? 'spread' : 'single'); } catch { /* private mode */ }
	}
	function zoom(dir: 1 | -1) {
		const now = scale;
		const next = dir > 0 ? STEPS.find((s) => s > now + 0.005) : [...STEPS].reverse().find((s) => s < now - 0.005);
		if (next) keepPlace(() => { manual = next; fit = null; });
	}
	function fitTo(to: 'width' | 'page') {
		keepPlace(() => (fit = to));
		try { localStorage.setItem(FIT_KEY, to); } catch { /* private mode */ }
	}

	// The hand: zoomed past Fit, a mouse drag moves the book, sideways inside
	// the viewer and up and down the page. Touch already pans with a finger.
	// A drag that moved is not a click, so it never opens a page code.
	let viewer = $state<HTMLElement>();
	let dragging = $state(false);
	const pannable = $derived(!cover && scale > fitScale + 0.005);
	let drag: { x: number; y: number; left: number; top: number; id: number } | null = null;
	function panStart(e: PointerEvent) {
		if (!pannable || e.pointerType !== 'mouse' || e.button !== 0 || !viewer) return;
		if ((e.target as HTMLElement).closest('input, textarea, select, button, label')) return;
		drag = { x: e.clientX, y: e.clientY, left: viewer.scrollLeft, top: window.scrollY, id: e.pointerId };
		e.preventDefault(); // no text selection, no picture drag
	}
	function panMove(e: PointerEvent) {
		if (!drag || !viewer || e.pointerId !== drag.id) return;
		const dx = e.clientX - drag.x;
		const dy = e.clientY - drag.y;
		if (!dragging) {
			if (Math.hypot(dx, dy) < 4) return;
			dragging = true;
			viewer.setPointerCapture(e.pointerId);
		}
		viewer.scrollLeft = drag.left - dx;
		jumpBy(drag.top - dy - window.scrollY);
	}
	function panEnd(e: PointerEvent) {
		if (!drag || e.pointerId !== drag.id) return;
		drag = null;
		if (!dragging) return;
		dragging = false;
		// The click that ends a drag lands on whatever is under the mouse: swallow it.
		// It fires right after pointerup; if none comes (released off the page), drop the trap.
		const swallow = (c: MouseEvent) => { c.preventDefault(); c.stopPropagation(); };
		window.addEventListener('click', swallow, { capture: true, once: true });
		setTimeout(() => window.removeEventListener('click', swallow, { capture: true }), 0);
	}
</script>

<Seo title="{data.book.title} · {data.book.subtitle} — book preview" description="A preview of the printed book, chapter by chapter." path="/course/{data.book.courseId}/book2/{data.book.level}" noindex />

<svelte:window bind:innerHeight />

<svelte:head>
	{@html cover ? `<style>@page { size: ${420 + spine + 6.35}mm 303.35mm; margin: 0; }</style>` : '<style>@page { size: A4; margin: 0; }</style>'}
	<!-- The fit scales follow the book's width. A scrollbar that comes and goes
	     with the zoom would change that width, and the scale, and the height,
	     and the scrollbar again: its gutter stays reserved on this page. -->
	<style>html { scrollbar-gutter: stable; }</style>
</svelte:head>

{#if !cover}
	<div class="chrome"><SiteNav {courseHref} compact /></div>
{/if}

<main data-ready={ready}>
	{#if !cover}
		<div class="title-row">
			<a class="back-link" href={back.href}><Icon name="arrowLeft" size="1em" /> {back.label}</a>
			<span class="book-title"><strong lang="de">{book.title}</strong> · <span lang="de">{book.subtitle}</span> · <span>{t('{n} chapters', { n: book.chapters.length })}</span></span>
		</div>
		<div class="dl-bar" bind:this={bar} bind:offsetHeight={barHeight}>
			<div class="seg" role="group" aria-label={t('Page view')}>
				<button type="button" aria-pressed={!spread} title={t('One page')} onclick={() => setSpread(false)}>
					<svg viewBox="0 0 20 16" aria-hidden="true"><rect x="6" y="1.5" width="8.5" height="13" rx="1" /></svg>
					<span class="lbl">{t('One page')}</span>
				</button>
				<button type="button" aria-pressed={spread} title={t('Two pages')} onclick={() => setSpread(true)}>
					<svg viewBox="0 0 20 16" aria-hidden="true"><rect x="1.5" y="1.5" width="8.25" height="13" rx="1" /><rect x="10.25" y="1.5" width="8.25" height="13" rx="1" /></svg>
					<span class="lbl">{t('Two pages')}</span>
				</button>
			</div>
			<div class="seg zoom" role="group" aria-label="Zoom">
				<button type="button" aria-label={t('Zoom out')} title={t('Zoom out')} disabled={scale <= STEPS[0] + 0.005} onclick={() => zoom(-1)}>−</button>
				<output class="pct" aria-live="polite">{Math.round(scale * 100)}%</output>
				<button type="button" aria-label={t('Zoom in')} title={t('Zoom in')} disabled={scale >= STEPS[STEPS.length - 1] - 0.005} onclick={() => zoom(1)}>+</button>
				<button type="button" class="fit" aria-pressed={fit === 'width'} title={t('Fit width')} onclick={() => fitTo('width')}>
					<svg viewBox="0 0 20 16" aria-hidden="true"><path d="M1.5 8h17M4.5 5l-3 3 3 3M15.5 5l3 3-3 3" /></svg>
					<span class="lbl">{t('Fit width')}</span>
				</button>
				<button type="button" class="fit" aria-pressed={fit === 'page'} title={t('Fit page')} onclick={() => fitTo('page')}>
					<svg viewBox="0 0 20 16" aria-hidden="true"><path d="M10 1v14M7 4l3-3 3 3M7 12l3 3 3-3" /></svg>
					<span class="lbl">{t('Fit page')}</span>
				</button>
			</div>
			<span class="grow"></span>
			<!-- The page is the book, laid out on A4 for print: the browser prints it as it is. -->
			<button type="button" class="btn print" title={t('Print')} onclick={() => window.print()}>
				<Icon name="printer" size="1em" /> <span class="lbl">{t('Print')}</span>
			</button>
			<!-- Turkish: the Turkish edition's PDF once it is printed; until then printing the page is the way. -->
			{#if !lang.limited || (entry && hasLocalPdf(entry, lang.current))}
				<a class="btn" title={t('Download the PDF')} href={entry ? bookPdf(entry, lang.current) : `/books/v2/${data.book.courseId}_${data.book.level.toLowerCase().replace('.', '_')}.pdf`} download>
					<Icon name="download" size="1em" /> <span class="lbl">{t('Download the PDF')}</span>
				</a>
			{/if}
		</div>
	{/if}
	<!-- svelte-ignore a11y_no_static_element_interactions -- mouse-only panning; keyboard and touch scroll natively -->
	<div
		class="viewer"
		class:pannable
		class:dragging
		bind:this={viewer}
		bind:clientWidth={viewerWidth}
		onpointerdown={panStart}
		onpointermove={panMove}
		onpointerup={panEnd}
		onpointercancel={panEnd}
		ondragstart={(e) => pannable && e.preventDefault()}
	>
		<Book2 {book} credits={data.credits} qr={data.qr} pages={data.pages} extras={data.extras} siteQr={data.siteQr} {cover} spineMm={spine} {hd} spread={!cover && spread} scale={cover ? 1 : scale} />
	</div>
</main>

<style>
	/* The bar below stays pinned; the nav scrolls away with the page rather
	   than stacking two sticky bars. */
	.chrome :global(.mini) {
		position: static;
		transform: none;
	}

	.title-row {
		display: flex;
		flex-wrap: wrap;
		gap: 0 1rem;
		align-items: center;
		padding: 0.3rem 1rem;
	}
	.book-title { font-size: 0.92rem; }

	.back-link {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
		min-height: 44px;
		color: var(--accent-ink);
		font-weight: 700;
		text-decoration: none;
	}

	/* One row on a phone too: the view, the zoom, then print and download as icons. */
	.dl-bar {
		position: sticky;
		top: 0;
		z-index: 2;
		display: flex;
		gap: 0.5rem;
		align-items: center;
		padding: 0.45rem 1rem;
		background: var(--surface, #fff);
		border-bottom: 1px solid var(--line, #ddd);
	}
	.grow { flex: 1; }
	.dl-bar .btn { min-height: 40px; padding-block: 0.35rem; padding-inline: 0.8rem; gap: 0.4rem; white-space: nowrap; }

	.seg {
		display: inline-flex;
		align-items: center;
		border: 1px solid var(--line-strong, #bbb);
		border-radius: 999px;
		overflow: hidden;
		background: var(--surface, #fff);
	}
	.seg button {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		gap: 0.35rem;
		min-width: 40px;
		min-height: 40px;
		padding: 0 0.7rem;
		border: 0;
		background: none;
		color: var(--ink);
		font: inherit;
		font-weight: 700;
		cursor: pointer;
	}
	.seg button + button { border-inline-start: 1px solid var(--line, #ddd); }
	.seg button[aria-pressed='true'] { background: var(--accent-ink); color: #fff; }
	.seg button:disabled { opacity: 0.4; cursor: default; }
	.seg svg { width: 1.25em; height: 1em; fill: none; stroke: currentColor; stroke-width: 1.5; }
	.zoom button:not(.fit) { padding: 0; font-size: 1.2rem; }
	.zoom .fit + .fit { border-inline-start: 1px solid var(--line, #ddd); }
	.pct { min-width: 3.2em; text-align: center; font-size: 0.85rem; font-weight: 700; font-variant-numeric: tabular-nums; }

	/* The book scrolls sideways on its own when zoomed past the screen. */
	/* overflow-anchor: the browser's own scroll anchoring would move the page
	   while keepPlace puts the reader's spot back; one hand on the scroll. */
	.viewer { overflow-x: auto; overflow-anchor: none; }
	/* The zoom animation scales the viewer past the screen for a moment: no scrollbar for it. */
	main { overflow-x: clip; }
	/* Zoomed past Fit: the hand, and a drag moves the book (not selects its text). */
	.viewer.pannable { cursor: grab; user-select: none; -webkit-user-select: none; }
	.viewer.dragging,
	.viewer.dragging :global(*) { cursor: grabbing; }

	@media (max-width: 760px) {
		.dl-bar .lbl { display: none; }
		.dl-bar { padding-inline: 0.5rem; gap: 0.35rem; }
		.dl-bar .btn { padding-inline: 0.6rem; }
		.seg button { padding: 0 0.55rem; }
	}

	.btn.print {
		border: 1px solid var(--line-strong);
		background: var(--surface);
		color: var(--ink);
		font: inherit;
		font-weight: 700;
		cursor: pointer;
	}

	@media print {
		.viewer { overflow: visible; }
		.chrome,
		.title-row,
		.dl-bar {
			display: none;
		}
	}
</style>
