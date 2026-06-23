import '../../models/quiz_content.dart';
import 'quest_builders.dart';

/// CEFR **C2.2 — "Meisterschaft"** Quest quizzes (Goethe C2 / GDS) — the
/// capstone module and the reading/listening ceiling of the course. Focus:
/// near-native discourse, implication and allusion, wordplay, and the analysis
/// of abstract, journalistic and literary texts at full density and speed.

/// 1. Philosophie & Gesellschaft (abstrakter Wortschatz).
final QuizContent questC22PhilosophieContent = sentenceQuestQuiz(
  id: 'quest_c2_2_philosophie',
  title: 'C2.2 · Philosophie & Gesellschaft',
  promptLabel: 'Wort',
  subjectsLabel: 'Abstrakt',
  subjectColumnLabel: 'English',
  categoryLabel: 'Abstrakt',
  contextualLayout: true,
  intro: 'The most abstract register of the course — the vocabulary of essays '
      'and philosophical debate.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'Abstract nouns',
      text: 'die Vernunft (reason), die Freiheit (freedom), die Verantwortung '
          '(responsibility), die Gerechtigkeit (justice), das Bewusstsein '
          '(consciousness).',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Nuanced abstractions',
      text: 'distinguish Ethik (ethics) / Moral (morals); Sinn (meaning) / Zweck '
          '(purpose).',
    ),
  ],
  items: [
    qsi('Der Mensch unterscheidet sich durch seine ____. (reason)', 'Vernunft',
        'Humans are distinguished by their reason.', 'reason'),
    qsi('Mit der Freiheit wächst auch die ____. (responsibility)',
        'Verantwortung', 'With freedom grows responsibility too.',
        'responsibility'),
    qsi('Eine gerechte Gesellschaft strebt nach ____. (justice)',
        'Gerechtigkeit', 'A just society strives for justice.', 'justice'),
    qsi('Die Frage nach dem ____ des Lebens ist alt. (meaning)', 'Sinn',
        'The question of the meaning of life is old.', 'meaning'),
    qsi('Das menschliche ____ bleibt ein Rätsel. (consciousness)',
        'Bewusstsein', 'Human consciousness remains a mystery.',
        'consciousness'),
  ],
);

/// 2. Feinheiten: Wortstellung & Fokus.
final QuizContent questC22FokusContent = sentenceQuestQuiz(
  id: 'quest_c2_2_fokus',
  title: 'C2.2 · Wortstellung & Fokus',
  promptLabel: 'Position',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Effekt',
  categoryLabel: 'Fokus',
  intro: 'At C2, word order is a stylistic tool. Fronting an element (Vorfeld) '
      'emphasises it; particles like "selbst", "gerade", "ausgerechnet" focus '
      'attention precisely.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'The Vorfeld emphasises',
      text: '"__Diesen Fehler__ hätte ich nie erwartet." Fronting the object '
          'foregrounds it; the verb stays second.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Focus particles',
      text: 'selbst der Chef (even the boss), gerade heute (of all days, today), '
          'ausgerechnet er (of all people, him).',
    ),
  ],
  items: [
    qsi('____ der Chef wusste nichts davon. (even)', 'Selbst',
        'Even the boss knew nothing about it.', 'selbst (even)'),
    qsi('____ heute musste es regnen! (of all days)', 'Ausgerechnet',
        'Of all days, it had to rain today!', 'ausgerechnet'),
    qsi('____ jetzt willst du gehen? (right …)', 'Gerade',
        'You want to leave right now?', 'gerade (right now)'),
    qsi('____ diesen Film habe ich gemeint. (it was exactly …)', 'Genau',
        'It was exactly this film I meant.', 'genau (exactly)'),
    qsi('____ er hat es geschafft. (of all people)', 'Ausgerechnet',
        'Of all people, he managed it.', 'ausgerechnet'),
  ],
);

