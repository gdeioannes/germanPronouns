import '../../models/quiz_content.dart';
import 'quest_builders.dart';

/// CEFR **B1.2 — "Erzählen & Begründen"** Quest quizzes (Goethe B1). Big rocks:
/// the **Präteritum** (narrative past), the **werden-Passiv**, the
/// **n-Deklination**, infinitive clauses (um…zu) and relative clauses in the
/// dative/genitive.

/// 1. Technik & Medien (vocab).
final QuizContent questB12TechnikContent = sentenceQuestQuiz(
  id: 'quest_b1_2_technik',
  title: 'B1.2 · Technik & Medien',
  promptLabel: 'Wort',
  subjectsLabel: 'Technik',
  subjectColumnLabel: 'English',
  categoryLabel: 'Technik',
  contextualLayout: true,
  intro:
      'Technology and media vocabulary for B1. Note "aktuell" = current (not '
      '"actual") — a classic false friend.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'False friend: aktuell',
      text:
          '"aktuell" = current/up-to-date, NOT "actual". "die aktuellen '
          'Nachrichten" = the current news.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Useful words',
      text:
          'herunterladen (download), speichern (save), die Nachricht '
          '(message/news), das Gerät (device).',
    ),
  ],
  items: [
    qsi(
      'Ich muss die Datei noch ____. (save)',
      'speichern',
      'I still have to save the file.',
      'save',
    ),
    qsi(
      'Kannst du die App ____? (download)',
      'herunterladen',
      'Can you download the app?',
      'download',
    ),
    qsi(
      'Ich habe dir eine ____ geschickt. (message)',
      'Nachricht',
      'I sent you a message.',
      'message',
    ),
    qsi(
      'Mein neues ____ ist sehr schnell. (device)',
      'Gerät',
      'My new device is very fast.',
      'device',
    ),
    qsi(
      'Ich lese die ____ Nachrichten online. (current)',
      'aktuellen',
      'I read the current news online.',
      'current',
    ),
    qsi(
      'Der ____ von meinem Laptop ist kaputt. (screen)',
      'Bildschirm',
      'The screen of my laptop is broken.',
      'screen',
    ),
    qsi(
      'Ich habe mein ____ schon wieder vergessen. (password)',
      'Passwort',
      'I have forgotten my password again.',
      'password',
    ),
    qsi(
      'Kannst du das Dokument bitte ____? (print)',
      'drucken',
      'Can you print the document, please?',
      'print',
    ),
    qsi(
      'Das ____ im Hotel ist kostenlos. (Wi-Fi)',
      'WLAN',
      'The Wi-Fi at the hotel is free.',
      'Wi-Fi',
    ),
    qsi(
      'Mein ____ ist fast leer — wo ist das Ladekabel? (battery)',
      'Akku',
      'My battery is almost empty — where is the charger?',
      'battery',
    ),
    qsi(
      'Ich schreibe dir morgen eine ____. (e-mail)',
      'E-Mail',
      'I will write you an e-mail tomorrow.',
      'e-mail',
    ),
    qsi(
      'Du musst nur auf den Link ____. (click)',
      'klicken',
      'You just have to click on the link.',
      'click',
    ),
    qsi(
      'Ich muss die Fotos noch ____. (upload)',
      'hochladen',
      'I still have to upload the photos.',
      'upload',
    ),
    qsi(
      'Ich schalte den Computer am Abend ____. (off)',
      'aus',
      'I switch the computer off in the evening.',
      'switch off (aus)',
    ),
    qsi(
      'Diese ____ hat viele gute Informationen. (website)',
      'Webseite',
      'This website has a lot of good information.',
      'website',
    ),
  ],
);

/// 2. Präteritum: regelmäßig.
final QuizContent questB12PraetRegContent = sentenceQuestQuiz(
  id: 'quest_b1_2_praet_reg',
  title: 'B1.2 · Präteritum: regelmäßig',
  promptLabel: 'Präteritum',
  subjectsLabel: 'Verben',
  subjectColumnLabel: 'Infinitiv',
  categoryLabel: 'Präteritum',
  intro:
      'The **Präteritum** is the written/narrative past — used in stories, '
      'reports and novels. Regular verbs insert **-te-**: machen → machte.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'stem + -te + ending',
      text:
          'ich machte, du machtest, er machte, wir machten … "Gestern '
          '__arbeitete__ ich lange."',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Speech vs writing',
      text:
          'In speech most verbs use the Perfekt; in writing the Präteritum. '
          'But sein/haben/modals use Präteritum even in speech.',
    ),
  ],
  items: [
    qsi(
      'Er ____ das ganze Wochenende. (arbeiten)',
      'arbeitete',
      'He worked the whole weekend.',
      'arbeiten → arbeitete',
    ),
    qsi(
      'Wir ____ in einem kleinen Dorf. (wohnen)',
      'wohnten',
      'We lived in a small village.',
      'wohnen → wohnten',
    ),
    qsi(
      'Sie ____ jeden Tag neue Vokabeln. (lernen)',
      'lernte',
      'She learned new vocabulary every day.',
      'lernen → lernte',
    ),
    qsi(
      'Ich ____ ihm einen Brief. (schicken → schickte)',
      'schickte',
      'I sent him a letter.',
      'schicken → schickte',
    ),
    qsi(
      'Das Kind ____ laut. (lachen)',
      'lachte',
      'The child laughed loudly.',
      'lachen → lachte',
    ),
    qsi(
      'Die Kinder ____ im Garten. (spielen)',
      'spielten',
      'The children played in the garden.',
      'spielen → spielten',
    ),
    qsi(
      'Sie ____ ein neues Kleid. (kaufen)',
      'kaufte',
      'She bought a new dress.',
      'kaufen → kaufte',
    ),
    qsi(
      'Er ____ mich nach dem Weg. (fragen)',
      'fragte',
      'He asked me the way.',
      'fragen → fragte',
    ),
    qsi(
      'Wir ____ die ganze Nacht Musik. (hören)',
      'hörten',
      'We listened to music all night.',
      'hören → hörten',
    ),
    qsi(
      'Ich ____ schnell meine Hausaufgaben. (machen)',
      'machte',
      'I quickly did my homework.',
      'machen → machte',
    ),
    qsi(
      'Sie ____ eine Stunde auf den Bus. (warten)',
      'wartete',
      'She waited an hour for the bus.',
      'warten → wartete',
    ),
    qsi(
      'Er ____ langsam die Tür. (öffnen)',
      'öffnete',
      'He slowly opened the door.',
      'öffnen → öffnete',
      accepted: ['oeffnete'],
    ),
    qsi(
      'Meine Mutter ____ eine Suppe. (kochen)',
      'kochte',
      'My mother cooked a soup.',
      'kochen → kochte',
    ),
    qsi(
      'Wir ____ lange über das Problem. (reden)',
      'redeten',
      'We talked about the problem for a long time.',
      'reden → redeten',
    ),
    qsi(
      'Der Film ____ zwei Stunden. (dauern)',
      'dauerte',
      'The film lasted two hours.',
      'dauern → dauerte',
    ),
  ],
);

