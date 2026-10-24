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
    date: "2026-10-24",
    title: "Flashcards tell you the gender rule",
    items: [
      'Miss a noun in the flashcards, and the back of the card now tells you its ending rule: "words ending in -ung are always die", "-chen are almost always das", "-er are usually der".',
      'When the noun breaks the rule, the card says so: "words ending in -er are usually der, but Mutter is an exception." Exceptions are where the article trips you up, so they get a warning of their own.',
    ],
  },
  {
    date: "2026-10-24",
    title: "Tap a word, get the right meaning",
    items: [
      'Tap "arm" and you now get "poor", not the body part. In "die Kluft zwischen Arm und Reich" the panel explains the phrase too. Thanks for the report!',
      'More words that shared a spelling with a noun now show their own meaning: recht, stolz, wert, perfekt, taub, deutsch, kraft, and verbs like träumen, frühstücken, duschen, begriff (begreifen), gerät (geraten) and angeboten (anbieten).',
      '"Sieben" at the start of a sentence is seven again, not a kitchen sieve. "Morgen" at the start of a sentence reminds you it often means tomorrow.',
      'In reported speech, "wolle", "solle" and "müsse" now say "wants", "should" and "must" instead of all saying "could".',
    ],
  },
  {
    date: "2026-10-24",
    title: "The forum shows what still needs an answer",
    items: [
      'The forum list now shows only open topics. Answered topics wait, folded, under "Answered" at the bottom, next to "Fixed". One click opens either, and search still finds every topic.',
    ],
  },
  {
    date: "2026-10-24",
    title: "One voice at a time: for screen readers and for hearing",
    items: [
      'New setting: "Say questions and answers aloud". It is on by default. If you use a screen reader, turn it off, so the course\'s voice and your screen reader don\'t talk over each other. The play buttons still work, and the picture hunt\'s Listen step still says its word, because that word is the question.',
      'With "Show the text in listening exercises" on, the picture hunt\'s Listen step writes the word you hear: the noun only, never its article.',
      "Leave an exercise right after answering, and the answer is no longer spoken on the next page.",
      "The Accessibility section of the About page now lists exactly what the course does for screen readers, the keyboard, hearing, seeing, typing and motion.",
    ],
  },
  {
    date: "2026-10-24",
    title: "The picture hunt asks out loud",
    items: [
      "After you answer in the picture hunt or the flashcards, the voice says the right word, right or wrong, while you still see it: sound, picture and word together.",
      "Every step of the picture hunt now says its question aloud, once, as soon as it appears. Bronze says it whole: \"Wo ist die Brille?\". Silver says only the noun, \"Brille\", so the article stays yours to choose. Gold, as before, says only the noun.",
      "After a first-try find on bronze the voice no longer repeats the answer you just heard, so the run moves on faster. After a miss, and on silver and gold, you still hear the answer with its article.",
    ],
  },
  {
    date: "2026-10-24",
    title: "Your level: how many German words do you know?",
    highlight: true,
    items: [
      "New in the menu: Your level. The word check shows you German words, screen by screen, and you tap the ones you know. It takes about two minutes, and the words get harder as you go.",
      "A few words on every screen are made up. Tapping them lowers your result, so tap only the words you are sure about. It keeps the answer honest.",
      "At the end you see about how many German words you know, your level, a bar for every level from A1.1 to C2.2, and the words to learn next. No marks, no medals.",
      "It also suggests a level and a pace for your deck, and one tap sets your deck up that way. Or choose your own.",
      "Your checks are kept on the Your level page, so the next one shows how many words you gained. Once a month the check turns up in your deck as a card too.",
    ],
  },
  {
    date: "2026-10-24",
    title: "Sharper covers on the study books",
    items: [
      "The covers of the A1.1 to B1.2 study books were blurry when printed. They are sharp now, in the PDFs too.",
    ],
  },
  {
    date: "2026-10-24",
    title: "B2.1 on paper: Berichten & Argumentieren",
    highlight: true,
    items: [
      "The B2.1 PDF is now a 54-page study book written for paper. It replaces the old generated workbook and is on the Workbooks shelf with its own cover.",
      "Twenty topics in three parts. Passing on what others say: politics and the news, Er sagt, er sei krank, the reported past, questions and requests, indirect questions, and the fixed little words after verbs, describing words and nouns (warten auf, stolz auf, die Kritik an). The passive and its friends: muss gelöst werden, ist gebaut worden, wird geöffnet or ist geöffnet, Hier wird getanzt, lassen, der um acht ankommende Zug, and the endings that give the gender away. Arguing: trotzdem, daher and sonst, the order of the middle of a sentence, wegen des Regens and nach dem Essen, dass or zu, Du brauchst nicht zu kommen, and writing a Stellungnahme.",
      "Five listening exercises with QR codes — the radio news, a dictation, a letter to the paper, a text about working from home and a debate about a car-free city centre — and a picture dictionary of 32 words from the hotel lobby, the building site and the polling station.",
    ],
  },
  {
    date: "2026-10-24",
    title: "B2.2 on paper: Was wäre, wenn?",
    highlight: true,
    items: [
      "The B2.2 PDF is now a 54-page study book written for paper. It replaces the old generated workbook and is on the Workbooks shelf with its own cover.",
      "Twenty topics in three parts. What isn't so: the environment, Wenn ich reich wäre …, Du hättest anrufen sollen, als ob, Er wird den Zug verpasst haben, Er soll reich sein, and eben, halt, schon and wohl. The written style: aufgrund and infolge, nouns made from verbs, bei Regen and durch Sparen, eine Entscheidung treffen, die geplanten Maßnahmen, Das lässt sich lösen, and endings like -lich, -los and -bar. Arguing well: five ways to say although, während and dagegen, wer, was and wo, damit and dadurch, jemand and welche, and a complaint letter that gets an answer.",
      "Five listening exercises with QR codes — a text about the climate, a dictation of what-ifs, a doctor on the radio, a book review and a talk about sleep — and a picture dictionary of 32 words from the eco flat and the lab.",
    ],
  },
  {
    date: "2026-10-23",
    title: 'A third song: "Wie bitte?", and a page for all songs',
    items: [
      "New song: Max's first date with Lena, survived on five German words. Too loud, too fast, a plate of snails and the bill: Wie bitte?, Noch einmal, bitte, Langsam, bitte, Ich kenne das Wort nicht, Was bedeutet …?, Können Sie das erklären? and Ich verstehe nur Bahnhof.",
      "It turns up in your A1.1 deck after the listening exercise where you introduce yourself, and the English for every German line is right under the lyrics.",
      "Songs in the menu now opens a page with all the songs. Each one has its own play button, so you can listen right there, and a link to its lyrics.",
      "A song's page keeps the menu at the top, and its back arrow takes you to the list of songs.",
    ],
  },
  {
    date: "2026-10-23",
    title: "The picture hunt: a walkthrough, half points and flip cards",
    items: [
      "The first time you open a picture hunt, a short walkthrough shows how it works: find the thing, zoom in, what the colours mean and the three medals. The ? button brings it back.",
      "Found it on a later try? That is now half a point, shown in yellow on the run bar, instead of a miss. A find on the first try is still green, and a thing that had to be shown is red.",
      "The Listen step now says only the noun, without der, die or das, so the article is yours to know. Every word is recorded in the same natural voice as the rest of the course.",
      "Cards turns the room into flip cards of its words, to learn them before you hunt. They have their own runs and medals.",
      "Audio on phones: the spoken question plays even when the hunt moves on by itself, without a tap first.",
    ],
  },
  {
    date: "2026-10-23",
    title: "B1.2 on paper: the sixth study book",
    highlight: true,
    items: [
      "The B1.2 PDF is now a 46-page study book written for paper. It replaces the old generated workbook and is on the Workbooks shelf with its own cover.",
      "Seventeen topics: technology, the written past (sagte, brachte, ging, kam), the past before the past, nachdem, bevor and während, the passive now and in the past, rules on signs, the nouns that grow an -n, um … zu, damit and indem, dessen and deren, zwar … aber, Hätte ich doch …!, trotz and wegen, das lachende Kind, denn, doch, ja and mal, -heit and -keit, and writing a story where something goes wrong.",
      "Timelines show what happened first: Als ich ankam, war der Zug schon abgefahren — and where nachdem, bevor, während, seit and bis sit.",
      "Three listening exercises with QR codes — an office computer disaster, a train announcement and a podcast about stress — and a picture dictionary of 32 words.",
    ],
  },
  {
    date: "2026-10-22",
    title: "Kafka as a printed book",
    items: [
      "Die Verwandlung with the words in the margin is now also a paperback, a hardcover and a Kindle book on Amazon. The links are under the free PDF on the Literature page and on the book's own page; the PDF stays free.",
    ],
  },
  {
    date: "2026-10-22",
    title: "B1.1 on paper: the fifth study book",
    highlight: true,
    items: [
      "The B1.1 PDF is now a 46-page study book written for paper, like the A books. It replaces the old generated workbook and is on the Workbooks shelf with its own cover.",
      "Seventeen topics: the world of work, adjective endings after der, after ein and with no article at all, bigger and best before a noun, die Deutschen and etwas Neues, würde, hätte and wäre, the future with werden, der Kollege, mit dem …, the genitive, als, wenn and obwohl, falls and da, zu + verb, es gibt and es lohnt sich, worauf and darauf, and formal and informal e-mails.",
      "Every topic has a drawing that explains it: the path from job advert to contract, the window of -e endings, cut the d- and glue the rest, a chart for the three jobs of werden, and one for als or wenn.",
      "Two listening exercises with QR codes — a job interview and a radio survey — and a picture dictionary of 32 words.",
    ],
  },
  {
    date: "2026-10-21",
    title: "A2.2 on paper: the fourth study book",
    highlight: true,
    items: [
      "The A2.2 PDF is now a 46-page study book written for paper, like the books before it. It replaces the old generated workbook and is on the Workbooks shelf with its own cover.",
      "Seventeen topics: where things are and where they go (Wo? and Wohin?), ich freue mich, weil and dass, wenn and deshalb, polite wrapped questions, verbs with their little word, at the doctor's, clothes and the endings of describing words, advice with sollte, der Mann, der …, the past of fairy tales, das wird gemacht, am schnellsten, building words, when-how-where, dates and e-mails.",
      "Wo? is taught with pictures: a cat on, in, under, next to, in front of and behind a basket — then you describe a living room yourself.",
      "Two listening exercises with QR codes — a voicemail about a museum visit and a trip to the doctor — and a picture dictionary of 32 new words.",
    ],
  },
  {
    date: "2026-10-21",
    title: "More pictures and diagrams in the study books",
    items: [
      "A1.1: the endings of the present, the vowel change (fahren – du fährst) and the five plurals are now shown as words built from their parts.",
      "A2.1: Woher? Wo? Wohin? is drawn as coming from — being at — going to, the weather words are shown with pictures before you practise them, and der, dieser and welcher share their endings in one diagram.",
      "In the A2.1 weather exercise you now describe a street with four kinds of weather, instead of the same pictures that teach the words.",
    ],
  },
  {
    date: "2026-10-21",
    title: "A2.1 on paper: the third study book",
    highlight: true,
    items: [
      "The A2.1 PDF is now a 40-page study book written for paper, like A1.1 and A1.2. It replaces the old 52-page workbook and is on the Workbooks shelf with its own cover.",
      "Fourteen topics: the past with haben and sein, war, hatte and konnte, the dative (dem, der, den, mir, dir, ihm and the little words that take it), where from, where and where to, seit, vor and für, the weather, comparing, welcher and dieser, man, jemand and nichts, and telling the story of your weekend.",
      "New drawings to learn from: a timeline that shows seit, vor, in and für at a glance, a decision chart for haben or sein, and sentences cut into boxes for who gets what.",
      "Two listening exercises with QR codes — a trip to Italy and a weather report — and an e-mail to a friend to write yourself.",
      "A new picture dictionary of 32 words, drawn for this book, and all the answers at the back.",
    ],
  },
  {
    date: "2026-10-21",
    title: "Kafka with the words in the margin",
    items: [
      "The Die Verwandlung PDF no longer opens each stage with a list of words to learn first. Each word is now explained in the margin, beside the line it is on, with a thin line pointing to it.",
      "855 words are explained instead of 524, and a word that comes back later is explained again wherever there is room on the page, so you never have to page back for it.",
      "A dictionary at the back lists every word from A to Z with the page that explains it.",
      "Fixed: Achsel was given as armpit; in Kafka's German it means shoulder.",
    ],
  },
  {
    date: "2026-10-21",
    title: "A1.2 on paper: the second study book",
    highlight: true,
    items: [
      "The A1.2 PDF is now a 48-page study book written for paper, like A1.1. It replaces the old 70-page workbook and is on the Workbooks shelf with its own cover.",
      "Seventeen topics on two facing pages each: den and einen, kein and nicht, mein and unser, the helper verbs, the time, days and months, verbs that split, nach, in and zu, ordering in a café, shopping, telling people what to do, your first past tense and more.",
      "The rules are drawn, not just explained: clock faces for halb and Viertel, sentences cut into boxes so you see where the verb goes, small decision charts for kein or nicht and haben or sein, and arrows for who does what to whom.",
      "Three listening exercises with QR codes: a phone message, an announcement at the station and an order in a café.",
      "It starts where A1.1 ends: words from A1.1 aren't taught again, and where a topic builds on A1.1, a small box reminds you.",
      "Two review spreads, a one-page summary to stick on the wall, a picture dictionary of 32 words and all the answers at the back.",
    ],
  },
  {
    date: "2026-10-21",
    title: "The A1.1 book, a little clearer",
    items: [
      "der, die and das are now printed in their colours — blue, red and green, as in the rest of the site.",
      "Where the verb goes in a question is now drawn as a sentence in boxes, du or Sie? is a small decision chart, and im, am and beim are shown as in + dem, an + dem, bei + dem.",
      "Fixed: the bottom of pages 2 and 3 showed a line of computer code instead of the book's title.",
    ],
  },
  {
    date: "2026-10-20",
    title: "Fixed problems get their own list in the forum",
    items: [
      "Once a reported problem has been put right, its topic leaves the main forum list, so what you see first is what still needs doing.",
      "Open \"Fixed\" at the bottom of the forum to see everything that has been corrected. Search still finds fixed topics, so you can check before reporting something again.",
    ],
  },
  {
    date: "2026-10-20",
    title: "A1.1 on paper: a real study book",
    highlight: true,
    items: [
      "The A1.1 PDF is now a 40-page study book written for paper, instead of the exercises printed out. It replaces the old 55-page workbook.",
      "Find it on the Workbooks shelf, with its own cover, or with the PDF button next to A1.1 on your course page.",
      "Fourteen topics, each on two facing pages: the left page teaches, with tables, diagrams and pictures, and the right page is for your pencil: write, match, circle, sort into columns, label and even colour in.",
      "Nothing is asked before it is taught: every German word on a practice page is on a learn page first, this one or an earlier one.",
      "Two review spreads, a one-page summary of A1.1 to stick on the wall, a picture dictionary of 40 words and all the answers at the back, with each answer in bold.",
      "QR codes take you to the audio for the listening exercises and to more practice on the site. The book prints well on A4, in colour or black and white. A1.2 and the higher levels are being redone the same way, and show \"Work in progress\" until they are ready.",
      "The whole Deutsch A1 book is no longer offered as one big PDF: the A1.1 book replaces it, and A1.2 follows.",
    ],
  },
  {
    date: "2026-10-20",
    title: "A weak-spot sheet that is really about your weak spots",
    items: [
      "\"My weak spots\" on the printable sheet now prints only what you got wrong, not whole exercises, with the weakest exercise first, so even half a sheet does the most good.",
      "It reads your recent answers, your last run and your medals: a mistake you have since fixed fades, and one slip no longer outranks a steady run of misses.",
      "Flashcard words you keep missing now come onto the sheet too: the English, and a line for the German with its article.",
      "In the menu, \"Workbooks (PDF)\" is now \"Printable sheets\". Levels whose book is still being redone say \"PDF · work in progress\" on the course page.",
    ],
  },
  {
    date: "2026-10-20",
    title: "See what went wrong in a text with gaps",
    items: [
      "When you check a long text with gaps, every gap you missed is now listed in its own sentence: what you wrote struck through, the right answer beside it, and one line on why.",
      "\"Read the corrected text\" shows the whole text filled in, with the gaps you missed marked, and can read it aloud.",
      "The right answer under a missed gap is now a green label you can actually read, instead of tiny text.",
    ],
  },
  {
    date: "2026-10-20",
    title: "No help now means no help",
    items: [
      "On the no-help step, nouns lose their gender colours until you answer, because a colour gives away der, die or das. The Word help switch is hidden on that step for the same reason.",
    ],
  },
  {
    date: "2026-10-20",
    title: "Small fixes",
    items: [
      "The word card at the start of your deck now shows only while your cards are being dealt, never on the way back from an exercise. It stays up to five seconds: swipe it away when you are ready, or tap it to keep it.",
      "Reading, listening and other scored exercises now show the medal you actually won, not always bronze.",
      "Word help works in chats and stories opened from a link.",
      "In Schreib mir!, the translation of a word you tap now opens on top of the next message instead of under it.",
      "Two grammar hints in the higher levels were wrong and are fixed.",
    ],
  },
  {
    date: "2026-10-20",
    title: "Ja oder Nein? starts again: ten new questions about you",
    highlight: true,
    items: [
      "Ten new themes, all new: which German city, food, drink, season, animal, party guest, traveller, flatmate and friend are you, and how German are you, really? Each theme has ten rounds of twelve questions instead of eight.",
      "The result is now your type in percent, with a short profile, your mix of all five types as one bar, what your Ja and Nein say about the way you swipe, who you get on with and who you clash with.",
      "The whole result fits on one phone screen, with no scrolling.",
      "Sharing sends your type and your mix, never your answers. Your friend's link opens the same twelve questions, shows your card first, and after they play it puts the two of you side by side.",
    ],
  },
  {
    date: "2026-10-20",
    title: "A word to read while your cards are dealt",
    items: [
      "When the deck opens, it now shows a card with one odd German word or a small fact about Germany while your cards are shuffled: Kummerspeck, Treppenwitz, why you never wish a German happy birthday early. Once your cards are ready, tap it to go straight to them.",
      "When you come back to the site, you land on your deck straight away, without the front page loading first.",
      "The back arrow on menu pages, like the forum, the literature shelf or the stories, now takes you back where you came from: home or your deck.",
      "Ja oder Nein? and Schreib mir! have left the menu. You meet them in your deck, as surprises.",
    ],
  },
  {
    date: "2026-10-20",
    title: "Read Die Verwandlung online, and ask for the next book",
    items: [
      "Kafka's Die Verwandlung can now be read on the site, in the same twelve stages as the PDF: the hard words first, then the text, then the notes. The PDF is still there for anyone who would rather print it.",
      "Under the literature shelf, a new link asks which book should come next. It opens the forum, where you can ask for a book or back someone else's pick. Only books whose author died more than 70 years ago can go on the shelf.",
    ],
  },
  {
    date: "2026-10-20",
    title: "Go for the next medal in one tap",
    items: [
      "When you win a medal, the first button at the end of the run is now \"Try for silver\" (or gold), and it starts a fresh run on that way of playing. Reading, listening and other scored exercises offer the next medal the same way.",
      "Your progress panel now shows how much of the course's medals you have won, in percent, where gold counts three times bronze.",
      "The course page opens much faster.",
    ],
  },
  {
    date: "2026-10-20",
    title: "Easier to read on a phone, and with a screen reader",
    items: [
      "Grammar tables too wide for a phone now turn into small cards, each value labelled with its column, instead of hiding columns off the side of the screen.",
      "Timelines in the lessons no longer let their labels run into each other; on a phone each label gets a row of its own. Long German words in the sentence diagrams break at a syllable instead of pushing past the edge.",
      "On a phone, the menu now scrolls on its own, so its last links can always be reached.",
      "Screen readers: pop-up windows now take focus, close with Escape and give focus back; the step dots say whether a section was right or wrong; Schreib mir! messages and German titles are read in a German voice.",
    ],
  },
  {
    date: "2026-10-19",
    title: "Literature: read Kafka in German",
    highlight: true,
    items: [
      "A new Literature shelf, in the Library menu: German classics in their original words, annotated for English speakers and free to download as a PDF.",
      "The first book is Kafka's Die Verwandlung, in twelve short reading stages. Each stage opens with the hard words and their English meaning, 524 in all, and 76 notes at the foot of the pages explain the German worth noticing: old subjunctives, idioms, Prague time-telling, and the moment Gregor's sister stops calling him \"he\".",
      "The home page shows the new book, with its own little corner label next to the one for the printed A1 book. Each label takes you to its book and goes away for good once you click it.",
    ],
  },
  {
    date: "2026-10-18",
    title: "Every level's PDF, one tap from the course page",
    items: [
      "Each level on the course page now has a PDF button next to its name: the printable workbook for that level, downloaded straight away. The workbook shelf also offers the whole Deutsch A1 book as one PDF, exactly as it is printed.",
      "The printed book passed the print service's checks: its pages are US Letter with proper margins, the running heads and page numbers sit clear of the edges, the chapter photographs are cropped to fit, and the cover matches the spine for 170 pages.",
    ],
  },
  {
    date: "2026-10-18",
    title: "Deutsch A1, the printed book",
    highlight: true,
    items: [
      "The first level is now a real book: Deutsch A1, Erste Schritte and Im Alltag in one volume, 150 pages in colour, US Letter size, ready for print on demand. Every lesson, every exercise, the diagrams, the picture dictionaries and the picture hunts are on paper, with the answers upside down under each unit.",
      "Paper and phone work together: each unit carries a QR code that opens the same exercise in the app, and the listening, dictation and repeat-after-me units carry a second code that opens a player with every recording. Scan the book's own code and the app shows a checklist of the book, so what you did on paper counts here too.",
      "At the back: the key with every transcript, dictation sentence and picture-hunt list, the grammar tables of the book, an A to Z word index, and the audio index for readers without a camera.",
      "It is a work in progress, not a finished book, and that is the point of the offer on the home page: the first readers who are interested get a test copy for free, printing and postage included. Write through the contact page, read it for a week or two, and say what you think.",
    ],
  },
  {
    date: "2026-10-18",
    title: "Gold always asks a real question",
    items: [
      "Some exercises had a no-help way with nothing to go on: \"Ich sehe zwei ____ .\" with no English line and no clue. We went through every exercise, on every level, and checked what each of the three ways actually shows you. Every gold step now gives you the German sentence and its English meaning, and nothing more.",
      "This fixes the numbers, plurals, countries and languages, the first adjectives, and the past-tense modal verbs, where the small label above the card used to give the verb away. Numbers over 100 and the pronoun exercises now say the word in the English line instead of leaving a second gap.",
      "The long texts with gaps keep a bare clue on the no-help way, such as \"sein\" or \"the bed\", and only drop the grammar note. Before, seven of the twelve texts could not be filled in without the hint.",
      "Picture hunts: if your device has no German voice, the listening way shows the question in writing instead of staying silent. A wrongly tapped object no longer reveals its article while you are being asked for one.",
      "Every short reading and listening text now has six questions instead of five, so silver can be earned there too: five of six.",
    ],
  },
  {
    date: "2026-10-18",
    title: "Three ways to play every exercise, and a medal for each",
    highlight: true,
    items: [
      "Most exercises now have a switch above them with three ways to play: an easier one, the usual one and one with no help. Pass a run of ten on one of them, with eight right, and you earn its medal: bronze for the easier way, silver for the usual one, gold for no help. A medal is never taken away.",
      "Fill-in exercises: choose the answer from four, type it with the word in brackets to help, or type it with no brackets and no hint. The no-help way uses each exercise's hardest sentences, and we wrote hundreds of new ones so every exercise has at least ten.",
      "Every one of the 3,400 fill-in sentences now comes with three wrong answers to choose from. They are the mistakes learners really make, like \"gegeht\" or \"in der Büro\", and each one has been checked so it is never also right.",
      "Flashcards: remember, choose or write the word with its article. Picture hunts: find what the word names, find it and choose der, die or das, or just listen, find it and write it. The long texts with gaps: choose each gap, type it with its hint, or type it with no hints.",
      "Reading, listening, dictation, speaking and writing earn their medal by score: bronze for a pass, silver for most of the way to full marks, gold for full marks.",
      "Winning a medal is now a moment: it swings in the stamp, then flies into its place on the switch.",
      "The words to repeat in a flashcard deck now show their progress on the card. A word you missed once leaves the list after one right answer, a word you keep missing after up to three. The count on the switch goes down as you go.",
      "Medals you had already won are kept, and medals now sync between your devices when you are signed in.",
      "We also corrected about a hundred fill-in sentences that marked a right answer as wrong, such as \"Sei\" beside \"Seid\", \"Können Sie\" beside \"Könnten Sie\", and \"Montag bis Freitag\".",
      "Flashcards fit on one phone screen with no scrolling.",
    ],
  },
  {
    date: "2026-10-18",
    title: "Exercises that no longer give away the answer",
    items: [
      "In some fill-in exercises, the small label above the sentence gave away the answer: \"ich → mich\" over \"Ich freue ___ auf das Wochenende\". The labels now only give the clue, such as \"ich\", and never the word you have to find.",
      "This is fixed in 16 exercises: reflexive pronouns, war and hatte, comparatives and superlatives, the imperative, verbs with prepositions, dative prepositions, relative pronouns, \"it\" as ihn/sie/es, and the C1–C2 connectors, academic phrases and vocabulary.",
      "Clues in brackets no longer work the answer out for you either: \"(zu + dem = zum)\" is now \"(zu + dem)\", and \"(gern → lieber)\" is now \"(gern)\".",
    ],
  },
  {
    date: "2026-10-18",
    title: "Meet Schreib mir! characters in your deck, and come back straight to it",
    items: [
      "Schreib mir! characters are now met in your course deck only. When one turns up there and you open their card, you have met them, and their chat stays open for you on the Schreib mir! page as well.",
      "The Schreib mir! page is now one list of your contacts, part of the app with its menu and footer: who liked you (with what they know about you and their Sunday voice note), chats still open, chats that ended without a like, and everyone you have not met yet as a blurred portrait with a question mark. The level chips filter the whole list.",
      "Once you have met a Schreib mir! character, a heart sits in the top bar. It counts the characters who liked you, and one tap opens your contacts, so you can read your chats again.",
      "To make room, Forum and Settings have moved into the Menu. The Menu button shows a dot when someone has replied to you on the forum.",
      "A new ? in the top bar explains the screen you are on. For the deck it shows a labelled picture of the screen and diagrams of how each pace mixes your cards, when finished exercises come back and how surprises turn up. Schreib mir! gets the same: labelled pictures of your contact list and of a chat, how a character moves from blurred to liked, and how your sentence scores move the hearts. There is help too for Ja oder Nein?, the stories, the word library and the forum.",
      "Coming back to the site takes you straight to your deck, so you can carry on where you left off. The front page is still one tap away on the logo.",
    ],
  },
  {
    date: "2026-10-17",
    title: "No more tickets: surprises just turn up",
    items: [
      "Tickets are gone. Ja oder Nein?, Schreib mir! characters, story episodes and songs are now surprises in your deck, and every one that turns up can be played straight away. Nothing to save up, nothing locked.",
      "A hand holds at most one surprise, so the exercises stay the main thing. Each time the deck deals, it decides once whether a surprise comes, and then which kind, from the kinds that still have something for you. Finished every story? Then it is one of the others.",
      "A good run makes a surprise in your next hand more likely.",
      "Prefer to just learn? Settings has a new switch, Games and stories in the deck. Turn it off and the deck deals only exercises.",
      "Ja oder Nein? and Schreib mir! are now in the Library menu next to Stories and Songs, so you can play them whenever you like.",
    ],
  },
  {
    date: "2026-10-17",
    title: "Schreib mir!: fifty-one strangers who want to chat",
    highlight: true,
    items: [
      "A new game, Schreib mir!: swipe through profiles, match with someone, and chat with them in German. There are fifty-one of them, from Helga, an 81-year-old DJ with a party in her cellar, to Bernd, a flatmate who eats everything, paper included, with the most at A1 and A2 and a few strange ones waiting at C1 and C2.",
      "You never pick from ready-made answers. Every reply is a sentence you build yourself from word tiles, and what you say steers the chat: tell Helga you are bringing friends and the night goes one way, tell her you are coming alone and it goes another.",
      "Each sentence gets a small score for how well it is built. A perfect one makes your match warmer, a nearly-right one gets a friendly reply with the right version quoted back, and one they cannot follow gets a confused \"Hä?\". If they lose interest completely, they delete you.",
      "There is no second try. Every chat is played once, so what you said stays said, and the ending is the one you earned.",
      "Matches send photos and voice notes, and some replies only make sense if you looked closely or listened carefully. Every line they send can be played aloud.",
      "Win them over and you get a like and their number in your contacts. The contacts page keeps everyone you have won, with the chat to read again, and the ending card can be sent to a friend.",
      "The characters also turn up in your course deck now and then, as one of its surprises. A chat you have started comes back in every hand until it ends. The Schreib mir! page in the menu lets you browse them all.",
    ],
  },
  {
    date: "2026-10-14",
    title: "A hundred rounds of Ja oder Nein?, fifty personas, and tickets",
    highlight: true,
    items: [
      "Ja oder Nein? is now a hundred themed rounds of eight on ten shelves: Rund um die Uhr, Auf dem Teller, Regeln und Ordnung, Draußen, Nachtleben, Zuhause, Stadt gegen Land, Durchs Jahr, Unterwegs and Typisch Deutsch?. Each round is a little tour of one theme, from Brot to Silvester to Die Deutsche Bahn, eight hundred questions in all.",
      "Every shelf has five personas of its own, fifty in total, from Krustenfan and Mett-Mensch to Berghain-Schlange, Rot-Geher:in and Balkonien-Urlauber:in. A round ends on one of its shelf's five, and the result is yours to keep.",
      "Your personas have a page: ten shelves of five, the ones you have earned in colour, the rest a question mark. Play a round again and you may land on a different one. One tap sends the whole collection as a grid of squares, with your count out of fifty.",
      "The deck deals the rounds in turn, one shelf after another, and the card names the round it holds. On the persona page you can also pick any round by hand.",
      "Send a result and your friend gets the same round: the link in the message opens those eight questions, with a line that dares them to answer back.",
      "The card runs on tickets. You get one with your first deck, another every twelve hours, and you can hold two at a time. While you have one, the card has a one-in-three chance of turning up in each hand you deal, and playing it from the deck spends the ticket. Swipe it away and it waits for a later hand; the ticket stays yours. The card shows how many you hold.",
      "A good run can win a ticket: finish an exercise with eight of ten or better and there is a one-in-four chance, one in eight if you already hold one. Winning one is a proper celebration, and the run summary says so.",
      "Story episodes come to your deck in order: Episode 1 only after you have finished the prologue, Episode 2 after that. The Stories page still lets you open any episode. Once you have finished them all, the deck stops dealing them.",
      "The learner on the front page no longer sits offset and cropped on the first open on a phone.",
    ],
  },
  {
    date: "2026-10-12",
    title: "Ja oder Nein?, and a better first lesson",
    items: [
      "A surprise card turns up in your deck: Ja oder Nein? Ten quick questions about life in Germany against a sky that will not sit still. Some are yes or no (Döner um vier Uhr morgens? Socken in Sandalen?), some are this or that (Oktoberfest oder Weihnachtsmarkt? Kreuzberg oder Prenzlauer Berg?), and you swipe towards your answer. Nothing is marked. At the end you find out who you are tonight, from Nachtbus-Legende to Gemütlichkeits-Guru, with one German word to keep.",
      "The result is made to be sent: a message in German that lists every one of your answers, with a switch to English for a friend who reads none, and one tap for WhatsApp, the share sheet or the clipboard. There are a hundred questions, and no round repeats one until you have been through them all.",
      "The card is a sure thing in your first minutes with the app and a rare visitor after that. Swipe it away and it stays away for a couple of days.",
      "The very first lesson, Zahlen 0–10, starts with the number board instead of a menu: hear the eleven numbers, read them, write three. Only then come the three missions, as things to do with the numbers rather than a way to skip them.",
      "Order the round and Last U-Bahn home deal new numbers every time you play. The friends can shout any count from one to ten and the station announcer knows every platform, so a second night is never the same as the first.",
      "The numbers drill asks for platforms and favourite numbers, not only bare equations.",
    ],
  },
  {
    date: "2026-10-11",
    title: "The spoken exercises behave",
    items: [
      "The six roleplays now come with a scene and a part for each of you (a colleague back from holiday, a radio host who disagrees with you, a journalist who asks the wrong questions), and the A2 storytelling exercise comes with its story beats. Until now the prompt told your assistant to play \"the role in MATERIAL\" and there was none, so it made one up.",
      "The picture at the start of a speaking exercise only appears where it belongs to the topic. A debate no longer opens with you describing a sofa, and when there is a picture, describing it is a warm-up on top of the conversation rather than three of its seven answers.",
      "Every speaking exercise names the mistakes it cares about most, and that list now actually reaches your assistant, so the four fixes in the report are the four that matter at your level.",
      "Sessions are as long as they claim: the beginner sessions that teach first get seven minutes instead of four, and the C2 conversations get ten answers to cover their six points.",
      "The score box reads reports that only say \"FINAL SCORE: 84 / 100\", and the fixes are saved however your assistant decorates them: bold, bulleted or numbered. Before, those reports counted as no score and no fixes.",
      "A teacher's pass over every spoken and written exercise. The checkpoints now hand the assistant the actual questions, items and situations to use, so a Perfekt check asks about where you went and an irreal-past check gives you three things that went wrong. The C1 nominalisation check became a six-item packing game, the C1 and C2 conversations got a running order with the register switches and objections written in, and the capstone reads you the opening of Kafka's \"Vor dem Gesetz\" to interpret. Beginners are addressed as du, the forms they have learned. Writing requests now state the length, and the scoring no longer counts the same slip twice. Saying \"Ende\" ends any session with a report.",
      "The Copy step now tells you what the session will be before you copy anything: the kind of exercise, the scene, how many answers and minutes, and what the tutor listens for. The prompt ends with a one-line reminder of the same, which is where an assistant pays most attention. The C1 summary task comes with its own source study, so the correction can check your summary against it, and writing requests list the words the task was built around.",
    ],
  },
  {
    date: "2026-10-11",
    title: "You can write German now, and have it corrected",
    highlight: true,
    items: [
      "A new kind of exercise: writing, and there is one in every level. You write a real text yourself and the app builds a correction request that carries what you wrote. Paste it into your own AI, and it marks your own German rather than setting you a fresh task. It starts with six sentences about yourself and ends, twelve levels later, with an argued essay.",
      "The writing box is a proper little editor: a sheet of writing paper, a row of ä ö ü ß for keyboards that do not have them, bold and italic, bullet points, a word and character count, and a full-screen button for the long ones. The asterisks that mark bold never reach the correction, so nobody tries to correct them.",
      "The box tells you how long the text should be, and the length grows with the level: a few sentences at A1, a proper text at C2. You cannot send it until it is long enough, so there is always something real to correct.",
      "The task sits above the box while you need it and folds away to one line once you are writing, so the page gives the room to your own words. One tap brings it back.",
      "The four fixes the correction gives you are saved under \"Work on these next time\". Your next speaking or writing exercise quietly brings one or two of them back and tells you whether you have improved, so the same slip does not survive for long.",
      "When the score comes back there is somewhere to go: try again, the next exercise, or your deck. Try again brings your own text back rather than a blank sheet, so you can mend the four things the correction found and send it round once more. Your draft also survives closing the page by accident.",
      "A text that comes back under its pass mark is marked for another go instead of being given a medal for turning up.",
      "A round of content corrections across the course: the vocabulary decks had twelve nonsense cards built from the wrong half of an exercise, twenty nouns were marked as having no plural when they do, and all twenty-four picture hunts promised you a pair of glasses that only two of the rooms contained.",
    ],
  },
  {
    date: "2026-10-10",
    title: "A forum, and a Report button on every exercise",
    highlight: true,
    items: [
      "There is a forum now, at Forum in the menu. Four boards: ask a question about German, report a problem with an exercise, suggest something, or just say hello. Anyone can read it; writing needs the e-mail sign-in, and you pick the name you post under.",
      "Every exercise has a Report button. It opens a small panel with the exercise and the question you are looking at already filled in, so a wrong article or a crooked audio clip takes one sentence and a tap to tell us about.",
      "Topics and replies can be liked, and the forum has a search box that looks through everything on the board as you type.",
      "When someone answers you, a dot appears on the Forum link, and the forum page says which of your topics have new replies. The quiz's report panel tells you too, if the answer was to something you reported there. Each topic has a \"don't notify me\" switch if you would rather not hear about it again.",
      "Signing in is no longer hidden in the settings: the same panel opens from the top bar, the menu, the front page and the forum, and the link we e-mail you brings you back to the page you were on when you asked for it.",
    ],
  },
  {
    date: "2026-10-10",
    title: "A new front door, menus that take you places, and 188 more verbs",
    highlight: true,
    items: [
      "The home page was redrawn around what you actually do here: swipe. A learner sits with the course's cards swirling out of her phone, and the picture itself is the way in. Under it, the four things that matter — nothing locked, learning that is fun, repetition at your own pace, and mysteries to solve — and a How it works in three steps, each with an exercise you can try on the spot.",
      "The top menu now takes you somewhere instead of scrolling the front page. Three groups: Levels lists all twelve modules by name, Library holds the word library, the printable workbooks, the stories and the songs, and About has the about page, what's new and contact. On a phone the same groups sit under Menu, the twelve levels as a tight three-column grid. The \"something new\" dot moves to About, and to Menu on a phone.",
      "Stories has a shelf of its own: every episode with its picture, its level and a line about the case, so you pick an episode instead of being dropped into one. The cover of each story lists the other episodes too.",
      "The song page has a playlist under the lyrics: every song with its own play button and a link to the exercise that drills what it teaches. Pressing play on another song takes you there and starts it straight away.",
      "The word library front page shows its three collections as cards — nouns by theme, verbs conjugated in five tenses, and the small words A to Z — each with how many it holds.",
      "188 more verbs in the library, from buchstabieren and rauchen to ankommen, mitkommen and zurückkommen, every one conjugated in full. That is 354 in all, so every verb the course uses now has its own page.",
      "The deck works out your level from everything you have done, not from the highest thing you ever finished. One peek at a C2 exercise after a month of A1 no longer makes the deck treat you as a C2 learner: a level counts as yours once there is real evidence at it, and a finish that went badly counts for little. The deck, the suggestions, the story and song cards and the level chip now all agree.",
      "In a picture hunt the two modes — find it, or find it and name its article — are now one small switch beside the question, and the nudges float over the top of the picture instead of taking a row of their own, so the room gets the whole card.",
      "The cards behind the top one in your deck now peek out above it as neat coloured edges, like a pile of cards, instead of fanning out below.",
      "The what's new and contact pages have the same top bar as the rest of the site.",
    ],
  },
  {
    date: "2026-10-09",
    title: "Bigger, flatter picture hunts",
    items: [
      "The picture in a picture hunt always fills the whole width of the card again. On a short screen it used to shrink to fit the height; now the page scrolls a little instead, so the small things stay big enough to tap.",
      "The kitchen, the supermarket and the antique shop are redrawn straight from the front, like the other rooms, instead of as a box seen from a corner above. Everything sits where you expect it, and the objects are larger.",
      "In the supermarket, das Brötchen made way for das Fließband, the checkout belt — the bread roll never came out clearly enough to find.",
    ],
  },
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
    title: "The number missions give you a fair chance",
    items: [
      "In Call Kim, the smudged digits are now ones you have already heard next to a printed digit, so you can match the sound to the number. The first number used to hide a zwei and a vier you had never seen written.",
      "The phone keypad shows each number's German word under the digit, like the letters on a real keypad: 2 zwei, 3 drei.",
      "When the right person picks up and reads out the next number, the call now shrinks to a bar at the top of the chat. You can dial along while they talk instead of hanging up and replaying the voice note. The bar keeps their words, the English and a replay button, with only the number left out — that part you catch by ear.",
      "The U-Bahn platform signs spell out the number for the first two trains; the last two are by ear alone. At the bar you see the word next to your fingers: 2 · zwei.",
      "German lines in all three missions now carry little pictures next to the words to remember: drei 3️⃣, Bier 🍺, Gleis 🚉, Kaffee ☕.",
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
