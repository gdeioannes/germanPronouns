import 'dart:math';
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/noun_lookup.dart';
import '../models/noun_settings.dart';
import '../models/quiz_config.dart';
import '../pages/word_library_page.dart';
import 'app_drawer.dart';
import 'fireworks.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key, required this.config});

  final QuizConfig config;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage>
    with SingleTickerProviderStateMixin {
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
  String get _enabledSubjectsKey =>
      '${widget.config.storageKeyPrefix}quiz_enabled_pronouns';
  String get _enabledCategoriesKey =>
      '${widget.config.storageKeyPrefix}quiz_enabled_cases';

  int _score = 0;
  int _streakAbsolute = 0;
  int _bestStreakLap = 0;
  int get _streakLap => _streakAbsolute ~/ _maxStreak;
  int _currentSubjectIndex = 0;
  int _currentCategoryIndex = 0;
  String _feedback = '';
  String _feedbackHint = '';
  bool? _lastAnswerCorrect;
  String _currentReferenceSentence = '';
  String _currentReferenceExplanation = '';
  bool _showFireworks = false;
  late final AnimationController _fireworksController;
  List<FireworkParticle> _fireworkParticles = const [];
  List<Map<String, dynamic>> _answerHistory = [];
  Map<String, int> _mistakesByCase = {};

  late Set<int> _enabledSubjectIndices;
  late Set<String> _enabledCategoryLabels;

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
    if (!mounted) return;
    setState(() {
      _score = storedScore;
      _streakAbsolute = storedStreak;
      _bestStreakLap = storedBestLap;
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

  void _nextQuestion() {
    final enabledSubjects = widget.config.subjectCategories == null
        ? _enabledSubjectIndices.toList()
        : _enabledSubjectIndices
              .where(
                (i) => NounSettings.instance.isEnabled(
                  widget.config.subjects[i],
                ),
              )
              .toList();
    if (enabledSubjects.isEmpty == false) {
      _currentSubjectIndex =
          enabledSubjects[_random.nextInt(enabledSubjects.length)];
    }

    final enabledCategories = widget.config.categories
        .where((c) => _enabledCategoryLabels.contains(c.label))
        .toList();
    if (enabledCategories.isEmpty) return;

    // Group weighting restricted to groups that have at least one enabled category.
    final availableGroups = enabledCategories.map((c) => c.group).toSet();
    final weights = Map<String, double>.fromEntries(
      widget.config.groupWeights.entries.where(
        (e) => availableGroups.contains(e.key),
      ),
    );
    final total = weights.values.fold<double>(0, (a, b) => a + b);
    var threshold = _random.nextDouble() * total;
    var selectedGroup = weights.keys.first;
    for (final entry in weights.entries) {
      threshold -= entry.value;
      if (threshold <= 0) {
        selectedGroup = entry.key;
        break;
      }
    }

    final categoriesInGroup = enabledCategories
        .where((c) => c.group == selectedGroup)
        .toList();
    final selectedCategory =
        categoriesInGroup[_random.nextInt(categoriesInGroup.length)];
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
      _answerHistory = [];
      _mistakesByCase = {};
      _feedback = '';
      _feedbackHint = '';
      _lastAnswerCorrect = null;
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
    final userAnswerRaw = _answerController.text.trim();
    final userAnswer = userAnswerRaw.toLowerCase();
    final caseLabel = widget.config.categories[_currentCategoryIndex].label;
    final nominative = widget.config.subjects[_currentSubjectIndex];
    final correctAnswer = widget
        .config
        .categories[_currentCategoryIndex]
        .values[_currentSubjectIndex];
    final isCorrect = userAnswer == correctAnswer.toLowerCase();
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
      if (isCorrect) {
        _streakAbsolute++;
        final multiplier = _streakLap + 1;
        lapCompleted = _streakAbsolute % _maxStreak == 0;
        if (_streakLap > _bestStreakLap) _bestStreakLap = _streakLap;
        final pointsEarned = multiplier;
        _score += pointsEarned;
        streakLapAtSubmit = _streakLap;
        shouldCelebrate = true;
        _feedbackHint = successHint;
        _lastAnswerCorrect = true;
        if (lapCompleted && multiplier > 1) {
          _feedback =
              '$nominative → $caseLabel = $correctAnswer (+$pointsEarned pts, ×$multiplier — lap $streakLapAtSubmit done!)';
        } else if (multiplier > 1) {
          _feedback =
              '$nominative → $caseLabel = $correctAnswer (+$pointsEarned pts, ×$multiplier)';
        } else {
          _feedback =
              '$nominative → $caseLabel = $correctAnswer (+$pointsEarned pt)';
        }
      } else {
        if (_streakLap > _bestStreakLap) _bestStreakLap = _streakLap;
        _streakAbsolute = 0;
        _score -= 1;
        _feedbackHint = reminderHint;
        _lastAnswerCorrect = false;
        _feedback =
            '$nominative → $caseLabel. You wrote "$userAnswerRaw", correct is "$correctAnswer" (-1 pt)';
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

      _answerController.clear();
      _nextQuestion();
    });

    if (shouldCelebrate) {
      _triggerFireworks(
        streakAbsolute: _streakAbsolute,
        lapCompleted: lapCompleted,
        streakLap: streakLapAtSubmit,
      );
    }

    _saveStoredStats();
    _requestAnswerFocus();
  }

  void _newQuestion() {
    setState(() {
      _feedback = '';
      _feedbackHint = '';
      _lastAnswerCorrect = null;
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
        final style = NounSettings.instance.colorNounsFor(widget.config.storageKeyPrefix)
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

  void _showNounInfoDialog(NounInfo info) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          '${info.article} ${info.noun.noun}',
          style: TextStyle(color: NounSettings.instance.colorForGender(info.noun.gender)),
        ),
        content: Text(info.noun.english),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
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
    final quizTextTheme = GoogleFonts.latoTextTheme(
      Theme.of(context).textTheme,
    );
    const quizFontScale = 1.2;
    final scaledQuizTextTheme = quizTextTheme.apply(
      fontSizeFactor: quizFontScale,
    );
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
            NounSettings.instance.colorNounsFor(widget.config.storageKeyPrefix)
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
        backgroundColor: colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(
          widget.config.title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Reset score and history',
            onPressed: _showResetConfirmationPanel,
            icon: const Icon(Icons.restart_alt_rounded),
          ),
        ],
      ),
      drawer: AppDrawer(currentPage: widget.config.currentPage),
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
                      Card(
                        color: Color.lerp(
                          colorScheme.primaryContainer,
                          Colors.white,
                          0.35,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
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
                                        padding: const EdgeInsets.fromLTRB(
                                          10,
                                          8,
                                          12,
                                          8,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            14,
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
                                              width: 26,
                                              height: 26,
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
                                                size: 15,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  '$_score',
                                                  style: scaledQuizTextTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color: colorScheme
                                                            .onSurface,
                                                      ),
                                                ),
                                                if (_streakLap > 0)
                                                  Text(
                                                    '×${_streakLap + 1}',
                                                    style: scaledQuizTextTheme
                                                        .labelSmall
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w800,
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
                                                size: 12,
                                                color: Colors.amber.shade700,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Best ×${_bestStreakLap + 1}',
                                                style: scaledQuizTextTheme
                                                    .labelSmall
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
                                                    child: TextField(
                                                      controller:
                                                          _answerController,
                                                      focusNode:
                                                          _answerFocusNode,
                                                      autofocus: true,
                                                      textInputAction:
                                                          TextInputAction.done,
                                                      style: sentenceStyle,
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
                                                        fillColor: colorScheme
                                                            .surfaceContainerHighest
                                                            .withValues(
                                                              alpha: 0.35,
                                                            ),
                                                      ),
                                                      onSubmitted: (_) =>
                                                          _submitAnswer(),
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
                                                  tooltip: 'Grammar info',
                                                  onPressed: () {
                                                    showDialog<void>(
                                                      context: context,
                                                      builder: (dialogContext) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                            'Sentence Info',
                                                          ),
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
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                    dialogContext,
                                                                  ).pop(),
                                                              child: const Text(
                                                                'Close',
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
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
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: FilledButton.icon(
                                      onPressed: _submitAnswer,
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
                                    onPressed: _newQuestion,
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
                                    color: _lastAnswerCorrect == true
                                        ? Colors.green.shade50
                                        : const Color(0xFFFFD6D6),
                                    border: Border.all(
                                      color: _lastAnswerCorrect == true
                                          ? Colors.green.shade400
                                          : Colors.red.shade500,
                                      width: 1.8,
                                    ),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _lastAnswerCorrect == true
                                            ? 'Correct'
                                            : 'Incorrect',
                                        style: scaledQuizTextTheme.bodyLarge
                                            ?.copyWith(
                                              color: _lastAnswerCorrect == true
                                                  ? Colors.green.shade700
                                                  : Colors.red.shade700,
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text.rich(
                                        TextSpan(
                                          children: _highlightNounSpans(
                                            _feedback,
                                            scaledQuizTextTheme.bodyLarge
                                                ?.copyWith(
                                                  color:
                                                      colorScheme.onSurface,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                        ),
                                      ),
                                      if (_feedbackHint != '') ...[
                                        const SizedBox(height: 8),
                                        Text.rich(
                                          TextSpan(
                                            children: _highlightNounSpans(
                                              _feedbackHint,
                                              scaledQuizTextTheme.bodyMedium
                                                  ?.copyWith(
                                                    color: colorScheme
                                                        .onSurfaceVariant,
                                                    fontStyle:
                                                        FontStyle.italic,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                  ),
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
                ],
              ),
            ),
            const SizedBox(height: 16),
            _sectionWithMaxWidth(
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                clipBehavior: Clip.antiAlias,
                child: ExpansionTile(
                  title: const Text(
                    'Help Memory',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text(
                    'Expanded reference table with all cases.',
                  ),
                  leading: CircleAvatar(
                    backgroundColor: colorScheme.primaryContainer,
                    child: Icon(
                      Icons.menu_book_rounded,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
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
                                      textColor: NounSettings.instance.colorNounsFor(widget.config.storageKeyPrefix)
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
                                              NounSettings.instance.colorNounsFor(widget.config.storageKeyPrefix)
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
                                  color: NounSettings.instance.colorNounsFor(widget.config.storageKeyPrefix)
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
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                clipBehavior: Clip.antiAlias,
                child: ExpansionTile(
                  title: const Text(
                    'History',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text('Recent answers and common mistakes.'),
                  leading: CircleAvatar(
                    backgroundColor: colorScheme.primaryContainer,
                    child: Icon(
                      Icons.history_rounded,
                      color: colorScheme.onPrimaryContainer,
                    ),
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
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                clipBehavior: Clip.antiAlias,
                child: ExpansionTile(
                  title: const Text(
                    'Analytics',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text(
                    'Performance heatmap: red bad, yellow mixed, green good.',
                  ),
                  leading: CircleAvatar(
                    backgroundColor: colorScheme.primaryContainer,
                    child: Icon(
                      Icons.analytics_rounded,
                      color: colorScheme.onPrimaryContainer,
                    ),
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
                                            NounSettings.instance.colorNounsFor(widget.config.storageKeyPrefix)
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
                                              NounSettings.instance.colorNounsFor(widget.config.storageKeyPrefix)
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
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                clipBehavior: Clip.antiAlias,
                child: ExpansionTile(
                  title: const Text(
                    'Settings',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    'Choose which ${widget.config.subjectsLabel.toLowerCase()} and cases appear in the quiz.',
                  ),
                  leading: CircleAvatar(
                    backgroundColor: colorScheme.primaryContainer,
                    child: Icon(
                      Icons.tune_rounded,
                      color: colorScheme.onPrimaryContainer,
                    ),
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
                          value: NounSettings.instance.colorNounsFor(widget.config.storageKeyPrefix),
                          onChanged: (value) {
                            setState(() {
                              NounSettings.instance.setColorNounsFor(
                                widget.config.storageKeyPrefix,
                                value,
                              );
                            });
                          },
                        ),
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