/// 3. Anspielungen & implizite Bedeutung.
final QuizContent questC22AnspielungContent = sentenceQuestQuiz(
  id: 'quest_c2_2_anspielung',
  title: 'C2.2 · Anspielungen & Implikatur',
  promptLabel: 'Bedeutung',
  subjectsLabel: 'Äußerungen',
  subjectColumnLabel: 'gemeint ist',
  categoryLabel: 'Implikatur',
  intro: 'Mastery means hearing what is *meant*, not just said. Indirect '
      'requests, understatement and allusion all imply more than the words. '
      'Choose what the speaker really means.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'Indirect speech acts',
      text: '"Es zieht hier." (There’s a draught) often means "Close the '
          'window." "Nicht schlecht." can mean "Really good."',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Litotes (understatement)',
      text: '"Das ist nicht ganz unwichtig" = it’s actually very important. A '
          'double negative softens but intensifies.',
    ),
  ],
  items: [
    qsi('„Es zieht hier." meint oft: Bitte das Fenster ____. (close)',
        'schließen', 'Often means: please close the window.',
        'indirect request'),
    qsi('„Nicht schlecht!" meint meist: ____. (really good)', 'gut',
        'Usually means: really good.', 'understatement'),
    qsi('„Das ist nicht ganz unwichtig." meint: sehr ____. (important)',
        'wichtig', 'Means: very important (litotes).', 'litotes'),
    qsi('„Du bist ja früh dran." (zu jemandem, der zu spät kommt) ist ____. '
        '(irony)', 'Ironie', 'Said to a latecomer: irony.', 'irony'),
    qsi('„Ich will ja nichts sagen, aber …" leitet oft ____ ein. (criticism)',
        'Kritik', 'Often introduces criticism.', 'implied criticism'),
  ],
);

/// 4. Sprechen: Ein Streitgespräch führen.
final QuizContent questC22SprechenStreitContent = speakQuestQuiz(
  id: 'quest_c2_2_sprechen_streitgespraech',
  title: 'C2.2 · Sprechen: Streitgespräch',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro: 'Hold your own in a heated but civil debate — interrupt, rebut and '
      'reframe. Listen and repeat these high-level discussion gambits.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Rebut sharply but politely',
      text: '"Mit Verlaub, das halte ich für ein Scheinargument." is forceful '
          'yet formal.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Reframe',
      text: '"Die eigentliche Frage ist doch eine ganz andere, nämlich …" shifts '
          'the terms of the debate.',
    ),
  ],
  phrases: const [
    SpeakPhrase(
        phrase: 'Mit Verlaub, das halte ich für ein Scheinargument.',
        meaning: 'With respect, I consider that a sham argument.'),
    SpeakPhrase(
        phrase: 'Sie verwechseln hier Ursache und Wirkung.',
        meaning: 'You’re confusing cause and effect here.'),
    SpeakPhrase(
        phrase: 'Die eigentliche Frage ist doch eine ganz andere.',
        meaning: 'The real question is actually quite a different one.'),
    SpeakPhrase(
        phrase: 'Lassen Sie mich das mit einem Beispiel widerlegen.',
        meaning: 'Let me refute that with an example.'),
    SpeakPhrase(
        phrase: 'Da muss ich Ihnen entschieden widersprechen.',
        meaning: 'I have to disagree with you firmly there.'),
    SpeakPhrase(
        phrase: 'Im Kern sind wir uns vermutlich gar nicht so uneinig.',
        meaning: 'At heart we probably don’t disagree that much.'),
  ],
);

/// 5. Stilistische Variation & Paraphrase.
final QuizContent questC22ParaphraseContent = sentenceQuestQuiz(
  id: 'quest_c2_2_paraphrase',
  title: 'C2.2 · Paraphrase & Variation',
  promptLabel: 'Synonym',
  subjectsLabel: 'Ausdrücke',
  subjectColumnLabel: 'Variante',
  categoryLabel: 'Paraphrase',
  intro: 'A master speaker varies expression to avoid repetition and to fit the '
      'register. Reformulate "weil" as "da/aufgrund der Tatsache, dass", '
      '"wichtig" as "von Bedeutung".',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'Elegant variation',
      text: 'wichtig → von Bedeutung / maßgeblich; weil → da / aufgrund; viele → '
          'eine Vielzahl von; zeigen → verdeutlichen.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Same meaning, higher register',
      text: 'Paraphrase upward for formal writing, downward for accessibility.',
    ),
  ],
  items: [
    qsi('„wichtig" gehoben: von ____ (of importance)', 'Bedeutung',
        'important → of importance', 'von Bedeutung'),
    qsi('„weil" gehoben: ____ (since)', 'da', 'because → since (da)', 'da'),
    qsi('„viele" gehoben: eine ____ von (a multitude of)', 'Vielzahl',
        'many → a multitude of', 'eine Vielzahl von'),
    qsi('„zeigen" gehoben: ____ (illustrate/clarify)', 'verdeutlichen',
        'show → clarify', 'verdeutlichen'),
    qsi('„benutzen" gehoben: ____ (employ/use)', 'verwenden',
        'use → employ', 'verwenden'),
  ],
);

