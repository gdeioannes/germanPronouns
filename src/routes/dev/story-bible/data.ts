// Shared data for the dev-only story-bible pages. Written source of truth:
// docs/story_bible.md (general) and docs/episodes/ (per episode); this file
// is the view model the pages render.

export const imgs = import.meta.glob('/src/lib/assets/story/*.webp', {
	eager: true,
	query: '?url',
	import: 'default'
}) as Record<string, string>;
export const img = (id: string) => imgs[`/src/lib/assets/story/${id}.webp`];

export const clips = import.meta.glob('/src/lib/assets/story/voices/*.mp3', {
	eager: true,
	query: '?url',
	import: 'default'
}) as Record<string, string>;
export const clip = (id: string) => clips[`/src/lib/assets/story/voices/${id}.mp3`];

export const palette = [
	{ name: 'Ink navy', hex: '#1f3a5f', role: 'Linework and deep shadow — the drawing itself.' },
	{ name: 'Terracotta', hex: '#c9683b', role: 'Accents, rim light, the string on the case board. The "clue" colour.' },
	{ name: 'Mustard', hex: '#d9a441', role: 'Warm light and Maya’s jacket — warmth belongs to the investigation.' },
	{ name: 'Sage', hex: '#7a9a7e', role: 'Walls and calm surfaces; the resting colour of the world.' },
	{ name: 'Soft blue', hex: '#8fb3c9', role: 'Cool half-light; everything unexplored sits in it.' },
	{ name: 'Paper', hex: '#fbf8f3', role: 'Ground and highlights.' }
];

export const lighting = [
	{
		id: 'light_ref_doorshaft',
		name: 'Door shaft',
		when: 'Investigation — the default',
		how: 'A warm blade of light through a half-open door into cool blue-grey half-light; dust motes; every prop readable.'
	},
	{
		id: 'light_ref_lampcone',
		name: 'Lamp cone',
		when: 'Discoveries, confrontations',
		how: 'One warm lamp, theatrical golden cone, dusky corners.'
	},
	{
		id: 'light_ref_duskwindow',
		name: 'Dusk window',
		when: 'Calm narrative beats',
		how: 'Golden hour, long window-frame shadows, warm and safe.'
	},
	{
		id: 'light_ref_torchnoir',
		name: 'Torch noir',
		when: 'Peak tension only (2–3 per episode)',
		how: 'Night, torch beam, terracotta rim light, detail swallowed by shadow.'
	}
];

export type Character = {
	id: string;
	name: string;
	group: 'Recurring cast' | 'Episode cast — The Empty Room' | 'Episode cast — Lost in Berlin' | 'Episode cast — The Secret Room';
	accent: string;
	accentSoft: string;
	lang: string;
	tagline: string;
	bio: string;
	dress: string;
	speech: string;
	reactions: { when: string; what: string }[];
	voiceNote: string;
	voices: { id: string; label: string }[];
	portrait: string;
	gallery: { id: string; label: string }[];
};

