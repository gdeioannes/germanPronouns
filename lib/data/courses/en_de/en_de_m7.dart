import '../../../models/quiz_content.dart';
import 'en_de_builder.dart';

/// M7 — Adjective Endings, intro (A2). The first pass at the endings: no ending
/// after sein, weak endings after der-words, mixed endings after ein-words.
/// The big text is a typed-input quiz — produce the declined adjective inline.

const List<HelpMemoryTip> _adjTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'Who already shows the gender?',
    text:
        'After **der/die/das** the article shows the case, so the adjective '
        'relaxes to weak **-e** (or **-en**). After **ein/kein/mein** the '
        'adjective must show it: **-er** (m), **-e** (f), **-es** (n).',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'der → -e, ein → -er/-es',
    text:
        '*der nett**e** Mann* (der did the work) vs *ein nett**er** Mann* (ein '
        'hides the gender, so the adjective shows -er).',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'After sein/werden/bleiben: nothing',
    text:
        'A predicate adjective never changes: Das Haus ist **alt**. Die Suppe '
        'wird **kalt**. Die Kinder bleiben **ruhig**.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'Nominative quick table',
    text:
        'der alt**e** Mann · die neu**e** Lampe · das klein**e** Kind — ein '
        'alt**er** Mann · eine neu**e** Lampe · ein klein**es** Kind.',
  ),
];

final QuizContent enDeM7Predicate = enDeFill(
  id: 'en_de_m7_predicate',
  title: 'Predicate adjectives (no ending)',
  intro:
      'Start with the easy case: when the adjective stands after sein/werden/'
      'bleiben, it takes no ending at all.',
  tips: _adjTips,
  items: const [
    CourseItem(
      prompt: 'The house is old. (alt)',
      answer: 'Das Haus ist **alt**',
    ),
    CourseItem(prompt: 'The car is new. (neu)', answer: 'Das Auto ist **neu**'),
    CourseItem(
      prompt: 'The woman is nice. (nett)',
      answer: 'Die Frau ist **nett**',
    ),
    CourseItem(
      prompt: 'The children are happy. (glücklich)',
      answer: 'Die Kinder sind **glücklich**',
    ),
    CourseItem(
      prompt: 'The coffee is hot. (heiß)',
      answer: 'Der Kaffee ist **heiß**',
    ),
    CourseItem(
      prompt: 'The film is exciting. (spannend)',
      answer: 'Der Film ist **spannend**',
    ),
    CourseItem(
      prompt: 'The soup tastes good. (gut)',
      answer: 'Die Suppe schmeckt **gut**',
    ),
    CourseItem(
      prompt: 'The weather stays beautiful. (schön)',
      answer: 'Das Wetter bleibt **schön**',
    ),
    CourseItem(
      prompt: 'The shoes are expensive. (teuer)',
      answer: 'Die Schuhe sind **teuer**',
    ),
    CourseItem(
      prompt: 'The garden is big. (groß)',
      answer: 'Der Garten ist **groß**',
    ),
    CourseItem(
      prompt: 'The music is loud. (laut)',
      answer: 'Die Musik ist **laut**',
    ),
    CourseItem(
      prompt: 'The bread stays fresh. (frisch)',
      answer: 'Das Brot bleibt **frisch**',
    ),
    CourseItem(
      prompt: 'The night is dark. (dunkel)',
      answer: 'Die Nacht ist **dunkel**',
    ),
    CourseItem(
      prompt: 'The exercise is easy. (leicht)',
      answer: 'Die Übung ist **leicht**',
    ),
    CourseItem(
      prompt: 'The dog is hungry. (hungrig)',
      answer: 'Der Hund ist **hungrig**',
    ),
  ],
);

