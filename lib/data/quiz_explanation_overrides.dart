import '../models/quiz_config.dart';
import 'article_data.dart';
import 'noun_article_data.dart';
import 'reference_sentence_bank.dart';

/// Original, code-driven explanation builders, kept for the quizzes whose
/// explanations are richer than the generic data-driven fallback. Keyed by
/// [QuizContent.id].
///
/// When the learner app runs a quiz from the database, the adapter uses the
/// override registered here (if any), so explanations stay identical to the
/// pre-database build — and they keep working for teacher-added sentences,
/// because these builders derive everything from the answer and the subject,
/// not from a fixed sentence bank.
///
/// Preposition and Pronouns-&-Articles are intentionally absent: the former's
/// generic explanation is equivalent (English meaning + usage come from the
/// stored subject data), and the latter ships its explanation pre-rendered in
/// each sentence's `explanationSections`.
final Map<String, ExplanationBuilder> explanationOverrides = {
  'article': buildArticleExplanation,
  'noun_article': buildNounArticleExplanation,
  'pronoun': buildReferenceExplanation,
};