/// 6. Hören: Ein wissenschaftlicher Fachvortrag (Originaltempo).
final QuizContent questC22HoerenFachvortragContent = listeningQuestQuiz(
  id: 'quest_c2_2_hoeren_fachvortrag',
  title: 'C2.2 · Hören: Fachvortrag',
  category: 'Science',
  passageTitle: 'Vortrag: Das Gedächtnis',
  passage:
      'Lange Zeit stellte man sich das Gedächtnis wie ein Archiv vor, in dem '
      'Erinnerungen unverändert lagerten. Diese Vorstellung gilt heute als '
      'überholt. Vielmehr deutet die Forschung darauf hin, dass jede Erinnerung '
      'bei ihrem Abruf gewissermaßen neu konstruiert werde – und sich dabei '
      'verändern könne. Erinnern wäre demnach weniger ein Wiederfinden als ein '
      'schöpferischer Akt, dessen Zuverlässigkeit wir womöglich systematisch '
      'überschätzen.',
  passageTranslation:
      'For a long time memory was imagined like an archive in which memories '
      'were stored unchanged. This idea is now regarded as outdated. Rather, '
      'research suggests that every memory is, as it were, reconstructed anew '
      'when recalled – and may change in the process. Remembering would '
      'therefore be less a retrieval than a creative act, whose reliability we '
      'may systematically overestimate.',
  questions: const [
    ReadingQuestion(
      question: 'Welche alte Vorstellung gilt heute als überholt?',
      questionTranslation: 'Which old idea is now considered outdated?',
      options: [
        'das Gedächtnis als unveränderliches Archiv',
        'das Gedächtnis als Muskel',
        'das Gedächtnis als Computer'
      ],
      optionsTranslation: [
        'memory as an unchanging archive',
        'memory as a muscle',
        'memory as a computer'
      ],
      correctIndex: 0,
      explanation: '"… das Gedächtnis wie ein Archiv … gilt heute als überholt."',
    ),
    ReadingQuestion(
      question: 'Was geschieht laut Forschung beim Abruf einer Erinnerung?',
      questionTranslation: 'What happens when a memory is recalled, according to research?',
      options: [
        'Sie wird neu konstruiert und kann sich verändern.',
        'Sie bleibt völlig unverändert.',
        'Sie wird gelöscht.'
      ],
      optionsTranslation: [
        'It is reconstructed and may change.',
        'It stays completely unchanged.',
        'It is deleted.'
      ],
      correctIndex: 0,
      explanation: '"… jede Erinnerung bei ihrem Abruf … neu konstruiert werde …"',
    ),
    ReadingQuestion(
      question: 'Welche Schlussfolgerung zieht der Redner?',
      questionTranslation: 'What conclusion does the speaker draw?',
      options: [
        'Wir überschätzen womöglich die Zuverlässigkeit unserer Erinnerungen.',
        'Unsere Erinnerungen sind absolut zuverlässig.',
        'Erinnern ist unmöglich.'
      ],
      optionsTranslation: [
        'We may overestimate the reliability of our memories.',
        'Our memories are absolutely reliable.',
        'Remembering is impossible.'
      ],
      correctIndex: 0,
      explanation: '"… deren Zuverlässigkeit wir womöglich systematisch '
          'überschätzen."',
    ),
  ],
  intro: 'A dense academic lecture at natural pace — you only hear it. Abstract '
      'and full of reported, hedged claims (werde, könne, wäre). This is the '
      'listening ceiling. Replay as needed.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Old view vs new view',
      text: 'The lecture overturns an old idea ("Archiv") with a new one '
          '("schöpferischer Akt"). Hold both.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Layered hedging',
      text: '"gewissermaßen", "womöglich", "werde/könne" all qualify the claims. '
          'Catch the caution.',
    ),
  ],
);

