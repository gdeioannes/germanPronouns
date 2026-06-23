import '../../models/quiz_content.dart';
import 'quest_builders.dart';

/// CEFR **A2.2 — "Beschreiben & Planen"** Quest quizzes (Goethe A2). Big rocks:
/// the **two-way prepositions** (Akkusativ vs Dativ), **subordinate clauses**
/// with weil/dass (verb to the end), and **TeKaMoLo** word order.

/// 1. Wechselpräpositionen: Wo? (Dativ) — location, no movement.
final QuizContent questA22WechselWoContent = sentenceQuestQuiz(
  id: 'quest_a2_2_wechsel_wo',
  title: 'A2.2 · Wechselpräpositionen: Wo?',
  promptLabel: 'Artikel',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'Wo? (Dativ)',
  intro: 'Nine prepositions can take EITHER case. When they answer **wo?** '
      '(location, no movement) they take the **dative**.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'The nine: an, auf, hinter, in, neben, über, unter, vor, zwischen',
      text: 'Picture a cat and a box: the cat sits **auf der** Box (wo? → Dativ).',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'wo? → Dativ',
      text: 'No movement = state = dative: dem/der/dem. "Das Buch liegt __auf '
          'dem__ Tisch."',
    ),
  ],
  items: [
    qsi('Das Buch liegt auf ____ Tisch. (der)', 'dem',
        'The book is on the table.', 'auf + Dativ'),
    qsi('Die Katze ist unter ____ Bett. (das)', 'dem',
        'The cat is under the bed.', 'unter + Dativ'),
    qsi('Das Bild hängt an ____ Wand. (die)', 'der',
        'The picture hangs on the wall.', 'an + Dativ'),
    qsi('Ich wohne in ____ Stadt. (die)', 'der', 'I live in the city.',
        'in + Dativ'),
    qsi('Das Auto steht vor ____ Haus. (das)', 'dem',
        'The car is in front of the house.', 'vor + Dativ'),
    qsi('Die Lampe hängt über ____ Tisch. (der)', 'dem',
        'The lamp hangs over the table.', 'über + Dativ'),
  ],
);

/// 2. Wechselpräpositionen: Wohin? (Akkusativ) — movement to a goal.
final QuizContent questA22WechselWohinContent = sentenceQuestQuiz(
  id: 'quest_a2_2_wechsel_wohin',
  title: 'A2.2 · Wechselpräpositionen: Wohin?',
  promptLabel: 'Artikel',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'Wohin? (Akkusativ)',
  intro: 'The same nine prepositions take the **accusative** when they answer '
      '**wohin?** (movement towards a goal).',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Movement → Akkusativ',
      text: 'The cat jumps **auf die** Box (wohin? → Akkusativ). Arrow A→ = '
          'Akkusativ. den/die/das.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'stellen/legen/hängen (action) vs stehen/liegen/hängen (state)',
      text: '"Ich lege das Buch __auf den__ Tisch" (wohin? Akk) vs "Das Buch '
          'liegt __auf dem__ Tisch" (wo? Dat).',
    ),
  ],
  items: [
    qsi('Ich lege das Buch auf ____ Tisch. (der)', 'den',
        'I put the book on the table.', 'auf + Akkusativ'),
    qsi('Die Katze springt unter ____ Bett. (das)', 'das',
        'The cat jumps under the bed.', 'unter + Akkusativ'),
    qsi('Ich hänge das Bild an ____ Wand. (die)', 'die',
        'I hang the picture on the wall.', 'an + Akkusativ'),
    qsi('Wir gehen in ____ Park. (der)', 'den', 'We go into the park.',
        'in + Akkusativ'),
    qsi('Stell die Schuhe vor ____ Tür. (die)', 'die',
        'Put the shoes in front of the door.', 'vor + Akkusativ'),
    qsi('Ich setze mich neben ____ Mann. (der)', 'den',
        'I sit down next to the man.', 'neben + Akkusativ'),
  ],
);