/// 3. Präteritum: unregelmäßig.
final QuizContent questB12PraetUnregContent = sentenceQuestQuiz(
  id: 'quest_b1_2_praet_unreg',
  title: 'B1.2 · Präteritum: unregelmäßig',
  promptLabel: 'Präteritum',
  subjectsLabel: 'Verben',
  subjectColumnLabel: 'Infinitiv',
  categoryLabel: 'Präteritum (stark)',
  intro:
      'Strong verbs change their stem vowel in the Präteritum (gehen → ging) '
      'and add no -te. There is no ending in the ich/er form. Learn the common '
      'ones by heart.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'No ending for ich/er',
      text:
          'ich ging, du gingst, er ging, wir gingen … The ich and er forms are '
          'identical.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Frequent strong verbs',
      text:
          'gehen→ging, kommen→kam, sehen→sah, finden→fand, geben→gab, '
          'fahren→fuhr, nehmen→nahm.',
    ),
  ],
  items: [
    qsi('Er ____ nach Hause. (gehen)', 'ging', 'He went home.', 'gehen → ging'),
    qsi(
      'Sie ____ spät an. (kommen → kam)',
      'kam',
      'She arrived late.',
      'kommen → kam',
    ),
    qsi(
      'Ich ____ ein Licht im Fenster. (sehen → sah)',
      'sah',
      'I saw a light in the window.',
      'sehen → sah',
    ),
    qsi(
      'Wir ____ den Schlüssel nicht. (finden → fanden)',
      'fanden',
      'We didn’t find the key.',
      'finden → fanden',
    ),
    qsi(
      'Er ____ mir das Buch. (geben → gab)',
      'gab',
      'He gave me the book.',
      'geben → gab',
    ),
    qsi(
      'Wir ____ mit dem Zug nach Wien. (fahren → fuhr)',
      'fuhren',
      'We went to Vienna by train.',
      'fahren → fuhren',
    ),
    qsi(
      'Er ____ den letzten Bus. (nehmen → nahm)',
      'nahm',
      'He took the last bus.',
      'nehmen → nahm',
    ),
    qsi(
      'Sie ____ nur einen Salat. (essen → aß)',
      'aß',
      'She only ate a salad.',
      'essen → aß',
      accepted: ['ass'],
    ),
    qsi(
      'Ich ____ eine Tasse Tee. (trinken → trank)',
      'trank',
      'I drank a cup of tea.',
      'trinken → trank',
    ),
    qsi(
      'Er ____ ihr einen langen Brief. (schreiben → schrieb)',
      'schrieb',
      'He wrote her a long letter.',
      'schreiben → schrieb',
    ),
    qsi(
      'Sie ____ das Buch in zwei Tagen. (lesen → las)',
      'las',
      'She read the book in two days.',
      'lesen → las',
    ),
    qsi(
      'Das Baby ____ zehn Stunden. (schlafen → schlief)',
      'schlief',
      'The baby slept for ten hours.',
      'schlafen → schlief',
    ),
    qsi(
      'Wir ____ bis Mitternacht. (bleiben → blieb)',
      'blieben',
      'We stayed until midnight.',
      'bleiben → blieben',
    ),
    qsi(
      'Es ____ langsam dunkel. (werden → wurde)',
      'wurde',
      'It slowly got dark.',
      'werden → wurde',
    ),
    qsi(
      'Ich ____ die Antwort nicht. (wissen → wusste)',
      'wusste',
      'I did not know the answer.',
      'wissen → wusste',
    ),
  ],
);

/// 4. Sprechen: Eine Geschichte erzählen.
final QuizContent questB12SprechenGeschichteContent = speakQuestQuiz(
  id: 'quest_b1_2_sprechen_geschichte',
  title: 'B1.2 · Sprechen: Eine Geschichte erzählen',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro:
      'Tell a short story, using time connectors to order events. Listen and '
      'repeat.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Sequence words',
      text:
          'zuerst (first), dann (then), danach (afterwards), plötzlich '
          '(suddenly), am Ende (in the end).',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Set the scene',
      text:
          '"Es war einmal …" (once upon a time) and "Eines Tages …" (one day) '
          'open a story.',
    ),
  ],
  phrases: const [
    SpeakPhrase(phrase: 'Eines Tages', meaning: 'One day'),
    SpeakPhrase(
      phrase: 'Zuerst ging ich zum Bahnhof.',
      meaning: 'First I went to the station.',
    ),
    SpeakPhrase(
      phrase: 'Plötzlich hörte ich ein Geräusch.',
      meaning: 'Suddenly I heard a noise.',
    ),
    SpeakPhrase(
      phrase: 'Danach rief ich die Polizei.',
      meaning: 'Afterwards I called the police.',
    ),
    SpeakPhrase(
      phrase: 'Am Ende war alles gut.',
      meaning: 'In the end everything was fine.',
    ),
    SpeakPhrase(
      phrase: 'Das war ein echtes Abenteuer!',
      meaning: 'That was a real adventure!',
    ),
  ],
);

/// 5. Passiv Präsens (werden + Partizip II).
final QuizContent questB12PassivContent = sentenceQuestQuiz(
  id: 'quest_b1_2_passiv',
  title: 'B1.2 · Passiv (Präsens)',
  promptLabel: 'werden-Form',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'Passiv',
  intro:
      'The passive focuses on the action, not the doer. German builds it with '
      '**werden + Partizip II**: "Das Haus __wird__ __gebaut__."',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'werden + Partizip II',
      text:
          'werden is conjugated (wird/werden), the participle goes last. "Hier '
          '__wird__ Deutsch __gesprochen__."',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'werden ≠ sein',
      text:
          'Use werden for the passive, not sein. "Das Auto wird repariert" = '
          'is being repaired (action).',
    ),
  ],
  items: [
    qsi(
      'Hier ____ Deutsch gesprochen. (werden, es/man)',
      'wird',
      'German is spoken here.',
      'wird gesprochen',
    ),
    qsi(
      'Das Auto ____ gerade repariert. (werden)',
      'wird',
      'The car is being repaired.',
      'wird repariert',
    ),
    qsi(
      'Die Briefe ____ jeden Tag gebracht. (werden, Pl.)',
      'werden',
      'The letters are delivered every day.',
      'werden gebracht',
    ),
    qsi(
      'Das Problem ____ schnell gelöst. (werden)',
      'wird',
      'The problem is solved quickly.',
      'wird gelöst',
    ),
    qsi(
      'Die Häuser ____ neu gebaut. (werden, Pl.)',
      'werden',
      'The houses are being newly built.',
      'werden gebaut',
    ),
    qsi(
      'Die Pizza ____ frisch gebacken. (werden)',
      'wird',
      'The pizza is baked fresh.',
      'wird gebacken',
    ),
    qsi(
      'Die Zimmer ____ jeden Tag geputzt. (werden, Pl.)',
      'werden',
      'The rooms are cleaned every day.',
      'werden geputzt',
    ),
    qsi(
      'Der Müll ____ am Montag abgeholt. (werden)',
      'wird',
      'The rubbish is collected on Monday.',
      'wird abgeholt',
    ),
    qsi(
      'In der Schweiz ____ vier Sprachen gesprochen. (werden, Pl.)',
      'werden',
      'Four languages are spoken in Switzerland.',
      'werden gesprochen',
    ),
    qsi(
      'Das Essen ____ um sieben serviert. (werden)',
      'wird',
      'The food is served at seven.',
      'wird serviert',
    ),
    qsi(
      'Die Rechnungen ____ online bezahlt. (werden, Pl.)',
      'werden',
      'The bills are paid online.',
      'werden bezahlt',
    ),
    qsi(
      'Der Kuchen ____ mit Schokolade gemacht. (werden)',
      'wird',
      'The cake is made with chocolate.',
      'wird gemacht',
    ),
    qsi(
      'Die Tür ____ um acht Uhr geöffnet. (werden)',
      'wird',
      'The door is opened at eight.',
      'wird geöffnet',
    ),
    qsi(
      'Die Pakete ____ morgen geliefert. (werden, Pl.)',
      'werden',
      'The parcels will be delivered tomorrow.',
      'werden geliefert',
    ),
    qsi(
      'Das Lied ____ oft im Radio gespielt. (werden)',
      'wird',
      'The song is often played on the radio.',
      'wird gespielt',
    ),
  ],
);