final QuizContent enDeM7DerNom = enDeFill(
  id: 'en_de_m7_der_nom',
  title: 'After der/die/das (nominative)',
  intro:
      'After the definite article in the nominative, the adjective is weak: '
      'just add -e (and -en in the plural).',
  tips: _adjTips,
  items: const [
    CourseItem(prompt: 'the old man (Nom)', answer: 'der **alte** Mann'),
    CourseItem(prompt: 'the new lamp (Nom)', answer: 'die **neue** Lampe'),
    CourseItem(prompt: 'the small child (Nom)', answer: 'das **kleine** Kind'),
    CourseItem(prompt: 'the young woman (Nom)', answer: 'die **junge** Frau'),
    CourseItem(prompt: 'the big house (Nom)', answer: 'das **große** Haus'),
    CourseItem(
      prompt: 'the nice people (Nom, pl)',
      answer: 'die **netten** Leute',
    ),
    CourseItem(
      prompt: 'the strong coffee (Nom)',
      answer: 'der **starke** Kaffee',
    ),
    CourseItem(prompt: 'the fresh bread (Nom)', answer: 'das **frische** Brot'),
    CourseItem(
      prompt: 'the beautiful city (Nom)',
      answer: 'die **schöne** Stadt',
    ),
    CourseItem(prompt: 'the red car (Nom)', answer: 'das **rote** Auto'),
    CourseItem(prompt: 'the long street (Nom)', answer: 'die **lange** Straße'),
    CourseItem(prompt: 'the fast train (Nom)', answer: 'der **schnelle** Zug'),
    CourseItem(
      prompt: 'the old books (Nom, pl)',
      answer: 'die **alten** Bücher',
    ),
    CourseItem(prompt: 'the warm soup (Nom)', answer: 'die **warme** Suppe'),
    CourseItem(
      prompt: 'the green garden (Nom)',
      answer: 'der **grüne** Garten',
    ),
  ],
);

// 7.2a — warm-up big text (after the der-nominative quiz): type the weak -e
// ending after der/die/das in the nominative.
final QuizContent enDeM7BigTextWarmup = enDeBigText(
  id: 'en_de_m7_bigtext_warmup',
  title: 'Big text (warm-up): Mein Lieblingscafé',
  passageTitle: 'Mein Lieblingscafé',
  template:
      'Das ist mein Lieblingscafé an der Ecke. Der {{0}} Kaffee hier ist der '
      'beste der ganzen Stadt, und die {{1}} Schokolade schmeckt wie im Himmel. '
      'Auf dem Tresen liegt das {{2}} Brot vom Bäcker nebenan, noch ganz warm. '
      'Die {{3}} Kellnerin kennt mich schon und lächelt immer freundlich. In der '
      'Ecke spielt der {{4}} Musiker leise Gitarre, und das {{5}} Fenster zeigt '
      'den ganzen Markt. Einfach perfekt!',
  blanks: [
    inputBlank('starke', hint: 'stark (der … Kaffee)'),
    inputBlank('heiße', accepted: ['heisse'], hint: 'heiß (die … Schokolade)'),
    inputBlank('frische', hint: 'frisch (das … Brot)'),
    inputBlank('nette', hint: 'nett (die … Kellnerin)'),
    inputBlank('junge', hint: 'jung (der … Musiker)'),
    inputBlank('große', accepted: ['grosse'], hint: 'groß (das … Fenster)'),
  ],
  passageTranslation:
      'This is my favourite café on the corner. The strong coffee here is the '
      'best in the whole city, and the hot chocolate tastes like heaven. On the '
      'counter lies the fresh bread from the baker next door, still warm. The '
      'nice waitress already knows me and always smiles warmly. In the corner '
      'the young musician plays the guitar quietly, and the big window shows the '
      'whole market. Simply perfect!',
  intro:
      'Type the adjective with its weak ending. After der/die/das in the '
      'nominative it is almost always just -e: der starke Kaffee, die heiße '
      'Schokolade, das frische Brot.',
  tips: _adjTips,
);

