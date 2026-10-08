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
    date: "2026-10-08",
    title: "Picture hunts: find the word in the room",
    highlight: true,
    items: [
      "Every module has two new picture hunts, next to its flashcards: a busy, lived-in room — a living room and a classroom at the start, a carpenter's workshop and a harbour at the end — and the question \"Wo ist der Heizkörper?\". You tap the thing in the picture.",
      "Each room hides 32 things, a fair mix of der, die and das, and a run of ten never asks the same one twice. Every word you find is also added to that module's flashcard deck.",
      "Tap the wrong object and it tells you what you touched, and you keep looking — the answer only lights up after three misses. A tap on bare wall costs nothing, and a tap just beside the right thing counts, because fingers are wider than a piece of chalk.",
      "Once you have passed a run, the hunt gets harder: the question hides the article — \"Wo ist ___ Tür?\" — and after you find it you choose der, die or das yourself.",
      "On a phone the picture fills the whole width, and you can pinch to zoom (or use the + and − buttons) to reach the small things.",
      "Each find shows its label in its gender's colour, then leaves a small tick, so you can see what you have found without labels covering the room. Every question can be heard read aloud.",
    ],
  },
  {
    date: "2026-10-08",
    title: "One word panel at a time",
    items: [
      "Tapping a word for its meaning used to leave the last panel open if the two words were in different sentences, so reading through a text left a trail of them until you tapped the background. Now tapping any word closes the one before it.",
    ],
  },
  {
    date: "2026-10-08",
    title: "Syncing between phone and computer works now",
    items: [
      "Signing in worked, but the sync behind it did not: the cloud copy refused every save, so each device kept showing \"Couldn't reach your account\" and the two never met. The cloud now accepts your own progress and nobody else's, and the first sync merges what each device had.",
      "If you signed in before today, press Sync now in Settings on each device once. Nothing was lost in the meantime — it was all still in each browser.",
    ],
  },
  {
    date: "2026-10-08",
    title: "The finished bar folds away instead of disappearing",
    items: [
      "Closing the bar at the end of an exercise used to leave you with no way to try again or move on, short of going back to the deck. It now folds into a small \"Finished\" pill in the corner; tap it and the bar is back with Try again, Next quiz and your deck.",
      "The More menu has a Start over button too, so a run that is going badly can be restarted at any point, not only once it is finished.",
    ],
  },
  {
    date: "2026-10-08",
    title: "Tap any word, not just the nouns",
    highlight: true,
    items: [
      "Every German word in the course can now be tapped for what it means in English — verbs in whatever form the sentence happens to use them, prepositions, and the small words like doch, sich and zwar that are in every sentence and in nobody's vocabulary list.",
      "It works in reading and listening texts, in the questions, in the fill-in exercises, in a dictation once you have revealed the line, in the Learn lessons, in the Help Memory examples and in the story dialogue.",
      "Nouns look exactly as they did: coloured blue, red or green for der, die and das, and showing their article and plural when you tap them. Every other word stays unmarked until you hover or tab to it, so a text still reads like a text.",
      "The meanings are written for someone learning, not copied from a translator. \"der\" tells you it is also the feminine dative and genitive; \"weil\" tells you it sends the verb to the end; \"gern\" explains that \"ich esse gern\" means \"I like eating\".",
      "Each word in the panel can be played out loud, and nouns and verbs link through to their full page in the Word Library.",
      "There is a new page listing the small words A–Z, searchable from either language: ask what \"obwohl\" means, or ask which German word means \"although\".",
      "All of it is the same Word help switch as before — in Settings, or on the exercise itself when you would rather be tested than helped.",
    ],
  },
  {
    date: "2026-10-08",
    title: "Sign in if you want to — and a dictation that listens properly",
    highlight: true,
    items: [
      "You can now sign in with your email address and keep your progress across devices: start on the laptop, carry on from the phone. No password — you get a link in your inbox and tapping it signs you in.",
      "It stays optional. Nothing in the course is behind a login, signing out leaves everything in this browser exactly as it was, and the only things stored are your email address and your own scores. Find it in Settings, in your progress panel, or as the one quiet line under your deck that you can wave away for good.",
      "If you have already practised on this device, nothing is thrown away when you sign in: the two copies are merged, and the better of the two wins for every exercise — the higher score, the longer streak, the better medal.",
      "And if you had been practising on two devices before signing in, you get asked rather than told. The first sign-in shows you both side by side — exercises finished, best streak, medals, when each was last practised — and you choose: keep both, which loses nothing, or keep one and drop the other. Nothing is written until you have picked.",
      "Dictation is now graded word by word instead of all-or-nothing. A missing comma, a dropped umlaut or a typo counts as right — \"nearly\" — and only half a sentence counts as a miss, with the words to listen for again marked in the line.",
      "Dictation is played in runs of ten like the other drills, with the same bar, the same streak carried between visits, the same medals and the same card at the end. A line you miss comes back round a couple of questions later, and a quiz with more lines than a run hands you a different ten each time.",
      "A dictation or fill-in exercise no longer jumps back to its first line while you are part-way through a run.",
      "New look for the app: a drawn logo in the top bar, a sharp icon on your home screen and a new picture when you share a link.",
      "The front page now says what the course is before it counts what is in it.",
    ],
  },
  {
    date: "2026-10-08",
    title: "Finding your own exercise, and a card that shows you the swipe",
    items: [
      "The way to the full list is now called the Exercise library, and it sits in the row under your card as a button of its own, next to Skip and Let's go. Picking an exercise yourself is a normal way to use the course, not something to go hunting for.",
      "On your first visit a hand sweeps across the top card to show you what it is for: swipe right to start the exercise, left to drop it. It disappears for good the moment you swipe, press a button or use the arrow keys, and it stands still if you have calm effects on.",
    ],
  },
  {
    date: "2026-10-07",
    title: "Story mode: voices that act, a map you can read",
    items: [
      "Every voice in Lost in Berlin and The Empty Room was re-recorded with an acting brief: Maya whispers into her recorder and lands her jokes, the baker is warm, the caretaker grumbles through the intercom, and the fast-talking stranger is now genuinely fast instead of a recording sped up.",
      "The Kiez map was redrawn: cobbles on the square, a fountain, windows on the houses, a dashed centre line on the streets, two arches under the bridge. A street-map pin drops where you stand, so finding a place starts from somewhere.",
      "When Maya's credibility runs out and a chapter restarts, the room number, the directions and every other detail stay the same. They only change when you start a story over from the beginning.",
    ],
  },
  {
    date: "2026-10-07",
    title: 'A second song: "Der, die, das"',
    items: [
      'A1.1 has an article rap: one day in Berlin told in English, with every noun of the level wearing its der, die or das. The story explains the words, the beat fixes the article. It sits after "Artikel im Nominativ" and comes round as a "Sing along" card in your deck.',
    ],
  },
  {
    date: "2026-10-07",
    title: 'A song to shout: "Ich bin Max"',
    items: [
      'A1.1 has a sing-along: a rap about landing in Berlin with zero German, getting everything wrong, and ending up with the whole sein table by heart. Find it at the top of the level, or wait for the orange "Sing along" card in your deck.',
      'The song page has the recording, the lyrics, and a "heard it" tick so the card stops coming round. No score, no medal — just sing.',
    ],
  },
  {
    date: "2026-10-06",
    title: "Runs and medals: the bar only moves forward",
    highlight: true,
    items: [
      'Grammar drills and flashcard decks are now played in runs of ten. The bar fills with every answer, right or wrong, and the run ends when it is full — a slip near the end no longer sends you back to the start. Finishing a run marks the exercise either way: a green tick from eight of ten right, a "try again" mark below that, so your deck shows which drills want another go.',
      "Your streak is its own thing: right answers in a row, carried on from run to run and visit to visit. A miss just starts it again at zero. There are no lives to lose any more.",
      "Medals come from the streak, whenever it happens: eight in a row is bronze, sixteen silver, twenty-four gold — mid-run, at the end, or three runs later. Each one gets a celebration of its own, bigger than the one for a finished run.",
      "Every run ends on a card: how many you got right, your best streak, the medal once the exercise is done, and the sentences you missed. Try again and the bar starts fresh with the streak still running.",
      "A sentence you miss comes back round a couple of questions later in the same run, and your runs are kept on record so the deck can tell a drill that needs more repetitions from one you hold.",
      "The same mark — medal, green tick or \"try again\" — now appears wherever an exercise is listed: the level page, the flashcard shelf in the word library, and the worksheet builder.",
    ],
  },
  {
    date: "2026-10-05",
    title: "A new first story: Lost in Berlin",
    highlight: true,
    items: [
      "Know no German at all? Start here. Maya lands in Berlin with a dead phone and a rain-soaked address, and you get her from the airport to the right doorbell.",
      "Everything is something to do: tap the right sign in the picture, steer Maya across a map with links, rechts and geradeaus, get off at the right U-Bahn stop by listening, and talk your way through a bakery, a fast-talking stranger and a grumpy intercom.",
      'You learn your first German along the way, from Hallo and Entschuldigung to "Ich verstehe nicht" and "Einen Pfannkuchen, bitte", plus a few Berlin facts.',
      "Every word in Maya’s notebook now has a play button with a recorded voice.",
      "The Empty Room, the second story, now waits for you in the middle of A1.1, once you have learned the German it needs.",
      "In every story you can now rearrange the words you build a sentence from: tap a placed word to take it back, then Check.",
    ],
  },
  {
    date: "2026-10-05",
    title: "The deck respects your level",
    items: [
      'Pick a level in the deck chooser and the "Learn next" and "Mix it up" cards now stay around it. Before, they could keep offering the first level no matter what you picked.',
      'Older exercises still come back when they need to: something you left part-way, a weak spot, or a review that is due. Medal nudges ("bronze, go for silver") only appear near your level.',
    ],
  },
  {
    date: "2026-10-05",
    title: "Build the sentence: word tiles",
    highlight: true,
    items: [
      "Word-order exercises are now built from word tiles. Tap them into the gap to practise verb second, verb last after weil, dass and wenn, indirect questions and the order of time, manner and place, from A1.2 up to C2.",
      "One tile is always a wrong form, so the word order has to be right and so does the word. Tap a placed tile to take it back.",
      "On a keyboard, number keys 1–9 place a tile, Backspace takes back the last one and Enter checks.",
      "The printable workbooks list the same words in brackets, in scrambled order, for you to write into the gap in the right order.",
    ],
  },
  {
    date: "2026-10-05",
    title: "Gentler corrections, sharper answers",
    items: [
      "A right answer now simply turns green instead of being typed out again.",
      'When relaxed correction lets a small slip through, you see it: "Correct — mind the spelling: schon → schön", with a little extra time to read it.',
      'Telling the time explains more: the minutes always come first, there is no "und", and the regional forms "zehn vor halb drei" and "drei Viertel elf" are accepted.',
      "A round of answer-key corrections across the course, so fewer right answers get marked wrong.",
    ],
  },
  {
    date: "2026-10-05",
    title: "Fits the smallest phones",
    items: [
      "Long German words now wrap at the edge of the screen instead of pushing the page sideways.",
      "Workbook tables scroll inside their card on a phone, and the workbook contents list uses one column.",
      "Settings with four choices lay them out two by two on narrow screens.",
      "Story mode captions wrap onto a second line instead of being cut off.",
    ],
  },
  {
    date: "2026-10-04",
    title: "A practice reminder in your calendar",
    items: [
      "New in Settings: pick your days and a time, and add a repeating practice reminder to Google Calendar, Apple Calendar, Outlook or any other calendar.",
      "Tapping the reminder takes you straight back to your course. Nothing is sent to us, and you can change or delete it in your calendar at any time.",
    ],
  },
  {
    date: "2026-10-04",
    title: "Open to more learners: accessibility",
    highlight: true,
    items: [
      "Works with screen readers: right and wrong answers, corrections and results are read out, and German is read in a German voice.",
      'Everything works from the keyboard, with a "Skip to content" link, and you no longer lose your place when the screen changes.',
      'New "Wait for me" answer reveal in Settings: exercises only move on when you press Next or Enter.',
      'A new setting adds a "Show the text" button to dictations and listening exercises, for when you can\'t hear the audio.',
      "Clearer text colours and a more visible answer box, and noun genders now differ by underline as well as colour.",
      '"Calm effects" now also stops the pulsing on the audio and microphone buttons.',
      "Read more in the new Accessibility section of the About page, linked from the footer.",
    ],
  },
  {
    date: "2026-10-04",
    title: "Privacy, in plain sight",
    items: [
      "A new Privacy section in Settings spells out what the site keeps: no cookies, no account, no personal data — just anonymous, aggregate statistics.",
      '"Start over" now also erases the one on-device statistics marker, along with your progress.',
    ],
  },
  {
    date: "2026-10-02",
    title: "Story mode begins, and a workbook for every level",
    highlight: true,
    items: [
      "First steps of Story mode: illustrated mystery episodes that teach A1.1 German through a story you follow.",
      "Printable workbooks for every level from A1.1 to C2.2, laid out like the lessons with pictures and a fold-away answer column.",
      "Audio now speaks only the German — hints and symbols are no longer read aloud.",
    ],
  },
  {
    date: "2026-10-01",
    title: "A new course home",
    items: [
      "The course home is now a swipeable card deck: pick a pace — steady, fast, adventurous or review — and work through it card by card.",
      "Every card in the deck got its own picture.",
      "A slimmer header leaves more room for the exercises.",
    ],
  },
  {
    date: "2026-09-30",
    title: "Recorded audio across all levels",
    items: [
      "Natural recorded pronunciation for the spoken text in every level, A1.1 through C2.2.",
      "Fixed the on-screen keyboard covering the answer field on phones.",
      "Questions shuffle more sensibly, so repeats feel fresh.",
    ],
  },
  {
    date: "2026-09-28",
    title: "Built for your phone",
    items: [
      "Every quiz now fits on one screen — notes and extras slide up as panels instead of pushing the exercise around.",
      'Celebrations got friendlier, and a new "Calm effects" setting turns them down if you prefer quiet.',
      "Long exercises are split into steps that are paged to your screen.",
    ],
  },
  {
    date: "2026-09-27",
    title: "Flashcards for every sub-level",
    items: [
      "A flashcard deck for each of the 12 sub-levels, built from the vocabulary of its lessons.",
      "A round of corrections across the course content.",
    ],
  },
  {
    date: "2026-09-25",
    title: "A clearer front door",
    items: [
      "A redesigned home page that explains the course and takes you straight to the right level.",
      "New navigation tabs so the word library and settings are always one tap away.",
    ],
  },
  {
    date: "2026-09-23",
    title: "A fuller course",
    items: [
      "Much more content from A1 to C2: new exercises, richer explanations and more examples at every level.",
    ],
  },
  {
    date: "2026-09-22",
    title: "The app, rebuilt",
    highlight: true,
    items: [
      "Language Quiz was rebuilt from the ground up as a fast, lightweight web app — it loads quicker and works better on every device.",
      "Every level is open from the start: begin wherever suits you.",
      "Relaxed correction is now the default — a missing umlaut or full stop no longer counts against you, and the exact spelling is still shown.",
      "Fill-in-the-blank fields sit right inside the sentence again.",
    ],
  },
  {
    date: "2026-09-21",
    title: "One course, full focus",
    items: [
      "The app now concentrates on a single, complete German course from A1 to C2.",
      "The coin economy and the apartment mini-game were retired to keep the focus on learning.",
    ],
  },
  {
    date: "2026-09-08",
    title: "A fresh start page",
    items: [
      "A redesigned landing page and start screen that take you into the course in fewer taps.",
      "Smarter AI study prompts, and fixes to the printable PDFs and the Help Memory.",
    ],
  },
  {
    date: "2026-08-22",
    title: "Find your level, speak out loud",
    items: [
      "A placement test that finds your level and starts you in the right place.",
      "Talk 1.0: speaking practice — take a prompt to your favourite voice assistant and bring your score back.",
      "New language pairs: English ↔ Spanish joined the catalogue.",
      "An in-app poll so you can vote on what gets built next.",
    ],
  },
  {
    date: "2026-07-07",
    title: "The word library arrives",
    items: [
      "A browsable library of German nouns and verbs, with articles, plurals and conjugations.",
      "A course finder to discover everything on offer.",
      "Clear legal notes: Language Quiz is an independent study aid.",
    ],
  },
  {
    date: "2026-07-02",
    title: "More languages",
    items: [
      "A language and course selector on the menu.",
      "Chinese ↔ English courses, including handwriting practice with stroke scoring.",
    ],
  },
  {
    date: "2026-06-29",
    title: "Private by design",
    items: [
      "Cookieless, privacy-first analytics — no consent banner, because nothing personal is collected.",
      "A faster app all round.",
    ],
  },
  {
    date: "2026-06-26",
    title: "Your own apartment",
    items: [
      "A playful apartment you furnished with coins earned by studying, with a shop and a room editor.",
      "Upgraded German grammar content behind the scenes.",
    ],
  },
  {
    date: "2026-06-23",
    title: "The full ladder, with ears",
    highlight: true,
    items: [
      "A complete course from A1 to C2, with listening and dictation exercise types.",
      "Natural text-to-speech with male and female voices, so every sentence can be heard.",
    ],
  },
  {
    date: "2026-06-20",
    title: "Quests and more courses",
    items: [
      "A quest chain that unlocks the next exercise as you keep your streak going.",
      "Spoken audio in exercises for the first time.",
      "New courses: travel German, everyday emotions, and German for Spanish speakers.",
      "The first version of relaxed correction: small slips no longer sink an answer.",
    ],
  },
  {
    date: "2026-06-13",
    title: "Der, die, das",
    items: [
      "The article trainer: learn each noun with its gender, plural and small built-in quizzes.",
      "The Help Memory: a reference you can open next to any exercise.",
      "Printable PDF worksheets, streak counters, prepositions and plurals.",
    ],
  },
  {
    date: "2026-06-08",
    title: "Language Quiz is born",
    highlight: true,
    items: [
      "The very first version: a free quiz for German pronouns and articles, with instant feedback and a little celebration for every correct answer.",
    ],
  },
];
