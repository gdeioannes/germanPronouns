import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/data/quiz_content_library.dart';
import 'package:german_pronouns_articles/models/quiz_content.dart';

/// A completion run is 10 consecutive correct answers (2 laps × 5, see
/// `NounSettings.defaultProgressionUnlockLaps`), so every quiz the learner
/// *answers* repeatedly must offer at least 10 distinct questions — otherwise a
/// single run is forced to repeat itself.
///
/// Applies to the answer-based kinds: fill-in-the-blank (the pool is the
/// subject × category cells the engine can draw) and dictation (the item
/// list). Play-through kinds (speak-repeat, draw) and single-pass passages
/// (reading, listening) are exempt.
const int kMinQuestionPool = 10;

/// Distinct (subject, category) cells a fill-in quiz can draw: cells whose
/// category value exists and is non-empty — the same validity rule the quiz
/// engine applies when picking a question.
int _fillBlankPool(QuizContent q) {
  var cells = 0;
  for (final category in q.categories) {
    for (var i = 0; i < q.subjects.length; i++) {
      if (i < category.values.length && category.values[i].isNotEmpty) {
        cells++;
      }
    }
  }
  return cells;
}

void main() {
  test('every fill-in quiz offers at least $kMinQuestionPool questions', () {
    for (final q in allQuizContent) {
      if (q.kind != QuizKind.fillBlank) continue;
      expect(
        _fillBlankPool(q),
        greaterThanOrEqualTo(kMinQuestionPool),
        reason:
            '${q.id} has fewer than $kMinQuestionPool distinct questions — a '
            '10-answer completion run would repeat itself. Add more items.',
      );
    }
  });

  test('every dictation quiz offers at least $kMinQuestionPool sentences', () {
    for (final q in allQuizContent) {
      if (q.kind != QuizKind.dictation) continue;
      expect(
        q.subjects.length,
        greaterThanOrEqualTo(kMinQuestionPool),
        reason:
            '${q.id} has fewer than $kMinQuestionPool sentences — a 10-answer '
            'completion run would repeat itself. Add more items.',
      );
    }
  });
}
