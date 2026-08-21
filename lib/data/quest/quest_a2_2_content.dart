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
  intro:
      'Nine prepositions can take EITHER case. When they answer **wo?** '
      '(location, no movement) they take the **dative**.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'The nine: an, auf, hinter, in, neben, über, unter, vor, zwischen',
      text:
          'Picture a cat and a box: the cat sits **auf der** Box (wo? → Dativ).',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'wo? → Dativ',
      text:
          'No movement = state = dative: dem/der/dem. "Das Buch liegt __auf '
          'dem__ Tisch."',
    ),
  ],
  items: [
    qsi(
      'Das Buch liegt auf ____ Tisch. (der)',
      'dem',
      'The book is on the table.',
      'auf + Dativ',
    ),
    qsi(
      'Die Katze ist unter ____ Bett. (das)',
      'dem',
      'The cat is under the bed.',
      'unter + Dativ',
    ),
    qsi(
      'Das Bild hängt an ____ Wand. (die)',
      'der',
      'The picture hangs on the wall.',
      'an + Dativ',
    ),
    qsi(
      'Ich wohne in ____ Stadt. (die)',
      'der',
      'I live in the city.',
      'in + Dativ',
    ),
    qsi(
      'Das Auto steht vor ____ Haus. (das)',
      'dem',
      'The car is in front of the house.',
      'vor + Dativ',
    ),
    qsi(
      'Die Lampe hängt über ____ Tisch. (der)',
      'dem',
      'The lamp hangs over the table.',
      'über + Dativ',
    ),
    qsi(
      'Die Schuhe stehen neben ____ Tür. (die)',
      'der',
      'The shoes are next to the door.',
      'neben + Dativ',
    ),
    qsi(
      'Der Garten liegt hinter ____ Haus. (das)',
      'dem',
      'The garden is behind the house.',
      'hinter + Dativ',
    ),
    qsi(
      'Der Tisch steht zwischen ____ Betten. (die, Plural)',
      'den',
      'The table stands between the beds.',
      'zwischen + Dativ',
    ),
    qsi(
      'Wir warten an ____ Bahnhof. (der)',
      'dem',
      'We wait at the station.',
      'an + Dativ (m.)',
    ),
    qsi(
      'Die Kinder spielen in ____ Garten. (der)',
      'dem',
      'The children play in the garden.',
      'in + Dativ (m.)',
    ),
    qsi(
      'Der Hund schläft unter ____ Stuhl. (der)',
      'dem',
      'The dog sleeps under the chair.',
      'unter + Dativ (m.)',
    ),
    qsi(
      'Das Restaurant liegt neben ____ Kino. (das)',
      'dem',
      'The restaurant is next to the cinema.',
      'neben + Dativ (n.)',
    ),
    qsi(
      'Die Uhr hängt über ____ Tür. (die)',
      'der',
      'The clock hangs above the door.',
      'über + Dativ (f.)',
    ),
    qsi(
      'Das Fahrrad steht hinter ____ Garage. (die)',
      'der',
      'The bike is behind the garage.',
      'hinter + Dativ (f.)',
    ),
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
  intro:
      'The same nine prepositions take the **accusative** when they answer '
      '**wohin?** (movement towards a goal).',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Movement → Akkusativ',
      text:
          'The cat jumps **auf die** Box (wohin? → Akkusativ). Arrow A→ = '
          'Akkusativ. den/die/das.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'stellen/legen/hängen (action) vs stehen/liegen/hängen (state)',
      text:
          '"Ich lege das Buch __auf den__ Tisch" (wohin? Akk) vs "Das Buch '
          'liegt __auf dem__ Tisch" (wo? Dat).',
    ),
  ],
  items: [
    qsi(
      'Ich lege das Buch auf ____ Tisch. (der)',
      'den',
      'I put the book on the table.',
      'auf + Akkusativ',
    ),
    qsi(
      'Die Katze springt unter ____ Bett. (das)',
      'das',
      'The cat jumps under the bed.',
      'unter + Akkusativ',
    ),
    qsi(
      'Ich hänge das Bild an ____ Wand. (die)',
      'die',
      'I hang the picture on the wall.',
      'an + Akkusativ',
    ),
    qsi(
      'Wir gehen in ____ Park. (der)',
      'den',
      'We go into the park.',
      'in + Akkusativ',
    ),
    qsi(
      'Stell die Schuhe vor ____ Tür. (die)',
      'die',
      'Put the shoes in front of the door.',
      'vor + Akkusativ',
    ),
    qsi(
      'Ich setze mich neben ____ Mann. (der)',
      'den',
      'I sit down next to the man.',
      'neben + Akkusativ',
    ),
    qsi(
      'Ich stelle die Vase auf ____ Regal. (das)',
      'das',
      'I put the vase on the shelf.',
      'auf + Akkusativ (n.)',
    ),
    qsi(
      'Er hängt die Uhr über ____ Tür. (die)',
      'die',
      'He hangs the clock above the door.',
      'über + Akkusativ',
    ),
    qsi(
      'Wir fahren in ____ Stadt. (die)',
      'die',
      'We drive into the city.',
      'in + Akkusativ (f.)',
    ),
    qsi(
      'Der Hund läuft hinter ____ Baum. (der)',
      'den',
      'The dog runs behind the tree.',
      'hinter + Akkusativ',
    ),
    qsi(
      'Ich lege den Brief zwischen ____ Bücher. (die, Plural)',
      'die',
      'I put the letter between the books.',
      'zwischen + Akkusativ',
    ),
    qsi(
      'Sie stellt die Milch in ____ Kühlschrank. (der)',
      'den',
      'She puts the milk in the fridge.',
      'in + Akkusativ (m.)',
    ),
    qsi(
      'Das Kind springt in ____ Wasser. (das)',
      'das',
      'The child jumps into the water.',
      'in + Akkusativ (n.)',
    ),
    qsi(
      'Ich setze mich an ____ Fenster. (das)',
      'das',
      'I sit down by the window.',
      'an + Akkusativ (n.)',
    ),
    qsi(
      'Stell den Stuhl vor ____ Schreibtisch. (der)',
      'den',
      'Put the chair in front of the desk.',
      'vor + Akkusativ',
    ),
  ],
);

