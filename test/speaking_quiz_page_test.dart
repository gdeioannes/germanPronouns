import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/models/app_page.dart';
import 'package:german_pronouns_articles/models/app_session.dart';
import 'package:german_pronouns_articles/models/coin_wallet.dart';
import 'package:german_pronouns_articles/models/course_session.dart';
import 'package:german_pronouns_articles/models/noun_settings.dart';
import 'package:german_pronouns_articles/models/quiz_content.dart';
import 'package:german_pronouns_articles/models/speaking_exercise.dart';
import 'package:german_pronouns_articles/pages/speaking_quiz_page.dart';
import 'package:german_pronouns_articles/services/speaking_prompt.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [NounSettings] is a singleton that loads once per test *file*, so a
/// completion saved by one test would otherwise leak into the next. Each test
/// gets its own quiz id instead.
QuizContent _content(String id) => QuizContent(
  id: id,
  title: 'Speaking Smoke',
  kind: QuizKind.speaking,
  level: 'A2',
  storageKeyPrefix: '${id}_',
  promptLabel: 'Exercise',
  subjectsLabel: 'Exercise',
  subjectColumnLabel: 'Exercise',
  subjects: const [],
  categories: const [],
  sentences: const [],
  speaking: const SpeakingExercise(
    topic: 'My weekend and what I did.',
    practisePoints: ['Perfekt with haben/sein'],
    scoringCriteria: ['the right helper'],
    targetVocabulary: ['gestern'],
  ),
  helpMemoryIntro: 'Run it in your own AI assistant.',
);

Widget _wrap(String id) => MaterialApp(
  home: SpeakingQuizPage(content: _content(id), currentPage: AppPage.articles),
);

