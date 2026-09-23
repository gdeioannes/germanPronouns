// The shared noun collection, fetched once and shared by everything that
// glosses a German word.
//
// It is 759 entries, and most of the app never needs it, so it is not imported
// statically: the first component that asks pulls it in, and everything after
// that reads the same list. Asking twice does not fetch twice.

import { lookupNoun, type NounInfo, type SharedNoun } from '$lib/domain/vocab';

class NounStore {
	list = $state<SharedNoun[]>([]);
	private pending: Promise<void> | null = null;

	/** Loads the collection if it isn't loaded, and never more than once. */
	load(): Promise<void> {
		this.pending ??= (async () => {
			const module = await import('$content/shared/nouns/de.json');
			this.list = module.default.nouns as SharedNoun[];
		})();
		return this.pending;
	}

	/** The noun a word refers to, through its inflected form if need be. */
	lookup(word: string): NounInfo | null {
		return lookupNoun(word, this.byNoun);
	}

	// Rebuilt only when the list changes — which is once, on load.
	private byNoun = $derived(new Map(this.list.map((noun) => [noun.noun, noun])));
}

export const nouns = new NounStore();