/// 6. Hören: Eine Durchsage.
final QuizContent questB12HoerenDurchsageContent = listeningQuestQuiz(
  id: 'quest_b1_2_hoeren_durchsage',
  // Station announcer (no gendered cue) — cast as a male voice for variety.
  voiceGender: VoiceGender.male,
  title: 'B1.2 · Hören: Eine Durchsage',
  category: 'Travel',
  passageTitle: 'Durchsage am Bahnhof',
  passage:
      'Achtung, eine Durchsage für die Reisenden nach Frankfurt. Der ICE 521 hat '
      'heute leider zwanzig Minuten Verspätung. Der Zug fährt nicht von Gleis '
      'vier, sondern von Gleis sieben ab. Bitte beachten Sie die geänderte '
      'Information auf den Anzeigetafeln. Wir bitten um Ihr Verständnis und '
      'wünschen Ihnen eine gute Reise.',
  passageTranslation:
      'Attention, an announcement for travellers to Frankfurt. The ICE 521 is '
      'unfortunately twenty minutes late today. The train does not leave from '
      'platform four, but from platform seven. Please note the changed '
      'information on the display boards. We ask for your understanding and wish '
      'you a good journey.',
  questions: const [
    ReadingQuestion(
      question: 'Wie viel Verspätung hat der Zug?',
      questionTranslation: 'How late is the train?',
      options: ['zehn Minuten', 'zwanzig Minuten', 'eine Stunde'],
      optionsTranslation: ['ten minutes', 'twenty minutes', 'an hour'],
      correctIndex: 1,
      explanation: '"… zwanzig Minuten Verspätung."',
    ),
    ReadingQuestion(
      question: 'Von welchem Gleis fährt der Zug jetzt ab?',
      questionTranslation: 'Which platform does the train leave from now?',
      options: ['von Gleis vier', 'von Gleis sieben', 'von Gleis fünf'],
      optionsTranslation: ['platform four', 'platform seven', 'platform five'],
      correctIndex: 1,
      explanation: '"… sondern von Gleis sieben ab."',
    ),
    ReadingQuestion(
      question: 'Wohin fährt der Zug?',
      questionTranslation: 'Where does the train go?',
      options: ['nach München', 'nach Frankfurt', 'nach Hamburg'],
      optionsTranslation: ['to Munich', 'to Frankfurt', 'to Hamburg'],
      correctIndex: 1,
      explanation: '"… für die Reisenden nach Frankfurt."',
    ),
    ReadingQuestion(
      question: 'Was sollen die Reisenden beachten?',
      questionTranslation: 'What should the travellers note?',
      options: [
        'die Anzeigetafeln',
        'den Fahrplan im Zug',
        'die Ansage im Bus',
      ],
      optionsTranslation: [
        'the display boards',
        'the timetable on the train',
        'the announcement on the bus',
      ],
      correctIndex: 0,
      explanation:
          '"Bitte beachten Sie die … Information auf den Anzeigetafeln."',
    ),
    ReadingQuestion(
      question: 'Was wünscht die Durchsage den Reisenden?',
      questionTranslation: 'What does the announcement wish the travellers?',
      options: ['einen schönen Tag', 'eine gute Reise', 'viel Erfolg'],
      optionsTranslation: ['a nice day', 'a good journey', 'good luck'],
      correctIndex: 1,
      explanation: '"… wünschen Ihnen eine gute Reise."',
    ),
  ],
  intro:
      'A station announcement — you only hear it. Listen for the delay, the '
      'platform change and the destination. Replay as needed.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'nicht …, sondern …',
      text:
          '"nicht von Gleis vier, __sondern__ von Gleis sieben" corrects '
          'information — listen for the second part.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Numbers matter',
      text:
          'Delays and platform numbers are the key facts in any announcement.',
    ),
  ],
);

/// 7. Passiv Präteritum (wurde + Partizip II).
final QuizContent questB12PassivPraetContent = sentenceQuestQuiz(
  id: 'quest_b1_2_passiv_praet',
  title: 'B1.2 · Passiv (Präteritum)',
  promptLabel: 'wurde-Form',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'Passiv Präteritum',
  intro:
      'In the past, the passive uses **wurde + Partizip II**: "Das Haus '
      '__wurde__ 1990 __gebaut__."',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'wurde / wurden',
      text:
          'ich wurde, er wurde, wir wurden … + participle last. "Amerika '
          '__wurde__ 1492 __entdeckt__."',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Agent with "von"',
      text:
          'Add the doer with von + Dativ: "Das Bild __wurde von Picasso__ '
          'gemalt."',
    ),
  ],
  items: [
    qsi(
      'Das Haus ____ 1990 gebaut. (werden → wurde)',
      'wurde',
      'The house was built in 1990.',
      'wurde gebaut',
    ),
    qsi(
      'Amerika ____ 1492 entdeckt. (werden → wurde)',
      'wurde',
      'America was discovered in 1492.',
      'wurde entdeckt',
    ),
    qsi(
      'Die Briefe ____ gestern geschrieben. (werden → wurden, Pl.)',
      'wurden',
      'The letters were written yesterday.',
      'wurden geschrieben',
    ),
    qsi(
      'Der Dieb ____ schnell gefunden. (werden → wurde)',
      'wurde',
      'The thief was found quickly.',
      'wurde gefunden',
    ),
    qsi(
      'Das Konzert ____ leider abgesagt. (werden → wurde)',
      'wurde',
      'The concert was unfortunately cancelled.',
      'wurde abgesagt',
    ),
    qsi(
      'Der Brief ____ sofort geschickt. (werden → wurde)',
      'wurde',
      'The letter was sent immediately.',
      'wurde geschickt',
    ),
    qsi(
      'Die Fenster ____ gestern geputzt. (werden → wurden, Pl.)',
      'wurden',
      'The windows were cleaned yesterday.',
      'wurden geputzt',
    ),
    qsi(
      'Das Telefon ____ 1876 erfunden. (werden → wurde)',
      'wurde',
      'The telephone was invented in 1876.',
      'wurde erfunden',
    ),
    qsi(
      'Die Stadt ____ vor tausend Jahren gegründet. (werden → wurde)',
      'wurde',
      'The city was founded a thousand years ago.',
      'wurde gegründet',
    ),
    qsi(
      'Die Gäste ____ herzlich begrüßt. (werden → wurden, Pl.)',
      'wurden',
      'The guests were warmly welcomed.',
      'wurden begrüßt',
    ),
    qsi(
      'Das Museum ____ letztes Jahr renoviert. (werden → wurde)',
      'wurde',
      'The museum was renovated last year.',
      'wurde renoviert',
    ),
    qsi(
      'Die Bilder ____ teuer verkauft. (werden → wurden, Pl.)',
      'wurden',
      'The paintings were sold at a high price.',
      'wurden verkauft',
    ),
    qsi(
      'Der Fehler ____ schnell korrigiert. (werden → wurde)',
      'wurde',
      'The mistake was corrected quickly.',
      'wurde korrigiert',
    ),
    qsi(
      'Ich ____ zur Party eingeladen. (werden → wurde)',
      'wurde',
      'I was invited to the party.',
      'wurde eingeladen',
    ),
    qsi(
      'Die Straße ____ letzte Woche gesperrt. (werden → wurde)',
      'wurde',
      'The street was closed last week.',
      'wurde gesperrt',
    ),
  ],
);

