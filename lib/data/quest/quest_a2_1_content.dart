import '../../models/quiz_content.dart';
import 'quest_builders.dart';

/// CEFR **A2.1 — "Erlebnisse"** Quest quizzes (Goethe A2). The "big rocks" are
/// the **Perfekt** (haben/sein) and the **dative case**. Authored as serializable
/// [QuizContent] so they seed into the database and run on the shared engine.

/// 1. Perfekt mit *haben* — the most common past tense in speech.
final QuizContent questA21PerfektHabenContent = sentenceQuestQuiz(
  id: 'quest_a2_1_perfekt_haben',
  title: 'A2.1 · Perfekt mit haben',
  promptLabel: 'Partizip II',
  subjectsLabel: 'Verben',
  subjectColumnLabel: 'Infinitiv',
  categoryLabel: 'Perfekt',
  intro: 'German talks about the past mostly with the **Perfekt**: a form of '
      'haben (or sein) plus the past participle (Partizip II) at the end. Most '
      'verbs take haben.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Regular participle: ge-…-t',
      text: 'machen → gemacht, spielen → gespielt, kaufen → gekauft. The '
          'participle goes to the END: "Ich habe Fußball gespielt."',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Strong verbs change',
      text: 'Many common verbs are irregular: essen → gegessen, trinken → '
          'getrunken, sehen → gesehen, lesen → gelesen. Learn these by heart.',
    ),
  ],
  items: const [
    QuestSentenceItem(
        sentence: 'Ich habe Fußball ____. (spielen)',
        answer: 'gespielt',
        english: 'I played football.',
        gloss: 'spielen'),
    QuestSentenceItem(
        sentence: 'Wir haben Pizza ____. (essen)',
        answer: 'gegessen',
        english: 'We ate pizza.',
        gloss: 'essen'),
    QuestSentenceItem(
        sentence: 'Hast du den Film ____? (sehen)',
        answer: 'gesehen',
        english: 'Did you see the film?',
        gloss: 'sehen'),
    QuestSentenceItem(
        sentence: 'Er hat ein Buch ____. (lesen)',
        answer: 'gelesen',
        english: 'He read a book.',
        gloss: 'lesen'),
    QuestSentenceItem(
        sentence: 'Sie hat Kaffee ____. (trinken)',
        answer: 'getrunken',
        english: 'She drank coffee.',
        gloss: 'trinken'),
    QuestSentenceItem(
        sentence: 'Ich habe das Auto ____. (kaufen)',
        answer: 'gekauft',
        english: 'I bought the car.',
        gloss: 'kaufen'),
    QuestSentenceItem(
        sentence: 'Wir haben viel ____. (arbeiten)',
        answer: 'gearbeitet',
        english: 'We worked a lot.',
        gloss: 'arbeiten'),
    QuestSentenceItem(
        sentence: 'Was hast du gestern ____? (machen)',
        answer: 'gemacht',
        english: 'What did you do yesterday?',
        gloss: 'machen'),
  ],
);

/// 2. Perfekt mit *sein* — movement and change-of-state verbs.
final QuizContent questA21PerfektSeinContent = sentenceQuestQuiz(
  id: 'quest_a2_1_perfekt_sein',
  title: 'A2.1 · Perfekt mit sein',
  promptLabel: 'Partizip II',
  subjectsLabel: 'Verben',
  subjectColumnLabel: 'Infinitiv',
  categoryLabel: 'Perfekt mit sein',
  intro: 'A small but important group of verbs builds the Perfekt with **sein**, '
      'not haben — verbs of movement (from A to B) and change of state.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Movers & changers take sein',
      text: 'gehen, fahren, kommen, fliegen (movement) + werden, aufstehen, '
          'einschlafen (change) + sein, bleiben. Everything else uses haben.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Irregular participles',
      text: 'gehen → gegangen, fahren → gefahren, kommen → gekommen, sein → '
          'gewesen, bleiben → geblieben.',
    ),
  ],
  items: const [
    QuestSentenceItem(
        sentence: 'Ich bin nach Berlin ____. (fahren)',
        answer: 'gefahren',
        english: 'I went/drove to Berlin.',
        gloss: 'fahren'),
    QuestSentenceItem(
        sentence: 'Wir sind ins Kino ____. (gehen)',
        answer: 'gegangen',
        english: 'We went to the cinema.',
        gloss: 'gehen'),
    QuestSentenceItem(
        sentence: 'Er ist um sieben Uhr ____. (aufstehen)',
        answer: 'aufgestanden',
        english: 'He got up at seven.',
        gloss: 'aufstehen'),
    QuestSentenceItem(
        sentence: 'Wann bist du nach Hause ____? (kommen)',
        answer: 'gekommen',
        english: 'When did you come home?',
        gloss: 'kommen'),
    QuestSentenceItem(
        sentence: 'Sie ist Ärztin ____. (werden)',
        answer: 'geworden',
        english: 'She became a doctor.',
        gloss: 'werden'),
    QuestSentenceItem(
        sentence: 'Ich bin zu Hause ____. (bleiben)',
        answer: 'geblieben',
        english: 'I stayed at home.',
        gloss: 'bleiben'),
    QuestSentenceItem(
        sentence: 'Das Baby ist schnell ____. (einschlafen)',
        answer: 'eingeschlafen',
        english: 'The baby fell asleep quickly.',
        gloss: 'einschlafen'),
  ],
);

