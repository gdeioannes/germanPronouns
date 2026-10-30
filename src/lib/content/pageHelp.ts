// The "?" in the top bar: a short explanation of the page you are on, keyed
// by SvelteKit route id. Written for learners: what this screen is, and what
// each part of it does. A page without an entry simply shows no "?". The
// chat and Ja oder Nein? screens have no top bar; they show the same "?" in
// their own header (components/PageHelp).

/** A picture for an item (components/help/HelpVisual). */
export type Visual =
	| 'anatomy'
	| 'swipe'
	| 'mix'
	| 'review'
	| 'surprise'
	| 'contacts-anatomy'
	| 'lifecycle'
	| 'chat-anatomy'
	| 'interest';

export interface HelpTopic {
	/** The panel's title. */
	title: string;
	/** One or two sentences: what this screen is for. */
	intro: string;
	/** Its parts, one short explanation each, with an optional bullet list. */
	items: { title: string; text: string; list?: string[]; visual?: Visual }[];
}

export const PAGE_HELP: Record<string, HelpTopic> = {
	'/course/[courseId]': {
		title: 'How the deck works',
		intro:
			'Your deck is a hand of about twelve exercise cards, picked for you from what you have done, the level you are at and the pace you chose. The top card is the one we suggest next.',
		items: [
			{
				title: 'The deck at a glance',
				text: 'What each part of the screen does:',
				visual: 'anatomy'
			},
			{
				title: 'Swipe right to start, left to skip',
				text: 'Swipe a card right, tap it or press "Let\'s go" to open the exercise. Swipe left or press "Skip" for not now. A skipped card stays away until you have been through the rest of the deck, then it can come back.',
				visual: 'swipe'
			},
			{
				title: 'What the cards say',
				text: '"Continue" is an exercise you started and did not finish; it always comes first. "Learn next" is the next step in order, "Practise" and "Review" bring back what is due again or went less well, and "Something new" is a peek at something you have not tried.'
			},
			{
				title: 'Pace and level',
				text: 'The chip under the title sets how the deck deals. Slow & steady keeps to your level with regular review. Fast learner pushes a level ahead. Adventurous spreads two levels either way. Polish up puts weak spots and due reviews first. You can also pick the level yourself, or leave it on automatic and it follows your progress.'
			},
			{
				title: 'How the deck picks your cards',
				text: 'Every hand mixes three groups. Within each group the strongest candidates are the likeliest, but not certain, so no two hands are the same. The groups are spread through the hand, so a repair card turns up every few cards rather than all at once.',
				list: [
					'Repair: exercises that went less well (about one mistake in five or more), ones you started and left, and finished ones due for review.',
					'New: exercises you have not tried yet, mostly at your level.',
					'Next steps: the next exercise in order, ones that build on what you are good at, and a mix of the rest.'
				]
			},
			{
				title: 'How your pace changes the mix',
				text: 'The same three groups, in different amounts. Slow & steady keeps a balance, Fast learner and Adventurous deal more new cards and reach further up the levels, and Polish up is mostly repair.',
				visual: 'mix'
			},
			{
				title: 'When an exercise comes back',
				text: 'A finished exercise returns for a quick review once enough time has passed. The better it went, the longer it waits. "Shaky" means about one mistake in five or more on your last go.',
				visual: 'review'
			},
			{
				title: 'The progress ring',
				text: 'It shows how much of the current level you have done. Tap it for the full picture, level by level.'
			},
			{
				title: 'Runs and medals',
				text: 'Exercises come in runs of ten, and eight right or better passes the run. Most exercises have three ways to play, shown as a switch above the exercise: an easier one, the usual one and one with no help, where nouns lose their gender colors until you answer. Passing a run on one earns its medal: bronze, silver or gold. Exercises you read, hear, say or write earn their medal by score instead: bronze for a pass, gold for full marks. Once you hold a medal, the bar at the end offers the next one up — "Try for silver", then "Try for gold". A medal is never taken away, and there are no lives. When you check a text with gaps, every gap you missed is listed in its sentence, with the right answer and why, and "Read the corrected text" shows the whole text filled in.'
			},
			{
				title: 'How surprises turn up',
				text: 'Each time the deck deals, it decides once whether a surprise comes, then picks one kind at random from the kinds that have something for you right now. Your very first surprise is the story prologue. Settings has a switch to turn surprises off.',
				visual: 'surprise',
				list: [
					'Story: the next episode in order, once you have reached its place in the course.',
					'Song: the next song for your level.',
					'Ja oder Nein?: the next themed round.',
					'Schreib mir!: the next character you have not met, as close to your level as possible. A chat you have started always comes back until it ends, as the surprise in that hand.'
				]
			},
			{
				title: 'Exercise library',
				text: 'The button between Skip and Let\'s go lists every exercise in order, if you would rather choose yourself.'
			},
			{
				title: 'The heart in the top bar',
				text: 'Once you have met a Schreib mir! character in the deck, a heart appears in the top bar. Its number counts the characters who liked you, and it opens your contacts.'
			}
		]
	},

	'/course/[courseId]/level/[levelId]': {
		title: 'This level',
		intro: 'Everything this level teaches, topic by topic, and the exercise that practises each one.',
		items: [
			{
				title: 'Checking what you have covered',
				text: 'Each topic links to its exercise, and the marks show which ones you have done. Use it to see what is left before you move up.'
			},
			{
				title: 'Back to learning',
				text: 'Your deck keeps dealing from the level you are at. Open any exercise here directly, or go back to the deck and let it choose.'
			}
		]
	},

	'/play/schreib-mir': {
		title: 'Schreib mir!',
		intro:
			'A chat game. Characters turn up in your course deck; open one there and you can chat with them in German, building every answer from word tiles, to reach the goal on their profile. This page is your contact list.',
		items: [
			{
				title: 'The list at a glance',
				text: 'What each part of the page shows:',
				visual: 'contacts-anatomy'
			},
			{
				title: 'How a character moves through the list',
				text: 'Everyone starts blurred at the bottom. Meeting them in your deck brings them up to Offen, and the chat decides where they end up.',
				visual: 'lifecycle'
			},
			{
				title: 'No like? They leave',
				text: 'What you say stays said: there is no second try inside a chat. A character who liked you stays as a contact. Anyone else leaves the list and goes back to the blurred ones, and may turn up in your deck again for another chance. The level chips filter the whole list.'
			}
		]
	},

	'/play/schreib-mir/[id]': {
		title: 'How the chat works',
		intro:
			'Reach the goal at the top by chatting in German. Every answer is a sentence you build yourself from the word tiles.',
		items: [
			{
				title: 'The chat at a glance',
				text: 'What each part of the screen does:',
				visual: 'chat-anatomy'
			},
			{
				title: 'Building a sentence',
				text: 'Tap tiles to add them to your sentence, tap a word in your sentence to take it back, and send with the arrow. The "." tile ends a sentence so you can start another, and "?" makes it a question.'
			},
			{
				title: 'The score and the hearts',
				text: 'Two things count: how well your sentence is built, and what it says. The words you choose steer the chat, so the character reacts to what you meant, not only to whether it is correct.',
				visual: 'interest'
			},
			{
				title: 'Photos and voice notes',
				text: 'Some messages are a photo or a voice note, and the right answer may depend on what you see or hear in it. A voice note plays twice at most.'
			},
			{
				title: 'One chance',
				text: 'There is no undo after you send. If the chat ends without a like, the character leaves your contacts, and may turn up in your deck again for a fresh start.'
			}
		]
	},

	// Wortblöcke carries its own illustrated "So spielst du" guide in-game
	// (shown before the first play, reopened from the ? in its top bar), so
	// it has no PageHelp entry: one set of instructions, not two.

	'/play/ja-nein': {
		title: 'Ja oder Nein?',
		intro:
			'Which German city are you? Which animal, which drink? Twelve quick questions in easy German. Swipe towards your answer: nothing is marked, there is nothing to get wrong.',
		items: [
			{
				title: 'Swiping',
				text: 'Some questions are yes or no, some are this or that. Swipe towards the side you pick, or tap it.'
			},
			{
				title: 'Your result',
				text: 'At the end you get your type, in percent, with a profile, your mix of all five, what your Ja and Nein say about you, who you get on with and who you clash with, and a German word to keep. It goes on your persona shelf.'
			},
			{
				title: 'Sharing',
				text: 'Send your type and your mix to a friend: the link opens the same twelve questions for them, so they can answer back.'
			}
		]
	},

	'/play/ja-nein/personas': {
		title: 'Your persona shelf',
		intro: 'Every persona Ja oder Nein? can make you: ten shelves of five.',
		items: [
			{
				title: 'Collecting',
				text: 'The ones you have earned are in color, the rest are a question mark. Play a round again and you may land on a different persona.'
			},
			{
				title: 'Picking a round',
				text: 'Each shelf lists its rounds, so you can play any of them from here as well as from the deck.'
			}
		]
	},

	'/literature': {
		title: 'Literature',
		intro: 'German classics in the original words, annotated for English speakers. Each one is a free PDF to print or read on a tablet.',
		items: [
			{
				title: 'How a book is laid out',
				text: 'The story comes in short reading stages. Each stage starts with the hard words and their English meaning, then the text. A dotted underline marks a phrase with a note on the German at the foot of the page.'
			},
			{
				title: 'Which level',
				text: 'The texts are unsimplified, so they suit B1 and up. The glossaries do most of the work; read the list once, then read without stopping at every word.'
			},
			{
				title: 'Asking for a book',
				text: 'The link under the shelf takes you to the forum, where you can ask for the next book or back someone else\'s pick. Only books in the public domain can go on the shelf: the author died more than 70 years ago, and it is the German original.'
			}
		]
	},

	'/songs': {
		title: 'Songs',
		intro: 'Funny sing-alongs about Max in Berlin. Each one has the recording, the lyrics and the English for every German line.',
		items: [
			{
				title: 'Pick a song',
				text: 'Tap a song to open it, then press play. "Heard" marks the songs you have listened to the end.'
			},
			{
				title: 'In your deck',
				text: 'Songs also turn up in your deck as a surprise, one at a time. Here you can pick any of them.'
			}
		]
	},

	'/level-check': {
		title: 'Your level',
		intro: 'Find out where you stand whenever you like. Nothing here counts as an exercise: no marks, no medals.',
		items: [
			{
				title: 'The word check',
				text: 'Tap the German words you know, screen by screen. It takes about two minutes and ends with your level, about how many words you know, and a suggestion for your deck.'
			},
			{
				title: 'Your checks',
				text: 'Every check is kept here, newest first, with how many words you gained since the one before. One a month shows your progress best.'
			},
			{
				title: 'Coming later',
				text: 'A placement test of grammar, reading and listening will join the word check on this page.'
			}
		]
	},

	'/level-check/words': {
		title: 'The word check',
		intro: 'Tap the words you know. The check finds your level from what you tap: no marks, no medals, nothing marked done.',
		items: [
			{
				title: 'Which words to tap',
				text: 'A word you would understand if you read it. You do not need to be able to use it yourself.'
			},
			{
				title: 'Made-up words',
				text: 'A few words on every screen are made up. Tapping them lowers your result, so only tap the words you are sure about. They keep the result honest.'
			},
			{
				title: 'How it moves on',
				text: 'Each screen holds words of one level. Know nearly all of them and the check jumps a level; know about half and it steps one up; know few and it stops. Most checks take four to six screens.'
			},
			{
				title: 'Your result',
				text: 'The bars show how much of each level you know. A light bar is worked out from the levels around it rather than shown. Your level is the first one you do not know well yet: that is where to learn.'
			},
			{
				title: 'Setting up your deck',
				text: 'The result suggests a level and a pace for your deck. One tap puts them in place; "Choose differently" lets you pick your own. You can change both later from the chip above your deck.'
			}
		]
	},

	'/stories': {
		title: 'Stories',
		intro: 'Maya\'s Berlin mysteries: playable stories, one for each step of the course. You solve the case with the German you have.',
		items: [
			{
				title: 'Where to start',
				text: 'The prologue needs no German at all. Each later episode fits a level of the course and uses what you have learned up to there.'
			},
			{
				title: 'In your deck',
				text: 'Episodes also turn up in your deck as a surprise, in order. Here you can pick any of them.'
			}
		]
	},

	'/words': {
		title: 'Word library',
		intro: 'Every German word in the course in one place: search for a word and open its page.',
		items: [
			{
				title: 'Nouns',
				text: 'Each noun page has its article (der, die or das), its plural, the English meaning and an example with audio.'
			},
			{
				title: 'Verbs',
				text: 'Each verb page has full conjugation tables with audio.'
			},
			{
				title: 'Small words',
				text: 'The dictionary lists the small words that hold a sentence together, like doch, mal and sich. You can also tap any German word in an exercise to see what it means.'
			}
		]
	},

	'/words/dictionary': {
		title: 'Dictionary',
		intro: 'The small words that hold a German sentence together, A to Z: pronouns, articles, prepositions, conjunctions and particles.',
		items: [
			{
				title: 'Tap a word anywhere',
				text: 'The same meanings appear when you tap a German word inside any exercise.'
			}
		]
	},

	'/words/nouns': {
		title: 'Nouns',
		intro: 'Every noun in the course by theme. Open one for its article, plural, meaning and an example with audio.',
		items: [
			{
				title: 'der, die, das',
				text: 'The article is part of the word: learn it with the noun, and the plural with it.'
			}
		]
	},

	'/words/nouns/[slug]': {
		title: 'A noun',
		intro: 'This word with its article, plural, meaning and an example sentence. Tap the speaker to hear it.',
		items: []
	},

	'/words/verbs': {
		title: 'Verbs',
		intro: 'Every verb in the course. Open one for its conjugation tables.',
		items: []
	},

	'/words/verbs/[slug]': {
		title: 'A verb',
		intro: 'This verb in every form: present, past, perfect, future, imperative and Konjunktiv II, with audio.',
		items: []
	},

	'/forum': {
		title: 'Forum',
		intro: 'Report a problem with an exercise, ask a question about German, or suggest what the course should do next.',
		items: [
			{
				title: 'Reading and posting',
				text: 'Anyone can read. Sign in to start a topic or reply. When someone answers one of your topics, a dot appears on the Menu button.'
			},
			{
				title: 'From an exercise',
				text: 'The flag inside an exercise opens a report with that exercise and question already filled in.'
			},
			{
				title: 'Answered and fixed',
				text: 'The main list shows only open topics. A topic marked answered moves to "Answered", and a problem that has been put right moves to "Fixed". Both are folded at the bottom. Search still finds every topic.'
			}
		]
	},

	'/forum/[id]': {
		title: 'A topic',
		intro: 'One question or report and its replies. Sign in to reply.',
		items: []
	},

	'/forum/new': {
		title: 'A new topic',
		intro: 'Pick a board, give your topic a clear title, and say what happened or what you would like to know.',
		items: []
	}
};
