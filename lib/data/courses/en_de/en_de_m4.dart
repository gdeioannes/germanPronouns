import '../../../models/quiz_content.dart';
import 'en_de_builder.dart';

/// M4 — The Dative (A2). The dative is the indirect object — the receiver (ask
/// Wem?). Articles: dem (m), der (f), dem (n), den + -n on the plural noun.
/// Theme: Oma, who gives presents to everyone (recipients = dative).

const List<HelpMemoryTip> _dativeTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'The dative articles (Wem?)',
    text: 'm: **dem** · f: **der** · n: **dem** · pl: **den** + an **-n** on the '
        'noun (den Kinder**n**). Ask Wem? — to/for whom.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'der → dem, die → der',
    text: 'Masculine/neuter become **dem**; feminine becomes **der** — the same '
        'little "der" you knew, now doing a new job.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'Dative pronouns',
    text: 'ich → **mir**, du → **dir**, er → **ihm**, sie → **ihr**, es → '
        '**ihm**, wir → **uns**, ihr → **euch**, sie → **ihnen**, Sie → '
        '**Ihnen**.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Dative prepositions (always!)',
    text: '**aus, bei, mit, nach, seit, von, zu** — always dative. Contractions: '
        'von+dem = **vom**, zu+dem = **zum**, zu+der = **zur**, bei+dem = '
        '**beim**.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'Dative verbs — no "to" in English',
    text: '**helfen, danken, gehören, gefallen, antworten, passen, schmecken** '
        'take a dative object: Ich helfe **dem** Mann. Das gehört **der** Frau.',
  ),
];

final QuizContent enDeM4Articles = enDeFill(
  id: 'en_de_m4_articles',
  title: 'Dative articles',
  intro: 'When something is given/done to a receiver, that receiver is dative: '
      'der → dem, die → der, das → dem, plural die → den (+ -n on the noun).',
  tips: _dativeTips,
  items: const [
    CourseItem(prompt: 'Oma gives the man a book. (der Mann)', answer: 'Oma gibt **dem** Mann ein Buch'),
    CourseItem(prompt: 'Oma gives the woman flowers. (die Frau)', answer: 'Oma gibt **der** Frau Blumen'),
    CourseItem(prompt: 'Oma gives the child sweets. (das Kind)', answer: 'Oma gibt **dem** Kind Süßigkeiten'),
    CourseItem(prompt: 'Oma gives the children chocolate. (die Kinder, pl)', answer: 'Oma gibt **den** Kindern Schokolade'),
    CourseItem(prompt: 'I help the teacher. (der Lehrer)', answer: 'Ich helfe **dem** Lehrer'),
    CourseItem(prompt: 'We give the dog food. (der Hund)', answer: 'Wir geben **dem** Hund Futter'),
    CourseItem(prompt: 'The book belongs to the woman. (die Frau)', answer: 'Das Buch gehört **der** Frau'),
    CourseItem(prompt: 'She answers the child. (das Kind)', answer: 'Sie antwortet **dem** Kind'),
  ],
);

// 4.1a — warm-up big text (after the dative-article quiz): type the dative
// article for each receiver. der→dem, die→der, das→dem, plural die→den.
final QuizContent enDeM4BigTextWarmup = enDeBigText(
  id: 'en_de_m4_bigtext_warmup',
  title: 'Big text (warm-up): Oma verteilt Geschenke',
  passageTitle: 'Oma verteilt Geschenke',
  template:
      'Heute hat Oma Geburtstag, aber sie macht ALLEN Geschenke — typisch Oma! '
      'Sie gibt {{0}} Opa eine warme Mütze, schenkt {{1}} Tante ein dickes Buch '
      'und gibt {{2}} Kind eine riesige Tafel Schokolade. Sogar {{3}} Hund '
      'bringt sie etwas: einen großen Knochen! Auch {{4}} netten Nachbarn von '
      'oben gibt sie ein Glas Marmelade. Und {{5}} Kindern aus der Nachbarschaft '
      'schenkt sie noch eine ganze Tüte Bonbons. Am Ende lacht Opa: „Oma, das '
      'Fest ist für dich — nicht von dir!"',
  blanks: [
    inputBlank('dem', hint: 'der Opa → Dativ'),
    inputBlank('der', hint: 'die Tante → Dativ'),
    inputBlank('dem', hint: 'das Kind → Dativ'),
    inputBlank('dem', hint: 'der Hund → Dativ'),
    inputBlank('dem', hint: 'der Nachbar → Dativ'),
    inputBlank('den', hint: 'die Kinder (pl) → Dativ'),
  ],
  passageTranslation:
      "Today it's Oma's birthday, but she gives presents to EVERYONE — typical "
      'Oma! She gives Grandpa a warm hat, gives Aunt a thick book, and gives the '
      'child a huge bar of chocolate. She even brings the dog something: a big '
      'bone! She also gives the nice neighbour from upstairs a jar of jam. And '
      'to the children from the neighbourhood she gives a whole bag of sweets. '
      "In the end Grandpa laughs: \"Oma, the party is for you — not from you!\"",
  intro: 'Type the dative article for each receiver (Wem? — to/for whom): der → '
      'dem, die → der, das → dem, and plural die → den (the noun also adds -n: '
      'den Kindern).',
  tips: _dativeTips,
);