/// 3. Sprechen: Mein Wochenende.
final QuizContent questA21SprechenWochenendeContent = speakQuestQuiz(
  id: 'quest_a2_1_sprechen_wochenende',
  title: 'A2.1 · Sprechen: Mein Wochenende',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro: 'Talk about your weekend in the Perfekt. Listen and repeat each '
      'sentence, then try to say your own.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Two-part frame',
      text: 'haben/sein in position 2, participle at the very end: "Ich __habe__ '
          'meine Freunde __getroffen__."',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Time words',
      text: '"am Samstag", "gestern", "am Wochenende" set the scene before the '
          'verb.',
    ),
  ],
  phrases: const [
    SpeakPhrase(phrase: 'Am Wochenende', meaning: 'On the weekend'),
    SpeakPhrase(
        phrase: 'Ich habe lange geschlafen.', meaning: 'I slept in.'),
    SpeakPhrase(
        phrase: 'Ich bin spazieren gegangen.', meaning: 'I went for a walk.'),
    SpeakPhrase(
        phrase: 'Ich habe Freunde getroffen.',
        meaning: 'I met friends.'),
    SpeakPhrase(
        phrase: 'Wir sind ins Restaurant gegangen.',
        meaning: 'We went to a restaurant.'),
    SpeakPhrase(
        phrase: 'Am Sonntag bin ich zu Hause geblieben.',
        meaning: 'On Sunday I stayed at home.'),
    SpeakPhrase(
        phrase: 'Wie war dein Wochenende?',
        meaning: 'How was your weekend?'),
  ],
);

/// Compact [QuestSentenceItem] helper for the longer item lists below.
QuestSentenceItem _di(String s, String a, String e, String g) =>
    QuestSentenceItem(sentence: s, answer: a, english: e, gloss: g);

/// 4. Dativ: bestimmte Artikel — der→dem, die→der, das→dem, plural→den (+n).
final QuizContent questA21DativArtikelContent = sentenceQuestQuiz(
  id: 'quest_a2_1_dativ_artikel',
  title: 'A2.1 · Dativ: bestimmte Artikel',
  promptLabel: 'Artikel',
  subjectsLabel: 'Nomen',
  subjectColumnLabel: 'Nomen',
  categoryLabel: 'Dativ',
  intro: 'The **dative** marks the indirect object (the receiver) and follows '
      'many prepositions. The articles change: der→dem, die→der, das→dem, and '
      'the plural→den (and the noun adds -n).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'der/die/das → dem/der/dem',
      text: 'Masculine & neuter become **dem**, feminine becomes **der**, plural '
          'becomes **den** + an -n on the noun (mit den Kindern).',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Ask "wem?"',
      text: 'The dative answers **wem?** (to whom?). "Ich gebe __dem__ Mann das '
          'Buch" — wem? dem Mann.',
    ),
  ],
  items: [
    _di('Ich gebe ____ Mann das Buch. (der)', 'dem',
        'I give the book to the man.', 'der Mann → Dativ'),
    _di('Ich helfe ____ Frau. (die)', 'der', 'I help the woman.',
        'die Frau → Dativ'),
    _di('Wir danken ____ Kind. (das)', 'dem', 'We thank the child.',
        'das Kind → Dativ'),
    _di('Sie spielt mit ____ Kindern. (die, Plural)', 'den',
        'She plays with the children.', 'die Kinder → Dativ'),
    _di('Das Auto gehört ____ Lehrer. (der)', 'dem',
        'The car belongs to the teacher.', 'der Lehrer → Dativ'),
    _di('Ich gebe ____ Katze Milch. (die)', 'der', 'I give the cat milk.',
        'die Katze → Dativ'),
  ],
);

/// 5. Dativpräpositionen — aus, bei, mit, nach, seit, von, zu (+ gegenüber).
final QuizContent questA21DativPraepContent = sentenceQuestQuiz(
  id: 'quest_a2_1_dativ_praep',
  title: 'A2.1 · Dativpräpositionen',
  promptLabel: 'Präposition',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'Dativpräposition',
  intro: 'A fixed group of prepositions **always** takes the dative — there are '
      'no exceptions, so the article is always dem/der/den.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'The dative song',
      text: '**aus, bei, mit, nach, seit, von, zu** (+ gegenüber). Chant them '
          'until they stick — they are always dative.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Common contractions',
      text: 'bei + dem = beim, von + dem = vom, zu + dem = zum, zu + der = zur.',
    ),
  ],
  items: const [
    QuestSentenceItem(
        sentence: 'Ich komme ____ der Schweiz. (origin)',
        answer: 'aus',
        english: 'I come from Switzerland.',
        gloss: 'aus (from)'),
    QuestSentenceItem(
        sentence: 'Ich wohne ____ meinen Eltern. (at the home of)',
        answer: 'bei',
        english: 'I live with my parents.',
        gloss: 'bei (at/with)'),
    QuestSentenceItem(
        sentence: 'Ich fahre ____ dem Bus. (by)',
        answer: 'mit',
        english: 'I go by bus.',
        gloss: 'mit (with/by)'),
    QuestSentenceItem(
        sentence: '____ der Arbeit gehe ich nach Hause. (after)',
        answer: 'nach',
        english: 'After work I go home.',
        gloss: 'nach (after/to)'),
    QuestSentenceItem(
        sentence: 'Ich lerne Deutsch ____ einem Jahr. (since)',
        answer: 'seit',
        english: "I've been learning German for a year.",
        gloss: 'seit (since/for)'),
    QuestSentenceItem(
        sentence: 'Das ist ein Geschenk ____ meiner Mutter. (from)',
        answer: 'von',
        english: 'This is a gift from my mother.',
        gloss: 'von (from/of)'),
    QuestSentenceItem(
        sentence: 'Ich gehe ____ Arzt. (zu + dem = zum)',
        answer: 'zum',
        english: 'I go to the doctor.',
        gloss: 'zu (to)'),
  ],
);

