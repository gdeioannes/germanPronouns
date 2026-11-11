// The tap-a-word dictionary, fetched once and shared by every view that shows
// German text.
//
// Same shape as nouns.svelte.ts and for the same reason: it is 237 KB, most of
// the app never needs it, and the first component that asks pulls it in. It is
// only ever asked for when the word-help setting is on, so a learner who turned
// the feature off never downloads it.

import { lookupWord, type DictionaryData, type WordInfo } from '$lib/domain/dictionary';
import { lang } from '$lib/i18n/lang.svelte';
import { loadGlossary } from '$lib/i18n/content.svelte';

class DictionaryStore {
	data = $state<DictionaryData | null>(null);
	/** Second-language glosses for the A1–A2 words, keyed "<de>|<pos>" (that language's mode only). */
	local = $state<Record<string, string> | null>(null);
	private pending: Promise<void> | null = null;
	private pendingLocal: Promise<void> | null = null;

	/** Loads the dictionary if it isn't loaded, and never more than once. */
	load(): Promise<void> {
		this.pending ??= (async () => {
			const module = await import('$content/shared/dictionary/de.json');
			this.data = module.default as DictionaryData;
		})();
		const l = lang.local;
		if (l)
			this.pendingLocal ??= loadGlossary(l).then((m) => {
				this.local = m;
			});
		return l ? Promise.all([this.pending, this.pendingLocal]).then(() => {}) : this.pending;
	}

	/** The word a surface form refers to, or null if the dictionary has none. */
	lookup(word: string): WordInfo | null {
		const info = lookupWord(word, this.data);
		if (!info || !lang.limited) return info;
		// A second language: its gloss, or none (the panel then shows the
		// German facts alone) rather than an English one.
		const gloss = this.local?.[`${info.entry.de}|${info.entry.pos}`] ?? '';
		return { ...info, entry: { ...info.entry, en: gloss } };
	}
}

export const dictionary = new DictionaryStore();
