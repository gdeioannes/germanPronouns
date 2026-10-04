/**
 * Screen-reader plumbing shared across the app.
 *
 * `announce` speaks a short message through the one polite live region the
 * root layout mounts (Announcer.svelte). A region that already exists in the
 * DOM is the only kind screen readers reliably notice: a verdict paragraph
 * rendered by `{#if}` arrives together with its text and is often missed.
 */
/** A stretch of an announcement, read in the voice for `lang` when given. */
export interface Spoken {
	text: string;
	lang?: string;
}

export const live = $state<{ parts: Spoken[]; serial: number }>({ parts: [], serial: 0 });

/**
 * `foreign` is read after `message` in the voice for `lang` — a corrected
 * German sentence read by an English voice is no help to a learner. For any
 * other mix of languages, pass the parts in order instead.
 */
export function announce(message: string | Spoken[], foreign = '', lang = 'de-DE'): void {
	const parts: Spoken[] =
		typeof message === 'string'
			? [{ text: message }, ...(foreign ? [{ text: foreign, lang }] : [])]
			: message;
	// Clearing first lets the same words ("Correct.") be announced twice in a row.
	live.parts = [];
	live.serial++;
	const serial = live.serial;
	setTimeout(() => {
		if (live.serial === serial) live.parts = parts;
	}, 60);
}

/**
 * Makes everything outside `el` inert — the page behind a modal panel can
 * neither take focus nor be reached by a screen reader's reading cursor —
 * and returns the undo. Only elements this call made inert are restored.
 */
export function inertOutside(el: HTMLElement): () => void {
	const touched: HTMLElement[] = [];
	let node: HTMLElement | null = el;
	while (node && node !== document.body) {
		const parent: HTMLElement | null = node.parentElement;
		for (const sibling of Array.from(parent?.children ?? [])) {
			if (sibling === node || !(sibling instanceof HTMLElement)) continue;
			if (sibling.inert || sibling.hasAttribute('aria-live') || sibling.tagName === 'SCRIPT') continue;
			sibling.inert = true;
			touched.push(sibling);
		}
		node = parent;
	}
	return () => touched.forEach((t) => (t.inert = false));
}

/**
 * Arrow keys for a `role="radiogroup"` built from buttons, as a native radio
 * group behaves: arrows move to the neighbouring option and select it. Pair
 * it with `tabindex={checked ? 0 : -1}` on each option, so the group is one
 * Tab stop.
 */
export function radioKeys(group: HTMLElement) {
	function onKey(event: KeyboardEvent) {
		const step = { ArrowRight: 1, ArrowDown: 1, ArrowLeft: -1, ArrowUp: -1 }[event.key];
		if (!step) return;
		const radios = Array.from(group.querySelectorAll<HTMLElement>('[role="radio"]')).filter(
			(r) => !(r as HTMLButtonElement).disabled
		);
		const at = radios.indexOf(document.activeElement as HTMLElement);
		if (at === -1 || radios.length === 0) return;
		event.preventDefault();
		event.stopPropagation();
		const to = radios[(at + step + radios.length) % radios.length];
		to.focus();
		to.click();
	}
	group.addEventListener('keydown', onKey);
	return { destroy: () => group.removeEventListener('keydown', onKey) };
}