/// 6. Hören: Eine Reise erzählen.
final QuizContent questA21HoerenReiseContent = listeningQuestQuiz(
  id: 'quest_a2_1_hoeren_reise',
  title: 'A2.1 · Hören: Eine Reise',
  category: 'Travel',
  passageTitle: 'Sofias Reise',
  passage:
      'Letzten Sommer bin ich mit dem Zug nach Italien gefahren. Die Reise hat '
      'acht Stunden gedauert. In Rom habe ich bei einer Freundin gewohnt. Wir '
      'haben viele Museen besucht und jeden Abend Pizza gegessen. Das Wetter war '
      'sehr heiß. Nach einer Woche bin ich wieder nach Hause gekommen.',
  passageTranslation:
      'Last summer I travelled to Italy by train. The journey took eight hours. '
      'In Rome I stayed with a friend. We visited many museums and ate pizza '
      'every evening. The weather was very hot. After a week I came back home.',
  questions: const [
    ReadingQuestion(
      question: 'Wie ist Sofia nach Italien gereist?',
      questionTranslation: 'How did Sofia travel to Italy?',
      options: ['mit dem Auto', 'mit dem Zug', 'mit dem Flugzeug'],
      optionsTranslation: ['by car', 'by train', 'by plane'],
      correctIndex: 1,
      explanation: '"… mit dem Zug nach Italien gefahren."',
    ),
    ReadingQuestion(
      question: 'Wo hat sie in Rom gewohnt?',
      questionTranslation: 'Where did she stay in Rome?',
      options: ['im Hotel', 'bei einer Freundin', 'auf einem Campingplatz'],
      optionsTranslation: ['in a hotel', 'with a friend', 'at a campsite'],
      correctIndex: 1,
      explanation: '"… habe ich bei einer Freundin gewohnt."',
    ),
    ReadingQuestion(
      question: 'Wie war das Wetter?',
      questionTranslation: 'What was the weather like?',
      options: ['kalt', 'sehr heiß', 'regnerisch'],
      optionsTranslation: ['cold', 'very hot', 'rainy'],
      correctIndex: 1,
      explanation: '"Das Wetter war sehr heiß."',
    ),
    ReadingQuestion(
      question: 'Wie lange hat die Reise gedauert?',
      questionTranslation: 'How long did the journey take?',
      options: ['zwei Stunden', 'acht Stunden', 'einen Tag'],
      optionsTranslation: ['two hours', 'eight hours', 'a day'],
      correctIndex: 1,
      explanation: '"Die Reise hat acht Stunden gedauert."',
    ),
    ReadingQuestion(
      question: 'Was haben sie jeden Abend gegessen?',
      questionTranslation: 'What did they eat every evening?',
      options: ['Pasta', 'Pizza', 'Salat'],
      optionsTranslation: ['pasta', 'pizza', 'salad'],
      correctIndex: 1,
      explanation: '"… jeden Abend Pizza gegessen."',
    ),
  ],
  intro: 'Listen to the travel story — it is read aloud, not shown. Listen for '
      'the means of transport, where she stayed and the weather. Replay as '
      'needed; the script is behind "Show text".',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Listen for the Perfekt',
      text: 'Past actions come as "bin … gefahren", "habe … gewohnt". The '
          'participle at the end tells you what happened.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Catch the place words',
      text: 'nach Italien, in Rom, nach Hause — these locate the story.',
    ),
  ],
);

/// 7. Personalpronomen im Dativ — mir, dir, ihm, ihr, uns, euch, ihnen, Ihnen.
final QuizContent questA21PronomenDativContent = sentenceQuestQuiz(
  id: 'quest_a2_1_pronomen_dativ',
  title: 'A2.1 · Personalpronomen im Dativ',
  promptLabel: 'Pronomen',
  subjectsLabel: 'Pronomen',
  subjectColumnLabel: 'English',
  categoryLabel: 'Dativ',
  contextualLayout: true,
  intro: 'When a pronoun is the receiver (the indirect object), it takes its '
      'dative form. These come up constantly with verbs like helfen, danken, '
      'gefallen and geben.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'The dative pronouns',
      text: 'ich→mir, du→dir, er→ihm, sie→ihr, es→ihm, wir→uns, ihr→euch, '
          'sie→ihnen, Sie→Ihnen.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'gefallen takes dative',
      text: '"Das Buch gefällt __mir__" = I like the book (lit. it pleases to '
          'me). The liker is in the dative.',
    ),
  ],
  items: const [
    QuestSentenceItem(
        sentence: 'Kannst du ____ helfen? (me)',
        answer: 'mir',
        english: 'Can you help me?',
        gloss: 'me'),
    QuestSentenceItem(
        sentence: 'Ich gebe ____ das Buch. (you, informal)',
        answer: 'dir',
        english: 'I give you the book.',
        gloss: 'you (informal)'),
    QuestSentenceItem(
        sentence: 'Das Auto gehört ____. (him)',
        answer: 'ihm',
        english: 'The car belongs to him.',
        gloss: 'him'),
    QuestSentenceItem(
        sentence: 'Wie geht es ____? (her)',
        answer: 'ihr',
        english: 'How is she?',
        gloss: 'her'),
    QuestSentenceItem(
        sentence: 'Können Sie ____ den Weg zeigen? (us)',
        answer: 'uns',
        english: 'Can you show us the way?',
        gloss: 'us'),
    QuestSentenceItem(
        sentence: 'Wie geht es ____, Herr Müller? (you, formal)',
        answer: 'Ihnen',
        english: 'How are you, Mr Müller?',
        gloss: 'you (formal)'),
    QuestSentenceItem(
        sentence: 'Ich danke ____ für die Hilfe. (you, plural)',
        answer: 'euch',
        english: 'I thank you (all) for the help.',
        gloss: 'you (plural)'),
    QuestSentenceItem(
        sentence: 'Das Geschenk gefällt ____. (them)',
        answer: 'ihnen',
        english: 'They like the present.',
        gloss: 'them'),
    QuestSentenceItem(
        sentence: 'Das Kind weint — gib ____ den Ball! (it)',
        answer: 'ihm',
        english: 'The child is crying — give it the ball!',
        gloss: 'it'),
  ],
);

