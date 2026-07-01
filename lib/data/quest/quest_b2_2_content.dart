import '../../models/quiz_content.dart';
import 'quest_builders.dart';

/// CEFR **B2.2 — "Differenzieren"** Quest quizzes (Goethe B2). Big rocks: the
/// **Konjunktiv II der Vergangenheit** (irreal past), **genitive prepositions**,
/// extended participial attributes, Funktionsverbgefüge and modal particles.

/// 1. Wissenschaft & Umwelt (vocab).
final QuizContent questB22UmweltContent = sentenceQuestQuiz(
  id: 'quest_b2_2_umwelt',
  title: 'B2.2 · Wissenschaft & Umwelt',
  promptLabel: 'Wort',
  subjectsLabel: 'Umwelt',
  subjectColumnLabel: 'English',
  categoryLabel: 'Umwelt',
  contextualLayout: true,
  intro: 'Science and environment vocabulary for nuanced B2 discussion.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'Environment nouns',
      text: 'der Klimawandel (climate change), die Umwelt (environment), die '
          'Forschung (research), nachhaltig (sustainable).',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Compound nouns',
      text: 'German builds long compounds: Umweltschutz (environmental '
          'protection), Energieverbrauch (energy consumption).',
    ),
  ],
  items: [
    qsi('Der ____ ist eine globale Herausforderung. (climate change)',
        'Klimawandel', 'Climate change is a global challenge.', 'climate change'),
    qsi('Wir müssen die ____ schützen. (environment)', 'Umwelt',
        'We must protect the environment.', 'environment'),
    qsi('Die ____ sucht nach neuen Lösungen. (research)', 'Forschung',
        'Research is looking for new solutions.', 'research'),
    qsi('Wir sollten ____ leben. (sustainably)', 'nachhaltig',
        'We should live sustainably.', 'sustainable'),
    qsi('Der ____ von Energie steigt jedes Jahr. (consumption)', 'Verbrauch',
        'Energy consumption rises every year.', 'consumption'),
  ],
);

/// 2. Konjunktiv II der Vergangenheit (hätte/wäre + Partizip II).
final QuizContent questB22Konj2VergContent = sentenceQuestQuiz(
  id: 'quest_b2_2_konj2_verg',
  title: 'B2.2 · Konjunktiv II der Vergangenheit',
  promptLabel: 'Form',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'Konj. II Vergangenheit',
  intro: 'To talk about an unreal **past** (something that didn’t happen), use '
      '**hätte/wäre + Partizip II**: "Ich __hätte__ das nie __gesagt__." '
      'Expresses regret and "would have".',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'hätte/wäre + Partizip II',
      text: 'haben-verbs → hätte … gemacht; sein-verbs → wäre … gegangen. The '
          'participle goes to the end.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Regret',
      text: '"Ich hätte mehr lernen __sollen__." (I should have studied more.) '
          'Modals: hätte … + Infinitiv + Modal-Infinitiv.',
    ),
  ],
  items: [
    qsi('Ich ____ das nie gesagt. (haben → Konj. II)', 'hätte',
        'I would never have said that.', 'ich hätte gesagt'),
    qsi('Wir ____ früher gegangen. (sein → Konj. II)', 'wären',
        'We would have left earlier.', 'wir wären gegangen'),
    qsi('Das ____ nicht passiert, wenn … (sein → Konj. II)', 'wäre',
        'That wouldn’t have happened if …', 'es wäre passiert'),
    qsi('Du ____ mich anrufen sollen. (haben → Konj. II)', 'hättest',
        'You should have called me.', 'du hättest … sollen'),
    qsi('Sie ____ fast den Zug verpasst. (haben → Konj. II)', 'hätte',
        'She almost missed the train.', 'sie hätte verpasst'),
  ],
);

/// 3. Irreale Bedingungssätze (wenn … hätte, … wäre).
final QuizContent questB22IrrealContent = sentenceQuestQuiz(
  id: 'quest_b2_2_irreal',
  title: 'B2.2 · Irreale Bedingungssätze',
  promptLabel: 'Form',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'irreale Bedingung',
  intro: 'Unreal conditionals describe what would happen/have happened if things '
      'were different: "Wenn ich Zeit __hätte__, __würde__ ich kommen." Present '
      'and past forms — a strong bridge to English "if I had …".',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Present vs past',
      text: 'Present: Wenn ich Zeit hätte, würde ich … . Past: Wenn ich Zeit '
          'gehabt hätte, wäre ich gekommen.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Bridge to English',
      text: '"Wenn ich du wäre" = "If I were you". The structure mirrors English '
          'closely — exploit that.',
    ),
  ],
  items: [
    qsi('Wenn ich reich ____, würde ich reisen. (sein → Konj. II)', 'wäre',
        'If I were rich, I would travel.', 'wenn ich wäre'),
    qsi('Wenn du fragst, ____ ich dir helfen. (würde, ich)', 'würde',
        'If you ask, I would help you.', 'würde helfen'),
    qsi('Wenn ich das gewusst ____, wäre ich geblieben. (haben → Konj. II)',
        'hätte', 'If I had known that, I would have stayed.',
        'wenn ich gewusst hätte'),
    qsi('An deiner Stelle ____ ich es anders machen. (würde, ich)', 'würde',
        'In your place I would do it differently.', 'würde machen'),
    qsi('Wenn ich du ____, würde ich es kaufen. (sein → Konj. II)', 'wäre',
        'If I were you, I would buy it.', 'wenn ich du wäre'),
  ],
);

