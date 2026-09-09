import '../../../models/quiz_content.dart';
import 'en_de_ai_builder.dart';

/// M10 · C1.2 — *Nuancieren* (Nuance).
///
/// Can-do: convey attitude and inference; read between the lines of
/// literary/journalistic text; handle idioms and word formation actively.
/// Grammar: subjective modals (er muss/dürfte/soll/will es getan haben),
/// Wortbildung (Ver-/Ent-/Zer-, -ung/-heit/-keit/-bar/-los), idioms &
/// collocations, rhetorical devices (irony markers, litotes),
/// aspect-like nuances (gerade dabei sein zu…).
///
/// C1.2 session shape: 5 minutes, 9 exchanges, pass 70; reports in German.
const _c12Session = SpeakingSession(durationMinutes: 5, minExchanges: 9);

const _copyTip = HelpMemoryTip(
  kind: 'rule',
  title: 'How this course works',
  text:
      'Copy the exercise into your AI assistant (voice mode is best), do the '
      'exercise there, and paste the score it gives you back here. Stay with '
      'one assistant so your scores stay comparable.',
);

final List<QuizContent> enDeAiM10Quizzes = [
  enDeAiEx(
    id: 'en_de_ai_m10_words_idioms',
    title: 'Words: the idiom decoder',
    level: 'C1',
    mode: SpeakingMode.vocabDrill,
    session: _c12Session,
    passScore: 70,
    topic:
        'Idiom decoder in three steps per idiom: I describe the literal '
        'image, then give the actual meaning, then use it in a small '
        'situation you propose. Missed idioms return later in the drill '
        'until I land them.',
    material:
        'Idioms to drill (idiom = meaning):\n'
        'jmdm. die Daumen drücken = to keep one\'s fingers crossed · '
        'die Katze im Sack kaufen = to buy a pig in a poke · '
        'ins Fettnäpfchen treten = to put one\'s foot in it · '
        'jmdm. reinen Wein einschenken = to tell someone the plain truth · '
        'auf dem Holzweg sein = to be barking up the wrong tree · '
        'zwei Fliegen mit einer Klappe schlagen = to kill two birds with '
        'one stone · '
        'die Kirche im Dorf lassen = to keep things in proportion · '
        'jmdm. auf den Zahn fühlen = to sound someone out, grill them · '
        'aus allen Wolken fallen = to be flabbergasted · '
        'den Nagel auf den Kopf treffen = to hit the nail on the head · '
        'um den heißen Brei herumreden = to beat around the bush · '
        'jmdn. auf die Palme bringen = to drive someone up the wall · '
        'sich etwas hinter die Ohren schreiben = to take a lesson to '
        'heart · '
        'mit dem falschen Fuß aufstehen = to get up on the wrong side of '
        'bed · '
        'das Handtuch werfen = to throw in the towel',
    practisePoints: [
      'Image → meaning → situated use, all three steps per idiom',
      'The idiom\'s fixed grammar (case, reflexive, preposition)',
      'Choosing the idiom that fits a situation, not just knowing it',
    ],
    scoringCriteria: [
      'correct meanings without hesitation',
      'idioms used with their fixed grammar intact',
      'situational fit in the use step',
    ],
    priorityErrors: [
      'idiom parts swapped or literal-translated',
      'wrong case after the idiom (jmdm. vs jmdn.)',
    ],
    intro:
        'Fifteen idioms every German speaker carries around. Your AI runs '
        'the decoder: picture, meaning, then a live situation — and the '
        'ones you fumble come back for revenge.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'mnemonic',
        title: 'Keep the image, keep the idiom',
        text:
            'Idioms stick through their pictures: a cat sold in a sack, a '
            'nail hit square on the head. Spend two seconds seeing the '
            'image and the phrase files itself.',
      ),
      HelpMemoryTip(
        kind: 'warning',
        title: 'jmdm. or jmdn. is part of the idiom',
        text:
            'The case is baked in: jmdm. (Dativ) die Daumen drücken, but '
            'jmdn. (Akkusativ) auf die Palme bringen. Learn the '
            'abbreviation with the phrase — it is not decoration.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m10_film_club',
    title: 'Film club: reading the characters',
    level: 'C1',
    mode: SpeakingMode.conversation,
    session: _c12Session,
    passScore: 70,
    topic:
        'Film club: invent a film we have both "watched" and share its '
        'plot with me first — a drama with at least one ambiguous '
        'character and one unexplained event. Then we discuss it, and I '
        'must infer motives with subjective modals: er dürfte eifersüchtig '
        'gewesen sein, sie soll früher … gewesen sein, er will nichts '
        'gewusst haben. Challenge my inferences and make me grade my own '
        'certainty.',
    practisePoints: [
      'Subjective modals with past infinitive (dürfte … gewesen sein)',
      'Grading certainty: muss > dürfte > könnte',
      'soll for hearsay, will for the character\'s own claim',
    ],
    targetVocabulary: [
      'das Motiv',
      'die Andeutung',
      'dürfte … gewesen sein',
      'soll … haben',
      'will … getan haben',
      'die Schlüsselszene',
    ],
    scoringCriteria: [
      'correct modal + infinitive-perfect constructions',
      'the modal matching the intended certainty',
      'inferences grounded in the shared plot',
    ],
    priorityErrors: [
      'wollte instead of will for claims (er will es nicht gewusst haben)',
      'gewesen sein order scrambled',
    ],
    intro:
        'Your AI invents a film; you both pretend you saw it last night. '
        'Now gossip about the characters — every guess about their motives '
        'needs the right subjective modal.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'The certainty ladder',
        text:
            'er muss es getan haben (I\'m sure) → er dürfte (probably) → '
            'er könnte (maybe). And sideways: er soll (people say), er '
            'will (he himself claims). Five modals, five stances.',
      ),
      HelpMemoryTip(
        kind: 'example',
        title: 'The full construction',
        text:
            '"Sie dürfte von Anfang an Bescheid gewusst haben." — modal in '
            'position two, the whole past parked at the end as participle '
            '+ haben/sein. One template for every inference.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m10_word_lab',
    title: 'Game: the word-formation lab',
    level: 'C1',
    mode: SpeakingMode.wordGame,
    session: _c12Session,
    passScore: 70,
    topic:
        'A morphology game about German word formation. Be strict about '
        'what actually exists — and explain the morphology behind every '
        'catch.',
    material:
        'Game rules:\n'
        '- 6 rounds. Each round you give me one root: binden, die Kraft, '
        'brauchen, der Mut, denken, klar (use these, in any order).\n'
        '- Per round I build 4 REAL derivatives using prefixes and '
        'suffixes (Ver-/Ent-/Zer-/Miss-, -ung/-heit/-keit/-bar/-los/'
        '-lich…), each with a one-line meaning — plus ONE plausible FAKE '
        'hidden among them, in a random position.\n'
        '- You spot the fake. If you catch it: explain why the morphology '
        'fails or what the real word would be — you get the glory, I get '
        '5 points per correct real word. If my fake fools you: 10 bonus '
        'points for me.\n'
        '- Wrong "real" words cost me 5 points and an explanation from '
        'you.\n'
        '- About 30 points possible per round; convert my total to the '
        'final score.',
    practisePoints: [
      'Productive prefixes: Ver- (change), Ent- (removal), Zer- (apart)',
      'Noun suffixes: -ung, -heit, -keit and which stems take which',
      '-bar and -los adjectives and their meanings',
    ],
    scoringCriteria: [
      'real derivatives with correct meanings',
      'plausible fakes that respect German morphology',
      'understanding the explanations, not just the points',
    ],
    priorityErrors: [
      '-heit/-keit attached to the wrong stem type',
      'meanings guessed from English instead of the prefix logic',
    ],
    intro:
        'A laboratory game: grow real words from six roots and smuggle in '
        'one convincing fake per round. Fooling your AI takes exactly the '
        'morphological feeling this module is after.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'Prefixes carry meaning',
        text:
            'Ver- transforms or spoils (verbinden, sich verlaufen), Ent- '
            'removes or undoes (entbinden, entkräften), Zer- breaks apart '
            '(zerdenken, zerreden). Guess an unknown verb from its prefix '
            'before reaching for a dictionary.',
      ),
      HelpMemoryTip(
        kind: 'mnemonic',
        title: '-keit follows -ig, -lich, -bar',
        text:
            'Adjectives in -ig/-lich/-bar take -keit (Heiterkeit, '
            'Brauchbarkeit); most others take -heit (Klarheit, Kühnheit). '
            'A fake like "Klarkeit" is exactly the kind your AI will '
            'pounce on.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m10_read_literary',
    title: 'Reading: between the lines',
    level: 'C1',
    mode: SpeakingMode.readingQa,
    session: _c12Session,
    passScore: 70,
    topic:
        'A short literary excerpt to read for tone rather than facts. Ask '
        'the questions in German, one at a time; question 4 demands a '
        'litotes paraphrase.',
    material:
        'Passage (show it to me exactly like this):\n'
        'Herr Brenner war kein unbeliebter Mann. Jeden Morgen um sieben '
        'grüßte er die Nachbarn mit jener Herzlichkeit, die man sich über '
        'Jahre antrainiert, und die Nachbarn grüßten zurück, wie man eben '
        'zurückgrüßt. Sein Garten war der ordentlichste der Straße; kein '
        'Grashalm wagte es, länger zu sein als die anderen. Als er im '
        'Frühjahr verkündete, er werde nun endlich das Leben genießen, '
        'nickten alle beifällig. Man wusste ja, wie sehr er es verdient '
        'hatte. Fortan genoss Herr Brenner das Leben: montags von neun '
        'bis zehn, nach dem Rasenmähen. Die Nachbarn fanden das nicht '
        'wenig beeindruckend. Nur das Mädchen aus dem dritten Stock '
        'fragte einmal, warum er dabei nie lächle. Herr Brenner erklärte '
        'ihr freundlich, zum Genießen gehöre Disziplin — sonst werde am '
        'Ende noch etwas daraus.\n'
        '\n'
        'Ask me (one at a time):\n'
        '1. Wie steht der Erzähler zu Herrn Brenner — und woran im Text '
        'erkennt man das?\n'
        '2. Was verrät der Satz über den Grashalm über Herrn Brenner, '
        'ohne es direkt zu sagen?\n'
        '3. Worin liegt die Ironie in "Fortan genoss Herr Brenner das '
        'Leben: montags von neun bis zehn"?\n'
        '4. "Kein unbeliebter Mann" und "nicht wenig beeindruckend" sind '
        'Litotes: formuliere beide direkt um und erkläre, was die '
        'Verneinungsform zusätzlich transportiert.\n'
        '5. Der Schlusssatz kippt die Logik ("sonst werde am Ende noch '
        'etwas daraus"): Was sagt er wörtlich, was bedeutet er '
        'wirklich?',
    practisePoints: [
      'Reading tone: what the narrator shows vs what he says',
      'Litotes decoded and paraphrased (kein unbeliebter Mann)',
      'Naming irony precisely instead of just sensing it',
    ],
    scoringCriteria: [
      'tone and stance read correctly from the text',
      'both litotes paraphrased with their extra shade explained',
      'the closing irony unpacked, literal vs meant',
    ],
    priorityErrors: [
      'litotes read as plain negation (kein unbeliebter = unbeliebt)',
      'irony explained by retelling instead of analyzing',
    ],
    intro:
        'A little story that says almost nothing directly and means '
        'everything sideways. Read it twice, then answer questions about '
        'what is written between the lines.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'Litotes: denied opposite, raised eyebrow',
        text:
            '"Kein unbeliebter Mann" is more than "beliebt" minus '
            'enthusiasm — the double negative holds the praise at arm\'s '
            'length. Paraphrase the meaning AND name the distance.',
      ),
      HelpMemoryTip(
        kind: 'tip',
        title: 'Irony hides in precision',
        text:
            'When a text is suspiciously exact — "montags von neun bis '
            'zehn" — the precision itself is the joke. Numbers where '
            'feelings belong are a classic irony marker.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m10_translate_hedge',
    title: 'Translate: hedge & attitude',
    level: 'C1',
    mode: SpeakingMode.translationDrill,
    session: _c12Session,
    passScore: 70,
    topic:
        'Ten English sentences whose whole point is the hedge: allegedly, '
        'apparently, supposedly, claims to. Each must land in German as '
        'angeblich, offenbar, soll … haben, will … haben or dürfte — the '
        'wrong hedge counts as a wrong answer even if the grammar holds. '
        'Serve one at a time and correct immediately.',
    material:
        'Sentences to serve one at a time (grade the hedge choice '
        'strictly):\n'
        '1. He allegedly stole the documents.\n'
        '2. Apparently, the meeting has been cancelled.\n'
        '3. She claims to have known nothing about it.\n'
        '4. The minister is said to have resigned last night.\n'
        '5. Supposedly, the building was never inspected.\n'
        '6. He must have forgotten our appointment.\n'
        '7. The company reportedly paid no taxes for years.\n'
        '8. She is probably still at the office. (dürfte)\n'
        '9. He says he paid the bill, but nobody believes him.\n'
        '10. By all appearances, the plan has failed.\n'
        'Round 2: pick 3 of my German sentences and ask who is the source '
        'of the claim in each (the speaker? rumor? the subject himself?) — '
        'I must justify my hedge choice.',
    practisePoints: [
      'soll … getan haben for hearsay, will … getan haben for '
          'self-claims',
      'angeblich vs offenbar: doubted rumor vs visible evidence',
      'dürfte and muss for the speaker\'s own inference',
    ],
    scoringCriteria: [
      'the hedge matching the English source of knowledge',
      'correct modal + past-infinitive grammar',
      'justified choices in round 2',
    ],
    priorityErrors: [
      'angeblich and offenbar swapped',
      'soll and will confused for claims',
    ],
    intro:
        'Ten sentences where the grammar is easy and the attitude is '
        'everything. Who says so — rumor, evidence, or the man himself? '
        'German has a different word for each answer.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'Follow the source',
        text:
            'Others say it → soll/angeblich. He himself says it (and you '
            'doubt it) → will. You can see it → offenbar. You deduce it → '
            'dürfte/muss. Locate the source, and the hedge picks itself.',
      ),
      HelpMemoryTip(
        kind: 'warning',
        title: 'Sentence 9 is the trap',
        text:
            '"He says he paid, but nobody believes him" is the textbook '
            'will-case: "Er will die Rechnung bezahlt haben." soll would '
            'wrongly make it other people\'s rumor.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m10_irony_monologue',
    title: 'Listen: the ironic monologue',
    level: 'C1',
    mode: SpeakingMode.listenRetell,
    session: _c12Session,
    passScore: 70,
    topic:
        'An irony-detection listening: you perform a monologue dripping '
        'with irony, and I separate what was said from what was meant.',
    material:
        'The piece (perform aloud as a fluent ~90-second monologue, '
        'clearly ironic in intent but never breaking character; repeat '
        'once on request):\n'
        '- Speaker: a commuter praising the local train service after a '
        'week of chaos. He calls the daily delays "kleine '
        'Überraschungsmomente", thanks the railway for "die Gelegenheit, '
        'den Bahnsteig wirklich kennenzulernen", admires the announcement '
        '"Der Zug fällt heute leider aus" as the most reliable sentence '
        'of the week ("darauf ist wenigstens Verlass"), and closes: "Man '
        'kann wirklich nicht behaupten, dass es langweilig wird."\n'
        '- Sprinkle in at least one litotes and one modal particle doing '
        'ironic work (ja, eben).\n'
        '\n'
        'Then ask me to:\n'
        '1. Summarize the literal content: what does he SAY about the '
        'train service?\n'
        '2. State what he actually MEANS, point by point.\n'
        '3. Name at least 3 concrete irony signals in the performance '
        '(word choice, litotes, particles, exaggerated praise).\n'
        '4. Deliver his final sentence twice myself: once sincerely, once '
        'ironically — and explain what I changed.',
    practisePoints: [
      'Separating literal content from intended meaning',
      'Naming irony markers: litotes, particles, hyperbolic praise',
      'Performing the same sentence in two tonal registers',
    ],
    scoringCriteria: [
      'both layers reported accurately and kept apart',
      'at least three specific irony signals identified',
      'an audible tonal contrast in the double delivery',
    ],
    priorityErrors: [
      'taking the praise at face value',
      'signals described vaguely ("it sounds funny") without naming the '
          'device',
    ],
    intro:
        'Your AI performs a rave review that is actually a demolition. '
        'Your job: report the surface, then the truth underneath, then '
        'point at exactly where the irony leaks through.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'Irony = praise + mismatch',
        text:
            'Spoken irony lives in the gap between glowing words and a '
            'grim situation. When someone thanks the railway for "die '
            'Gelegenheit, den Bahnsteig kennenzulernen", measure the gap — '
            'that measurement is your answer.',
      ),
      HelpMemoryTip(
        kind: 'example',
        title: 'Report both layers cleanly',
        text:
            '"Wörtlich lobt er die Pünktlichkeit; gemeint ist das '
            'Gegenteil: Er beklagt die täglichen Ausfälle." — one sentence '
            'per layer, and never blend them.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m10_story_twice',
    title: 'Tell it: the anecdote, twice',
    level: 'C1',
    mode: SpeakingMode.storytelling,
    session: _c12Session,
    passScore: 70,
    topic:
        '"Erzähl es zweimal": the same four-beat anecdote told straight, '
        'then retold dripping with irony. Grade above all the CONTRAST '
        'between the two tellings — a good version 2 must be recognizably '
        'the same story wearing a smirk.',
    material:
        'Story skeleton:\n'
        '- The anecdote (invent details): I organize a perfect birthday '
        'dinner. Beat 1: the ambitious plan. Beat 2: the first thing goes '
        'wrong (the cake, the guest list…). Beat 3: everything cascades. '
        'Beat 4: the ending nobody planned.\n'
        '- Version 1, straight: sincere, factual, mildly self-critical; '
        'Perfekt narration, no irony.\n'
        '- Version 2, ironic: the same four beats retold as a triumph — '
        'hyperbolic praise for every disaster, at least 1 litotes (nicht '
        'ganz nach Plan…), at least 2 ironic modal particles (ja, eben, '
        'natürlich), 1 ironic idiom from this module, and one "gerade '
        'dabei sein zu…" at the moment of collapse.\n'
        '- After both versions, tell me which single line carried the '
        'most contrast and why.',
    practisePoints: [
      'Holding an identical event structure across two tones',
      'Ironic devices on demand: litotes, particles, hyperbole',
      'gerade dabei sein zu… for the frozen moment of disaster',
    ],
    scoringCriteria: [
      'the same four beats clearly present in both versions',
      'the required ironic devices, correctly built',
      'genuine tonal contrast, not just added jokes',
    ],
    priorityErrors: [
      'version 2 changing the events instead of the tone',
      'irony signaled by saying "ironisch" instead of performing it',
    ],
    intro:
        'One dinner-party disaster, two performances: the honest version '
        'and the version for friends who appreciate a good smirk. The '
        'grade lives in the distance between them.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'example',
        title: 'The frozen moment',
        text:
            '"Ich war gerade dabei, die Kerzen anzuzünden, als der '
            'Rauchmelder seine Meinung sagte." — gerade dabei sein zu '
            'stops time right before the crash. Every good disaster story '
            'has this beat.',
      ),
      HelpMemoryTip(
        kind: 'tip',
        title: 'Irony keeps a straight face',
        text:
            'In version 2, never admit the disaster. "Der Kuchen war eben '
            'experimentell" works BECAUSE the words stay proud while the '
            'facts burn. The listener does the laughing for you.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m10_write_review',
    title: 'Write: the review',
    level: 'C1',
    mode: SpeakingMode.writing,
    session: _c12Session,
    passScore: 70,
    topic:
        'A review of a film or book of my choice (real or invented), '
        'about 130 words, graded against the rubric. Afterwards, mark '
        'every idiom and subjective modal I used and judge each one\'s '
        'fit individually.',
    material:
        'Writing task:\n'
        '- I write a review (film or book, my choice) of about 130 words '
        'for a culture blog: what it is, what works, what doesn\'t, a '
        'verdict with a recommendation.\n'
        'Required forms:\n'
        '- At least 3 idioms from this module\'s idiom list, each fitting '
        'its sentence naturally (no idiom parade).\n'
        '- At least 2 subjective-modal inferences about the maker\'s '
        'intentions or reception (Der Regisseur dürfte sich an … '
        'orientiert haben; das Buch soll bereits verfilmt werden).\n'
        '- One evaluative adverb used precisely (keineswegs, durchaus, '
        'offenbar).\n'
        'Rubric (grade against this):\n'
        '- Register: educated-casual blog German, consistent throughout — '
        'no academic stiffness, no slang breaks.\n'
        '- The required forms present, correct, and NATURAL in context.\n'
        '- A real argument: the verdict follows from the observations.\n'
        '- Length within 120–140 words.',
    practisePoints: [
      'Idioms integrated invisibly into evaluative prose',
      'Subjective modals for inferences about intent and reception',
      'One register held across praise, criticism and verdict',
    ],
    scoringCriteria: [
      'all required forms present and natural',
      'register consistency at blog level',
      'a verdict the review actually earns',
    ],
    priorityErrors: [
      'idioms bolted on instead of woven in',
      'register wobbling between academic and colloquial',
    ],
    intro:
        'Write like the culture pages: opinionated, fluent, and quietly '
        'showing off. Three idioms and two educated guesses about the '
        'maker — all of it wearing the same voice.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Hide the homework',
        text:
            'The best required-form is the one a reader never notices. '
            '"Wer hier die Katze im Sack kauft, ist selbst schuld" earns '
            'its idiom; "Es gibt ein Sprichwort: die Katze im Sack" does '
            'not.',
      ),
      HelpMemoryTip(
        kind: 'example',
        title: 'The inference sentence',
        text:
            '"Der Autor dürfte beim Schreiben mehr an die Verfilmung als '
            'an seine Leser gedacht haben." — criticism, inference and '
            'subjective modal in one elegant jab. Reviews live on '
            'sentences like this.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m10_dinner_party',
    title: 'Roleplay: dinner-party diplomacy',
    level: 'C1',
    mode: SpeakingMode.roleplay,
    session: _c12Session,
    passScore: 70,
    topic:
        'Dinner-party diplomacy: you are a guest at my table who keeps '
        'making confidently awkward claims ("Klassische Musik ist doch '
        'nur Lärm mit Regeln", "Wer Fahrrad fährt, hasst einfach Autos"). '
        'I must deflect with humor and hedged disagreement — never a '
        'flat "Das ist falsch", never surrender either. Escalate gently '
        'if my deflections work too well, and keep the evening pleasant '
        'on the surface throughout.',
    practisePoints: [
      'Hedged disagreement: Da wäre ich mir nicht so sicher…',
      'Humor and light irony as social tools',
      'Litotes for polite doubt (nicht ganz unumstritten)',
      'Changing the subject gracefully when needed',
    ],
    targetVocabulary: [
      'Da ist was dran, aber…',
      'nicht ganz unumstritten',
      'sagen wir mal so',
      'keineswegs',
      'ein gewagter Vergleich',
      'die Kirche im Dorf lassen',
    ],
    scoringCriteria: [
      'disagreement always hedged, never blunt or absent',
      'humor that defuses rather than wounds',
      'the pleasant surface held for the whole dinner',
    ],
    priorityErrors: [
      'flat contradiction (Das stimmt nicht!)',
      'agreeing outright just to escape the topic',
    ],
    intro:
        'The hardest register there is: disagreeing charmingly. Your AI '
        'plays the guest with strong opinions; you keep the dinner warm '
        'without swallowing a single one of them.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'example',
        title: 'The three-step deflection',
        text:
            '"Da ist was dran — sagen wir mal so: Ich würde die Kirche im '
            'Dorf lassen. Aber erzählen Sie doch mal…" — concede a crumb, '
            'hedge the doubt, pass the ball. No feelings harmed.',
      ),
      HelpMemoryTip(
        kind: 'rule',
        title: 'Konjunktiv softens, litotes smiles',
        text:
            '"Da wäre ich mir nicht so sicher" and "Das ist nicht ganz '
            'unumstritten" both disagree completely while sounding like '
            'small talk. That doubleness is the whole skill.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m10_gate_interview',
    title: 'Module exam: the C1.2 interview',
    level: 'C1',
    mode: SpeakingMode.interview,
    session: SpeakingSession(durationMinutes: 6, minExchanges: 10),
    passScore: 70,
    topic:
        'The closing examination for module 10: a culture conversation '
        '(film, books, music — follow my lead). Hidden test: plant 3 '
        'idioms and 2 clearly ironic statements in YOUR turns during the '
        'conversation. I must catch each one — react to the idiom '
        'naturally or mirror it, and answer the irony on its meant level, '
        'not its literal one. Reveal at the end which I caught and which '
        'slipped past. Also demand at least 2 subjective-modal inferences '
        'from me along the way.',
    practisePoints: [
      'Catching idioms and irony live in flowing conversation',
      'Answering irony on the meant level without flagging it',
      'Subjective-modal inferences woven into culture talk',
      'Tone control: matching wit with wit',
    ],
    scoringCriteria: [
      'planted idioms and ironic statements caught and mirrored',
      'correct subjective-modal inference constructions',
      'tone held: witty, precise, never flat-footed',
    ],
    priorityErrors: [
      'ironic statements answered literally',
      'modal-inference forms broken under conversation pressure',
      'idioms noticed but responded to woodenly',
    ],
    intro:
        'The module gate — and the course\'s slyest exam: a culture chat '
        'with five traps hidden in it. Pass it and C2 territory unlocks. '
        'Retake it as often as you like — your best score counts.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'Answer the meaning, not the words',
        text:
            'When the examiner sighs "Na, DAS war ja ein Meisterwerk", '
            'agreeing politely fails the trap. Respond to the demolition '
            'underneath: "Stimmt, da hätte man das Handtuch auch früher '
            'werfen können."',
      ),
      HelpMemoryTip(
        kind: 'tip',
        title: 'Mirror, don\'t museum-guide',
        text:
            'Catching an idiom means playing it back, not explaining it. '
            'If the AI says someone "ins Fettnäpfchen getreten" ist, step '
            'into the image yourself — analysis can wait for the report.',
      ),
    ],
  ),
];