/// 7. Wortspiel & Mehrdeutigkeit.
final QuizContent questC22WortspielContent = sentenceQuestQuiz(
  id: 'quest_c2_2_wortspiel',
  title: 'C2.2 · Wortspiel & Mehrdeutigkeit',
  promptLabel: 'Lesart',
  subjectsLabel: 'Beispiele',
  subjectColumnLabel: 'Doppelsinn',
  categoryLabel: 'Wortspiel',
  intro: 'Wordplay exploits double meanings (Doppeldeutigkeit) and homonyms. '
      'Appreciating it is the last step to native-like command — headlines, '
      'jokes and ads rely on it.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'Homonyms',
      text: 'die Bank (bench / bank), das Schloss (castle / lock), der Flügel '
          '(wing / grand piano). One word, two worlds.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Idioms played literally',
      text: 'Headlines pun by reviving a dead metaphor: "Der Wurm ist drin" '
          'about a fishing shop.',
    ),
  ],
  items: [
    qsi('„die Bank" kann eine Sitzbank oder eine ____ sein. (financial '
        'institution)', 'Bank', 'a bench or a (financial) bank',
        'Bank (homonym)'),
    qsi('„das Schloss" kann ein Gebäude oder ein ____ sein. (lock)', 'Schloss',
        'a castle or a lock', 'Schloss (homonym)'),
    qsi('„der Flügel" kann ein Vogelteil oder ein ____ sein. (grand piano)',
        'Flügel', 'a wing or a grand piano', 'Flügel (homonym)'),
    qsi('„der Ball" kann ein Spielball oder ein ____ sein. (formal dance)',
        'Ball', 'a ball (toy) or a ball (dance)', 'Ball (homonym)'),
    qsi('„der Kiefer" ist ein Knochen, „die Kiefer" ein ____. (pine tree)',
        'Baum', 'jaw (m) vs pine (f) — gender disambiguates', 'Kiefer (Genus)'),
  ],
);

/// 8. Lesen: Ein Essay (anspruchsvoll, abstrakt).
final QuizContent questC22LesenEssayContent = readingQuestQuiz(
  id: 'quest_c2_2_lesen_essay',
  title: 'C2.2 · Lesen: Essay',
  category: 'Society',
  passageTitle: 'Über das Vergessen',
  passage:
      'Wir leben im Zeitalter der totalen Speicherung. Was einmal digital '
      'festgehalten wurde, scheint dem Vergessen für immer entzogen. Doch '
      'gerade darin liegt eine unterschätzte Gefahr. Das Vergessen ist keine '
      'bloße Schwäche des Gedächtnisses, sondern eine Leistung: Es erlaubt uns, '
      'Unwichtiges abzulegen, Wunden vernarben zu lassen und neu zu beginnen. '
      'Eine Gesellschaft, die nichts mehr vergisst, droht an der Last ihrer '
      'eigenen Vergangenheit zu ersticken. Vielleicht ist das Recht auf '
      'Vergessen am Ende ein Recht auf Zukunft.',
  passageTranslation:
      'We live in the age of total storage. What was once recorded digitally '
      'seems forever withdrawn from forgetting. Yet precisely therein lies an '
      'underestimated danger. Forgetting is not a mere weakness of memory but an '
      'achievement: it allows us to set aside the unimportant, to let wounds '
      'scar over and to begin anew. A society that no longer forgets anything '
      'threatens to suffocate under the burden of its own past. Perhaps the '
      'right to be forgotten is, in the end, a right to a future.',
  questions: const [
    ReadingQuestion(
      question: 'Wie bewertet der Autor das Vergessen?',
      questionTranslation: 'How does the author evaluate forgetting?',
      options: [
        'als Leistung, nicht als bloße Schwäche',
        'als reines Versagen',
        'als technisches Problem'
      ],
      optionsTranslation: [
        'as an achievement, not a mere weakness',
        'as pure failure',
        'as a technical problem'
      ],
      correctIndex: 0,
      explanation: '"Das Vergessen ist keine bloße Schwäche …, sondern eine '
          'Leistung …"',
    ),
    ReadingQuestion(
      question: 'Welche Gefahr sieht der Autor in totaler Speicherung?',
      questionTranslation: 'What danger does the author see in total storage?',
      options: [
        'an der Last der Vergangenheit zu ersticken',
        'dass Daten verloren gehen',
        'dass niemand mehr liest'
      ],
      optionsTranslation: [
        'suffocating under the burden of the past',
        'that data is lost',
        'that no one reads anymore'
      ],
      correctIndex: 0,
      explanation: '"… droht an der Last ihrer eigenen Vergangenheit zu '
          'ersticken."',
    ),
    ReadingQuestion(
      question: 'Wie deutet der Autor das „Recht auf Vergessen"?',
      questionTranslation: 'How does the author interpret the "right to be forgotten"?',
      options: [
        'als ein Recht auf Zukunft',
        'als juristische Spitzfindigkeit',
        'als technische Unmöglichkeit'
      ],
      optionsTranslation: [
        'as a right to a future',
        'as a legal nicety',
        'as a technical impossibility'
      ],
      correctIndex: 0,
      explanation: '"… das Recht auf Vergessen … ein Recht auf Zukunft."',
    ),
  ],
  intro: 'A philosophical essay — abstract, paradoxical, with an aphoristic '
      'thesis. The reading ceiling of the course. Read for argument and nuance.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Reversal of common sense',
      text: 'The essay defends forgetting against the cult of storage. The '
          'thesis inverts the expected view.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'The closing aphorism',
      text: '"ein Recht auf Vergessen … ein Recht auf Zukunft" condenses the '
          'whole argument into one line.',
    ),
  ],
);

