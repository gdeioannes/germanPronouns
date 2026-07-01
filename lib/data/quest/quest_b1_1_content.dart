import '../../models/quiz_content.dart';
import 'quest_builders.dart';

/// CEFR **B1.1 — "Meinungen & Wünsche"** Quest quizzes (Goethe B1 / Zertifikat
/// B1). Big rocks: the **Konjunktiv II** (würde/hätte/wäre — politeness and
/// hypothesis), **adjective endings**, the **Genitiv**, relative clauses and
/// Futur I.

/// 1. Die Welt der Arbeit (vocab).
final QuizContent questB11ArbeitContent = sentenceQuestQuiz(
  id: 'quest_b1_1_arbeit',
  title: 'B1.1 · Die Welt der Arbeit',
  promptLabel: 'Wort',
  subjectsLabel: 'Arbeit',
  subjectColumnLabel: 'English',
  categoryLabel: 'Arbeit',
  contextualLayout: true,
  intro: 'The world of work is a core B1 topic. Watch the false friends: "der '
      'Chef" = boss, "die Rente" = pension, "der Termin" = appointment.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'False friends (E20)',
      text: 'der Chef ≠ chef (it’s the boss); die Rente ≠ rent (it’s a pension); '
          'der Termin ≠ terminal (it’s an appointment/deadline).',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Useful work words',
      text: 'die Stelle/der Job (job), die Bewerbung (application), das '
          'Gehalt (salary), die Kollegin (colleague).',
    ),
  ],
  items: [
    qsi('Ich suche eine neue ____. (job/position)', 'Stelle',
        'I’m looking for a new position.', 'position'),
    qsi('Mein ____ ist sehr nett. (boss)', 'Chef', 'My boss is very nice.',
        'boss'),
    qsi('Ich schicke meine ____ an die Firma. (application)', 'Bewerbung',
        'I send my application to the company.', 'application'),
    qsi('Das ____ ist nicht sehr hoch. (salary)', 'Gehalt',
        'The salary is not very high.', 'salary'),
    qsi('Mit 67 Jahren geht man in ____. (retirement)', 'Rente',
        'At 67 you retire.', 'retirement/pension'),
    qsi('Ich habe morgen einen wichtigen ____. (appointment)', 'Termin',
        'I have an important appointment tomorrow.', 'appointment'),
  ],
);

/// 2. Adjektivendungen: bestimmter Artikel.
final QuizContent questB11AdjBestimmtContent = sentenceQuestQuiz(
  id: 'quest_b1_1_adj_bestimmt',
  title: 'B1.1 · Adjektivendungen: bestimmter Artikel',
  promptLabel: 'Endung',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'nach der/die/das',
  intro: 'When an adjective stands before a noun it needs an ending. After the '
      'definite article (der/die/das), which already shows the case, the '
      'adjective just takes **-e** or **-en** — the "weak" endings.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'The "one strong signal" rule',
      text: 'der/die/das already marks the case, so the adjective only needs '
          '-e (nom. sing. & fem./neut. acc.) or -en (everywhere else).',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Nominative singular = -e',
      text: 'der __große__ Mann, die __kleine__ Frau, das __neue__ Auto. '
          'Accusative masculine flips to -en: den __großen__ Mann.',
    ),
  ],
  items: [
    qsi('Der ____ Mann liest. (groß, Nom. m)', 'große',
        'The tall man is reading.', 'der große Mann'),
    qsi('Ich sehe den ____ Mann. (groß, Akk. m)', 'großen',
        'I see the tall man.', 'den großen Mann'),
    qsi('Die ____ Frau singt. (jung, Nom. f)', 'junge',
        'The young woman is singing.', 'die junge Frau'),
    qsi('Das ____ Auto ist teuer. (neu, Nom. n)', 'neue',
        'The new car is expensive.', 'das neue Auto'),
    qsi('Ich mag die ____ Schuhe. (rot, Akk. Pl.)', 'roten',
        'I like the red shoes.', 'die roten Schuhe'),
  ],
);

/// 3. Sprechen: Höfliche Bitten.
final QuizContent questB11SprechenBittenContent = speakQuestQuiz(
  id: 'quest_b1_1_sprechen_bitten',
  title: 'B1.1 · Sprechen: Höfliche Bitten',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro: 'Polite requests use the Konjunktiv II — könnten, würden, hätte gern. '
      'Listen and repeat; these soften a request the way "could/would" do in '
      'English.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'könnten / würden = could / would',
      text: '"__Könnten__ Sie mir helfen?" is far more polite than "Helfen Sie '
          'mir!".',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Ich hätte gern / Ich möchte',
      text: 'In a shop or café: "Ich __hätte gern__ einen Kaffee" / "Ich '
          '__möchte__ bezahlen."',
    ),
  ],
  phrases: const [
    SpeakPhrase(
        phrase: 'Könnten Sie mir bitte helfen?',
        meaning: 'Could you please help me?'),
    SpeakPhrase(
        phrase: 'Würden Sie das Fenster öffnen?',
        meaning: 'Would you open the window?'),
    SpeakPhrase(
        phrase: 'Ich hätte gern eine Tasse Tee.',
        meaning: 'I would like a cup of tea.'),
    SpeakPhrase(
        phrase: 'Dürfte ich Sie etwas fragen?',
        meaning: 'Might I ask you something?'),
    SpeakPhrase(
        phrase: 'Wäre es möglich, später zu kommen?',
        meaning: 'Would it be possible to come later?'),
    SpeakPhrase(
        phrase: 'Vielen Dank, das ist sehr nett.',
        meaning: 'Thank you, that’s very kind.'),
  ],
);

