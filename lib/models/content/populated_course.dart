import '../course.dart';
import 'quiz.dart';

/// A course as the client consumes it: the *populated* aggregate — the course
/// metadata + nav (the existing [Course]) with all of its quizzes embedded as
/// typed [Quiz]s, every entity carrying its own id. This is the shape of one
/// `assets/content/courses/<id>.json` bundle.
///
/// Normalized ↔ populated: a future database can store courses and quizzes as
/// separate collections linked by id and `populate` them into this same object;
/// the JSON bundle is that populate result, so the client code is identical
/// whether the source is a bundled asset or a remote DB.
class PopulatedCourse {
  PopulatedCourse({
    required this.course,
    required this.version,
    this.quizzes = const [],
  }) : _byId = {for (final q in quizzes) q.id: q};

  /// Course metadata + navigation (reuses the existing serializable [Course]).
  final Course course;

  /// Content version of this bundle (for cache invalidation).
  final String version;

  /// Every quiz belonging to the course, typed by kind.
  final List<Quiz> quizzes;

  final Map<String, Quiz> _byId;

  String get id => course.id;

  /// The quiz referenced by a nav item's `ref` (a `QuizContent.id`), or null.
  Quiz? quizById(String quizId) => _byId[quizId];

  Map<String, dynamic> toJson() => {
    ...course.toJson(),
    'version': version,
    'quizzes': [for (final q in quizzes) q.toJson()],
  };

  factory PopulatedCourse.fromJson(Map<String, dynamic> json) => PopulatedCourse(
    course: Course.fromJson(json),
    version: json['version'] as String? ?? '',
    quizzes: [
      for (final q in (json['quizzes'] as List?) ?? const [])
        Quiz.fromJson(Map<String, dynamic>.from(q as Map)),
    ],
  );
}