/// 9. Fach- & Wissenschaftssprache.
final QuizContent questC22WissenschaftsspracheContent = sentenceQuestQuiz(
  id: 'quest_c2_2_wissenschaftssprache',
  title: 'C2.2 · Wissenschaftssprache',
  promptLabel: 'Wendung',
  subjectsLabel: 'Wendungen',
  subjectColumnLabel: 'Funktion',
  categoryLabel: 'Wissenschaftssprache',
  intro: 'Academic German has its own formulae for hedging, referencing and '
      'concluding. Mastering them lets you read and write like a specialist.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'Standard formulae',
      text: '"Es ist davon auszugehen, dass …", "im Hinblick auf …", "in Bezug '
          'auf …", "daraus ergibt sich, dass …".',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Impersonal & hedged',
      text: 'Academic style avoids "ich" and hedges claims: "vermutlich", '
          '"tendenziell", "es ist anzunehmen".',
    ),
  ],
  items: [
    qsi('Es ist davon ____, dass die Zahlen steigen. (to be assumed)',
        'auszugehen', 'It is to be assumed that the figures will rise.',
        'davon auszugehen'),
    qsi('Im ____ auf die Kosten ist der Plan kritisch. (with regard to)',
        'Hinblick', 'With regard to the costs, the plan is critical.',
        'im Hinblick auf'),
    qsi('Daraus ____ sich, dass die These haltbar ist. (it follows)', 'ergibt',
        'From this it follows that the thesis holds.', 'daraus ergibt sich'),
    qsi('Die Studie kommt zu dem ____, dass … (conclusion/result)', 'Ergebnis',
        'The study reaches the conclusion that …', 'zu dem Ergebnis kommen'),
    qsi('In ____ auf frühere Arbeiten zeigt sich … (with reference to)',
        'Bezug', 'With reference to earlier works it is shown …',
        'in Bezug auf'),
  ],
);