/// 4. Adjektivendungen: unbestimmter Artikel.
final QuizContent questB11AdjUnbestimmtContent = sentenceQuestQuiz(
  id: 'quest_b1_1_adj_unbestimmt',
  title: 'B1.1 · Adjektivendungen: unbestimmter Artikel',
  promptLabel: 'Endung',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'nach ein/eine',
  intro: 'After ein/eine (which does NOT show the case for masculine nominative '
      'or any neuter), the adjective itself must carry the signal: -er / -e / '
      '-es.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'The adjective shows the case',
      text: 'ein __großer__ Mann (-er = masc. nom.), eine __kleine__ Frau (-e), '
          'ein __neues__ Auto (-es = neut.).',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Accusative masculine → -en',
      text: 'einen __großen__ Mann. As soon as the article shows -en (einen), '
          'the adjective follows with -en.',
    ),
  ],
  items: [
    qsi('Das ist ein ____ Mann. (groß, Nom. m)', 'großer',
        'That is a tall man.', 'ein großer Mann'),
    qsi('Ich habe einen ____ Hund. (klein, Akk. m)', 'kleinen',
        'I have a small dog.', 'einen kleinen Hund'),
    qsi('Sie trägt eine ____ Jacke. (rot, Akk. f)', 'rote',
        'She is wearing a red jacket.', 'eine rote Jacke'),
    qsi('Wir haben ein ____ Haus. (neu, Akk. n)', 'neues',
        'We have a new house.', 'ein neues Haus'),
    qsi('Das ist ein ____ Problem. (schwierig, Nom. n)', 'schwieriges',
        'That is a difficult problem.', 'ein schwieriges Problem'),
  ],
);

/// 5. Konjunktiv II: würde + Infinitiv.
final QuizContent questB11Konj2WuerdeContent = sentenceQuestQuiz(
  id: 'quest_b1_1_konj2_wuerde',
  title: 'B1.1 · Konjunktiv II: würde + Infinitiv',
  promptLabel: 'würde-Form',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'würde + Infinitiv',
  intro: 'The Konjunktiv II expresses wishes, polite requests and hypotheses. '
      'The all-purpose form is **würde + infinitive** — your safe default.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'würde forms',
      text: 'ich würde, du würdest, er würde, wir würden … + infinitive at the '
          'end: "Ich __würde__ gern nach Italien __fahren__."',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'When in doubt, würde',
      text: 'For most verbs, würde + Infinitiv is correct and natural. Learn '
          'hätte/wäre/könnte separately (next quiz).',
    ),
  ],
  items: [
    qsi('Ich ____ gern mehr reisen. (würde, ich)', 'würde',
        'I would like to travel more.', 'ich würde'),
    qsi('____ du mir helfen? (würde, du)', 'Würdest',
        'Would you help me?', 'du würdest'),
    qsi('Er ____ nie so etwas sagen. (würde, er)', 'würde',
        'He would never say such a thing.', 'er würde'),
    qsi('Wir ____ gern ein Haus kaufen. (würde, wir)', 'würden',
        'We would like to buy a house.', 'wir würden'),
    qsi('An deiner Stelle ____ ich das nicht machen. (würde, ich)', 'würde',
        "In your place I wouldn't do that.", 'ich würde'),
  ],
);

