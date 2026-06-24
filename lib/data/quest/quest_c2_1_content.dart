import '../../models/quiz_content.dart';
import 'quest_builders.dart';

/// CEFR **C2.1 — "Stilsicherheit"** Quest quizzes (Goethe C2 / GDS). Big rocks:
/// **register** (formal ↔ colloquial), strong **collocations**, rhetorical
/// devices, the literary/journalistic Konjunktiv I, and proverbs. Reading and
/// listening reach near-native density.

/// 1. Wirtschaft & Recht (Fachwortschatz).
final QuizContent questC21WirtschaftContent = sentenceQuestQuiz(
  id: 'quest_c2_1_wirtschaft',
  title: 'C2.1 · Wirtschaft & Recht',
  promptLabel: 'Wort',
  subjectsLabel: 'Fachwortschatz',
  subjectColumnLabel: 'English',
  categoryLabel: 'Fachwortschatz',
  contextualLayout: true,
  intro: 'Specialist vocabulary from economics and law — the register of '
      'broadsheet journalism and GDS texts.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'Specialist nouns',
      text: 'die Konjunktur (economic situation), die Rendite (yield), das '
          'Gesetz (law), die Verordnung (regulation), der Vertrag (contract).',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Precise, not vague',
      text: 'C2 distinguishes near-synonyms: Gesetz (statute) ≠ Verordnung '
          '(regulation) ≠ Vertrag (contract).',
    ),
  ],
  items: [
    qsi('Die ____ hat sich im letzten Quartal erholt. (economy/business cycle)',
        'Konjunktur', 'The economy recovered in the last quarter.',
        'business cycle'),
    qsi('Der Bundestag verabschiedete ein neues ____. (law)', 'Gesetz',
        'Parliament passed a new law.', 'law'),
    qsi('Beide Parteien unterzeichneten den ____. (contract)', 'Vertrag',
        'Both parties signed the contract.', 'contract'),
    qsi('Die ____ der Anlage lag bei drei Prozent. (yield/return)', 'Rendite',
        'The yield of the investment was three percent.', 'yield'),
    qsi('Eine neue ____ regelt den Datenschutz. (regulation)', 'Verordnung',
        'A new regulation governs data protection.', 'regulation'),
  ],
);

/// 2. Register: formell ↔ umgangssprachlich.
final QuizContent questC21RegisterContent = sentenceQuestQuiz(
  id: 'quest_c2_1_register',
  title: 'C2.1 · Register: formell ↔ umgangssprachlich',
  promptLabel: 'Register',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Umgangssprache → formell',
  categoryLabel: 'formelles Äquivalent',
  intro: 'A C2 speaker chooses the right register. Replace a colloquial word '
      'with its formal equivalent: kriegen → erhalten, kaputt → defekt, Kumpel '
      '→ Bekannter.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'Colloquial → formal',
      text: 'kriegen → erhalten/bekommen; klauen → entwenden; Kohle → Geld; '
          'echt gut → ausgezeichnet.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Match the situation',
      text: 'A job application needs "erhalten"; a chat with friends can use '
          '"kriegen". Mismatched register stands out.',
    ),
  ],
  items: [
    qsi('umgangssprachlich „kriegen" → formell „____" (receive)', 'erhalten',
        'to receive (formal)', 'kriegen → erhalten'),
    qsi('umgangssprachlich „kaputt" → formell „____" (broken)', 'defekt',
        'broken/defective (formal)', 'kaputt → defekt'),
    qsi('umgangssprachlich „klauen" → formell „____" (steal)', 'entwenden',
        'to steal (formal)', 'klauen → entwenden'),
    qsi('umgangssprachlich „echt gut" → formell „____" (excellent)',
        'ausgezeichnet', 'excellent (formal)', 'echt gut → ausgezeichnet'),
    qsi('umgangssprachlich „Kohle" → formell „____" (money)', 'Geld',
        'money (formal)', 'Kohle → Geld'),
  ],
);