final QuizContent enDeM7DerAkk = enDeFill(
  id: 'en_de_m7_der_akk',
  title: 'After der/die/das (accusative)',
  intro:
      'In the accusative only the masculine changes — and that is exactly '
      'where the adjective ending becomes -en: den alten Mann.',
  tips: _adjTips,
  items: const [
    CourseItem(
      prompt: 'I see the old man. (Akk)',
      answer: 'Ich sehe den **alten** Mann',
    ),
    CourseItem(
      prompt: 'I buy the new lamp. (Akk)',
      answer: 'Ich kaufe die **neue** Lampe',
    ),
    CourseItem(
      prompt: 'I read the small book. (Akk)',
      answer: 'Ich lese das **kleine** Buch',
    ),
    CourseItem(
      prompt: 'I eat the fresh bread. (Akk)',
      answer: 'Ich esse das **frische** Brot',
    ),
    CourseItem(
      prompt: 'I know the nice people. (Akk, pl)',
      answer: 'Ich kenne die **netten** Leute',
    ),
    CourseItem(
      prompt: 'I drink the strong coffee. (Akk)',
      answer: 'Ich trinke den **starken** Kaffee',
    ),
    CourseItem(
      prompt: 'I take the fast train. (Akk)',
      answer: 'Ich nehme den **schnellen** Zug',
    ),
    CourseItem(
      prompt: 'I visit the beautiful city. (Akk)',
      answer: 'Ich besuche die **schöne** Stadt',
    ),
    CourseItem(
      prompt: 'I wear the warm jacket. (Akk)',
      answer: 'Ich trage die **warme** Jacke',
    ),
    CourseItem(
      prompt: 'I open the big window. (Akk)',
      answer: 'Ich öffne das **große** Fenster',
    ),
    CourseItem(
      prompt: 'I love the green garden. (Akk)',
      answer: 'Ich liebe den **grünen** Garten',
    ),
    CourseItem(
      prompt: 'I hear the loud music. (Akk)',
      answer: 'Ich höre die **laute** Musik',
    ),
    CourseItem(
      prompt: 'I feed the hungry dog. (Akk)',
      answer: 'Ich füttere den **hungrigen** Hund',
    ),
    CourseItem(
      prompt: 'I buy the old books. (Akk, pl)',
      answer: 'Ich kaufe die **alten** Bücher',
    ),
    CourseItem(
      prompt: 'I eat the hot soup. (Akk)',
      answer: 'Ich esse die **heiße** Suppe',
    ),
  ],
);

final QuizContent enDeM7EinNom = enDeFill(
  id: 'en_de_m7_ein_nom',
  title: 'After ein/mein (nominative)',
  intro:
      'After ein-words the adjective has to show the gender, because "ein" '
      "doesn't: -er (m), -e (f), -es (n).",
  tips: _adjTips,
  items: const [
    CourseItem(prompt: 'an old man (Nom)', answer: 'ein **alter** Mann'),
    CourseItem(prompt: 'a nice woman (Nom)', answer: 'eine **nette** Frau'),
    CourseItem(prompt: 'a new car (Nom)', answer: 'ein **neues** Auto'),
    CourseItem(prompt: 'my small dog (Nom)', answer: 'mein **kleiner** Hund'),
    CourseItem(prompt: 'my new lamp (Nom)', answer: 'meine **neue** Lampe'),
    CourseItem(prompt: 'my old house (Nom)', answer: 'mein **altes** Haus'),
    CourseItem(
      prompt: 'a strong coffee (Nom)',
      answer: 'ein **starker** Kaffee',
    ),
    CourseItem(
      prompt: 'a beautiful city (Nom)',
      answer: 'eine **schöne** Stadt',
    ),
    CourseItem(prompt: 'a fresh bread (Nom)', answer: 'ein **frisches** Brot'),
    CourseItem(
      prompt: 'my young brother (Nom)',
      answer: 'mein **junger** Bruder',
    ),
    CourseItem(prompt: 'a warm soup (Nom)', answer: 'eine **warme** Suppe'),
    CourseItem(prompt: 'a red car (Nom)', answer: 'ein **rotes** Auto'),
    CourseItem(prompt: 'my big garden (Nom)', answer: 'mein **großer** Garten'),
    CourseItem(prompt: 'a long street (Nom)', answer: 'eine **lange** Straße'),
    CourseItem(
      prompt: 'my new bike (Nom, das Fahrrad)',
      answer: 'mein **neues** Fahrrad',
    ),
  ],
);

