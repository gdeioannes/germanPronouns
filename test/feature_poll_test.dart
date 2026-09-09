import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:german_pronouns_articles/l10n/app_strings.dart';
import 'package:german_pronouns_articles/models/coin_wallet.dart';
import 'package:german_pronouns_articles/models/course.dart';
import 'package:german_pronouns_articles/models/noun_settings.dart';
import 'package:german_pronouns_articles/models/settings_keys.dart';
import 'package:german_pronouns_articles/models/user_settings.dart';
import 'package:german_pronouns_articles/widgets/feature_poll.dart';

/// Sizes the test screen so the widget under test really sees [size].
///
/// `binding.setSurfaceSize` is the trap here: it resizes the render surface but
/// leaves MediaQuery reporting 800x600, so an adaptive panel lays out for the
/// wrong width and silently picks the wrong branch. Setting the view is what
/// MediaQuery actually reads.
void _useScreen(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

/// Pumps a host with a button that opens the poll, and taps it open.
Future<void> _openPoll(WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (context) => TextButton(
          onPressed: () => showFeaturePoll(context),
          child: const Text('open'),
        ),
      ),
    ),
  ));
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    CoinWallet.instance.resetForTest();
    // NounSettings is a singleton whose load() is guarded by a _loaded flag, so
    // a second load() is a no-op and flags would leak between tests. resetAll()
    // is the reset that actually puts every field back to its default.
    await NounSettings.instance.load();
    await NounSettings.instance.resetAll();
  });

  group('when the poll is due', () {
    test('immediately, when it has never been shown', () {
      expect(NounSettings.instance.featurePollLastShown, isNull);
      expect(isFeaturePollDue(), isTrue);
    });

    test('not again during the cooldown week', () async {
      final shownAt = DateTime(2026, 8, 1, 9);
      await NounSettings.instance.markFeaturePollShown(shownAt);

      expect(isFeaturePollDue(now: shownAt), isFalse);
      expect(isFeaturePollDue(now: shownAt.add(const Duration(minutes: 5))),
          isFalse);
      expect(isFeaturePollDue(now: shownAt.add(const Duration(days: 6, hours: 23))),
          isFalse);
    });

    test('again once a week has passed and the learner came back', () async {
      final shownAt = DateTime(2026, 8, 1, 9);
      await NounSettings.instance.markFeaturePollShown(shownAt);

      expect(isFeaturePollDue(now: shownAt.add(kFeaturePollCooldown)), isTrue);
      expect(isFeaturePollDue(now: shownAt.add(const Duration(days: 30))),
          isTrue);
    });

    test('and answering again restarts the cooldown', () async {
      final first = DateTime(2026, 8, 1, 9);
      await NounSettings.instance.markFeaturePollShown(first);
      final second = first.add(const Duration(days: 8));
      expect(isFeaturePollDue(now: second), isTrue);

      await NounSettings.instance.markFeaturePollShown(second);
      expect(isFeaturePollDue(now: second.add(const Duration(days: 3))),
          isFalse);
      expect(isFeaturePollDue(now: second.add(const Duration(days: 8))), isTrue);
    });
  });

  test('the last-shown time persists and survives a reload', () async {
    final shownAt = DateTime(2026, 8, 1, 9);
    await NounSettings.instance.markFeaturePollShown(shownAt);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getInt(SettingsKeys.featurePollLastShown),
        shownAt.millisecondsSinceEpoch);

    await NounSettings.instance.load();
    expect(NounSettings.instance.featurePollLastShown, shownAt);
  });

  test('the last-shown time round-trips through the settings snapshot', () {
    const settings = UserSettings(featurePollLastShownMillis: 1754038800000);
    final restored = UserSettings.fromJson(settings.toJson());
    expect(restored.featurePollLastShownMillis, 1754038800000);
    // Absent in an older snapshot means "never asked", so upgrading users do
    // get the poll rather than being silently skipped forever.
    expect(UserSettings.fromJson(const {}).featurePollLastShownMillis, isNull);
  });

  group('the options', () {
    test('carry stable, unique analytics ids', () {
      final ids = FeaturePollChoice.values.map((c) => c.id).toList();
      expect(ids.toSet().length, ids.length, reason: 'ids must be unique');
      // Pinned: renaming one splits its history in the analytics dashboard.
      expect(ids, const [
        'games',
        'account_sync',
        'more_courses',
        'mistake_review',
        'speaking',
        'reminders',
      ]);
    });

    test('lead with the two the app most wants to decide between', () {
      expect(FeaturePollChoice.values.first, FeaturePollChoice.games);
      expect(FeaturePollChoice.values[1], FeaturePollChoice.account);
    });

    test('have a real label in every UI language', () {
      for (final lang in UiLang.values) {
        final strings = stringsFor(lang);
        expect(strings.featurePollTitle.trim(), isNotEmpty, reason: '$lang');
        expect(strings.featurePollBody.trim(), isNotEmpty, reason: '$lang');
        expect(strings.featurePollNotNow.trim(), isNotEmpty, reason: '$lang');
        // Label of the Settings / course-home buttons that open it on demand.
        expect(strings.featurePollOpen.trim(), isNotEmpty, reason: '$lang');
        // The thanks line must keep its placeholder, or the payout goes unsaid.
        expect(strings.featurePollThanks, contains('{coins}'), reason: '$lang');
        // The no-coins thanks must NOT promise a payout.
        expect(strings.featurePollThanksAgain.trim(), isNotEmpty,
            reason: '$lang');
        expect(strings.featurePollThanksAgain, isNot(contains('{coins}')),
            reason: '$lang');
        final labels = <String>[];
        for (final choice in FeaturePollChoice.values) {
          final label = choice.label(strings);
          expect(label.trim(), isNotEmpty, reason: '$lang / ${choice.id}');
          labels.add(label);
        }
        expect(labels.toSet().length, labels.length,
            reason: '$lang has a duplicated option label');
      }
    });
  });

  testWidgets('tapping an option answers, pays coins and never asks again',
      (tester) async {
    _useScreen(tester, const Size(900, 1200)); // wide: the dialog branch
    await _openPoll(tester);

    final strings = stringsFor(UiLang.en);
    expect(find.text(strings.featurePollTitle), findsOneWidget);
    for (final choice in FeaturePollChoice.values) {
      expect(find.text(choice.label(strings)), findsOneWidget);
    }

    await tester.tap(find.text(strings.featurePollGames));
    await tester.pumpAndSettle();

    expect(find.text(strings.featurePollTitle), findsNothing);
    expect(CoinWallet.instance.balance, CoinWallet.featurePollBonus);
    expect(NounSettings.instance.featurePollLastShown, isNotNull);
    expect(isFeaturePollDue(), isFalse); // the cooldown has started
  });

  testWidgets('dismissing still counts as asked, and pays nothing',
      (tester) async {
    _useScreen(tester, const Size(900, 1200));
    await _openPoll(tester);

    final strings = stringsFor(UiLang.en);
    await tester.tap(find.text(strings.featurePollNotNow));
    await tester.pumpAndSettle();

    // The poll really closed — so the assertions below can't pass vacuously.
    expect(find.text(strings.featurePollTitle), findsNothing);
    expect(CoinWallet.instance.balance, 0);
    expect(NounSettings.instance.featurePollLastShown, isNotNull);
    expect(isFeaturePollDue(), isFalse); // the cooldown has started
  });

  testWidgets('on a phone every option and the dismiss button are reachable',
      (tester) async {
    // The narrow branch is a scrollable sheet: six options wrap to two lines
    // and overflow the screen, so this guards the regression where the last
    // option and "Not now" sat off-screen with no way to reach them.
    _useScreen(tester, const Size(390, 780));
    await _openPoll(tester);

    final strings = stringsFor(UiLang.en);
    for (final choice in FeaturePollChoice.values) {
      final option = find.text(choice.label(strings));
      expect(option, findsOneWidget, reason: choice.id);
      await tester.ensureVisible(option);
      await tester.pumpAndSettle();
    }

    final notNow = find.text(strings.featurePollNotNow);
    await tester.ensureVisible(notNow);
    await tester.pumpAndSettle();
    await tester.tap(notNow);
    await tester.pumpAndSettle();
    expect(find.text(strings.featurePollTitle), findsNothing);
  });

  /// Puts [minutes] of course time on the clock, so the after-quiz ask's
  /// usage gate (kFeaturePollMinUsage) is satisfied — or not.
  /// Anchored to the real clock: the entry point ticks the clock itself with
  /// DateTime.now(), so a marker left in the fake past would be counted as a
  /// (capped) extra half-hour segment.
  Future<void> spendOnCourse(int minutes) async {
    final now = DateTime.now();
    await NounSettings.instance
        .markCourseUsage(now.subtract(Duration(minutes: minutes)));
    await NounSettings.instance.markCourseUsage(now);
  }

  testWidgets('the after-quiz entry point waits, then asks when due',
      (tester) async {
    await spendOnCourse(20);
    _useScreen(tester, const Size(900, 1200));
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => maybeShowFeaturePollAfterQuiz(context),
            child: const Text('finish'),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('finish'));
    await tester.pump();

    final strings = stringsFor(UiLang.en);
    // Nothing yet — the celebration gets the screen to itself first.
    expect(find.text(strings.featurePollTitle), findsNothing);

    await tester.pump(kFeaturePollDelay);
    await tester.pumpAndSettle();
    expect(find.text(strings.featurePollTitle), findsOneWidget);

    await tester.tap(find.text(strings.featurePollGames));
    await tester.pumpAndSettle();
    expect(CoinWallet.instance.balance, CoinWallet.featurePollBonus);
  });

  testWidgets(
      'the after-quiz entry point stays silent before 20 minutes on the course',
      (tester) async {
    await spendOnCourse(15); // not enough yet
    expect(isFeaturePollDue(), isTrue); // never shown — only usage blocks it
    _useScreen(tester, const Size(900, 1200));
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => maybeShowFeaturePollAfterQuiz(context),
            child: const Text('finish'),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('finish'));
    await tester.pump(kFeaturePollDelay);
    await tester.pumpAndSettle();

    expect(find.text(stringsFor(UiLang.en).featurePollTitle), findsNothing);
    expect(CoinWallet.instance.balance, 0);
  });

  test('course time accumulates across segments but a single one is capped',
      () async {
    final t0 = DateTime(2026, 8, 1, 9);
    await NounSettings.instance.markCourseUsage(t0);
    // An overnight-open tab: only 30 minutes of this segment count.
    await NounSettings.instance.markCourseUsage(t0.add(const Duration(hours: 9)));
    expect(NounSettings.instance.courseUsage(t0.add(const Duration(hours: 9))),
        const Duration(minutes: 30));
    // …and the total persists.
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getInt(SettingsKeys.courseUsageMs),
        const Duration(minutes: 30).inMilliseconds);
  });

  testWidgets('the after-quiz entry point stays silent during the cooldown',
      (tester) async {
    await spendOnCourse(20);
    await NounSettings.instance.markFeaturePollShown();
    _useScreen(tester, const Size(900, 1200));
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => maybeShowFeaturePollAfterQuiz(context),
            child: const Text('finish'),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('finish'));
    await tester.pump(kFeaturePollDelay);
    await tester.pumpAndSettle();

    expect(find.text(stringsFor(UiLang.en).featurePollTitle), findsNothing);
    expect(CoinWallet.instance.balance, 0);
  });

  group('opened on demand from Settings / the course home', () {
    testWidgets('opens even while the poll is on cooldown', (tester) async {
      await NounSettings.instance.markFeaturePollShown();
      expect(isFeaturePollDue(), isFalse);

      _useScreen(tester, const Size(900, 1200));
      await _openPoll(tester);

      // The due check gates the automatic ask only — a button press always
      // opens it, or the entry point would look broken.
      expect(
          find.text(stringsFor(UiLang.en).featurePollTitle), findsOneWidget);
    });

    testWidgets('pays no coins for a second answer inside the same week',
        (tester) async {
      await NounSettings.instance.markFeaturePollShown();
      _useScreen(tester, const Size(900, 1200));
      await _openPoll(tester);

      final strings = stringsFor(UiLang.en);
      await tester.tap(find.text(strings.featurePollGames));
      await tester.pumpAndSettle();

      // The vote still counts; the reward does not repeat, so the manual
      // buttons can't be farmed for coins.
      expect(CoinWallet.instance.balance, 0);
      expect(find.text(strings.featurePollThanksAgain), findsOneWidget);
    });

    testWidgets('adds to the existing balance when opened before the wallet '
        'has loaded', (tester) async {
      // The login page offers the poll before the learner shell boots, so the
      // wallet may still be unloaded. CoinWallet.add() increments its
      // in-memory balance, so answering without loading first would start from
      // a stale zero and persist 40 over the learner's real coins.
      SharedPreferences.setMockInitialValues({SettingsKeys.coinBalance: 500});
      CoinWallet.instance.resetForTest(); // simulates "not loaded yet"
      expect(CoinWallet.instance.balance, 0);

      _useScreen(tester, const Size(900, 1200));
      await _openPoll(tester);
      await tester.tap(find.text(stringsFor(UiLang.en).featurePollGames));
      await tester.pumpAndSettle();

      expect(CoinWallet.instance.balance, 500 + CoinWallet.featurePollBonus);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt(SettingsKeys.coinBalance),
          500 + CoinWallet.featurePollBonus);
    });

    testWidgets('still pays when the learner opens it while it is due',
        (tester) async {
      expect(isFeaturePollDue(), isTrue);
      _useScreen(tester, const Size(900, 1200));
      await _openPoll(tester);

      await tester.tap(find.text(stringsFor(UiLang.en).featurePollGames));
      await tester.pumpAndSettle();

      expect(CoinWallet.instance.balance, CoinWallet.featurePollBonus);
    });
  });

  testWidgets('a phone learner can actually pick the last option',
      (tester) async {
    _useScreen(tester, const Size(390, 780));
    await _openPoll(tester);

    final strings = stringsFor(UiLang.en);
    final last = find.text(strings.featurePollReminders);
    await tester.ensureVisible(last);
    await tester.pumpAndSettle();
    await tester.tap(last);
    await tester.pumpAndSettle();

    expect(find.text(strings.featurePollTitle), findsNothing);
    expect(CoinWallet.instance.balance, CoinWallet.featurePollBonus);
  });
}
