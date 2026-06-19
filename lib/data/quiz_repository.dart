import '../models/app_page.dart';
import '../models/quiz_config.dart';
import '../models/quiz_section.dart';
import 'section_catalog.dart';

/// Source of the quizzes that make up each [QuizSection].
///
/// The app currently uses [InMemoryQuizRepository], which serves the const
/// configs compiled into the app via [quizSections]. This interface is the
/// seam for the planned database step: a `DbQuizRepository` can implement it
/// to load a section's quizzes from a database, without changing the drawer,
/// router, or quiz engine that consume the result.
///
/// The methods are async so a real (network/disk) implementation fits without
/// changing this contract — the in-memory implementation simply returns
/// already-built values.
abstract class QuizRepository {
  /// All quiz sections, in display order.
  Future<List<QuizSection>> sections();

  /// The quizzes belonging to [page]'s section, or an empty list if [page] is
  /// not a quiz section.
  Future<List<QuizConfig>> quizzesForSection(AppPage page);
}

/// [QuizRepository] backed by the in-memory [quizSections] catalog.
class InMemoryQuizRepository implements QuizRepository {
  const InMemoryQuizRepository();

  @override
  Future<List<QuizSection>> sections() async => quizSections;

  @override
  Future<List<QuizConfig>> quizzesForSection(AppPage page) async =>
      sectionForPage(page)?.quizzes ?? const [];
}

/// The repository the app reads from. Swap this for a DB-backed implementation
/// when the database step lands; nothing else needs to change.
const QuizRepository quizRepository = InMemoryQuizRepository();