/// 6. Hören: Ein Vorstellungsgespräch.
final QuizContent questB11HoerenInterviewContent = listeningQuestQuiz(
  id: 'quest_b1_1_hoeren_interview',
  title: 'B1.1 · Hören: Vorstellungsgespräch',
  category: 'Work',
  passageTitle: 'Im Vorstellungsgespräch',
  passage:
      'Guten Tag, Frau Wagner, schön, dass Sie da sind. Erzählen Sie ein wenig '
      'über sich. Ich habe drei Jahre als Verkäuferin gearbeitet, aber jetzt '
      'möchte ich etwas Neues machen. Ich würde gern im Büro arbeiten, weil ich '
      'gut organisieren kann. Ich spreche Deutsch und Englisch. Könnten Sie mir '
      'sagen, wie die Arbeitszeiten sind?',
  passageTranslation:
      'Good day, Ms Wagner, nice that you’re here. Tell us a little about '
      'yourself. I worked as a salesperson for three years, but now I would like '
      'to do something new. I would like to work in an office, because I am good '
      'at organising. I speak German and English. Could you tell me what the '
      'working hours are?',
  questions: const [
    ReadingQuestion(
      question: 'Was hat Frau Wagner früher gemacht?',
      questionTranslation: 'What did Ms Wagner do before?',
      options: [
        'Sie hat im Büro gearbeitet.',
        'Sie hat als Verkäuferin gearbeitet.',
        'Sie war Lehrerin.'
      ],
      optionsTranslation: [
        'She worked in an office.',
        'She worked as a salesperson.',
        'She was a teacher.'
      ],
      correctIndex: 1,
      explanation: '"Ich habe drei Jahre als Verkäuferin gearbeitet …"',
    ),
    ReadingQuestion(
      question: 'Warum möchte sie im Büro arbeiten?',
      questionTranslation: 'Why does she want to work in an office?',
      options: [
        'weil sie gut organisieren kann',
        'weil es mehr Geld gibt',
        'weil es näher ist'
      ],
      optionsTranslation: [
        'because she’s good at organising',
        'because it pays more',
        'because it’s closer'
      ],
      correctIndex: 0,
      explanation: '"… weil ich gut organisieren kann."',
    ),
    ReadingQuestion(
      question: 'Was möchte Frau Wagner wissen?',
      questionTranslation: 'What does Ms Wagner want to know?',
      options: ['das Gehalt', 'die Arbeitszeiten', 'den Urlaub'],
      optionsTranslation: ['the salary', 'the working hours', 'the holidays'],
      correctIndex: 1,
      explanation: '"… wie die Arbeitszeiten sind?"',
    ),
    ReadingQuestion(
      question: 'Wie lange hat sie als Verkäuferin gearbeitet?',
      questionTranslation: 'How long did she work as a salesperson?',
      options: ['ein Jahr', 'drei Jahre', 'fünf Jahre'],
      optionsTranslation: ['one year', 'three years', 'five years'],
      correctIndex: 1,
      explanation: '"Ich habe drei Jahre als Verkäuferin gearbeitet …"',
    ),
    ReadingQuestion(
      question: 'Welche Sprachen spricht Frau Wagner?',
      questionTranslation: 'Which languages does Ms Wagner speak?',
      options: [
        'Deutsch und Französisch',
        'Deutsch und Englisch',
        'nur Deutsch',
      ],
      optionsTranslation: [
        'German and French',
        'German and English',
        'only German',
      ],
      correctIndex: 1,
      explanation: '"Ich spreche Deutsch und Englisch."',
    ),
  ],
  intro: 'A job interview — you only hear it. Listen for the past job, the '
      'reason (weil …) and the question she asks. Replay as needed.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Polite Konjunktiv',
      text: '"Ich würde gern …", "Könnten Sie …?" mark wishes and polite '
          'questions in an interview.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Listen for the job',
      text: '"als Verkäuferin gearbeitet" tells you her previous role — a likely '
          'question.',
    ),
  ],
);

/// 7. Konjunktiv II: hätte / wäre / könnte.
final QuizContent questB11Konj2HaetteContent = sentenceQuestQuiz(
  id: 'quest_b1_1_konj2_haette',
  title: 'B1.1 · Konjunktiv II: hätte / wäre / könnte',
  promptLabel: 'Konjunktiv II',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'hätte/wäre/könnte',
  intro: 'A few very common verbs use their own one-word Konjunktiv II instead '
      'of würde: **hätte** (would have), **wäre** (would be), **könnte** (could), '
      'plus möchte and the modals.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Learn these by heart',
      text: 'sein → wäre, haben → hätte, können → könnte, müssen → müsste, '
          'werden → würde.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Wishes with the past',
      text: '"Ich __hätte__ gern mehr Zeit." "Es __wäre__ schön, wenn …" "Du '
          '__könntest__ recht haben."',
    ),
  ],
  items: [
    qsi('Ich ____ gern mehr Zeit. (haben)', 'hätte',
        'I would like to have more time.', 'ich hätte'),
    qsi('Das ____ wirklich schön. (sein)', 'wäre',
        'That would be really nice.', 'es wäre'),
    qsi('____ du mir kurz helfen? (können)', 'Könntest',
        'Could you help me for a moment?', 'du könntest'),
    qsi('Wir ____ jetzt eigentlich gehen. (müssen)', 'müssten',
        'We really ought to go now.', 'wir müssten'),
    qsi('An deiner Stelle ____ ich froh. (sein)', 'wäre',
        'In your place I would be glad.', 'ich wäre'),
    qsi('Wenn ich reich ____, würde ich reisen. (sein)', 'wäre',
        'If I were rich, I would travel.', 'ich wäre'),
    qsi('____ ihr uns morgen besuchen? (können)', 'Könntet',
        'Could you visit us tomorrow?', 'ihr könntet'),
    qsi('Ich ____ gern einen Kaffee. (mögen)', 'möchte',
        'I would like a coffee.', 'ich möchte'),
    qsi('Wir ____ gern ein größeres Auto. (haben)', 'hätten',
        'We would like a bigger car.', 'wir hätten'),
  ],
);

