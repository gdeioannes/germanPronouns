// The tap-a-word dictionary, fetched once and shared by every view that shows
// German text.
//
// Same shape as nouns.svelte.ts and for the same reason: it is 237 KB, most of
// the app never needs it, and the first component that asks pulls it in. It is
// only ever asked for when the word-help setting is on, so a learner who turned
// the feature off never downloads it.

import { lookupWord, type DictionaryData, type WordInfo } from '$lib/domain/dictionary';
import { lang } from '$lib/i18n/lang.svelte';

class DictionaryStore {
	data = $state<DictionaryData | null>(null);
	/** Turkish glosses for the A1–A2 words, keyed "<de>|<pos>" (Turkish mode only). */
	tr = $state<Record<string, string> | null>(null);
	private pending: Promise<void> | null = null;
	private pendingTr: Promise<void> | null = null;

	/** Loads the dictionary if it isn't loaded, and never more than once. */
	load(): Promise<void> {
		this.pending ??= (async () => {
			const module = await import('$content/shared/dictionary/de.json');
			this.data = module.default as DictionaryData;
		})();
		if (lang.tr)
			this.pendingTr ??= import('$content/tr/dictionary.de.json').then((m) => {
				this.tr = m.default as Record<string, string>;
			});
		return lang.tr ? Promise.all([this.pending, this.pendingTr]).then(() => {}) : this.pending;
	}

	/** The word a surface form refers to, or null if the dictionary has none. */
	lookup(word: string): WordInfo | null {
		const info = lookupWord(word, this.data);
		if (!info || !lang.tr) return info;
		// Turkish mode: the Turkish gloss, or none (the panel then shows the
		// German facts alone) rather than an English one.
		const gloss = this.tr?.[`${info.entry.de}|${info.entry.pos}`] ?? '';
		return { ...info, entry: { ...info.entry, en: gloss } };
	}
}

export const dictionary = new DictionaryStore();
