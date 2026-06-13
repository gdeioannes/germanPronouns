import '../models/quiz_config.dart';
import '../widgets/app_drawer.dart';
import 'reference_sentence_bank.dart';

const listPronounsGermanNominative = [
  'ich',
  'du',
  'er',
  'sie',
  'es',
  'wir',
  'ihr',
  'sie',
  'Sie',
];

/// Same order as [listPronounsGermanNominative] but with 'sie (pl.)' at
/// index 7 so the plural third-person form is distinguishable in the UI.
const listPronounsGermanNominativeDisplay = [
  'ich',
  'du',
  'er',
  'sie',
  'es',
  'wir',
  'ihr',
  'sie (pl.)',
  'Sie',
];

const listPronounsGermanAkusative = [
  'mich',
  'dich',
  'ihn',
  'sie',
  'es',
  'uns',
  'euch',
  'sie',
  'Sie',
];

const listPronounsGermanDative = [
  'mir',
  'dir',
  'ihm',
  'ihr',
  'ihm',
  'uns',
  'euch',
  'ihnen',
  'Ihnen',
];

const listPronounsGermanGenitive = [
  'meiner',
  'deiner',
  'seiner',
  'ihrer',
  'seiner',
  'unser',
  'euer',
  'ihrer',
  'Ihrer',
];

const listPronounsGermanReflexive = [
  'mir',
  'dir',
  'sich',
  'sich',
  'sich',
  'uns',
  'euch',
  'sich',
  'sich',
];

const listPronounsGermanPossessiveMasculine = [
  'mein',
  'dein',
  'sein',
  'ihr',
  'sein',
  'unser',
  'euer',
  'ihr',
  'Ihr',
];

const listPronounsGermanPossessiveMasculineAccusative = [
  'meinen',
  'deinen',
  'seinen',
  'ihren',
  'seinen',
  'unseren',
  'euren',
  'ihren',
  'Ihren',
];

const listPronounsGermanPossessiveMasculineDative = [
  'meinem',
  'deinem',
  'seinem',
  'ihrem',
  'seinem',
  'unserem',
  'eurem',
  'ihrem',
  'Ihrem',
];

const listPronounsGermanPossessiveMasculineGenitive = [
  'meines',
  'deines',
  'seines',
  'ihres',
  'seines',
  'unseres',
  'eures',
  'ihres',
  'Ihres',
];

const listPronounsGermanPossessiveFeminine = [
  'meine',
  'deine',
  'seine',
  'ihre',
  'seine',
  'unsere',
  'eure',
  'ihre',
  'Ihre',
];

const listPronounsGermanPossessiveFeminineAccusative = [
  'meine',
  'deine',
  'seine',
  'ihre',
  'seine',
  'unsere',
  'eure',
  'ihre',
  'Ihre',
];

const listPronounsGermanPossessiveFeminineDative = [
  'meiner',
  'deiner',
  'seiner',
  'ihrer',
  'seiner',
  'unserer',
  'eurer',
  'ihrer',
  'Ihrer',
];

const listPronounsGermanPossessiveFeminineGenitive = [
  'meiner',
  'deiner',
  'seiner',
  'ihrer',
  'seiner',
  'unserer',
  'eurer',
  'ihrer',
  'Ihrer',
];

const listPronounsGermanPossessiveNeuter = [
  'mein',
  'dein',
  'sein',
  'ihr',
  'sein',
  'unser',
  'euer',
  'ihr',
  'Ihr',
];

const listPronounsGermanPossessiveNeuterAccusative = [
  'mein',
  'dein',
  'sein',
  'ihr',
  'sein',
  'unser',
  'euer',
  'ihr',
  'Ihr',
];

const listPronounsGermanPossessiveNeuterDative = [
  'meinem',
  'deinem',
  'seinem',
  'ihrem',
  'seinem',
  'unserem',
  'eurem',
  'ihrem',
  'Ihrem',
];

const listPronounsGermanPossessiveNeuterGenitive = [
  'meines',
  'deines',
  'seines',
  'ihres',
  'seines',
  'unseres',
  'eures',
  'ihres',
  'Ihres',
];

const listPronounsGermanPossessivePluralGenitive = [
  'meiner',
  'deiner',
  'seiner',
  'ihrer',
  'seiner',
  'unserer',
  'eurer',
  'ihrer',
  'Ihrer',
];

const listPronounsGermanPossessivePlural = [
  'meine',
  'deine',
  'seine',
  'ihre',
  'seine',
  'unsere',
  'eure',
  'ihre',
  'Ihre',
];