/// 3. Kollokationen (starke Wortpartner).
final QuizContent questC21KollokationenContent = sentenceQuestQuiz(
  id: 'quest_c2_1_kollokationen',
  title: 'C2.1 · Kollokationen',
  promptLabel: 'Verb',
  subjectsLabel: 'Kollokationen',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'Kollokation',
  intro: 'Native fluency depends on collocations — words that conventionally go '
      'together. You "treffen eine Entscheidung", not "machen". (E20: collocations '
      'rarely match English.)',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'Fixed partners',
      text: 'eine Entscheidung treffen, eine Rolle spielen, Maßnahmen ergreifen, '
          'Kritik üben, einen Antrag stellen.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Don’t translate the verb',
      text: 'English "make a decision" → German "eine Entscheidung __treffen__" '
          '(hit), not machen.',
    ),
  ],
  items: [
    qsi('eine Entscheidung ____ (make)', 'treffen', 'to make a decision',
        'Entscheidung treffen'),
    qsi('eine wichtige Rolle ____ (play)', 'spielen', 'to play a role',
        'Rolle spielen'),
    qsi('Maßnahmen ____ (take measures)', 'ergreifen', 'to take measures',
        'Maßnahmen ergreifen'),
    qsi('einen Antrag ____ (submit)', 'stellen', 'to submit an application',
        'Antrag stellen'),
    qsi('großen Wert auf etwas ____ (place value on)', 'legen',
        'to place great value on something', 'Wert legen auf'),
  ],
);

/// 4. Sprechen: Eine Rede halten.
final QuizContent questC21SprechenRedeContent = speakQuestQuiz(
  id: 'quest_c2_1_sprechen_rede',
  title: 'C2.1 · Sprechen: Eine Rede halten',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro: 'Deliver a formal speech with rhetorical flair. Listen and repeat, '
      'paying attention to rhythm and emphasis.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Rhetorical openers',
      text: '"Sehr geehrte Damen und Herren," opens; a rhetorical question or a '
          'striking image hooks the audience.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Tricolon',
      text: 'Lists of three persuade: "Wir wollen Freiheit, Gerechtigkeit und '
          'Solidarität."',
    ),
  ],
  phrases: const [
    SpeakPhrase(
        phrase: 'Sehr geehrte Damen und Herren,',
        meaning: 'Ladies and gentlemen,'),
    SpeakPhrase(
        phrase: 'Lassen Sie mich mit einer Frage beginnen.',
        meaning: 'Let me begin with a question.'),
    SpeakPhrase(
        phrase: 'Wir wollen Freiheit, Gerechtigkeit und Solidarität.',
        meaning: 'We want freedom, justice and solidarity.'),
    SpeakPhrase(
        phrase: 'Es ist an der Zeit, dass wir handeln.',
        meaning: 'It is time for us to act.'),
    SpeakPhrase(
        phrase: 'Ich appelliere an Ihre Verantwortung.',
        meaning: 'I appeal to your responsibility.'),
    SpeakPhrase(
        phrase: 'Ich danke Ihnen für Ihre Aufmerksamkeit.',
        meaning: 'I thank you for your attention.'),
  ],
);

/// 5. Stilmittel & Rhetorik.
final QuizContent questC21StilmittelContent = sentenceQuestQuiz(
  id: 'quest_c2_1_stilmittel',
  title: 'C2.1 · Stilmittel & Rhetorik',
  promptLabel: 'Stilmittel',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Beispiel',
  categoryLabel: 'Stilmittel',
  intro: 'Recognise rhetorical devices: the **Metapher** (image), the '
      '**rhetorische Frage**, the **Ironie**, the **Übertreibung** (hyperbole). '
      'They shape meaning beyond the literal.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'Common devices',
      text: 'Metapher (a sea of people), rhetorische Frage (who could deny it?), '
          'Ironie, Untertreibung (Litotes), Anapher (repeated opening).',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Effect, not decoration',
      text: 'Each device has a purpose: to persuade, to distance, to emphasise. '
          'Ask why the author chose it.',
    ),
  ],
  items: [
    qsi('„Ein Meer von Menschen" ist eine ____. (image)', 'Metapher',
        '"A sea of people" is a metaphor.', 'Metapher'),
    qsi('„Wer könnte das bestreiten?" ist eine rhetorische ____. (question)',
        'Frage', 'A rhetorical question.', 'rhetorische Frage'),
    qsi('„Na, das war ja großartig …" (gemeint: schlecht) ist ____. (irony)',
        'Ironie', 'That is irony.', 'Ironie'),
    qsi('„Ich habe es dir tausendmal gesagt!" ist eine ____. (exaggeration)',
        'Übertreibung', 'An exaggeration / hyperbole.', 'Übertreibung'),
    qsi('Die Wiederholung am Satzanfang heißt ____. (anaphora)', 'Anapher',
        'Repetition at the start of clauses is anaphora.', 'Anapher'),
  ],
);