/// 8. Lesen: Die Zukunft der Arbeit.
final QuizContent questB11LesenArbeitContent = readingQuestQuiz(
  id: 'quest_b1_1_lesen_arbeit',
  title: 'B1.1 · Lesen: Die Zukunft der Arbeit',
  category: 'Work',
  passageTitle: 'Arbeiten von zu Hause',
  passage:
      'Immer mehr Menschen arbeiten heute von zu Hause. Das nennt man '
      'Homeoffice. Viele Angestellte finden das praktisch, weil sie keine Zeit '
      'für den Weg zur Arbeit verlieren. Sie könnten morgens länger schlafen und '
      'flexibler arbeiten. Manche Chefs sind aber skeptisch, weil sie ihre '
      'Mitarbeiter nicht sehen. Experten glauben, dass in Zukunft viele Menschen '
      'nur noch ein paar Tage pro Woche ins Büro fahren werden.',
  passageTranslation:
      'More and more people work from home today. This is called "home office". '
      'Many employees find it practical because they don’t lose time on the '
      'commute. They could sleep longer in the morning and work more flexibly. '
      'Some bosses, however, are sceptical because they can’t see their staff. '
      'Experts believe that in future many people will only go to the office a '
      'few days a week.',
  questions: const [
    ReadingQuestion(
      question: 'Warum finden viele Angestellte Homeoffice praktisch?',
      questionTranslation: 'Why do many employees find home office practical?',
      options: [
        'weil das Gehalt höher ist',
        'weil sie keine Zeit für den Weg verlieren',
        'weil das Büro zu klein ist'
      ],
      optionsTranslation: [
        'because the salary is higher',
        'because they don’t lose time commuting',
        'because the office is too small'
      ],
      correctIndex: 1,
      explanation: '"… weil sie keine Zeit für den Weg zur Arbeit verlieren."',
    ),
    ReadingQuestion(
      question: 'Warum sind manche Chefs skeptisch?',
      questionTranslation: 'Why are some bosses sceptical?',
      options: [
        'weil sie ihre Mitarbeiter nicht sehen',
        'weil es teurer ist',
        'weil die Technik fehlt'
      ],
      optionsTranslation: [
        'because they can’t see their staff',
        'because it’s more expensive',
        'because the technology is missing'
      ],
      correctIndex: 0,
      explanation: '"… weil sie ihre Mitarbeiter nicht sehen."',
    ),
    ReadingQuestion(
      question: 'Was glauben Experten über die Zukunft?',
      questionTranslation: 'What do experts believe about the future?',
      options: [
        'Alle werden nur zu Hause arbeiten.',
        'Niemand wird mehr ins Büro fahren.',
        'Viele fahren nur ein paar Tage pro Woche ins Büro.'
      ],
      optionsTranslation: [
        'Everyone will work only at home.',
        'No one will go to the office anymore.',
        'Many will go to the office only a few days a week.'
      ],
      correctIndex: 2,
      explanation: '"… nur noch ein paar Tage pro Woche ins Büro fahren werden."',
    ),
    ReadingQuestion(
      question: 'Wie nennt man das Arbeiten von zu Hause?',
      questionTranslation: 'What is working from home called?',
      options: ['Homeoffice', 'Teilzeit', 'Freizeit'],
      optionsTranslation: ['home office', 'part-time', 'free time'],
      correctIndex: 0,
      explanation: '"Das nennt man Homeoffice."',
    ),
    ReadingQuestion(
      question: 'Was könnten die Angestellten im Homeoffice tun?',
      questionTranslation: 'What could the employees do in the home office?',
      options: [
        'morgens länger schlafen und flexibler arbeiten',
        'mehr Urlaub nehmen',
        'ein höheres Gehalt verlangen',
      ],
      optionsTranslation: [
        'sleep longer and work more flexibly',
        'take more holiday',
        'demand a higher salary',
      ],
      correctIndex: 0,
      explanation: '"Sie könnten morgens länger schlafen und flexibler arbeiten."',
    ),
  ],
  intro: 'An opinion text about home office. It uses weil, Konjunktiv II '
      '(könnten) and the future (werden) — a realistic B1 reading.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Pro and contra',
      text: 'The text gives advantages (praktisch) and a doubt (skeptisch). '
          'Sort the arguments to answer the questions.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Future = werden + Infinitiv',
      text: '"… fahren werden" is Futur I: the infinitive goes last, werden is '
          'conjugated.',
    ),
  ],
);

/// 9. Futur I — werden + Infinitiv.
final QuizContent questB11FuturContent = sentenceQuestQuiz(
  id: 'quest_b1_1_futur',
  title: 'B1.1 · Futur I',
  promptLabel: 'werden-Form',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'Futur I',
  intro: 'The future tense uses **werden + infinitive**. It often expresses a '
      'prediction or a firm intention (everyday plans usually just use the '
      'present + a time word).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'werden conjugated, infinitive last',
      text: 'ich werde, du wirst, er wird, wir werden … "Morgen __wird__ es '
          '__regnen__."',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Prediction',
      text: 'Use Futur I for predictions: "Das __wird__ schwierig __werden__." '
          'For plans, present + morgen is more natural.',
    ),
  ],
  items: [
    qsi('Morgen ____ es regnen. (werden, es)', 'wird',
        'Tomorrow it will rain.', 'es wird'),
    qsi('Ich ____ dich nie vergessen. (werden, ich)', 'werde',
        'I will never forget you.', 'ich werde'),
    qsi('____ du zur Party kommen? (werden, du)', 'Wirst',
        'Will you come to the party?', 'du wirst'),
    qsi('Wir ____ bald umziehen. (werden, wir)', 'werden',
        'We will move soon.', 'wir werden'),
    qsi('Das ____ bestimmt teuer. (werden, es)', 'wird',
        'That will certainly be expensive.', 'es wird'),
  ],
);