/// 4. Sprechen: Hypothesen & Bedauern.
final QuizContent questB22SprechenHypotheseContent = speakQuestQuiz(
  id: 'quest_b2_2_sprechen_hypothese',
  title: 'B2.2 · Sprechen: Hypothesen & Bedauern',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro: 'Speculate and express regret with the Konjunktiv II. Listen and '
      'repeat.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Hätte ich nur …',
      text: '"Hätte ich nur …!" / "Wäre ich doch …!" express regret about the '
          'past.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Speculate',
      text: '"An seiner Stelle würde ich …", "Es wäre besser gewesen, wenn …".',
    ),
  ],
  phrases: const [
    SpeakPhrase(
        phrase: 'An deiner Stelle würde ich das nicht tun.',
        meaning: 'In your place I wouldn’t do that.'),
    SpeakPhrase(
        phrase: 'Hätte ich nur mehr Zeit gehabt!',
        meaning: 'If only I had had more time!'),
    SpeakPhrase(
        phrase: 'Es wäre besser gewesen, früher zu gehen.',
        meaning: 'It would have been better to leave earlier.'),
    SpeakPhrase(
        phrase: 'Wenn ich gekonnt hätte, wäre ich gekommen.',
        meaning: 'If I had been able to, I would have come.'),
    SpeakPhrase(
        phrase: 'Das hätte schiefgehen können.',
        meaning: 'That could have gone wrong.'),
    SpeakPhrase(
        phrase: 'Ich bereue es ein bisschen.',
        meaning: 'I regret it a little.'),
  ],
);

/// 5. Genitivpräpositionen (trotz/während/wegen/aufgrund).
final QuizContent questB22GenitivPraepContent = sentenceQuestQuiz(
  id: 'quest_b2_2_genitiv_praep',
  title: 'B2.2 · Genitivpräpositionen',
  promptLabel: 'Präposition',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'Genitivpräposition',
  intro: 'A set of prepositions takes the **genitive** in formal German: trotz '
      '(despite), während (during), wegen (because of), aufgrund (due to), '
      'innerhalb (within).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Genitive after these prepositions',
      text: '"__trotz des__ Regens", "__während der__ Woche", "__wegen des__ '
          'Wetters". Article → des/der.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Spoken German uses dative',
      text: 'Colloquially you’ll hear "wegen dem Wetter", but the exam wants the '
          'genitive: "wegen des Wetters".',
    ),
  ],
  items: [
    qsi('____ des Regens gingen wir spazieren. (despite)', 'Trotz',
        'Despite the rain we went for a walk.', 'trotz + Gen.'),
    qsi('____ der Woche habe ich keine Zeit. (during)', 'Während',
        'During the week I have no time.', 'während + Gen.'),
    qsi('____ des schlechten Wetters fällt das Spiel aus. (because of)',
        'Wegen', 'Because of the bad weather the game is cancelled.',
        'wegen + Gen.'),
    qsi('____ eines Fehlers war der Zug verspätet. (due to)', 'Aufgrund',
        'Due to an error the train was late.', 'aufgrund + Gen.'),
    qsi('____ einer Stunde war alles fertig. (within)', 'Innerhalb',
        'Within an hour everything was ready.', 'innerhalb + Gen.'),
  ],
);