/// 3. Sprechen: Mein Zimmer beschreiben.
final QuizContent questA22SprechenZimmerContent = speakQuestQuiz(
  id: 'quest_a2_2_sprechen_zimmer',
  title: 'A2.2 · Sprechen: Mein Zimmer',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro:
      'Describe a room using the two-way prepositions in their location '
      '(dative) sense. Listen and repeat.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Position = Dativ',
      text:
          'Describing where things ARE → dative: "Das Bett steht __an der__ '
          'Wand."',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'es gibt + Akkusativ',
      text:
          '"In meinem Zimmer gibt es einen Schrank." es gibt always takes the '
          'accusative.',
    ),
  ],
  phrases: const [
    SpeakPhrase(phrase: 'Das ist mein Zimmer.', meaning: 'This is my room.'),
    SpeakPhrase(
      phrase: 'Das Bett steht an der Wand.',
      meaning: 'The bed is against the wall.',
    ),
    SpeakPhrase(
      phrase: 'Der Tisch steht am Fenster.',
      meaning: 'The table is by the window.',
    ),
    SpeakPhrase(
      phrase: 'Auf dem Tisch liegt ein Buch.',
      meaning: 'There is a book on the table.',
    ),
    SpeakPhrase(
      phrase: 'Neben dem Bett steht eine Lampe.',
      meaning: 'There is a lamp next to the bed.',
    ),
    SpeakPhrase(
      phrase: 'Es gibt auch einen großen Schrank.',
      meaning: 'There is also a big wardrobe.',
    ),
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
  intro:
      'Many German verbs are **reflexive**: the action points back at the '
      'subject with a reflexive pronoun (mich, dich, sich, uns, euch, sich).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'The reflexive pronouns',
      text:
          'ich → mich, du → dich, er/sie/es → sich, wir → uns, ihr → euch, '
          'sie/Sie → sich.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Common reflexive verbs',
      text:
          'sich freuen (to be glad), sich treffen (to meet), sich '
          'interessieren für (to be interested in), sich waschen.',
    ),
  ],
  items: [
    qsi(
      'Ich freue ____ auf das Wochenende. (ich)',
      'mich',
      "I'm looking forward to the weekend.",
      'ich → mich',
    ),
    qsi('Freust du ____ auch? (du)', 'dich', 'Are you glad too?', 'du → dich'),
    qsi(
      'Er interessiert ____ für Musik. (er)',
      'sich',
      'He is interested in music.',
      'er → sich',
    ),
    qsi(
      'Wir treffen ____ um acht Uhr. (wir)',
      'uns',
      'We meet at eight.',
      'wir → uns',
    ),
    qsi(
      'Wascht ____ die Hände! (ihr)',
      'euch',
      'Wash your hands!',
      'ihr → euch',
    ),
    qsi(
      'Die Kinder freuen ____ über das Geschenk. (sie Pl.)',
      'sich',
      'The children are happy about the gift.',
      'sie → sich',
    ),
    qsi(
      'Ich wasche ____ jeden Morgen. (ich)',
      'mich',
      'I wash (myself) every morning.',
      'ich → mich (waschen)',
    ),
    qsi(
      'Interessierst du ____ für Sport? (du)',
      'dich',
      'Are you interested in sport?',
      'du → dich (interessieren)',
    ),
    qsi(
      'Sie duscht ____ am Abend. (sie Sg.)',
      'sich',
      'She showers in the evening.',
      'sie → sich (duschen)',
    ),
    qsi(
      'Wir freuen ____ auf den Urlaub. (wir)',
      'uns',
      'We are looking forward to the holiday.',
      'wir → uns (freuen)',
    ),
    qsi(
      'Beeilt ____, der Bus kommt! (ihr)',
      'euch',
      'Hurry up, the bus is coming!',
      'ihr → euch (beeilen)',
    ),
    qsi(
      'Er zieht ____ schnell an. (er)',
      'sich',
      'He gets dressed quickly.',
      'er → sich (anziehen)',
    ),
    qsi(
      'Ich erinnere ____ an den Sommer. (ich)',
      'mich',
      'I remember the summer.',
      'ich → mich (erinnern)',
    ),
    qsi(
      'Setzen Sie ____ bitte! (Sie)',
      'sich',
      'Please sit down!',
      'Sie → sich (setzen)',
    ),
    qsi(
      'Wir sehen ____ morgen. (wir)',
      'uns',
      'We will see each other tomorrow.',
      'wir → uns (sehen)',
    ),
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
  intro:
      'After **weil** (because) the conjugated verb jumps to the **very end** '
      'of the clause — a key difference from English word order.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'The verb kicks to the back',
      text:
          '"Ich bleibe zu Hause, weil ich krank __bin__." Not "weil ich bin '
          'krank". The conjunction sends the verb last.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Comma before weil',
      text:
          'A subordinate clause is always separated by a comma: Main, weil ….',
    ),
  ],
  items: [
    qsi(
      'Ich bleibe zu Hause, weil ich krank ____. (sein)',
      'bin',
      "I'm staying home because I'm ill.",
      'weil … bin',
    ),
    qsi(
      'Sie lernt Deutsch, weil sie in Berlin ____. (wohnen)',
      'wohnt',
      'She learns German because she lives in Berlin.',
      'weil … wohnt',
    ),
    qsi(
      'Wir nehmen den Bus, weil es ____. (regnen)',
      'regnet',
      "We take the bus because it's raining.",
      'weil … regnet',
    ),
    qsi(
      'Er ist müde, weil er schlecht ____ hat. (schlafen)',
      'geschlafen',
      'He is tired because he slept badly.',
      'weil … geschlafen hat',
    ),
    qsi(
      'Ich kaufe das Buch, weil es interessant ____. (sein)',
      'ist',
      'I buy the book because it is interesting.',
      'weil … ist',
    ),
    qsi(
      'Er geht zum Arzt, weil er Fieber ____. (haben)',
      'hat',
      'He goes to the doctor because he has a fever.',
      'weil … hat',
    ),
    qsi(
      'Ich lerne viel, weil ich die Prüfung bestehen ____. (wollen)',
      'will',
      'I study a lot because I want to pass the exam.',
      'weil … will',
    ),
    qsi(
      'Wir bleiben drinnen, weil es kalt ____. (sein)',
      'ist',
      'We stay inside because it is cold.',
      'weil … ist (kalt)',
    ),
    qsi(
      'Sie ist glücklich, weil sie Urlaub ____. (haben)',
      'hat',
      'She is happy because she is on holiday.',
      'weil … hat (Urlaub)',
    ),
    qsi(
      'Ich esse einen Apfel, weil ich Hunger ____. (haben)',
      'habe',
      'I eat an apple because I am hungry.',
      'weil … habe',
    ),
    qsi(
      'Er kommt zu spät, weil der Bus nicht ____. (kommen)',
      'kommt',
      'He is late because the bus is not coming.',
      'weil … kommt',
    ),
    qsi(
      'Wir fahren ans Meer, weil wir schwimmen ____. (möchten)',
      'möchten',
      'We go to the sea because we want to swim.',
      'weil … möchten',
    ),
    qsi(
      'Ich rufe dich an, weil ich eine Frage ____. (haben)',
      'habe',
      'I am calling you because I have a question.',
      'weil … habe (Frage)',
    ),
    qsi(
      'Sie trägt eine Jacke, weil es windig ____. (sein)',
      'ist',
      'She wears a jacket because it is windy.',
      'weil … ist (windig)',
    ),
    qsi(
      'Er spart Geld, weil er ein Auto kaufen ____. (wollen)',
      'will',
      'He saves money because he wants to buy a car.',
      'weil … will (kaufen)',
    ),
  ],
);

