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
);