/// 10. Relativsätze (Nominativ/Akkusativ).
final QuizContent questB11RelativContent = sentenceQuestQuiz(
  id: 'quest_b1_1_relativ',
  title: 'B1.1 · Relativsätze (Nom./Akk.)',
  promptLabel: 'Relativpronomen',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'Relativpronomen',
  intro: 'A relative clause adds information about a noun. The relative pronoun '
      '(der/die/das…) matches the noun’s **gender/number**, but its **case** '
      'comes from its role inside the relative clause. The verb goes to the end.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Gender from the noun, case from the clause',
      text: 'der Mann, __der__ dort steht (subject → Nom.); der Mann, __den__ '
          'ich kenne (object → Akk.).',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Verb last',
      text: 'The relative clause is a subordinate clause: "…, das ich gekauft '
          '__habe__." Comma before, verb at the end.',
    ),
  ],
  items: [
    qsi('Das ist der Mann, ____ dort steht. (Nom. m)', 'der',
        'That is the man who is standing there.', 'der (Nom.)'),
    qsi('Das ist der Mann, ____ ich gut kenne. (Akk. m)', 'den',
        'That is the man whom I know well.', 'den (Akk.)'),
    qsi('Die Frau, ____ Deutsch spricht, ist nett. (Nom. f)', 'die',
        'The woman who speaks German is nice.', 'die (Nom.)'),
    qsi('Das Buch, ____ ich lese, ist spannend. (Akk. n)', 'das',
        'The book I’m reading is exciting.', 'das (Akk.)'),
    qsi('Die Leute, ____ hier wohnen, sind laut. (Nom. Pl.)', 'die',
        'The people who live here are loud.', 'die (Pl.)'),
  ],
);

/// 11. Genitiv (intro) + Possessivgenitiv.
final QuizContent questB11GenitivContent = sentenceQuestQuiz(
  id: 'quest_b1_1_genitiv',
  title: 'B1.1 · Genitiv',
  promptLabel: 'Genitiv',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'Genitiv',
  intro: 'The **Genitiv** shows possession and relationships (English "of" / '
      '’s). The articles are des/der/des/der and masculine & neuter nouns '
      'add **-s** (des Mannes).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'des/der + -s on m/n nouns',
      text: 'der → des (+ Noun-s), die → der, das → des (+ Noun-s), Plural → '
          'der. "das Auto __des Mannes__".',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Ask "wessen?"',
      text: 'The Genitiv answers **wessen?** (whose?). Spoken German often uses '
          '"von + Dativ" instead (das Auto von dem Mann).',
    ),
  ],
  items: [
    qsi('Das ist das Auto ____ Mannes. (der → des)', 'des',
        'That is the man’s car.', 'des Mannes'),
    qsi('Die Farbe ____ Hauses ist blau. (das → des)', 'des',
        'The colour of the house is blue.', 'des Hauses'),
    qsi('Das ist die Tasche ____ Frau. (die → der)', 'der',
        'That is the woman’s bag.', 'der Frau'),
    qsi('Die Meinung ____ Leute ist wichtig. (Plural → der)', 'der',
        'The opinion of the people is important.', 'der Leute'),
    qsi('Am Ende ____ Films weinte ich. (der → des)', 'des',
        'At the end of the film I cried.', 'des Films'),
  ],
);

/// 12. Diktat: Wünsche & Bitten.
final QuizContent questB11DiktatContent = dictationQuestQuiz(
  id: 'quest_b1_1_diktat_konjunktiv',
  title: 'B1.1 · Diktat: Wünsche & Bitten',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro: 'A dictation with the Konjunktiv II. You HEAR a sentence and TYPE it. '
      'Listen for würde/hätte/wäre/könnte and the infinitive at the end.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Polite forms',
      text: 'könnten/würden + infinitive make a request polite. Write the '
          'infinitive at the end.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'wäre vs ware',
      text: 'wäre has an umlaut (ä). Type "waere" if you can’t make the umlaut — '
          'it’s accepted.',
    ),
  ],
  sentences: const [
    SpeakPhrase(
        phrase: 'Ich würde gern nach Spanien fahren.',
        meaning: 'I would like to go to Spain.'),
    SpeakPhrase(
        phrase: 'Könnten Sie mir bitte helfen?',
        meaning: 'Could you please help me?'),
    SpeakPhrase(
        phrase: 'Ich hätte gern einen Termin.',
        meaning: 'I would like an appointment.'),
    SpeakPhrase(
        phrase: 'Es wäre schön, wenn du kommen würdest.',
        meaning: 'It would be nice if you came.'),
    SpeakPhrase(
        phrase: 'An deiner Stelle würde ich das nicht machen.',
        meaning: "In your place I wouldn't do that."),
    SpeakPhrase(
        phrase: 'Wir müssten eigentlich gehen.',
        meaning: 'We really ought to go.'),
  ],
);

