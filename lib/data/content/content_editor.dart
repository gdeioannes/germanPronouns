import '../../models/content/populated_course.dart';
import '../../models/content/quiz.dart';
import 'course_content_provider.dart';

/// Local, validated editor for the JSON content collections — the **write** side
/// of the same seam the learner reads. Edits are persisted to a
/// [CourseBundleStore] (the device database) and override the shipped asset
/// bundles, so a teacher's changes reach learners immediately. A future remote
/// editor implements the same operations against the database — the back-office
/// UI doesn't change.
class ContentEditor {
  ContentEditor({required this.provider, required this.store});

  final CachingCourseProvider provider;
  final CourseBundleStore store;

  /// The current (possibly edited) bundle for [courseId].
  Future<PopulatedCourse> course(String courseId) =>
      provider.populated(courseId);

  /// Inserts or updates [quiz] (by id) in [courseId]'s bundle, then persists.
  Future<void> saveQuiz(String courseId, Quiz quiz) async {
    final current = await provider.populated(courseId);
    _validate(current, quiz);
    final quizzes = [...current.quizzes];
    final index = quizzes.indexWhere((q) => q.id == quiz.id);
    if (index >= 0) {
      quizzes[index] = quiz;
    } else {
      quizzes.add(quiz);
    }
    await _persist(current, quizzes);
  }

  /// Removes the quiz with [quizId] from [courseId]'s bundle, then persists.
  Future<void> deleteQuiz(String courseId, String quizId) async {
    final current = await provider.populated(courseId);
    final quizzes = [
      for (final q in current.quizzes)
        if (q.id != quizId) q,
    ];
    await _persist(current, quizzes);
  }

  /// Reverts [courseId] to the shipped bundle (drops all local edits).
  Future<void> resetCourse(String courseId) async {
    await store.remove(courseId);
    provider.invalidate(courseId);
  }

  Future<void> _persist(PopulatedCourse current, List<Quiz> quizzes) async {
    final updated = PopulatedCourse(
      course: current.course,
      version: current.version,
      quizzes: quizzes,
    );
    await store.write(current.id, updated.toJson());
    provider.invalidate(current.id);
  }

  /// Guards the invariants the rest of the app relies on: a non-empty id, and a
  /// `storageKeyPrefix` that is immutable once set (it keys saved learner
  /// progress) and unique within the course.
  void _validate(PopulatedCourse course, Quiz quiz) {
    if (quiz.id.isEmpty) {
      throw ArgumentError('Quiz id must not be empty.');
    }
    final existing = course.quizById(quiz.id);
    if (existing != null &&
        existing.storageKeyPrefix != quiz.storageKeyPrefix) {
      throw ArgumentError(
        'storageKeyPrefix is immutable (${quiz.id}) — it keys saved progress.',
      );
    }
    for (final q in course.quizzes) {
      if (q.id != quiz.id && q.storageKeyPrefix == quiz.storageKeyPrefix) {
        throw ArgumentError(
          'storageKeyPrefix "${quiz.storageKeyPrefix}" already used by ${q.id}.',
        );
      }
    }
  }
}