/// 6. Hören: Ein Feature / eine Dokumentation.
final QuizContent questC21HoerenFeatureContent = listeningQuestQuiz(
  id: 'quest_c2_1_hoeren_feature',
  // Radio feature narrator (no gendered cue) — cast as a male voice for variety.
  voiceGender: VoiceGender.male,
  title: 'C2.1 · Hören: Feature',
  category: 'Media',
  passageTitle: 'Feature: Die Stille der Großstadt',
  passage:
      'Wer glaubt, eine Großstadt schlafe nie, der irrt. Es gibt diesen einen '
      'Moment, kurz vor der Morgendämmerung, in dem selbst die rastlose '
      'Metropole den Atem anzuhalten scheint. Die letzten Nachtschwärmer sind '
      'verschwunden, die ersten Bäcker noch nicht erwacht. In dieser flüchtigen '
      'Stille, so behaupten manche, offenbare die Stadt ihr wahres Gesicht – '
      'verletzlich, leer und auf eigentümliche Weise schön.',
  passageTranslation:
      'Anyone who thinks a big city never sleeps is wrong. There is this one '
      'moment, just before dawn, in which even the restless metropolis seems to '
      'hold its breath. The last night owls have disappeared, the first bakers '
      'not yet awake. In this fleeting silence, some claim, the city reveals its '
      'true face – vulnerable, empty and beautiful in a peculiar way.',
  questions: const [
    ReadingQuestion(
      question: 'Welche Vorstellung widerlegt das Feature?',
      questionTranslation: 'Which idea does the feature refute?',
      options: [
        'dass eine Großstadt nie schläft',
        'dass Städte gefährlich sind',
        'dass Bäcker früh aufstehen'
      ],
      optionsTranslation: [
        'that a big city never sleeps',
        'that cities are dangerous',
        'that bakers get up early'
      ],
      correctIndex: 0,
      explanation: '"Wer glaubt, eine Großstadt schlafe nie, der irrt."',
    ),
    ReadingQuestion(
      question: 'Wann tritt der beschriebene Moment ein?',
      questionTranslation: 'When does the described moment occur?',
      options: [
        'kurz vor der Morgendämmerung',
        'um Mitternacht',
        'am späten Nachmittag'
      ],
      optionsTranslation: [
        'just before dawn',
        'at midnight',
        'in the late afternoon'
      ],
      correctIndex: 0,
      explanation: '"… kurz vor der Morgendämmerung …"',
    ),
    ReadingQuestion(
      question: 'Wie wird die Stadt in der Stille beschrieben?',
      questionTranslation: 'How is the city described in the silence?',
      options: [
        'verletzlich und auf eigentümliche Weise schön',
        'laut und hektisch',
        'grau und hässlich'
      ],
      optionsTranslation: [
        'vulnerable and beautiful in a peculiar way',
        'loud and hectic',
        'grey and ugly'
      ],
      correctIndex: 0,
      explanation: '"… verletzlich, leer und auf eigentümliche Weise schön."',
    ),
  ],
  intro: 'A literary radio feature — you only hear it. The language is poetic '
      '(personification: die Metropole hält den Atem an). Listen for image and '
      'mood. Replay as needed.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Personification',
      text: 'The city "holds its breath" and "reveals its face" — it’s treated '
          'as a living being. Don’t read it literally.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'so behaupten manche',
      text: 'This hedges the poetic claim as someone’s view, not fact — typical '
          'feature style.',
    ),
  ],
);

