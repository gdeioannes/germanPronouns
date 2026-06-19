import '../models/quiz_content.dart';
import 'pronoun_data.dart';
import 'reference_sentence_bank.dart';

/// The Pronoun quiz expressed as serializable [QuizContent].
///
/// The sentence bank is normalized out of [referenceSentenceTemplates] (a
/// nested case → answer → sentences map) into flat [QuizSentenceData] rows —
/// exactly the shape a database `sentences` table would hold. Database-ready
/// twin of `pronounQuizConfig`; the live app still runs on the latter.
///
/// Answers are not stored per sentence: like the live quiz, the correct answer
/// for a (subject, case) is the category's value, so the adapter falls back to
/// it. Explanations are rebuilt generically by the adapter.
List<QuizSentenceData> _buildPronounSentences() {
  final sentences = <QuizSentenceData>[];
  for (final category in quizCases) {
    final caseTemplates =
        referenceSentenceTemplates[canonicalReferenceCaseLabel(category.label)];
    if (caseTemplates == null) continue;
    for (var i = 0; i < listPronounsGermanNominative.length; i++) {
      final nominative = listPronounsGermanNominative[i];
      final answer = category.values[i];
      final options = caseTemplates[answer] ?? caseTemplates[nominative];
      if (options == null) continue;
      for (final sentence in options) {
        sentences.add(
          QuizSentenceData(
            subjectKey: nominative,
            categoryLabel: category.label,
            sentence: sentence,
          ),
        );
      }
    }
  }
  return sentences;
}

final QuizContent pronounQuizContent = QuizContent(
  id: 'pronoun',
  title: 'German Pronoun Quiz',
  storageKeyPrefix: '',
  promptLabel: 'Pronoun',
  subjectsLabel: 'Pronouns',
  subjectColumnLabel: 'Nominative',
  subjects: [
    for (var i = 0; i < listPronounsGermanNominative.length; i++)
      QuizSubjectData(
        key: listPronounsGermanNominative[i],
        display: listPronounsGermanNominativeDisplay[i],
      ),
  ],
  categories: [
    for (final c in quizCases)
      QuizCategoryData(label: c.label, group: c.group, values: c.values),
  ],
  sentences: _buildPronounSentences(),
  legacyCategoryLabelMigration: pronounLegacyCaseLabelMigration,
  helpMemoryTables: pronounHelpMemoryTables,
  endingPatternTables: pronounEndingPatternTables,
);