final QuizContent enDeM4Pronouns = enDeFill(
  id: 'en_de_m4_pronouns',
  title: 'Dative pronouns',
  intro: 'The dative pronouns: mir, dir, ihm, ihr, uns, euch, ihnen, Ihnen. '
      'These are the everyday "to me / to you" forms.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'The set',
      text: 'ich→mir, du→dir, er→ihm, sie→ihr, es→ihm, wir→uns, ihr→euch, '
          'sie→ihnen, Sie→Ihnen.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Everyday phrases',
      text: 'Das gefällt mir. Kannst du mir helfen? Es gehört ihr.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Oma gives me a present. (ich)', answer: 'Oma gibt **mir** ein Geschenk'),
    CourseItem(prompt: 'I give you a book. (du)', answer: 'Ich gebe **dir** ein Buch'),
    CourseItem(prompt: 'She gives him money. (er)', answer: 'Sie gibt **ihm** Geld'),
    CourseItem(prompt: 'He gives her flowers. (sie)', answer: 'Er gibt **ihr** Blumen'),
    CourseItem(prompt: 'We give them sweets. (sie, pl)', answer: 'Wir geben **ihnen** Süßigkeiten'),
    CourseItem(prompt: 'That pleases me. (gefallen)', answer: 'Das gefällt **mir**'),
    CourseItem(prompt: 'Can I help you? (Sie)', answer: 'Kann ich **Ihnen** helfen?'),
    CourseItem(prompt: 'The jacket suits you. (du)', answer: 'Die Jacke passt **dir**'),
  ],
);

final QuizContent enDeM4Verbs = enDeFill(
  id: 'en_de_m4_verbs',
  title: 'Dative verbs',
  intro: 'Some verbs simply take a dative object — there is no logical "to" in '
      'English. Learn them as a list: helfen, danken, gehören, gefallen, '
      'antworten, schmecken, passen.',
  tips: _dativeTips,
  items: const [
    CourseItem(prompt: 'I help the man. (der Mann)', answer: 'Ich helfe **dem** Mann'),
    CourseItem(prompt: 'The book belongs to the woman. (die Frau)', answer: 'Das Buch gehört **der** Frau'),
    CourseItem(prompt: 'The film pleases the children. (die Kinder)', answer: 'Der Film gefällt **den** Kindern'),
    CourseItem(prompt: 'I thank the man. (der Mann)', answer: 'Ich danke **dem** Mann'),
    CourseItem(prompt: 'The pizza tastes good to me. (ich)', answer: 'Die Pizza schmeckt **mir**'),
    CourseItem(prompt: 'She answers the teacher. (der Lehrer)', answer: 'Sie antwortet **dem** Lehrer'),
    CourseItem(prompt: 'The dress suits her. (sie)', answer: 'Das Kleid passt **ihr**'),
  ],
);

final QuizContent enDeM4Prepositions = enDeFill(
  id: 'en_de_m4_prepositions',
  title: 'Dative prepositions',
  intro: 'These prepositions always force the dative: aus, bei, mit, nach, '
      'seit, von, zu. The preposition decides the case, so you never have to '
      'work it out.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Learn them as a chant',
      text: 'aus, bei, mit, nach, seit, von, zu — always + dative.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Contractions',
      text: 'von dem → vom, zu dem → zum, zu der → zur, bei dem → beim. You will '
          'meet these everywhere.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I come from the city. (aus, die Stadt)', answer: 'Ich komme aus **der** Stadt'),
    CourseItem(prompt: 'She lives with grandma. (bei, die Oma)', answer: 'Sie wohnt bei **der** Oma'),
    CourseItem(prompt: 'I travel by train. (mit, der Zug)', answer: 'Ich fahre mit **dem** Zug'),
    CourseItem(prompt: 'I get a present from grandma. (von, die Oma)', answer: 'Ich bekomme ein Geschenk von **der** Oma'),
    CourseItem(prompt: 'After the meal I sleep. (nach, das Essen)', answer: 'Nach **dem** Essen schlafe ich'),
    CourseItem(prompt: 'For a year I have been here. (seit, ein Jahr)', answer: 'Seit **einem** Jahr bin ich hier'),
  ],
);