// 7.5 — big text with TYPED inputs: produce the whole declined adjective inside
// a description (the infinitive/base is the hint). This is the "decline an
// adjective with an input" use the course is built around.
final QuizContent enDeM7BigText = enDeBigText(
  id: 'en_de_m7_bigtext',
  title: 'Big text: Die neue Wohnung',
  passageTitle: 'Die neue Wohnung',
  template:
      'Endlich, nach einer langen Suche, habe ich eine {{0}} Wohnung gefunden — '
      'und ich bin überglücklich! Das {{1}} Wohnzimmer ist hell und super '
      'gemütlich; morgens scheint die Sonne direkt herein. In der Ecke steht '
      'ein {{2}} Sofa, weich wie eine Wolke, und an der Wand hängt ein {{3}} '
      'Bild von einem alten Hafen. Die {{4}} Küche ist zwar nicht groß, aber '
      'modern und praktisch. Mein {{5}} Schlafzimmer hat ein riesiges Fenster '
      'mit Blick über die ganze Stadt. Nur einen Nachteil gibt es: Der Nachbar '
      'übt jeden Abend Trompete. Trotzdem — ich liebe meine {{6}} Wohnung über '
      'alles!',
  blanks: [
    inputBlank('neue', hint: 'neu (eine … Wohnung)'),
    inputBlank('große', accepted: ['grosse'], hint: 'groß (das … Wohnzimmer)'),
    inputBlank('neues', hint: 'neu (ein … Sofa)'),
    inputBlank('schönes', accepted: ['schoenes'], hint: 'schön (ein … Bild)'),
    inputBlank('kleine', hint: 'klein (die … Küche)'),
    inputBlank(
      'gemütliches',
      accepted: ['gemuetliches'],
      hint: 'gemütlich (mein … Schlafzimmer)',
    ),
    inputBlank('neue', hint: 'neu (meine … Wohnung)'),
  ],
  passageTranslation:
      "Finally, after a long search, I've found a new apartment — and I'm "
      'overjoyed! The living room is bright and super cosy; in the morning the '
      'sun shines straight in. In the corner there is a new sofa, soft as a '
      'cloud, and on the wall hangs a beautiful picture of an old harbour. The '
      "kitchen isn't big, but it's modern and practical. My bedroom has a huge "
      'window with a view over the whole city. There is only one drawback: the '
      'neighbour practises the trumpet every evening. Even so — I love my new '
      'apartment more than anything!',
  intro:
      'Type the full adjective with its ending (the base form is the hint). '
      'Decide der-word vs ein-word and the case: eine neue Wohnung, das große '
      'Wohnzimmer, ein neues Sofa…',
  tips: _adjTips,
);

final QuizContent enDeM7Dictation = enDeDict(
  id: 'en_de_m7_dictation',
  title: 'Dictation: hear the endings',
  intro:
      'Listen and write the phrase. The adjective ending (-e / -en / -er / '
      '-es) is unstressed and easy to miss — catch it.',
  tips: _adjTips,
  items: const [
    CourseItem(prompt: 'the old man', answer: 'der alte Mann'),
    CourseItem(
      prompt: 'I see the old man.',
      answer: 'Ich sehe den alten Mann.',
    ),
    CourseItem(prompt: 'a new car', answer: 'ein neues Auto'),
    CourseItem(prompt: 'the small child', answer: 'das kleine Kind'),
    CourseItem(prompt: 'my big house', answer: 'mein großes Haus'),
    CourseItem(prompt: 'the strong coffee', answer: 'der starke Kaffee'),
    CourseItem(
      prompt: 'I drink the strong coffee.',
      answer: 'Ich trinke den starken Kaffee.',
    ),
    CourseItem(prompt: 'a nice woman', answer: 'eine nette Frau'),
    CourseItem(prompt: 'the fresh bread', answer: 'das frische Brot'),
    CourseItem(
      prompt: 'I take the fast train.',
      answer: 'Ich nehme den schnellen Zug.',
    ),
    CourseItem(prompt: 'my small dog', answer: 'mein kleiner Hund'),
    CourseItem(prompt: 'the young woman', answer: 'die junge Frau'),
    CourseItem(
      prompt: 'I love my new apartment.',
      answer: 'Ich liebe meine neue Wohnung.',
    ),
    CourseItem(prompt: 'a beautiful picture', answer: 'ein schönes Bild'),
    CourseItem(prompt: 'the nice people', answer: 'die netten Leute'),
  ],
);