/// 8. n-Deklination (weak masculine nouns).
final QuizContent questB12NDeklinationContent = sentenceQuestQuiz(
  id: 'quest_b1_2_n_deklination',
  title: 'B1.2 · n-Deklination',
  promptLabel: 'Form',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Nomen',
  categoryLabel: 'n-Deklination',
  intro:
      'A group of masculine nouns (often people and animals) add **-(e)n** in '
      'every case except the nominative singular: der Junge → den Jungen.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '-(e)n outside the nominative',
      text:
          'der Student → den/dem/des Studenten; der Junge → den Jungen; der '
          'Kollege → dem Kollegen.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Common n-nouns',
      text:
          'der Student, der Junge, der Kollege, der Mensch, der Nachbar, der '
          'Herr (→ den Herrn).',
    ),
  ],
  items: [
    qsi(
      'Ich kenne den ____. (der Student)',
      'Studenten',
      'I know the student.',
      'den Studenten',
    ),
    qsi(
      'Ich helfe dem ____. (der Junge)',
      'Jungen',
      'I help the boy.',
      'dem Jungen',
    ),
    qsi(
      'Das ist das Auto des ____. (der Kollege)',
      'Kollegen',
      'That is the colleague’s car.',
      'des Kollegen',
    ),
    qsi(
      'Wir sprechen mit dem ____. (der Nachbar)',
      'Nachbarn',
      'We talk to the neighbour.',
      'dem Nachbarn',
    ),
    qsi(
      'Ich sehe einen ____ auf der Straße. (der Mensch)',
      'Menschen',
      'I see a person in the street.',
      'einen Menschen',
    ),
    qsi(
      'Fragen Sie den ____ dort! (der Herr)',
      'Herrn',
      'Ask the gentleman over there!',
      'den Herrn',
    ),
    qsi(
      'Ich gebe dem ____ die Hand. (der Präsident)',
      'Präsidenten',
      'I shake the president\'s hand.',
      'dem Präsidenten',
    ),
    qsi(
      'Das Foto des ____ hängt im Flur. (der Junge)',
      'Jungen',
      'The photo of the boy hangs in the hall.',
      'des Jungen',
    ),
    qsi(
      'Wir besuchen einen wichtigen ____. (der Kunde)',
      'Kunden',
      'We visit an important customer.',
      'einen Kunden',
    ),
    qsi(
      'Der Zoo hat einen neuen ____. (der Elefant)',
      'Elefanten',
      'The zoo has a new elephant.',
      'einen Elefanten',
    ),
    qsi(
      'Ich spreche mit dem ____. (der Polizist)',
      'Polizisten',
      'I talk to the police officer.',
      'dem Polizisten',
    ),
    qsi(
      'Kennst du den ____ da drüben? (der Tourist)',
      'Touristen',
      'Do you know the tourist over there?',
      'den Touristen',
    ),
    qsi(
      'Wir sehen einen ____ im Zoo. (der Löwe)',
      'Löwen',
      'We see a lion at the zoo.',
      'einen Löwen',
      accepted: ['Loewen'],
    ),
    qsi(
      'Das Büro des ____ ist im ersten Stock. (der Experte)',
      'Experten',
      'The expert\'s office is on the first floor.',
      'des Experten',
    ),
    qsi(
      'Sie hilft dem ____ mit dem Formular. (der Patient)',
      'Patienten',
      'She helps the patient with the form.',
      'dem Patienten',
    ),
  ],
);

/// 9. Lesen: Ein technisches Missgeschick.
final QuizContent questB12LesenTechnikContent = readingQuestQuiz(
  id: 'quest_b1_2_lesen_technik',
  title: 'B1.2 · Lesen: Ein Missgeschick',
  category: 'Technology',
  passageTitle: 'Der verlorene Vortrag',
  passage:
      'Am Morgen seiner wichtigen Präsentation passierte Herrn Klein ein '
      'Missgeschick. Er schaltete den Computer ein, aber der Bildschirm blieb '
      'schwarz. Seine Präsentation war auf der Festplatte gespeichert, doch das '
      'Gerät startete nicht mehr. Zum Glück hatte ein Kollege eine Kopie auf '
      'einem USB-Stick. Die Datei wurde schnell geöffnet, und der Vortrag konnte '
      'doch noch beginnen. Seitdem speichert Herr Klein alles zweimal.',
  passageTranslation:
      'On the morning of his important presentation, a mishap happened to Mr '
      'Klein. He switched on the computer, but the screen stayed black. His '
      'presentation was saved on the hard drive, but the device wouldn’t start '
      'anymore. Luckily a colleague had a copy on a USB stick. The file was '
      'quickly opened, and the talk could begin after all. Since then Mr Klein '
      'saves everything twice.',
  questions: const [
    ReadingQuestion(
      question: 'Was war das Problem am Morgen?',
      questionTranslation: 'What was the problem in the morning?',
      options: [
        'Der Computer startete nicht.',
        'Er hatte verschlafen.',
        'Die Präsentation war zu lang.',
      ],
      optionsTranslation: [
        'The computer wouldn’t start.',
        'He had overslept.',
        'The presentation was too long.',
      ],
      correctIndex: 0,
      explanation:
          '"… der Bildschirm blieb schwarz … das Gerät startete nicht."',
    ),
    ReadingQuestion(
      question: 'Wie wurde das Problem gelöst?',
      questionTranslation: 'How was the problem solved?',
      options: [
        'Ein Kollege hatte eine Kopie auf einem USB-Stick.',
        'Er hielt den Vortrag ohne Folien.',
        'Die Präsentation wurde verschoben.',
      ],
      optionsTranslation: [
        'A colleague had a copy on a USB stick.',
        'He gave the talk without slides.',
        'The presentation was postponed.',
      ],
      correctIndex: 0,
      explanation: '"Zum Glück hatte ein Kollege eine Kopie …"',
    ),
    ReadingQuestion(
      question: 'Was macht Herr Klein seitdem?',
      questionTranslation: 'What does Mr Klein do since then?',
      options: [
        'Er benutzt keine Computer mehr.',
        'Er speichert alles zweimal.',
        'Er kommt immer zu spät.',
      ],
      optionsTranslation: [
        'He no longer uses computers.',
        'He saves everything twice.',
        'He’s always late.',
      ],
      correctIndex: 1,
      explanation: '"Seitdem speichert Herr Klein alles zweimal."',
    ),
    ReadingQuestion(
      question: 'Wo war die Präsentation gespeichert?',
      questionTranslation: 'Where was the presentation saved?',
      options: ['auf der Festplatte', 'auf einem USB-Stick', 'in der Cloud'],
      optionsTranslation: [
        'on the hard drive',
        'on a USB stick',
        'in the cloud',
      ],
      correctIndex: 0,
      explanation: '"Seine Präsentation war auf der Festplatte gespeichert …"',
    ),
    ReadingQuestion(
      question: 'Konnte der Vortrag am Ende beginnen?',
      questionTranslation: 'Could the talk begin in the end?',
      options: [
        'Ja, mit der Kopie vom USB-Stick.',
        'Nein, er fiel aus.',
        'Nein, er wurde verschoben.',
      ],
      optionsTranslation: [
        'Yes, with the copy from the USB stick.',
        'No, it was cancelled.',
        'No, it was postponed.',
      ],
      correctIndex: 0,
      explanation:
          '"Die Datei wurde schnell geöffnet, und der Vortrag konnte '
          'doch noch beginnen."',
    ),
  ],
  intro:
      'A short anecdote in the Präteritum, with a passive (Die Datei wurde '
      'geöffnet) and the genitive (seiner Präsentation).',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Problem → solution → lesson',
      text:
          'Anecdotes often follow this shape. The questions usually ask about '
          'each part.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'zum Glück',
      text:
          '"zum Glück" (luckily) signals the turning point — often the answer '
          'to "how was it solved?".',
    ),
  ],
);