/// 3. Sprechen: Mein Zimmer beschreiben.
final QuizContent questA22SprechenZimmerContent = speakQuestQuiz(
  id: 'quest_a2_2_sprechen_zimmer',
  title: 'A2.2 · Sprechen: Mein Zimmer',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro: 'Describe a room using the two-way prepositions in their location '
      '(dative) sense. Listen and repeat.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Position = Dativ',
      text: 'Describing where things ARE → dative: "Das Bett steht __an der__ '
          'Wand."',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'es gibt + Akkusativ',
      text: '"In meinem Zimmer gibt es einen Schrank." es gibt always takes the '
          'accusative.',
    ),
  ],
  phrases: const [
    SpeakPhrase(phrase: 'Das ist mein Zimmer.', meaning: 'This is my room.'),
    SpeakPhrase(
        phrase: 'Das Bett steht an der Wand.',
        meaning: 'The bed is against the wall.'),
    SpeakPhrase(
        phrase: 'Der Tisch steht am Fenster.',
        meaning: 'The table is by the window.'),
    SpeakPhrase(
        phrase: 'Auf dem Tisch liegt ein Buch.',
        meaning: 'There is a book on the table.'),
    SpeakPhrase(
        phrase: 'Neben dem Bett steht eine Lampe.',
        meaning: 'There is a lamp next to the bed.'),
    SpeakPhrase(
        phrase: 'Es gibt auch einen großen Schrank.',
        meaning: 'There is also a big wardrobe.'),
  ],
);

/// 4. Reflexive Verben — sich freuen, sich treffen, sich waschen …
final QuizContent questA22ReflexivContent = sentenceQuestQuiz(
  id: 'quest_a2_2_reflexiv',
  title: 'A2.2 · Reflexive Verben',
  promptLabel: 'Reflexivpronomen',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Verb',
  categoryLabel: 'Reflexivpronomen',
  intro: 'Many German verbs are **reflexive**: the action points back at the '
      'subject with a reflexive pronoun (mich, dich, sich, uns, euch, sich).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'The reflexive pronouns',
      text: 'ich → mich, du → dich, er/sie/es → sich, wir → uns, ihr → euch, '
          'sie/Sie → sich.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Common reflexive verbs',
      text: 'sich freuen (to be glad), sich treffen (to meet), sich '
          'interessieren für (to be interested in), sich waschen.',
    ),
  ],
  items: [
    qsi('Ich freue ____ auf das Wochenende. (ich)', 'mich',
        "I'm looking forward to the weekend.", 'ich → mich'),
    qsi('Freust du ____ auch? (du)', 'dich', 'Are you glad too?',
        'du → dich'),
    qsi('Er interessiert ____ für Musik. (er)', 'sich',
        'He is interested in music.', 'er → sich'),
    qsi('Wir treffen ____ um acht Uhr. (wir)', 'uns', 'We meet at eight.',
        'wir → uns'),
    qsi('Wascht ____ die Hände! (ihr)', 'euch', 'Wash your hands!',
        'ihr → euch'),
    qsi('Die Kinder freuen ____ über das Geschenk. (sie Pl.)', 'sich',
        'The children are happy about the gift.', 'sie → sich'),
  ],
);

/// 5. Nebensatz mit *weil* — verb to the very end.
final QuizContent questA22WeilContent = sentenceQuestQuiz(
  id: 'quest_a2_2_weil',
  title: 'A2.2 · Nebensatz mit weil',
  promptLabel: 'Verb am Ende',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'weil + Verb am Ende',
  intro: 'After **weil** (because) the conjugated verb jumps to the **very end** '
      'of the clause — a key difference from English word order.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'The verb kicks to the back',
      text: '"Ich bleibe zu Hause, weil ich krank __bin__." Not "weil ich bin '
          'krank". The conjunction sends the verb last.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Comma before weil',
      text: 'A subordinate clause is always separated by a comma: Main, weil ….',
    ),
  ],
  items: [
    qsi('Ich bleibe zu Hause, weil ich krank ____. (sein)', 'bin',
        "I'm staying home because I'm ill.", 'weil … bin'),
    qsi('Sie lernt Deutsch, weil sie in Berlin ____. (wohnen)', 'wohnt',
        'She learns German because she lives in Berlin.', 'weil … wohnt'),
    qsi('Wir nehmen den Bus, weil es ____. (regnen)', 'regnet',
        "We take the bus because it's raining.", 'weil … regnet'),
    qsi('Er ist müde, weil er schlecht ____ hat. (schlafen)', 'geschlafen',
        'He is tired because he slept badly.', 'weil … geschlafen hat'),
    qsi('Ich kaufe das Buch, weil es interessant ____. (sein)', 'ist',
        'I buy the book because it is interesting.', 'weil … ist'),
  ],
);