/// 8. Lesen: Ein Wochenende in Hamburg.
final QuizContent questA21LesenHamburgContent = readingQuestQuiz(
  id: 'quest_a2_1_lesen_hamburg',
  title: 'A2.1 · Lesen: Ein Wochenende in Hamburg',
  category: 'Travel',
  passageTitle: 'Ein Wochenende in Hamburg',
  passage:
      'Am Freitag ist Familie Klein nach Hamburg gefahren. Sie sind mit dem Auto '
      'gefahren und haben drei Stunden gebraucht. Am Samstag haben sie eine '
      'Hafenrundfahrt gemacht und sind auf einen Markt gegangen. Die Kinder '
      'haben Fisch gegessen, aber die Mutter mag keinen Fisch. Am Sonntag hat es '
      'geregnet, deshalb sind sie ins Museum gegangen. Am Abend sind sie müde, '
      'aber glücklich nach Hause gekommen.',
  passageTranslation:
      'On Friday the Klein family went to Hamburg. They went by car and needed '
      'three hours. On Saturday they did a harbour boat tour and went to a '
      'market. The children ate fish, but the mother does not like fish. On '
      'Sunday it rained, so they went to the museum. In the evening they came '
      'home tired but happy.',
  questions: const [
    ReadingQuestion(
      question: 'Wie ist die Familie nach Hamburg gefahren?',
      questionTranslation: 'How did the family travel to Hamburg?',
      options: ['mit dem Zug', 'mit dem Auto', 'mit dem Bus'],
      optionsTranslation: ['by train', 'by car', 'by bus'],
      correctIndex: 1,
      explanation: '"Sie sind mit dem Auto gefahren …"',
    ),
    ReadingQuestion(
      question: 'Wer mag keinen Fisch?',
      questionTranslation: 'Who does not like fish?',
      options: ['die Kinder', 'die Mutter', 'der Vater'],
      optionsTranslation: ['the children', 'the mother', 'the father'],
      correctIndex: 1,
      explanation: '"… aber die Mutter mag keinen Fisch."',
    ),
    ReadingQuestion(
      question: 'Warum sind sie am Sonntag ins Museum gegangen?',
      questionTranslation: 'Why did they go to the museum on Sunday?',
      options: ['Es war zu heiß.', 'Es hat geregnet.', 'Es war Feiertag.'],
      optionsTranslation: ['It was too hot.', 'It rained.', 'It was a holiday.'],
      correctIndex: 1,
      explanation: '"Am Sonntag hat es geregnet, deshalb …"',
    ),
    ReadingQuestion(
      question: 'Was hat die Familie am Samstag gemacht?',
      questionTranslation: 'What did the family do on Saturday?',
      options: [
        'eine Hafenrundfahrt',
        'einen Zoobesuch',
        'eine Radtour',
      ],
      optionsTranslation: [
        'a harbour boat tour',
        'a zoo visit',
        'a bike tour',
      ],
      correctIndex: 0,
      explanation: '"Am Samstag haben sie eine Hafenrundfahrt gemacht …"',
    ),
    ReadingQuestion(
      question: 'Wie sind sie am Abend nach Hause gekommen?',
      questionTranslation: 'How did they come home in the evening?',
      options: [
        'wütend und nass',
        'müde, aber glücklich',
        'hungrig und traurig',
      ],
      optionsTranslation: [
        'angry and wet',
        'tired but happy',
        'hungry and sad',
      ],
      correctIndex: 1,
      explanation: '"… müde, aber glücklich nach Hause gekommen."',
    ),
  ],
  intro: 'Read the weekend story, then answer. It uses the Perfekt throughout '
      '(sind gefahren, haben gemacht) — the most common past tense.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'deshalb = therefore',
      text: '"Es hat geregnet, __deshalb__ sind sie ins Museum gegangen" shows '
          'cause → result. Watch for it in the "why?" question.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Skim for who/what',
      text: 'Find the names and the verbs of action; you rarely need every word.',
    ),
  ],
);