const List<QuizCategoryDefinition> quizCases = [
  QuizCategoryDefinition(
    label: 'Accusative',
    values: listPronounsGermanAkusative,
    group: 'Accusative',
  ),
  QuizCategoryDefinition(
    label: 'Dative',
    values: listPronounsGermanDative,
    group: 'Dative',
  ),
  QuizCategoryDefinition(
    label: 'Genitive',
    values: listPronounsGermanGenitive,
    group: 'Genitive',
  ),
  QuizCategoryDefinition(
    label: 'Reflexive',
    values: listPronounsGermanReflexive,
    group: 'Reflexive',
  ),
  QuizCategoryDefinition(
    label: 'Poss. Masc. Nom.',
    values: listPronounsGermanPossessiveMasculine,
    group: 'Possessive',
  ),
  QuizCategoryDefinition(
    label: 'Poss. Masc. Acc.',
    values: listPronounsGermanPossessiveMasculineAccusative,
    group: 'Possessive',
  ),
  QuizCategoryDefinition(
    label: 'Poss. Masc. Dat.',
    values: listPronounsGermanPossessiveMasculineDative,
    group: 'Possessive',
  ),
  QuizCategoryDefinition(
    label: 'Poss. Masc. Gen.',
    values: listPronounsGermanPossessiveMasculineGenitive,
    group: 'Possessive',
  ),
  QuizCategoryDefinition(
    label: 'Poss. Fem. Nom.',
    values: listPronounsGermanPossessiveFeminine,
    group: 'Possessive',
  ),
  QuizCategoryDefinition(
    label: 'Poss. Fem. Acc.',
    values: listPronounsGermanPossessiveFeminineAccusative,
    group: 'Possessive',
  ),
  QuizCategoryDefinition(
    label: 'Poss. Fem. Dat.',
    values: listPronounsGermanPossessiveFeminineDative,
    group: 'Possessive',
  ),
  QuizCategoryDefinition(
    label: 'Poss. Fem. Gen.',
    values: listPronounsGermanPossessiveFeminineGenitive,
    group: 'Possessive',
  ),
  QuizCategoryDefinition(
    label: 'Poss. Neut. Nom.',
    values: listPronounsGermanPossessiveNeuter,
    group: 'Possessive',
  ),
  QuizCategoryDefinition(
    label: 'Poss. Neut. Acc.',
    values: listPronounsGermanPossessiveNeuterAccusative,
    group: 'Possessive',
  ),
  QuizCategoryDefinition(
    label: 'Poss. Neut. Dat.',
    values: listPronounsGermanPossessiveNeuterDative,
    group: 'Possessive',
  ),
  QuizCategoryDefinition(
    label: 'Poss. Neut. Gen.',
    values: listPronounsGermanPossessiveNeuterGenitive,
    group: 'Possessive',
  ),
  QuizCategoryDefinition(
    label: 'Poss. Pl. Gen.',
    values: listPronounsGermanPossessivePluralGenitive,
    group: 'Possessive',
  ),
  QuizCategoryDefinition(
    label: 'Poss. Pl. Nom.',
    values: listPronounsGermanPossessivePlural,
    group: 'Possessive',
  ),
];

// Tune these values to control case-group frequency.
// Possessive stays one group, so all its variants share this group chance.
const Map<String, double> groupChanceWeights = {
  'Accusative': 1,
  'Dative': 1,
  'Genitive': 1,
  'Reflexive': 1,
  'Possessive': 1,
};

/// Maps case labels stored by older app versions to their current label.
const Map<String, String> pronounLegacyCaseLabelMigration = {
  'Poss. Masc.': 'Poss. Masc. Nom.',
  'Poss. Fem.': 'Poss. Fem. Nom.',
  'Poss. Neut.': 'Poss. Neut. Nom.',
  'Poss. Pl.': 'Poss. Pl. Nom.',
};

