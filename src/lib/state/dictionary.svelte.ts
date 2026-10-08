// The tap-a-word dictionary, fetched once and shared by every view that shows
// German text.
//
// Same shape as nouns.svelte.ts and for the same reason: it is 237 KB, most of
// the app never needs it, and the first component that asks pulls it in. It is
// only ever asked for when the word-help setting is on, so a learner who turned
// the feature off never downloads it.

import { lookupWord, type DictionaryData, type WordInfo } from '$lib/domain/dictionary';

class DictionaryStore {
	data = $state<DictionaryData | null>(null);
	private pending: Promise<void> | null = null;

	/** Loads the dictionary if it isn't loaded, and never more than once. */
	load(): Promise<void> {
		this.pending ??= (async () => {
			const module = await import('$content/shared/dictionary/de.json');
			this.data = module.default as DictionaryData;
		})();
		return this.pending;
	}

	/** The word a surface form refers to, or null if the dictionary has none. */
	lookup(word: string): WordInfo | null {
		return lookupWord(word, this.data);
	}
}

export const dictionary = new DictionaryStore();