// 4.5 — big text with case selects (~60% of the case phrases marked): Oma's
// party. Recipients are dative; mix in the doers (Nominativ) and a couple of
// direct objects (Akkusativ).
final QuizContent enDeM4BigText = enDeBigText(
  id: 'en_de_m4_bigtext',
  title: 'Big text: Omas Geburtstag',
  passageTitle: 'Omas Geburtstag',
  template:
      'Liebe Oma, was für ein wunderbares Fest! Du gibst wirklich immer allen '
      'etwas. Schon am Eingang drückst du dem Onkel {{0}} ein dickes Buch in '
      'die Hand, der Tante {{1}} schenkst du einen warmen Schal, und den '
      'Kindern {{2}} gibst du so viel Schokolade, dass sie den ganzen Abend '
      'wild herumspringen. Der Onkel {{3}} freut sich wie ein kleines Kind und '
      'liest sofort die erste Seite. In der Küche backst du auch noch den '
      'Kuchen {{4}} ganz allein, und er schmeckt einfach allen am besten. Nach '
      'dem Essen {{5}} setzen wir uns zusammen und spielen bis Mitternacht '
      'Karten. Am Ende umarme ich dich und danke dir {{6}} von ganzem Herzen '
      'für diesen schönen Tag. Bleib gesund und bis ganz bald! Deine Anna',
  blanks: [
    caseBlank('Dativ'), // dem Onkel (receiver)
    caseBlank('Dativ'), // der Tante (receiver)
    caseBlank('Dativ'), // den Kindern (receiver)
    caseBlank('Nominativ'), // Der Onkel (doer)
    caseBlank('Akkusativ'), // den Kuchen (direct object of backen)
    caseBlank('Dativ'), // dem Essen (nach + Dativ)
    caseBlank('Dativ'), // dir (danken + Dativ)
  ],
  passageTranslation:
      'Dear Oma, what a wonderful celebration! You really do always give '
      'everyone something. Right at the door you press a thick book into '
      "Uncle's hand, you give Aunt a warm scarf, and you give the children so "
      'much chocolate that they bounce around wildly all evening. Uncle is as '
      'happy as a little child and immediately reads the first page. In the '
      'kitchen you also bake the cake all by yourself, and it simply tastes the '
      'best to everyone. After the meal we sit down together and play cards '
      'until midnight. At the end I hug you and thank you from the bottom of my '
      'heart for this lovely day. Stay healthy and see you very soon! Your Anna',
  intro: 'Choose the case for each marked phrase. The receivers of Oma\'s gifts '
      'are Dativ (Wem?); the doers are Nominativ (Wer?); what she bakes is '
      'Akkusativ (Was?). Note "nach dem Essen" and "danken dir" are dative too.',
  tips: _dativeTips,
);

final QuizContent enDeM4Speak = enDeSpeak(
  id: 'en_de_m4_speak',
  title: 'Speak: thanks & giving',
  intro: 'Say each line aloud. These dative phrases come up every time you give '
      'something, thank someone, or say you like something.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Liking = dative',
      text: 'German says "it pleases me": Das gefällt mir. Das schmeckt mir.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I thank you.', answer: 'Ich danke dir.'),
    CourseItem(prompt: 'That pleases me. (I like it)', answer: 'Das gefällt mir.'),
    CourseItem(prompt: 'Can I help you?', answer: 'Kann ich dir helfen?'),
    CourseItem(prompt: 'This present is for you.', answer: 'Dieses Geschenk ist für dich.'),
    CourseItem(prompt: 'It belongs to me.', answer: 'Es gehört mir.'),
    CourseItem(prompt: 'Many thanks!', answer: 'Vielen Dank!'),
  ],
);

final QuizContent enDeM4Dictation = enDeDict(
  id: 'en_de_m4_dictation',
  title: 'Dictation: dem / den / der',
  intro: 'Listen and type each sentence. The hard part is by ear: dem vs den vs '
      'der — train it here.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Three look-alikes',
      text: 'dem (m/n dative), der (f dative), den (plural dative, + -n). Listen '
          'closely to the ending.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I give the man the book.', answer: 'Ich gebe dem Mann das Buch.'),
    CourseItem(prompt: 'She helps the woman.', answer: 'Sie hilft der Frau.'),
    CourseItem(prompt: 'We give the children sweets.', answer: 'Wir geben den Kindern Süßigkeiten.'),
    CourseItem(prompt: 'The book belongs to the child.', answer: 'Das Buch gehört dem Kind.'),
    CourseItem(prompt: 'I travel by train.', answer: 'Ich fahre mit dem Zug.'),
  ],
);

/// M4 — The Dative, in module order.
final List<QuizContent> enDeM4 = [
  enDeM4Articles,
  enDeM4BigTextWarmup,
  enDeM4Pronouns,
  enDeM4Verbs,
  enDeM4Prepositions,
  enDeM4Speak,
  enDeM4Dictation,
  enDeM4BigText,
];