/// 10. Infinitivsätze: um…zu / ohne…zu.
final QuizContent questB12InfinitivContent = sentenceQuestQuiz(
  id: 'quest_b1_2_infinitiv',
  title: 'B1.2 · Infinitivsätze: um…zu',
  promptLabel: 'zu-Form',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'um…zu / ohne…zu',
  intro:
      'To express purpose, German uses **um … zu + infinitive** (in order '
      'to). The infinitive goes to the end, after "zu".',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'um … zu = in order to',
      text:
          '"Ich lerne Deutsch, __um__ in Deutschland __zu arbeiten__." Same '
          'subject in both parts.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'ohne … zu / statt … zu',
      text:
          'ohne zu fragen (without asking), statt zu helfen (instead of '
          'helping).',
    ),
  ],
  items: [
    qsi(
      'Ich lerne Deutsch, um in Berlin zu ____. (arbeiten)',
      'arbeiten',
      'I learn German in order to work in Berlin.',
      'um … zu arbeiten',
    ),
    qsi(
      'Er ging früh, um den Zug zu ____. (erreichen)',
      'erreichen',
      'He left early to catch the train.',
      'um … zu erreichen',
    ),
    qsi(
      'Sie ging weg, ohne etwas zu ____. (sagen)',
      'sagen',
      'She left without saying anything.',
      'ohne … zu sagen',
    ),
    qsi(
      'Wir sparen Geld, um ein Haus zu ____. (kaufen)',
      'kaufen',
      'We save money to buy a house.',
      'um … zu kaufen',
    ),
    qsi(
      'Statt zu ____, schaute er fern. (lernen)',
      'lernen',
      'Instead of studying, he watched TV.',
      'statt … zu lernen',
    ),
    qsi(
      'Sie treibt Sport, um fit zu ____. (bleiben)',
      'bleiben',
      'She does sport in order to stay fit.',
      'um … zu bleiben',
    ),
    qsi(
      'Er nahm ein Taxi, um pünktlich zu ____. (sein)',
      'sein',
      'He took a taxi in order to be on time.',
      'um … zu sein',
    ),
    qsi(
      'Ich rufe an, um einen Termin zu ____. (vereinbaren)',
      'vereinbaren',
      'I am calling to arrange an appointment.',
      'um … zu vereinbaren',
    ),
    qsi(
      'Sie fuhr los, ohne sich zu ____. (verabschieden)',
      'verabschieden',
      'She left without saying goodbye.',
      'ohne … zu verabschieden',
    ),
    qsi(
      'Er kaufte das Handy, ohne den Preis zu ____. (vergleichen)',
      'vergleichen',
      'He bought the phone without comparing the price.',
      'ohne … zu vergleichen',
    ),
    qsi(
      'Statt zu ____, ging sie zu Fuß. (fahren)',
      'fahren',
      'Instead of driving, she walked.',
      'statt … zu fahren',
    ),
    qsi(
      'Wir sparen, um im Sommer zu ____. (verreisen)',
      'verreisen',
      'We save in order to travel in the summer.',
      'um … zu verreisen',
    ),
    qsi(
      'Ich brauche eine Brille, um besser zu ____. (sehen)',
      'sehen',
      'I need glasses in order to see better.',
      'um … zu sehen',
    ),
    qsi(
      'Er ging vorbei, ohne uns zu ____. (grüßen)',
      'grüßen',
      'He walked past without greeting us.',
      'ohne … zu grüßen',
      accepted: ['gruessen'],
    ),
    qsi(
      'Statt zu ____, hörte er Musik. (arbeiten)',
      'arbeiten',
      'Instead of working, he listened to music.',
      'statt … zu arbeiten',
    ),
  ],
);