/// 6. Hören: Eine Verabredung.
final QuizContent questA22HoerenVerabredungContent = listeningQuestQuiz(
  id: 'quest_a2_2_hoeren_verabredung',
  // The speaker is Jan ("ich bin es, Jan"), a man — read with a male voice.
  voiceGender: VoiceGender.male,
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
      options: [
        'ins Kino gehen',
        'eine Ausstellung besuchen',
        'Fußball spielen',
      ],
      optionsTranslation: [
        'go to the cinema',
        'visit an exhibition',
        'play football',
      ],
      correctIndex: 1,
      explanation: '"Es gibt eine neue Ausstellung im Museum."',
    ),
    ReadingQuestion(
      question: 'Warum will Jan um drei Uhr gehen?',
      questionTranslation: 'Why does Jan want to go at three?',
      options: [
        'weil es dann billiger ist',
        'weil es dann nicht so voll ist',
        'weil er später keine Zeit hat',
      ],
      optionsTranslation: [
        'because it’s cheaper then',
        'because it’s less crowded then',
        'because he has no time later',
      ],
      correctIndex: 1,
      explanation: '"… weil es dann nicht so voll ist."',
    ),
    ReadingQuestion(
      question: 'Wo wollen sie sich treffen?',
      questionTranslation: 'Where do they want to meet?',
      options: ['im Café', 'vor dem Museum', 'am Bahnhof'],
      optionsTranslation: [
        'in the café',
        'in front of the museum',
        'at the station',
      ],
      correctIndex: 1,
      explanation: '"Treffen wir uns vor dem Museum?"',
    ),
    ReadingQuestion(
      question: 'An welchem Tag soll die Verabredung sein?',
      questionTranslation: 'On which day should the meeting be?',
      options: ['am Freitag', 'am Samstag', 'am Sonntag'],
      optionsTranslation: ['on Friday', 'on Saturday', 'on Sunday'],
      correctIndex: 1,
      explanation: '"Hast du am Samstag Zeit? … Bis Samstag!"',
    ),
    ReadingQuestion(
      question: 'Was wollen sie nach der Ausstellung machen?',
      questionTranslation: 'What do they want to do after the exhibition?',
      options: ['einen Kaffee trinken', 'essen gehen', 'ins Kino gehen'],
      optionsTranslation: [
        'have a coffee',
        'go for a meal',
        'go to the cinema',
      ],
      correctIndex: 0,
      explanation: '"Danach trinken wir vielleicht einen Kaffee."',
    ),
  ],
  intro:
      'A voicemail making a plan — you only hear it. Listen for the activity, '
      'the reason (weil …) and the meeting place. Replay as needed.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Listen for weil',
      text:
          'The reason follows "weil …" with the verb at the end. That answers '
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
  intro:
      '**dass** (that) introduces a reported idea, and like weil it sends the '
      'verb to the end. Use it after verbs of thinking and saying.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'dass → verb last',
      text:
          '"Ich glaube, dass er recht __hat__." denken, glauben, wissen, '
          'hoffen, sagen all take dass-clauses.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'dass ≠ das',
      text:
          'das = the/that (article/relative); dass = that (conjunction). Two '
          's after a short vowel.',
    ),
  ],
  items: [
    qsi(
      'Ich glaube, dass er recht ____. (haben)',
      'hat',
      'I think that he is right.',
      'dass … hat',
    ),
    qsi(
      'Sie sagt, dass sie morgen ____. (kommen)',
      'kommt',
      'She says that she is coming tomorrow.',
      'dass … kommt',
    ),
    qsi(
      'Ich hoffe, dass das Wetter schön ____. (sein)',
      'ist',
      'I hope that the weather is nice.',
      'dass … ist',
    ),
    qsi(
      'Wir wissen, dass du viel ____. (arbeiten)',
      'arbeitest',
      'We know that you work a lot.',
      'dass … arbeitest',
    ),
    qsi(
      'Es ist gut, dass du gekommen ____. (sein)',
      'bist',
      "It's good that you came.",
      'dass … bist',
    ),
    qsi(
      'Ich denke, dass Deutsch nicht so schwer ____. (sein)',
      'ist',
      'I think that German is not so hard.',
      'dass … ist (schwer)',
    ),
    qsi(
      'Er sagt, dass er keine Zeit ____. (haben)',
      'hat',
      'He says that he has no time.',
      'dass … hat (Zeit)',
    ),
    qsi(
      'Wir hoffen, dass ihr bald ____. (kommen)',
      'kommt',
      'We hope that you (all) come soon.',
      'dass … kommt (ihr)',
    ),
    qsi(
      'Ich weiß, dass du mir ____. (helfen)',
      'hilfst',
      'I know that you will help me.',
      'dass … hilfst',
    ),
    qsi(
      'Sie glaubt, dass wir zu viel ____. (arbeiten)',
      'arbeiten',
      'She thinks that we work too much.',
      'dass … arbeiten',
    ),
    qsi(
      'Es ist schade, dass du nicht kommen ____. (können)',
      'kannst',
      'It is a pity that you cannot come.',
      'dass … kannst',
    ),
    qsi(
      'Ich finde, dass das Essen gut ____. (schmecken)',
      'schmeckt',
      'I find that the food tastes good.',
      'dass … schmeckt',
    ),
    qsi(
      'Er hofft, dass das Wetter besser ____. (werden)',
      'wird',
      'He hopes that the weather gets better.',
      'dass … wird',
    ),
    qsi(
      'Wir wissen, dass sie viel Sport ____. (machen, sie Sg.)',
      'macht',
      'We know that she does a lot of sport.',
      'dass … macht',
    ),
    qsi(
      'Ich glaube, dass ich morgen frei ____. (haben)',
      'habe',
      'I think that I am free tomorrow.',
      'dass … habe (frei)',
    ),
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
  intro:
      'Body parts and being ill — essential for a visit to the doctor. Note '
      'the phrase "Ich habe … schmerzen" for aches.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'Saying what hurts',
      text:
          'Ich habe Kopfschmerzen / Bauchschmerzen / Halsschmerzen. Or: Mein '
          'Bein tut weh.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'At the doctor',
      text:
          'der Arzt (doctor), die Krankheit (illness), die Apotheke '
          '(pharmacy), das Medikament (medicine).',
    ),
  ],
  items: [
    qsi(
      'Ich habe ____ und nehme eine Tablette. (headache)',
      'Kopfschmerzen',
      'I have a headache and take a pill.',
      'headache',
    ),
    qsi(
      'Mein ____ tut weh, ich kann nicht laufen. (leg)',
      'Bein',
      'My leg hurts, I cannot walk.',
      'leg',
    ),
    qsi(
      'Der ____ untersucht den Patienten. (doctor)',
      'Arzt',
      'The doctor examines the patient.',
      'doctor',
    ),
    qsi(
      'Ich kaufe das Medikament in der ____. (pharmacy)',
      'Apotheke',
      'I buy the medicine at the pharmacy.',
      'pharmacy',
    ),
    qsi(
      'Ich bin ____ und bleibe im Bett. (ill)',
      'krank',
      'I am ill and stay in bed.',
      'ill',
    ),
    qsi(
      'Ich habe ____ — zu viel Schokolade! (stomach ache)',
      'Bauchschmerzen',
      'I have a stomach ache — too much chocolate!',
      'stomach ache',
    ),
    qsi(
      'Mein ____ tut weh, ich kann kaum sprechen. (throat)',
      'Hals',
      'My throat hurts, I can hardly speak.',
      'throat',
    ),
    qsi(
      'Ich habe 39 Grad — ich habe ____. (fever)',
      'Fieber',
      'I have a temperature of 39 — I have a fever.',
      'fever',
    ),
    qsi(
      'Der Arzt gibt mir ein ____ für Tabletten. (prescription)',
      'Rezept',
      'The doctor gives me a prescription for tablets.',
      'prescription',
    ),
    qsi(
      'Ich nehme ein ____ gegen die Schmerzen. (medicine)',
      'Medikament',
      'I take a medicine for the pain.',
      'medicine',
    ),
    qsi(
      'Ich sehe mit den ____. (eyes)',
      'Augen',
      'I see with my eyes.',
      'eyes',
    ),
    qsi(
      'Ich höre mit den ____. (ears)',
      'Ohren',
      'I hear with my ears.',
      'ears',
    ),
    qsi(
      'Ich schreibe mit der ____. (hand)',
      'Hand',
      'I write with my hand.',
      'hand',
    ),
    qsi(
      'Ich habe eine ____ und muss niesen. (a cold)',
      'Erkältung',
      'I have a cold and have to sneeze.',
      'a cold',
      accepted: ['Erkaeltung'],
    ),
    qsi(
      'Der ____ tut weh — die Musik war zu laut! (head)',
      'Kopf',
      'My head hurts — the music was too loud!',
      'head',
    ),
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
        'weil er ein Rezept braucht',
      ],
      optionsTranslation: [
        'because he doesn’t feel well',
        'for a check-up',
        'because he needs a prescription',
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
        'sofort ins Krankenhaus gehen',
      ],
      optionsTranslation: [
        'do sport',
        'drink a lot and stay in bed',
        'go to hospital immediately',
      ],
      correctIndex: 1,
      explanation: '"Sie müssen viel trinken und im Bett bleiben."',
    ),
    ReadingQuestion(
      question: 'Wie lange hat er schon Kopfschmerzen?',
      questionTranslation: 'How long has he had a headache?',
      options: ['seit einem Tag', 'seit drei Tagen', 'seit einer Woche'],
      optionsTranslation: ['for one day', 'for three days', 'for a week'],
      correctIndex: 1,
      explanation: '"Er hat seit drei Tagen Kopfschmerzen und Fieber."',
    ),
    ReadingQuestion(
      question: 'Wo holt Herr Berger die Tabletten?',
      questionTranslation: 'Where does Mr Berger pick up the tablets?',
      options: ['im Supermarkt', 'in der Apotheke', 'beim Arzt'],
      optionsTranslation: [
        'at the supermarket',
        'at the pharmacy',
        'at the doctor',
      ],
      correctIndex: 1,
      explanation: '"In der Apotheke holt er die Tabletten."',
    ),
  ],
  intro:
      'A scene at the doctor’s. It recycles the health vocabulary, weil, and '
      'modal verbs (müssen).',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'seit + time',
      text:
          '"seit drei Tagen" = for three days (and still). seit always takes '
          'the dative.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'The doctor’s advice',
      text:
          'Advice comes as "Sie müssen …" (you must) — a modal verb with the '
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
  intro:
      'The imperative gives commands, advice and instructions. It has three '
      'forms — du, ihr and Sie — and the verb comes first.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'du / ihr / Sie forms',
      text:
          'du: drop -st (du gehst → Geh!). ihr: like the present (Geht!). Sie: '
          'verb + Sie (Gehen Sie!).',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Stem-change a→ä drops',
      text:
          'fahren → Fahr! (no umlaut in du-imperative), but e→i stays: nehmen '
          '→ Nimm!, geben → Gib!',
    ),
  ],
  items: [
    qsi(
      '____ bitte langsamer! (sprechen, du)',
      'Sprich',
      'Speak more slowly, please!',
      'sprechen → Sprich!',
    ),
    qsi(
      '____ Sie hier, bitte. (warten, Sie)',
      'Warten',
      'Please wait here.',
      'warten → Warten Sie!',
    ),
    qsi(
      '____ mir bitte das Salz. (geben, du)',
      'Gib',
      'Pass me the salt, please.',
      'geben → Gib!',
    ),
    qsi(
      '____ leise, das Baby schläft! (sein, ihr)',
      'Seid',
      'Be quiet, the baby is sleeping!',
      'sein → Seid!',
    ),
    qsi(
      '____ viel Wasser! (trinken, du)',
      'Trink',
      'Drink lots of water!',
      'trinken → Trink!',
    ),
    qsi(
      '____ bitte das Fenster! (öffnen, du)',
      'Öffne',
      'Open the window, please!',
      'öffnen → Öffne!',
      accepted: ['Oeffne'],
    ),
    qsi(
      '____ Sie bitte langsam. (fahren, Sie)',
      'Fahren',
      'Please drive slowly.',
      'fahren → Fahren Sie!',
    ),
    qsi(
      '____ eure Hausaufgaben! (machen, ihr)',
      'Macht',
      'Do your homework!',
      'machen → Macht!',
    ),
    qsi(
      '____ ruhig, bitte! (sein, du)',
      'Sei',
      'Be calm, please!',
      'sein → Sei!',
    ),
    qsi(
      '____ den Bus, er kommt gleich! (nehmen, du)',
      'Nimm',
      'Take the bus, it is coming soon!',
      'nehmen → Nimm!',
    ),
    qsi(
      '____ Sie mir bitte die Rechnung. (bringen, Sie)',
      'Bringen',
      'Please bring me the bill.',
      'bringen → Bringen Sie!',
    ),
    qsi(
      '____ langsamer, Kinder! (laufen, ihr)',
      'Lauft',
      'Run more slowly, children!',
      'laufen → Lauft!',
    ),
    qsi(
      '____ mir bitte! (helfen, du)',
      'Hilf',
      'Help me, please!',
      'helfen → Hilf!',
    ),
    qsi(
      '____ keine Angst! (haben, du)',
      'Hab',
      "Don't be afraid!",
      'haben → Hab!',
      accepted: ['Habe'],
    ),
    qsi(
      '____ mehr Obst! (essen, du)',
      'Iss',
      'Eat more fruit!',
      'essen → Iss!',
    ),
  ],
);