/// 6. Hören: Ein Vortrag.
final QuizContent questB22HoerenVortragContent = listeningQuestQuiz(
  id: 'quest_b2_2_hoeren_vortrag',
  // Lecturer (no gendered cue) — cast as a male voice for variety.
  voiceGender: VoiceGender.male,
  title: 'B2.2 · Hören: Ein Vortrag',
  category: 'Science',
  passageTitle: 'Vortrag: Schlaf',
  passage:
      'Guten Abend und willkommen zu meinem Vortrag über den Schlaf. Viele von '
      'uns schlafen zu wenig. Studien zeigen, dass Erwachsene durchschnittlich '
      'sieben bis acht Stunden brauchen. Wer dauerhaft weniger schläft, riskiert '
      'gesundheitliche Probleme. Interessant ist, dass nicht nur die Dauer, '
      'sondern auch die Qualität des Schlafes entscheidend ist. Hätten wir alle '
      'eine feste Routine, würden wir deutlich besser schlafen.',
  passageTranslation:
      'Good evening and welcome to my talk about sleep. Many of us sleep too '
      'little. Studies show that adults need on average seven to eight hours. '
      'Anyone who permanently sleeps less risks health problems. It is '
      'interesting that not only the duration but also the quality of sleep is '
      'decisive. If we all had a fixed routine, we would sleep much better.',
  questions: const [
    ReadingQuestion(
      question: 'Wie viele Stunden Schlaf brauchen Erwachsene laut Studien?',
      questionTranslation: 'How many hours of sleep do adults need according to studies?',
      options: ['fünf bis sechs', 'sieben bis acht', 'neun bis zehn'],
      optionsTranslation: ['five to six', 'seven to eight', 'nine to ten'],
      correctIndex: 1,
      explanation: '"… durchschnittlich sieben bis acht Stunden …"',
    ),
    ReadingQuestion(
      question: 'Was ist neben der Dauer noch entscheidend?',
      questionTranslation: 'Besides duration, what else is decisive?',
      options: ['die Qualität', 'die Temperatur', 'das Alter'],
      optionsTranslation: ['the quality', 'the temperature', 'the age'],
      correctIndex: 0,
      explanation: '"… auch die Qualität des Schlafes entscheidend ist."',
    ),
    ReadingQuestion(
      question: 'Was würde laut Redner besseren Schlaf bringen?',
      questionTranslation: 'What would bring better sleep, according to the speaker?',
      options: ['mehr Kaffee', 'eine feste Routine', 'weniger Sport'],
      optionsTranslation: ['more coffee', 'a fixed routine', 'less sport'],
      correctIndex: 1,
      explanation: '"Hätten wir alle eine feste Routine, würden wir … besser '
          'schlafen."',
    ),
    ReadingQuestion(
      question: 'Was riskiert, wer dauerhaft zu wenig schläft?',
      questionTranslation: 'What does someone who permanently sleeps too little risk?',
      options: [
        'gesundheitliche Probleme',
        'einen schlechten Job',
        'weniger Freizeit',
      ],
      optionsTranslation: [
        'health problems',
        'a bad job',
        'less free time',
      ],
      correctIndex: 0,
      explanation: '"Wer dauerhaft weniger schläft, riskiert gesundheitliche '
          'Probleme."',
    ),
    ReadingQuestion(
      question: 'Worüber hält der Redner seinen Vortrag?',
      questionTranslation: 'What is the speaker giving his talk about?',
      options: ['über den Schlaf', 'über Ernährung', 'über Sport'],
      optionsTranslation: ['about sleep', 'about nutrition', 'about sport'],
      correctIndex: 0,
      explanation: '"… willkommen zu meinem Vortrag über den Schlaf."',
    ),
  ],
  intro: 'A short lecture — you only hear it. Listen for the numbers and the '
      'unreal conditional at the end (Hätten wir …, würden wir …). Replay as '
      'needed.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'nicht nur …, sondern auch …',
      text: 'This structure adds a second key point — often a question target.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Conditional without "wenn"',
      text: '"Hätten wir … , würden wir …" drops wenn and puts the verb first. '
          'Still an "if" sentence.',
    ),
  ],
);

/// 7. Erweitertes Partizipialattribut.
final QuizContent questB22PartizipAttributContent = sentenceQuestQuiz(
  id: 'quest_b2_2_partizip_attribut',
  title: 'B2.2 · Erweitertes Partizipialattribut',
  promptLabel: 'Partizip',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'Partizipialattribut',
  intro: 'Formal/written German compresses a relative clause into an extended '
      'participle before the noun: "das __von mir gelesene__ Buch" = the book '
      'read by me. The participle sits right before the noun, with its modifiers '
      'in front.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Relative clause → participle',
      text: '"das Buch, das ich gelesen habe" → "das __gelesene__ Buch"; add '
          'modifiers in front: "das gestern gelesene Buch".',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Read from the noun backwards',
      text: 'To understand it, find the noun, then read its participle and '
          'modifiers backwards.',
    ),
  ],
  items: [
    qsi('Das von mir ____ Buch war spannend. (lesen → Partizip II)', 'gelesene',
        'The book read by me was exciting.', 'das gelesene Buch'),
    qsi('Die gestern ____ E-Mail war wichtig. (schreiben → Partizip II)',
        'geschriebene', 'The email written yesterday was important.',
        'die geschriebene E-Mail'),
    qsi('Der schnell ____ Plan funktionierte nicht. (machen → Partizip II)',
        'gemachte', 'The quickly made plan didn’t work.', 'der gemachte Plan'),
    qsi('Die im Park ____ Kinder lachten. (spielen → Partizip I)', 'spielenden',
        'The children playing in the park laughed.',
        'die spielenden Kinder'),
    qsi('Das frisch ____ Brot riecht gut. (backen → Partizip II)', 'gebackene',
        'The freshly baked bread smells good.', 'das gebackene Brot'),
  ],
);

