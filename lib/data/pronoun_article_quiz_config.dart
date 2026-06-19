import 'dart:math';

import '../models/quiz_config.dart';
import '../models/app_page.dart';
import 'pronoun_article_sentences.dart';

const List<String> accusativePronounsList = [
  'mich', 'dich', 'ihn', 'sie', 'es', 'uns', 'euch', 'sie', 'Sie',
];

const List<String> dativePronounsList = [
  'mir', 'dir', 'ihm', 'ihr', 'ihm', 'uns', 'euch', 'ihnen', 'Ihnen',
];

const List<QuizCategoryDefinition> pronounArticleQuizCases = [
  QuizCategoryDefinition(
    label: 'Accusative',
    values: accusativePronounsList,
    group: 'Case',
  ),
  QuizCategoryDefinition(
    label: 'Dative',
    values: dativePronounsList,
    group: 'Case',
  ),
];

const Map<String, double> pronounArticleGroupWeights = {'Case': 1};

/// Picks a random sentence for a given pronoun and case.
String pickPronounArticleSentence({
  required String caseLabel,
  required String nominative,
  required String answer,
  required Random random,
}) {
  final caseValue = caseLabel.toLowerCase();
  final candidates = pronounArticleSentences
      .where((s) => s.case_ == caseValue && s.nominative == nominative)
      .toList();
  if (candidates.isEmpty) return '';
  return candidates[random.nextInt(candidates.length)].answerSentence;
}

/// Returns the correct answer(s) for a fill-in sentence.
Set<String> acceptablePronounArticleAnswers(String sentence) {
  // Find the sentence and return its expected answer
  final sentenceData = pronounArticleSentences
      .firstWhere((s) => s.answerSentence == sentence, orElse: () => const PronounArticlePair(
        case_: '',
        nominative: '',
        question: '',
        answerSentence: '',
        blanks: [],
        answer: '',
        pattern: '',
      ));

  if (sentenceData.answer.isEmpty) return {};

  // Accept the answer as-is, case-insensitive
  return {sentenceData.answer.toLowerCase()};
}

/// Builds explanation for a Pronouns & Articles quiz answer.
String buildPronounArticleExplanation({
  required String caseLabel,
  required String nominative,
  required String answer,
  required String sentence,
}) {
  final sentenceData = pronounArticleSentences
      .firstWhere((s) => s.answerSentence == sentence, orElse: () => const PronounArticlePair(
        case_: '',
        nominative: '',
        question: '',
        answerSentence: '',
        blanks: [],
        answer: '',
        pattern: '',
      ));

  if (sentenceData.answer.isEmpty) return 'Unable to find explanation.';

  final sections = [
    'Question: ${sentenceData.question}',
    'Answer: ${sentenceData.answer}',
    'Case: $caseLabel',
    'Nominative: $nominative',
    'Pattern: ${sentenceData.pattern == 'together' ? 'Pronouns together (consecutive)' : 'Pronouns separated (verb between)'}',
  ];

  return sections.join('\n\n');
}

// ── Help Memory reference content ────────────────────────────────────────

/// Core reference: nominative pronouns (first column) mapped to their
/// accusative and dative forms, driven by the existing quiz [categories].
const List<HelpMemoryTable> pronounArticleHelpMemoryTables = [
  HelpMemoryTable(
    title: 'Personal Pronouns by Case',
    columns: [
      HelpMemoryColumn(categoryLabel: 'Accusative', displayLabel: 'Accusative'),
      HelpMemoryColumn(categoryLabel: 'Dative', displayLabel: 'Dative'),
    ],
  ),
];