/// 11. Diktat: Im Alltag.
final QuizContent questA22DiktatContent = dictationQuestQuiz(
  id: 'quest_a2_2_diktat_alltag',
  title: 'A2.2 · Diktat: Beschreiben',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro:
      'A dictation with two-way prepositions and subordinate clauses. You '
      'HEAR a sentence and TYPE it. Listen for the case after the preposition '
      'and the verb at the end of weil/dass clauses.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Wo or wohin?',
      text:
          'Location → dem/der; movement → den/die/das. Listen to the verb '
          '(liegt vs lege).',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Comma + verb last',
      text:
          'In "…, weil ich müde bin" the verb is the last word. Write it there.',
    ),
  ],
  sentences: const [
    SpeakPhrase(
      phrase: 'Das Buch liegt auf dem Tisch.',
      meaning: 'The book is on the table.',
    ),
    SpeakPhrase(
      phrase: 'Ich gehe heute nicht raus, weil es regnet.',
      meaning: "I'm not going out today because it's raining.",
    ),
    SpeakPhrase(
      phrase: 'Stell die Flasche in den Kühlschrank.',
      meaning: 'Put the bottle in the fridge.',
    ),
    SpeakPhrase(
      phrase: 'Ich glaube, dass sie recht hat.',
      meaning: 'I think that she is right.',
    ),
    SpeakPhrase(
      phrase: 'Die Lampe hängt über dem Bett.',
      meaning: 'The lamp hangs over the bed.',
    ),
    SpeakPhrase(
      phrase: 'Wir treffen uns vor dem Kino.',
      meaning: 'We meet in front of the cinema.',
    ),
    SpeakPhrase(
      phrase: 'Trink viel und bleib im Bett!',
      meaning: 'Drink a lot and stay in bed!',
    ),
    SpeakPhrase(
      phrase: 'Ich freue mich auf das Wochenende.',
      meaning: "I'm looking forward to the weekend.",
    ),
    SpeakPhrase(
      phrase: 'Er sagt, dass er müde ist.',
      meaning: 'He says that he is tired.',
    ),
    SpeakPhrase(
      phrase: 'Das Bild hängt an der Wand.',
      meaning: 'The picture hangs on the wall.',
    ),
    SpeakPhrase(
      phrase: 'Ich lege das Buch auf den Tisch.',
      meaning: 'I put the book on the table.',
    ),
    SpeakPhrase(
      phrase: 'Nimm bitte deine Tabletten!',
      meaning: 'Please take your tablets!',
    ),
    SpeakPhrase(phrase: 'Mein Hals tut weh.', meaning: 'My throat hurts.'),
    SpeakPhrase(
      phrase: 'Wir bleiben zu Hause, weil wir krank sind.',
      meaning: 'We stay at home because we are ill.',
    ),
    SpeakPhrase(
      phrase: 'Sie ist die beste Schülerin in der Klasse.',
      meaning: 'She is the best pupil in the class.',
    ),
  ],
);

