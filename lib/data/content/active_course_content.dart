import '../../models/content/quiz.dart';
import '../../models/course_session.dart';
import 'asset_course_provider.dart';

/// Resolves [quizId] from the **active course's** populated bundle (lazily
/// loaded from `assets/content/` on first open, then cached by the provider).
///
/// Returns null when the active course's bundle has no such quiz, so the legacy
/// loaders can fall back to the content database / compiled content — keeping
/// the app working while the runtime read path moves onto the JSON collections.
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