/// 11. Diktat: Im Präteritum.
final QuizContent questB12DiktatContent = dictationQuestQuiz(
  id: 'quest_b1_2_diktat_praeteritum',
  title: 'B1.2 · Diktat: Eine kleine Geschichte',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro:
      'A dictation in the narrative past. You HEAR a sentence and TYPE it. '
      'Listen for the Präteritum forms (ging, kam, war) and the connectors.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Strong verbs',
      text: 'ging, kam, sah, fand are one-word past forms. Write them exactly.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Connectors start the clause',
      text:
          'After "Als …, …" or "Plötzlich …" the verb is in second position '
          'of the main clause.',
    ),
  ],
  sentences: const [
    SpeakPhrase(
      phrase: 'Eines Tages ging ich in den Wald.',
      meaning: 'One day I went into the forest.',
    ),
    SpeakPhrase(
      phrase: 'Plötzlich hörte ich ein Geräusch.',
      meaning: 'Suddenly I heard a noise.',
    ),
    SpeakPhrase(
      phrase: 'Ein kleiner Hund kam zu mir.',
      meaning: 'A small dog came to me.',
    ),
    SpeakPhrase(
      phrase: 'Er war hungrig und müde.',
      meaning: 'It was hungry and tired.',
    ),
    SpeakPhrase(
      phrase: 'Ich gab ihm etwas zu essen.',
      meaning: 'I gave it something to eat.',
    ),
    SpeakPhrase(
      phrase: 'Am Ende nahm ich ihn mit nach Hause.',
      meaning: 'In the end I took it home with me.',
    ),
    SpeakPhrase(
      phrase: 'Es war einmal ein kleines Mädchen.',
      meaning: 'Once upon a time there was a little girl.',
    ),
    SpeakPhrase(
      phrase: 'Sie wohnte am Rand des Waldes.',
      meaning: 'She lived at the edge of the forest.',
    ),
    SpeakPhrase(
      phrase: 'Als ich jung war, las ich viel.',
      meaning: 'When I was young, I read a lot.',
    ),
    SpeakPhrase(
      phrase: 'Wir fuhren jeden Sommer ans Meer.',
      meaning: 'Every summer we went to the sea.',
    ),
    SpeakPhrase(
      phrase: 'Der Zug kam pünktlich an.',
      meaning: 'The train arrived on time.',
    ),
    SpeakPhrase(
      phrase: 'Niemand wusste die Antwort.',
      meaning: 'Nobody knew the answer.',
    ),
    SpeakPhrase(
      phrase: 'Sie schrieb ihm jeden Tag einen Brief.',
      meaning: 'She wrote him a letter every day.',
    ),
    SpeakPhrase(
      phrase: 'Das Wetter wurde immer schlechter.',
      meaning: 'The weather got worse and worse.',
    ),
    SpeakPhrase(
      phrase: 'Am Abend saßen wir am Feuer.',
      meaning: 'In the evening we sat by the fire.',
    ),
  ],
);

/// 12. Relativsätze (Dativ/Genitiv).
final QuizContent questB12RelativDatContent = sentenceQuestQuiz(
  id: 'quest_b1_2_relativ_dat',
  title: 'B1.2 · Relativsätze (Dativ/Genitiv)',
  promptLabel: 'Relativpronomen',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'Relativpronomen',
  intro:
      'When the relative pronoun is a dative object or follows a preposition, '
      'it takes the dative (dem/der/dem/denen); the genitive uses dessen/deren.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Dative & genitive forms',
      text:
          'Dativ: dem/der/dem/denen. Genitiv: dessen (m/n), deren (f/Pl.). '
          '"der Mann, __dem__ ich helfe".',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Preposition pulls the case',
      text:
          '"das Haus, __in dem__ ich wohne" — the preposition decides the '
          'case (in + Dativ here).',
    ),
  ],
  items: [
    qsi(
      'Das ist der Mann, ____ ich helfe. (Dativ m)',
      'dem',
      'That is the man whom I help.',
      'dem (Dativ)',
    ),
    qsi(
      'Die Frau, ____ ich danke, ist meine Lehrerin. (Dativ f)',
      'der',
      'The woman I thank is my teacher.',
      'der (Dativ)',
    ),
    qsi(
      'Das ist das Haus, in ____ ich wohne. (Dativ n)',
      'dem',
      'That is the house I live in.',
      'in dem (Dativ)',
    ),
    qsi(
      'Das sind die Leute, ____ ich vertraue. (Dativ Pl.)',
      'denen',
      'Those are the people I trust.',
      'denen (Dativ Pl.)',
    ),
    qsi(
      'Der Mann, ____ Auto rot ist, wohnt hier. (Genitiv m)',
      'dessen',
      'The man whose car is red lives here.',
      'dessen (Genitiv)',
    ),
    qsi(
      'Der Freund, ____ ich das Buch leihe, ist krank. (Dativ m)',
      'dem',
      'The friend I lend the book to is ill.',
      'dem (leihen)',
    ),
    qsi(
      'Die Kollegin, mit ____ ich arbeite, ist nett. (mit + Dativ f)',
      'der',
      'The colleague I work with is nice.',
      'mit der',
    ),
    qsi(
      'Das Kind, ____ das Eis schmeckt, lacht. (Dativ n)',
      'dem',
      'The child who likes the ice cream laughs.',
      'dem (schmecken)',
    ),
    qsi(
      'Die Nachbarn, bei ____ wir wohnen, sind leise. (bei + Dativ Pl.)',
      'denen',
      'The neighbours we live with are quiet.',
      'bei denen',
    ),
    qsi(
      'Der Tisch, an ____ wir essen, ist sehr alt. (an + Dativ m)',
      'dem',
      'The table we eat at is very old.',
      'an dem',
    ),
    qsi(
      'Die Frau, ____ Hund bellt, wohnt oben. (Genitiv f)',
      'deren',
      'The woman whose dog barks lives upstairs.',
      'deren (Genitiv f)',
    ),
    qsi(
      'Die Stadt, in ____ ich geboren wurde, ist klein. (in + Dativ f)',
      'der',
      'The city I was born in is small.',
      'in der',
    ),
    qsi(
      'Der Kollege, von ____ ich erzählte, kommt morgen. (von + Dativ m)',
      'dem',
      'The colleague I told you about comes tomorrow.',
      'von dem',
    ),
    qsi(
      'Die Kinder, ____ Eltern arbeiten, essen in der Schule. (Genitiv Pl.)',
      'deren',
      'The children whose parents work eat at school.',
      'deren (Pl.)',
    ),
    qsi(
      'Das Dorf, aus ____ er kommt, liegt in Bayern. (aus + Dativ n)',
      'dem',
      'The village he comes from is in Bavaria.',
      'aus dem',
    ),
  ],
);

/// 13. Sprechen: Etwas begründen.
final QuizContent questB12SprechenBegruendenContent = speakQuestQuiz(
  id: 'quest_b1_2_sprechen_begruenden',
  title: 'B1.2 · Sprechen: Etwas begründen',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro:
      'Give reasons for your choices and opinions. Listen and repeat these '
      'cause-and-effect phrases.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'weil / denn / deshalb',
      text:
          'weil + verb last; denn + normal order; deshalb + verb second. All '
          'three link a reason and a result.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Justify a choice',
      text:
          '"Ich nehme das, weil es billiger ist." "Es ist spät, deshalb gehe '
          'ich."',
    ),
  ],
  phrases: const [
    SpeakPhrase(
      phrase: 'Ich nehme den Zug, weil er schneller ist.',
      meaning: 'I take the train because it’s faster.',
    ),
    SpeakPhrase(
      phrase: 'Es regnet, deshalb bleibe ich zu Hause.',
      meaning: 'It’s raining, so I’m staying home.',
    ),
    SpeakPhrase(
      phrase: 'Ich kann nicht kommen, denn ich bin krank.',
      meaning: 'I can’t come, because I’m ill.',
    ),
    SpeakPhrase(
      phrase: 'Der Grund dafür ist einfach.',
      meaning: 'The reason for it is simple.',
    ),
    SpeakPhrase(
      phrase: 'Das hat zwei Gründe.',
      meaning: 'There are two reasons for that.',
    ),
    SpeakPhrase(
      phrase: 'Deswegen bin ich anderer Meinung.',
      meaning: 'That’s why I disagree.',
    ),
  ],
);