/// 12. Sprechen: Personen beschreiben.
final QuizContent questA22SprechenPersonContent = speakQuestQuiz(
  id: 'quest_a2_2_sprechen_person',
  title: 'A2.2 · Sprechen: Personen beschreiben',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro:
      'Describe what people look like and what they are like. Listen and '
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
      phrase: 'Mein Freund heißt Paul.',
      meaning: 'My friend is called Paul.',
    ),
    SpeakPhrase(
      phrase: 'Er ist groß und schlank.',
      meaning: 'He is tall and slim.',
    ),
    SpeakPhrase(
      phrase: 'Er hat kurze, dunkle Haare.',
      meaning: 'He has short, dark hair.',
    ),
    SpeakPhrase(
      phrase: 'Er ist sehr freundlich und lustig.',
      meaning: 'He is very friendly and funny.',
    ),
    SpeakPhrase(
      phrase: 'Sie trägt eine Brille.',
      meaning: 'She wears glasses.',
    ),
    SpeakPhrase(
      phrase: 'Wie sieht deine Schwester aus?',
      meaning: 'What does your sister look like?',
    ),
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
  intro:
      'The superlative names the top of a group. The adverbial form is **am '
      '…-sten**: "Er läuft am schnellsten."',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'am …-sten',
      text:
          'schnell → am schnellsten, klein → am kleinsten. After -t/-d/-s add '
          '-esten: am ältesten.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Irregulars',
      text:
          'gut → am besten, viel → am meisten, gern → am liebsten, groß → am '
          'größten.',
    ),
  ],
  items: [
    qsi(
      'Der Elefant ist am ____. (groß)',
      'größten',
      'The elephant is the biggest.',
      'groß → am größten',
    ),
    qsi(
      'Im Winter sind die Tage am ____. (kurz)',
      'kürzesten',
      'In winter the days are shortest.',
      'kurz → am kürzesten',
    ),
    qsi(
      'Anna läuft am ____. (schnell)',
      'schnellsten',
      'Anna runs the fastest.',
      'schnell → am schnellsten',
    ),
    qsi(
      'Dieses Eis schmeckt am ____. (gut)',
      'besten',
      'This ice cream tastes the best.',
      'gut → am besten',
    ),
    qsi(
      'Ich trinke am ____ Wasser. (gern)',
      'liebsten',
      'I like drinking water the most.',
      'gern → am liebsten',
    ),
    qsi(
      'Der Mount Everest ist am ____. (hoch)',
      'höchsten',
      'Mount Everest is the highest.',
      'hoch → am höchsten',
      accepted: ['hoechsten'],
    ),
    qsi(
      'Mein Opa ist am ____ in der Familie. (alt)',
      'ältesten',
      'My grandpa is the oldest in the family.',
      'alt → am ältesten',
      accepted: ['aeltesten'],
    ),
    qsi(
      'Im Juli ist es am ____. (warm)',
      'wärmsten',
      'In July it is warmest.',
      'warm → am wärmsten',
      accepted: ['waermsten'],
    ),
    qsi(
      'Diese Übung ist am ____. (leicht)',
      'leichtesten',
      'This exercise is the easiest.',
      'leicht → am leichtesten',
    ),
    qsi(
      'Er isst am ____ von allen. (viel)',
      'meisten',
      'He eats the most of all.',
      'viel → am meisten',
    ),
    qsi(
      'Das Kino ist am ____ von hier. (weit)',
      'weitesten',
      'The cinema is the furthest from here.',
      'weit → am weitesten',
    ),
    qsi(
      'Der Januar ist am ____. (kalt)',
      'kältesten',
      'January is the coldest.',
      'kalt → am kältesten',
      accepted: ['kaeltesten'],
    ),
    qsi(
      'Dieses Auto fährt am ____. (langsam)',
      'langsamsten',
      'This car drives the slowest.',
      'langsam → am langsamsten',
    ),
    qsi(
      'Das Sofa ist am ____. (bequem)',
      'bequemsten',
      'The sofa is the most comfortable.',
      'bequem → am bequemsten',
    ),
    qsi(
      'Die Bäckerei ist am ____. (nah)',
      'nächsten',
      'The bakery is the nearest.',
      'nah → am nächsten',
      accepted: ['naechsten'],
    ),
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
        'weil der Aufzug kaputt ist',
      ],
      optionsTranslation: [
        'because it’s healthier',
        'because there is no lift',
        'because the lift is broken',
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
    ReadingQuestion(
      question: 'In welchem Stock liegt die Wohnung?',
      questionTranslation: 'On which floor is the flat?',
      options: ['im zweiten Stock', 'im vierten Stock', 'im Erdgeschoss'],
      optionsTranslation: [
        'on the second floor',
        'on the fourth floor',
        'on the ground floor',
      ],
      correctIndex: 1,
      explanation: '"… weil sie im vierten Stock liegt."',
    ),
    ReadingQuestion(
      question: 'Welches Zimmer findet Marie am schönsten?',
      questionTranslation: 'Which room does Marie find the nicest?',
      options: ['das Wohnzimmer', 'das Schlafzimmer', 'die Küche'],
      optionsTranslation: ['the living room', 'the bedroom', 'the kitchen'],
      correctIndex: 1,
      explanation: '"Das Schlafzimmer ist am schönsten."',
    ),
  ],
  intro:
      'A friendly email. It uses weil, deshalb and the superlative — a good '
      'review of this level’s grammar in a real text type.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Email frame',
      text:
          'Lieber/Liebe … (Dear) opens; Viele Grüße (best wishes) closes. '
          'Useful to recognise and to write.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'weil vs deshalb',
      text:
          'weil + reason (verb last); deshalb + result (verb second). Both '
          'appear here.',
    ),
  ],
);