/// 8. Modalpartikeln (doch/ja/mal/eben).
final QuizContent questB22ModalpartikelnContent = sentenceQuestQuiz(
  id: 'quest_b2_2_modalpartikeln',
  title: 'B2.2 · Modalpartikeln',
  promptLabel: 'Partikel',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'Modalpartikel',
  intro: 'Modal particles (doch, ja, mal, eben, halt) add tone and attitude — '
      'they are tiny but make German sound natural. They have no direct English '
      'equivalent.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'What they add',
      text: 'doch (surprise/contradiction), ja (shared knowledge), mal '
          '(softening a request), eben/halt (resignation: "that’s just how it '
          'is").',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Don’t translate them',
      text: 'Feel their tone instead of translating: "Komm __mal__ her" softens '
          '"Komm her".',
    ),
  ],
  items: [
    qsi('Komm ____ her! (softening a request)', 'mal',
        'Come here (gently).', 'mal (softening)'),
    qsi('Das ist ____ teuer! (surprise/contradiction)', 'doch',
        'But that’s expensive!', 'doch (surprise)'),
    qsi('Du weißt ____, dass ich keine Zeit habe. (shared knowledge)', 'ja',
        'You know (after all) that I have no time.', 'ja (shared)'),
    qsi('Da kann man ____ nichts machen. (resignation)', 'eben',
        'There’s just nothing you can do.', 'eben (resignation)'),
    qsi('Nimm ____ ein Taxi! (a friendly suggestion: doch)', 'doch',
        'Just take a taxi!', 'doch (suggestion)'),
  ],
);

/// 9. Lesen: Klimawandel — was tun?
final QuizContent questB22LesenKlimaContent = readingQuestQuiz(
  id: 'quest_b2_2_lesen_klima',
  title: 'B2.2 · Lesen: Klimawandel',
  category: 'Environment',
  passageTitle: 'Was jeder Einzelne tun kann',
  passage:
      'Der Klimawandel wird oft als ein Problem dargestellt, das nur die Politik '
      'lösen könne. Sicher sind große Entscheidungen wichtig. Doch auch das '
      'Verhalten des Einzelnen spielt eine Rolle. Wer weniger Fleisch isst, '
      'öfter das Rad nimmt und bewusster konsumiert, trägt zum Klimaschutz bei. '
      'Hätten alle Menschen ihren Energieverbrauch schon früher gesenkt, wäre '
      'die Lage heute weniger dramatisch. Es ist also nie zu spät, anzufangen.',
  passageTranslation:
      'Climate change is often presented as a problem that only politics can '
      'solve. Of course big decisions are important. But the behaviour of the '
      'individual also plays a role. Anyone who eats less meat, cycles more '
      'often and consumes more consciously contributes to climate protection. '
      'If all people had reduced their energy consumption earlier, the situation '
      'would be less dramatic today. So it is never too late to start.',
  questions: const [
    ReadingQuestion(
      question: 'Wie wird der Klimawandel oft dargestellt?',
      questionTranslation: 'How is climate change often portrayed?',
      options: [
        'als ein Problem nur für die Politik',
        'als ein erfundenes Problem',
        'als ein Problem der Vergangenheit'
      ],
      optionsTranslation: [
        'as a problem only for politics',
        'as an invented problem',
        'as a problem of the past'
      ],
      correctIndex: 0,
      explanation: '"… das nur die Politik lösen könne."',
    ),
    ReadingQuestion(
      question: 'Was betont der Text zusätzlich?',
      questionTranslation: 'What does the text additionally stress?',
      options: [
        'das Verhalten des Einzelnen',
        'die Rolle der Industrie allein',
        'dass nichts hilft'
      ],
      optionsTranslation: [
        'the behaviour of the individual',
        'the role of industry alone',
        'that nothing helps'
      ],
      correctIndex: 0,
      explanation: '"… auch das Verhalten des Einzelnen spielt eine Rolle."',
    ),
    ReadingQuestion(
      question: 'Was ist die Schlussfolgerung des Textes?',
      questionTranslation: 'What is the text’s conclusion?',
      options: [
        'Es ist zu spät.',
        'Es ist nie zu spät, anzufangen.',
        'Nur die Politik kann handeln.'
      ],
      optionsTranslation: [
        'It is too late.',
        'It is never too late to start.',
        'Only politics can act.'
      ],
      correctIndex: 1,
      explanation: '"Es ist also nie zu spät, anzufangen."',
    ),
    ReadingQuestion(
      question: 'Wie trägt der Einzelne laut Text zum Klimaschutz bei?',
      questionTranslation: 'How does the individual contribute to climate protection, per the text?',
      options: [
        'weniger Fleisch essen und öfter Rad fahren',
        'mehr arbeiten',
        'mehr fliegen',
      ],
      optionsTranslation: [
        'eat less meat and cycle more',
        'work more',
        'fly more',
      ],
      correctIndex: 0,
      explanation: '"Wer weniger Fleisch isst, öfter das Rad nimmt … trägt zum '
          'Klimaschutz bei."',
    ),
    ReadingQuestion(
      question: 'Was wäre laut Text heute anders, wenn alle früher gehandelt hätten?',
      questionTranslation: 'What would be different today if everyone had acted earlier?',
      options: [
        'Die Lage wäre weniger dramatisch.',
        'Es gäbe keine Politik mehr.',
        'Alles wäre teurer.',
      ],
      optionsTranslation: [
        'The situation would be less dramatic.',
        'There would be no politics anymore.',
        'Everything would be more expensive.',
      ],
      correctIndex: 0,
      explanation: '"Hätten alle Menschen ihren Energieverbrauch schon früher '
          'gesenkt, wäre die Lage heute weniger dramatisch."',
    ),
  ],
  intro: 'An argumentative text using reported speech (könne) and a past unreal '
      'conditional (Hätten alle … gesenkt, wäre …). Typical demanding B2 '
      'reading.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Concede, then argue',
      text: '"Sicher … . Doch …" concedes a point, then makes the real argument. '
          'The author’s view comes after "Doch".',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'The conclusion',
      text: '"Es ist also …" signals the takeaway — a frequent question target.',
    ),
  ],
);

