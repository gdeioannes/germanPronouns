<script lang="ts">
	import { feedback } from '$lib/state/feedback.svelte';
	import { track, trackBookDownload } from '$lib/services/analytics';
	import Seo from '$lib/components/Seo.svelte';
	import Book2 from '$lib/components/book2/Book2.svelte';
	import Icon from '$lib/icons/Icon.svelte';
	import SiteNav from '$lib/components/SiteNav.svelte';
	import { openShare } from '$lib/state/sharePanel.svelte';
	import { returnTo, returnLabel } from '$lib/state/returnTo.svelte';
	import { page } from '$app/state';
	import { browser, dev } from '$app/environment';
	import type { PageData } from './$types';
	import { t } from '$lib/i18n/t';
	import { lang } from '$lib/i18n/lang.svelte';
	import { inLangBookFront, inLangChapter } from '$lib/i18n/content.svelte';
	import { BOOKS, bookPdf, pdfOffered } from '$lib/content/books';

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
	const pdfHref = $derived(
		entry ? bookPdf(entry, lang.current) : `/books/v2/${data.book.courseId}_${data.book.level.toLowerCase().replace('.', '_')}.pdf`
	);
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
	/** Opened from an exercise (its Book chip): the way back is that exercise. */
	let fromQuiz = $state<string | null>(null);
	/** The chapter page to open at ("hallo/grammatik-1"), from the same link. */
	let openAt: string | null = null;
	/** Which entry of that page's exercise list sent the reader here: it names the block on the page. */
	let openN = -1;
	/** Still settling on the page asked for: the zoom is fitted after the first layout, which moves every page. */
	let landing = $state(false);
	const courseHref = $derived(page.data.site?.courseHref ?? '/');
	const back = $derived(
		fromQuiz
			? { href: `/course/${data.book.courseId}/quiz/${fromQuiz}`, label: t('Back to the exercise') }
			: fromBooks
				? { href: '/books', label: t('The books') }
				: { href: returnTo.path, label: returnLabel(returnTo.path) }
	);
	onMount(() => {
		const q = new URLSearchParams(window.location.search);
		fromBooks = q.get('from') === 'books';
		const quizId = q.get('quiz');
		fromQuiz = quizId && /^[\w-]+$/.test(quizId) ? quizId : null;
		openAt = q.get('at');
		openN = Number(q.get('n') ?? -1);
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
		if (openAt) {
			landing = true;
			// The reader's own first scroll, tap or key ends it: from then on the place is theirs.
			// Anything that changes the page's height while it settles (the release
			// banner arriving above the book, a late font) moves the pages: land again.
			const shifts = new ResizeObserver(() => landing && requestAnimationFrame(land));
			shifts.observe(document.body);
			let timer: ReturnType<typeof setTimeout> | undefined;
			const mine = () => {
				landing = false;
				shifts.disconnect();
				clearTimeout(timer);
				document.removeEventListener('visibilitychange', seen);
				window.removeEventListener('load', seen);
			};
			// A tab opened in the background draws nothing, so nothing can be placed:
			// the settling time starts when the book is first looked at, and again
			// once everything has loaded.
			const seen = () => {
				if (document.hidden || !landing) return;
				clearTimeout(timer);
				requestAnimationFrame(land);
				timer = setTimeout(mine, 3000);
			};
			document.addEventListener('visibilitychange', seen);
			if (document.readyState !== 'complete') window.addEventListener('load', seen, { once: true });
			seen();
			for (const type of ['wheel', 'touchstart', 'keydown', 'pointerdown']) window.addEventListener(type, mine, { once: true, passive: true });
		}
	});

	// Opened from an exercise: straight to the page it belongs to, and on that
	// page to the block it practises (the entry's "for": "Who is who"), which
	// is marked for a moment. Repeated while the zoom settles, so the place holds.
	let marked: HTMLElement | null = null;
	function land() {
		if (!openAt || !viewer) return;
		const pages = bookPages();
		const i = pages.findIndex((p) => p.dataset.at === openAt);
		if (i < 0) return;
		const pageEl = pages[i];
		const under = (bar?.getBoundingClientRect().bottom ?? 0) + 12;
		jumpBy(pageEl.getBoundingClientRect().top - under);
		const [chapterId, part] = openAt.split('/');
		const block = blockFor(pageEl, chapterId, part, openN);
		if (block) {
			const r = block.getBoundingClientRect();
			// Already whole on the screen (a big screen showing the full page): leave the page where it is.
			if (r.top < under || r.bottom > window.innerHeight - 8) jumpBy(r.top - under - 8);
			if (marked !== block) {
				marked = block;
				if (!window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
					block.animate(
						[
							{ boxShadow: '0 0 0 0 rgb(201 104 59 / 0)', backgroundColor: 'rgb(201 104 59 / 0)' },
							{ boxShadow: '0 0 0 6px rgb(201 104 59 / 0.55)', backgroundColor: 'rgb(201 104 59 / 0.12)', offset: 0.25 },
							{ boxShadow: '0 0 0 6px rgb(201 104 59 / 0.55)', backgroundColor: 'rgb(201 104 59 / 0.12)', offset: 0.7 },
							{ boxShadow: '0 0 0 0 rgb(201 104 59 / 0)', backgroundColor: 'rgb(201 104 59 / 0)' }
						],
						{ duration: 2600, easing: 'ease-in-out' }
					);
				}
			}
		}
		readPage();
	}
	/**
	 * The block an exercise link names, in whatever language the book is shown.
	 * The link's label is matched on the page as it stands; in a translated
	 * edition the heading it names may read differently, so the label is then
	 * looked up in the book as written (data.book) and the string at the same
	 * place in the translated book is the heading to find.
	 */
	function blockFor(pageEl: HTMLElement, chapterId: string, part: string, n: number): HTMLElement | null {
		const shown = book.chapters.find((c) => c.id === chapterId);
		const written = data.book.chapters.find((c) => c.id === chapterId);
		const label = shown?.appQuizzes?.[part]?.[n]?.for;
		const direct = label ? blockNamed(pageEl, label) : null;
		if (direct || !shown || !written) return direct;
		const source = written.appQuizzes?.[part]?.[n]?.for;
		if (!source) return null;
		const clean = (s: string) => s.replace(/\s+/g, ' ').trim().toLowerCase();
		const wanted = [source, ...source.split(' · ').reverse()].map(clean).filter((w) => w.length >= 3);
		// Only this page's own part of the chapter: the same words can head a block on another page.
		const i = Number(part.slice(-1)) - 1;
		const key = part === 'lesen' ? 'reading' : part.startsWith('grammatik') ? 'grammar' : part === 'alltag' ? 'document' : part.startsWith('uebungen') ? 'practise' : null;
		if (!key) return null;
		const pick = (c: unknown) => { const v = (c as Record<string, unknown>)[key]; return Array.isArray(v) && (key === 'grammar' || key === 'practise') ? v[i] : v; };
		const path = pathOf(pick(written), wanted);
		if (!path) return null;
		let at: unknown = pick(shown);
		for (const k of path) at = (at as Record<string, unknown> | undefined)?.[k];
		return typeof at === 'string' && at ? blockNamed(pageEl, at) : null;
	}
	/** Where in a piece of the book a string equal to one of `wanted` sits (the first, by the order given). */
	function pathOf(root: unknown, wanted: string[]): (string | number)[] | null {
		const clean = (s: string) => s.replace(/\s+/g, ' ').trim().toLowerCase();
		for (const w of wanted) {
			const walk = (o: unknown, path: (string | number)[]): (string | number)[] | null => {
				if (typeof o === 'string') return clean(o) === w ? path : null;
				if (Array.isArray(o)) { for (let k = 0; k < o.length; k++) { const hit = walk(o[k], [...path, k]); if (hit) return hit; } return null; }
				if (o && typeof o === 'object') { for (const [k, v] of Object.entries(o)) { const hit = walk(v, [...path, k]); if (hit) return hit; } }
				return null;
			};
			const hit = walk(root, []);
			if (hit) return hit;
		}
		return null;
	}
	/** The block of a page whose heading is the label ("Übung 1 · du or Sie?" also by either half). */
	function blockNamed(pageEl: HTMLElement, label: string): HTMLElement | null {
		// "Übung 5 · …": the exercise with that number on the page, whatever its title reads in this edition.
		const number = /^Übung (\d+)/.exec(label)?.[1];
		if (number) {
			const ex = [...pageEl.querySelectorAll<HTMLElement>('section.ex')].find((s) => s.querySelector('header .n')?.textContent?.trim() === number);
			if (ex) return ex;
		}
		const clean = (s: string) => s.replace(/\s+/g, ' ').trim().toLowerCase();
		const wanted = [label, ...label.split(' · ').reverse()].map(clean).filter(Boolean);
		const heads = [...pageEl.querySelectorAll<HTMLElement>('h2, h3, h4, h5, caption, figcaption, .head, .title, .label, strong, b')];
		// The heading's own box is a line; its parent is the block it heads.
		const blockOf = (h: HTMLElement) => (h.parentElement && h.parentElement !== pageEl ? h.parentElement : h);
		for (const w of wanted) {
			const hit = heads.find((h) => clean(h.textContent ?? '') === w) ?? heads.find((h) => clean(h.textContent ?? '').startsWith(w));
			if (hit) return blockOf(hit);
		}
		// A heading that only ends with it ("Ein Klingelschild in Berlin: Wer wohnt hier?"), then any
		// single line of the page that is exactly it (a table row's question, a caption).
		for (const w of wanted.filter((x) => x.length >= 6)) {
			const hit = heads.find((h) => clean(h.textContent ?? '').includes(w));
			if (hit) return blockOf(hit);
		}
		const lines = [...pageEl.querySelectorAll<HTMLElement>('td, th, p, li, dt, span')].filter((e) => !e.childElementCount || e.children.length <= 2);
		for (const w of wanted.filter((x) => x.length >= 6)) {
			const hit = lines.find((e) => clean(e.textContent ?? '') === w);
			if (hit) return hit.closest<HTMLElement>('table, ul, ol, dl') ?? blockOf(hit);
		}
		return null;
	}
	// The dev server lets a coverage script use the same matcher (never in a build).
	if (dev && browser) {
		const w = window as unknown as Record<string, unknown>;
		w.__blockNamed = blockNamed;
		/** One exercise link, as the reader would resolve it in the language shown now. */
		w.__bookLink = (at: string, n: number) => {
			const pageEl = bookPages().find((p) => p.dataset.at === at);
			const [chapterId, part] = at.split('/');
			const label = book.chapters.find((c) => c.id === chapterId)?.appQuizzes?.[part]?.[n]?.for ?? '';
			const el = pageEl ? blockFor(pageEl, chapterId, part, n) : null;
			return { page: !!pageEl, label, found: !!el, el };
		};
	}
	$effect(() => {
		void scale; void spread; void viewerWidth;
		if (!landing || !ready) return;
		const frame = requestAnimationFrame(land);
		return () => cancelAnimationFrame(frame);
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

	// The page box: which page the reader is on (the page at a third of the
	// screen under the bar; in two-page view the left one of the pair), and a
	// field to type another page into, with a step back and forward.
	let pageNow = $state(1);
	let pageCount = $state(0);
	let pageDraft = $state('1');
	let pageEditing = $state(false);
	const bookPages = () => (viewer ? [...viewer.querySelectorAll<HTMLElement>('.book2 > .page')] : []);
	function readPage() {
		const pages = bookPages();
		pageCount = pages.length;
		if (!pages.length) return;
		const top = bar?.getBoundingClientRect().bottom ?? 0;
		const y = top + (window.innerHeight - top) / 3;
		let best = Infinity;
		let left = Infinity;
		let at = 0;
		for (let i = 0; i < pages.length; i++) {
			const r = pages[i].getBoundingClientRect();
			if (r.top - y > best + 1) break; // the pages run top to bottom: the rest are further away
			const d = Math.max(r.top - y, 0, y - r.bottom);
			if (d < best - 0.5 || (Math.abs(d - best) <= 0.5 && r.left < left)) { best = d; left = r.left; at = i; }
		}
		pageNow = at + 1;
		if (!pageEditing) pageDraft = String(pageNow);
	}
	let pageFrame = 0;
	function queuePage() {
		if (cover || pageFrame) return;
		pageFrame = requestAnimationFrame(() => { pageFrame = 0; readPage(); });
	}
	// A new zoom or view moves the pages: read again once laid out, and after the zoom has played.
	$effect(() => {
		void scale; void spread; void ready; void book;
		queuePage();
		const late = setTimeout(queuePage, 400);
		return () => clearTimeout(late);
	});
	/** Brings page n to the top of the screen, under the bar. */
	function goToPage(n: number) {
		const pages = bookPages();
		if (!pages.length || !Number.isFinite(n) || !viewer) return;
		const to = Math.min(pages.length, Math.max(1, Math.round(n)));
		const el = pages[to - 1];
		viewer.getAnimations().forEach((a) => a.finish());
		jumpBy(el.getBoundingClientRect().top - (bar?.getBoundingClientRect().bottom ?? 0) - 12);
		// Zoomed in past the screen's width: the page's left edge into view.
		const r = el.getBoundingClientRect();
		const v = viewer.getBoundingClientRect();
		if (r.left < v.left || r.right > v.left + viewer.clientWidth) viewer.scrollLeft += r.left - v.left - 16;
		pageNow = to;
		pageDraft = String(to);
		if (!window.matchMedia('(prefers-reduced-motion: reduce)').matches) viewer.animate([{ opacity: 0.4 }, { opacity: 1 }], { duration: 200, easing: 'ease-out' });
	}
	/** One page on, or back; in two-page view one pair (the cover stands alone). */
	function stepPage(dir: 1 | -1) {
		const n = pageNow;
		if (!spread) return goToPage(n + dir);
		const even = n - (n % 2);
		goToPage(dir > 0 ? (n < 2 ? 2 : even + 2) : n <= 3 ? 1 : even - 2);
	}
	function submitPage() {
		const n = parseInt(pageDraft, 10);
		if (Number.isFinite(n)) goToPage(n);
		else pageDraft = String(pageNow);
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

<svelte:window bind:innerHeight onscroll={queuePage} onresize={queuePage} />

<svelte:head>
	{@html cover ? `<style>@page { size: ${420 + spine + 6.35}mm 303.35mm; margin: 0; }</style>` : '<style>@page { size: A4; margin: 0; }</style>'}
	<!-- The fit scales follow the book's width. A scrollbar that comes and goes
	     with the zoom would change that width, and the scale, and the height,
	     and the scrollbar again: its gutter stays reserved on this page. -->
	<style>html { scrollbar-gutter: stable; }</style>
</svelte:head>

{#if !cover}
	<div class="chrome"><SiteNav {courseHref} compact level={data.book.level} /></div>
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
			{#if pageCount}
				<form class="seg pager" role="group" aria-label={t('Page')} onsubmit={(e) => { e.preventDefault(); submitPage(); }}>
					<button type="button" aria-label={t('Previous page')} title={t('Previous page')} disabled={pageNow <= 1} onclick={() => stepPage(-1)}>
						<svg viewBox="0 0 20 16" aria-hidden="true"><path d="M12.5 3l-5 5 5 5" /></svg>
					</button>
					<label class="pg-box">
						<span class="sr-only">{t('Page')}</span>
						<input
							type="text"
							inputmode="numeric"
							enterkeyhint="go"
							autocomplete="off"
							size="3"
							bind:value={pageDraft}
							onfocus={(e) => { pageEditing = true; e.currentTarget.select(); }}
							onblur={() => { pageEditing = false; pageDraft = String(pageNow); }}
							onkeydown={(e) => { if (e.key === 'Escape') { pageDraft = String(pageNow); e.currentTarget.blur(); } }}
						/>
						<span class="of">/ {pageCount}</span>
					</label>
					<button type="button" aria-label={t('Next page')} title={t('Next page')} disabled={pageNow >= pageCount} onclick={() => stepPage(1)}>
						<svg viewBox="0 0 20 16" aria-hidden="true"><path d="M7.5 3l5 5-5 5" /></svg>
					</button>
				</form>
			{/if}
			<span class="grow"></span>
			<!-- A book is the thing a reader knows someone else needs. -->
			<button
				type="button"
				class="btn share"
				title={t('Share')}
				onclick={() =>
					openShare({
						where: 'reader',
						text: t('I thought of you: a free German book with audio, level {level}. No sign-up, nothing to pay.', { level: data.book.level }),
						props: { book: data.book.level }
					})}
			>
				<Icon name="share" size="1em" /> <span class="lbl">{t('Share')}</span>
			</button>
			<!-- The page is the book, laid out on A4 for print: the browser prints it as it is. -->
			<button type="button" class="btn print" title={t('Print')} onclick={() => window.print()}>
				<Icon name="printer" size="1em" /> <span class="lbl">{t('Print')}</span>
			</button>
			<!-- Turkish: the Turkish edition's PDF once it is printed; until then printing the page is the way. -->
			{#if !entry || pdfOffered(entry, lang.current)}
				<a
					class="btn"
					title={t('Download the PDF')}
					href={pdfHref}
					download
					onclick={(e) => {
						trackBookDownload(data.book.level, 'reader');
						feedback.beforeDownload(e, { href: pdfHref, book: data.book.level });
					}}
				>
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
		onscroll={queuePage}
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
	/* Nothing in the bar ever squeezes (text broke over two lines, cut off): too
	   little room and the bar takes a second row instead. */
	.dl-bar { flex-wrap: wrap; row-gap: 0.35rem; }
	.dl-bar > * { flex-shrink: 0; }
	.dl-bar .grow { flex-shrink: 1; }
	.seg button { white-space: nowrap; }
	/* A medium screen: the view and fit buttons as icons (their names stay in the tooltip). */
	@media (max-width: 1240px) {
		.seg .lbl { display: none; }
	}
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
	.pager button { padding: 0; }
	/* The paper runs left to right in every language (the Arabic books too): back on the left, on to the right. */
	.pager { direction: ltr; }
	.pg-box { display: inline-flex; align-items: center; gap: 0.3rem; padding: 0 0.5rem; border-inline: 1px solid var(--line, #ddd); min-height: 40px; font-size: 0.85rem; font-weight: 700; font-variant-numeric: tabular-nums; }
	.pg-box input {
		width: 3.2em;
		padding: 0.2rem 0.3rem;
		border: 1px solid var(--line-strong, #bbb);
		border-radius: 6px;
		background: var(--surface, #fff);
		color: var(--ink);
		font: inherit;
		text-align: center;
	}
	.pg-box .of { color: var(--muted, #666); white-space: nowrap; }
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
		.pager button { padding: 0; }
		.pg-box { padding: 0 0.35rem; }
	}

	/* A phone: the bar is one row of icons (view, zoom, print, download), and
	   the page box floats at the foot of the screen, under the thumb. */
	@media (max-width: 560px) {
		.dl-bar { gap: 0.3rem; padding-block: 0.35rem; }
		.seg button { min-width: 36px; min-height: 36px; padding: 0; }
		.pct { min-width: 2.7em; font-size: 0.8rem; }
		.dl-bar .btn { min-width: 36px; min-height: 36px; padding: 0; justify-content: center; }
		.pager {
			position: fixed;
			left: 50%;
			bottom: calc(12px + env(safe-area-inset-bottom, 0px));
			transform: translateX(-50%);
			z-index: 5;
			box-shadow: 0 4px 18px rgb(0 0 0 / 0.18);
		}
		.pager button { min-width: 44px; min-height: 44px; }
		.pg-box { min-height: 44px; font-size: 0.95rem; }
		/* 16 px: a smaller field makes iPhone zoom the whole page on focus. */
		.pg-box input { font-size: 16px; width: 2.8em; }
		/* The last page scrolls clear of the floating box. */
		main { padding-bottom: 76px; }
		.title-row { padding-block: 0; font-size: 0.9rem; }
		.back-link { min-height: 36px; }
	}
	/* A small phone: one row still, so Print goes (nobody prints from one; the PDF stays). */
	@media (max-width: 420px) {
		.dl-bar .btn.print { display: none; }
	}

	.btn.share {
		border: 1px solid var(--share-strong);
		background: var(--share);
		color: var(--share-ink);
		font: inherit;
		font-weight: 700;
		cursor: pointer;
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