/// 10. Hören: Eine literarische Lesung.
final QuizContent questC22HoerenLesungContent = listeningQuestQuiz(
  id: 'quest_c2_2_hoeren_lesung',
  title: 'C2.2 · Hören: Literarische Lesung',
  category: 'Arts',
  passageTitle: 'Lesung: Der Koffer',
  passage:
      'Er hatte den Koffer nie ausgepackt. Drei Jahrzehnte stand er auf dem '
      'Schrank, ein stummer Zeuge eines Aufbruchs, der nie zur Ankunft geworden '
      'war. Manchmal, an schlaflosen Nächten, glaubte er, ihn atmen zu hören. '
      'Nicht der Inhalt hielt ihn gefangen, das wusste er längst – es war die '
      'Möglichkeit, eines Tages doch noch zu gehen, die er sich nicht nehmen '
      'lassen wollte.',
  passageTranslation:
      'He had never unpacked the suitcase. For three decades it stood on the '
      'wardrobe, a silent witness to a departure that had never become an '
      'arrival. Sometimes, on sleepless nights, he believed he could hear it '
      'breathe. It was not the contents that held him captive – he had long '
      'known that – it was the possibility of one day leaving after all, which '
      'he did not want to be taken from him.',
  questions: const [
    ReadingQuestion(
      question: 'Wie lange stand der Koffer schon dort?',
      questionTranslation: 'How long had the suitcase stood there?',
      options: ['drei Jahre', 'drei Jahrzehnte', 'drei Wochen'],
      optionsTranslation: ['three years', 'three decades', 'three weeks'],
      correctIndex: 1,
      explanation: '"Drei Jahrzehnte stand er auf dem Schrank …"',
    ),
    ReadingQuestion(
      question: 'Was hielt den Mann laut Text wirklich gefangen?',
      questionTranslation: 'What really held the man captive, according to the text?',
      options: [
        'der Inhalt des Koffers',
        'die Möglichkeit, eines Tages doch zu gehen',
        'die Angst vor der Reise'
      ],
      optionsTranslation: [
        'the contents of the suitcase',
        'the possibility of one day leaving after all',
        'the fear of the journey'
      ],
      correctIndex: 1,
      explanation: '"… es war die Möglichkeit, eines Tages doch noch zu gehen …"',
    ),
    ReadingQuestion(
      question: 'Wofür steht der Koffer im Text symbolisch?',
      questionTranslation: 'What does the suitcase symbolise in the text?',
      options: [
        'einen unerfüllten Aufbruch',
        'eine vergangene Reise',
        'materiellen Reichtum'
      ],
      optionsTranslation: [
        'an unfulfilled departure',
        'a past journey',
        'material wealth'
      ],
      correctIndex: 0,
      explanation: '"… ein stummer Zeuge eines Aufbruchs, der nie zur Ankunft '
          'geworden war."',
    ),
  ],
  intro: 'An author’s reading — you only hear it. Dense, metaphorical prose '
      '(the suitcase as a symbol). Listen for image and implication, not just '
      'facts. Replay as needed.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Object as symbol',
      text: 'The suitcase stands for an unlived possibility. The "facts" matter '
          'less than what they mean.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Aufbruch vs Ankunft',
      text: '"ein Aufbruch, der nie zur Ankunft wurde" — a departure that never '
          'became an arrival. The whole story in one phrase.',
    ),
  ],
);

/// 11. Sprechen: Eine Analyse vortragen.
final QuizContent questC22SprechenAnalyseContent = speakQuestQuiz(
  id: 'quest_c2_2_sprechen_analyse',
  title: 'C2.2 · Sprechen: Eine Analyse vortragen',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro: 'Present a literary or argumentative analysis aloud — precise, '
      'structured, evaluative. Listen and repeat these analytical phrases.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Interpret, don’t retell',
      text: '"Der Text lässt sich so deuten, dass …", "auffällig ist die '
          'Metaphorik …".',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Weigh interpretations',
      text: '"Man könnte einwenden, dass … . Dennoch spricht vieles dafür, dass '
          '…".',
    ),
  ],
  phrases: const [
    SpeakPhrase(
        phrase: 'Der Text lässt sich auf mehreren Ebenen deuten.',
        meaning: 'The text can be interpreted on several levels.'),
    SpeakPhrase(
        phrase: 'Auffällig ist die durchgängige Metaphorik des Wassers.',
        meaning: 'Striking is the consistent water imagery.'),
    SpeakPhrase(
        phrase: 'Damit verweist der Autor implizit auf …',
        meaning: 'With this the author implicitly refers to …'),
    SpeakPhrase(
        phrase: 'Man könnte einwenden, dass diese Deutung zu weit geht.',
        meaning: 'One could object that this interpretation goes too far.'),
    SpeakPhrase(
        phrase: 'Dennoch spricht vieles für diese Lesart.',
        meaning: 'Nevertheless much speaks for this reading.'),
    SpeakPhrase(
        phrase: 'Zusammenfassend lässt sich der Text als … begreifen.',
        meaning: 'In summary the text can be understood as …'),
  ],
);

