import '../../models/quiz_content.dart';
import '../content/active_course_content.dart';
import '../quest_data.dart';
import 'placement_modules.dart';

/// How many questions each module contributes to the placement test.
const int kPlacementQuestionsPerModule = 4;

/// The share of a module's questions a learner must get right to be considered
/// past it. Below this, the test stops and places them in that module.
const double kPlacementPassRatio = 0.6;

/// One question in the placement test: a fill-in-the-blank sentence lifted from
/// a real quiz in the module it is testing.
class PlacementQuestion {
  const PlacementQuestion({
    required this.moduleIndex,
    required this.sentence,
    required this.acceptedAnswers,
    this.prompt,
    this.english,
  });

  /// Index into the course's [placementModules] — what a wrong answer counts
  /// against.
  final int moduleIndex;

  /// The sentence, with its `____` blank left in.
  final String sentence;

  /// Every spelling accepted, compared case- and whitespace-insensitively.
  final List<String> acceptedAnswers;

  final String? prompt;
  final String? english;

  /// Whether [answer] is one of the accepted fills.
  bool accepts(String answer) {
    final given = _normalize(answer);
    if (given.isEmpty) return false;
    return acceptedAnswers.any((a) => _normalize(a) == given);
  }

  static String _normalize(String s) =>
      s.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
}

/// Builds the placement test for [modules]: [kPlacementQuestionsPerModule]
/// questions per module, ordered from the first module to the last.
///
/// Questions are sampled from the modules' own quizzes rather than authored
/// separately, so a course gets a placement test the moment it gets gated
/// content, and the test can't drift out of sync with what it is placing into.
/// The sampling is deterministic — evenly spaced across the module's pooled
/// questions — so a learner who retakes the test sees the same paper, and the
/// tests are reproducible in a failure report.
///
/// Only fill-in questions with explicit accepted answers are eligible: a
/// placement test has to mark itself, and article/noun quizzes compute their
/// answer from the selected subject at runtime rather than storing it.
Future<List<PlacementQuestion>> buildPlacementTest(
  List<PlacementModule> modules,
) async {
  final questions = <PlacementQuestion>[];
  for (var i = 0; i < modules.length; i++) {
    final pool = <PlacementQuestion>[];
    for (final ref in modules[i].quizRefs) {
      final content = await _content(ref);
      if (content == null || content.kind != QuizKind.fillBlank) continue;
      for (final s in content.sentences) {
        if (s.acceptedAnswers.isEmpty) continue;
        if (!s.sentence.contains('____')) continue;
        pool.add(
          PlacementQuestion(
            moduleIndex: i,
            sentence: s.sentence,
            acceptedAnswers: s.acceptedAnswers,
            prompt: s.prompt,
            english: s.english,
          ),
        );
      }
    }
    questions.addAll(_spread(pool, kPlacementQuestionsPerModule));
  }
  return questions;
}

/// Resolves a module quiz ref to its content: a plain quiz id through the
/// course bundle, or a Quest chain key through the compiled chain.
Future<QuizContent?> _content(String ref) async {
  final resolved = await resolveQuizContent(ref);
  if (resolved != null) return resolved;
  return questEntryByKey(ref)?.content;
}

/// Picks at most [count] items evenly spaced across [pool], so the sample
/// spans the module's quizzes instead of clustering in its first one.
List<PlacementQuestion> _spread(List<PlacementQuestion> pool, int count) {
  if (pool.length <= count) return pool;
  final step = pool.length / count;
  return [for (var i = 0; i < count; i++) pool[(i * step).floor()]];
}

/// The outcome of a placement run.
class PlacementResult {
  const PlacementResult({
    required this.moduleIndex,
    required this.correctByModule,
    required this.askedByModule,
    required this.completedWholeTest,
  });

  /// Where the learner is placed — the index of the first module they failed,
  /// or the last module when they passed everything.
  final int moduleIndex;

  /// Right answers and questions asked, per module index. Modules the test
  /// never reached are absent.
  final Map<int, int> correctByModule;
  final Map<int, int> askedByModule;

  /// False when the test stopped early because a module was failed.
  final bool completedWholeTest;
}

/// Scores [answers] (parallel to [questions]) against the module thresholds.
///
/// Walks the modules in order and stops at the first one the learner scored
/// below [kPlacementPassRatio] on — that module is where they are placed, which
/// is the whole point of ordering the paper from the easiest module up. A
/// learner who clears every module is placed in the last one; they have
/// nothing left to unlock past it.
PlacementResult scorePlacement(
  List<PlacementQuestion> questions,
  List<String> answers, {
  required int moduleCount,
}) {
  final correct = <int, int>{};
  final asked = <int, int>{};
  for (var i = 0; i < questions.length && i < answers.length; i++) {
    final q = questions[i];
    asked[q.moduleIndex] = (asked[q.moduleIndex] ?? 0) + 1;
    // Seeded so a module that was asked always has a correct count, even if it
    // is zero — "asked 4, correct absent" reads as missing data otherwise.
    correct[q.moduleIndex] = (correct[q.moduleIndex] ?? 0) +
        (q.accepts(answers[i]) ? 1 : 0);
  }

  for (var m = 0; m < moduleCount; m++) {
    final total = asked[m] ?? 0;
    if (total == 0) continue; // no eligible questions — can't fail it
    final ratio = (correct[m] ?? 0) / total;
    if (ratio < kPlacementPassRatio) {
      return PlacementResult(
        moduleIndex: m,
        correctByModule: correct,
        askedByModule: asked,
        completedWholeTest: false,
      );
    }
  }
  return PlacementResult(
    moduleIndex: moduleCount - 1,
    correctByModule: correct,
    askedByModule: asked,
    completedWholeTest: true,
  );
}

/// Whether the questions answered so far already settle the placement — true
/// once a module is finished and was failed. Lets the test stop asking about
/// levels the learner has already shown they aren't at.
///
/// [upTo] is the number of questions answered.
bool placementDecided(List<PlacementQuestion> questions, List<String> answers) {
  final answered = answers.length;
  if (answered == 0 || answered >= questions.length) return false;
  // Only decide on a module boundary: a module is judged as a whole.
  if (questions[answered].moduleIndex == questions[answered - 1].moduleIndex) {
    return false;
  }
  final module = questions[answered - 1].moduleIndex;
  var total = 0;
  var right = 0;
  for (var i = 0; i < answered; i++) {
    if (questions[i].moduleIndex != module) continue;
    total++;
    if (questions[i].accepts(answers[i])) right++;
  }
  return total > 0 && right / total < kPlacementPassRatio;
}