/// 10. Funktionsverbgefüge (in Betracht ziehen …).
final QuizContent questB22FvgContent = sentenceQuestQuiz(
  id: 'quest_b2_2_fvg',
  title: 'B2.2 · Funktionsverbgefüge',
  promptLabel: 'Verb',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'Funktionsverbgefüge',
  intro: 'Funktionsverbgefüge are fixed noun + verb collocations common in '
      'formal/written German: "eine Entscheidung __treffen__", "in Betracht '
      '__ziehen__". Learn them as units.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'Common combinations',
      text: 'eine Entscheidung treffen (make a decision), eine Frage stellen '
          '(ask), Kritik üben (criticise), zur Verfügung stehen (be available).',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Often = a single verb',
      text: '"eine Entscheidung treffen" = entscheiden; the FVG just sounds more '
          'formal.',
    ),
  ],
  items: [
    qsi('Wir müssen eine Entscheidung ____. (treffen)', 'treffen',
        'We have to make a decision.', 'Entscheidung treffen'),
    qsi('Darf ich eine Frage ____? (stellen)', 'stellen',
        'May I ask a question?', 'Frage stellen'),
    qsi('Wir sollten diese Option in Betracht ____. (ziehen)', 'ziehen',
        'We should consider this option.', 'in Betracht ziehen'),
    qsi('Die Kunden üben Kritik an dem Plan. — Sie ____ Kritik. (üben)',
        'üben', 'They criticise.', 'Kritik üben'),
    qsi('Ich stehe Ihnen gern zur Verfügung. — Ich ____ zur Verfügung. '
        '(stehen)', 'stehe', 'I am at your disposal.',
        'zur Verfügung stehen'),
  ],
);

/// 11. Diktat: Irreal.
final QuizContent questB22DiktatContent = dictationQuestQuiz(
  id: 'quest_b2_2_diktat_irreal',
  title: 'B2.2 · Diktat: Hypothesen',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro: 'A dictation with unreal conditionals and genitive prepositions. You '
      'HEAR a sentence and TYPE it. Listen for hätte/wäre and trotz/wegen + '
      'genitive.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Two clauses',
      text: 'In "Wenn …, würde/wäre …" there is a comma between the clauses. '
          'Write the verb at the end of the wenn-clause.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Umlauts in hätte/wäre/würde',
      text: 'Type haette/waere/wuerde if needed — both spellings are accepted.',
    ),
  ],
  sentences: const [
    SpeakPhrase(
        phrase: 'Wenn ich Zeit hätte, würde ich dir helfen.',
        meaning: 'If I had time, I would help you.'),
    SpeakPhrase(
        phrase: 'Hätte ich das gewusst, wäre ich nicht gekommen.',
        meaning: 'If I had known that, I wouldn’t have come.'),
    SpeakPhrase(
        phrase: 'Trotz des Regens sind wir spazieren gegangen.',
        meaning: 'Despite the rain we went for a walk.'),
    SpeakPhrase(
        phrase: 'Wegen des schlechten Wetters fällt das Spiel aus.',
        meaning: 'Because of the bad weather the game is cancelled.'),
    SpeakPhrase(
        phrase: 'An deiner Stelle würde ich das anders machen.',
        meaning: "In your place I'd do it differently."),
    SpeakPhrase(
        phrase: 'Wir müssen eine wichtige Entscheidung treffen.',
        meaning: 'We have to make an important decision.'),
  ],
);

/// 12. Konzessivsätze (obwohl / wenngleich).
final QuizContent questB22KonzessivContent = sentenceQuestQuiz(
  id: 'quest_b2_2_konzessiv',
  title: 'B2.2 · Konzessivsätze',
  promptLabel: 'Konnektor',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'Konzession',
  intro: 'Concessive clauses express "although/even though". **obwohl** + verb '
      'at the end (subordinate); **trotzdem** + verb second (adverb).',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'obwohl vs trotzdem',
      text: 'obwohl is a subordinating conjunction (verb last). trotzdem is an '
          'adverb (verb second). Don’t mix them.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Formal alternatives',
      text: 'wenngleich, obgleich, obschon = literary "although". zwar … aber … '
          '= admittedly … but ….',
    ),
  ],
  items: [
    qsi('____ es regnete, gingen wir spazieren. (although)', 'Obwohl',
        'Although it rained, we went for a walk.', 'obwohl'),
    qsi('Es regnete. ____ gingen wir spazieren. (nevertheless)', 'Trotzdem',
        'It rained. Nevertheless we went for a walk.', 'trotzdem'),
    qsi('Er kam, ____ er krank war. (although)', 'obwohl',
        'He came although he was ill.', 'obwohl'),
    qsi('____ teuer, ist es seinen Preis wert. (zwar … aber)', 'Zwar',
        'Admittedly expensive, but worth the price.', 'zwar … aber'),
    qsi('Sie lächelte, ____ sie traurig war. (although)', 'obwohl',
        'She smiled although she was sad.', 'obwohl'),
  ],
);

