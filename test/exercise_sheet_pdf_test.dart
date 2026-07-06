import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/data/exercise_sheet_builder.dart';
import 'package:german_pronouns_articles/models/app_session.dart';
import 'package:german_pronouns_articles/models/course_session.dart';
import 'package:german_pronouns_articles/theme/exercise_sheet_pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Layout smoke tests for the exercise worksheet PDF: every answer placement
/// must survive a full `doc.save()` (where MultiPage layout actually runs and
/// "won't fit" errors surface). Under flutter_test the brand fonts fall back
/// to Helvetica (Latin-1 only — keep fixtures free of CJK) and the final
/// share step has no platform plugin, so reaching [MissingPluginException]
/// means the document laid out and saved successfully.

Future<void> _export(
  List<ExerciseSection> sections,
  ExerciseAnswerPlacement placement,
) async {
  try {
    await exportExerciseSheetPdf(
      sections,
      scope: ExerciseScope.fullCourse,
      placement: placement,
    );
  } on MissingPluginException {
    // Printing.sharePdf is unimplemented in tests; layout already succeeded.
  }
}

List<ExerciseSection> _sections() => [
  // Enough cloze items to span several pages.
  ExerciseSection(
    quizTitle: 'Artikel im Akkusativ',
    kind: ExerciseSectionKind.cloze,
    items: [
      for (var i = 0; i < 60; i++)
        ExerciseItem(
          prompt: 'Ich sehe ____ Mann, der über die Straße läuft ($i).',
          answer: 'den',
          secondary: i.isEven ? 'someone is watching' : null,
          categoryLabel: 'Akkusativ',
        ),
    ],
  ),
  ExerciseSection(
    quizTitle: 'Lesen: Ein Tag in Köln',
    kind: ExerciseSectionKind.reading,
    passage:
        'Anna wohnt in Köln. Jeden Morgen fährt sie mit dem Rad zur Arbeit '
        'und trinkt unterwegs einen Kaffee. Am Abend trifft sie ihre Freunde '
        'am Rhein.',
    items: [
      for (var i = 0; i < 4; i++)
        ExerciseItem(
          prompt: 'Frage $i: Was macht Anna am Morgen?',
          answer: 'b',
          options: const ['Sie schläft', 'Sie fährt Rad', 'Sie liest'],
        ),
    ],
  ),
  ExerciseSection(
    quizTitle: 'Präpositionen im Text',
    kind: ExerciseSectionKind.inlineCloze,
    passage:
        'Wir fahren {{0}} Sommer {{1}} die Berge und bleiben {{2}} einer '
        'kleinen Hütte.',
    items: [
      ExerciseItem(prompt: 'Jahreszeit', answer: 'im', options: const ['im', 'am']),
      ExerciseItem(prompt: '', answer: 'in', options: const ['in', 'auf']),
      ExerciseItem(prompt: '', answer: 'in', options: const []),
    ],
  ),
  ExerciseSection(
    quizTitle: 'Schreiben',
    kind: ExerciseSectionKind.writing,
    items: [
      for (var i = 0; i < 3; i++)
        ExerciseItem(prompt: 'strasse $i - street', answer: 'Straße'),
    ],
  ),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppSession.instance.load();
    await CourseSession.instance.load();
  });

  for (final placement in ExerciseAnswerPlacement.values) {
    test('worksheet lays out with answers placed: ${placement.name}',
        () async {
      await _export(_sections(), placement);
    });
  }

  test('single tiny section lays out in every placement', () async {
    final sections = [
      ExerciseSection(
        quizTitle: 'Mini',
        kind: ExerciseSectionKind.cloze,
        items: [ExerciseItem(prompt: 'Der ____ ist groß.', answer: 'Baum')],
      ),
    ];
    for (final placement in ExerciseAnswerPlacement.values) {
      await _export(sections, placement);
    }
  });
}