/// 6. Hören: Eine Verabredung.
final QuizContent questA22HoerenVerabredungContent = listeningQuestQuiz(
  id: 'quest_a2_2_hoeren_verabredung',
  title: 'A2.2 · Hören: Eine Verabredung',
  category: 'Daily Life',
  passageTitle: 'Ein Plan für Samstag',
  passage:
      'Hallo Lisa, ich bin es, Jan. Hast du am Samstag Zeit? Es gibt eine neue '
      'Ausstellung im Museum. Wir können um drei Uhr hingehen, weil es dann '
      'nicht so voll ist. Danach trinken wir vielleicht einen Kaffee. Treffen '
      'wir uns vor dem Museum? Ruf mich bitte zurück. Bis Samstag!',
  passageTranslation:
      'Hi Lisa, it’s me, Jan. Do you have time on Saturday? There is a new '
      'exhibition at the museum. We can go at three o’clock, because it’s not so '
      'crowded then. Afterwards maybe we’ll have a coffee. Shall we meet in '
      'front of the museum? Please call me back. See you Saturday!',
  questions: const [
    ReadingQuestion(
      question: 'Was schlägt Jan für Samstag vor?',
      questionTranslation: 'What does Jan suggest for Saturday?',
      options: ['ins Kino gehen', 'eine Ausstellung besuchen', 'Fußball spielen'],
      optionsTranslation: ['go to the cinema', 'visit an exhibition', 'play football'],
      correctIndex: 1,
      explanation: '"Es gibt eine neue Ausstellung im Museum."',
    ),
    ReadingQuestion(
      question: 'Warum will Jan um drei Uhr gehen?',
      questionTranslation: 'Why does Jan want to go at three?',
      options: [
        'weil es dann billiger ist',
        'weil es dann nicht so voll ist',
        'weil er später keine Zeit hat'
      ],
      optionsTranslation: [
        'because it’s cheaper then',
        'because it’s less crowded then',
        'because he has no time later'
      ],
      correctIndex: 1,
      explanation: '"… weil es dann nicht so voll ist."',
    ),
    ReadingQuestion(
      question: 'Wo wollen sie sich treffen?',
      questionTranslation: 'Where do they want to meet?',
      options: ['im Café', 'vor dem Museum', 'am Bahnhof'],
      optionsTranslation: ['in the café', 'in front of the museum', 'at the station'],
      correctIndex: 1,
      explanation: '"Treffen wir uns vor dem Museum?"',
    ),
  ],
  intro: 'A voicemail making a plan — you only hear it. Listen for the activity, '
      'the reason (weil …) and the meeting place. Replay as needed.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Listen for weil',
      text: 'The reason follows "weil …" with the verb at the end. That answers '
          'the "why?" question.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Suggestions',
      text: '"Wir können …", "Treffen wir uns …?" are ways to propose a plan.',
    ),
  ],
);