/// 9. war & hatte (Präteritum) — the past of sein and haben, used even in speech.
final QuizContent questA21WarHatteContent = sentenceQuestQuiz(
  id: 'quest_a2_1_war_hatte',
  title: 'A2.1 · war & hatte (Präteritum)',
  promptLabel: 'Form',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'Präteritum',
  intro: 'sein and haben are normally used in the simple past (Präteritum), even '
      'in everyday speech: **war** (was) and **hatte** (had), not "bin gewesen".',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'war / hatte',
      text: 'ich war, du warst, er war, wir waren … and ich hatte, du hattest, '
          'er hatte, wir hatten …',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Use them for description',
      text: '"Das Wetter __war__ schön und ich __hatte__ viel Zeit." Background '
          'and states love war/hatte.',
    ),
  ],
  items: const [
    QuestSentenceItem(
        sentence: 'Gestern ____ ich krank. (sein, ich)',
        answer: 'war',
        english: 'Yesterday I was ill.',
        gloss: 'ich war'),
    QuestSentenceItem(
        sentence: '____ du gestern zu Hause? (sein, du)',
        answer: 'warst',
        english: 'Were you at home yesterday?',
        gloss: 'du warst'),
    QuestSentenceItem(
        sentence: 'Das Essen ____ sehr gut. (sein, es)',
        answer: 'war',
        english: 'The food was very good.',
        gloss: 'es war'),
    QuestSentenceItem(
        sentence: 'Wir ____ im Urlaub. (sein, wir)',
        answer: 'waren',
        english: 'We were on holiday.',
        gloss: 'wir waren'),
    QuestSentenceItem(
        sentence: 'Ich ____ keine Zeit. (haben, ich)',
        answer: 'hatte',
        english: 'I had no time.',
        gloss: 'ich hatte'),
    QuestSentenceItem(
        sentence: 'Sie ____ einen Hund. (haben, sie Sg.)',
        answer: 'hatte',
        english: 'She had a dog.',
        gloss: 'sie hatte'),
    QuestSentenceItem(
        sentence: 'Wir ____ viel Spaß. (haben, wir)',
        answer: 'hatten',
        english: 'We had a lot of fun.',
        gloss: 'wir hatten'),
  ],
);

/// 10. Das Wetter & Jahreszeiten (vocab).
final QuizContent questA21WetterContent = sentenceQuestQuiz(
  id: 'quest_a2_1_wetter',
  title: 'A2.1 · Das Wetter & Jahreszeiten',
  promptLabel: 'Wort',
  subjectsLabel: 'Wetter',
  subjectColumnLabel: 'English',
  categoryLabel: 'Wetter',
  contextualLayout: true,
  intro: 'Weather and seasons come up in small talk and in the A2 exam. Note '
      'that German often uses "es" + verb: es regnet, es schneit.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'es + verb',
      text: 'es regnet (it rains), es schneit (it snows), es ist windig (it is '
          'windy). The weather is an impersonal "es".',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'The four seasons',
      text: 'der Frühling, der Sommer, der Herbst, der Winter — all masculine, '
          'used with "im": im Sommer.',
    ),
  ],
  items: const [
    QuestSentenceItem(
        sentence: 'Im April ____ es oft. (rains)',
        answer: 'regnet',
        english: 'In April it often rains.',
        gloss: 'rain'),
    QuestSentenceItem(
        sentence: 'Im Winter ____ es. (snows)',
        answer: 'schneit',
        english: 'In winter it snows.',
        gloss: 'snow'),
    QuestSentenceItem(
        sentence: 'Heute ist es sehr ____. (sunny → die Sonne scheint)',
        answer: 'sonnig',
        english: 'Today it is very sunny.',
        gloss: 'sunny'),
    QuestSentenceItem(
        sentence: 'Im ____ fallen die Blätter. (autumn)',
        answer: 'Herbst',
        english: 'In autumn the leaves fall.',
        gloss: 'autumn'),
    QuestSentenceItem(
        sentence: 'Im ____ ist es heiß. (summer)',
        answer: 'Sommer',
        english: 'In summer it is hot.',
        gloss: 'summer'),
    QuestSentenceItem(
        sentence: 'Es ist kalt und ____. (windy)',
        answer: 'windig',
        english: 'It is cold and windy.',
        gloss: 'windy'),
  ],
);

/// 11. Diktat: Im Perfekt.
final QuizContent questA21DiktatContent = dictationQuestQuiz(
  id: 'quest_a2_1_diktat_perfekt',
  title: 'A2.1 · Diktat: Im Perfekt',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro: 'A dictation using the Perfekt. You HEAR a sentence and TYPE it. Listen '
      'for the auxiliary (habe/bin) and the participle at the end. Replay as '
      'often as you like.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'haben or sein?',
      text: 'Movement/change → bin (… gefahren, gekommen). Everything else → '
          'habe (… gemacht, gegessen).',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Participle at the end',
      text: 'Write the participle last: "Ich habe einen Film gesehen." The verb '
          'frame wraps the sentence.',
    ),
  ],
  sentences: const [
    SpeakPhrase(
        phrase: 'Ich habe einen Film gesehen.',
        meaning: 'I watched a film.'),
    SpeakPhrase(
        phrase: 'Wir sind nach Hamburg gefahren.',
        meaning: 'We went to Hamburg.'),
    SpeakPhrase(
        phrase: 'Hast du gut geschlafen?',
        meaning: 'Did you sleep well?'),
    SpeakPhrase(
        phrase: 'Sie ist um acht Uhr aufgestanden.',
        meaning: 'She got up at eight.'),
    SpeakPhrase(
        phrase: 'Ich habe Brot gekauft.', meaning: 'I bought bread.'),
    SpeakPhrase(
        phrase: 'Wir haben im Restaurant gegessen.',
        meaning: 'We ate at a restaurant.'),
    SpeakPhrase(
        phrase: 'Er ist zu Hause geblieben.',
        meaning: 'He stayed at home.'),
  ],
);