/// 13. Sprechen: Meinung äußern.
final QuizContent questB11SprechenMeinungContent = speakQuestQuiz(
  id: 'quest_b1_1_sprechen_meinung',
  title: 'B1.1 · Sprechen: Meinung äußern',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro: 'Express and justify an opinion — a core B1 speaking skill. Listen and '
      'repeat these opener phrases.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Opinion openers',
      text: '"Meiner Meinung nach …", "Ich finde, dass …", "Ich bin der '
          'Meinung, dass …".',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Agree / disagree',
      text: '"Da stimme ich zu." (I agree.) "Das sehe ich anders." (I see it '
          'differently.)',
    ),
  ],
  phrases: const [
    SpeakPhrase(
        phrase: 'Meiner Meinung nach ist das richtig.',
        meaning: 'In my opinion that is right.'),
    SpeakPhrase(
        phrase: 'Ich finde, dass das eine gute Idee ist.',
        meaning: 'I think that is a good idea.'),
    SpeakPhrase(
        phrase: 'Einerseits ja, andererseits nein.',
        meaning: 'On the one hand yes, on the other no.'),
    SpeakPhrase(
        phrase: 'Da stimme ich dir zu.', meaning: 'I agree with you.'),
    SpeakPhrase(
        phrase: 'Das sehe ich leider anders.',
        meaning: 'Unfortunately I see it differently.'),
    SpeakPhrase(
        phrase: 'Was meinst du dazu?',
        meaning: 'What do you think about it?'),
  ],
);

/// 14. Nebensätze: wenn / als / obwohl.
final QuizContent questB11KonjunktionenContent = sentenceQuestQuiz(
  id: 'quest_b1_1_konjunktionen',
  title: 'B1.1 · Nebensätze: wenn / als / obwohl',
  promptLabel: 'Konjunktion',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'Konjunktion',
  intro: 'These subordinating conjunctions all send the verb to the end: **wenn** '
      '(if/whenever), **als** (when, single past event), **obwohl** (although).',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'wenn vs als',
      text: '**als** for a single event in the past (Als ich klein war …); '
          '**wenn** for repeated or present/future (Immer wenn …, Wenn ich Zeit '
          'habe …).',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'obwohl = although',
      text: '"Ich gehe joggen, __obwohl__ es regnet." Concession — verb at the '
          'end as always.',
    ),
  ],
  items: [
    qsi('____ ich Zeit habe, lese ich. (whenever/if)', 'Wenn',
        'Whenever I have time, I read.', 'wenn'),
    qsi('____ ich ein Kind war, wohnten wir in Köln. (when, past)', 'Als',
        'When I was a child, we lived in Cologne.', 'als'),
    qsi('Wir gehen spazieren, ____ es kalt ist. (although)', 'obwohl',
        'We go for a walk although it is cold.', 'obwohl'),
    qsi('____ du anrufst, bin ich zu Hause. (if/when)', 'Wenn',
        'If you call, I’m at home.', 'wenn'),
    qsi('____ der Film begann, kamen wir zu spät. (when, past)', 'Als',
        'When the film began, we arrived too late.', 'als'),
  ],
);

/// 15. Hören: Eine Radio-Umfrage.
final QuizContent questB11HoerenUmfrageContent = listeningQuestQuiz(
  id: 'quest_b1_1_hoeren_umfrage',
  title: 'B1.1 · Hören: Radio-Umfrage',
  category: 'Media',
  passageTitle: 'Umfrage: Freizeit',
  passage:
      'Wir haben Passanten gefragt: Was machen Sie in Ihrer Freizeit? Eine junge '
      'Frau sagt: "Ich treibe gern Sport, vor allem schwimme ich dreimal pro '
      'Woche." Ein älterer Mann antwortet: "Ich würde gern mehr reisen, aber ich '
      'habe leider wenig Geld." Ein Student meint: "Am liebsten treffe ich '
      'Freunde und spiele Gitarre."',
  passageTranslation:
      'We asked passers-by: What do you do in your free time? A young woman '
      'says: "I like doing sport, above all I swim three times a week." An older '
      'man answers: "I would like to travel more, but unfortunately I have '
      'little money." A student says: "Most of all I meet friends and play '
      'guitar."',
  questions: const [
    ReadingQuestion(
      question: 'Was macht die junge Frau dreimal pro Woche?',
      questionTranslation: 'What does the young woman do three times a week?',
      options: ['schwimmen', 'reisen', 'Gitarre spielen'],
      optionsTranslation: ['swim', 'travel', 'play guitar'],
      correctIndex: 0,
      explanation: '"… schwimme ich dreimal pro Woche."',
    ),
    ReadingQuestion(
      question: 'Was möchte der ältere Mann, kann es aber nicht?',
      questionTranslation: 'What does the older man want but can’t do?',
      options: ['mehr schlafen', 'mehr reisen', 'mehr arbeiten'],
      optionsTranslation: ['sleep more', 'travel more', 'work more'],
      correctIndex: 1,
      explanation: '"Ich würde gern mehr reisen, aber … wenig Geld."',
    ),
    ReadingQuestion(
      question: 'Was macht der Student am liebsten?',
      questionTranslation: 'What does the student like doing most?',
      options: [
        'allein zu Hause bleiben',
        'Freunde treffen und Gitarre spielen',
        'ins Kino gehen'
      ],
      optionsTranslation: [
        'stay home alone',
        'meet friends and play guitar',
        'go to the cinema'
      ],
      correctIndex: 1,
      explanation: '"… treffe ich Freunde und spiele Gitarre."',
    ),
    ReadingQuestion(
      question: 'Warum reist der ältere Mann nicht mehr?',
      questionTranslation: 'Why doesn’t the older man travel more?',
      options: [
        'weil er wenig Geld hat',
        'weil er keine Zeit hat',
        'weil er krank ist',
      ],
      optionsTranslation: [
        'because he has little money',
        'because he has no time',
        'because he is ill',
      ],
      correctIndex: 0,
      explanation: '"… aber ich habe leider wenig Geld."',
    ),
    ReadingQuestion(
      question: 'Wie viele Personen antworten in der Umfrage?',
      questionTranslation: 'How many people answer in the survey?',
      options: ['zwei', 'drei', 'vier'],
      optionsTranslation: ['two', 'three', 'four'],
      correctIndex: 1,
      explanation: 'A young woman, an older man and a student — three answers.',
    ),
  ],
  intro: 'A street survey with three speakers — you only hear it. Keep each '
      'person’s answer separate. Replay as needed.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Three voices',
      text: 'junge Frau / älterer Mann / Student. Tag each fact to the right '
          'person.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'würde gern = would like to',
      text: 'The man’s wish is marked by "Ich würde gern …" — a clue for his '
          'answer.',
    ),
  ],
);