/// Pumps the page on a viewport tall enough to build the whole list: the score
/// field sits below the default 600px fold, and a lazy ListView never builds
/// what it can't show. Sized through `tester.view` — `setSurfaceSize` leaves
/// MediaQuery at 800x600, so adaptive widgets would test the wrong branch.
Future<void> _pumpPage(WidgetTester tester, String id) async {
  tester.view.physicalSize = const Size(1200, 2600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  // Warm the template cache with real I/O: the page loads it from the asset
  // bundle, and a fake-async pump can't drive a real file read to completion.
  await tester.runAsync(() => SpeakingPromptBuilder.load('en'));
  await tester.pumpWidget(_wrap(id));
  // The prompt is rendered from an async template load, so the first frames show
  // a spinner. pumpAndSettle can't be used here (the shell keeps a frame
  // scheduled), so pump until the page's own content is on screen.
  for (var i = 0; i < 40 && find.byType(TextField).evaluate().isEmpty; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      // Skip the first-run explainer sheet; it would sit over the page.
      kSpeakingExplainerSeenKey: true,
    });
    // getInstance() caches across tests in one file, so the mock values above
    // only take effect after a reload — otherwise a completion saved by an
    // earlier test leaks into the next one.
    await (await SharedPreferences.getInstance()).reload();
    await AppSession.instance.load();
    await CourseSession.instance.load();
    await NounSettings.instance.load();
    await CoinWallet.instance.load();
    // Saving a score finishes the quiz, which schedules the feature poll behind
    // a delay; put it on cooldown or the binding fails on '!timersPending'.
    await NounSettings.instance.markFeaturePollShown();
  });

  testWidgets('shows the steps, the trigger phrase and the disclaimer',
      (tester) async {
    await _pumpPage(tester, 'speaking_steps');

    final s = CourseSession.instance.strings.speaking;
    expect(find.text(s.howItWorksTitle), findsOneWidget);
    expect(find.text(s.step1), findsOneWidget);
    // The persistent disclaimer is on the page itself, not only in the sheet.
    expect(find.text(s.disclaimerShort), findsOneWidget);
    expect(find.textContaining("Los geht's"), findsOneWidget);
    expect(find.text(s.copyExercise), findsOneWidget);
  });

  testWidgets('copy puts the rendered prompt on the clipboard', (tester) async {
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );

    await _pumpPage(tester, 'speaking_copy');
    await tester.tap(find.text(CourseSession.instance.strings.speaking.copyExercise));
    await tester.pumpAndSettle();

    expect(copied, isNotNull);
    expect(copied, contains('My weekend and what I did.'));
    expect(copied, contains('Perfekt with haben/sein'));
    expect(copied, contains('SCORE='));
    expect(copied, contains("Los geht's"));
    // No placeholder survived into what the learner pastes.
    expect(RegExp(r'\{\w+\}').firstMatch(copied!), isNull);
  });

  testWidgets('the AI hand-off buttons appear only once the prompt is copied',
      (tester) async {
    // The hand-off only unlocks once the clipboard write succeeds, so this test
    // needs a working clipboard as well as a working launcher.
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async => null,
    );
    final launched = <String>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/url_launcher'),
      (call) async {
        if (call.method == 'launch') {
          launched.add((call.arguments as Map)['url'] as String);
        }
        return true;
      },
    );
    addTearDown(() {
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      );
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/url_launcher'),
        null,
      );
    });

    await _pumpPage(tester, 'speaking_handoff');
    final s = CourseSession.instance.strings.speaking;
    final gemini = s.openAssistant.replaceAll('{ai}', 'Gemini');

    // Opening the assistant before copying would land the learner in an empty
    // chat with nothing to paste, so there is nothing to tap yet.
    expect(find.text(gemini), findsNothing);

    await tester.tap(find.text(s.copyExercise));
    await tester.pumpAndSettle();

    expect(find.text(s.openTitle), findsOneWidget);
    expect(find.text(gemini), findsOneWidget);
    expect(find.text(s.openAssistant.replaceAll('{ai}', 'ChatGPT')),
        findsOneWidget);

    await tester.tap(find.text(gemini));
    await tester.pumpAndSettle();

    expect(launched, ['https://gemini.google.com/app']);
    // The choice sticks, so the next visit offers it first.
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('speaking_preferred_ai'), 'gemini');
  });

  testWidgets('a passing score saves, completes the quiz and pays coins',
      (tester) async {
    await _pumpPage(tester, 'speaking_pass');

    final s = CourseSession.instance.strings.speaking;
    final before = CoinWallet.instance.balance;

    // Paste the AI's whole report: the score is read off its SCORE= line.
    await tester.enterText(find.byType(TextField), 'FINAL SCORE: 84 / 100\nSCORE=84');
    await tester.pumpAndSettle();
    await tester.tap(find.text(s.saveScore));
    await tester.pumpAndSettle();

    expect(find.text(s.silver), findsOneWidget);
    expect(find.textContaining('84 / 100'), findsOneWidget);
    expect(NounSettings.instance.isSpeakQuizCompleted('speaking_pass'), isTrue);
    expect(CoinWallet.instance.balance, greaterThan(before));

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getInt('speaking_pass_speaking_best'), 84);
  });

  testWidgets('a failing score records the attempt but does not complete',
      (tester) async {
    await _pumpPage(tester, 'speaking_fail');

    final s = CourseSession.instance.strings.speaking;
    await tester.enterText(find.byType(TextField), '30');
    await tester.pumpAndSettle();
    await tester.tap(find.text(s.saveScore));
    await tester.pumpAndSettle();

    // No medal below grade 5 — a "try again", and the quiz stays open.
    expect(find.text(s.tryAgain), findsOneWidget);
    expect(NounSettings.instance.isSpeakQuizCompleted('speaking_fail'), isFalse);
  });

  testWidgets('the first-run sheet is sized to its content, not the viewport',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    await (await SharedPreferences.getInstance()).reload();

    tester.view.physicalSize = const Size(1200, 2600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.runAsync(() => SpeakingPromptBuilder.load('en'));
    await tester.pumpWidget(_wrap('speaking_explainer'));
    for (var i = 0;
        i < 40 && find.text(CourseSession.instance.strings.gotIt).evaluate().isEmpty;
        i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    final s = CourseSession.instance.strings.speaking;
    expect(find.text(s.whyTitle), findsOneWidget);

    // The sheet must hug its content: a fixed-fraction sheet would leave a band
    // of empty panel under the button on a tall window.
    final sheet = tester.getRect(
      find.ancestor(
        of: find.text(s.whyTitle),
        matching: find.byType(SingleChildScrollView),
      ),
    );
    final buttonBottom = tester.getRect(
      find.text(CourseSession.instance.strings.gotIt),
    ).bottom;
    expect(sheet.bottom - buttonBottom, lessThan(80));
  });

  testWidgets('Save stays disabled until the score parses', (tester) async {
    await _pumpPage(tester, 'speaking_validation');

    final s = CourseSession.instance.strings.speaking;
    FilledButton saveButton() => tester.widget<FilledButton>(
      find.ancestor(
        of: find.text(s.saveScore),
        matching: find.byType(FilledButton),
      ),
    );

    expect(saveButton().onPressed, isNull);

    await tester.enterText(find.byType(TextField), '101');
    await tester.pumpAndSettle();
    expect(saveButton().onPressed, isNull);

    await tester.enterText(find.byType(TextField), '77');
    await tester.pumpAndSettle();
    expect(saveButton().onPressed, isNotNull);
  });
}