/// 12. Sprechen: Nach dem Weg fragen.
final QuizContent questA21SprechenWegContent = speakQuestQuiz(
  id: 'quest_a2_1_sprechen_weg',
  title: 'A2.1 · Sprechen: Nach dem Weg fragen',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro: 'Ask for and follow directions. These use the dative prepositions and '
      'the imperative — both common in town.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Polite opener',
      text: '"Entschuldigung, wie komme ich zum/zur …?" is the all-purpose way '
          'to ask the way.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Direction words',
      text: 'links (left), rechts (right), geradeaus (straight on), an der Ecke '
          '(at the corner).',
    ),
  ],
  phrases: const [
    SpeakPhrase(
        phrase: 'Entschuldigung!', meaning: 'Excuse me!'),
    SpeakPhrase(
        phrase: 'Wie komme ich zum Bahnhof?',
        meaning: 'How do I get to the station?'),
    SpeakPhrase(
        phrase: 'Gehen Sie geradeaus.', meaning: 'Go straight ahead.'),
    SpeakPhrase(
        phrase: 'Biegen Sie links ab.', meaning: 'Turn left.'),
    SpeakPhrase(
        phrase: 'Es ist an der Ecke.', meaning: "It's on the corner."),
    SpeakPhrase(
        phrase: 'Wie weit ist es?', meaning: 'How far is it?'),
    SpeakPhrase(
        phrase: 'Vielen Dank für die Hilfe!',
        meaning: 'Thanks for the help!'),
  ],
);

/// 13. Komparativ — comparing with "als" and the -er ending.
final QuizContent questA21KomparativContent = sentenceQuestQuiz(
  id: 'quest_a2_1_komparativ',
  title: 'A2.1 · Komparativ',
  promptLabel: 'Komparativ',
  subjectsLabel: 'Adjektive',
  subjectColumnLabel: 'Adjektiv',
  categoryLabel: 'Komparativ',
  intro: 'To compare two things, add **-er** to the adjective and join with '
      '**als** (than). Many short adjectives also take an umlaut.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '-er + als',
      text: 'klein → kleiner als, schnell → schneller als. "Ein Auto ist '
          '__schneller als__ ein Fahrrad."',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Umlaut + irregulars',
      text: 'alt → älter, groß → größer, jung → jünger. And gut → __besser__, '
          'viel → __mehr__, gern → __lieber__.',
    ),
  ],
  items: const [
    QuestSentenceItem(
        sentence: 'Ein Zug ist ____ als ein Bus. (schnell)',
        answer: 'schneller',
        english: 'A train is faster than a bus.',
        gloss: 'schnell'),
    QuestSentenceItem(
        sentence: 'Mein Bruder ist ____ als ich. (alt)',
        answer: 'älter',
        english: 'My brother is older than me.',
        gloss: 'alt'),
    QuestSentenceItem(
        sentence: 'Berlin ist ____ als Bonn. (groß)',
        answer: 'größer',
        english: 'Berlin is bigger than Bonn.',
        gloss: 'groß'),
    QuestSentenceItem(
        sentence: 'Heute ist es ____ als gestern. (warm)',
        answer: 'wärmer',
        english: 'Today it is warmer than yesterday.',
        gloss: 'warm'),
    QuestSentenceItem(
        sentence: 'Dieses Buch ist ____ als der Film. (gut)',
        answer: 'besser',
        english: 'This book is better than the film.',
        gloss: 'gut → besser'),
    QuestSentenceItem(
        sentence: 'Ich trinke ____ Tee als Kaffee. (gern → lieber)',
        answer: 'lieber',
        english: 'I prefer tea to coffee.',
        gloss: 'gern → lieber'),
    QuestSentenceItem(
        sentence: 'Ein Fahrrad ist ____ als ein Auto. (langsam)',
        answer: 'langsamer',
        english: 'A bike is slower than a car.',
        gloss: 'langsam'),
    QuestSentenceItem(
        sentence: 'Im Winter sind die Tage ____ als im Sommer. (kurz)',
        answer: 'kürzer',
        english: 'In winter the days are shorter than in summer.',
        gloss: 'kurz'),
    QuestSentenceItem(
        sentence: 'Meine Schwester ist ____ als ich. (jung)',
        answer: 'jünger',
        english: 'My sister is younger than me.',
        gloss: 'jung'),
    QuestSentenceItem(
        sentence: 'Ich esse ____ Obst als Süßigkeiten. (viel → mehr)',
        answer: 'mehr',
        english: 'I eat more fruit than sweets.',
        gloss: 'viel → mehr'),
  ],
);