/// 7. Konjunktiv I in literarischen/journalistischen Texten.
final QuizContent questC21Konj1LitContent = sentenceQuestQuiz(
  id: 'quest_c2_1_konj1_lit',
  title: 'C2.1 · Konjunktiv I (Journalismus)',
  promptLabel: 'Konjunktiv I',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'Konjunktiv I',
  intro: 'Quality journalism uses the Konjunktiv I consistently for reported '
      'speech across whole paragraphs, marking everything as someone else’s '
      'claim. Master the less common forms (habe, sei, werde, gehe, könne).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Sustained reported speech',
      text: 'Once started, the whole report stays in Konjunktiv I: "Er sagte, er '
          'sei müde und habe keine Zeit; er werde später kommen."',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Signals distance',
      text: 'The Konjunktiv I tells the reader: the journalist is quoting, not '
          'endorsing.',
    ),
  ],
  items: [
    qsi('Der Sprecher erklärte, die Lage ____ ernst. (sein → Konj. I)', 'sei',
        'The spokesman said the situation was serious.', 'sei'),
    qsi('Sie betonte, man ____ alles versucht. (haben → Konj. I)', 'habe',
        'She stressed they had tried everything.', 'habe'),
    qsi('Er fügte hinzu, er ____ bald zurücktreten. (werden → Konj. I)',
        'werde', 'He added he would soon resign.', 'werde'),
    qsi('Der Bericht hält fest, die Zahlen ____ gestiegen. (sein → Konj. I, '
        'Pl.)', 'seien', 'The report states the figures had risen.', 'seien'),
    qsi('Sie meinte, das ____ nicht ausgeschlossen. (sein → Konj. I)', 'sei',
        'She said that was not ruled out.', 'sei'),
  ],
);

/// 8. Konnotation & Wortwahl.
final QuizContent questC21KonnotationContent = sentenceQuestQuiz(
  id: 'quest_c2_1_konnotation',
  title: 'C2.1 · Konnotation & Wortwahl',
  promptLabel: 'Konnotation',
  subjectsLabel: 'Wortpaare',
  subjectColumnLabel: 'Bewertung',
  categoryLabel: 'Konnotation',
  intro: 'Near-synonyms carry different connotations. "sparsam" (thrifty, '
      'positive) vs "geizig" (stingy, negative) describe the same behaviour with '
      'opposite judgement. C2 means choosing the loaded word deliberately.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'Positive vs negative pairs',
      text: 'selbstbewusst (confident) vs arrogant; sparsam vs geizig; '
          'eigenwillig vs stur; jung vs unerfahren.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Word choice = stance',
      text: 'Calling protesters "Aktivisten" vs "Randalierer" reveals the '
          'writer’s position.',
    ),
  ],
  items: [
    qsi('positiv: sparsam — negativ: ____ (stingy)', 'geizig',
        'thrifty (pos.) vs stingy (neg.)', 'sparsam/geizig'),
    qsi('positiv: selbstbewusst — negativ: ____ (arrogant)', 'arrogant',
        'confident (pos.) vs arrogant (neg.)', 'selbstbewusst/arrogant'),
    qsi('positiv: eigenwillig — negativ: ____ (stubborn)', 'stur',
        'strong-willed (pos.) vs stubborn (neg.)', 'eigenwillig/stur'),
    qsi('neutral: Demonstranten — abwertend: ____ (rioters)', 'Randalierer',
        'demonstrators (neutral) vs rioters (pejorative)',
        'Demonstranten/Randalierer'),
    qsi('positiv: kostengünstig — negativ: ____ (cheap/inferior)', 'billig',
        'inexpensive (pos.) vs cheap (neg.)', 'kostengünstig/billig'),
  ],
);

