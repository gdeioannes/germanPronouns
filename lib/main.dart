import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/pronoun_data.dart';
import 'data/reference_sentence_bank.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    );

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: baseTheme,
      home: const MyHomePage(title: 'German Pronoun Quiz'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _answerController = TextEditingController();
  final FocusNode _answerFocusNode = FocusNode();
  final ScrollController _tableScrollController = ScrollController();
  final Random _random = Random();
  static const String _historyStorageKey = 'quiz_answer_history';
  static const String _mistakesStorageKey = 'quiz_mistakes_by_case';
  static const String _scoreStorageKey = 'quiz_score';
  static const String _streakStorageKey = 'quiz_streak';
  static const String _enabledPronounsKey = 'quiz_enabled_pronouns';
  static const String _enabledCasesKey = 'quiz_enabled_cases';
  static const int _maxStoredHistory = 100;
  static const int _maxStreak = 5;

  int _score = 0;
  int _streakCount = 0;
  int _currentPronounIndex = 0;
  int _currentCaseIndex = 0;
  String _feedback = '';
  String _feedbackHint = '';
  bool? _lastAnswerCorrect;
  String _currentReferenceSentence = '';
  String _currentReferenceExplanation = '';
  bool _showFireworks = false;
  late final AnimationController _fireworksController;
  List<_FireworkParticle> _fireworkParticles = const [];
  List<Map<String, dynamic>> _answerHistory = [];
  Map<String, int> _mistakesByCase = {};

  Set<int> _enabledPronounIndices = {0, 1, 2, 3, 4, 5, 6, 7, 8};
  Set<String> _enabledCaseLabels = {
    'Accusative',
    'Dative',
    'Genitive',
    'Reflexive',
    'Poss. Masc.',
    'Poss. Masc. Acc.',
    'Poss. Masc. Dat.',
    'Poss. Masc. Gen.',
    'Poss. Fem.',
    'Poss. Fem. Acc.',
    'Poss. Fem. Dat.',
    'Poss. Fem. Gen.',
    'Poss. Neut.',
    'Poss. Neut. Acc.',
    'Poss. Neut. Dat.',
    'Poss. Neut. Gen.',
    'Poss. Pl. Gen.',
    'Poss. Pl.',
  };

  List<MapEntry<String, List<String>>> get _tableColumns => [
    MapEntry('Nominative', listPronounsGermanNominative),
    MapEntry('Accusative', listPronounsGermanAkusative),
    MapEntry('Dative', listPronounsGermanDative),
    MapEntry('Genitive', listPronounsGermanGenitive),
    MapEntry('Reflexive', listPronounsGermanReflexive),
    MapEntry('Poss. Masc.', listPronounsGermanPossessiveMasculine),
    MapEntry(
      'Poss. Masc. Acc.',
      listPronounsGermanPossessiveMasculineAccusative,
    ),
    MapEntry('Poss. Masc. Dat.', listPronounsGermanPossessiveMasculineDative),
    MapEntry('Poss. Masc. Gen.', listPronounsGermanPossessiveMasculineGenitive),
    MapEntry('Poss. Fem.', listPronounsGermanPossessiveFeminine),
    MapEntry('Poss. Fem. Acc.', listPronounsGermanPossessiveFeminineAccusative),
    MapEntry('Poss. Fem. Dat.', listPronounsGermanPossessiveFeminineDative),
    MapEntry('Poss. Fem. Gen.', listPronounsGermanPossessiveFeminineGenitive),
    MapEntry('Poss. Neut.', listPronounsGermanPossessiveNeuter),
    MapEntry('Poss. Neut. Acc.', listPronounsGermanPossessiveNeuterAccusative),
    MapEntry('Poss. Neut. Dat.', listPronounsGermanPossessiveNeuterDative),
    MapEntry('Poss. Neut. Gen.', listPronounsGermanPossessiveNeuterGenitive),
    MapEntry('Poss. Pl. Gen.', listPronounsGermanPossessivePluralGenitive),
    MapEntry('Poss. Pl.', listPronounsGermanPossessivePlural),
  ];

  final List<QuizCaseDefinition> _quizCases = [
    QuizCaseDefinition(
      label: 'Accusative',
      values: listPronounsGermanAkusative,
      group: 'Accusative',
    ),
    QuizCaseDefinition(
      label: 'Dative',
      values: listPronounsGermanDative,
      group: 'Dative',
    ),
    QuizCaseDefinition(
      label: 'Genitive',
      values: listPronounsGermanGenitive,
      group: 'Genitive',
    ),
    QuizCaseDefinition(
      label: 'Reflexive',
      values: listPronounsGermanReflexive,
      group: 'Reflexive',
    ),
    QuizCaseDefinition(
      label: 'Poss. Masc.',
      values: listPronounsGermanPossessiveMasculine,
      group: 'Possessive',
    ),
    QuizCaseDefinition(
      label: 'Poss. Masc. Acc.',
      values: listPronounsGermanPossessiveMasculineAccusative,
      group: 'Possessive',
    ),
    QuizCaseDefinition(
      label: 'Poss. Masc. Dat.',
      values: listPronounsGermanPossessiveMasculineDative,
      group: 'Possessive',
    ),
    QuizCaseDefinition(
      label: 'Poss. Masc. Gen.',
      values: listPronounsGermanPossessiveMasculineGenitive,
      group: 'Possessive',
    ),
    QuizCaseDefinition(
      label: 'Poss. Fem.',
      values: listPronounsGermanPossessiveFeminine,
      group: 'Possessive',
    ),
    QuizCaseDefinition(
      label: 'Poss. Fem. Acc.',
      values: listPronounsGermanPossessiveFeminineAccusative,
      group: 'Possessive',
    ),
    QuizCaseDefinition(
      label: 'Poss. Fem. Dat.',
      values: listPronounsGermanPossessiveFeminineDative,
      group: 'Possessive',
    ),
    QuizCaseDefinition(
      label: 'Poss. Fem. Gen.',
      values: listPronounsGermanPossessiveFeminineGenitive,
      group: 'Possessive',
    ),
    QuizCaseDefinition(
      label: 'Poss. Neut.',
      values: listPronounsGermanPossessiveNeuter,
      group: 'Possessive',
    ),
    QuizCaseDefinition(
      label: 'Poss. Neut. Acc.',
      values: listPronounsGermanPossessiveNeuterAccusative,
      group: 'Possessive',
    ),
    QuizCaseDefinition(
      label: 'Poss. Neut. Dat.',
      values: listPronounsGermanPossessiveNeuterDative,
      group: 'Possessive',
    ),
    QuizCaseDefinition(
      label: 'Poss. Neut. Gen.',
      values: listPronounsGermanPossessiveNeuterGenitive,
      group: 'Possessive',
    ),
    QuizCaseDefinition(
      label: 'Poss. Pl. Gen.',
      values: listPronounsGermanPossessivePluralGenitive,
      group: 'Possessive',
    ),
    QuizCaseDefinition(
      label: 'Poss. Pl.',
      values: listPronounsGermanPossessivePlural,
      group: 'Possessive',
    ),
  ];

  // Tune these values to control case-group frequency.
  // Possessive stays one group, so all its variants share this group chance.
  final Map<String, double> _groupChanceWeights = {
    'Accusative': 1,
    'Dative': 1,
    'Genitive': 1,
    'Reflexive': 1,
    'Possessive': 1,
  };

  @override
  void initState() {
    super.initState();
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
  }

  @override
  void dispose() {
    _answerController.dispose();
    _answerFocusNode.dispose();
    _tableScrollController.dispose();
    _fireworksController.dispose();
    super.dispose();
  }

  void _triggerFireworks({required int streak, required bool jackpot}) {
    final colorScheme = Theme.of(context).colorScheme;
    final palette = [
      colorScheme.primary,
      colorScheme.tertiary,
      Colors.orange,
      Colors.amber,
      Colors.lightBlue,
      Colors.green,
    ];

    final baseIntensity = 1 + (streak * 0.22);
    final intensity = jackpot ? baseIntensity + 0.85 : baseIntensity;
    final particleCount = (34 * intensity).round().clamp(36, 120);
    final particles = List.generate(particleCount, (_) {
      final angle = _random.nextDouble() * 2 * pi;
      final direction = Offset(cos(angle), sin(angle));
      return _FireworkParticle(
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

    final pronounsJson = prefs.getString(_enabledPronounsKey);
    final casesJson = prefs.getString(_enabledCasesKey);

    Set<int> loadedPronouns = {0, 1, 2, 3, 4, 5, 6, 7, 8};
    Set<String> loadedCases = _enabledCaseLabels;

    if (pronounsJson != null && pronounsJson != '') {
      final decoded = jsonDecode(pronounsJson);
      if (decoded is List) {
        loadedPronouns = decoded.map((v) => (v as num).toInt()).toSet();
      }
    }
    if (casesJson != null && casesJson != '') {
      final decoded = jsonDecode(casesJson);
      if (decoded is List) {
        loadedCases = decoded.map((v) => v.toString()).toSet();
      }
    }

    if (!mounted) return;
    setState(() {
      _score = storedScore;
      _streakCount = storedStreak.clamp(0, _maxStreak);
      _answerHistory = loadedHistory;
      _mistakesByCase = loadedMistakes;
      if (loadedPronouns.isEmpty == false) {
        _enabledPronounIndices = loadedPronouns;
      }
      if (loadedCases.isEmpty == false) _enabledCaseLabels = loadedCases;
    });
  }

  Future<void> _saveStoredStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_scoreStorageKey, _score);
    await prefs.setInt(_streakStorageKey, _streakCount);
    await prefs.setString(_historyStorageKey, jsonEncode(_answerHistory));
    await prefs.setString(_mistakesStorageKey, jsonEncode(_mistakesByCase));
    await prefs.setString(
      _enabledPronounsKey,
      jsonEncode(_enabledPronounIndices.toList()),
    );
    await prefs.setString(
      _enabledCasesKey,
      jsonEncode(_enabledCaseLabels.toList()),
    );
  }

  void _nextQuestion() {
    final enabledPronouns = _enabledPronounIndices.toList();
    if (enabledPronouns.isEmpty == false) {
      _currentPronounIndex =
          enabledPronouns[_random.nextInt(enabledPronouns.length)];
    }

    final enabledCases = _quizCases
        .where((c) => _enabledCaseLabels.contains(c.label))
        .toList();
    if (enabledCases.isEmpty) return;

    // Group weighting restricted to groups that have at least one enabled case.
    final availableGroups = enabledCases.map((c) => c.group).toSet();
    final weights = Map<String, double>.fromEntries(
      _groupChanceWeights.entries.where((e) => availableGroups.contains(e.key)),
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

    final casesInGroup = enabledCases
        .where((c) => c.group == selectedGroup)
        .toList();
    final selectedCase = casesInGroup[_random.nextInt(casesInGroup.length)];
    _currentCaseIndex = _quizCases.indexOf(selectedCase);
    final nominative = listPronounsGermanNominative[_currentPronounIndex];
    final correctAnswer = selectedCase.values[_currentPronounIndex];
    _currentReferenceSentence = pickReferenceSentence(
      caseLabel: selectedCase.label,
      nominative: nominative,
      answer: correctAnswer,
      random: _random,
    );
    _currentReferenceExplanation = buildReferenceExplanation(
      caseLabel: selectedCase.label,
      nominative: nominative,
      answer: correctAnswer,
      sentence: _currentReferenceSentence,
    );
  }

  void _togglePronoun(int index) {
    setState(() {
      if (_enabledPronounIndices.contains(index)) {
        if (_enabledPronounIndices.length <= 1) return;
        _enabledPronounIndices = Set.of(_enabledPronounIndices)..remove(index);
      } else {
        _enabledPronounIndices = Set.of(_enabledPronounIndices)..add(index);
      }
      _feedback = '';
      _feedbackHint = '';
      _lastAnswerCorrect = null;
      _answerController.clear();
      _nextQuestion();
    });
    _saveStoredStats();
  }

  void _toggleCase(String label) {
    setState(() {
      if (_enabledCaseLabels.contains(label)) {
        if (_enabledCaseLabels.length <= 1) return;
        _enabledCaseLabels = Set.of(_enabledCaseLabels)..remove(label);
      } else {
        _enabledCaseLabels = Set.of(_enabledCaseLabels)..add(label);
      }
      _feedback = '';
      _feedbackHint = '';
      _lastAnswerCorrect = null;
      _answerController.clear();
      _nextQuestion();
    });
    _saveStoredStats();
  }

  Future<void> _resetProgress() async {
    setState(() {
      _score = 0;
      _streakCount = 0;
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
    final caseLabel = _quizCases[_currentCaseIndex].label;
    final nominative = listPronounsGermanNominative[_currentPronounIndex];
    final correctAnswer =
        _quizCases[_currentCaseIndex].values[_currentPronounIndex];
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
    var reachedStreakFive = false;
    var fireworksStreak = 0;

    setState(() {
      if (isCorrect) {
        final previousStreak = _streakCount;
        _streakCount = min(_streakCount + 1, _maxStreak);
        var pointsEarned = 1;
        reachedStreakFive =
            previousStreak < _maxStreak && _streakCount == _maxStreak;
        if (reachedStreakFive) {
          pointsEarned += 2;
        }
        _score += pointsEarned;
        fireworksStreak = _streakCount;
        shouldCelebrate = true;
        _feedbackHint = successHint;
        _lastAnswerCorrect = true;
        if (reachedStreakFive) {
          _feedback =
              '$nominative -> $caseLabel = $correctAnswer (+3 points, bonus +2)';
        } else {
          _feedback = '$nominative -> $caseLabel = $correctAnswer (+1 point)';
        }
      } else {
        _streakCount = 0;
        _score -= 1;
        _feedbackHint = reminderHint;
        _lastAnswerCorrect = false;
        _feedback =
            '$nominative -> $caseLabel. You wrote "$userAnswerRaw", correct is "$correctAnswer" (-1 point)';
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
      _triggerFireworks(streak: fireworksStreak, jackpot: reachedStreakFive);
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
        spans.add(
          TextSpan(
            text: ' $body',
            style: baseStyle?.copyWith(
              fontStyle: emphasizeBody ? FontStyle.italic : FontStyle.normal,
              height: 1.35,
            ),
          ),
        );
      } else {
        spans.add(TextSpan(text: section, style: baseStyle));
      }

      if (i < sections.length - 1) {
        spans.add(const TextSpan(text: '\n\n'));
      }
    }

    return spans;
  }

  Widget _buildStreakTracker(ColorScheme colorScheme) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: _streakCount.toDouble()),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      builder: (context, animatedStreak, child) {
        final normalizedProgress = ((animatedStreak - 1) / (_maxStreak - 1))
            .clamp(0.0, 1.0);
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
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: colorScheme.surfaceContainerHighest,
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: normalizedProgress,
                          child: Container(
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: List.generate(_maxStreak, (ballIndex) {
                      final fillProgress = (animatedStreak - ballIndex).clamp(
                        0.0,
                        1.0,
                      );
                      final isJackpotBall = ballIndex == _maxStreak - 1;
                      final activeColor = isJackpotBall
                          ? colorScheme.tertiary
                          : colorScheme.primary;
                      final ballColor = Color.lerp(
                        colorScheme.surfaceContainerHighest,
                        activeColor,
                        fillProgress,
                      );

                      return Expanded(
                        child: Center(
                          child: AnimatedScale(
                            duration: const Duration(milliseconds: 260),
                            scale: fillProgress > 0.95
                                ? (isJackpotBall ? 1.15 : 1.0)
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
                                          color: activeColor.withValues(
                                            alpha: 0.35,
                                          ),
                                          blurRadius: isJackpotBall ? 14 : 8,
                                          spreadRadius: isJackpotBall ? 2 : 0,
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
    final currentCase = _quizCases[_currentCaseIndex].label;
    final currentPronoun =
        listPronounsGermanNominativeDisplay[_currentPronounIndex];
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
          widget.title,
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
                                  const SizedBox(width: 12),
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minWidth: 132,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                        10,
                                        8,
                                        12,
                                        8,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: colorScheme.primaryContainer,
                                        border: Border.all(
                                          color: colorScheme.primary.withValues(
                                            alpha: 0.45,
                                          ),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: colorScheme.primary
                                                .withValues(alpha: 0.16),
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
                                              color: colorScheme.primary,
                                            ),
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.star_rounded,
                                              size: 15,
                                              color: colorScheme.onPrimary,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '$_score',
                                            style: scaledQuizTextTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w900,
                                                  color: colorScheme
                                                      .onPrimaryContainer,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                          'Pronoun',
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
                                    Text(
                                      currentPronoun,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: scaledQuizTextTheme.headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            fontSize:
                                                (scaledQuizTextTheme
                                                        .headlineSmall
                                                        ?.fontSize ??
                                                    24) *
                                                0.8,
                                          ),
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
                                              TextSpan(text: referenceBefore),
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
                                                TextSpan(text: referenceAfter),
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
                                      Text(
                                        _feedback,
                                        style: scaledQuizTextTheme.bodyLarge
                                            ?.copyWith(
                                              color: colorScheme.onSurface,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      if (_feedbackHint != '') ...[
                                        const SizedBox(height: 8),
                                        Text(
                                          _feedbackHint,
                                          style: scaledQuizTextTheme.bodyMedium
                                              ?.copyWith(
                                                color: colorScheme
                                                    .onSurfaceVariant,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.w600,
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
                              painter: _FireworksPainter(
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
                        const fixedColumnWidth = 120.0;
                        const valueColumnWidth = 110.0;
                        const rowHeight = 48.0;
                        final scrollableWidth =
                            valueColumnWidth * (_tableColumns.length - 1);

                        Widget buildFixedCell(
                          String text, {
                          bool header = false,
                          Color? background,
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
                            child: Text(
                              text,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: header ? Colors.white : null,
                                fontWeight: header
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                              ),
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

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                buildFixedCell('Nominative', header: true),
                                for (
                                  int index = 0;
                                  index <
                                      listPronounsGermanNominativeDisplay
                                          .length;
                                  index++
                                )
                                  buildFixedCell(
                                    listPronounsGermanNominativeDisplay[index],
                                    background: index.isEven
                                        ? colorScheme.surface
                                        : colorScheme.surfaceContainerHighest
                                              .withValues(alpha: 0.35),
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
                                          _tableColumns
                                              .skip(1)
                                              .map((column) => column.key)
                                              .toList(),
                                          header: true,
                                        ),
                                        for (
                                          int index = 0;
                                          index <
                                              listPronounsGermanNominative
                                                  .length;
                                          index++
                                        )
                                          buildScrollableRow(
                                            _tableColumns
                                                .skip(1)
                                                .map(
                                                  (column) =>
                                                      column.value[index],
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
                        const fixedColumnWidth = 120.0;
                        const valueColumnWidth = 110.0;
                        const rowHeight = 48.0;
                        final scrollableWidth =
                            valueColumnWidth * (_tableColumns.length - 1);

                        Widget buildFixedCell(
                          String text, {
                          bool header = false,
                          Color? background,
                          String? tooltip,
                        }) {
                          final bg =
                              background ??
                              (header
                                  ? colorScheme.primary
                                  : colorScheme.surface);
                          final brightness =
                              ThemeData.estimateBrightnessForColor(bg);
                          final fg = brightness == Brightness.dark
                              ? Colors.white
                              : colorScheme.onSurface;

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
                              child: Text(
                                text,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: header ? Colors.white : fg,
                                  fontWeight: header
                                      ? FontWeight.w700
                                      : FontWeight.w600,
                                ),
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

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                buildFixedCell('Nominative', header: true),
                                for (
                                  int index = 0;
                                  index < listPronounsGermanNominative.length;
                                  index++
                                )
                                  () {
                                    final nominative =
                                        listPronounsGermanNominative[index];
                                    final displayName =
                                        listPronounsGermanNominativeDisplay[index];
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
                                      tooltip:
                                          '$displayName: ${stats['correct']}/${stats['total']} correct',
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
                                          _tableColumns
                                              .skip(1)
                                              .map((column) => column.key)
                                              .toList(),
                                          header: true,
                                        ),
                                        for (
                                          int index = 0;
                                          index <
                                              listPronounsGermanNominative
                                                  .length;
                                          index++
                                        )
                                          () {
                                            final nominative =
                                                listPronounsGermanNominative[index];
                                            final values = _tableColumns
                                                .skip(1)
                                                .map(
                                                  (column) =>
                                                      column.value[index],
                                                )
                                                .toList();
                                            final backgrounds = _tableColumns
                                                .skip(1)
                                                .map((column) {
                                                  final stats =
                                                      _statsForCaseCell(
                                                        nominative,
                                                        column.key,
                                                      );
                                                  return _analyticsHeatColor(
                                                    stats['correct']!,
                                                    stats['total']!,
                                                    colorScheme,
                                                  );
                                                })
                                                .toList();
                                            final tooltips = _tableColumns
                                                .skip(1)
                                                .map((column) {
                                                  final stats =
                                                      _statsForCaseCell(
                                                        nominative,
                                                        column.key,
                                                      );
                                                  return '$nominative -> ${column.key}: ${stats['correct']}/${stats['total']} correct';
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
                  subtitle: const Text(
                    'Choose which pronouns and cases appear in the quiz.',
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
                        Text(
                          'Active Pronouns',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: List.generate(
                            listPronounsGermanNominativeDisplay.length,
                            (i) => FilterChip(
                              label: Text(
                                listPronounsGermanNominativeDisplay[i],
                              ),
                              selected: _enabledPronounIndices.contains(i),
                              onSelected: (_) => _togglePronoun(i),
                            ),
                          ),
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
                          children: _quizCases
                              .map(
                                (c) => FilterChip(
                                  label: Text(c.label),
                                  selected: _enabledCaseLabels.contains(
                                    c.label,
                                  ),
                                  onSelected: (_) => _toggleCase(c.label),
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

class _FireworkParticle {
  const _FireworkParticle({
    required this.origin,
    required this.direction,
    required this.speed,
    required this.size,
    required this.color,
  });

  final Offset origin;
  final Offset direction;
  final double speed;
  final double size;
  final Color color;
}

class _FireworksPainter extends CustomPainter {
  const _FireworksPainter({required this.progress, required this.particles});

  final double progress;
  final List<_FireworkParticle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    if (particles.isEmpty) return;

    final eased = Curves.easeOutCubic.transform(progress.clamp(0.0, 1.0));
    final fade = (1 - progress).clamp(0.0, 1.0);
    final paint = Paint()..style = PaintingStyle.fill;

    for (final particle in particles) {
      final start = Offset(
        particle.origin.dx * size.width,
        particle.origin.dy * size.height,
      );
      final position = start + (particle.direction * particle.speed * eased);

      // solid rotated square particle (confetti-like)
      paint.color = particle.color.withValues(alpha: 0.95 * fade);
      final side = particle.size * 1.9;
      final rotation =
          atan2(particle.direction.dy, particle.direction.dx) + progress * 8.0;
      canvas.save();
      canvas.translate(position.dx, position.dy);
      canvas.rotate(rotation);
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: side, height: side),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _FireworksPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.particles != particles;
  }
}