/// Help Memory reference tables, split by topic instead of one wide table:
/// personal/reflexive pronouns, then each possessive pronoun group
/// (masculine/feminine/neuter/plural) separately. Every table keeps the
/// nominative pronoun as its fixed first column for reference.
const List<HelpMemoryTable> pronounHelpMemoryTables = [
  HelpMemoryTable(
    title: 'Personal & Reflexive Pronouns',
    columns: [
      HelpMemoryColumn(categoryLabel: 'Accusative'),
      HelpMemoryColumn(categoryLabel: 'Dative'),
      HelpMemoryColumn(categoryLabel: 'Genitive'),
      HelpMemoryColumn(categoryLabel: 'Reflexive'),
    ],
  ),
  HelpMemoryTable(
    title: 'Possessive Pronouns — Masculine noun',
    columns: [
      HelpMemoryColumn(
        categoryLabel: 'Poss. Masc. Nom.',
        displayLabel: 'Nominative',
      ),
      HelpMemoryColumn(
        categoryLabel: 'Poss. Masc. Acc.',
        displayLabel: 'Accusative',
      ),
      HelpMemoryColumn(
        categoryLabel: 'Poss. Masc. Dat.',
        displayLabel: 'Dative',
      ),
      HelpMemoryColumn(
        categoryLabel: 'Poss. Masc. Gen.',
        displayLabel: 'Genitive',
      ),
    ],
  ),
  HelpMemoryTable(
    title: 'Possessive Pronouns — Feminine noun',
    columns: [
      HelpMemoryColumn(
        categoryLabel: 'Poss. Fem. Nom.',
        displayLabel: 'Nominative',
      ),
      HelpMemoryColumn(
        categoryLabel: 'Poss. Fem. Acc.',
        displayLabel: 'Accusative',
      ),
      HelpMemoryColumn(
        categoryLabel: 'Poss. Fem. Dat.',
        displayLabel: 'Dative',
      ),
      HelpMemoryColumn(
        categoryLabel: 'Poss. Fem. Gen.',
        displayLabel: 'Genitive',
      ),
    ],
  ),
  HelpMemoryTable(
    title: 'Possessive Pronouns — Neuter noun',
    columns: [
      HelpMemoryColumn(
        categoryLabel: 'Poss. Neut. Nom.',
        displayLabel: 'Nominative',
      ),
      HelpMemoryColumn(
        categoryLabel: 'Poss. Neut. Acc.',
        displayLabel: 'Accusative',
      ),
      HelpMemoryColumn(
        categoryLabel: 'Poss. Neut. Dat.',
        displayLabel: 'Dative',
      ),
      HelpMemoryColumn(
        categoryLabel: 'Poss. Neut. Gen.',
        displayLabel: 'Genitive',
      ),
    ],
  ),
  HelpMemoryTable(
    title: 'Possessive Pronouns — Plural noun',
    columns: [
      HelpMemoryColumn(
        categoryLabel: 'Poss. Pl. Nom.',
        displayLabel: 'Nominative',
      ),
      HelpMemoryColumn(
        categoryLabel: 'Poss. Pl. Gen.',
        displayLabel: 'Genitive',
      ),
    ],
  ),
];

/// Reference tables explaining where the possessive-pronoun endings above
/// come from: the der/die/das declension endings, and the (mostly
/// identical) endings used for possessive pronouns and other "ein-words".
const List<EndingPatternTable> pronounEndingPatternTables = [
  EndingPatternTable(
    title: 'Definite article endings (der/die/das)',
    cornerLabel: 'Case',
    columnLabels: ['Masculine', 'Feminine', 'Neuter', 'Plural'],
    rowLabels: ['Nominative', 'Accusative', 'Dative', 'Genitive'],
    rows: [
      ['der', 'die', 'das', 'die'],
      ['den', 'die', 'das', 'die'],
      ['dem', 'der', 'dem', 'den'],
      ['des', 'der', 'des', 'der'],
    ],
    notes: [
      'The final letters (-er, -ie, -as, -en, -em, -es) are the actual '
          'case/gender endings — the same endings reappear below on '
          'possessive pronouns.',
    ],
  ),
  EndingPatternTable(
    title: 'Possessive pronoun endings (mein-/dein-/sein-/...)',
    cornerLabel: 'Case',
    columnLabels: ['Masculine', 'Feminine', 'Neuter', 'Plural'],
    rowLabels: ['Nominative', 'Accusative', 'Dative', 'Genitive'],
    rows: [
      ['—', '-e', '—', '-e'],
      ['-en', '-e', '—', '-e'],
      ['-em', '-er', '-em', '-en'],
      ['-es', '-er', '-es', '-er'],
    ],
    notes: [
      'Add the ending to the possessive stem: mein + -em = meinem '
          '(masc./neut. dative).',
      'Same endings as the der/die/das table above, except masc. '
          'nominative, neut. nominative, and neut. accusative take no '
          'ending at all (mein, not "meiner"/"meines").',
    ],
  ),
];

const QuizConfig pronounQuizConfig = QuizConfig(
  title: 'German Pronoun Quiz',
  storageKeyPrefix: '',
  promptLabel: 'Pronoun',
  subjectsLabel: 'Pronouns',
  subjectColumnLabel: 'Nominative',
  subjects: listPronounsGermanNominative,
  subjectDisplays: listPronounsGermanNominativeDisplay,
  categories: quizCases,
  groupWeights: groupChanceWeights,
  pickSentence: pickReferenceSentence,
  buildExplanation: buildReferenceExplanation,
  legacyCategoryLabelMigration: pronounLegacyCaseLabelMigration,
  currentPage: AppPage.pronouns,
  helpMemoryTables: pronounHelpMemoryTables,
  endingPatternTables: pronounEndingPatternTables,
);