/// 9. Lesen: Ein anspruchsvoller Zeitungsartikel.
final QuizContent questC21LesenArtikelContent = readingQuestQuiz(
  id: 'quest_c2_1_lesen_artikel',
  title: 'C2.1 · Lesen: Zeitungsartikel',
  category: 'Society',
  passageTitle: 'Die Rückkehr der Langsamkeit',
  passage:
      'Inmitten einer Gesellschaft, die Geschwindigkeit zum Maß aller Dinge '
      'erhoben hat, formiert sich leiser Widerstand. Immer mehr Menschen, so '
      'beobachten Soziologen, entdeckten den Wert der Langsamkeit neu – sei es '
      'beim Kochen, beim Reisen oder schlicht im Umgang miteinander. Was '
      'zunächst wie eine nostalgische Marotte anmutet, könnte sich als '
      'notwendige Korrektur erweisen. Denn wer ständig beschleunigt, läuft '
      'Gefahr, das Ziel aus den Augen zu verlieren, für das die Eile überhaupt '
      'erst betrieben wurde.',
  passageTranslation:
      'In the midst of a society that has elevated speed to the measure of all '
      'things, a quiet resistance is forming. More and more people, sociologists '
      'observe, are rediscovering the value of slowness – be it in cooking, '
      'travelling or simply in dealing with one another. What at first seems '
      'like a nostalgic quirk could prove to be a necessary correction. For '
      'whoever constantly accelerates risks losing sight of the very goal for '
      'which the haste was pursued in the first place.',
  questions: const [
    ReadingQuestion(
      question: 'Was beobachten die Soziologen?',
      questionTranslation: 'What do the sociologists observe?',
      options: [
        'eine Wiederentdeckung der Langsamkeit',
        'eine Zunahme der Geschwindigkeit',
        'das Ende des Kochens'
      ],
      optionsTranslation: [
        'a rediscovery of slowness',
        'an increase in speed',
        'the end of cooking'
      ],
      correctIndex: 0,
      explanation: '"… entdeckten den Wert der Langsamkeit neu …"',
    ),
    ReadingQuestion(
      question: 'Wie könnte sich dieser Trend laut Autor erweisen?',
      questionTranslation: 'How could this trend prove to be, according to the author?',
      options: [
        'als nostalgische Marotte',
        'als notwendige Korrektur',
        'als wirtschaftlicher Schaden'
      ],
      optionsTranslation: [
        'as a nostalgic quirk',
        'as a necessary correction',
        'as economic damage'
      ],
      correctIndex: 1,
      explanation: '"… könnte sich als notwendige Korrektur erweisen."',
    ),
    ReadingQuestion(
      question: 'Wovor warnt der Schlusssatz?',
      questionTranslation: 'What does the final sentence warn of?',
      options: [
        'das Ziel aus den Augen zu verlieren',
        'zu wenig zu arbeiten',
        'zu langsam zu reisen'
      ],
      optionsTranslation: [
        'losing sight of the goal',
        'working too little',
        'travelling too slowly'
      ],
      correctIndex: 0,
      explanation: '"… läuft Gefahr, das Ziel aus den Augen zu verlieren …"',
    ),
  ],
  intro: 'A demanding op-ed with long periodic sentences, reported speech '
      '(entdeckten, sei es), and an aphoristic conclusion. GDS-level reading.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Untangle long sentences',
      text: 'Find the main verb first, then attach the clauses. The thesis is in '
          'the main clause.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'The warning at the close',
      text: 'The final sentence delivers the point: speed can defeat its own '
          'purpose.',
    ),
  ],
);

/// 10. Idiomatik: Sprichwörter.
final QuizContent questC21SprichwoerterContent = sentenceQuestQuiz(
  id: 'quest_c2_1_sprichwoerter',
  title: 'C2.1 · Sprichwörter',
  promptLabel: 'Wort',
  subjectsLabel: 'Sprichwörter',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'Sprichwort',
  intro: 'Proverbs condense cultural wisdom into fixed sayings. A C2 speaker '
      'recognises and deploys them. Complete the missing word.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'Common proverbs',
      text: '"Morgenstund hat Gold im Mund." "Wer A sagt, muss auch B sagen." '
          '"Übung macht den Meister."',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Fixed and metaphorical',
      text: 'Proverbs are frozen: the wording doesn’t change and the meaning is '
          'figurative.',
    ),
  ],
  items: [
    qsi('Übung macht den ____. (practice makes perfect)', 'Meister',
        'Practice makes perfect.', 'Übung macht den Meister'),
    qsi('Morgenstund hat ____ im Mund. (the early bird …)', 'Gold',
        'The early bird catches the worm.', 'Morgenstund hat Gold im Mund'),
    qsi('Der Apfel fällt nicht weit vom ____. (like father, like son)', 'Stamm',
        'The apple doesn’t fall far from the tree.',
        'Apfel fällt nicht weit vom Stamm'),
    qsi('Wer zuletzt lacht, lacht am ____. (he who laughs last …)', 'besten',
        'He who laughs last laughs longest.', 'Wer zuletzt lacht …'),
    qsi('Aller Anfang ist ____. (the first step is the hardest)', 'schwer',
        'Every beginning is hard.', 'Aller Anfang ist schwer'),
  ],
);

