import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/data/placement/placement_modules.dart';
import 'package:german_pronouns_articles/data/placement/placement_test.dart';
import 'package:german_pronouns_articles/models/course.dart';
import 'package:german_pronouns_articles/models/nav_layout.dart';
import 'package:german_pronouns_articles/models/noun_settings.dart';
import 'package:german_pronouns_articles/models/settings_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

NavGroup _group(String id, List<String> refs, {bool gated = true}) => NavGroup(
  id: id,
  title: '${id.toUpperCase()} · SOMETHING',
  type: NavGroupType.quizzes,
  gated: gated,
  items: [for (final r in refs) NavItem(ref: r)],
);

Course _course(List<NavGroup> groups) => Course(
  id: 'test_course',
  name: 'Test',
  tagline: 'Test',
  speakFlag: 'gb',
  learnFlag: 'de',
  uiLang: UiLang.en,
  nav: NavLayout(groups: groups),
);

PlacementQuestion _q(int module, {String answer = 'right'}) =>
    PlacementQuestion(
      moduleIndex: module,
      sentence: 'Ich ____ hier.',
      acceptedAnswers: [answer],
    );

/// A paper of [modules] modules × [perModule] questions, all answerable with
/// 'right'.
List<PlacementQuestion> _paper(int modules, int perModule) => [
  for (var m = 0; m < modules; m++)
    for (var i = 0; i < perModule; i++) _q(m),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('modules', () {
    test('every gated group is a module, in nav order', () {
      final modules = placementModules(
        _course([
          _group('a1_1', ['q1', 'q2']),
          _group('a1_2', ['q3']),
          NavGroup(
            id: 'more',
            title: 'MORE',
            type: NavGroupType.links,
            items: [NavItem(ref: 'settings')],
          ),
        ]),
      );

      expect(modules.map((m) => m.id), ['a1_1', 'a1_2']);
      expect(modules.first.quizRefs, ['q1', 'q2']);
      expect(modules.first.shortTitle, 'A1_1');
    });

    test('ungated groups are not modules — nothing there to unlock', () {
      final modules = placementModules(
        _course([
          _group('m1', ['q1'], gated: false),
          _group('m2', ['q2'], gated: false),
        ]),
      );
      expect(modules, isEmpty);
      expect(
        supportsPlacement(_course([_group('m1', ['q1'], gated: false)])),
        isFalse,
      );
    });

    test('a single module is not placeable — there is one place to be', () {
      expect(placementModules(_course([_group('a1_1', ['q1'])])), isEmpty);
    });

    test('hidden items are left out of a module', () {
      final modules = placementModules(
        _course([
          NavGroup(
            id: 'a1_1',
            title: 'A1.1',
            type: NavGroupType.quizzes,
            gated: true,
            items: [NavItem(ref: 'q1'), NavItem(ref: 'q2', hidden: true)],
          ),
          _group('a1_2', ['q3']),
        ]),
      );
      expect(modules.first.quizRefs, ['q1']);
    });

    test('unlocking up to a module opens everything before it, not itself', () {
      final modules = placementModules(
        _course([
          _group('a1_1', ['q1', 'q2']),
          _group('a1_2', ['q3']),
          _group('a2_1', ['q4']),
        ]),
      );

      // Placed at a2_1: the two earlier modules open, a2_1 is where they start.
      expect(refsUnlockedUpTo(modules, 2), {'q1', 'q2', 'q3'});
      // Placed at the first module: nothing to open — a plain fresh start.
      expect(refsUnlockedUpTo(modules, 0), isEmpty);
    });
  });

  group('scoring', () {
    test('places the learner in the first module they fail', () {
      final questions = _paper(3, 4);
      // Module 0 and 1 perfect, module 2 all wrong.
      final answers = [
        ...List.filled(8, 'right'),
        ...List.filled(4, 'wrong'),
      ];

      final result = scorePlacement(questions, answers, moduleCount: 3);
      expect(result.moduleIndex, 2);
      expect(result.completedWholeTest, isFalse);
      expect(result.correctByModule[2], 0);
      expect(result.askedByModule[2], 4);
    });

    test('clearing everything places the learner in the last module', () {
      final questions = _paper(3, 4);
      final result = scorePlacement(
        questions,
        List.filled(12, 'right'),
        moduleCount: 3,
      );
      expect(result.moduleIndex, 2);
      expect(result.completedWholeTest, isTrue);
    });

    test('the pass mark is a ratio, not perfection', () {
      final questions = _paper(2, 4);
      // 3/4 = 0.75, comfortably over the 0.6 bar; then 2/4 = 0.5, under it.
      final answers = [
        'right', 'right', 'right', 'wrong', //
        'right', 'right', 'wrong', 'wrong',
      ];
      final result = scorePlacement(questions, answers, moduleCount: 2);
      expect(result.moduleIndex, 1);
    });

    test('a module the test never reached cannot place the learner', () {
      final questions = _paper(3, 4);
      // Stopped after module 0, which was failed.
      final result = scorePlacement(
        questions,
        List.filled(4, 'wrong'),
        moduleCount: 3,
      );
      expect(result.moduleIndex, 0);
      expect(result.askedByModule.containsKey(1), isFalse);
    });
  });

  group('early stop', () {
    test('decides as soon as a finished module was failed', () {
      final questions = _paper(3, 4);
      expect(placementDecided(questions, List.filled(4, 'wrong')), isTrue);
    });

    test('does not decide mid-module', () {
      final questions = _paper(3, 4);
      // Three wrong answers in, but module 0 isn't finished being asked.
      expect(placementDecided(questions, List.filled(3, 'wrong')), isFalse);
    });

    test('does not stop a learner who is passing', () {
      final questions = _paper(3, 4);
      expect(placementDecided(questions, List.filled(4, 'right')), isFalse);
      expect(placementDecided(questions, List.filled(8, 'right')), isFalse);
    });
  });

  group('answers', () {
    test('accepts case and stray whitespace, rejects empty', () {
      const q = PlacementQuestion(
        moduleIndex: 0,
        sentence: 'Ich ____ hier.',
        acceptedAnswers: ['bin nicht'],
      );
      expect(q.accepts('bin nicht'), isTrue);
      expect(q.accepts('  BIN   nicht '), isTrue);
      expect(q.accepts('bin'), isFalse);
      // "I don't know" submits an empty answer; it must never count as right.
      expect(q.accepts(''), isFalse);
      expect(q.accepts('   '), isFalse);
    });
  });

  // [NounSettings] is a singleton whose load() runs once per test *file*, so
  // these tests share one store. Each uses its own ref namespace and asserts
  // only about its own refs — the same approach the other singleton-backed
  // suites take.
  group('unlock persistence', () {
    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await (await SharedPreferences.getInstance()).reload();
      await NounSettings.instance.load();
    });

    Set<String> unlockedAmong(Iterable<String> refs) =>
        NounSettings.instance.placementUnlockedQuizzes.intersection(refs.toSet());

    test('a placed quiz clears the gate but is never done', () async {
      await NounSettings.instance.setPlacementUnlocked(
        courseRefs: ['a1', 'a2', 'a3'],
        unlocked: ['a1', 'a2'],
      );

      final settings = NounSettings.instance;
      expect(settings.clearsGate('a1', done: false), isTrue);
      expect(settings.clearsGate('a3', done: false), isFalse);
      // The completion sets — what ribbons, coins and the ring read — are
      // untouched, which is what "no medals, no coins" means in storage.
      expect(settings.isQuestQuizCompleted('a1'), isFalse);
      expect(settings.completedQuestQuizzes, isEmpty);
      expect(settings.questGateCleared, contains('a1'));
    });

    test('re-placing replaces the course\'s previous unlock set', () async {
      await NounSettings.instance.setPlacementUnlocked(
        courseRefs: ['b1', 'b2', 'b3'],
        unlocked: ['b1', 'b2'],
      );
      // Placed lower the second time: b2 must close again.
      await NounSettings.instance.setPlacementUnlocked(
        courseRefs: ['b1', 'b2', 'b3'],
        unlocked: ['b1'],
      );
      expect(unlockedAmong(['b1', 'b2', 'b3']), {'b1'});
    });

    test('another course\'s placement survives', () async {
      await NounSettings.instance.setPlacementUnlocked(
        courseRefs: ['c_other'],
        unlocked: ['c_other'],
      );
      await NounSettings.instance.setPlacementUnlocked(
        courseRefs: ['c1', 'c2'],
        unlocked: ['c1'],
      );
      // Both German courses share the Quest chain, so scoping the reset to the
      // course's own refs is what keeps one placement from wiping the other.
      expect(unlockedAmong(['c_other', 'c1', 'c2']), {'c_other', 'c1'});
    });

    test('deleting a course\'s progress closes the gates it opened', () async {
      await NounSettings.instance.setPlacementUnlocked(
        courseRefs: ['d1', 'd2'],
        unlocked: ['d1', 'd2'],
      );
      await NounSettings.instance.unmarkCompletions(['d1', 'd2']);
      expect(unlockedAmong(['d1', 'd2']), isEmpty);
      expect(NounSettings.instance.clearsGate('d1', done: false), isFalse);
    });

    test('the unlock set is written to storage, not just held', () async {
      await NounSettings.instance.setPlacementUnlocked(
        courseRefs: ['e1', 'e2'],
        unlocked: ['e1'],
      );
      final prefs = await SharedPreferences.getInstance();
      final stored =
          prefs.getStringList(SettingsKeys.placementUnlockedQuizzes) ?? [];
      expect(stored, contains('e1'));
      expect(stored, isNot(contains('e2')));
    });

    // The drawer and the course home cache lock state and only recompute when
    // this fires; without it a placed learner sees their new level only after
    // reopening the page.
    test('applying a placement signals listeners to reload', () async {
      final seen = <int>[];
      void listener() => seen.add(progressRevision.value);
      progressRevision.addListener(listener);
      addTearDown(() => progressRevision.removeListener(listener));

      await NounSettings.instance.setPlacementUnlocked(
        courseRefs: ['f1', 'f2'],
        unlocked: ['f1'],
      );
      expect(seen, hasLength(1));

      await NounSettings.instance.unmarkCompletions(['f1', 'f2']);
      expect(seen, hasLength(2));

      await NounSettings.instance.markQuestQuizCompleted('f1');
      expect(seen, hasLength(3));
    });
  });
}