final QuizContent enDeM7Speak = enDeSpeak(
  id: 'en_de_m7_speak',
  title: 'Speak: der nette / ein netter',
  intro:
      'Say the der/ein pairs aloud. Hearing them side by side fixes the '
      'difference between weak (-e) and mixed (-er/-es) endings.',
  tips: _adjTips,
  items: const [
    CourseItem(prompt: 'the nice man', answer: 'der nette Mann'),
    CourseItem(prompt: 'a nice man', answer: 'ein netter Mann'),
    CourseItem(prompt: 'the new lamp', answer: 'die neue Lampe'),
    CourseItem(prompt: 'a new lamp', answer: 'eine neue Lampe'),
    CourseItem(prompt: 'the small child', answer: 'das kleine Kind'),
    CourseItem(prompt: 'a small child', answer: 'ein kleines Kind'),
  ],
);

/// M7 — Adjective Endings (intro), in module order.

/// Speaking: run this conversation in your own AI assistant and bring the
/// score back (see `SpeakingQuizPage`).
final QuizContent enDeM7Speaking = enDeSpeaking(
  id: 'en_de_m7_speaking',
  title: 'Describe things around you',
  level: 'A2',
  topic:
      'The things and people around me: my room, my city, my friends, and what they are like.',
  practisePoints: [
    'No ending after sein: Das Haus ist alt.',
    'Weak endings after der/die/das: der alte Mann, die neue Wohnung',
    'Mixed endings after ein/eine: ein alter Mann, eine neue Wohnung',
  ],
  targetVocabulary: ['alt', 'neu', 'groß', 'klein', 'schön', 'teuer'],
  scoringCriteria: [
    'no ending after sein',
    'the ending after a der-word',
    'the ending after an ein-word',
  ],
  priorityErrors: [
    'an ending after sein',
    'wrong weak ending',
    'wrong mixed ending',
  ],
  intro:
      'Describe your world out loud. Copy the exercise into your AI assistant, turn on voice mode, and let the adjectives do the work.',
  tips: _adjTips,
);

/// Mid-module speaking checkpoint: a shorter, question-driven run over
/// what the module has taught up to this point, before the second half
/// adds the rest. The closing exercise covers the module as a whole.
final QuizContent enDeM7SpeakingCheck = enDeSpeaking(
  id: 'en_de_m7_speaking_check',
  title: 'Checkpoint: is it big or is it a big one?',
  level: 'A2',
  topic:
      'Short descriptions of things near me, first after sein, then in front of the noun.',
  practisePoints: [
    'No ending after sein: Das Auto ist neu.',
    'Weak endings after der/die/das in the nominative',
    'Weak endings in the accusative: Ich sehe den alten Mann.',
  ],
  targetVocabulary: ['alt', 'neu', 'groß', 'der alte', 'den alten'],
  scoringCriteria: [
    'no ending after sein',
    'the weak ending in the nominative',
    'the weak ending in the accusative',
  ],
  priorityErrors: ['an ending after sein', 'wrong weak ending'],
  mode: SpeakingMode.interview,
  session: SpeakingSession(durationMinutes: 3, minExchanges: 6),
  report: SpeakingReport(maxWords: 150, maxCorrections: 3),
  intro:
      'A short checkpoint on what this module has covered so far. Copy it into your AI assistant, turn on voice mode, and answer its questions - three minutes is enough.',
  tips: _adjTips,
);

final List<QuizContent> enDeM7 = [
  enDeM7Predicate,
  enDeM7DerNom,
  enDeM7BigTextWarmup,
  enDeM7DerAkk,
  enDeM7SpeakingCheck,
  enDeM7EinNom,
  enDeM7Dictation,
  enDeM7Speak,
  enDeM7BigText,
  enDeM7Speaking,
];