/// 11. Diktat: Register & Stil.
final QuizContent questC21DiktatContent = dictationQuestQuiz(
  id: 'quest_c2_1_diktat_register',
  title: 'C2.1 · Diktat: Register & Stil',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro: 'A dictation in elevated, formal German. You HEAR a sentence and TYPE '
      'it. Listen for collocations, Konjunktiv I and precise vocabulary.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Formal register',
      text: 'These sentences avoid colloquialisms; spell the formal words in '
          'full (erhalten, ausgezeichnet).',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Long, layered sentences',
      text: 'Hold the whole clause before you write; the verb may come late.',
    ),
  ],
  sentences: const [
    SpeakPhrase(
        phrase: 'Die Regierung erklärte, sie habe alle Optionen geprüft.',
        meaning: 'The government said it had examined all options.'),
    SpeakPhrase(
        phrase: 'Wir müssen umgehend geeignete Maßnahmen ergreifen.',
        meaning: 'We must take suitable measures immediately.'),
    SpeakPhrase(
        phrase: 'Sehr geehrte Damen und Herren, ich danke Ihnen für Ihr '
            'Erscheinen.',
        meaning: 'Ladies and gentlemen, thank you for coming.'),
    SpeakPhrase(
        phrase: 'Das Unternehmen legt großen Wert auf Nachhaltigkeit.',
        meaning: 'The company places great value on sustainability.'),
    SpeakPhrase(
        phrase: 'Es ist an der Zeit, dass wir Verantwortung übernehmen.',
        meaning: 'It is time for us to take responsibility.'),
    SpeakPhrase(
        phrase: 'Aller Anfang ist schwer, doch Übung macht den Meister.',
        meaning: 'Every beginning is hard, but practice makes perfect.'),
  ],
);

/// 12. Sprechen: Spontan reagieren & moderieren.
final QuizContent questC21SprechenModerierenContent = speakQuestQuiz(
  id: 'quest_c2_1_sprechen_moderieren',
  title: 'C2.1 · Sprechen: Moderieren',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro: 'Chair a discussion and react spontaneously — fluent, flexible C2 '
      'speech. Listen and repeat these moderation phrases.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Manage the floor',
      text: '"Darf ich kurz einhaken?", "Lassen Sie ihn bitte ausreden.", '
          '"Kommen wir zum nächsten Punkt."',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Paraphrase & summarise',
      text: '"Wenn ich Sie richtig verstehe, meinen Sie …" keeps a discussion on '
          'track.',
    ),
  ],
  phrases: const [
    SpeakPhrase(
        phrase: 'Darf ich an dieser Stelle kurz einhaken?',
        meaning: 'May I cut in briefly at this point?'),
    SpeakPhrase(
        phrase: 'Lassen Sie ihn bitte ausreden.',
        meaning: 'Please let him finish.'),
    SpeakPhrase(
        phrase: 'Wenn ich Sie richtig verstehe, meinen Sie …',
        meaning: 'If I understand you correctly, you mean …'),
    SpeakPhrase(
        phrase: 'Kommen wir nun zum nächsten Punkt.',
        meaning: 'Let’s move on to the next point.'),
    SpeakPhrase(
        phrase: 'Das bringt mich zu einer interessanten Frage.',
        meaning: 'That brings me to an interesting question.'),
    SpeakPhrase(
        phrase: 'Wir müssen leider zum Schluss kommen.',
        meaning: 'Unfortunately we have to come to a close.'),
  ],
);