export const cast: Character[] = [
	{
		id: 'maya',
		name: 'Maya Ellison',
		group: 'Recurring cast',
		accent: '#d9a441',
		accentSoft: '#f6ecd4',
		lang: 'English (en-US)',
		tagline: 'The investigator. Every module is an episode of her podcast.',
		bio: 'Mid-twenties American true-crime podcaster. Fluent English, almost no German — permanently at the learner’s level, so every German word she decodes, the learner decodes with her. Dry humour, over-dramatic, obsessive note-taker. The learner is her remote assistant.',
		dress:
			'Mustard corduroy jacket (always), cream-and-navy striped shirt, dark trousers, white sneakers, sage canvas messenger bag worn across the body. Round amber glasses, shoulder-length dark brown curls, pencil behind one ear. Props: navy notebook, phone, case board. Never a magnifying glass — she’s a podcaster, not a cop.',
		speech:
			'English only. Short dramatic sentences, CAPITALISED emphasis, trailing ellipses before reveals, podcast framing everywhere ("episode", "listeners", "scoop"). Warm to the learner, theatrical about everything else. She never teaches — she asks, and grammar help always sounds like case work. She never reads German aloud; her mangled German is a text-only gag.',
		reactions: [
			{ when: 'A clue is found', what: 'Gasps, over-celebrates, immediately writes it down. “THAT is going in episode one.”' },
			{ when: 'The learner answers right', what: 'Treats it as her own scoop, credits “my brilliant assistant”.' },
			{ when: 'The learner answers wrong', what: 'Blames herself or the handwriting, never the learner. “Ugh, my notes are a mess. Again?”' },
			{ when: 'German is spoken at her', what: 'Panic-polite. Repeats the two words she caught, mispronounced, then turns to the learner.' },
			{ when: 'Credibility is lost', what: 'Deflates theatrically, then rallies. “Okay. New plan. There’s always a new plan.”' }
		],
		voiceNote: 'Chirp 3 HD Achernar (en-US): young, bright, a little dramatic. Cast 2026-10-02 after four audition rounds.',
		voices: [{ id: 'maya_achernar', label: 'Reference clip' }],
		portrait: 'maya_canon_portrait',
		gallery: [
			{ id: 'maya_ref_neutral', label: 'Neutral' },
			{ id: 'maya_ref_clue', label: 'Found a clue' },
			{ id: 'maya_ref_phone', label: 'On the phone' },
			{ id: 'maya_ref_notes', label: 'Model sheet' },
			{ id: 'maya_canon_full', label: 'In a scene (door-shaft light)' },
			{ id: 'maya_canon_casefile', label: 'At the case board' }
		]
	},
	{
		id: 'jonas',
		name: 'Jonas',
		group: 'Episode cast — The Empty Room',
		accent: '#3f5d45',
		accentSoft: '#e4ebe5',
		lang: 'German (de-DE)',
		tagline: 'The missing flatmate. Seen only in photos and flashbacks.',
		bio: 'Around thirty, tall and lanky, friendly and a little shy. Maya’s flatmate since the night she landed in Berlin (Episode 0), though she barely saw him — until the morning his room was empty. Everything the learner knows about him arrives as evidence: a torn note, a filled-in form, old chat messages.',
		dress: 'Short blond hair, round wire glasses, forest-green hoodie over a white t-shirt, blue jeans, brown leather sneakers.',
		speech: 'Mostly present in writing (notes, forms, chats); heard in flashbacks and old voicemails. Warm, hesitant, simple German with lots of ähm and false starts — A1.1-level by design, and always correct despite the stumbling.',
		reactions: [],
		voiceNote: 'Chirp 3 HD Puck (de-DE): friendly, a little shy. Cast 2026-10-02 — heard in flashbacks and voicemails.',
		voices: [{ id: 'jonas_puck', label: 'Reference clip' }],
		portrait: 'jonas_ref_neutral',
		gallery: [{ id: 'jonas_ref_neutral', label: 'Reference' }]
	},
	{
		id: 'lena',
		name: 'Lena',
		group: 'Episode cast — The Empty Room',
		accent: '#c9683b',
		accentSoft: '#f7e6dd',
		lang: 'German (de-DE)',
		tagline: 'The mystery woman. Composed, hard to read.',
		bio: 'Around thirty. Her name is the first real clue — a voicemail on the WG phone. She answers questions precisely and volunteers nothing; whether she is a friend, a stranger or something else stays open until the confrontation.',
		dress: 'Straight black hair in a low bun, light olive skin, terracotta-red wool coat over a cream blouse, soft blue scarf, dark trousers, small gold earrings, ankle boots.',
		speech: 'Calm, measured German, short complete sentences, polite Sie at first. Her clips are slow and clear — she is the learner’s main listening voice in Episode 1, so she must stay pleasant to replay.',
		reactions: [],
		voiceNote: 'Chirp 3 HD Aoede (de-DE): composed, voicemail-calm. Cast 2026-10-02.',
		voices: [{ id: 'lena_aoede', label: 'Reference clip' }],
		portrait: 'lena_ref_neutral',
		gallery: [{ id: 'lena_ref_neutral', label: 'Reference' }]
	},
	{
		id: 'boehm',
		name: 'Hausmeister Böhm',
		group: 'Recurring cast',
		accent: '#1f3a5f',
		accentSoft: '#e2e8f0',
		lang: 'German (de-DE)',
		tagline: 'The building caretaker. Permanently unimpressed. Ep 0 intercom, Ep 1 red herrings.',
		bio: 'In his sixties, keeper of every key and every rule in the building. Red-herring generator: he knows something about everyone, shares it grudgingly, and is always technically right. Designed to recur across episodes as the grumpy constant.',
		dress: 'Grey moustache, bushy eyebrows, flat tweed cap, navy work overalls over a red-and-grey checked shirt, black work boots, a large ring of keys on his belt.',
		speech: 'Gruff, slow, minimal German — perfect for beginners: short declaratives, lots of repetition, complaints about schedules ("Der Müll kommt am Dienstag raus. Nicht am Montag."). Never explains twice without sighing.',
		reactions: [],
		voiceNote: 'Chirp 3 HD Charon (de-DE): gruff, unimpressed, slow. Cast 2026-10-02.',
		voices: [{ id: 'boehm_charon', label: 'Reference clip' }],
		portrait: 'boehm_ref_neutral',
		gallery: [{ id: 'boehm_ref_neutral', label: 'Reference' }]
	},
	{
		id: 'passantin',
		name: 'The woman with the dog',
		group: 'Episode cast — Lost in Berlin',
		accent: '#7a9a7e',
		accentSoft: '#e4ebe5',
		lang: 'German (de-DE)',
		tagline: 'The passer-by. Walks fast, talks faster, helps anyway.',
		bio: 'In her fifties, out with her dachshund. The learner’s first real Berlin stranger: she rattles off directions at full speed, which is exactly why “Ich verstehe nicht” exists — then says it again, slowly, pointing.',
		dress: 'Short grey bob, red-framed glasses, sage-green rain jacket, navy trousers, brown shoes, mustard tote bag; a small brown dachshund on a red lead.',
		speech: 'Brisk, kind, Sie to strangers. One fast line (played sped up, blurred on screen), then the same directions slowly in taught words only: links, rechts, geradeaus, dann.',
		reactions: [],
		voiceNote: 'Chirp 3 HD Zephyr (de-DE): bright, quick. Cast 2026-10-05 from the voice description.',
		voices: [{ id: 'passantin_zephyr', label: 'Reference clip' }],
		portrait: 'passantin_ref_neutral',
		gallery: [{ id: 'passantin_ref_neutral', label: 'Reference' }]
	},
	{
		id: 'baeckerin',
		name: 'Frau Demir, the baker',
		group: 'Episode cast — Lost in Berlin',
		accent: '#c9683b',
		accentSoft: '#f7e6dd',
		lang: 'German (de-DE)',
		tagline: 'Runs the corner bakery. Knows everyone, especially their order.',
		bio: 'In her forties, warm and chatty, the Kiez’s memory: she knows Jonas by his breakfast (a Pfannkuchen and a coffee, every morning) and corrects every tourist who orders a “Berliner” before she knows his surname. Likely to recur as Maya’s friendly local.',
		dress: 'Dark curly hair under a cream headscarf, sleeves rolled up, terracotta apron dusted with flour over a cream shirt.',
		speech: 'Counter German, Sie to customers, short and warm: greetings, “Bitte schön?”, names. The learner’s first full conversation.',
		reactions: [],
		voiceNote: 'Chirp 3 HD Sulafat (de-DE): warm. Cast 2026-10-05 from the voice description.',
		voices: [{ id: 'baeckerin_sulafat', label: 'Reference clip' }],
		portrait: 'baeckerin_ref_neutral',
		gallery: [{ id: 'baeckerin_ref_neutral', label: 'Reference' }]
	},
	{
		id: 'oma',
		name: 'Oma Hartmann, the Chefin',
		group: 'Recurring cast',
		accent: '#7a9a7e',
		accentSoft: '#e4ebe5',
		lang: 'German (de-DE)',
		tagline: 'Owns the Pension. Lena’s grandmother. The only person Maya is afraid of.',
		bio: 'Around eighty, has run Pension Sonnenschein since her mother did; the house turns a hundred in Episode 2. Interrogates guests over breakfast, puts the ones she likes to work in her kitchen (Buletten, the Berlin way), and tests Maya’s German with one question at a time. Planned co-host of Maya’s German-language podcast from Episode 3.',
		dress: 'White hair pinned up, half-moon reading glasses on a chain, sage cardigan over a cream blouse with a small gold brooch, dark skirt, sensible brown shoes. At night: a quilted sage dressing gown.',
		speech: 'Dry, unhurried, sharp, Sie to strangers. Short complete sentences a beginner can imitate: kitchen orders (“Geben Sie mir die Zwiebel”), family facts, one-word questions (“Warum?”). Her catchphrase, to any claim of speaking German: “Das sehen wir.”',
		reactions: [],
		voiceNote: 'Chirp 3 HD Gacrux (de-DE): the number tasks’ grandmother voice, kept for her. Cast 2026-10-08; Despina and Vindemiatrix recorded as alternatives.',
		voices: [{ id: 'oma_gacrux', label: 'Reference clip' }],
		portrait: 'oma_ref_neutral',
		gallery: [{ id: 'oma_ref_neutral', label: 'Reference' }]
	},
	{
		id: 'kurier',
		name: 'The courier',
		group: 'Episode cast — The Secret Room',
		accent: '#d9a441',
		accentSoft: '#f8efd6',
		lang: 'German (de-DE)',
		tagline: 'Delivers the parcel that starts Episode 2. Gone in two lines.',
		bio: 'A parcel courier with a scanner and no time. Hands Maya the misdelivered paint, reads a postcode and a total off the scanner, leaves.',
		dress: 'Yellow rain jacket, black cycling helmet, dark trousers, parcel scanner.',
		speech: 'Fast, flat, polite: “Unterschreiben Sie hier, bitte.” Digits one at a time.',
		reactions: [],
		voiceNote: 'Chirp 3 HD Rasalgethi (de-DE). Cast 2026-10-08 from the voice description.',
		voices: [{ id: 'kurier_rasalgethi', label: 'Reference clip' }],
		portrait: 'kurier_ref_neutral',
		gallery: [{ id: 'kurier_ref_neutral', label: 'Reference' }]
	}
];

