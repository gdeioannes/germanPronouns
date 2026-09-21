import '../models/quiz_content.dart';
import 'noun_article_content.dart';
import 'quest_data.dart';

/// Every quiz as serializable [QuizContent], compiled into the app. This is
/// the static, build-time content that seeds the local database on first run
/// (and the shape a teacher exports back to a JSON asset to publish edits).
final List<QuizContent> allQuizContent = [
  nounArticleQuizContent,
  // Quest (CEFR A1–C2) quizzes — one ordered, streak-unlocked chain.
  ...questQuizContent,
];
