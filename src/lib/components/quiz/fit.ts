// Sizing text pages to the screen they are read on.
//
// The page budget (see domain/paginate) is measured from the page itself: the
// width of the text column gives the characters per line, the room left in
// a section under the passage's header gives the lines. That first estimate
// is then checked against the real thing — while any text section still
// overflows its screen, the budget shrinks and the text is paged again.

import { tick } from 'svelte';

export interface PageFit {
	/** Characters (line-weighted) per page. */
	budget: number;
	/** Characters per displayed line. */
	lineWidth: number;
}

/**
 * Fits the text in `root`'s sections (those holding `selector`) to the
 * screen. `set` applies a fit — the component re-pages from it — and the
 * sections are measured again after each re-render. Hidden sections keep
 * their layout, so all of them are measured, not just the one on screen.
 */
export async function fitPages(
	root: HTMLElement,
	selector: string,
	set: (fit: PageFit) => void
): Promise<void> {
	await tick();
	const text = root.querySelector<HTMLElement>(selector);
	const step = text?.closest<HTMLElement>('[data-step]');
	if (!text || !step || step.clientHeight === 0) return;

	const style = getComputedStyle(text);
	const fontSize = parseFloat(style.fontSize) || 16;
	const lineHeight = parseFloat(style.lineHeight) || fontSize * 1.6;
	// A serif's average character is about half its size.
	const lineWidth = Math.max(16, Math.floor(text.clientWidth / (fontSize * 0.5)));
	// Room under the passage header, less the "continues" line at the foot.
	// Measured with bounding rects, not offsetTop: a hidden section carries a
	// transform, which makes it the offsetParent of its text and would put
	// the two offsets in different coordinate spaces.
	const above = Math.max(0, text.getBoundingClientRect().top - step.getBoundingClientRect().top);
	const lines = Math.max(4, Math.floor((step.clientHeight - above - 48) / lineHeight));

	let budget = lines * lineWidth;
	set({ budget, lineWidth });
	for (let round = 0; round < 12; round++) {
		await tick();
		const overflowing = [...root.querySelectorAll<HTMLElement>('[data-step]')].some(
			(section) => section.querySelector(selector) && section.scrollHeight > section.clientHeight + 2
		);
		if (!overflowing || budget <= lineWidth * 4) return;
		budget = Math.round(budget * 0.9);
		set({ budget, lineWidth });
	}
}

/** A text field has focus — on a phone, the on-screen keyboard is up. */
function typing(): boolean {
	const el = document.activeElement as HTMLElement | null;
	return !!el && (el.isContentEditable || ['INPUT', 'TEXTAREA', 'SELECT'].includes(el.tagName));
}

/**
 * Runs `fit` now, once the web fonts have loaded (they change how much text
 * a line holds), and again after the window settles from a resize.
 *
 * Not while typing: on many phones the keyboard shrinks the window, and
 * re-paging then would pull the gap being typed in out from under the
 * finger — onto another page, or out of the DOM, which drops the keyboard,
 * grows the window back and pages again. A resize skipped that way is caught
 * up once the field lets go of focus.
 */
export function fitOnResize(fit: () => void): () => void {
	let timer: ReturnType<typeof setTimeout> | undefined;
	let live = true;
	let skipped = false;
	const run = () => {
		if (typing()) skipped = true;
		else fit();
	};
	const onResize = () => {
		clearTimeout(timer);
		timer = setTimeout(run, 250);
	};
	const onFocusOut = () => {
		if (!skipped) return;
		// Focus may just be moving to the next gap; look once it has landed.
		clearTimeout(timer);
		timer = setTimeout(() => {
			if (typing()) return;
			skipped = false;
			fit();
		}, 250);
	};
	fit();
	document.fonts?.ready.then(() => live && run());
	window.addEventListener('resize', onResize);
	document.addEventListener('focusout', onFocusOut);
	return () => {
		live = false;
		clearTimeout(timer);
		window.removeEventListener('resize', onResize);
		document.removeEventListener('focusout', onFocusOut);
	};
}