/// 14. Hören: Wetterbericht.
final QuizContent questA21HoerenWetterContent = listeningQuestQuiz(
  id: 'quest_a2_1_hoeren_wetter',
  title: 'A2.1 · Hören: Wetterbericht',
  category: 'Weather',
  passageTitle: 'Das Wetter heute',
  passage:
      'Guten Morgen! Hier ist der Wetterbericht für heute. Am Vormittag ist es '
      'im Norden noch kalt und es regnet. Am Nachmittag scheint im Süden die '
      'Sonne und es wird wärmer, etwa zwanzig Grad. Am Abend kommt Wind aus dem '
      'Westen. Nehmen Sie im Norden einen Regenschirm mit!',
  passageTranslation:
      'Good morning! Here is the weather report for today. In the morning it is '
      'still cold in the north and it is raining. In the afternoon the sun '
      'shines in the south and it gets warmer, about twenty degrees. In the '
      'evening wind comes from the west. In the north, take an umbrella!',
  questions: const [
    ReadingQuestion(
      question: 'Wie ist das Wetter am Vormittag im Norden?',
      questionTranslation: 'What is the weather like in the north in the morning?',
      options: ['sonnig', 'kalt und regnerisch', 'sehr heiß'],
      optionsTranslation: ['sunny', 'cold and rainy', 'very hot'],
      correctIndex: 1,
      explanation: '"… im Norden noch kalt und es regnet."',
    ),
    ReadingQuestion(
      question: 'Wie warm wird es am Nachmittag im Süden?',
      questionTranslation: 'How warm does it get in the south in the afternoon?',
      options: ['etwa 10 Grad', 'etwa 20 Grad', 'etwa 30 Grad'],
      optionsTranslation: ['about 10°', 'about 20°', 'about 30°'],
      correctIndex: 1,
      explanation: '"… und es wird wärmer, etwa zwanzig Grad."',
    ),
    ReadingQuestion(
      question: 'Was sollte man im Norden mitnehmen?',
      questionTranslation: 'What should you take in the north?',
      options: ['eine Sonnenbrille', 'einen Regenschirm', 'einen Schal'],
      optionsTranslation: ['sunglasses', 'an umbrella', 'a scarf'],
      correctIndex: 1,
      explanation: '"Nehmen Sie im Norden einen Regenschirm mit!"',
    ),
    ReadingQuestion(
      question: 'Woher kommt am Abend der Wind?',
      questionTranslation: 'Where does the wind come from in the evening?',
      options: ['aus dem Osten', 'aus dem Westen', 'aus dem Süden'],
      optionsTranslation: ['from the east', 'from the west', 'from the south'],
      correctIndex: 1,
      explanation: '"Am Abend kommt Wind aus dem Westen."',
    ),
    ReadingQuestion(
      question: 'Wo scheint am Nachmittag die Sonne?',
      questionTranslation: 'Where does the sun shine in the afternoon?',
      options: ['im Norden', 'im Süden', 'im Westen'],
      optionsTranslation: ['in the north', 'in the south', 'in the west'],
      correctIndex: 1,
      explanation: '"Am Nachmittag scheint im Süden die Sonne …"',
    ),
  ],
  intro: 'A weather report on the radio — you only hear it. Listen for north vs '
      'south, the temperature and the advice at the end. Replay as needed.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Compass + time of day',
      text: 'im Norden/Süden and am Vormittag/Nachmittag/Abend split the report '
          'into parts. Match each fact to its part.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'es wird wärmer',
      text: '"es wird + comparative" = it is getting (warmer/colder). A clue for '
          'the temperature question.',
    ),
  ],
);

/// 15. Lesen: Emmas erste Woche in Deutschland.
final QuizContent questA21LesenEmmaContent = readingQuestQuiz(
  id: 'quest_a2_1_lesen_emma',
  title: 'A2.1 · Lesen: Emmas erste Woche',
  category: 'Daily Life',
  passageTitle: 'Emmas erste Woche in Deutschland',
  passage:
      'Emma kommt aus England und studiert jetzt in München. In der ersten Woche '
      'war alles neu für sie. Am Montag hat sie ein Zimmer in einer WG gefunden. '
      'Am Dienstag ist sie zur Universität gegangen und hat neue Leute '
      'kennengelernt. Das Deutsch war zuerst schwer, aber die Studenten waren '
      'sehr nett. Am Wochenende ist sie mit dem Fahrrad durch die Stadt '
      'gefahren. Jetzt gefällt ihr das Leben in München sehr.',
  passageTranslation:
      'Emma is from England and now studies in Munich. In the first week '
      'everything was new for her. On Monday she found a room in a shared flat. '
      'On Tuesday she went to the university and met new people. The German was '
      'hard at first, but the students were very kind. At the weekend she rode '
      'her bike through the city. Now she really likes life in Munich.',
  questions: const [
    ReadingQuestion(
      question: 'Was hat Emma am Montag gemacht?',
      questionTranslation: 'What did Emma do on Monday?',
      options: [
        'ein Zimmer gefunden',
        'neue Leute kennengelernt',
        'die Stadt besichtigt'
      ],
      optionsTranslation: [
        'found a room',
        'met new people',
        'toured the city'
      ],
      correctIndex: 0,
      explanation: '"Am Montag hat sie ein Zimmer in einer WG gefunden."',
    ),
    ReadingQuestion(
      question: 'Wie waren die anderen Studenten?',
      questionTranslation: 'What were the other students like?',
      options: ['unfreundlich', 'sehr nett', 'sehr laut'],
      optionsTranslation: ['unfriendly', 'very kind', 'very loud'],
      correctIndex: 1,
      explanation: '"… aber die Studenten waren sehr nett."',
    ),
    ReadingQuestion(
      question: 'Wie findet Emma das Leben in München jetzt?',
      questionTranslation: 'How does Emma find life in Munich now?',
      options: ['langweilig', 'zu teuer', 'sie mag es sehr'],
      optionsTranslation: ['boring', 'too expensive', 'she really likes it'],
      correctIndex: 2,
      explanation: '"Jetzt gefällt ihr das Leben in München sehr."',
    ),
    ReadingQuestion(
      question: 'Was hat Emma am Dienstag gemacht?',
      questionTranslation: 'What did Emma do on Tuesday?',
      options: [
        'neue Leute kennengelernt',
        'ein Fahrrad gekauft',
        'die Eltern besucht',
      ],
      optionsTranslation: [
        'met new people',
        'bought a bike',
        'visited her parents',
      ],
      correctIndex: 0,
      explanation: '"… und hat neue Leute kennengelernt."',
    ),
    ReadingQuestion(
      question: 'Wie ist Emma am Wochenende durch die Stadt gefahren?',
      questionTranslation: 'How did Emma travel through the city at the weekend?',
      options: ['mit dem Bus', 'mit dem Fahrrad', 'zu Fuß'],
      optionsTranslation: ['by bus', 'by bike', 'on foot'],
      correctIndex: 1,
      explanation: '"… ist sie mit dem Fahrrad durch die Stadt gefahren."',
    ),
  ],
  intro: 'Emma is an English student in Munich — a character you will meet again '
      'in later readings. The text mixes Perfekt (hat gefunden) and war/hatte.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Day-by-day structure',
      text: 'Am Montag …, Am Dienstag …, Am Wochenende … — each day is one event. '
          'Match the question to the right day.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'gefällt ihr',
      text: '"das Leben gefällt ihr" = she likes the life (dative ihr). A nice '
          'callback to the dative pronouns.',
    ),
  ],
);