/// Big text (inline cloze) — Mein Zimmer: the Wechselpräpositionen in action.
/// First the learner locates things (Wo? → Dativ), then tidies up and moves
/// them (Wohin? → Akkusativ), so the case flips inside one passage exactly where
/// the meaning flips — the clearest way to feel the two-way prepositions.
final QuizContent questA22BigTextZimmerContent = bigTextQuestQuiz(
  id: 'quest_a2_2_bigtext_zimmer',
  title: 'A2.2 · Großer Text: Mein Zimmer',
  passageTitle: 'Mein Zimmer',
  template:
      'Mein Zimmer ist klein. Das Bett steht an {{0}} Wand. Über {{1}} Bett '
      'hängt ein Poster. Der Schreibtisch steht vor {{2}} Fenster. Jetzt räume '
      'ich auf: Ich lege die Bücher auf {{3}} Regal. Ich hänge die Jacke in '
      '{{4}} Schrank. Ich stelle die Lampe auf {{5}} Tisch. Dann setze ich mich '
      'auf {{6}} Sofa und lege das Handy neben {{7}} Bett.',
  blanks: [
    inputBlank('der', hint: 'Wo? → Dativ · die Wand'),
    inputBlank('dem', hint: 'Wo? → Dativ · das Bett'),
    inputBlank('dem', hint: 'Wo? → Dativ · das Fenster'),
    inputBlank('das', hint: 'Wohin? → Akk · das Regal'),
    inputBlank('den', hint: 'Wohin? → Akk · der Schrank'),
    inputBlank('den', hint: 'Wohin? → Akk · der Tisch'),
    inputBlank('das', hint: 'Wohin? → Akk · das Sofa'),
    inputBlank('das', hint: 'Wohin? → Akk · das Bett'),
  ],
  passageTranslation:
      'My room is small. The bed stands against the wall. A poster hangs above '
      'the bed. The desk stands in front of the window. Now I tidy up: I put the '
      'books on the shelf. I hang the jacket in the wardrobe. I put the lamp on '
      'the table. Then I sit down on the sofa and put the phone next to the bed.',
  intro:
      'The nine two-way prepositions (an, auf, in, über, vor, neben …) take '
      'the DATIVE for a location (Wo?) and the ACCUSATIVE for a movement '
      '(Wohin?). Watch the verb: stehen/hängen/liegen = Wo?, legen/stellen/'
      'hängen(+obj) = Wohin?',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Movement → Akkusativ',
      text:
          'The cat sits ON the box (auf der Box, Dat) vs jumps ONTO the box '
          '(auf die Box, Akk). An arrow of movement points to the accusative.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'The verb gives it away',
      text:
          'stehen, liegen, hängen (be in a place) → Dativ. legen, stellen, '
          'setzen, hängen (put somewhere) → Akkusativ.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Same preposition, two cases',
      text:
          'in/an/auf don’t pick a fixed case like für or mit — they switch, '
          'so you must read the sentence, not just the preposition.',
    ),
  ],
);