/// 13. Hören: Interview mit einer Fachperson.
final QuizContent questB22HoerenFachinterviewContent = listeningQuestQuiz(
  id: 'quest_b2_2_hoeren_fachinterview',
  title: 'B2.2 · Hören: Fachinterview',
  category: 'Science',
  passageTitle: 'Interview: Ernährung',
  passage:
      'Frau Doktor Berg, viele Menschen wollen sich gesünder ernähren. Was raten '
      'Sie? Mein wichtigster Rat ist: Essen Sie viel Gemüse und trinken Sie '
      'genug Wasser. Man muss übrigens nicht völlig auf Süßigkeiten verzichten; '
      'entscheidend ist das Maß. Hätten die Menschen weniger Stress, würden sie '
      'auch automatisch gesünder essen. Denn Stress führt oft zu schlechten '
      'Gewohnheiten.',
  passageTranslation:
      'Dr Berg, many people want to eat more healthily. What do you advise? My '
      'most important advice is: eat lots of vegetables and drink enough water. '
      'By the way, you don’t have to give up sweets entirely; the key is '
      'moderation. If people had less stress, they would automatically eat more '
      'healthily too. Because stress often leads to bad habits.',
  questions: const [
    ReadingQuestion(
      question: 'Was ist der wichtigste Rat der Ärztin?',
      questionTranslation: 'What is the doctor’s most important advice?',
      options: [
        'völlig auf Zucker verzichten',
        'viel Gemüse essen und genug Wasser trinken',
        'nur dreimal am Tag essen'
      ],
      optionsTranslation: [
        'give up sugar entirely',
        'eat lots of vegetables and drink enough water',
        'eat only three times a day'
      ],
      correctIndex: 1,
      explanation: '"Essen Sie viel Gemüse und trinken Sie genug Wasser."',
    ),
    ReadingQuestion(
      question: 'Was sagt sie über Süßigkeiten?',
      questionTranslation: 'What does she say about sweets?',
      options: [
        'Man muss völlig darauf verzichten.',
        'Man muss nicht völlig darauf verzichten.',
        'Sie sind immer gesund.'
      ],
      optionsTranslation: [
        'You must give them up entirely.',
        'You don’t have to give them up entirely.',
        'They are always healthy.'
      ],
      correctIndex: 1,
      explanation: '"… nicht völlig auf Süßigkeiten verzichten …"',
    ),
    ReadingQuestion(
      question: 'Was führt laut Ärztin zu schlechten Gewohnheiten?',
      questionTranslation: 'What leads to bad habits, according to the doctor?',
      options: ['Stress', 'Sport', 'Wasser'],
      optionsTranslation: ['stress', 'sport', 'water'],
      correctIndex: 0,
      explanation: '"Denn Stress führt oft zu schlechten Gewohnheiten."',
    ),
    ReadingQuestion(
      question: 'Worauf kommt es bei Süßigkeiten laut Ärztin an?',
      questionTranslation: 'What matters with sweets, according to the doctor?',
      options: ['auf das Maß', 'auf den Preis', 'auf die Uhrzeit'],
      optionsTranslation: ['on moderation', 'on the price', 'on the time of day'],
      correctIndex: 0,
      explanation: '"… entscheidend ist das Maß."',
    ),
    ReadingQuestion(
      question: 'Was würde laut Ärztin gesünderes Essen fördern?',
      questionTranslation: 'What would promote healthier eating, per the doctor?',
      options: ['weniger Stress', 'mehr Geld', 'mehr Termine'],
      optionsTranslation: ['less stress', 'more money', 'more appointments'],
      correctIndex: 0,
      explanation: '"Hätten die Menschen weniger Stress, würden sie … gesünder '
          'essen."',
    ),
  ],
  intro: 'An expert interview — you only hear it. Listen for the advice, the '
      'nuance about sweets (nicht völlig) and the cause at the end. Replay as '
      'needed.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Nuance words',
      text: '"übrigens" (by the way), "nicht völlig" (not entirely) add nuance — '
          'don’t miss the "not".',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'denn = because',
      text: 'The final "Denn …" gives the reason — a likely question.',
    ),
  ],
);