/// Big text (inline cloze) — Mein Wochenende bei Oma: the two A2.1 big rocks in
/// one narration — the Perfekt (choosing haben vs sein) and the dative article
/// after mit/bei/nach. Filling them inside a story keeps each choice fresh.
final QuizContent questA21BigTextWochenendeContent = bigTextQuestQuiz(
  id: 'quest_a2_1_bigtext_wochenende',
  title: 'A2.1 · Großer Text: Ein Wochenende bei Oma',
  passageTitle: 'Ein Wochenende bei Oma',
  template:
      'Letztes Wochenende {{0}} ich meine Oma besucht. Ich {{1}} mit {{2}} Bus '
      'gefahren. Bei {{3}} Oma {{4}} ich Kuchen gegessen. Sie {{5}} mir viele '
      'Fotos gezeigt. Nach {{6}} Essen {{7}} wir im Park spazieren gegangen. Am '
      'Abend {{8}} ich nach Hause gekommen. Es {{9}} ein schöner Tag.',
  blanks: [
    inputBlank('habe', hint: 'haben/sein? · besuchen'),
    inputBlank('bin', hint: 'haben/sein? · fahren (Bewegung)'),
    inputBlank('dem', hint: 'mit + Dativ · der Bus'),
    inputBlank('der', hint: 'bei + Dativ · die Oma'),
    inputBlank('habe', hint: 'haben/sein? · essen'),
    inputBlank('hat', hint: 'haben/sein? · zeigen'),
    inputBlank('dem', hint: 'nach + Dativ · das Essen'),
    inputBlank('sind', hint: 'haben/sein? · gehen (Bewegung)'),
    inputBlank('bin', hint: 'haben/sein? · kommen (Bewegung)'),
    inputBlank('war', hint: 'sein im Präteritum'),
  ],
  passageTranslation:
      'Last weekend I visited my grandma. I went by bus. At grandma\'s I ate '
      'cake. She showed me lots of photos. After the meal we went for a walk in '
      'the park. In the evening I came home. It was a lovely day.',
  intro: 'Fill in the past. Two things at once: the Perfekt (pick haben or sein) '
      'and the dative article after mit, bei and nach. Read it once, then fill '
      'each gap.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Movers & changers take sein',
      text: 'Verbs of motion or change (fahren, gehen, kommen) build the Perfekt '
          'with sein; everything else (besuchen, essen, zeigen) uses haben.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'mit / bei / nach → Dativ',
      text: 'These always take the dative: der→dem, die→der, das→dem. So mit dem '
          'Bus, bei der Oma, nach dem Essen.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'war = the simple past of sein',
      text: 'sein and haben prefer the simple past even in speech: "Es war schön", '
          'not "Es ist schön gewesen".',
    ),
  ],
);

/// Every A2.1 quiz, in chain order — knowledge interleaved with the four skill
/// types (Sprechen, Hören, Lesen, Diktat), never more than two knowledge quizzes
/// in a row.
final List<QuizContent> questA2_1Content = [
  questA21PerfektHabenContent, //     Perfekt mit haben      (knowledge·verb)
  questA21PerfektSeinContent, //      Perfekt mit sein       (knowledge·verb)
  questA21SprechenWochenendeContent, // Sprechen: Wochenende (speaking)
  questA21DativArtikelContent, //     Dativ: Artikel         (knowledge)
  questA21HoerenReiseContent, //      Hören: Eine Reise      (listening)
  questA21DativPraepContent, //       Dativpräpositionen     (knowledge)
  questA21PronomenDativContent, //    Pronomen im Dativ      (knowledge)
  questA21LesenHamburgContent, //     Lesen: Hamburg         (reading)
  questA21WarHatteContent, //         war & hatte            (knowledge·verb)
  questA21BigTextWochenendeContent, // Großer Text: bei Oma  (reading·cloze)
  questA21WetterContent, //           Wetter & Jahreszeiten  (knowledge)
  questA21DiktatContent, //           Diktat: Im Perfekt     (dictation)
  questA21SprechenWegContent, //      Sprechen: Nach dem Weg (speaking)
  questA21KomparativContent, //       Komparativ             (knowledge)
  questA21HoerenWetterContent, //     Hören: Wetterbericht   (listening)
  questA21LesenEmmaContent, //        Lesen: Emmas Woche     (reading)
];