/// 7. Nebensatz mit *dass*.
final QuizContent questA22DassContent = sentenceQuestQuiz(
  id: 'quest_a2_2_dass',
  title: 'A2.2 · Nebensatz mit dass',
  promptLabel: 'Verb am Ende',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'dass + Verb am Ende',
  intro: '**dass** (that) introduces a reported idea, and like weil it sends the '
      'verb to the end. Use it after verbs of thinking and saying.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'dass → verb last',
      text: '"Ich glaube, dass er recht __hat__." denken, glauben, wissen, '
          'hoffen, sagen all take dass-clauses.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'dass ≠ das',
      text: 'das = the/that (article/relative); dass = that (conjunction). Two '
          's after a short vowel.',
    ),
  ],
  items: [
    qsi('Ich glaube, dass er recht ____. (haben)', 'hat',
        'I think that he is right.', 'dass … hat'),
    qsi('Sie sagt, dass sie morgen ____. (kommen)', 'kommt',
        'She says that she is coming tomorrow.', 'dass … kommt'),
    qsi('Ich hoffe, dass das Wetter schön ____. (sein)', 'ist',
        'I hope that the weather is nice.', 'dass … ist'),
    qsi('Wir wissen, dass du viel ____. (arbeiten)', 'arbeitest',
        'We know that you work a lot.', 'dass … arbeitest'),
    qsi('Es ist gut, dass du gekommen ____. (sein)', 'bist',
        "It's good that you came.", 'dass … bist'),
  ],
);

/// 8. Körper & Gesundheit (vocab).
final QuizContent questA22GesundheitContent = sentenceQuestQuiz(
  id: 'quest_a2_2_gesundheit',
  title: 'A2.2 · Körper & Gesundheit',
  promptLabel: 'Wort',
  subjectsLabel: 'Körper',
  subjectColumnLabel: 'English',
  categoryLabel: 'Gesundheit',
  contextualLayout: true,
  intro: 'Body parts and being ill — essential for a visit to the doctor. Note '
      'the phrase "Ich habe … schmerzen" for aches.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'Saying what hurts',
      text: 'Ich habe Kopfschmerzen / Bauchschmerzen / Halsschmerzen. Or: Mein '
          'Bein tut weh.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'At the doctor',
      text: 'der Arzt (doctor), die Krankheit (illness), die Apotheke '
          '(pharmacy), das Medikament (medicine).',
    ),
  ],
  items: [
    qsi('Ich habe ____ und nehme eine Tablette. (headache)', 'Kopfschmerzen',
        'I have a headache and take a pill.', 'headache'),
    qsi('Mein ____ tut weh, ich kann nicht laufen. (leg)', 'Bein',
        'My leg hurts, I cannot walk.', 'leg'),
    qsi('Der ____ untersucht den Patienten. (doctor)', 'Arzt',
        'The doctor examines the patient.', 'doctor'),
    qsi('Ich kaufe das Medikament in der ____. (pharmacy)', 'Apotheke',
        'I buy the medicine at the pharmacy.', 'pharmacy'),
    qsi('Ich bin ____ und bleibe im Bett. (ill)', 'krank',
        'I am ill and stay in bed.', 'ill'),
  ],
);

