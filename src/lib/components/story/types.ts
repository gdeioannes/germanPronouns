// Shapes of a story episode (assets/content/stories/*.json), as the player
// reads them. The schema is docs/story_module_schema.md; beats stay loose
// records because each kind carries its own fields.

export type Opt = { text: string; correct: boolean; reply?: string };
export type Beat = Record<string, unknown> & { id: string; type: string };

export interface Chapter {
	id: string;
	title: string;
	clue?: string;
	studyLinks?: string[];
	/** Hub tile: a short English line under the German title. */
	subtitle?: string;
	/** Hub tile once done: what the clue was ("Street: {pool:street}"). */
	clueText?: string;
	/** Hub lead: clues needed before it opens, and the tile text meanwhile. */
	requires?: string[];
	lockedText?: string;
	beats: Beat[];
}

export interface MicroCheck {
	after: string;
	kind: string;
	text: string;
	question: string;
	options: Opt[];
}

export interface Episode {
	id: string;
	course: string;
	level: string;
	/** Which half of the level's topics (0 = the prologue, before any). */
	half: number;
	/** The word list (authoring metadata, checked by npm run story-review). */
	teaches?: string[];
	title: string;
	tagline: string;
	minutesFloor: number;
	credibility: number;
	pools: Record<string, string[]>;
	chapters: Chapter[];
	hub: {
		afterChapter: string;
		leads: string[];
		requiredClues: string[];
		unlocks: string;
		/** Hub screen heading. */
		title?: string;
		/** Under the leads while clues are missing. */
		lockedHint?: string;
		/** The button that opens the finale. */
		finaleLabel?: string;
		/** Maya's line when the last clue lands. */
		allCluesLine?: string;
	};
	microChecks: MicroCheck[];
	/** Who the between-chapter check is from (default: Maya texting). */
	microFrom?: string;
	/** Title-screen scene. */
	cover?: string;
	ending?: { image: string; title: string; text: string; line: string; next?: { href: string; label: string } };
}

/** What a beat component gets from the player: the shared juice and flow. */
export interface BeatHost {
	resolve: (text: string) => string;
	/** story/x_{pool:y} → playable file for the current draw. */
	clip: (key: string) => string;
	play: (src: string, rate?: number) => void;
	sfx: (name: string, gain?: number) => void;
	right: (anchor: Element | null) => void;
	wrong: (anchor: Element | null, critical: boolean) => void;
	done: () => void;
	/** The drawn variant index of a pool. */
	drawOf: (pool: string) => number;
	/** Drop words into Maya's notebook (a hotspot's find, a map's place). */
	note: (entries: { de: string; en: string }[]) => void;
}