/// Case-detection, case-bound verbs, and word-order study tables.
const List<EndingPatternTable> pronounArticleEndingPatternTables = [
  EndingPatternTable(
    title: 'How to Find the Case',
    cornerLabel: 'Case',
    columnLabels: ['Question word', 'Role', 'Example'],
    rowLabels: ['Nominative', 'Accusative', 'Dative'],
    rows: [
      [
        'Wer? / Was? (Who?)',
        'Subject — does the action',
        'Er sieht mich. → Wer sieht? → er',
      ],
      [
        'Wen? / Was? (Whom?)',
        'Direct object — directly affected',
        'Er sieht mich. → Wen sieht er? → mich',
      ],
      [
        'Wem? (To whom?)',
        'Indirect object — the receiver',
        'Er hilft mir. → Wem hilft er? → mir',
      ],
    ],
    notes: [
      'Ask "Wen?" to find the accusative object (mich, dich, ihn, sie, es, uns, euch, sie, Sie).',
      'Ask "Wem?" to find the dative object (mir, dir, ihm, ihr, uns, euch, ihnen, Ihnen).',
      'The nominative is always the one performing the verb.',
    ],
  ),
  EndingPatternTable(
    title: 'Verbs That Always Take the Dative',
    cornerLabel: 'Verb',
    columnLabels: ['English', 'Example'],
    rowLabels: [
      'helfen',
      'danken',
      'glauben',
      'folgen',
      'antworten',
      'gehören',
      'vertrauen',
      'gratulieren',
      'gefallen',
      'passen',
    ],
    rows: [
      ['to help', 'Ich helfe dir.'],
      ['to thank', 'Wir danken Ihnen.'],
      ['to believe', 'Sie glauben mir.'],
      ['to follow', 'Wir folgen ihm.'],
      ['to answer', 'Er antwortet mir.'],
      ['to belong to', 'Das Buch gehört ihr.'],
      ['to trust', 'Ich vertraue ihm.'],
      ['to congratulate', 'Ich gratuliere dir.'],
      ['to please / like', 'Das Lied gefällt uns.'],
      ['to suit / fit', 'Der Termin passt mir.'],
    ],
    notes: [
      'These feel like direct objects in English, but in German the object is dative.',
      'Always use a dative pronoun after them: mir, dir, ihm, ihr, uns, euch, ihnen, Ihnen.',
    ],
  ),
  EndingPatternTable(
    title: 'Common Verbs With the Accusative',
    cornerLabel: 'Verb',
    columnLabels: ['English', 'Example'],
    rowLabels: [
      'sehen',
      'kennen',
      'mögen',
      'lieben',
      'suchen',
      'besuchen',
      'treffen',
      'einladen',
      'fragen',
      'anrufen',
    ],
    rows: [
      ['to see', 'Ich sehe ihn.'],
      ['to know', 'Wir kennen sie.'],
      ['to like', 'Ich mag dich.'],
      ['to love', 'Sie liebt ihn.'],
      ['to look for', 'Er sucht mich.'],
      ['to visit', 'Wir besuchen euch.'],
      ['to meet', 'Ich treffe ihn.'],
      ['to invite', 'Sie lädt uns ein.'],
      ['to ask', 'Er fragt mich.'],
      ['to call (phone)', 'Ich rufe dich an.'],
    ],
    notes: [
      'Most German verbs take an accusative (direct) object.',
      'Use mich, dich, ihn, sie, es, uns, euch, sie, Sie after them.',
    ],
  ),
  EndingPatternTable(
    title: 'Two-Object Verbs (Dative + Accusative)',
    cornerLabel: 'Verb',
    columnLabels: ['English', 'Example (dat. person + acc. thing)'],
    rowLabels: ['geben', 'schreiben', 'zeigen', 'schicken', 'erklären', 'bringen'],
    rows: [
      ['to give', 'Ich gebe dir das Buch.'],
      ['to write', 'Sie schreibt mir einen Brief.'],
      ['to show', 'Er zeigt uns die Stadt.'],
      ['to send', 'Wir schicken Ihnen das Paket.'],
      ['to explain', 'Ich erkläre euch die Regel.'],
      ['to bring', 'Er bringt mir den Kaffee.'],
    ],
    notes: [
      'The receiver (person) is dative; the thing given is accusative.',
      'Default order with nouns: dative before accusative — "Ich gebe dem Kind den Ball."',
    ],
  ),
  EndingPatternTable(
    title: 'Word Order of Pronouns',
    cornerLabel: 'Rule',
    columnLabels: ['How it works', 'Example'],
    rowLabels: ['Subject first', 'Two pronouns', 'Emphasis'],
    rows: [
      ['Nominative subject comes before the object pronoun', 'Er sieht mich.'],
      ['Accusative pronoun comes before the dative pronoun', 'Ich gebe es ihm.'],
      ['Front the object pronoun for emphasis', 'Mich hat er gesehen.'],
    ],
    notes: [
      'With two pronouns the accusative comes first: "Ich gebe es ihm." (not "ihm es").',
      'A pronoun always comes before a noun: "Ich gebe ihm das Buch."',
    ],
  ),
];

/// Nominative pronouns
const List<String> pronounArticleSubjects = [
  'ich', 'du', 'er', 'sie', 'es', 'wir', 'ihr', 'sie', 'Sie',
];

const List<String> pronounArticleSubjectDisplays = [
  'ich', 'du', 'er', 'sie', 'es', 'wir', 'ihr', 'sie (pl.)', 'Sie',
];

const List<List<String>> pronounArticleSubjectCategories = [
  ['accusative', 'dative'], ['accusative', 'dative'], ['accusative', 'dative'],
  ['accusative', 'dative'], ['accusative', 'dative'], ['accusative', 'dative'],
  ['accusative', 'dative'], ['accusative', 'dative'], ['accusative', 'dative'],
];

final QuizConfig pronounArticleQuizConfig = QuizConfig(
  title: 'Pronouns & Articles Quiz',
  storageKeyPrefix: 'pronoun_article_',
  promptLabel: 'Pronoun',
  subjectsLabel: 'Pronouns',
  subjectColumnLabel: 'Pronoun',
  subjects: pronounArticleSubjects,
  subjectDisplays: pronounArticleSubjectDisplays,
  categories: pronounArticleQuizCases,
  groupWeights: pronounArticleGroupWeights,
  pickSentence: pickPronounArticleSentence,
  buildExplanation: buildPronounArticleExplanation,
  acceptableAnswersForSentence: acceptablePronounArticleAnswers,
  sentenceHint: null,
  helpMemoryTables: pronounArticleHelpMemoryTables,
  endingPatternTables: pronounArticleEndingPatternTables,
  helpMemorySubtitle:
      'Pronoun forms by case, how to detect the case (Wen?/Wem?), '
      'verbs bound to the dative and accusative, and pronoun word order — '
      'exportable as a PDF study sheet.',
  currentPage: AppPage.pronounsAndArticles,
);