/// 9. Lesen: Beim Arzt.
final QuizContent questA22LesenArztContent = readingQuestQuiz(
  id: 'quest_a2_2_lesen_arzt',
  title: 'A2.2 · Lesen: Beim Arzt',
  category: 'Health',
  passageTitle: 'Beim Arzt',
  passage:
      'Herr Berger geht zum Arzt, weil er sich nicht gut fühlt. Er hat seit drei '
      'Tagen Kopfschmerzen und Fieber. Der Arzt untersucht ihn und sagt: "Sie '
      'haben eine Erkältung. Sie müssen viel trinken und im Bett bleiben." Herr '
      'Berger bekommt ein Rezept für ein Medikament. In der Apotheke holt er die '
      'Tabletten. Nach einer Woche geht es ihm wieder besser.',
  passageTranslation:
      'Mr Berger goes to the doctor because he does not feel well. He has had a '
      'headache and a fever for three days. The doctor examines him and says: '
      '"You have a cold. You must drink a lot and stay in bed." Mr Berger gets a '
      'prescription for a medicine. At the pharmacy he picks up the tablets. '
      'After a week he feels better again.',
  questions: const [
    ReadingQuestion(
      question: 'Warum geht Herr Berger zum Arzt?',
      questionTranslation: 'Why does Mr Berger go to the doctor?',
      options: [
        'weil er sich nicht gut fühlt',
        'für eine Routineuntersuchung',
        'weil er ein Rezept braucht'
      ],
      optionsTranslation: [
        'because he doesn’t feel well',
        'for a check-up',
        'because he needs a prescription'
      ],
      correctIndex: 0,
      explanation: '"… weil er sich nicht gut fühlt."',
    ),
    ReadingQuestion(
      question: 'Was hat Herr Berger?',
      questionTranslation: 'What does Mr Berger have?',
      options: ['eine Allergie', 'eine Erkältung', 'einen gebrochenen Arm'],
      optionsTranslation: ['an allergy', 'a cold', 'a broken arm'],
      correctIndex: 1,
      explanation: '"Sie haben eine Erkältung."',
    ),
    ReadingQuestion(
      question: 'Was soll er tun?',
      questionTranslation: 'What should he do?',
      options: [
        'Sport machen',
        'viel trinken und im Bett bleiben',
        'sofort ins Krankenhaus gehen'
      ],
      optionsTranslation: [
        'do sport',
        'drink a lot and stay in bed',
        'go to hospital immediately'
      ],
      correctIndex: 1,
      explanation: '"Sie müssen viel trinken und im Bett bleiben."',
    ),
  ],
  intro: 'A scene at the doctor’s. It recycles the health vocabulary, weil, and '
      'modal verbs (müssen).',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'seit + time',
      text: '"seit drei Tagen" = for three days (and still). seit always takes '
          'the dative.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'The doctor’s advice',
      text: 'Advice comes as "Sie müssen …" (you must) — a modal verb with the '
          'main verb at the end.',
    ),
  ],
);

/// 10. Imperativ — du/ihr/Sie commands.
final QuizContent questA22ImperativContent = sentenceQuestQuiz(
  id: 'quest_a2_2_imperativ',
  title: 'A2.2 · Imperativ',
  promptLabel: 'Imperativ',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'Imperativ',
  intro: 'The imperative gives commands, advice and instructions. It has three '
      'forms — du, ihr and Sie — and the verb comes first.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'du / ihr / Sie forms',
      text: 'du: drop -st (du gehst → Geh!). ihr: like the present (Geht!). Sie: '
          'verb + Sie (Gehen Sie!).',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Stem-change a→ä drops',
      text: 'fahren → Fahr! (no umlaut in du-imperative), but e→i stays: nehmen '
          '→ Nimm!, geben → Gib!',
    ),
  ],
  items: [
    qsi('____ bitte langsamer! (sprechen, du)', 'Sprich',
        'Speak more slowly, please!', 'sprechen → Sprich!'),
    qsi('____ Sie hier, bitte. (warten, Sie)', 'Warten',
        'Please wait here.', 'warten → Warten Sie!'),
    qsi('____ mir bitte das Salz. (geben, du)', 'Gib',
        'Pass me the salt, please.', 'geben → Gib!'),
    qsi('____ leise, das Baby schläft! (sein, ihr)', 'Seid',
        'Be quiet, the baby is sleeping!', 'sein → Seid!'),
    qsi('____ viel Wasser! (trinken, du)', 'Trink', 'Drink lots of water!',
        'trinken → Trink!'),
  ],
);

/// 11. Diktat: Im Alltag.
final QuizContent questA22DiktatContent = dictationQuestQuiz(
  id: 'quest_a2_2_diktat_alltag',
  title: 'A2.2 · Diktat: Beschreiben',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro: 'A dictation with two-way prepositions and subordinate clauses. You '
      'HEAR a sentence and TYPE it. Listen for the case after the preposition '
      'and the verb at the end of weil/dass clauses.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Wo or wohin?',
      text: 'Location → dem/der; movement → den/die/das. Listen to the verb '
          '(liegt vs lege).',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Comma + verb last',
      text: 'In "…, weil ich müde bin" the verb is the last word. Write it there.',
    ),
  ],
  sentences: const [
    SpeakPhrase(
        phrase: 'Das Buch liegt auf dem Tisch.',
        meaning: 'The book is on the table.'),
    SpeakPhrase(
        phrase: 'Ich gehe heute nicht raus, weil es regnet.',
        meaning: "I'm not going out today because it's raining."),
    SpeakPhrase(
        phrase: 'Stell die Flasche in den Kühlschrank.',
        meaning: 'Put the bottle in the fridge.'),
    SpeakPhrase(
        phrase: 'Ich glaube, dass sie recht hat.',
        meaning: 'I think that she is right.'),
    SpeakPhrase(
        phrase: 'Die Lampe hängt über dem Bett.',
        meaning: 'The lamp hangs over the bed.'),
    SpeakPhrase(
        phrase: 'Wir treffen uns vor dem Kino.',
        meaning: 'We meet in front of the cinema.'),
    SpeakPhrase(
        phrase: 'Trink viel und bleib im Bett!',
        meaning: 'Drink a lot and stay in bed!'),
  ],
);

