// The icon set, as raw path data on a 24×24 grid.
//
// Drawn to one spec so they read as a family: 1.75 stroke, round caps and
// joins, shapes kept inside a 20×20 optical area with 2px of air, and geometry
// snapped to whole or half units. They inherit `currentColor` and scale with
// the type, so an icon beside a label always matches its weight and colour.
//
// Replaces the emoji the first pass used — emoji render differently on every
// platform, can't take the brand colour, and never align to the text baseline.

export interface IconSpec {
	/** Stroked outlines — the default. */
	d: string;
	/** Extra paths that are filled rather than stroked (dots, solid arrows). */
	fill?: string;
	/** Some marks read better slightly off the shared stroke weight. */
	width?: number;
}

const RAW = {
	// -- audio ---------------------------------------------------------------
	/** Speaker with two waves: play this aloud. */
	volume: {
		d: 'M4 9.5h3l4-3.5v12l-4-3.5H4a1 1 0 0 1-1-1v-3a1 1 0 0 1 1-1Z M15 9.2a4 4 0 0 1 0 5.6 M18 6.6a8 8 0 0 1 0 10.8'
	},
	/** Speaker mid-playback, used as the "stop" state. */
	volumeOff: {
		d: 'M4 9.5h3l4-3.5v12l-4-3.5H4a1 1 0 0 1-1-1v-3a1 1 0 0 1 1-1Z M15.5 10.5l5 5 M20.5 10.5l-5 5'
	},
	play: { d: 'M7 5.5l11 6.5-11 6.5V5.5Z' },
	stop: { d: 'M6.5 6.5h11v11h-11z' },
	/** A slower playback rate: the play mark with a trailing wave. */
	slow: {
		d: 'M5 5.5l9 6.5-9 6.5V5.5Z M18 8.5a5.5 5.5 0 0 1 0 7'
	},
	mic: {
		d: 'M12 3.5a2.5 2.5 0 0 1 2.5 2.5v6a2.5 2.5 0 0 1-5 0V6A2.5 2.5 0 0 1 12 3.5Z M5.5 11.5a6.5 6.5 0 0 0 13 0 M12 18v2.5 M8.5 20.5h7'
	},

	// -- verdicts ------------------------------------------------------------
	check: { d: 'M4.5 12.5l5 5 10-11' },
	close: { d: 'M6 6l12 12 M18 6L6 18' },

	// -- navigation ----------------------------------------------------------
	arrowLeft: { d: 'M19 12H5 M11 6l-6 6 6 6' },
	arrowRight: { d: 'M5 12h14 M13 6l6 6-6 6' },
	chevronRight: { d: 'M9 5l7 7-7 7' },
	chevronDown: { d: 'M5 9l7 7 7-7' },
	lock: {
		d: 'M6.5 10.5h11a1 1 0 0 1 1 1v7a1 1 0 0 1-1 1h-11a1 1 0 0 1-1-1v-7a1 1 0 0 1 1-1Z M8.5 10.5V7.5a3.5 3.5 0 0 1 7 0v3'
	},

	// -- quiz kinds ----------------------------------------------------------
	/** Open book — reading. */
	book: {
		d: 'M12 7.5C10.5 6 8.5 5.5 4.5 5.5v12c4 0 6 .5 7.5 2 1.5-1.5 3.5-2 7.5-2v-12c-4 0-6 .5-7.5 2Z M12 7.5v14'
	},
	/** Headphones — listening. */
	headphones: {
		d: 'M4.5 14.5v-2a7.5 7.5 0 0 1 15 0v2 M4.5 13.5h2a1 1 0 0 1 1 1v3a1 1 0 0 1-1 1h-2a1 1 0 0 1-1-1v-3a1 1 0 0 1 1-1Z M17.5 13.5h2a1 1 0 0 1 1 1v3a1 1 0 0 1-1 1h-2a1 1 0 0 1-1-1v-3a1 1 0 0 1 1-1Z'
	},
	/** Pen on a ruled line — dictation. */
	pen: {
		d: 'M4 20h16 M16.5 4.5l3 3L9 18l-4 1 1-4 10.5-10.5Z'
	},
	/** Two speech bubbles — the AI speaking exercise. */
	chat: {
		d: 'M8.5 14.5H6l-2.5 2.5v-10a1 1 0 0 1 1-1h9a1 1 0 0 1 1 1v6a1 1 0 0 1-1 1Z M17.5 9.5h1.5a1 1 0 0 1 1 1v9l-2.5-2.5h-6a1 1 0 0 1-1-1v-1.5'
	},
	/** Loop with a voice wave — listen and repeat. */
	repeat: {
		d: 'M4.5 11V9.5a3 3 0 0 1 3-3h10 M14.5 3.5l3 3-3 3 M19.5 13v1.5a3 3 0 0 1-3 3h-10 M9.5 20.5l-3-3 3-3'
	},
	/** A blank on a ruled line — fill in the gap. */
	blank: {
		d: 'M4 17h16 M7 11.5h3 M14 11.5h3 M4 6h16'
	},

	// -- progress ------------------------------------------------------------
	/** Bookmark ribbon with a swallowtail — the completion mark. */
	ribbon: {
		d: 'M6.5 3.5h11v17l-5.5-4.5-5.5 4.5v-17Z'
	},
	flame: {
		d: 'M12 21c3.6 0 6-2.3 6-5.4 0-3.7-3.4-5.3-3-9.6-2.3.8-3.6 2.7-3.6 4.6 0 1-.6 1.6-1.3 1.6-.8 0-1.3-.7-1.3-1.8C7.3 11.4 6 13.1 6 15.6 6 18.7 8.4 21 12 21Z'
	},
	trophy: {
		d: 'M8 4.5h8v4.5a4 4 0 0 1-8 0V4.5Z M8 6H5.5v1.5A3 3 0 0 0 8.5 10.5 M16 6h2.5v1.5a3 3 0 0 1-3 3 M12 13v3.5 M8.5 19.5h7'
	},
	star: {
		d: 'M12 4l2.4 5 5.6.7-4 3.9 1 5.4-5-2.7-5 2.7 1-5.4-4-3.9 5.6-.7L12 4Z'
	},

	// -- chrome --------------------------------------------------------------
	search: { d: 'M11 4.5a6.5 6.5 0 1 1 0 13 6.5 6.5 0 0 1 0-13Z M15.8 15.8l3.7 3.7' },
	settings: {
		d: 'M12 9a3 3 0 1 1 0 6 3 3 0 0 1 0-6Z M12 2.5l1.3 2.3 2.6-.5.5 2.6 2.3 1.3-1.2 2.3 1.2 2.3-2.3 1.3-.5 2.6-2.6-.5L12 21.5l-1.3-2.3-2.6.5-.5-2.6-2.3-1.3 1.2-2.3-1.2-2.3 2.3-1.3.5-2.6 2.6.5L12 2.5Z'
	},
	copy: {
		d: 'M9 9h9a1 1 0 0 1 1 1v9a1 1 0 0 1-1 1H9a1 1 0 0 1-1-1v-9a1 1 0 0 1 1-1Z M5.5 15.5A1.5 1.5 0 0 1 4 14V5.5A1.5 1.5 0 0 1 5.5 4H14a1.5 1.5 0 0 1 1.5 1.5'
	},
	external: { d: 'M13.5 4.5H19.5v6 M19.5 4.5L11 13 M17 14v5.5H4.5V7H10' },
	info: {
		d: 'M12 3.5a8.5 8.5 0 1 1 0 17 8.5 8.5 0 0 1 0-17Z M12 11v5.5',
		fill: 'M12 7a1.1 1.1 0 1 1 0 2.2A1.1 1.1 0 0 1 12 7Z'
	},
	help: {
		d: 'M12 3.5a8.5 8.5 0 1 1 0 17 8.5 8.5 0 0 1 0-17Z M9.5 9.3a2.6 2.6 0 0 1 5 .9c0 1.7-2.5 2.1-2.5 3.8',
		fill: 'M12 16a1.1 1.1 0 1 1 0 2.2A1.1 1.1 0 0 1 12 16Z'
	},
	trash: {
		d: 'M4.5 6.5h15 M9 6.5V4.5h6v2 M6.5 6.5l1 13h9l1-13 M10 10v6 M14 10v6'
	},
	words: {
		d: 'M4.5 5.5h15a1 1 0 0 1 1 1v11a1 1 0 0 1-1 1h-15a1 1 0 0 1-1-1v-11a1 1 0 0 1 1-1Z M8 9.5h8 M8 13h5'
	}
} as const;

/** The icon names, taken from the literal registry above. */
export type IconName = keyof typeof RAW;

/**
 * The registry, widened to [IconSpec]. `as const` is what gives us the
 * [IconName] union, but it also narrows each entry to its own literal shape —
 * which would hide the optional `fill` and `width` on the entries that omit
 * them. This view restores them without losing the key union.
 */
export const icons: Record<IconName, IconSpec> = RAW;

/** The icon that stands for each quiz type, shared by every list and header. */
export const QUIZ_TYPE_ICONS = {
	fillBlank: 'blank',
	reading: 'book',
	listening: 'headphones',
	dictation: 'pen',
	speakRepeat: 'repeat',
	speaking: 'chat'
} as const satisfies Record<string, IconName>;