/// 14. Sprechen: Einräumen & widersprechen.
final QuizContent questB22SprechenEinraeumenContent = speakQuestQuiz(
  id: 'quest_b2_2_sprechen_einraeumen',
  title: 'B2.2 · Sprechen: Einräumen & widersprechen',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro: 'Concede a point and then disagree — the heart of nuanced B2 discussion. '
      'Listen and repeat.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Concession formula',
      text: '"Sie haben zwar recht, aber …", "Das ist ein guter Punkt, '
          'allerdings …".',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Soft disagreement',
      text: '"Da bin ich nicht ganz Ihrer Meinung." is polite but clear.',
    ),
  ],
  phrases: const [
    SpeakPhrase(
        phrase: 'Sie haben zwar recht, aber man muss auch bedenken …',
        meaning: 'You’re right, but one must also consider …'),
    SpeakPhrase(
        phrase: 'Das ist ein guter Punkt, allerdings …',
        meaning: 'That’s a good point, however …'),
    SpeakPhrase(
        phrase: 'Da bin ich nicht ganz Ihrer Meinung.',
        meaning: 'I don’t entirely agree with you there.'),
    SpeakPhrase(
        phrase: 'Einerseits ja, andererseits sehe ich Probleme.',
        meaning: 'On the one hand yes, on the other I see problems.'),
    SpeakPhrase(
        phrase: 'Trotzdem bleibe ich bei meiner Meinung.',
        meaning: 'Nevertheless I stick to my opinion.'),
    SpeakPhrase(
        phrase: 'Das müssen wir differenzierter betrachten.',
        meaning: 'We have to look at this in a more nuanced way.'),
  ],
);

/// 15. Lesen: Eine Buchrezension.
final QuizContent questB22LesenRezensionContent = readingQuestQuiz(
  id: 'quest_b2_2_lesen_rezension',
  title: 'B2.2 · Lesen: Eine Buchrezension',
  category: 'Arts',
  passageTitle: 'Rezension: „Die lange Reise“',
  passage:
      'Der neue Roman „Die lange Reise“ erzählt die Geschichte einer Familie, '
      'die im 20. Jahrhundert mehrmals ihre Heimat verlassen muss. Sprachlich '
      'ist das Buch beeindruckend: Die ruhig erzählten Kapitel ziehen den Leser '
      'langsam in ihren Bann. Zwar ist der Anfang etwas langsam, doch wer durchhält, '
      'wird belohnt. Manche Kritiker bemängeln die vielen Figuren, ich jedoch '
      'fand gerade diese Vielfalt überzeugend. Ein lesenswertes Buch.',
  passageTranslation:
      'The new novel "The Long Journey" tells the story of a family that has to '
      'leave its homeland several times in the 20th century. Linguistically the '
      'book is impressive: the calmly narrated chapters slowly draw the reader '
      'in. Admittedly the beginning is a little slow, but those who persevere '
      'are rewarded. Some critics complain about the many characters, but I '
      'found precisely this variety convincing. A book worth reading.',
  questions: const [
    ReadingQuestion(
      question: 'Wovon handelt der Roman?',
      questionTranslation: 'What is the novel about?',
      options: [
        'von einer Familie, die ihre Heimat verlassen muss',
        'von einer Liebesgeschichte',
        'von einem Verbrechen'
      ],
      optionsTranslation: [
        'a family that has to leave its homeland',
        'a love story',
        'a crime'
      ],
      correctIndex: 0,
      explanation: '"… einer Familie, die … ihre Heimat verlassen muss."',
    ),
    ReadingQuestion(
      question: 'Was kritisieren manche Kritiker?',
      questionTranslation: 'What do some critics criticise?',
      options: ['den langsamen Anfang', 'die vielen Figuren', 'die Sprache'],
      optionsTranslation: ['the slow start', 'the many characters', 'the language'],
      correctIndex: 1,
      explanation: '"Manche Kritiker bemängeln die vielen Figuren …"',
    ),
    ReadingQuestion(
      question: 'Wie bewertet der Rezensent das Buch insgesamt?',
      questionTranslation: 'How does the reviewer rate the book overall?',
      options: ['als enttäuschend', 'als lesenswert', 'als zu kurz'],
      optionsTranslation: ['as disappointing', 'as worth reading', 'as too short'],
      correctIndex: 1,
      explanation: '"Ein lesenswertes Buch."',
    ),
    ReadingQuestion(
      question: 'Wie beurteilt der Rezensent den Anfang des Buches?',
      questionTranslation: 'How does the reviewer judge the start of the book?',
      options: ['etwas langsam', 'sehr spannend', 'zu brutal'],
      optionsTranslation: ['a little slow', 'very exciting', 'too brutal'],
      correctIndex: 0,
      explanation: '"Zwar ist der Anfang etwas langsam, doch wer durchhält, wird '
          'belohnt."',
    ),
    ReadingQuestion(
      question: 'Wie fand der Rezensent selbst die vielen Figuren?',
      questionTranslation: 'How did the reviewer himself find the many characters?',
      options: ['überzeugend', 'verwirrend', 'langweilig'],
      optionsTranslation: ['convincing', 'confusing', 'boring'],
      correctIndex: 0,
      explanation: '"… ich jedoch fand gerade diese Vielfalt überzeugend."',
    ),
  ],
  intro: 'A book review — a B2 text type with evaluation and concession (Zwar …, '
      'doch …) and a participial attribute (die ruhig erzählten Kapitel).',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'The verdict',
      text: 'A review ends with an overall judgement ("Ein lesenswertes Buch") — '
          'the answer to "how does the reviewer rate it?".',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'ich jedoch',
      text: '"Manche … , ich jedoch …" contrasts others’ view with the writer’s '
          'own. Keep them apart.',
    ),
  ],
);