/// 16. Lesen: Im Ausland studieren.
final QuizContent questB11LesenStudiumContent = readingQuestQuiz(
  id: 'quest_b1_1_lesen_studium',
  title: 'B1.1 · Lesen: Im Ausland studieren',
  category: 'Education',
  passageTitle: 'Ein Jahr in Deutschland',
  passage:
      'Viele Studenten möchten ein Semester im Ausland verbringen. Ein '
      'Auslandsjahr hat viele Vorteile: Man lernt eine neue Sprache, findet '
      'Freunde aus aller Welt und wird selbstständiger. Natürlich gibt es auch '
      'Schwierigkeiten. Am Anfang fühlt man sich oft allein, und alles ist '
      'fremd. Aber die meisten Studenten sagen später, dass das Jahr die beste '
      'Entscheidung ihres Lebens war.',
  passageTranslation:
      'Many students would like to spend a semester abroad. A year abroad has '
      'many advantages: you learn a new language, make friends from all over '
      'the world and become more independent. Of course there are also '
      'difficulties. At the beginning you often feel alone, and everything is '
      'foreign. But most students say later that the year was the best decision '
      'of their lives.',
  questions: const [
    ReadingQuestion(
      question: 'Welchen Vorteil nennt der Text?',
      questionTranslation: 'Which advantage does the text mention?',
      options: [
        'Man verdient viel Geld.',
        'Man wird selbstständiger.',
        'Man hat keine Prüfungen.'
      ],
      optionsTranslation: [
        'You earn a lot of money.',
        'You become more independent.',
        'You have no exams.'
      ],
      correctIndex: 1,
      explanation: '"… und wird selbstständiger."',
    ),
    ReadingQuestion(
      question: 'Wie fühlt man sich am Anfang oft?',
      questionTranslation: 'How do you often feel at the beginning?',
      options: ['allein', 'reich', 'krank'],
      optionsTranslation: ['alone', 'rich', 'ill'],
      correctIndex: 0,
      explanation: '"Am Anfang fühlt man sich oft allein …"',
    ),
    ReadingQuestion(
      question: 'Was sagen die meisten Studenten später?',
      questionTranslation: 'What do most students say later?',
      options: [
        'Es war zu teuer.',
        'Es war die beste Entscheidung ihres Lebens.',
        'Sie würden es nicht wieder machen.'
      ],
      optionsTranslation: [
        'It was too expensive.',
        'It was the best decision of their lives.',
        'They wouldn’t do it again.'
      ],
      correctIndex: 1,
      explanation: '"… die beste Entscheidung ihres Lebens war."',
    ),
    ReadingQuestion(
      question: 'Was möchten viele Studenten machen?',
      questionTranslation: 'What do many students want to do?',
      options: [
        'ein Semester im Ausland verbringen',
        'sofort Geld verdienen',
        'nie umziehen',
      ],
      optionsTranslation: [
        'spend a semester abroad',
        'earn money right away',
        'never move',
      ],
      correctIndex: 0,
      explanation: '"Viele Studenten möchten ein Semester im Ausland verbringen."',
    ),
    ReadingQuestion(
      question: 'Welche Schwierigkeit nennt der Text?',
      questionTranslation: 'Which difficulty does the text mention?',
      options: [
        'Am Anfang ist alles fremd.',
        'Das Studium ist zu leicht.',
        'Es gibt keine Sprachkurse.',
      ],
      optionsTranslation: [
        'At first everything is foreign.',
        'The studies are too easy.',
        'There are no language courses.',
      ],
      correctIndex: 0,
      explanation: '"Am Anfang fühlt man sich oft allein, und alles ist fremd."',
    ),
  ],
  intro: 'A text about studying abroad, with the Genitiv (die Entscheidung '
      'ihres Lebens) and dass-clauses. A nice review of B1.1.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Advantages & difficulties',
      text: 'Vorteile (advantages) vs Schwierigkeiten (difficulties) organise '
          'the text. Find the one the question asks about.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'man = one/you',
      text: '"man" is the impersonal subject (one/you in general). It takes the '
          'er/sie/es verb form.',
    ),
  ],
);