export const scenarios = [
	{
		id: 'room_ref_wide',
		name: "Jonas's room",
		episode: 'The Empty Room',
		block: '{room}',
		desc: 'Anchor location. Sage-green walls, tall window, warm wooden floorboards, empty bed frame, ink-navy wardrobe with one door open, pale poster rectangles, torn paper on the floor.'
	},
	{
		id: 'room_ref_close',
		name: "Jonas's room — detail",
		episode: 'The Empty Room',
		block: '{room}',
		desc: 'The same block rendered as a close-up: the torn note on the floorboards in a shaft of window light.'
	},
	{
		id: 'ep0_square_dusk',
		src: '/img/story/ep0_square_dusk.webp',
		name: 'The square (Maya’s U-Bahn stop)',
		episode: 'Lost in Berlin',
		block: '{square}',
		desc: 'The hub of Episode 0 and Maya’s Kiez from now on: U-Bahn entrance, map board, a crossing with an Ampelmännchen light, Frau Demir’s bakery with its striped awning. Its street plan is the code-drawn Kiez map (KiezMap.svelte).'
	},
	{
		id: 'ep0_baeckerei',
		src: '/img/story/ep0_baeckerei.webp',
		name: 'Frau Demir’s bakery',
		episode: 'Lost in Berlin',
		block: '{baeckerei}',
		desc: 'Wooden counter, glass display (pretzels left, jam doughnuts middle, coffee right — the hotspot layout), blank chalkboard, terracotta tiles.'
	},
	{
		id: 'ep0_door_dusk',
		src: '/img/story/ep0_door_dusk.webp',
		name: 'The Altbau front door',
		episode: 'Lost in Berlin',
		block: '{altbau_door}',
		desc: 'Maya and Jonas’s building: dark-green double door, brass bell panel with four blank plates (close-up: ep0_bells), tiled step.'
	}
];
