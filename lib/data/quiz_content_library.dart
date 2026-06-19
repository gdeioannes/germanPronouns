import '../models/quiz_content.dart';
import 'article_content.dart';
import 'noun_article_content.dart';
import 'preposition_content.dart';
import 'pronoun_article_content.dart';
import 'pronoun_content.dart';

/// Every quiz as serializable [QuizContent], compiled into the app. This is
/// the static, build-time content that seeds the local database on first run
/// (and the shape a teacher exports back to a JSON asset to publish edits).
final List<QuizContent> allQuizContent = [
  pronounQuizContent,
  articleQuizContent,
  nounArticleQuizContent,
  pronounArticleQuizContent,
  prepositionQuizContent,
];