/// 12. Hören: Capstone — Podiumsdiskussion (mehrere Sprecher).
final QuizContent questC22HoerenCapstoneContent = listeningQuestQuiz(
  id: 'quest_c2_2_hoeren_capstone',
  title: 'C2.2 · Hören: Podiumsdiskussion (Capstone)',
  category: 'Society',
  passageTitle: 'Podium: Künstliche Intelligenz',
  passage:
      'Moderatorin: Bedroht künstliche Intelligenz unsere Arbeitsplätze? Herr '
      'Weber, Sie sind skeptisch. Weber: Nicht die Technik an sich beunruhigt '
      'mich, sondern das Tempo, mit dem sie ganze Branchen umwälzt. Wer soll die '
      'Verlierer auffangen? Frau Söll: Da widerspreche ich. Jede technische '
      'Revolution hat am Ende mehr Arbeit geschaffen, als sie vernichtete – '
      'vorausgesetzt, wir investieren rechtzeitig in Bildung. Moderatorin: Genau '
      'an diesem „vorausgesetzt" entscheidet sich womöglich alles.',
  passageTranslation:
      'Moderator: Does artificial intelligence threaten our jobs? Mr Weber, you '
      'are sceptical. Weber: It is not the technology itself that worries me, but '
      'the speed with which it upends whole sectors. Who is to catch the losers? '
      'Ms Söll: I disagree there. Every technical revolution has ultimately '
      'created more work than it destroyed – provided we invest in education in '
      'time. Moderator: It is precisely on that "provided" that everything may '
      'hinge.',
  questions: const [
    ReadingQuestion(
      question: 'Was beunruhigt Herrn Weber konkret?',
      questionTranslation: 'What specifically worries Mr Weber?',
      options: [
        'das Tempo, mit dem KI ganze Branchen umwälzt',
        'die Technik an sich',
        'die Kosten der Technik'
      ],
      optionsTranslation: [
        'the speed at which AI upends whole sectors',
        'the technology itself',
        'the cost of the technology'
      ],
      correctIndex: 0,
      explanation: '"… sondern das Tempo, mit dem sie ganze Branchen umwälzt."',
    ),
    ReadingQuestion(
      question: 'Welche Bedingung nennt Frau Söll für ihren Optimismus?',
      questionTranslation: 'What condition does Ms Söll name for her optimism?',
      options: [
        'rechtzeitige Investitionen in Bildung',
        'ein Verbot von KI',
        'höhere Steuern'
      ],
      optionsTranslation: [
        'timely investment in education',
        'a ban on AI',
        'higher taxes'
      ],
      correctIndex: 0,
      explanation: '"… vorausgesetzt, wir investieren rechtzeitig in Bildung."',
    ),
    ReadingQuestion(
      question: 'Worauf weist die Moderatorin am Ende hin?',
      questionTranslation: 'What does the moderator point out at the end?',
      options: [
        'dass an dem Wort „vorausgesetzt" alles hängt',
        'dass beide unrecht haben',
        'dass die Diskussion beendet ist'
      ],
      optionsTranslation: [
        'that everything hinges on the word "provided"',
        'that both are wrong',
        'that the discussion is over'
      ],
      correctIndex: 0,
      explanation: '"Genau an diesem „vorausgesetzt" entscheidet sich womöglich '
          'alles."',
    ),
  ],
  intro: 'The capstone listening: a multi-speaker panel at natural pace, with '
      'overlap of viewpoints and a subtle moderator’s point. Track three voices '
      'and the conditional that frames the debate. Replay as needed.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Three voices',
      text: 'Moderatorin / Weber (sceptic) / Söll (optimist). Keep each '
          'position straight.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'The hinge word',
      text: 'The whole debate turns on "vorausgesetzt" (provided that) — the '
          'moderator’s closing point.',
    ),
  ],
);