/// Big text (inline cloze) — Meine neue Wohnung: adjective endings, the B1.1
/// "cliff", drilled where they actually hurt — inside noun phrases spread across
/// der-words, ein-words and no article, and across nominative/accusative/dative.
/// The learner types the whole declined adjective, so the ending is a decision,
/// not a lookup.
final QuizContent questB11BigTextWohnungContent = bigTextQuestQuiz(
  id: 'quest_b1_1_bigtext_wohnung',
  title: 'B1.1 · Großer Text: Meine neue Wohnung',
  passageTitle: 'Meine neue Wohnung',
  template:
      'Ich habe eine {{0}} Wohnung gefunden. Das {{1}} Zimmer hat ein {{2}} '
      'Fenster. An der Wand hängt ein {{3}} Bild. Ich sitze gern auf dem {{4}} '
      'Sofa. Vor dem Haus steht ein {{5}} Baum. Ich habe {{6}} Nachbarn. Am '
      'Abend trinke ich einen {{7}} Tee.',
  blanks: [
    inputBlank('neue', hint: 'neu · eine … Wohnung (Akk, f)'),
    inputBlank('große', hint: 'groß · das … Zimmer (Nom, n)'),
    inputBlank('großes', hint: 'groß · ein … Fenster (Akk, n)'),
    inputBlank('schönes', hint: 'schön · ein … Bild (Nom, n)'),
    inputBlank('bequemen', hint: 'bequem · auf dem … Sofa (Dat, n)'),
    inputBlank('alter', hint: 'alt · ein … Baum (Nom, m)'),
    inputBlank('nette', hint: 'nett · … Nachbarn (Akk, Plural, kein Artikel)'),
    inputBlank('heißen', accepted: const ['heissen'],
        hint: 'heiß · einen … Tee (Akk, m)'),
  ],
  passageTranslation:
      'I have found a new flat. The big room has a big window. A beautiful '
      'picture hangs on the wall. I like sitting on the comfortable sofa. In '
      'front of the house stands an old tree. I have nice neighbours. In the '
      'evening I drink a hot tea.',
  intro: 'Type each adjective with its ending. The ending depends on three '
      'things at once: the article type (der-word / ein-word / none), the '
      'gender, and the case. Read the noun phrase, decide, then write it.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'One strong signal',
      text: 'If the article already shows the case (das, dem, den …), the '
          'adjective just takes -e or -en. With ein/eine or no article, the '
          'adjective itself carries the strong ending (-er/-es/-e).',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Dative & plural → -en',
      text: 'After a dative (dem/der) and in almost every plural, the ending is '
          '-en: auf dem bequemen Sofa, mit den netten Nachbarn.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'ein has no ending — so the adjective shows the gender',
      text: 'ein __alter__ Baum (m), ein __schönes__ Bild (n): because ein looks '
          'the same, the adjective must reveal masculine (-er) vs neuter (-es).',
    ),
  ],
);

/// Every B1.1 quiz, in chain order — all five exercise types, interleaved.
final List<QuizContent> questB1_1Content = [
  questB11ArbeitContent, //          Die Welt der Arbeit    (knowledge)
  questB11AdjBestimmtContent, //     Adj.: bestimmt         (knowledge)
  questB11SprechenBittenContent, //  Sprechen: Bitten       (speaking)
  questB11AdjUnbestimmtContent, //   Adj.: unbestimmt       (knowledge)
  questB11BigTextWohnungContent, //  Großer Text: Wohnung   (reading·cloze)
  questB11Konj2WuerdeContent, //     Konj. II: würde        (knowledge·verb)
  questB11HoerenInterviewContent, // Hören: Interview       (listening)
  questB11Konj2HaetteContent, //     Konj. II: hätte/wäre   (knowledge·verb)
  questB11LesenArbeitContent, //     Lesen: Zukunft Arbeit  (reading)
  questB11FuturContent, //           Futur I                (knowledge·verb)
  questB11RelativContent, //         Relativsätze           (knowledge)
  questB11DiktatContent, //          Diktat: Wünsche        (dictation)
  questB11GenitivContent, //         Genitiv                (knowledge)
  questB11SprechenMeinungContent, // Sprechen: Meinung      (speaking)
  questB11KonjunktionenContent, //   wenn/als/obwohl        (knowledge)
  questB11HoerenUmfrageContent, //   Hören: Umfrage         (listening)
  questB11LesenStudiumContent, //    Lesen: Ausland         (reading)
];
