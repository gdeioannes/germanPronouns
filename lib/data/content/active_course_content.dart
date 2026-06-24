import '../../models/content/quiz.dart';
import '../../models/course_session.dart';
import '../../models/quiz_content.dart';
import '../db/content_repository.dart';
import '../noun_article_content.dart';
import 'asset_course_provider.dart';

/// Resolves [quizId] from the **active course's** populated bundle (lazily
/// loaded from `assets/content/` on first open, then cached by the provider).
///
/// Returns null when the active course's bundle has no such quiz, so callers
/// can fall back to the content database / compiled content — keeping the app
/// working while the runtime read path moves onto the JSON collections.
Future<Quiz?> activeCourseQuiz(String quizId) async {
  final session = CourseSession.instance;
  final courseId = session.activeCourseId ?? session.activeCourse.id;
  try {
    final populated = await courseContentProvider.populated(courseId);
    return populated.quizById(quizId);
  } catch (_) {
    return null;
  }
}

/// Resolves [quizId]'s content for rendering: the active course's JSON bundle
/// (lazy + cached) first, then the content database. Returns null if neither
/// has it, so a caller can fall back to its own compiled content/config. Shared
/// by every quiz loader so the bundle→DB read order lives in one place.
Future<QuizContent?> resolveQuizContent(String quizId) async {
  final fromBundle = (await activeCourseQuiz(quizId))?.toLegacy();
  if (fromBundle != null) return fromBundle;
  try {
    return await (await contentRepository()).quizContent(quizId);
  } catch (_) {
    return null;
  }
}

/// The full "All Nouns" content for the active course, built from its shared
/// noun collection (`nouns/<lang>.json`, keyed by the learned language) so
/// multiple courses for the same language share one list — `noun_article` is
/// deliberately not baked into any course bundle. Falls back to
/// [resolveQuizContent] (DB → compiled) when the language has no shared
/// collection. Returns null only if no source has it.
Future<QuizContent?> resolveNounArticleContent() async {
  final lang =
      CourseSession.instance.activeCourse.learnLocale.split('-').first;
  final collection = await courseContentProvider.nounCollection(lang);
  if (!collection.isEmpty) {
    return buildNounArticleContent(
      collection.nouns,
      collection.categoryDisplayNames,
    );
  }
  return resolveQuizContent('noun_article');
}