/// 13. Hören: Satire / Kabarett-Ausschnitt.
final QuizContent questC21HoerenSatireContent = listeningQuestQuiz(
  id: 'quest_c2_1_hoeren_satire',
  // The cabaret piece portrays a man ("der perfekte Bürger … er") — male voice.
  voiceGender: VoiceGender.male,
  title: 'C2.1 · Hören: Satire',
  category: 'Media',
  passageTitle: 'Kabarett: Der perfekte Bürger',
  passage:
      'Der perfekte Bürger, meine Damen und Herren, trennt seinen Müll in '
      'siebzehn Tonnen, fährt selbstverständlich nur noch Fahrrad – natürlich '
      'eines aus nachhaltigem Bambus, importiert um den halben Globus – und '
      'erklärt jedem ungefragt, wie gut er für das Klima lebt. Dass er dabei '
      'dreimal im Jahr in den Urlaub fliegt, erwähnt er lieber nicht. Aber '
      'pssst: Hauptsache, das Gewissen ist beruhigt.',
  passageTranslation:
      'The perfect citizen, ladies and gentlemen, separates his rubbish into '
      'seventeen bins, of course only cycles anymore – naturally on a bike made '
      'of sustainable bamboo, imported halfway around the globe – and explains '
      'to everyone, unasked, how well he lives for the climate. That he flies on '
      'holiday three times a year he prefers not to mention. But shhh: the main '
      'thing is that his conscience is at ease.',
  questions: const [
    ReadingQuestion(
      question: 'Worüber macht sich der Kabarettist lustig?',
      questionTranslation: 'What is the cabaret artist making fun of?',
      options: [
        'über scheinheiliges Umweltbewusstsein',
        'über die Mülltrennung an sich',
        'über das Fahrradfahren'
      ],
      optionsTranslation: [
        'about hypocritical environmental awareness',
        'about waste separation as such',
        'about cycling'
      ],
      correctIndex: 0,
      explanation: 'Die Pointe: Er fliegt dreimal im Jahr, predigt aber '
          'Klimaschutz.',
    ),
    ReadingQuestion(
      question: 'Welcher Widerspruch wird aufgedeckt?',
      questionTranslation: 'Which contradiction is revealed?',
      options: [
        'Er predigt Klimaschutz, fliegt aber oft in den Urlaub.',
        'Er fährt Fahrrad, hat aber kein Auto.',
        'Er trennt Müll, kauft aber zu viel.'
      ],
      optionsTranslation: [
        'He preaches climate protection but flies on holiday often.',
        'He cycles but has no car.',
        'He separates rubbish but buys too much.'
      ],
      correctIndex: 0,
      explanation: '"Dass er dabei dreimal im Jahr in den Urlaub fliegt, '
          'erwähnt er lieber nicht."',
    ),
    ReadingQuestion(
      question: 'Was ist laut Pointe „die Hauptsache"?',
      questionTranslation: 'What is "the main thing", according to the punchline?',
      options: [
        'dass das Gewissen beruhigt ist',
        'dass die Umwelt gerettet wird',
        'dass alle es sehen'
      ],
      optionsTranslation: [
        'that the conscience is at ease',
        'that the environment is saved',
        'that everyone sees it'
      ],
      correctIndex: 0,
      explanation: '"Hauptsache, das Gewissen ist beruhigt."',
    ),
  ],
  intro: 'A satirical cabaret piece — you only hear it. The humour is in the '
      'irony and the exaggeration. Listen for the contradiction the artist '
      'exposes. Replay as needed.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Irony means the opposite',
      text: '"der perfekte Bürger" is praised in order to mock him. Read the '
          'tone, not the words.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'The punchline at the end',
      text: 'Satire saves the sting for last ("Hauptsache, das Gewissen ist '
          'beruhigt").',
    ),
  ],
);