/// 14. Hören: Ein Podcast-Ausschnitt.
final QuizContent questB12HoerenPodcastContent = listeningQuestQuiz(
  id: 'quest_b1_2_hoeren_podcast',
  title: 'B1.2 · Hören: Podcast',
  category: 'Media',
  passageTitle: 'Podcast: Weniger Stress',
  passage:
      'Willkommen zu unserem Podcast über ein gesundes Leben. Heute geht es um '
      'Stress. Viele Menschen fühlen sich gestresst, weil sie zu viel arbeiten '
      'und zu wenig schlafen. Unser Tipp: Machen Sie jeden Tag eine kurze Pause '
      'und gehen Sie an die frische Luft. Auch Sport hilft, denn dabei wird '
      'Stress abgebaut. Schon zwanzig Minuten pro Tag können viel verändern.',
  passageTranslation:
      'Welcome to our podcast about a healthy life. Today it’s about stress. '
      'Many people feel stressed because they work too much and sleep too '
      'little. Our tip: take a short break every day and get some fresh air. '
      'Sport also helps, because it reduces stress. Even twenty minutes a day '
      'can change a lot.',
  questions: const [
    ReadingQuestion(
      question: 'Worum geht es heute im Podcast?',
      questionTranslation: 'What is today’s podcast about?',
      options: ['um Ernährung', 'um Stress', 'um Schlafprobleme'],
      optionsTranslation: [
        'about nutrition',
        'about stress',
        'about sleep problems',
      ],
      correctIndex: 1,
      explanation: '"Heute geht es um Stress."',
    ),
    ReadingQuestion(
      question: 'Welchen Tipp gibt der Podcast?',
      questionTranslation: 'What tip does the podcast give?',
      options: [
        'jeden Tag eine Pause machen',
        'mehr Kaffee trinken',
        'länger arbeiten',
      ],
      optionsTranslation: [
        'take a break every day',
        'drink more coffee',
        'work longer',
      ],
      correctIndex: 0,
      explanation: '"… machen Sie jeden Tag eine kurze Pause …"',
    ),
    ReadingQuestion(
      question: 'Wie viele Minuten Sport pro Tag reichen schon?',
      questionTranslation: 'How many minutes of sport a day is already enough?',
      options: ['zehn Minuten', 'zwanzig Minuten', 'eine Stunde'],
      optionsTranslation: ['ten minutes', 'twenty minutes', 'an hour'],
      correctIndex: 1,
      explanation: '"Schon zwanzig Minuten pro Tag …"',
    ),
    ReadingQuestion(
      question: 'Warum fühlen sich viele Menschen gestresst?',
      questionTranslation: 'Why do many people feel stressed?',
      options: [
        'weil sie zu viel arbeiten und zu wenig schlafen',
        'weil sie zu viel Sport machen',
        'weil sie keine Hobbys haben',
      ],
      optionsTranslation: [
        'because they work too much and sleep too little',
        'because they do too much sport',
        'because they have no hobbies',
      ],
      correctIndex: 0,
      explanation: '"… weil sie zu viel arbeiten und zu wenig schlafen."',
    ),
    ReadingQuestion(
      question: 'Was passiert beim Sport laut Podcast?',
      questionTranslation:
          'What happens during sport according to the podcast?',
      options: [
        'Stress wird abgebaut.',
        'Man schläft schlechter.',
        'Man wird hungrig.',
      ],
      optionsTranslation: [
        'Stress is reduced.',
        'You sleep worse.',
        'You get hungry.',
      ],
      correctIndex: 0,
      explanation: '"… denn dabei wird Stress abgebaut."',
    ),
  ],
  intro:
      'A short podcast clip — you only hear it. Listen for the topic, the tip '
      'and the number. Replay as needed.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Es geht um …',
      text: '"Es geht um …" announces the topic — the first thing to catch.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Passive in the wild',
      text:
          '"… wird Stress abgebaut" is a passive: stress is reduced. A natural '
          'B1.2 callback.',
    ),
  ],
);

/// 15. Lesen: Eine wahre Anekdote.
final QuizContent questB12LesenAnekdoteContent = readingQuestQuiz(
  id: 'quest_b1_2_lesen_anekdote',
  title: 'B1.2 · Lesen: Eine wahre Anekdote',
  category: 'Daily Life',
  passageTitle: 'Der ehrliche Finder',
  passage:
      'Letzte Woche fand ein Junge auf dem Weg zur Schule eine Brieftasche. '
      'Darin waren dreihundert Euro und ein Ausweis. Viele Kinder hätten das '
      'Geld vielleicht behalten, aber der Junge brachte die Brieftasche sofort '
      'zur Polizei. Der Besitzer war sehr glücklich und wollte sich bedanken. '
      'Er bot dem Jungen fünfzig Euro an, doch der Junge nahm das Geld nicht. '
      '"Ehrlichkeit ist wichtiger als Geld", sagte er.',
  passageTranslation:
      'Last week a boy found a wallet on his way to school. Inside were three '
      'hundred euros and an ID card. Many children might have kept the money, '
      'but the boy took the wallet straight to the police. The owner was very '
      'happy and wanted to thank him. He offered the boy fifty euros, but the '
      'boy did not take the money. "Honesty is more important than money," he '
      'said.',
  questions: const [
    ReadingQuestion(
      question: 'Was fand der Junge?',
      questionTranslation: 'What did the boy find?',
      options: ['ein Handy', 'eine Brieftasche', 'einen Schlüssel'],
      optionsTranslation: ['a phone', 'a wallet', 'a key'],
      correctIndex: 1,
      explanation: '"… fand ein Junge … eine Brieftasche."',
    ),
    ReadingQuestion(
      question: 'Was machte der Junge mit der Brieftasche?',
      questionTranslation: 'What did the boy do with the wallet?',
      options: [
        'Er behielt das Geld.',
        'Er brachte sie zur Polizei.',
        'Er gab sie einem Freund.',
      ],
      optionsTranslation: [
        'He kept the money.',
        'He took it to the police.',
        'He gave it to a friend.',
      ],
      correctIndex: 1,
      explanation: '"… brachte die Brieftasche sofort zur Polizei."',
    ),
    ReadingQuestion(
      question: 'Warum nahm er die fünfzig Euro nicht?',
      questionTranslation: 'Why didn’t he take the fifty euros?',
      options: [
        'Ehrlichkeit ist ihm wichtiger als Geld.',
        'Er hatte genug Geld.',
        'Der Besitzer war zu arm.',
      ],
      optionsTranslation: [
        'Honesty is more important to him than money.',
        'He had enough money.',
        'The owner was too poor.',
      ],
      correctIndex: 0,
      explanation: '"Ehrlichkeit ist wichtiger als Geld."',
    ),
    ReadingQuestion(
      question: 'Wie viel Geld war in der Brieftasche?',
      questionTranslation: 'How much money was in the wallet?',
      options: ['dreißig Euro', 'dreihundert Euro', 'dreitausend Euro'],
      optionsTranslation: [
        'thirty euros',
        'three hundred euros',
        'three thousand euros',
      ],
      correctIndex: 1,
      explanation: '"Darin waren dreihundert Euro und ein Ausweis."',
    ),
    ReadingQuestion(
      question: 'Wie viel bot der Besitzer dem Jungen an?',
      questionTranslation: 'How much did the owner offer the boy?',
      options: ['fünf Euro', 'fünfzig Euro', 'fünfhundert Euro'],
      optionsTranslation: ['five euros', 'fifty euros', 'five hundred euros'],
      correctIndex: 1,
      explanation: '"Er bot dem Jungen fünfzig Euro an …"',
    ),
  ],
  intro:
      'A true little story in the Präteritum, with a hint of Konjunktiv II '
      '(hätten … behalten) and the comparative (wichtiger als).',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Follow the actions',
      text:
          'fand → brachte → bot an → nahm nicht. The chain of verbs tells the '
          'story.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'The moral last',
      text:
          'The point often comes in the final quoted sentence — a good place '
          'to look for the "why?" answer.',
    ),
  ],
);