/// Every A2.2 quiz, in chain order — all five exercise types, interleaved.

/// Speaking: the learner runs this conversation in their own AI
/// assistant and enters the score it gives (see `SpeakingQuizPage`).
final QuizContent questSpeakingPlaeneContent = speakingQuestQuiz(
  id: 'quest_a2_2_sprechen_dialog',
  title: 'A2.2 · Gespräch: Beschreiben & Planen',
  level: 'A2.2',
  topic:
      'Describing a place I know and planning something: where things are, where they go, and why I want to do what I plan.',
  practisePoints: [
    'Wo? + dative vs Wohin? + accusative',
    'weil and dass with the verb at the end',
    'TeKaMoLo order: time before manner before place',
  ],
  targetVocabulary: ['auf', 'in', 'neben', 'weil', 'dass', 'deshalb'],
  scoringCriteria: [
    'dative for a location, accusative for movement',
    'the verb at the end after weil/dass',
    'the order of time, manner and place',
  ],
  priorityErrors: [
    'wrong case after a two-way preposition',
    'verb not at the end in a subordinate clause',
    'wrong word order',
  ],
  intro:
      'The app does not run this conversation. Copy the exercise, paste it into your own AI assistant, turn on its voice mode, and say "Los geht\'s" to start. It grades you at the end - bring that score back here.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Let it be a conversation',
      text:
          'Answer in full sentences and let the tutor react. It will not correct you while you talk - every correction comes at the end, with your score.',
    ),
  ],
);