/// 14. Lesen: Eine literarische Kurzgeschichte.
final QuizContent questC21LesenKurzgeschichteContent = readingQuestQuiz(
  id: 'quest_c2_1_lesen_kurzgeschichte',
  title: 'C2.1 · Lesen: Kurzgeschichte',
  category: 'Arts',
  passageTitle: 'Kurzgeschichte: Der Stuhl',
  passage:
      'Seit dem Tod seiner Frau ließ der alte Mann den Stuhl ihr gegenüber '
      'unberührt. Niemand durfte sich dorthin setzen, nicht die Kinder, nicht '
      'die Gäste. Morgens deckte er für zwei, abends räumte er einen vollen '
      'Teller ab. Die Nachbarn tuschelten, er habe den Verstand verloren. Vielleicht '
      'hatten sie recht. Vielleicht aber war es das Einzige, was ihm geblieben '
      'war: die Gewohnheit, jemanden zu erwarten, der nicht mehr kam.',
  passageTranslation:
      'Since his wife’s death the old man left the chair opposite hers '
      'untouched. No one was allowed to sit there, not the children, not the '
      'guests. In the morning he set the table for two, in the evening he '
      'cleared away a full plate. The neighbours whispered that he had lost his '
      'mind. Perhaps they were right. But perhaps it was the only thing left to '
      'him: the habit of expecting someone who no longer came.',
  questions: const [
    ReadingQuestion(
      question: 'Warum bleibt der Stuhl unberührt?',
      questionTranslation: 'Why does the chair remain untouched?',
      options: [
        'Er gehörte seiner verstorbenen Frau.',
        'Er ist kaputt.',
        'Er ist zu wertvoll.'
      ],
      optionsTranslation: [
        'It belonged to his deceased wife.',
        'It is broken.',
        'It is too valuable.'
      ],
      correctIndex: 0,
      explanation: 'Der Mann hält den Platz seiner toten Frau frei.',
    ),
    ReadingQuestion(
      question: 'Was sagen die Nachbarn über den Mann?',
      questionTranslation: 'What do the neighbours say about the man?',
      options: [
        'er habe den Verstand verloren',
        'er sei sehr reich',
        'er wolle umziehen'
      ],
      optionsTranslation: [
        'that he had lost his mind',
        'that he is very rich',
        'that he wants to move'
      ],
      correctIndex: 0,
      explanation: '"… er habe den Verstand verloren."',
    ),
    ReadingQuestion(
      question: 'Wie deutet der Erzähler das Verhalten am Ende?',
      questionTranslation: 'How does the narrator interpret the behaviour at the end?',
      options: [
        'als das Einzige, was ihm geblieben war',
        'als reine Verrücktheit',
        'als Wunsch nach Aufmerksamkeit'
      ],
      optionsTranslation: [
        'as the only thing left to him',
        'as pure madness',
        'as a wish for attention'
      ],
      correctIndex: 0,
      explanation: '"… das Einzige, was ihm geblieben war …"',
    ),
  ],
  intro: 'A literary short story — restrained, melancholic, with reported speech '
      '(er habe) and an ambiguous, empathetic ending. GDS-level interpretation.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Show, don’t tell',
      text: 'The grief is shown through the actions (decken für zwei), never '
          'named directly.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Vielleicht … Vielleicht aber …',
      text: 'The narrator weighs two readings without deciding — the empathy is '
          'in the second one.',
    ),
  ],
);

/// Every C2.1 quiz, in chain order — all five exercise types, interleaved.
final List<QuizContent> questC2_1Content = [
  questC21WirtschaftContent, //          Wirtschaft & Recht     (knowledge)
  questC21RegisterContent, //            Register               (knowledge)
  questC21SprechenRedeContent, //        Sprechen: Rede         (speaking)
  questC21KollokationenContent, //       Kollokationen          (knowledge)
  questC21StilmittelContent, //          Stilmittel & Rhetorik  (knowledge)
  questC21HoerenFeatureContent, //       Hören: Feature         (listening)
  questC21Konj1LitContent, //            Konjunktiv I (Presse)  (knowledge·verb)
  questC21KonnotationContent, //         Konnotation            (knowledge)
  questC21LesenArtikelContent, //        Lesen: Zeitungsartikel (reading)
  questC21SprichwoerterContent, //       Sprichwörter           (knowledge)
  questC21DiktatContent, //              Diktat: Register       (dictation)
  questC21SprechenModerierenContent, //  Sprechen: Moderieren   (speaking)
  questC21HoerenSatireContent, //        Hören: Satire          (listening)
  questC21LesenKurzgeschichteContent, // Lesen: Kurzgeschichte  (reading)
];