/// 12. Sprechen: Personen beschreiben.
final QuizContent questA22SprechenPersonContent = speakQuestQuiz(
  id: 'quest_a2_2_sprechen_person',
  title: 'A2.2 · Sprechen: Personen beschreiben',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro: 'Describe what people look like and what they are like. Listen and '
      'repeat; notice ser-like sein for character (Er ist nett) vs states.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Hair & build',
      text: '"Er hat kurze, dunkle Haare." "Sie ist groß und schlank."',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Character adjectives',
      text: 'nett (nice), freundlich (friendly), ruhig (calm), lustig (funny).',
    ),
  ],
  phrases: const [
    SpeakPhrase(
        phrase: 'Mein Freund heißt Paul.', meaning: 'My friend is called Paul.'),
    SpeakPhrase(
        phrase: 'Er ist groß und schlank.',
        meaning: 'He is tall and slim.'),
    SpeakPhrase(
        phrase: 'Er hat kurze, dunkle Haare.',
        meaning: 'He has short, dark hair.'),
    SpeakPhrase(
        phrase: 'Er ist sehr freundlich und lustig.',
        meaning: 'He is very friendly and funny.'),
    SpeakPhrase(
        phrase: 'Sie trägt eine Brille.',
        meaning: 'She wears glasses.'),
    SpeakPhrase(
        phrase: 'Wie sieht deine Schwester aus?',
        meaning: 'What does your sister look like?'),
  ],
);

/// 13. Superlativ — am größten / der größte.
final QuizContent questA22SuperlativContent = sentenceQuestQuiz(
  id: 'quest_a2_2_superlativ',
  title: 'A2.2 · Superlativ',
  promptLabel: 'Superlativ',
  subjectsLabel: 'Adjektive',
  subjectColumnLabel: 'Adjektiv',
  categoryLabel: 'Superlativ',
  intro: 'The superlative names the top of a group. The adverbial form is **am '
      '…-sten**: "Er läuft am schnellsten."',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'am …-sten',
      text: 'schnell → am schnellsten, klein → am kleinsten. After -t/-d/-s add '
          '-esten: am ältesten.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Irregulars',
      text: 'gut → am besten, viel → am meisten, gern → am liebsten, groß → am '
          'größten.',
    ),
  ],
  items: [
    qsi('Der Elefant ist am ____. (groß)', 'größten',
        'The elephant is the biggest.', 'groß → am größten'),
    qsi('Im Winter sind die Tage am ____. (kurz)', 'kürzesten',
        'In winter the days are shortest.', 'kurz → am kürzesten'),
    qsi('Anna läuft am ____. (schnell)', 'schnellsten',
        'Anna runs the fastest.', 'schnell → am schnellsten'),
    qsi('Dieses Eis schmeckt am ____. (gut)', 'besten',
        'This ice cream tastes the best.', 'gut → am besten'),
    qsi('Ich trinke am ____ Wasser. (gern)', 'liebsten',
        'I like drinking water the most.', 'gern → am liebsten'),
  ],
);

