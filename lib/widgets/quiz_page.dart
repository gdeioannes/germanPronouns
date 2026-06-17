import 'dart:math';
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/noun_lookup.dart';
import '../data/noun_plurals.dart';
import '../data/noun_progression_data.dart';
import '../models/noun_settings.dart';
import '../models/quiz_config.dart';
import '../pages/word_library_page.dart';
import '../theme/app_theme.dart';
import 'app_drawer.dart';
import 'fireworks.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key, required this.config});

  final QuizConfig config;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with TickerProviderStateMixin {
  final TextEditingController _answerController = TextEditingController();
  final FocusNode _answerFocusNode = FocusNode();
  final ScrollController _tableScrollController = ScrollController();
  final Random _random = Random();

  static const List<Color> _rainbowColors = [
    Color(0xFFE53935),
    Color(0xFFFF7043),
    Color(0xFFFFB300),
    Color(0xFF43A047),
    Color(0xFF1E88E5),
    Color(0xFF5E35B1),
    Color(0xFFD81B60),
  ];
  static const int _maxStoredHistory = 100;
  static const int _maxStreak = 5;

  String get _historyStorageKey =>
      '${widget.config.storageKeyPrefix}quiz_answer_history';
  String get _mistakesStorageKey =>
      '${widget.config.storageKeyPrefix}quiz_mistakes_by_case';
  String get _scoreStorageKey =>
      '${widget.config.storageKeyPrefix}quiz_score';
  String get _streakStorageKey =>
      '${widget.config.storageKeyPrefix}quiz_streak';
  String get _bestStreakLapKey =>
      '${widget.config.storageKeyPrefix}quiz_best_streak_lap';
  String get _bestStreakAbsoluteKey =>
      '${widget.config.storageKeyPrefix}quiz_best_streak_absolute';
  String get _enabledSubjectsKey =>
      '${widget.config.storageKeyPrefix}quiz_enabled_pronouns';
  String get _enabledCategoriesKey =>
      '${widget.config.storageKeyPrefix}quiz_enabled_cases';

  int _score = 0;
  int _streakAbsolute = 0;
  int _bestStreakLap = 0;

  /// Highest [_streakAbsolute] ever reached for this quiz, persisted under
  /// [_bestStreakAbsoluteKey] and shown in the drawer's streak stat (which,
  /// unlike [_streakAbsolute], doesn't reset to 0 on a wrong answer).
  int _bestStreakAbsolute = 0;
  int get _streakLap => _streakAbsolute ~/ _maxStreak;
  int _currentSubjectIndex = 0;
  int _currentCategoryIndex = 0;
  String _feedback = '';
  String _feedbackHint = '';
  bool? _lastAnswerCorrect;

  /// Details of the most recently submitted answer (exercise, user's
  /// answer, correct answer, and whether it was correct), shown via the
  /// "Last answer" info button. Persists across questions until the next
  /// answer is submitted.
  Map<String, Object>? _lastAnswerInfo;

  /// True while the correct answer is being revealed in the answer field
  /// after an incorrect submission (animated or instant, per
  /// [NounSettings.answerRevealAnimationEnabled]), before advancing to the
  /// next question.
  bool _showingAnswerReveal = false;

  /// True while [QuizConfig.sentenceHint] for the current sentence is
  /// revealed via the eye icon. Resets to false on every new question.
  bool _showSentenceHint = false;
  String _currentReferenceSentence = '';
  String _currentReferenceExplanation = '';
  bool _showFireworks = false;
  late final AnimationController _fireworksController;
  List<FireworkParticle> _fireworkParticles = const [];

  /// True while the special "noun category unlocked" celebration (gold
  /// fireworks plus a centered "Noun Category Unlocked!" banner naming the
  /// newly-unlocked category) is playing.
  bool _showCategoryUnlockCelebration = false;
  late final AnimationController _categoryUnlockController;
  List<FireworkParticle> _categoryUnlockParticles = const [];
  String _unlockedCategoryName = '';
  List<Map<String, dynamic>> _answerHistory = [];
  Map<String, int> _mistakesByCase = {};

  /// Tracks sentences that have been answered incorrectly in the current
  /// question cycle, used to show first letter hint only on first wrong answer.
  final Set<String> _attemptedSentences = {};

  /// True while showing the first-letter hint, used to display the red asterisk
  /// prefix without making the field read-only.
  bool _showingFirstLetterHint = false;

  late Set<int> _enabledSubjectIndices;
  late Set<String> _enabledCategoryLabels;

  // Shuffle bags for `_nextQuestion`'s subject/group/category picks: each
  // bag is drained in random order before reshuffling, so every option is
  // seen once per cycle instead of repeating early.
  final List<int> _subjectBag = [];
  final List<String> _groupBag = [];
  final List<QuizCategoryDefinition> _categoryBag = [];

  @override
  void initState() {
    super.initState();
    _enabledSubjectIndices = Set<int>.from(
      List.generate(widget.config.subjects.length, (i) => i),
    );
    _enabledCategoryLabels = widget.config.categories
        .map((c) => c.label)
        .toSet();
    _fireworksController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 1800),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed && mounted) {
            setState(() {
              _showFireworks = false;
            });
          }
        });
    _categoryUnlockController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 2800),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed && mounted) {
            setState(() {
              _showCategoryUnlockCelebration = false;
            });
          }
        });
    _nextQuestion();
    _loadStoredStats();
    _requestAnswerFocus();
    if (widget.config.subjectCategories != null) {
      NounSettings.instance.load().then((_) {
        if (!mounted) return;
        final currentNoun = widget.config.subjects[_currentSubjectIndex];
        if (!NounSettings.instance.isEnabled(currentNoun)) {
          setState(_nextQuestion);
        }
      });
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    _answerFocusNode.dispose();
    _tableScrollController.dispose();
    _fireworksController.dispose();
    _categoryUnlockController.dispose();
    super.dispose();
  }

  void _triggerFireworks({
    required int streakAbsolute,
    required bool lapCompleted,
    required int streakLap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final lapColor = _rainbowColors[streakLap % _rainbowColors.length];
    final palette = [
      lapColor,
      colorScheme.primary,
      colorScheme.tertiary,
      Colors.orange,
      Colors.amber,
      Colors.lightBlue,
    ];

    final baseIntensity =
        1.0 + (streakLap * 0.3) + (streakAbsolute % _maxStreak) * 0.05;
    final intensity = lapCompleted ? baseIntensity + 0.9 : baseIntensity;
    final particleCount = (34 * intensity).round().clamp(36, 120);
    final particles = List.generate(particleCount, (_) {
      final angle = _random.nextDouble() * 2 * pi;
      final direction = Offset(cos(angle), sin(angle));
      return FireworkParticle(
        origin: Offset(
          0.2 + _random.nextDouble() * 0.6,
          0.3 + _random.nextDouble() * 0.25,
        ),
        direction: direction,
        speed: (52 + _random.nextDouble() * 46) * intensity,
        size: (1.9 + _random.nextDouble() * 2.3) * (0.9 + intensity * 0.22),
        color: palette[_random.nextInt(palette.length)],
      );
    });

    setState(() {
      _fireworkParticles = particles;
      _showFireworks = true;
    });
    _fireworksController.forward(from: 0);
  }

  /// Plays the special "noun category unlocked" celebration: a bigger,
  /// gold-toned firework burst spreading from across the card, plus a
  /// centered banner naming [unlockedCategoryName].
  void _triggerCategoryUnlockCelebration(String unlockedCategoryName) {
    const palette = [
      Colors.amber,
      Colors.amberAccent,
      Color(0xFFFFD54F),
      Colors.deepOrange,
      Colors.white,
    ];

    final particles = List.generate(160, (_) {
      final angle = _random.nextDouble() * 2 * pi;
      final direction = Offset(cos(angle), sin(angle));
      return FireworkParticle(
        origin: Offset(
          0.1 + _random.nextDouble() * 0.8,
          0.15 + _random.nextDouble() * 0.5,
        ),
        direction: direction,
        speed: 70 + _random.nextDouble() * 90,
        size: 2.2 + _random.nextDouble() * 3.2,
        color: palette[_random.nextInt(palette.length)],
      );
    });

    setState(() {
      _categoryUnlockParticles = particles;
      _unlockedCategoryName = unlockedCategoryName;
      _showCategoryUnlockCelebration = true;
    });
    _categoryUnlockController.forward(from: 0);
  }

  void _requestAnswerFocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _answerFocusNode.requestFocus();
      }
    });
  }

  Future<void> _loadStoredStats() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_historyStorageKey);
    final mistakesJson = prefs.getString(_mistakesStorageKey);
    final storedScore = prefs.getInt(_scoreStorageKey) ?? 0;
    final storedStreak = prefs.getInt(_streakStorageKey) ?? 0;

    List<Map<String, dynamic>> loadedHistory = [];
    Map<String, int> loadedMistakes = {};

    if (historyJson != null && historyJson != '') {
      final decoded = jsonDecode(historyJson);
      if (decoded is List) {
        loadedHistory = decoded
            .whereType<Map>()
            .map((item) => item.map((k, v) => MapEntry(k.toString(), v)))
            .toList();
      }
    }

    if (mistakesJson != null && mistakesJson != '') {
      final decoded = jsonDecode(mistakesJson);
      if (decoded is Map) {
        loadedMistakes = decoded.map(
          (k, v) => MapEntry(k.toString(), (v as num).toInt()),
        );
      }
    }

    final subjectsJson = prefs.getString(_enabledSubjectsKey);
    final categoriesJson = prefs.getString(_enabledCategoriesKey);

    Set<int> loadedSubjects = _enabledSubjectIndices;
    Set<String> loadedCategories = _enabledCategoryLabels;

    if (subjectsJson != null && subjectsJson != '') {
      final decoded = jsonDecode(subjectsJson);
      if (decoded is List) {
        loadedSubjects = decoded.map((v) => (v as num).toInt()).toSet();
      }
    }
    if (categoriesJson != null && categoriesJson != '') {
      final decoded = jsonDecode(categoriesJson);
      if (decoded is List) {
        final migration = widget.config.legacyCategoryLabelMigration;
        loadedCategories = decoded
            .map((v) => v.toString())
            .map((label) => migration[label] ?? label)
            .toSet();
      }
    }

    final storedBestLap = prefs.getInt(_bestStreakLapKey) ?? 0;
    final storedBestStreakAbsolute =
        prefs.getInt(_bestStreakAbsoluteKey) ?? storedStreak;
    if (!mounted) return;
    setState(() {
      _score = storedScore;
      _streakAbsolute = storedStreak;
      _bestStreakLap = storedBestLap;
      _bestStreakAbsolute = storedBestStreakAbsolute;
      _answerHistory = loadedHistory;
      _mistakesByCase = loadedMistakes;
      if (loadedSubjects.isEmpty == false) {
        _enabledSubjectIndices = loadedSubjects;
      }
      if (loadedCategories.isEmpty == false) {
        _enabledCategoryLabels = loadedCategories;
      }
    });
  }

  Future<void> _saveStoredStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_scoreStorageKey, _score);
    await prefs.setInt(_streakStorageKey, _streakAbsolute);
    await prefs.setInt(_bestStreakLapKey, _bestStreakLap);
    await prefs.setInt(_bestStreakAbsoluteKey, _bestStreakAbsolute);
    await prefs.setString(_historyStorageKey, jsonEncode(_answerHistory));
    await prefs.setString(_mistakesStorageKey, jsonEncode(_mistakesByCase));
    await prefs.setString(
      _enabledSubjectsKey,
      jsonEncode(_enabledSubjectIndices.toList()),
    );
    await prefs.setString(
      _enabledCategoriesKey,
      jsonEncode(_enabledCategoryLabels.toList()),
    );
  }

  /// Picks the next item from [pool] using a shuffle bag stored in [bag]:
  /// items are drawn in random order without repeats until every item in
  /// [pool] has been drawn once, then the bag is reshuffled. A small chance
  /// of a pure uniform pick (ignoring the bag) keeps selection from feeling
  /// too mechanical — this is what lets the same item occasionally come up
  /// twice in a row, just much less often than with plain `Random.nextInt`.
  ///
  /// [bag] should be a dedicated, persistent list per pool (e.g. one for
  /// subjects, one for categories) so it can be drained across calls.
  T _drawFromShuffleBag<T>(
    List<T> bag,
    List<T> pool, {
    T? avoidRepeat,
    double randomChance = 0.12,
  }) {
    if (pool.length == 1) return pool.first;

    if (_random.nextDouble() < randomChance) {
      return pool[_random.nextInt(pool.length)];
    }

    bag.removeWhere((item) => !pool.contains(item));
    if (bag.isEmpty) {
      bag.addAll(pool);
      bag.shuffle(_random);
      if (avoidRepeat != null && bag.length > 1 && bag.first == avoidRepeat) {
        final swapIndex = 1 + _random.nextInt(bag.length - 1);
        final first = bag[0];
        bag[0] = bag[swapIndex];
        bag[swapIndex] = first;
      }
    }
    return bag.removeAt(0);
  }

  void _nextQuestion() {
    _showSentenceHint = false;
    _attemptedSentences.clear();
    _showingFirstLetterHint = false;
    final enabledSubjects = widget.config.subjectCategories == null
        ? _enabledSubjectIndices.toList()
        : _enabledSubjectIndices
              .where(
                (i) => NounSettings.instance.isEnabled(
                  widget.config.subjects[i],
                ),
              )
              .toList();
    if (enabledSubjects.isNotEmpty) {
      _currentSubjectIndex = _drawFromShuffleBag(
        _subjectBag,
        enabledSubjects,
        avoidRepeat: _currentSubjectIndex,
      );
    }

    final enabledCategories = widget.config.categories
        .where((c) => _enabledCategoryLabels.contains(c.label))
        .toList();
    if (enabledCategories.isEmpty) return;

    final previousCategory = widget.config.categories[_currentCategoryIndex];

    // Group weighting restricted to groups that have at least one enabled category.
    final availableGroups = enabledCategories.map((c) => c.group).toSet();
    final weights = Map<String, double>.fromEntries(
      widget.config.groupWeights.entries.where(
        (e) => availableGroups.contains(e.key),
      ),
    );

    // Expand each group into copies proportional to its weight, so the
    // shuffle bag still respects the configured group weighting.
    final groupPool = <String>[
      for (final entry in weights.entries)
        for (var i = 0; i < max(1, (entry.value * 12).round()); i++)
          entry.key,
    ];
    final selectedGroup = groupPool.isEmpty
        ? enabledCategories.first.group
        : _drawFromShuffleBag(
            _groupBag,
            groupPool,
            avoidRepeat: previousCategory.group,
          );

    final categoriesInGroup = enabledCategories
        .where((c) => c.group == selectedGroup)
        .toList();
    final selectedCategory = _drawFromShuffleBag(
      _categoryBag,
      categoriesInGroup,
      avoidRepeat: previousCategory,
    );
    _currentCategoryIndex = widget.config.categories.indexOf(
      selectedCategory,
    );
    final nominative = widget.config.subjects[_currentSubjectIndex];
    final correctAnswer = selectedCategory.values[_currentSubjectIndex];
    _currentReferenceSentence = widget.config.pickSentence(
      caseLabel: selectedCategory.label,
      nominative: nominative,
      answer: correctAnswer,
      random: _random,
    );
    _currentReferenceExplanation = widget.config.buildExplanation(
      caseLabel: selectedCategory.label,
      nominative: nominative,
      answer: correctAnswer,
      sentence: _currentReferenceSentence,
    );
  }

  void _toggleSubject(int index) {
    setState(() {
      if (_enabledSubjectIndices.contains(index)) {
        if (_enabledSubjectIndices.length <= 1) return;
        _enabledSubjectIndices = Set.of(_enabledSubjectIndices)
          ..remove(index);
      } else {
        _enabledSubjectIndices = Set.of(_enabledSubjectIndices)..add(index);
      }
      _subjectBag.clear();
      _feedback = '';
      _feedbackHint = '';
      _lastAnswerCorrect = null;
      _answerController.clear();
      _nextQuestion();
    });
    _saveStoredStats();
  }

  void _toggleCategory(String label) {
    setState(() {
      if (_enabledCategoryLabels.contains(label)) {
        if (_enabledCategoryLabels.length <= 1) return;
        _enabledCategoryLabels = Set.of(_enabledCategoryLabels)
          ..remove(label);
      } else {
        _enabledCategoryLabels = Set.of(_enabledCategoryLabels)..add(label);
      }
      _groupBag.clear();
      _categoryBag.clear();
      _feedback = '';
      _feedbackHint = '';
      _lastAnswerCorrect = null;
      _answerController.clear();
      _nextQuestion();
    });
    _saveStoredStats();
  }

  /// Bulk-toggles a group of subjects (e.g. all nouns in a category or
  /// difficulty tier). If every subject in [indices] is currently enabled,
  /// disables them all (unless that would leave no subjects enabled);
  /// otherwise enables them all.
  void _toggleSubjectGroup(Iterable<int> indices) {
    final indexSet = indices.toSet();
    if (indexSet.isEmpty) return;
    final allEnabled = indexSet.every(_enabledSubjectIndices.contains);

    setState(() {
      if (allEnabled) {
        final remaining = Set.of(_enabledSubjectIndices)
          ..removeAll(indexSet);
        if (remaining.isEmpty) return;
        _enabledSubjectIndices = remaining;
      } else {
        _enabledSubjectIndices = Set.of(_enabledSubjectIndices)
          ..addAll(indexSet);
      }
      _subjectBag.clear();
      _feedback = '';
      _feedbackHint = '';
      _lastAnswerCorrect = null;
      _answerController.clear();
      _nextQuestion();
    });
    _saveStoredStats();
  }

  /// Indices of subjects tagged with [category] (a subject may belong to
  /// more than one category).
  Iterable<int> _subjectIndicesForCategory(String category) {
    final cats = widget.config.subjectCategories!;
    return [
      for (var i = 0; i < cats.length; i++)
        if (cats[i].contains(category)) i,
    ];
  }

  /// Indices of subjects tagged with [difficulty].
  Iterable<int> _subjectIndicesForDifficulty(NounDifficulty difficulty) {
    final diffs = widget.config.subjectDifficulties!;
    return [
      for (var i = 0; i < diffs.length; i++)
        if (diffs[i] == difficulty) i,
    ];
  }

  /// All category keys used by [widget.config.subjectCategories], in first-
  /// seen order, deduplicated.
  List<String> _orderedCategoryKeys() {
    final cats = widget.config.subjectCategories!;
    final seen = <String>{};
    final result = <String>[];
    for (final list in cats) {
      for (final c in list) {
        if (seen.add(c)) result.add(c);
      }
    }
    return result;
  }

  String _difficultyLabel(NounDifficulty d) => switch (d) {
    NounDifficulty.beginner => 'Beginner',
    NounDifficulty.intermediate => 'Intermediate',
    NounDifficulty.advanced => 'Advanced',
  };

  /// When true, the Help Memory and Analytics tables show one row per
  /// article gender (der/die/das) instead of one row per subject.
  bool get _useGenderReferenceRows =>
      widget.config.collapseReferenceTablesByGender &&
      widget.config.subjectGenders != null;

  static const List<String> _genderRowOrder = ['m', 'f', 'n'];

  static const Map<String, String> _genderArticles = {
    'm': 'der',
    'f': 'die',
    'n': 'das',
  };

  static const Map<String, String> _genderRowNames = {
    'm': 'masculine',
    'f': 'feminine',
    'n': 'neuter',
  };

  /// Common (non-absolute) rules of thumb for guessing a noun's gender from
  /// its ending or meaning, shown below the reference table for the Artikel
  /// quiz. Each entry is "pattern — example(s)".
  static const Map<String, List<String>> _genderRules = {
    'm': [
      '-er for people/professions and many tools — der Lehrer, der Bäcker, der Computer',
      '-or — der Motor, der Doktor, der Professor',
      '-ig, -ling, -ich — der König, der Frühling, der Teppich',
      '-ant, -ist, -ismus — der Praktikant, der Tourist, der Optimismus',
      'Seasons, months, days of the week — der Winter, der Mai, der Montag',
      'Weather phenomena — der Regen, der Schnee, der Wind, der Sturm',
      'Cardinal directions — der Norden, der Süden, der Osten, der Westen',
      'Most nouns formed from a verb stem + -en — der Wagen, der Garten',
    ],
    'f': [
      '-e — die Lampe, die Blume, die Tasche (many, but not all: der Junge, das Auge)',
      '-ung — die Zeitung, die Wohnung, die Übung',
      '-heit, -keit, -igkeit — die Freiheit, die Möglichkeit, die Süßigkeit',
      '-schaft — die Freundschaft, die Mannschaft, die Landschaft',
      '-ion, -tion — die Nation, die Information, die Diskussion',
      '-tät — die Universität, die Realität, die Qualität',
      '-ik — die Musik, die Politik, die Mathematik',
      '-ur — die Natur, die Kultur, die Temperatur',
      '-enz, -anz — die Differenz, die Distanz, die Toleranz',
      'Most numbers used as nouns — die Million, die Eins, die Hundert',
      'Many tree and flower names — die Eiche, die Tulpe, die Rose',
    ],
    'n': [
      '-chen, -lein (diminutives) — das Mädchen, das Fräulein, das Häuschen',
      '-um — das Museum, das Zentrum, das Datum',
      '-ment — das Dokument, das Experiment, das Element',
      'Infinitives used as nouns — das Essen, das Leben, das Lesen, das Schwimmen',
      'Most Ge- collective nouns — das Gebäude, das Geschenk, das Gepäck',
      'Young people and animals — das Kind, das Baby, das Fohlen',
      'Metals and chemical elements — das Gold, das Silber, das Eisen',
      'Letters, colors, and languages used as nouns — das A, das Blau, das Deutsch',
    ],
  };

  /// Index of the first subject with [gender], used to read a
  /// gender-independent value out of [QuizConfig.categories] (every subject
  /// of the same gender has the same value in each category).
  int _firstSubjectIndexForGender(String gender) =>
      widget.config.subjectGenders!.indexOf(gender);

  /// Builds one focused reference table for the Help Memory section, with
  /// [QuizConfig.subjectColumnLabel] as the fixed first column and
  /// [table]'s columns as the rest.
  Widget _buildHelpMemoryTable(BuildContext context, HelpMemoryTable table) {
    final colorScheme = Theme.of(context).colorScheme;
    final categoriesByLabel = {
      for (final c in widget.config.categories) c.label: c,
    };

    Widget cell(String text, {bool header = false}) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: header ? Colors.white : null,
            fontWeight: header ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      );
    }

    TableRow buildRow(int? subjectIndex) {
      final background = subjectIndex == null
          ? colorScheme.primary
          : (subjectIndex.isEven
                ? colorScheme.surface
                : colorScheme.surfaceContainerHighest.withValues(alpha: 0.35));
      return TableRow(
        decoration: BoxDecoration(color: background),
        children: [
          cell(
            subjectIndex == null
                ? widget.config.subjectColumnLabel
                : widget.config.subjectDisplays[subjectIndex],
            header: subjectIndex == null,
          ),
          for (final column in table.columns)
            cell(
              subjectIndex == null
                  ? (column.displayLabel ?? column.categoryLabel)
                  : categoriesByLabel[column.categoryLabel]!
                        .values[subjectIndex],
              header: subjectIndex == null,
            ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          table.title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Table(
          border: TableBorder.all(color: colorScheme.outlineVariant),
          columnWidths: const {0: FixedColumnWidth(110)},
          defaultColumnWidth: const FlexColumnWidth(),
          children: [
            buildRow(null),
            for (
              var index = 0;
              index < widget.config.subjectDisplays.length;
              index++
            )
              buildRow(index),
          ],
        ),
      ],
    );
  }

  /// Builds a small declension-ending reference table shown below the
  /// [HelpMemoryTable]s.
  Widget _buildEndingPatternTable(BuildContext context, EndingPatternTable table) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget cell(String text, {bool header = false}) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: header ? Colors.white : null,
            fontWeight: header ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          table.title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Table(
          border: TableBorder.all(color: colorScheme.outlineVariant),
          columnWidths: const {0: FixedColumnWidth(110)},
          defaultColumnWidth: const FlexColumnWidth(),
          children: [
            TableRow(
              decoration: BoxDecoration(color: colorScheme.primary),
              children: [
                cell(table.cornerLabel, header: true),
                for (final label in table.columnLabels)
                  cell(label, header: true),
              ],
            ),
            for (var index = 0; index < table.rowLabels.length; index++)
              TableRow(
                decoration: BoxDecoration(
                  color: index.isEven
                      ? colorScheme.surface
                      : colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.35,
                        ),
                ),
                children: [
                  cell(table.rowLabels[index]),
                  for (final value in table.rows[index]) cell(value),
                ],
              ),
          ],
        ),
        if (table.notes != null) ...[
          const SizedBox(height: 8),
          for (final note in table.notes!)
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 2),
              child: Text('• $note'),
            ),
        ],
      ],
    );
  }

  /// Builds a PDF of the Help Memory reference table (and, for the Artikel
  /// quiz, the gender rules below it) and saves/downloads it directly as a
  /// PDF file (no print dialog).
  Future<void> _exportHelpMemoryPdf() async {
    final baseFont = await PdfGoogleFonts.notoSansRegular();
    final boldFont = await PdfGoogleFonts.notoSansBold();
    final doc = pw.Document(
      theme: pw.ThemeData.withFont(base: baseFont, bold: boldFont),
    );

    if (widget.config.helpMemoryTables != null) {
      final categoriesByLabel = {
        for (final c in widget.config.categories) c.label: c,
      };
      const cellStyle = pw.TextStyle(fontSize: 10);
      const cellPadding = pw.EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 3,
      );
      final headerStyle = pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        fontSize: 10,
      );

      doc.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(24),
          build: (context) => [
            pw.Header(
              level: 0,
              text: '${widget.config.title} — Help Memory',
            ),
            for (final table in widget.config.helpMemoryTables!) ...[
              pw.Header(level: 1, text: table.title),
              pw.TableHelper.fromTextArray(
                headers: [
                  widget.config.subjectColumnLabel,
                  for (final column in table.columns)
                    column.displayLabel ?? column.categoryLabel,
                ],
                data: [
                  for (
                    var i = 0;
                    i < widget.config.subjectDisplays.length;
                    i++
                  )
                    [
                      widget.config.subjectDisplays[i],
                      for (final column in table.columns)
                        categoriesByLabel[column.categoryLabel]!.values[i],
                    ],
                ],
                headerStyle: headerStyle,
                cellStyle: cellStyle,
                cellAlignment: pw.Alignment.centerLeft,
                cellPadding: cellPadding,
              ),
              pw.SizedBox(height: 12),
            ],
            for (final table
                in widget.config.endingPatternTables ??
                    const <EndingPatternTable>[]) ...[
              pw.Header(level: 1, text: table.title),
              pw.TableHelper.fromTextArray(
                headers: [table.cornerLabel, ...table.columnLabels],
                data: [
                  for (var i = 0; i < table.rowLabels.length; i++)
                    [table.rowLabels[i], ...table.rows[i]],
                ],
                headerStyle: headerStyle,
                cellStyle: cellStyle,
                cellAlignment: pw.Alignment.centerLeft,
                cellPadding: cellPadding,
              ),
              if (table.notes != null) ...[
                pw.SizedBox(height: 4),
                for (final note in table.notes!)
                  pw.Bullet(
                    text: note,
                    style: const pw.TextStyle(fontSize: 9),
                  ),
              ],
              pw.SizedBox(height: 12),
            ],
          ],
        ),
      );
    } else {
      final showEnglish =
          widget.config.subjectEnglish != null &&
          NounSettings.instance.showEnglishFor(
            widget.config.storageKeyPrefix,
          );

      final genderRows = _useGenderReferenceRows ? _genderRowOrder : null;
      final rowCount =
          genderRows?.length ?? widget.config.subjectDisplays.length;

      final headers = [
        widget.config.subjectColumnLabel,
        ...widget.config.categories.map((c) => c.label),
      ];

      final rows = <List<String>>[];
      for (var index = 0; index < rowCount; index++) {
        if (genderRows != null) {
          final gender = genderRows[index];
          final subjectIndex = _firstSubjectIndexForGender(gender);
          rows.add([
            '${_genderArticles[gender]} (${_genderRowNames[gender]})',
            ...widget.config.categories.map((c) => c.values[subjectIndex]),
          ]);
        } else {
          var label = widget.config.subjectDisplays[index];
          if (showEnglish) {
            label = '$label (${widget.config.subjectEnglish![index]})';
          }
          rows.add([
            label,
            ...widget.config.categories.map((c) => c.values[index]),
          ]);
        }
      }

      final columnCount = headers.length;
      final cellFontSize = columnCount > 15
          ? 7.0
          : columnCount > 7
              ? 8.0
              : 10.0;
      final pageFormat = columnCount > 15
          ? PdfPageFormat.a3.landscape
          : columnCount > 5
              ? PdfPageFormat.a4.landscape
              : PdfPageFormat.a4;

      doc.addPage(
        pw.MultiPage(
          pageFormat: pageFormat,
          margin: const pw.EdgeInsets.all(24),
          build: (context) => [
            pw.Header(
              level: 0,
              text: '${widget.config.title} — Help Memory',
            ),
            pw.TableHelper.fromTextArray(
              headers: headers,
              data: rows,
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: cellFontSize,
              ),
              cellStyle: pw.TextStyle(fontSize: cellFontSize),
              cellAlignment: pw.Alignment.centerLeft,
              cellPadding: const pw.EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 3,
              ),
              columnWidths: {
                for (var i = 0; i < columnCount; i++)
                  i: const pw.FlexColumnWidth(1),
              },
            ),
            if (_useGenderReferenceRows) ...[
              pw.SizedBox(height: 16),
              pw.Header(level: 1, text: 'Gender rules of thumb'),
              for (final gender in _genderRowOrder) ...[
                pw.SizedBox(height: 6),
                pw.Text(
                  '${_genderArticles[gender]} (${_genderRowNames[gender]})',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                for (final rule in _genderRules[gender]!)
                  pw.Bullet(
                    text: rule,
                    style: const pw.TextStyle(fontSize: 10),
                  ),
              ],
            ],
          ],
        ),
      );
    }

    await Printing.sharePdf(
      bytes: await doc.save(),
      filename: '${widget.config.storageKeyPrefix}help_memory.pdf',
    );
  }

  /// Opens the global Word Library and, once the user returns, picks a new
  /// question if the currently displayed noun was disabled there.
  Future<void> _openWordLibrary() async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const WordLibraryPage()),
    );
    if (!mounted) return;
    final currentNoun = widget.config.subjects[_currentSubjectIndex];
    if (!NounSettings.instance.isEnabled(currentNoun)) {
      setState(_nextQuestion);
    }
  }

  Future<void> _resetProgress() async {
    setState(() {
      _score = 0;
      _streakAbsolute = 0;
      _bestStreakLap = 0;
      _bestStreakAbsolute = 0;
      _answerHistory = [];
      _mistakesByCase = {};
      _feedback = '';
      _feedbackHint = '';
      _lastAnswerCorrect = null;
      _lastAnswerInfo = null;
    });
    await _saveStoredStats();
  }

  String _buildMistakeReminder({
    required String caseLabel,
    required String correctAnswer,
    required String explanation,
  }) {
    final sections = explanation
        .split('\n\n')
        .map((part) => part.trim())
        .where((part) => part != '')
        .toList();

    String? pickBody(String prefix) {
      for (final section in sections) {
        if (section.startsWith(prefix)) {
          return section.substring(prefix.length).trim();
        }
      }
      return null;
    }

    final triggerHint = pickBody('Trigger:');
    if (triggerHint != null && triggerHint != '') {
      return 'Tip: $triggerHint';
    }

    final grammarHint = pickBody('Grammar:');
    if (grammarHint != null && grammarHint != '') {
      return 'Tip: $grammarHint';
    }

    return 'RemiTipnder: In $caseLabel, use "$correctAnswer" for this pronoun.';
  }

  String _buildSuccessReminder({
    required String caseLabel,
    required String correctAnswer,
    required String explanation,
  }) {
    final sections = explanation
        .split('\n\n')
        .map((part) => part.trim())
        .where((part) => part != '')
        .toList();

    String? pickBody(String prefix) {
      for (final section in sections) {
        if (section.startsWith(prefix)) {
          return section.substring(prefix.length).trim();
        }
      }
      return null;
    }

    final triggerHint = pickBody('Trigger:');
    if (triggerHint != null && triggerHint != '') {
      return 'Nice work: keep an eye on this trigger next time too - $triggerHint';
    }

    final grammarHint = pickBody('Grammar:');
    if (grammarHint != null && grammarHint != '') {
      return 'Nice work: $grammarHint';
    }

    return 'Nice work: "$correctAnswer" is the right $caseLabel form here.';
  }

  Future<void> _showResetConfirmationPanel() async {
    final colorScheme = Theme.of(context).colorScheme;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Reset Progress'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'This will reset your score and clear your history data.',
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This action is irreversible.',
                        style: TextStyle(
                          color: colorScheme.onErrorContainer,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _resetProgress();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Score and history reset.')));
      _requestAnswerFocus();
    }
  }

  void _submitAnswer() {
    if (_showingAnswerReveal) return;

    var userAnswerRaw = _answerController.text.trim();

    // Clear hint prefix display after submission
    if (_showingFirstLetterHint) {
      _showingFirstLetterHint = false;
    }

    final userAnswer = userAnswerRaw.toLowerCase();
    final caseLabel = widget.config.categories[_currentCategoryIndex].label;
    final nominative = widget.config.subjects[_currentSubjectIndex];
    final correctAnswer = widget
        .config
        .categories[_currentCategoryIndex]
        .values[_currentSubjectIndex];
    final acceptableAnswers =
        widget.config.acceptableAnswersForSentence
            ?.call(_currentReferenceSentence)
            .map((a) => a.toLowerCase())
            .toSet() ??
        {correctAnswer.toLowerCase()};
    final isCorrect = acceptableAnswers.contains(userAnswer);

    // If first-letter hint is enabled and this is first attempt and answer is wrong,
    // show hint and don't record submission
    final isFirstAttempt = !_attemptedSentences.contains(_currentReferenceSentence);
    if (NounSettings.instance.showFirstLetterHint && isFirstAttempt && !isCorrect) {
      _attemptedSentences.add(_currentReferenceSentence);
      // Show first letter animated, keep field editable
      _revealFirstLetterHint(correctAnswer);
      return; // Don't process submission, just show hint
    }
    final reminderHint = _buildMistakeReminder(
      caseLabel: caseLabel,
      correctAnswer: correctAnswer,
      explanation: _currentReferenceExplanation,
    );
    final successHint = _buildSuccessReminder(
      caseLabel: caseLabel,
      correctAnswer: correctAnswer,
      explanation: _currentReferenceExplanation,
    );
    var shouldCelebrate = false;
    var lapCompleted = false;
    var streakLapAtSubmit = 0;

    setState(() {
      _lastAnswerInfo = {
        'nominative': nominative,
        'caseLabel': caseLabel,
        'userAnswer': userAnswerRaw,
        'correctAnswer': correctAnswer,
        'isCorrect': isCorrect,
        'explanation': _currentReferenceExplanation,
      };

      if (isCorrect) {
        _streakAbsolute++;
        final multiplier = _streakLap + 1;
        lapCompleted = _streakAbsolute % _maxStreak == 0;
        if (_streakLap > _bestStreakLap) _bestStreakLap = _streakLap;
        if (_streakAbsolute > _bestStreakAbsolute) {
          _bestStreakAbsolute = _streakAbsolute;
        }
        final pointsEarned = multiplier;
        _score += pointsEarned;
        streakLapAtSubmit = _streakLap;
        shouldCelebrate = true;
        _feedbackHint = successHint;
        _lastAnswerCorrect = true;
        _feedback = widget.config.acceptableAnswersForSentence != null
            ? userAnswerRaw
            : correctAnswer;
      } else {
        if (_streakLap > _bestStreakLap) _bestStreakLap = _streakLap;
        _streakAbsolute = 0;
        _score -= 1;
        _feedbackHint = reminderHint;
        _lastAnswerCorrect = false;
        _feedback = correctAnswer;
        _mistakesByCase[caseLabel] = (_mistakesByCase[caseLabel] ?? 0) + 1;
      }

      _answerHistory.insert(0, {
        'time': DateTime.now().toIso8601String(),
        'nominative': nominative,
        'case': caseLabel,
        'answer': userAnswerRaw,
        'correctAnswer': correctAnswer,
        'correct': isCorrect,
      });
      if (_answerHistory.length > _maxStoredHistory) {
        _answerHistory = _answerHistory.take(_maxStoredHistory).toList();
      }

      if (isCorrect) {
        _answerController.clear();
        _nextQuestion();
      } else {
        _showingAnswerReveal = true;
        _answerController.clear();
      }
    });

    if (shouldCelebrate) {
      _triggerFireworks(
        streakAbsolute: _streakAbsolute,
        lapCompleted: lapCompleted,
        streakLap: streakLapAtSubmit,
      );
    }

    if (widget.config.progressionKey != null &&
        _streakAbsolute >= NounSettings.instance.progressionUnlockStreak &&
        !NounSettings.instance.isNounCategoryCompleted(
          widget.config.progressionKey!,
        )) {
      final progressionKey = widget.config.progressionKey!;
      NounSettings.instance.markNounCategoryCompleted(progressionKey);
      final index = nounProgressionEntries.indexWhere(
        (e) => e.key == progressionKey,
      );
      if (index >= 0 && index + 1 < nounProgressionEntries.length) {
        _triggerCategoryUnlockCelebration(
          nounProgressionEntries[index + 1].displayName,
        );
      }
    }

    _saveStoredStats();

    if (isCorrect) {
      _requestAnswerFocus();
    } else {
      _revealCorrectAnswer(correctAnswer);
    }
  }

  /// Shows just the first letter of [correctAnswer] typed out animated with a
  /// non-deletable red asterisk prefix, then keeps the field editable so the
  /// user can type the rest. Does not record any submission stats (no streak
  /// loss, no point change).
  Future<void> _revealFirstLetterHint(String correctAnswer) async {
    _answerController.clear();
    // Type out first letter (asterisk will show as red prefix)
    await Future.delayed(const Duration(milliseconds: 70));
    if (!mounted) return;
    setState(() {
      _showingFirstLetterHint = true;
      _answerController.text = correctAnswer[0];
    });
    // Wait a moment, then let user continue typing
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    _requestAnswerFocus();
  }

  /// After an incorrect answer, types out [correctAnswer] in the answer
  /// field one letter at a time, pauses for a duration set by
  /// [NounSettings.answerRevealMode], then advances to the next question.
  Future<void> _revealCorrectAnswer(String correctAnswer) async {
    _showingAnswerReveal = true;
    for (var i = 1; i <= correctAnswer.length; i++) {
      await Future.delayed(const Duration(milliseconds: 70));
      if (!mounted) return;
      setState(() {
        _answerController.text = correctAnswer.substring(0, i);
      });
    }

    final pause = switch (NounSettings.instance.answerRevealMode) {
      AnswerRevealMode.quick => const Duration(milliseconds: 500),
      AnswerRevealMode.normal => const Duration(milliseconds: 1500),
      AnswerRevealMode.slow => const Duration(milliseconds: 3000),
    };
    await Future.delayed(pause);
    if (!mounted) return;

    setState(() {
      _showingAnswerReveal = false;
      _answerController.clear();
      _nextQuestion();
    });
  }

  void _newQuestion() {
    setState(() {
      _answerController.clear();
      _nextQuestion();
    });
    _requestAnswerFocus();
  }

  Map<String, int> _statsForCaseCell(String nominative, String caseLabel) {
    int total = 0;
    int correct = 0;
    for (final entry in _answerHistory) {
      if (entry['nominative'] == nominative && entry['case'] == caseLabel) {
        total += 1;
        if (entry['correct'] == true) {
          correct += 1;
        }
      }
    }
    return {'correct': correct, 'total': total};
  }

  Map<String, int> _statsForNominative(String nominative) {
    int total = 0;
    int correct = 0;
    for (final entry in _answerHistory) {
      if (entry['nominative'] == nominative) {
        total += 1;
        if (entry['correct'] == true) {
          correct += 1;
        }
      }
    }
    return {'correct': correct, 'total': total};
  }

  /// Aggregates [_statsForNominative] across every subject with [gender]
  /// ('m'/'f'/'n'). Used when [QuizConfig.collapseReferenceTablesByGender]
  /// is set, so the Analytics table shows one row per article gender.
  Map<String, int> _statsForGender(String gender) {
    int total = 0;
    int correct = 0;
    final genders = widget.config.subjectGenders!;
    for (var i = 0; i < genders.length; i++) {
      if (genders[i] != gender) continue;
      final stats = _statsForNominative(widget.config.subjects[i]);
      correct += stats['correct']!;
      total += stats['total']!;
    }
    return {'correct': correct, 'total': total};
  }

  /// Aggregates [_statsForCaseCell] across every subject with [gender]
  /// ('m'/'f'/'n') for [caseLabel]. Used when
  /// [QuizConfig.collapseReferenceTablesByGender] is set, so the Analytics
  /// table shows one row per article gender.
  Map<String, int> _statsForGenderCase(String gender, String caseLabel) {
    int total = 0;
    int correct = 0;
    final genders = widget.config.subjectGenders!;
    for (var i = 0; i < genders.length; i++) {
      if (genders[i] != gender) continue;
      final stats = _statsForCaseCell(widget.config.subjects[i], caseLabel);
      correct += stats['correct']!;
      total += stats['total']!;
    }
    return {'correct': correct, 'total': total};
  }

  Color _analyticsHeatColor(int correct, int total, ColorScheme colorScheme) {
    if (total == 0) {
      return colorScheme.surface;
    }

    final ratio = correct / total;
    final low = Colors.red.shade300;
    final mid = Colors.yellow.shade300;
    final high = Colors.green.shade300;

    final gradientColor = ratio <= 0.5
        ? Color.lerp(low, mid, ratio / 0.5)!
        : Color.lerp(mid, high, (ratio - 0.5) / 0.5)!;

    return Color.lerp(colorScheme.surface, gradientColor, 0.7)!;
  }

  Widget _buildLegendChip(Color color, String label) {
    return Chip(
      avatar: CircleAvatar(backgroundColor: color, radius: 7),
      label: Text(label),
    );
  }

  static final RegExp _wordPattern = RegExp(r'[A-Za-zÄÖÜäöüßẞ]+');

  /// Splits [text] into spans, one per recognized noun (from
  /// [germanNouns]/[nounSurfaceForms]) plus the text between them. Tapping a
  /// recognized noun shows its article and English translation. When "Color
  /// nouns by article" is on, recognized nouns are also colored by gender.
  List<InlineSpan> _highlightNounSpans(String text, TextStyle? baseStyle) {
    final matches = _wordPattern.allMatches(text).toList();
    if (matches.isEmpty) {
      return [TextSpan(text: text, style: baseStyle)];
    }

    final spans = <InlineSpan>[];
    var start = 0;
    for (final match in matches) {
      if (match.start > start) {
        spans.add(
          TextSpan(text: text.substring(start, match.start), style: baseStyle),
        );
      }

      final word = match.group(0)!;
      final info = lookupNoun(word);
      if (info == null) {
        spans.add(TextSpan(text: word, style: baseStyle));
      } else {
        final style = NounSettings.instance.colorNouns
            ? (baseStyle ?? const TextStyle()).copyWith(
                color: NounSettings.instance.colorForGender(info.noun.gender),
                fontWeight: FontWeight.w800,
              )
            : baseStyle;
        spans.add(
          TextSpan(
            text: word,
            style: style,
            recognizer: TapGestureRecognizer()
              ..onTap = () => _showNounInfoDialog(info),
          ),
        );
      }

      start = match.end;
    }
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start), style: baseStyle));
    }
    return spans;
  }

  /// Renders the AppBar title, replacing a trailing "Quiz" word with the
  /// QUIZ wordmark logo to match the drawer header's branding.
  Widget _appBarTitle(String title) {
    const suffix = 'Quiz';
    final label = title.endsWith(suffix)
        ? title.substring(0, title.length - suffix.length)
        : '$title ';
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SvgPicture.asset('assets/icons/QuizLogo-01.svg', height: 43),
        ),
      ],
    );
  }

  /// Pill-shaped title used by the info dialogs (noun info, sentence info)
  /// for a consistent look across both.
  Widget _infoDialogTitle(BuildContext context, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(kRadiusSmall),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  void _showNounInfoDialog(NounInfo info) {
    final pluralEnding = pluralEndingNotation(info.noun.noun);
    final headline = pluralEnding != null
        ? '${info.article} ${info.noun.noun} $pluralEnding'
        : '${info.article} ${info.noun.noun}';
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: _infoDialogTitle(dialogContext, 'Noun'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              headline,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: NounSettings.instance.colorForGender(info.noun.gender),
              ),
            ),
            const SizedBox(height: 4),
            Text('Translation: ${info.noun.english}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Shows the "Last Answer" dialog with full details about the most
  /// recently submitted answer: the exercise, the user's answer, whether it
  /// was correct, and the correct answer. No-op if nothing has been answered
  /// yet.
  void _showLastAnswerInfoDialog(BuildContext context) {
    final info = _lastAnswerInfo;
    if (info == null) return;
    final isCorrect = info['isCorrect'] == true;
    final userAnswer = info['userAnswer'] as String;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: _infoDialogTitle(dialogContext, 'Last Answer'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${info['nominative']} → ${info['caseLabel']}'),
              const SizedBox(height: 8),
              Text(
                'Your answer: ${userAnswer.isEmpty ? '(none)' : userAnswer}',
              ),
              const SizedBox(height: 4),
              Text('Correct answer: ${info['correctAnswer']}'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isCorrect
                      ? kSectionAccentColors[2]
                      : Theme.of(dialogContext).colorScheme.error,
                  borderRadius: BorderRadius.circular(kRadiusSmall),
                ),
                child: Text(
                  isCorrect ? 'Correct' : 'Incorrect',
                  style: Theme.of(dialogContext).textTheme.titleMedium
                      ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 12),
              SelectableText.rich(
                TextSpan(
                  children: _buildExplanationSpans(
                    dialogContext,
                    info['explanation'] as String,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Shows the "Sentence Info" dialog with the current question's grammar
  /// explanation. Opened via the info button next to the answer field, or
  /// the Ctrl+I keyboard shortcut.
  void _showSentenceInfoDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: _infoDialogTitle(dialogContext, 'Sentence Info'),
          content: SingleChildScrollView(
            child: SelectableText.rich(
              TextSpan(
                children: _buildExplanationSpans(
                  dialogContext,
                  _currentReferenceExplanation,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  List<InlineSpan> _buildExplanationSpans(
    BuildContext context,
    String explanation,
  ) {
    final rawBaseStyle = Theme.of(context).textTheme.bodyMedium;
    final baseStyle = rawBaseStyle?.copyWith(
      fontSize: (rawBaseStyle.fontSize ?? 14) * 1.4,
    );
    final spans = <InlineSpan>[];
    final sections = explanation
        .split('\n\n')
        .map((part) => part.trim())
        .where((part) => part != '')
        .toList();

    for (var i = 0; i < sections.length; i++) {
      final section = sections[i];
      final separator = section.indexOf(':');

      if (separator > 0) {
        final label = section.substring(0, separator + 1);
        final body = section.substring(separator + 1).trimLeft();
        final emphasizeBody =
            label.startsWith('Sentence meaning') ||
            label.startsWith('Missing form');

        spans.add(
          TextSpan(
            text: label,
            style: baseStyle?.copyWith(fontWeight: FontWeight.w700),
          ),
        );
        final bodyStyle = baseStyle?.copyWith(
          fontStyle: emphasizeBody ? FontStyle.italic : FontStyle.normal,
          height: 1.35,
        );
        spans.add(const TextSpan(text: ' '));
        spans.addAll(_highlightNounSpans(body, bodyStyle));
      } else {
        spans.addAll(_highlightNounSpans(section, baseStyle));
      }

      if (i < sections.length - 1) {
        spans.add(const TextSpan(text: '\n\n'));
      }
    }

    return spans;
  }

  Widget _buildStreakTracker(ColorScheme colorScheme) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: _streakAbsolute + 0.0),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, child) {
        final currentLap = (animatedValue / _maxStreak).floor();
        final posInLap = animatedValue - currentLap * _maxStreak;
        final lapColor = _rainbowColors[currentLap % _rainbowColors.length];
        final prevLapColor = currentLap > 0
            ? _rainbowColors[(currentLap - 1) % _rainbowColors.length]
            : colorScheme.surfaceContainerHighest;
        final hasHistory = currentLap > 0;
        final normalizedProgress = ((posInLap - 1) / (_maxStreak - 1)).clamp(
          0.0,
          1.0,
        );
        return SizedBox(
          height: 40,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final sideInset = constraints.maxWidth / (_maxStreak * 2);
              return Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: sideInset,
                    right: sideInset,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        // Base track (grey)
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: colorScheme.surfaceContainerHighest,
                          ),
                        ),
                        // Previous lap: full bar in old color
                        if (hasHistory)
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: prevLapColor,
                            ),
                          ),
                        // New lap color filling from left
                        FractionallySizedBox(
                          widthFactor: normalizedProgress,
                          child: Container(
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: lapColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: List.generate(_maxStreak, (ballIndex) {
                      final fillProgress = (posInLap - ballIndex).clamp(
                        0.0,
                        1.0,
                      );
                      final isLastBall = ballIndex == _maxStreak - 1;
                      // Balls retain previous lap color as base
                      final baseBallColor = hasHistory
                          ? prevLapColor
                          : colorScheme.surfaceContainerHighest;
                      final ballColor = Color.lerp(
                        baseBallColor,
                        lapColor,
                        fillProgress,
                      );

                      return Expanded(
                        child: Center(
                          child: AnimatedScale(
                            duration: const Duration(milliseconds: 260),
                            scale: fillProgress > 0.95 && isLastBall
                                ? 1.15
                                : 1.0,
                            child: Container(
                              width: 29,
                              height: 29,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ballColor,
                                boxShadow: fillProgress > 0.98
                                    ? [
                                        BoxShadow(
                                          color: lapColor.withValues(
                                            alpha: 0.4,
                                          ),
                                          blurRadius: isLastBall ? 16 : 8,
                                          spreadRadius: isLastBall ? 2 : 0,
                                        ),
                                      ]
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _sectionWithMaxWidth(Widget child) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final quizTextTheme = Theme.of(context).textTheme;
    const quizFontScale = 1.2;
    final scaledQuizTextTheme = quizTextTheme.apply(
      fontSizeFactor: quizFontScale,
    );
    final isCompact = MediaQuery.sizeOf(context).width < 600;
    final currentCase = widget.config.categories[_currentCategoryIndex].label;
    final currentPronoun =
        widget.config.subjectDisplays[_currentSubjectIndex];
    final currentEnglish =
        widget.config.subjectEnglish != null &&
            NounSettings.instance.showEnglishFor(widget.config.storageKeyPrefix)
        ? widget.config.subjectEnglish![_currentSubjectIndex]
        : null;
    final currentGenderColor =
        widget.config.subjectGenders != null &&
            NounSettings.instance.colorNouns
        ? NounSettings.instance.colorForGender(
            widget.config.subjectGenders![_currentSubjectIndex],
          )
        : null;
    final blankMatch = RegExp(r'_{4,}').firstMatch(_currentReferenceSentence);
    final referenceBefore = blankMatch != null
        ? _currentReferenceSentence.substring(0, blankMatch.start)
        : _currentReferenceSentence;
    final referenceAfter = blankMatch != null
        ? _currentReferenceSentence.substring(blankMatch.end)
        : '';
    final recentHistory = _answerHistory.take(5).toList();
    final topMistakes = _mistakesByCase.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final baseSentenceStyle = scaledQuizTextTheme.titleMedium;
    final sentenceStyle = baseSentenceStyle?.copyWith(
      fontWeight: FontWeight.w600,
      color: colorScheme.onSurface,
      fontSize: (baseSentenceStyle.fontSize ?? 16) * 1.3,
    );

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: _appBarTitle(widget.config.title),
        ),
        actions: [
          IconButton(
            tooltip: 'Reset score and history',
            onPressed: _showResetConfirmationPanel,
            icon: const Icon(Icons.restart_alt_rounded),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHigh,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.outline.withValues(alpha: 0.4),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: AppDrawer(
        currentPage: widget.config.currentPage,
        currentNounProgressionKey: widget.config.progressionKey,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 8),
            _sectionWithMaxWidth(
              Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(kRadiusLarge),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.outline,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Card(
                        margin: EdgeInsets.zero,
                        color: colorScheme.surfaceContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kRadiusLarge),
                          side: BorderSide(color: Colors.grey.shade400),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: _buildStreakTracker(colorScheme),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: isCompact
                                            ? const EdgeInsets.fromLTRB(
                                                8,
                                                6,
                                                10,
                                                6,
                                              )
                                            : const EdgeInsets.fromLTRB(
                                                10,
                                                8,
                                                12,
                                                8,
                                              ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            isCompact ? 12 : 14,
                                          ),
                                          color: _streakLap > 0
                                              ? _rainbowColors[_streakLap %
                                                        _rainbowColors.length]
                                                    .withValues(alpha: 0.18)
                                              : colorScheme.primaryContainer,
                                          border: Border.all(
                                            color: _streakLap > 0
                                                ? _rainbowColors[_streakLap %
                                                      _rainbowColors.length]
                                                : colorScheme.primary
                                                      .withValues(alpha: 0.45),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  (_streakLap > 0
                                                          ? _rainbowColors[_streakLap %
                                                                _rainbowColors
                                                                    .length]
                                                          : colorScheme.primary)
                                                      .withValues(alpha: 0.18),
                                              blurRadius: 12,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: isCompact ? 22 : 26,
                                              height: isCompact ? 22 : 26,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: _streakLap > 0
                                                    ? _rainbowColors[_streakLap %
                                                          _rainbowColors.length]
                                                    : colorScheme.primary,
                                              ),
                                              alignment: Alignment.center,
                                              child: Icon(
                                                _streakLap > 0
                                                    ? Icons.bolt
                                                    : Icons.star_rounded,
                                                size: isCompact ? 13 : 15,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(width: isCompact ? 6 : 8),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  '$_score',
                                                  style:
                                                      (isCompact
                                                              ? quizTextTheme
                                                                    .titleSmall
                                                              : scaledQuizTextTheme
                                                                    .titleMedium)
                                                          ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            color: colorScheme
                                                                .onSurface,
                                                          ),
                                                ),
                                                if (_streakLap > 0)
                                                  Text(
                                                    '×$_streakLap',
                                                    style:
                                                        (isCompact
                                                                ? quizTextTheme
                                                                      .labelSmall
                                                                : scaledQuizTextTheme
                                                                      .labelSmall)
                                                            ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              color:
                                                                  _rainbowColors[_streakLap %
                                                                      _rainbowColors
                                                                          .length],
                                                            ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (_bestStreakLap > 0) ...[
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            color: colorScheme
                                                .surfaceContainerHighest
                                                .withValues(alpha: 0.7),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.emoji_events_rounded,
                                                size: isCompact ? 12 : 14,
                                                color: Colors.amber.shade700,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Best ×$_bestStreakLap',
                                                style:
                                                    (isCompact
                                                            ? quizTextTheme
                                                                  .labelSmall
                                                            : scaledQuizTextTheme
                                                                  .labelSmall)
                                                        ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: colorScheme
                                                          .onSurfaceVariant,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: colorScheme.outlineVariant,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          widget.config.promptLabel,
                                          style: scaledQuizTextTheme.labelLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.w300,
                                                fontSize:
                                                    (scaledQuizTextTheme
                                                            .labelLarge
                                                            ?.fontSize ??
                                                        14) *
                                                    0.8,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Text.rich(
                                      TextSpan(
                                        text: currentPronoun,
                                        style: scaledQuizTextTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              fontSize:
                                                  (scaledQuizTextTheme
                                                          .headlineSmall
                                                          ?.fontSize ??
                                                      24) *
                                                  0.8,
                                              color: currentGenderColor,
                                            ),
                                        children: currentEnglish == null
                                            ? null
                                            : [
                                                TextSpan(
                                                  text: ' ($currentEnglish)',
                                                  style: scaledQuizTextTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: colorScheme
                                                            .onSurfaceVariant,
                                                      ),
                                                ),
                                              ],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Case',
                                      style: scaledQuizTextTheme.labelLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w300,
                                            fontSize:
                                                (scaledQuizTextTheme
                                                        .labelLarge
                                                        ?.fontSize ??
                                                    14) *
                                                0.8,
                                          ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      currentCase,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: scaledQuizTextTheme.headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                (scaledQuizTextTheme
                                                        .headlineSmall
                                                        ?.fontSize ??
                                                    24) *
                                                0.8,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: colorScheme.outlineVariant,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Quiz',
                                      style: scaledQuizTextTheme.labelLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w300,
                                            fontSize:
                                                (scaledQuizTextTheme
                                                        .labelLarge
                                                        ?.fontSize ??
                                                    14) *
                                                0.8,
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    LayoutBuilder(
                                      builder: (context, constraints) {
                                        final inputWidth = min(
                                          130.0,
                                          constraints.maxWidth * 0.4,
                                        );
                                        return RichText(
                                          text: TextSpan(
                                            style: sentenceStyle,
                                            children: [
                                              ..._highlightNounSpans(
                                                referenceBefore,
                                                sentenceStyle,
                                              ),
                                              WidgetSpan(
                                                alignment:
                                                    PlaceholderAlignment.middle,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                      ),
                                                  child: SizedBox(
                                                    width: inputWidth,
                                                    child: CallbackShortcuts(
                                                      bindings: {
                                                        const SingleActivator(
                                                              LogicalKeyboardKey
                                                                  .keyI,
                                                              control: true,
                                                            ):
                                                            () =>
                                                                _showSentenceInfoDialog(
                                                                  context,
                                                                ),
                                                      },
                                                      child: TextField(
                                                        controller:
                                                            _answerController,
                                                        focusNode:
                                                            _answerFocusNode,
                                                        autofocus: true,
                                                        textInputAction:
                                                            TextInputAction
                                                                .done,
                                                        style: sentenceStyle,
                                                        readOnly:
                                                            _showingAnswerReveal,
                                                        showCursor:
                                                            !_showingAnswerReveal,
                                                        minLines: 1,
                                                        maxLines: 1,
                                                        decoration: InputDecoration(
                                                          isDense: true,
                                                          contentPadding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 10,
                                                                vertical: 10,
                                                              ),
                                                          border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  12,
                                                                ),
                                                          ),
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                          prefixText:
                                                              (_showingAnswerReveal || _showingFirstLetterHint)
                                                              ? '*'
                                                              : null,
                                                          prefixStyle: sentenceStyle
                                                              ?.copyWith(
                                                                color: Colors
                                                                    .red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                        onChanged: (value) {
                                                          // Prevent deletion of first letter during hint mode
                                                          if (_showingFirstLetterHint && value.isEmpty) {
                                                            _answerController.text = _answerController.text;
                                                          }
                                                        },
                                                        onSubmitted: (_) =>
                                                            _submitAnswer(),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              if (referenceAfter != '')
                                                ..._highlightNounSpans(
                                                  referenceAfter,
                                                  sentenceStyle,
                                                ),
                                              WidgetSpan(
                                                alignment:
                                                    PlaceholderAlignment.middle,
                                                child: IconButton(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 4,
                                                      ),
                                                  constraints:
                                                      const BoxConstraints(
                                                        minWidth: 28,
                                                        minHeight: 28,
                                                      ),
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                  tooltip:
                                                      'Grammar info (Ctrl+I)',
                                                  onPressed: () =>
                                                      _showSentenceInfoDialog(
                                                        context,
                                                      ),
                                                  icon: const Icon(
                                                    Icons.info_outline_rounded,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                    if (widget.config.sentenceHint != null) ...[
                                      const SizedBox(height: 8),
                                      InkWell(
                                        borderRadius: BorderRadius.circular(8),
                                        onTap: () => setState(
                                          () => _showSentenceHint =
                                              !_showSentenceHint,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              _showSentenceHint
                                                  ? Icons
                                                        .visibility_off_rounded
                                                  : Icons.visibility_rounded,
                                              size: 18,
                                              color:
                                                  colorScheme.onSurfaceVariant,
                                            ),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                _showSentenceHint
                                                    ? (widget
                                                              .config
                                                              .sentenceHint!(
                                                                _currentReferenceSentence,
                                                              ) ??
                                                          '')
                                                    : 'Hinweis anzeigen',
                                                style: quizTextTheme.bodySmall
                                                    ?.copyWith(
                                                      color: colorScheme
                                                          .onSurfaceVariant,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: FilledButton.icon(
                                      onPressed: _showingAnswerReveal
                                          ? null
                                          : _submitAnswer,
                                      icon: const Icon(Icons.check_rounded),
                                      label: Text(
                                        'Check',
                                        style: scaledQuizTextTheme.labelLarge
                                            ?.copyWith(
                                              color: colorScheme.onPrimary,
                                            ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  OutlinedButton.icon(
                                    onPressed: _showingAnswerReveal
                                        ? null
                                        : _newQuestion,
                                    icon: const Icon(Icons.skip_next_rounded),
                                    label: Text(
                                      'Next',
                                      style: scaledQuizTextTheme.labelLarge,
                                    ),
                                  ),
                                ],
                              ),
                              if (_feedback != '') ...[
                                const SizedBox(height: 16),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey.shade400,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      kRadiusLarge,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _lastAnswerCorrect == true
                                                  ? kSectionAccentColors[2]
                                                  : colorScheme.error,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    kRadiusSmall,
                                                  ),
                                            ),
                                            child: Text(
                                              _lastAnswerCorrect == true
                                                  ? 'Correct'
                                                  : 'Incorrect',
                                              style: scaledQuizTextTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text.rich(
                                              TextSpan(
                                                children: _highlightNounSpans(
                                                  _feedback,
                                                  Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        color: colorScheme
                                                            .onSurface,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            tooltip: 'Last answer details',
                                            onPressed: () =>
                                                _showLastAnswerInfoDialog(
                                                  context,
                                                ),
                                            icon: const Icon(
                                              Icons.info_outline_rounded,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (_feedbackHint != '') ...[
                                        const SizedBox(height: 8),
                                        Text.rich(
                                          TextSpan(
                                            children: _buildExplanationSpans(
                                              context,
                                              _feedbackHint,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        ),
                      ),
                    ],
                  ),
                  if (_showFireworks)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: AnimatedBuilder(
                          animation: _fireworksController,
                          builder: (context, _) {
                            return CustomPaint(
                              painter: FireworksPainter(
                                progress: _fireworksController.value,
                                particles: _fireworkParticles,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  if (_showCategoryUnlockCelebration)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Stack(
                          children: [
                            AnimatedBuilder(
                              animation: _categoryUnlockController,
                              builder: (context, _) {
                                return CustomPaint(
                                  painter: FireworksPainter(
                                    progress: _categoryUnlockController.value,
                                    particles: _categoryUnlockParticles,
                                  ),
                                );
                              },
                            ),
                            Center(
                              child: AnimatedBuilder(
                                animation: _categoryUnlockController,
                                builder: (context, child) {
                                  final t = _categoryUnlockController.value;
                                  final opacity = t < 0.12
                                      ? (t / 0.12)
                                      : t > 0.8
                                      ? ((1 - t) / 0.2)
                                      : 1.0;
                                  return Opacity(
                                    opacity: opacity.clamp(0.0, 1.0),
                                    child: child,
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(
                                      alpha: 0.6,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      kRadiusLarge,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Noun Category Unlocked!',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        _unlockedCategoryName,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color: Colors.amber,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _sectionWithMaxWidth(
              Card(
                clipBehavior: Clip.antiAlias,
                child: ExpansionTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Help Memory',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Save as PDF',
                        icon: const Icon(Icons.picture_as_pdf_rounded),
                        onPressed: _exportHelpMemoryPdf,
                      ),
                    ],
                  ),
                  subtitle: Text(
                    widget.config.helpMemorySubtitle ??
                        (widget.config.helpMemoryTables != null
                            ? 'Reference tables for pronouns, possessives, '
                                  'and endings.'
                            : 'Expanded reference table with all cases.'),
                  ),
                  leading: IconBadge(
                    icon: Icons.menu_book_rounded,
                    color: kSectionAccentColors[0],
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: widget.config.helpMemoryTables != null
                      ? [
                          for (final table in widget.config.helpMemoryTables!) ...[
                            _buildHelpMemoryTable(context, table),
                            const SizedBox(height: 16),
                          ],
                          for (final table
                              in widget.config.endingPatternTables ??
                                  const <EndingPatternTable>[]) ...[
                            _buildEndingPatternTable(context, table),
                            const SizedBox(height: 16),
                          ],
                        ]
                      : [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final showEnglish =
                            widget.config.subjectEnglish != null &&
                            NounSettings.instance.showEnglishFor(widget.config.storageKeyPrefix);
                        final showSubtitleRow =
                            showEnglish || _useGenderReferenceRows;
                        final fixedColumnWidth = showSubtitleRow
                            ? 170.0
                            : 120.0;
                        const valueColumnWidth = 110.0;
                        final rowHeight = showSubtitleRow ? 58.0 : 48.0;
                        final scrollableWidth =
                            valueColumnWidth * widget.config.categories.length;

                        Widget buildFixedCell(
                          String text, {
                          bool header = false,
                          Color? background,
                          Color? textColor,
                          String? subtitle,
                        }) {
                          return Container(
                            width: fixedColumnWidth,
                            height: rowHeight,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color:
                                  background ??
                                  (header
                                      ? colorScheme.primary
                                      : colorScheme.surface),
                              border: Border(
                                right: BorderSide(
                                  color: header
                                      ? colorScheme.primary
                                      : colorScheme.outlineVariant,
                                ),
                                bottom: BorderSide(
                                  color: colorScheme.outlineVariant,
                                ),
                              ),
                            ),
                            child: subtitle == null
                                ? Text(
                                    text,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: header
                                          ? Colors.white
                                          : textColor,
                                      fontWeight: header
                                          ? FontWeight.w700
                                          : FontWeight.w600,
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        text,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: header
                                              ? Colors.white
                                              : textColor,
                                          fontWeight: header
                                              ? FontWeight.w700
                                              : FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        subtitle,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: colorScheme.onSurfaceVariant,
                                          fontSize: 11,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                          );
                        }

                        Widget buildScrollableRow(
                          List<String> values, {
                          bool header = false,
                          Color? background,
                        }) {
                          return SizedBox(
                            width: scrollableWidth,
                            height: rowHeight,
                            child: Row(
                              children: values.map((value) {
                                return Container(
                                  width: valueColumnWidth,
                                  height: rowHeight,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        background ??
                                        (header
                                            ? colorScheme.primary
                                            : colorScheme.surface),
                                    border: Border(
                                      right: BorderSide(
                                        color: header
                                            ? colorScheme.primary
                                            : colorScheme.outlineVariant,
                                      ),
                                      bottom: BorderSide(
                                        color: colorScheme.outlineVariant,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    value,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: header ? Colors.white : null,
                                      fontWeight: header
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        }

                        final genderRows = _useGenderReferenceRows
                            ? _genderRowOrder
                            : null;
                        final rowCount =
                            genderRows?.length ??
                            widget.config.subjectDisplays.length;

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                buildFixedCell(
                                  widget.config.subjectColumnLabel,
                                  header: true,
                                ),
                                for (int index = 0; index < rowCount; index++)
                                  if (genderRows != null)
                                    buildFixedCell(
                                      _genderArticles[genderRows[index]]!,
                                      background: index.isEven
                                          ? colorScheme.surface
                                          : colorScheme
                                                .surfaceContainerHighest
                                                .withValues(alpha: 0.35),
                                      textColor: NounSettings.instance.colorNouns
                                          ? NounSettings.instance
                                                .colorForGender(
                                                  genderRows[index],
                                                )
                                          : null,
                                      subtitle: _genderRowNames[genderRows[index]],
                                    )
                                  else
                                    buildFixedCell(
                                      widget.config.subjectDisplays[index],
                                      background: index.isEven
                                          ? colorScheme.surface
                                          : colorScheme
                                                .surfaceContainerHighest
                                                .withValues(alpha: 0.35),
                                      textColor:
                                          widget.config.subjectGenders !=
                                                  null &&
                                              NounSettings.instance.colorNouns
                                          ? NounSettings.instance
                                                .colorForGender(
                                                  widget
                                                      .config
                                                      .subjectGenders![index],
                                                )
                                          : null,
                                      subtitle: showEnglish
                                          ? widget
                                                .config
                                                .subjectEnglish![index]
                                          : null,
                                    ),
                              ],
                            ),
                            Expanded(
                              child: Scrollbar(
                                controller: _tableScrollController,
                                thumbVisibility: true,
                                child: SingleChildScrollView(
                                  controller: _tableScrollController,
                                  scrollDirection: Axis.horizontal,
                                  child: SizedBox(
                                    width: scrollableWidth,
                                    child: Column(
                                      children: [
                                        buildScrollableRow(
                                          widget.config.categories
                                              .map((c) => c.label)
                                              .toList(),
                                          header: true,
                                        ),
                                        for (
                                          int index = 0;
                                          index < rowCount;
                                          index++
                                        )
                                          buildScrollableRow(
                                            widget.config.categories
                                                .map(
                                                  (c) => c.values[genderRows !=
                                                          null
                                                      ? _firstSubjectIndexForGender(
                                                          genderRows[index],
                                                        )
                                                      : index],
                                                )
                                                .toList(),
                                            background: index.isEven
                                                ? colorScheme.surface
                                                : colorScheme
                                                      .surfaceContainerHighest
                                                      .withValues(alpha: 0.35),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    if (_useGenderReferenceRows) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Gender rules of thumb (tendencies, not absolute — exceptions exist)',
                        style: Theme.of(context).textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      for (final gender in _genderRowOrder)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_genderArticles[gender]} (${_genderRowNames[gender]})',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: NounSettings.instance.colorNouns
                                      ? NounSettings.instance.colorForGender(
                                          gender,
                                        )
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 4),
                              for (final rule in _genderRules[gender]!)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8,
                                    bottom: 2,
                                  ),
                                  child: Text('• $rule'),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _sectionWithMaxWidth(
              Card(
                clipBehavior: Clip.antiAlias,
                child: ExpansionTile(
                  title: Text(
                    'History',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text('Recent answers and common mistakes.'),
                  leading: IconBadge(
                    icon: Icons.history_rounded,
                    color: kSectionAccentColors[1],
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    if (recentHistory.isEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'No history yet.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    else
                      ...recentHistory.map((entry) {
                        final ok = entry['correct'] == true;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            '${ok ? 'OK' : 'X'} ${entry['nominative']} -> ${entry['case']}: ${entry['answer']} (correct: ${entry['correctAnswer']})',
                            style: TextStyle(
                              color: ok
                                  ? colorScheme.primary
                                  : colorScheme.error,
                            ),
                          ),
                        );
                      }),
                    const SizedBox(height: 8),
                    Text(
                      'Mistake Analytics',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (topMistakes.isEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'No mistakes tracked yet.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: topMistakes.take(6).map((entry) {
                          return Chip(
                            label: Text('${entry.key}: ${entry.value}'),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _sectionWithMaxWidth(
              Card(
                clipBehavior: Clip.antiAlias,
                child: ExpansionTile(
                  title: Text(
                    'Analytics',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text(
                    'Performance heatmap: red bad, yellow mixed, green good.',
                  ),
                  leading: IconBadge(
                    icon: Icons.analytics_rounded,
                    color: kSectionAccentColors[2],
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    Row(
                      children: [
                        _buildLegendChip(Colors.red.shade300, 'Bad avg'),
                        const SizedBox(width: 8),
                        _buildLegendChip(Colors.yellow.shade300, 'Mixed'),
                        const SizedBox(width: 8),
                        _buildLegendChip(Colors.green.shade300, 'Good avg'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final showEnglish =
                            widget.config.subjectEnglish != null &&
                            NounSettings.instance.showEnglishFor(widget.config.storageKeyPrefix);
                        final showSubtitleRow =
                            showEnglish || _useGenderReferenceRows;
                        final fixedColumnWidth = showSubtitleRow
                            ? 170.0
                            : 120.0;
                        const valueColumnWidth = 110.0;
                        final rowHeight = showSubtitleRow ? 58.0 : 48.0;
                        final scrollableWidth =
                            valueColumnWidth * widget.config.categories.length;

                        Widget buildFixedCell(
                          String text, {
                          bool header = false,
                          Color? background,
                          Color? textColor,
                          String? tooltip,
                          String? subtitle,
                        }) {
                          final bg =
                              background ??
                              (header
                                  ? colorScheme.primary
                                  : colorScheme.surface);
                          final brightness =
                              ThemeData.estimateBrightnessForColor(bg);
                          final fg =
                              textColor ??
                              (brightness == Brightness.dark
                                  ? Colors.white
                                  : colorScheme.onSurface);

                          return Tooltip(
                            message: tooltip ?? text,
                            child: Container(
                              width: fixedColumnWidth,
                              height: rowHeight,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: bg,
                                border: Border(
                                  right: BorderSide(
                                    color: header
                                        ? colorScheme.primary
                                        : colorScheme.outlineVariant,
                                  ),
                                  bottom: BorderSide(
                                    color: colorScheme.outlineVariant,
                                  ),
                                ),
                              ),
                              child: subtitle == null
                                  ? Text(
                                      text,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: header ? Colors.white : fg,
                                        fontWeight: header
                                            ? FontWeight.w700
                                            : FontWeight.w600,
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          text,
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: header ? Colors.white : fg,
                                            fontWeight: header
                                                ? FontWeight.w700
                                                : FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          subtitle,
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: fg.withValues(alpha: 0.7),
                                            fontSize: 11,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          );
                        }

                        Widget buildScrollableRow(
                          List<String> values, {
                          bool header = false,
                          List<Color>? backgrounds,
                          List<String>? tooltips,
                        }) {
                          return SizedBox(
                            width: scrollableWidth,
                            height: rowHeight,
                            child: Row(
                              children: List.generate(values.length, (idx) {
                                final bg = header
                                    ? colorScheme.primary
                                    : (backgrounds?[idx] ??
                                          colorScheme.surface);
                                final brightness =
                                    ThemeData.estimateBrightnessForColor(bg);
                                final fg = brightness == Brightness.dark
                                    ? Colors.white
                                    : colorScheme.onSurface;

                                return Tooltip(
                                  message: tooltips?[idx] ?? values[idx],
                                  child: Container(
                                    width: valueColumnWidth,
                                    height: rowHeight,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: bg,
                                      border: Border(
                                        right: BorderSide(
                                          color: header
                                              ? colorScheme.primary
                                              : colorScheme.outlineVariant,
                                        ),
                                        bottom: BorderSide(
                                          color: colorScheme.outlineVariant,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      values[idx],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: header ? Colors.white : fg,
                                        fontWeight: header
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          );
                        }

                        final genderRows = _useGenderReferenceRows
                            ? _genderRowOrder
                            : null;
                        final rowCount =
                            genderRows?.length ??
                            widget.config.subjects.length;

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                buildFixedCell(
                                  widget.config.subjectColumnLabel,
                                  header: true,
                                ),
                                for (int index = 0; index < rowCount; index++)
                                  () {
                                    if (genderRows != null) {
                                      final gender = genderRows[index];
                                      final displayName =
                                          _genderArticles[gender]!;
                                      final stats = _statsForGender(gender);
                                      final bg = _analyticsHeatColor(
                                        stats['correct']!,
                                        stats['total']!,
                                        colorScheme,
                                      );
                                      return buildFixedCell(
                                        displayName,
                                        background: bg,
                                        textColor:
                                            NounSettings.instance.colorNouns
                                            ? NounSettings.instance
                                                  .colorForGender(gender)
                                            : null,
                                        tooltip:
                                            '$displayName (${_genderRowNames[gender]}): ${stats['correct']}/${stats['total']} correct',
                                        subtitle: _genderRowNames[gender],
                                      );
                                    }

                                    final nominative =
                                        widget.config.subjects[index];
                                    final displayName =
                                        widget.config.subjectDisplays[index];
                                    final stats = _statsForNominative(
                                      nominative,
                                    );
                                    final bg = _analyticsHeatColor(
                                      stats['correct']!,
                                      stats['total']!,
                                      colorScheme,
                                    );
                                    return buildFixedCell(
                                      displayName,
                                      background: bg,
                                      textColor:
                                          widget.config.subjectGenders !=
                                                  null &&
                                              NounSettings.instance.colorNouns
                                          ? NounSettings.instance
                                                .colorForGender(
                                                  widget
                                                      .config
                                                      .subjectGenders![index],
                                                )
                                          : null,
                                      tooltip:
                                          '$displayName: ${stats['correct']}/${stats['total']} correct',
                                      subtitle: showEnglish
                                          ? widget
                                                .config
                                                .subjectEnglish![index]
                                          : null,
                                    );
                                  }(),
                              ],
                            ),
                            Expanded(
                              child: Scrollbar(
                                controller: _tableScrollController,
                                thumbVisibility: true,
                                child: SingleChildScrollView(
                                  controller: _tableScrollController,
                                  scrollDirection: Axis.horizontal,
                                  child: SizedBox(
                                    width: scrollableWidth,
                                    child: Column(
                                      children: [
                                        buildScrollableRow(
                                          widget.config.categories
                                              .map((c) => c.label)
                                              .toList(),
                                          header: true,
                                        ),
                                        for (
                                          int index = 0;
                                          index < rowCount;
                                          index++
                                        )
                                          () {
                                            if (genderRows != null) {
                                              final gender = genderRows[index];
                                              final subjectIndex =
                                                  _firstSubjectIndexForGender(
                                                    gender,
                                                  );
                                              final values = widget
                                                  .config
                                                  .categories
                                                  .map(
                                                    (c) =>
                                                        c.values[subjectIndex],
                                                  )
                                                  .toList();
                                              final backgrounds = widget
                                                  .config
                                                  .categories
                                                  .map((c) {
                                                    final stats =
                                                        _statsForGenderCase(
                                                          gender,
                                                          c.label,
                                                        );
                                                    return _analyticsHeatColor(
                                                      stats['correct']!,
                                                      stats['total']!,
                                                      colorScheme,
                                                    );
                                                  })
                                                  .toList();
                                              final tooltips = widget
                                                  .config
                                                  .categories
                                                  .map((c) {
                                                    final stats =
                                                        _statsForGenderCase(
                                                          gender,
                                                          c.label,
                                                        );
                                                    return '${_genderArticles[gender]} -> ${c.label}: ${stats['correct']}/${stats['total']} correct';
                                                  })
                                                  .toList();

                                              return buildScrollableRow(
                                                values,
                                                backgrounds: backgrounds,
                                                tooltips: tooltips,
                                              );
                                            }

                                            final nominative =
                                                widget.config.subjects[index];
                                            final values = widget
                                                .config
                                                .categories
                                                .map((c) => c.values[index])
                                                .toList();
                                            final backgrounds = widget
                                                .config
                                                .categories
                                                .map((c) {
                                                  final stats =
                                                      _statsForCaseCell(
                                                        nominative,
                                                        c.label,
                                                      );
                                                  return _analyticsHeatColor(
                                                    stats['correct']!,
                                                    stats['total']!,
                                                    colorScheme,
                                                  );
                                                })
                                                .toList();
                                            final tooltips = widget
                                                .config
                                                .categories
                                                .map((c) {
                                                  final stats =
                                                      _statsForCaseCell(
                                                        nominative,
                                                        c.label,
                                                      );
                                                  return '$nominative -> ${c.label}: ${stats['correct']}/${stats['total']} correct';
                                                })
                                                .toList();

                                            return buildScrollableRow(
                                              values,
                                              backgrounds: backgrounds,
                                              tooltips: tooltips,
                                            );
                                          }(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _sectionWithMaxWidth(
              Card(
                clipBehavior: Clip.antiAlias,
                child: ExpansionTile(
                  title: Text(
                    'Settings',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    'Choose which ${widget.config.subjectsLabel.toLowerCase()} and cases appear in the quiz.',
                  ),
                  leading: IconBadge(
                    icon: Icons.tune_rounded,
                    color: kSectionAccentColors[3],
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.config.subjectDifficulties != null) ...[
                          Text(
                            'Difficulty',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: NounDifficulty.values.map((d) {
                              final indices = _subjectIndicesForDifficulty(
                                d,
                              ).toList();
                              final allEnabled = indices.every(
                                _enabledSubjectIndices.contains,
                              );
                              return FilterChip(
                                label: Text(_difficultyLabel(d)),
                                selected: allEnabled,
                                onSelected: (_) => _toggleSubjectGroup(indices),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 10),
                        ],
                        if (widget.config.subjectCategories != null) ...[
                          Text(
                            'Category',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: _orderedCategoryKeys().map((catKey) {
                              final indices = _subjectIndicesForCategory(
                                catKey,
                              ).toList();
                              final allEnabled = indices.every(
                                _enabledSubjectIndices.contains,
                              );
                              final label =
                                  widget.config.categoryDisplayNames?[catKey] ??
                                  catKey;
                              return FilterChip(
                                label: Text(label),
                                selected: allEnabled,
                                onSelected: (_) => _toggleSubjectGroup(indices),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 10),
                        ],
                        if (widget.config.subjectCategories != null) ...[
                          Text(
                            'Manage the full word list, including individual '
                            'words, in the Word Library.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 6),
                          OutlinedButton.icon(
                            onPressed: _openWordLibrary,
                            icon: const Icon(Icons.library_books_rounded),
                            label: const Text('Open Word Library'),
                          ),
                        ] else ...[
                          Text(
                            'Active ${widget.config.subjectsLabel}',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: List.generate(
                              widget.config.subjectDisplays.length,
                              (i) => FilterChip(
                                label: Text(widget.config.subjectDisplays[i]),
                                selected: _enabledSubjectIndices.contains(i),
                                onSelected: (_) => _toggleSubject(i),
                              ),
                            ),
                          ),
                        ],
                        if (widget.config.subjectEnglish != null) ...[
                          const SizedBox(height: 10),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Show English meanings'),
                            value: NounSettings.instance.showEnglishFor(widget.config.storageKeyPrefix),
                            onChanged: (value) {
                              setState(() {
                                NounSettings.instance.setShowEnglishFor(
                                  widget.config.storageKeyPrefix,
                                  value,
                                );
                              });
                            },
                          ),
                        ],
                        const SizedBox(height: 10),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Color nouns by article'),
                          subtitle: const Text(
                            'Highlights known nouns in sentences by their '
                            'article color (may reveal quiz answers).',
                          ),
                          value: NounSettings.instance.colorNouns,
                          onChanged: (value) {
                            setState(() {
                              NounSettings.instance.setColorNouns(value);
                            });
                          },
                        ),
                        if (widget.config.progressionKey != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            '* ${NounSettings.instance.progressionUnlockLaps} '
                            'streaks in a row '
                            '(${NounSettings.instance.progressionUnlockStreak} '
                            'correct answers) unlocks the next category '
                            'either way — turning this off is the fairer '
                            'challenge, since the article color can '
                            'otherwise give away the answer.',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        Text(
                          'Active Cases',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: widget.config.categories
                              .map(
                                (c) => FilterChip(
                                  label: Text(c.label),
                                  selected: _enabledCategoryLabels.contains(
                                    c.label,
                                  ),
                                  onSelected: (_) => _toggleCategory(c.label),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