/// Mid-level speaking checkpoint: a shorter, question-driven run over the
/// first half of this sub-level. The closing Gespräch covers the level as
/// a whole.
final QuizContent questSpeakingCheckA22Content = speakingQuestQuiz(
  id: 'quest_a2_2_sprechen_kurzcheck',
  title: 'A2.2 · Kurzcheck: Wo oder wohin?',
  level: 'A2.2',
  topic: 'Where things are in the room I am in, and where they are going.',
  practisePoints: [
    'Wo? + dative for a location',
    'Wohin? + accusative for movement',
    'The article after the preposition',
  ],
  targetVocabulary: ['auf', 'in', 'neben', 'unter', 'stellen'],
  scoringCriteria: [
    'dative for a location',
    'accusative for movement',
    'the article after the preposition',
  ],
  priorityErrors: ['wrong case after a two-way preposition', 'wrong article'],
  mode: SpeakingMode.interview,
  session: SpeakingSession(durationMinutes: 3, minExchanges: 6),
  report: SpeakingReport(maxWords: 150, maxCorrections: 3),
  intro:
      'A short checkpoint on the first half of this level. Copy it into your own AI assistant, turn on voice mode, and answer - about three minutes.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'A short checkpoint, not an exam',
      text:
          'Three minutes is enough. Answer in full sentences and let the tutor move on - it saves every correction for the report at the end.',
    ),
  ],
);

final List<QuizContent> questA2_2Content = [
  questA22WechselWoContent, //        Wechselpräp.: Wo?      (knowledge)
  questA22WechselWohinContent, //     Wechselpräp.: Wohin?   (knowledge)
  questA22BigTextZimmerContent, //    Großer Text: Mein Zimmer (reading·cloze)
  questA22SprechenZimmerContent, //   Sprechen: Mein Zimmer  (speaking)
  questA22ReflexivContent, //         Reflexive Verben       (knowledge·verb)
  questA22WeilContent, //             Nebensatz: weil        (knowledge)
  questA22HoerenVerabredungContent, // Hören: Verabredung    (listening)
  questA22DassContent, //             Nebensatz: dass        (knowledge)
  questSpeakingCheckA22Content, // Kurzcheck mit einer KI (speaking·AI)
  questA22GesundheitContent, //       Körper & Gesundheit    (knowledge)
  questA22LesenArztContent, //        Lesen: Beim Arzt       (reading)
  questA22ImperativContent, //        Imperativ              (knowledge·verb)
  questA22DiktatContent, //           Diktat: Beschreiben    (dictation)
  questA22SprechenPersonContent, //   Sprechen: Personen     (speaking)
  questA22SuperlativContent, //       Superlativ             (knowledge)
  questA22LesenEmailContent, //       Lesen: Eine E-Mail     (reading)
  questSpeakingPlaeneContent, // Gespräch mit einer KI  (speaking·AI)
];