/// 14. Lesen: Eine E-Mail an einen Freund.
final QuizContent questA22LesenEmailContent = readingQuestQuiz(
  id: 'quest_a2_2_lesen_email',
  title: 'A2.2 · Lesen: Eine E-Mail',
  category: 'Daily Life',
  passageTitle: 'Eine E-Mail an Tom',
  passage:
      'Lieber Tom, wie geht es dir? Ich bin jetzt in meine neue Wohnung '
      'umgezogen. Sie ist nicht sehr groß, aber sehr hell, weil sie im vierten '
      'Stock liegt. Das Schlafzimmer ist am schönsten. Leider gibt es keinen '
      'Aufzug, deshalb muss ich immer die Treppe nehmen. Am Samstag mache ich '
      'eine kleine Party. Möchtest du kommen? Schreib mir bald zurück! Viele '
      'Grüße, Marie.',
  passageTranslation:
      'Dear Tom, how are you? I have now moved into my new flat. It is not very '
      'big, but very bright, because it is on the fourth floor. The bedroom is '
      'the nicest. Unfortunately there is no lift, so I always have to take the '
      'stairs. On Saturday I’m having a small party. Would you like to come? '
      'Write back soon! Best wishes, Marie.',
  questions: const [
    ReadingQuestion(
      question: 'Wie ist Maries neue Wohnung?',
      questionTranslation: 'What is Marie’s new flat like?',
      options: ['groß und dunkel', 'klein, aber hell', 'alt und billig'],
      optionsTranslation: ['big and dark', 'small but bright', 'old and cheap'],
      correctIndex: 1,
      explanation: '"Sie ist nicht sehr groß, aber sehr hell …"',
    ),
    ReadingQuestion(
      question: 'Warum nimmt Marie immer die Treppe?',
      questionTranslation: 'Why does Marie always take the stairs?',
      options: [
        'weil es gesünder ist',
        'weil es keinen Aufzug gibt',
        'weil der Aufzug kaputt ist'
      ],
      optionsTranslation: [
        'because it’s healthier',
        'because there is no lift',
        'because the lift is broken'
      ],
      correctIndex: 1,
      explanation: '"Leider gibt es keinen Aufzug, deshalb …"',
    ),
    ReadingQuestion(
      question: 'Was plant Marie für Samstag?',
      questionTranslation: 'What is Marie planning for Saturday?',
      options: ['einen Umzug', 'eine Party', 'eine Reise'],
      optionsTranslation: ['a move', 'a party', 'a trip'],
      correctIndex: 1,
      explanation: '"Am Samstag mache ich eine kleine Party."',
    ),
  ],
  intro: 'A friendly email. It uses weil, deshalb and the superlative — a good '
      'review of this level’s grammar in a real text type.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Email frame',
      text: 'Lieber/Liebe … (Dear) opens; Viele Grüße (best wishes) closes. '
          'Useful to recognise and to write.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'weil vs deshalb',
      text: 'weil + reason (verb last); deshalb + result (verb second). Both '
          'appear here.',
    ),
  ],
);

/// Every A2.2 quiz, in chain order — all five exercise types, interleaved.
final List<QuizContent> questA2_2Content = [
  questA22WechselWoContent, //        Wechselpräp.: Wo?      (knowledge)
  questA22WechselWohinContent, //     Wechselpräp.: Wohin?   (knowledge)
  questA22SprechenZimmerContent, //   Sprechen: Mein Zimmer  (speaking)
  questA22ReflexivContent, //         Reflexive Verben       (knowledge·verb)
  questA22WeilContent, //             Nebensatz: weil        (knowledge)
  questA22HoerenVerabredungContent, // Hören: Verabredung    (listening)
  questA22DassContent, //             Nebensatz: dass        (knowledge)
  questA22GesundheitContent, //       Körper & Gesundheit    (knowledge)
  questA22LesenArztContent, //        Lesen: Beim Arzt       (reading)
  questA22ImperativContent, //        Imperativ              (knowledge·verb)
  questA22DiktatContent, //           Diktat: Beschreiben    (dictation)
  questA22SprechenPersonContent, //   Sprechen: Personen     (speaking)
  questA22SuperlativContent, //       Superlativ             (knowledge)
  questA22LesenEmailContent, //       Lesen: Eine E-Mail     (reading)
];
