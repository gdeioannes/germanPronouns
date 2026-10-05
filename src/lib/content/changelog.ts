// The app's changelog, newest first. Written for learners, not developers:
// each release is a short story of what changed for them, grouped under the
// day it shipped. The /changelog page renders this list, so adding a release
// here is all it takes to publish one.

export type ChangelogEntry = {
	/** ISO date, used for <time datetime> and sorting. */
	date: string;
	/** A short release name. */
	title: string;
	/** What changed, one learner-facing sentence per item. */
	items: string[];
	/** Marks the big milestones so the page can set them apart. */
	highlight?: boolean;
};

export const changelog: ChangelogEntry[] = [
	{
		date: '2026-10-05',
		title: 'A new first story: Lost in Berlin',
		highlight: true,
		items: [
			'Know no German at all? Start here. Maya lands in Berlin with a dead phone and a rain-soaked address, and you get her from the airport to the right doorbell.',
			'Everything is something to do: tap the right sign in the picture, steer Maya across a map with links, rechts and geradeaus, get off at the right U-Bahn stop by listening, and talk your way through a bakery, a fast-talking stranger and a grumpy intercom.',
			'You learn your first German along the way, from Hallo and Entschuldigung to "Ich verstehe nicht" and "Einen Pfannkuchen, bitte", plus a few Berlin facts.',
			'Every word in Maya’s notebook now has a play button with a recorded voice.',
			'The Empty Room, the second story, now waits for you in the middle of A1.1, once you have learned the German it needs.',
			'In every story you can now rearrange the words you build a sentence from: tap a placed word to take it back, then Check.'
		]
	},
	{
		date: '2026-10-05',
		title: 'The deck respects your level',
		items: [
			'Pick a level in the deck chooser and the "Learn next" and "Mix it up" cards now stay around it. Before, they could keep offering the first level no matter what you picked.',
			'Older exercises still come back when they need to: something you left part-way, a weak spot, or a review that is due. Medal nudges ("bronze, go for silver") only appear near your level.'
		]
	},
	{
		date: '2026-10-05',
		title: 'Build the sentence: word tiles',
		highlight: true,
		items: [
			'Word-order exercises are now built from word tiles. Tap them into the gap to practise verb second, verb last after weil, dass and wenn, indirect questions and the order of time, manner and place, from A1.2 up to C2.',
			'One tile is always a wrong form, so the word order has to be right and so does the word. Tap a placed tile to take it back.',
			'On a keyboard, number keys 1–9 place a tile, Backspace takes back the last one and Enter checks.',
			'The printable workbooks list the same words in brackets, in scrambled order, for you to write into the gap in the right order.'
		]
	},
	{
		date: '2026-10-05',
		title: 'Gentler corrections, sharper answers',
		items: [
			'A right answer now simply turns green instead of being typed out again.',
			'When relaxed correction lets a small slip through, you see it: "Correct — mind the spelling: schon → schön", with a little extra time to read it.',
			'Telling the time explains more: the minutes always come first, there is no "und", and the regional forms "zehn vor halb drei" and "drei Viertel elf" are accepted.',
			'A round of answer-key corrections across the course, so fewer right answers get marked wrong.'
		]
	},
	{
		date: '2026-10-05',
		title: 'Fits the smallest phones',
		items: [
			'Long German words now wrap at the edge of the screen instead of pushing the page sideways.',
			'Workbook tables scroll inside their card on a phone, and the workbook contents list uses one column.',
			'Settings with four choices lay them out two by two on narrow screens.',
			'Story mode captions wrap onto a second line instead of being cut off.'
		]
	},
	{
		date: '2026-10-04',
		title: 'A practice reminder in your calendar',
		items: [
			'New in Settings: pick your days and a time, and add a repeating practice reminder to Google Calendar, Apple Calendar, Outlook or any other calendar.',
			'Tapping the reminder takes you straight back to your course. Nothing is sent to us, and you can change or delete it in your calendar at any time.'
		]
	},
	{
		date: '2026-10-04',
		title: 'Open to more learners: accessibility',
		highlight: true,
		items: [
			'Works with screen readers: right and wrong answers, corrections and results are read out, and German is read in a German voice.',
			'Everything works from the keyboard, with a "Skip to content" link, and you no longer lose your place when the screen changes.',
			'New "Wait for me" answer reveal in Settings: exercises only move on when you press Next or Enter.',
			'A new setting adds a "Show the text" button to dictations and listening exercises, for when you can\'t hear the audio.',
			'Clearer text colours and a more visible answer box, and noun genders now differ by underline as well as colour.',
			'"Calm effects" now also stops the pulsing on the audio and microphone buttons.',
			'Read more in the new Accessibility section of the About page, linked from the footer.'
		]
	},
	{
		date: '2026-10-04',
		title: 'Privacy, in plain sight',
		items: [
			'A new Privacy section in Settings spells out what the site keeps: no cookies, no account, no personal data — just anonymous, aggregate statistics.',
			'"Start over" now also erases the one on-device statistics marker, along with your progress.'
		]
	},
	{
		date: '2026-10-02',
		title: 'Story mode begins, and a workbook for every level',
		highlight: true,
		items: [
			'First steps of Story mode: illustrated mystery episodes that teach A1.1 German through a story you follow.',
			'Printable workbooks for every level from A1.1 to C2.2, laid out like the lessons with pictures and a fold-away answer column.',
			'Audio now speaks only the German — hints and symbols are no longer read aloud.'
		]
	},
	{
		date: '2026-10-01',
		title: 'A new course home',
		items: [
			'The course home is now a swipeable card deck: pick a pace — steady, fast, adventurous or review — and work through it card by card.',
			'Every card in the deck got its own picture.',
			'A slimmer header leaves more room for the exercises.'
		]
	},
	{
		date: '2026-09-30',
		title: 'Recorded audio across all levels',
		items: [
			'Natural recorded pronunciation for the spoken text in every level, A1.1 through C2.2.',
			'Fixed the on-screen keyboard covering the answer field on phones.',
			'Questions shuffle more sensibly, so repeats feel fresh.'
		]
	},
	{
		date: '2026-09-28',
		title: 'Built for your phone',
		items: [
			'Every quiz now fits on one screen — notes and extras slide up as panels instead of pushing the exercise around.',
			'Celebrations got friendlier, and a new "Calm effects" setting turns them down if you prefer quiet.',
			'Long exercises are split into steps that are paged to your screen.'
		]
	},
	{
		date: '2026-09-27',
		title: 'Flashcards for every sub-level',
		items: [
			'A flashcard deck for each of the 12 sub-levels, built from the vocabulary of its lessons.',
			'A round of corrections across the course content.'
		]
	},
	{
		date: '2026-09-25',
		title: 'A clearer front door',
		items: [
			'A redesigned home page that explains the course and takes you straight to the right level.',
			'New navigation tabs so the word library and settings are always one tap away.'
		]
	},
	{
		date: '2026-09-23',
		title: 'A fuller course',
		items: [
			'Much more content from A1 to C2: new exercises, richer explanations and more examples at every level.'
		]
	},
	{
		date: '2026-09-22',
		title: 'The app, rebuilt',
		highlight: true,
		items: [
			'Language Quiz was rebuilt from the ground up as a fast, lightweight web app — it loads quicker and works better on every device.',
			'Every level is open from the start: begin wherever suits you.',
			'Relaxed correction is now the default — a missing umlaut or full stop no longer counts against you, and the exact spelling is still shown.',
			'Fill-in-the-blank fields sit right inside the sentence again.'
		]
	},
	{
		date: '2026-09-21',
		title: 'One course, full focus',
		items: [
			'The app now concentrates on a single, complete German course from A1 to C2.',
			'The coin economy and the apartment mini-game were retired to keep the focus on learning.'
		]
	},
	{
		date: '2026-09-08',
		title: 'A fresh start page',
		items: [
			'A redesigned landing page and start screen that take you into the course in fewer taps.',
			'Smarter AI study prompts, and fixes to the printable PDFs and the Help Memory.'
		]
	},
	{
		date: '2026-08-22',
		title: 'Find your level, speak out loud',
		items: [
			'A placement test that finds your level and starts you in the right place.',
			'Talk 1.0: speaking practice — take a prompt to your favourite voice assistant and bring your score back.',
			'New language pairs: English ↔ Spanish joined the catalogue.',
			'An in-app poll so you can vote on what gets built next.'
		]
	},
	{
		date: '2026-07-07',
		title: 'The word library arrives',
		items: [
			'A browsable library of German nouns and verbs, with articles, plurals and conjugations.',
			'A course finder to discover everything on offer.',
			'Clear legal notes: Language Quiz is an independent study aid.'
		]
	},
	{
		date: '2026-07-02',
		title: 'More languages',
		items: [
			'A language and course selector on the menu.',
			'Chinese ↔ English courses, including handwriting practice with stroke scoring.'
		]
	},
	{
		date: '2026-06-29',
		title: 'Private by design',
		items: [
			'Cookieless, privacy-first analytics — no consent banner, because nothing personal is collected.',
			'A faster app all round.'
		]
	},
	{
		date: '2026-06-26',
		title: 'Your own apartment',
		items: [
			'A playful apartment you furnished with coins earned by studying, with a shop and a room editor.',
			'Upgraded German grammar content behind the scenes.'
		]
	},
	{
		date: '2026-06-23',
		title: 'The full ladder, with ears',
		highlight: true,
		items: [
			'A complete course from A1 to C2, with listening and dictation exercise types.',
			'Natural text-to-speech with male and female voices, so every sentence can be heard.'
		]
	},
	{
		date: '2026-06-20',
		title: 'Quests and more courses',
		items: [
			'A quest chain that unlocks the next exercise as you keep your streak going.',
			'Spoken audio in exercises for the first time.',
			'New courses: travel German, everyday emotions, and German for Spanish speakers.',
			'The first version of relaxed correction: small slips no longer sink an answer.'
		]
	},
	{
		date: '2026-06-13',
		title: 'Der, die, das',
		items: [
			'The article trainer: learn each noun with its gender, plural and small built-in quizzes.',
			'The Help Memory: a reference you can open next to any exercise.',
			'Printable PDF worksheets, streak counters, prepositions and plurals.'
		]
	},
	{
		date: '2026-06-08',
		title: 'Language Quiz is born',
		highlight: true,
		items: [
			'The very first version: a free quiz for German pronouns and articles, with instant feedback and a little celebration for every correct answer.'
		]
	}
];
