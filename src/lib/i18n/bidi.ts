// Right to left (Arabic): German text in an Arabic page must still run left to
// right, or its punctuation jumps to the wrong end ("?Wer ist das"). Text marked
// lang="de" is handled in CSS (arabic.css). Much German is not marked: book
// headings, exercise lines, options. So in a right-to-left page, every text
// element with letters but no Arabic letter at all is given dir="ltr". An
// Arabic sentence that merely starts with a German word keeps its direction:
// it has Arabic letters in it.
//
// Only attributes are set (never nodes added or moved), so Svelte's own
// updates are untouched; the observer re-checks whatever changes.

const ARABIC = /[؀-ۿݐ-ݿﭐ-﷿ﹰ-﻿]/;
const LETTER = /\p{L}/u;
const MARK = 'data-auto-ltr';

/** An element holding text of its own (a direct text node with a letter). */
function ownsText(el: Element): boolean {
	for (const n of el.childNodes) if (n.nodeType === 3 && LETTER.test(n.nodeValue ?? '')) return true;
	return false;
}

function check(el: Element) {
	if (el.closest('[lang="de"], svg, script, style, [contenteditable]')) return;
	// Flex and grid rows would reverse their children: leave their layout alone.
	const display = getComputedStyle(el).display;
	const flowing = !/flex|grid/.test(display);
	const text = el.textContent ?? '';
	const latinOnly = flowing && LETTER.test(text) && !ARABIC.test(text);
	if (latinOnly && !el.hasAttribute('dir')) {
		el.setAttribute('dir', 'ltr');
		el.setAttribute(MARK, '');
	} else if (!latinOnly && el.hasAttribute(MARK)) {
		el.removeAttribute('dir');
		el.removeAttribute(MARK);
	}
}

/**
 * Blocks that may hold German only through their children (a table cell of
 * links, a list item of tiles): checked as a whole too, so the commas and
 * question marks between those children fall into place.
 */
const HOLDERS = new Set(['TD', 'TH', 'LI', 'P', 'DD', 'DT', 'BLOCKQUOTE']);

function scan(root: Element) {
	const walker = document.createTreeWalker(root, NodeFilter.SHOW_ELEMENT);
	for (let n = walker.currentNode as Element | null; n; n = walker.nextNode() as Element | null)
		if (ownsText(n) || HOLDERS.has(n.tagName)) check(n);
}

/** Keeps German left to right inside `root` until the returned function is called. */
export function autoBidi(root: Element): () => void {
	let queued = false;
	const dirty = new Set<Element>();
	const flush = () => {
		queued = false;
		for (const el of dirty) if (el.isConnected) scan(el);
		dirty.clear();
	};
	const observer = new MutationObserver((records) => {
		for (const r of records) {
			const target = r.target.nodeType === 3 ? r.target.parentElement : (r.target as Element);
			if (target) dirty.add(target);
		}
		if (!queued) {
			queued = true;
			requestAnimationFrame(flush);
		}
	});
	scan(root);
	observer.observe(root, { childList: true, subtree: true, characterData: true });
	return () => {
		observer.disconnect();
		for (const el of root.querySelectorAll(`[${MARK}]`)) {
			el.removeAttribute('dir');
			el.removeAttribute(MARK);
		}
	};
}

// ── German runs inside Arabic sentences ──────────────────
// "أن أسأل بشكل غير مباشر (Können Sie mir sagen, ob …?)": without help the
// bidi algorithm scatters the German's comma, ellipsis and question mark
// around the Arabic. Each run of Latin text inside an Arabic string is wrapped
// in invisible isolate marks (FSI … PDI), so it lays out as one left-to-right
// piece. A run starts and ends on a letter (or ? ! …), so a full stop or
// comma closing the Arabic sentence stays Arabic. Strings with markup or a
// link are left alone, and so is anything without Arabic letters; {placeholders}
// are never touched.

const RUN = /[A-Za-zÀ-ÖØ-öø-ÿẞ](?:[A-Za-zÀ-ÖØ-öø-ÿẞ0-9 ,.'’\-/()…:;]*[A-Za-zÀ-ÖØ-öø-ÿẞ0-9?!…)])?[?!]?/g;
const FSI = '⁨';
const PDI = '⁩';

/** An Arabic string with each German (Latin) run isolated; other strings unchanged. */
export function isolateLatin(s: string): string {
	if (!ARABIC.test(s) || /[<>]|https?:/.test(s) || s.includes(FSI)) return s;
	// Placeholders ({subject}, {n}) are matched first and kept as they are.
	return s.replace(new RegExp(String.raw`\{\w+\}|` + RUN.source, 'g'), (run) => {
		if (run.startsWith('{')) return run;
		// Brackets belong to the run only when it opens them itself.
		const opens = (run.match(/\(/g) ?? []).length;
		const closes = (run.match(/\)/g) ?? []).length;
		if (closes > opens) {
			const cut = run.lastIndexOf(')');
			return `${FSI}${run.slice(0, cut).trimEnd()}${PDI}${run.slice(cut)}`;
		}
		return `${FSI}${run}${PDI}`;
	});
}

/** The direction marks isolateLatin adds (and LRM/RLM), as a pattern. */
const MARKS = new RegExp(`[${String.fromCharCode(0x2066)}-${String.fromCharCode(0x2069, 0x200e, 0x200f)}]`, 'g');

/** Text without its invisible direction marks: for a search result or a share card. */
export function stripBidi(s: string): string {
	return s.replace(MARKS, '');
}