/// Big text (inline cloze) — Verpasste Chancen: the irreal past (Konjunktiv II
/// der Vergangenheit) as a stream of regrets after a failed exam. Every gap is a
/// hätte/wäre + Partizip II — including the wenn-less inversion (Hätte ich …) —
/// which is exactly how native speakers pile up "if only I had …".
final QuizContent questB22BigTextChancenContent = bigTextQuestQuiz(
  id: 'quest_b2_2_bigtext_chancen',
  title: 'B2.2 · Großer Text: Verpasste Chancen',
  passageTitle: 'Verpasste Chancen',
  template:
      'Gestern hatte ich eine wichtige Prüfung, und leider habe ich sie nicht '
      'bestanden. Wenn ich mehr {{0}} hätte, hätte ich sie bestanden. Wenn ich '
      'am Abend früher ins Bett {{1}} wäre, {{2}} ich nicht so müde gewesen. Ich '
      'hätte mich besser vorbereitet, wenn ich weniger Zeit am Handy {{3}} '
      'hätte. Hätte mir mein Freund {{4}}, wäre ich ruhiger geblieben. Ach, '
      '{{5}} ich nur mehr geübt! Und {{6}} ich am Morgen nicht den Bus '
      'verpasst, {{7}} ich pünktlich gewesen.',
  blanks: [
    inputBlank('gelernt', hint: 'lernen → Partizip II'),
    inputBlank('gegangen', hint: 'gehen → Partizip II (Bewegung)'),
    inputBlank('wäre', accepted: const ['waere'], hint: 'sein als Hilfsverb'),
    inputBlank('verbracht', hint: 'verbringen → Partizip II'),
    inputBlank('geholfen', hint: 'helfen → Partizip II'),
    inputBlank('hätte', accepted: const ['haette'], hint: 'haben als Hilfsverb'),
    inputBlank('hätte', accepted: const ['haette'], hint: 'haben als Hilfsverb'),
    inputBlank('wäre', accepted: const ['waere'], hint: 'sein als Hilfsverb'),
  ],
  passageTranslation:
      'Yesterday I had an important exam, and unfortunately I didn’t pass it. If '
      'I had studied more, I would have passed it. If I had gone to bed earlier '
      'in the evening, I wouldn’t have been so tired. I would have prepared '
      'better if I had spent less time on my phone. If my friend had helped me, '
      'I would have stayed calmer. Oh, if only I had practised more! And if I '
      'hadn’t missed the bus in the morning, I would have been on time.',
  intro: 'Regret the past. The irreal past is built from hätte or wäre + the '
      'Partizip II: "Wenn ich mehr gelernt hätte, hätte ich bestanden." Choose '
      'hätte or wäre exactly as the Perfekt would (movers/changers → wäre).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'hätte / wäre + Partizip II',
      text: 'Same auxiliary split as the Perfekt: haben-verbs → hätte … gelernt; '
          'sein-verbs (gehen, bleiben, sein) → wäre … gegangen.',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Drop wenn, move the verb up',
      text: '"Wenn ich … gehabt hätte" = "Hätte ich … gehabt". Starting with the '
          'conjugated hätte/wäre replaces wenn — very common in speech.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Two participles can stack',
      text: 'With a modal it becomes a double infinitive: "Ich hätte lernen '
          'müssen" — but the plain regret here is just aux + one Partizip II.',
    ),
  ],
);

/// Every B2.2 quiz, in chain order — all five exercise types, interleaved.
final List<QuizContent> questB2_2Content = [
  questB22UmweltContent, //              Wissenschaft & Umwelt   (knowledge)
  questB22Konj2VergContent, //          Konj. II Vergangenheit  (knowledge·verb)
  questB22IrrealContent, //             Irreale Bedingungen     (knowledge·verb)
  questB22BigTextChancenContent, //     Großer Text: Chancen    (reading·cloze)
  questB22SprechenHypotheseContent, //  Sprechen: Hypothesen    (speaking)
  questB22GenitivPraepContent, //       Genitivpräpositionen    (knowledge)
  questB22HoerenVortragContent, //      Hören: Vortrag          (listening)
  questB22PartizipAttributContent, //   Partizipialattribut     (knowledge)
  questB22ModalpartikelnContent, //     Modalpartikeln          (knowledge)
  questB22LesenKlimaContent, //         Lesen: Klimawandel      (reading)
  questB22FvgContent, //                Funktionsverbgefüge     (knowledge)
  questB22DiktatContent, //             Diktat: Hypothesen      (dictation)
  questB22KonzessivContent, //          Konzessivsätze          (knowledge)
  questB22HoerenFachinterviewContent, // Hören: Fachinterview   (listening)
  questB22SprechenEinraeumenContent, // Sprechen: Einräumen     (speaking)
  questB22LesenRezensionContent, //     Lesen: Buchrezension    (reading)
];
