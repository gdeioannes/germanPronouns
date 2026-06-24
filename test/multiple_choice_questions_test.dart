import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/models/quiz_content.dart';
import 'package:german_pronouns_articles/widgets/multiple_choice_questions.dart';

/// Render smoke test for the shared [MultipleChoiceQuestions] widget that the
/// reading and listening pages now both use — guards the Stage 5b extraction.
void main() {
  const questions = [
    ReadingQuestion(question: 'Q1?', options: ['A', 'B', 'C'], correctIndex: 1),
    ReadingQuestion(question: 'Q2?', options: ['X', 'Y'], correctIndex: 0),
  ];

  Widget harness({
    required List<int?> selected,
    required bool submitted,
    void Function(int, int)? onSelect,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: MultipleChoiceQuestions(
            questions: questions,
            selected: selected,
            optionOrder: [
              for (final q in questions)
                [for (var i = 0; i < q.options.length; i++) i],
            ],
            submitted: submitted,
            bestCorrect: null,
            nextExercise: null,
            onSelect: onSelect ?? (_, _) {},
            onSubmit: () {},
            onRetry: () {},
          ),
        ),
      ),
    );
  }

  testWidgets('renders each question and its options', (tester) async {
    await tester.pumpWidget(harness(selected: [null, null], submitted: false));
    expect(find.text('1. Q1?'), findsOneWidget);
    expect(find.text('2. Q2?'), findsOneWidget);
    expect(find.text('A'), findsOneWidget);
    expect(find.text('Y'), findsOneWidget);
  });

  testWidgets('tapping an option reports its question + option index',
      (tester) async {
    int? tappedQ;
    int? tappedO;
    await tester.pumpWidget(harness(
      selected: [null, null],
      submitted: false,
      onSelect: (q, o) {
        tappedQ = q;
        tappedO = o;
      },
    ));
    await tester.tap(find.text('B'));
    await tester.pump();
    expect(tappedQ, 0);
    expect(tappedO, 1);
  });

  testWidgets('shows the score once submitted', (tester) async {
    // Both answered correctly (Q1 -> index 1, Q2 -> index 0).
    await tester.pumpWidget(harness(selected: [1, 0], submitted: true));
    expect(find.textContaining('2 / 2'), findsOneWidget);
  });
}