/// Big text (inline cloze) — Der kleine Ritter: a fairy tale told in the
/// Präteritum, the written/narrative past. It mixes weak (-te) and strong
/// (vowel-change) forms in one flowing story, which is exactly how the narrative
/// past is actually used — far more memorable than a form table.
final QuizContent questB12BigTextRitterContent = bigTextQuestQuiz(
  id: 'quest_b1_2_bigtext_ritter',
  title: 'B1.2 · Großer Text: Der kleine Ritter',
  passageTitle: 'Der kleine Ritter',
  template:
      'Es {{0}} einmal ein kleiner Ritter. Er {{1}} in einem alten Schloss. '
      'Eines Tages {{2}} ein Drache ins Dorf. Die Menschen {{3}} große Angst. '
      'Der Ritter {{4}} sein Pferd und {{5}} zum Drachen. Er {{6}} nicht, '
      'sondern {{7}} freundlich mit dem Drachen. Am Ende {{8}} sie Freunde. '
      'Alle {{9}} glücklich.',
  blanks: [
    inputBlank('war', hint: 'sein → Präteritum'),
    inputBlank('wohnte', hint: 'wohnen (schwach)'),
    inputBlank('kam', hint: 'kommen (stark)'),
    inputBlank('hatten', hint: 'haben (Plural)'),
    inputBlank('nahm', hint: 'nehmen (stark)'),
    inputBlank('ritt', hint: 'reiten (stark)'),
    inputBlank(
      'kämpfte',
      accepted: const ['kaempfte'],
      hint: 'kämpfen (schwach)',
    ),
    inputBlank('sprach', hint: 'sprechen (stark)'),
    inputBlank('wurden', hint: 'werden (stark, Plural)'),
    inputBlank('waren', hint: 'sein (Plural)'),
  ],
  passageTranslation:
      'Once upon a time there was a little knight. He lived in an old castle. '
      'One day a dragon came into the village. The people were very afraid. The '
      'knight took his horse and rode to the dragon. He did not fight, but spoke '
      'kindly with the dragon. In the end they became friends. Everyone was '
      'happy.',
  intro:
      'Tell the story in the Präteritum, the past you meet in books and '
      'reports. Weak verbs add -te (wohnte); strong verbs change the stem vowel '
      '(kommen → kam, nehmen → nahm). Read the sentence, then write the form.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Weak vs strong',
      text:
          'Weak: stem + -te (wohnen → wohnte, kämpfen → kämpfte). Strong: new '
          'stem vowel, no -te (kommen → kam, sprechen → sprach, reiten → ritt).',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '"Es war einmal …"',
      text:
          'Every German fairy tale opens with the Präteritum of sein. war, '
          'hatte, wurde are the three you will reach for most.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Plurals still change',
      text:
          'Präteritum takes endings too: er war → sie waren, er hatte → sie '
          'hatten, er wurde → sie wurden.',
    ),
  ],
);

/// Every B1.2 quiz, in chain order — all five exercise types, interleaved.

/// Speaking: the learner runs this conversation in their own AI
/// assistant and enters the score it gives (see `SpeakingQuizPage`).
final QuizContent questSpeakingErzaehlenContent = speakingQuestQuiz(
  id: 'quest_b1_2_sprechen_dialog',
  title: 'B1.2 · Gespräch: Erzählen & Begründen',
  level: 'B1.2',
  topic:
      'Telling a story and explaining a process: something that happened to me, and how something is done where I live.',
  practisePoints: [
    'Präteritum for narration: war, hatte, ging, wurde',
    'werden-Passiv: Das Haus wurde gebaut.',
    'um ... zu for purpose',
    'Relative clauses in the dative: die Frau, der ich geholfen habe',
  ],
  targetVocabulary: ['damals', 'plötzlich', 'wurde', 'um ... zu', 'deswegen'],
  scoringCriteria: [
    'the Präteritum form',
    'the passive with werden',
    'um ... zu with the infinitive at the end',
    'staying in one tense',
  ],
  priorityErrors: [
    'wrong Präteritum form',
    'active instead of passive',
    'wrong case in the relative clause',
    'switching tense mid-story',
  ],
  session: SpeakingSession(durationMinutes: 5, minExchanges: 8),
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
final QuizContent questSpeakingCheckB12Content = speakingQuestQuiz(
  id: 'quest_b1_2_sprechen_kurzcheck',
  title: 'B1.2 · Kurzcheck: Präteritum',
  level: 'B1.2',
  topic: 'A short piece of narration: what happened, in the written past.',
  practisePoints: [
    'Präteritum of sein, haben and the modals',
    'Präteritum of common strong verbs: ging, kam, gab, fand',
    'Staying in one tense across several sentences',
  ],
  targetVocabulary: ['war', 'hatte', 'ging', 'kam', 'damals'],
  scoringCriteria: [
    'the Präteritum form',
    'strong verb stems',
    'staying in one tense',
  ],
  priorityErrors: ['wrong Präteritum form', 'switching to Perfekt mid-story'],
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

final List<QuizContent> questB1_2Content = [
  questB12TechnikContent, //          Technik & Medien      (knowledge)
  questB12PraetRegContent, //         Präteritum: regelm.   (knowledge·verb)
  questB12PraetUnregContent, //       Präteritum: unregelm. (knowledge·verb)
  questB12BigTextRitterContent, //    Großer Text: Ritter   (reading·cloze)
  questB12SprechenGeschichteContent, // Sprechen: Geschichte (speaking)
  questB12PassivContent, //           Passiv (Präsens)      (knowledge·verb)
  questB12HoerenDurchsageContent, //  Hören: Durchsage      (listening)
  questB12PassivPraetContent, //      Passiv (Präteritum)   (knowledge·verb)
  questSpeakingCheckB12Content, // Kurzcheck mit einer KI (speaking·AI)
  questB12NDeklinationContent, //     n-Deklination         (knowledge)
  questB12LesenTechnikContent, //     Lesen: Missgeschick   (reading)
  questB12InfinitivContent, //        Infinitivsätze        (knowledge)
  questB12DiktatContent, //           Diktat: Präteritum    (dictation)
  questB12RelativDatContent, //       Relativsätze (Dat/Gen)(knowledge)
  questB12SprechenBegruendenContent, // Sprechen: Begründen  (speaking)
  questB12HoerenPodcastContent, //    Hören: Podcast        (listening)
  questB12LesenAnekdoteContent, //    Lesen: Anekdote       (reading)
  questSpeakingErzaehlenContent, // Gespräch mit einer KI  (speaking·AI)
];