/// 13. Lesen: Capstone — literarischer Text mit Interpretation.
final QuizContent questC22LesenCapstoneContent = readingQuestQuiz(
  id: 'quest_c2_2_lesen_capstone',
  title: 'C2.2 · Lesen: Literatur & Deutung (Capstone)',
  category: 'Arts',
  passageTitle: 'Capstone: Das offene Fenster',
  passage:
      'Jeden Abend öffnete sie das Fenster, auch im Winter, auch wenn niemand '
      'kam. „Damit die Luft sich nicht an die Stille gewöhnt", pflegte sie zu '
      'sagen, halb im Scherz. Erst nach ihrem Tod begriff ihre Tochter, dass es '
      'nie um die Luft gegangen war. Das offene Fenster war ein Versprechen an '
      'die Welt: dass dieses Haus, trotz allem, noch nicht aufgehört hatte zu '
      'erwarten. Manche Gesten, so erkannte sie, sind Sätze, die man nicht '
      'aussprechen kann, ohne sie zu zerstören.',
  passageTranslation:
      'Every evening she opened the window, even in winter, even when no one '
      'came. "So that the air doesn’t get used to the silence," she used to say, '
      'half in jest. Only after her death did her daughter understand that it '
      'had never been about the air. The open window was a promise to the world: '
      'that this house, despite everything, had not yet stopped expecting. Some '
      'gestures, she realised, are sentences one cannot speak aloud without '
      'destroying them.',
  questions: const [
    ReadingQuestion(
      question: 'Was tat die Frau jeden Abend?',
      questionTranslation: 'What did the woman do every evening?',
      options: [
        'das Fenster öffnen',
        'einen Brief schreiben',
        'das Licht ausschalten'
      ],
      optionsTranslation: [
        'open the window',
        'write a letter',
        'turn off the light'
      ],
      correctIndex: 0,
      explanation: '"Jeden Abend öffnete sie das Fenster …"',
    ),
    ReadingQuestion(
      question: 'Was begriff die Tochter erst nach dem Tod der Mutter?',
      questionTranslation: 'What did the daughter understand only after her mother’s death?',
      options: [
        'dass es nie um die Luft gegangen war',
        'dass das Fenster kaputt war',
        'dass die Mutter fror'
      ],
      optionsTranslation: [
        'that it had never been about the air',
        'that the window was broken',
        'that the mother was cold'
      ],
      correctIndex: 0,
      explanation: '"… dass es nie um die Luft gegangen war."',
    ),
    ReadingQuestion(
      question: 'Wie ist der Schlusssatz über „manche Gesten" zu verstehen?',
      questionTranslation: 'How is the final sentence about "some gestures" to be understood?',
      options: [
        'Manche Bedeutungen gehen verloren, wenn man sie ausspricht.',
        'Gesten sind immer eindeutig.',
        'Man sollte nie schweigen.'
      ],
      optionsTranslation: [
        'Some meanings are lost when spoken aloud.',
        'Gestures are always unambiguous.',
        'One should never be silent.'
      ],
      correctIndex: 0,
      explanation: '"… Sätze, die man nicht aussprechen kann, ohne sie zu '
          'zerstören."',
    ),
  ],
  intro: 'The capstone reading: a literary miniature whose meaning lies entirely '
      'in its symbol and its closing aphorism. Interpret the gesture, weigh the '
      'final sentence. This is the C2 ceiling of the course — and its finale.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'The window as promise',
      text: 'The open window symbolises hope and expectation, not ventilation. '
          'Read the symbol.',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'You’ve reached C2',
      text: 'If you can interpret this paragraph, you can read German literature. '
          'Herzlichen Glückwunsch!',
    ),
  ],
);

/// Every C2.2 quiz, in chain order — the capstone module; all five exercise
/// types, interleaved, at the C2 ceiling of the course.
final List<QuizContent> questC2_2Content = [
  questC22PhilosophieContent, //         Philosophie & Gesellsch.(knowledge)
  questC22FokusContent, //               Wortstellung & Fokus   (knowledge)
  questC22SprechenStreitContent, //      Sprechen: Streitgespr. (speaking)
  questC22AnspielungContent, //          Anspielungen           (knowledge)
  questC22ParaphraseContent, //          Paraphrase & Variation (knowledge)
  questC22HoerenFachvortragContent, //   Hören: Fachvortrag     (listening)
  questC22WortspielContent, //           Wortspiel              (knowledge)
  questC22LesenEssayContent, //          Lesen: Essay           (reading)
  questC22WissenschaftsspracheContent, // Wissenschaftssprache  (knowledge)
  questC22HoerenLesungContent, //        Hören: Lesung          (listening)
  questC22SprechenAnalyseContent, //     Sprechen: Analyse      (speaking)
  questC22HoerenCapstoneContent, //      Hören: Capstone        (listening)
  questC22LesenCapstoneContent, //       Lesen: Capstone        (reading)
];
