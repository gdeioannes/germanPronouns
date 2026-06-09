import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';
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
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'German Pronouns Help'),
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
  static const int _maxStoredHistory = 100;

  int _score = 0;
  int _currentPronounIndex = 0;
  int _currentCaseIndex = 0;
  String _feedback = '';
  String _currentReferenceSentence = '';
  bool _showFireworks = false;
  late final AnimationController _fireworksController;
  List<_FireworkParticle> _fireworkParticles = const [];
  List<Map<String, dynamic>> _answerHistory = [];
  Map<String, int> _mistakesByCase = {};

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

  void _triggerFireworks() {
    final colorScheme = Theme.of(context).colorScheme;
    final palette = [
      colorScheme.primary,
      colorScheme.tertiary,
      Colors.orange,
      Colors.amber,
      Colors.lightBlue,
      Colors.green,
    ];

    final particleCount = 40;
    final particles = List.generate(particleCount, (_) {
      final angle = _random.nextDouble() * 2 * pi;
      final direction = Offset(cos(angle), sin(angle));
      return _FireworkParticle(
        origin: Offset(
          0.2 + _random.nextDouble() * 0.6,
          0.3 + _random.nextDouble() * 0.25,
        ),
        direction: direction,
        speed: 52 + _random.nextDouble() * 46,
        size: 1.9 + _random.nextDouble() * 2.3,
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

    List<Map<String, dynamic>> loadedHistory = [];
    Map<String, int> loadedMistakes = {};

    if (historyJson != null && historyJson.isNotEmpty) {
      final decoded = jsonDecode(historyJson);
      if (decoded is List) {
        loadedHistory = decoded
            .whereType<Map>()
            .map((item) => item.map((k, v) => MapEntry(k.toString(), v)))
            .toList();
      }
    }

    if (mistakesJson != null && mistakesJson.isNotEmpty) {
      final decoded = jsonDecode(mistakesJson);
      if (decoded is Map) {
        loadedMistakes = decoded.map(
          (k, v) => MapEntry(k.toString(), (v as num).toInt()),
        );
      }
    }

    if (!mounted) return;
    setState(() {
      _score = storedScore;
      _answerHistory = loadedHistory;
      _mistakesByCase = loadedMistakes;
    });
  }

  Future<void> _saveStoredStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_scoreStorageKey, _score);
    await prefs.setString(_historyStorageKey, jsonEncode(_answerHistory));
    await prefs.setString(_mistakesStorageKey, jsonEncode(_mistakesByCase));
  }

  String _pickCaseGroup() {
    final total = _groupChanceWeights.values.fold<double>(0, (a, b) => a + b);
    var threshold = _random.nextDouble() * total;

    for (final entry in _groupChanceWeights.entries) {
      threshold -= entry.value;
      if (threshold <= 0) {
        return entry.key;
      }
    }
    return _groupChanceWeights.keys.first;
  }

  void _nextQuestion() {
    _currentPronounIndex = _random.nextInt(listPronounsGermanNominative.length);
    final selectedGroup = _pickCaseGroup();
    final casesInGroup = _quizCases
        .where((quizCase) => quizCase.group == selectedGroup)
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
  }

  Future<void> _resetProgress() async {
    setState(() {
      _score = 0;
      _answerHistory = [];
      _mistakesByCase = {};
      _feedback = '';
    });
    await _saveStoredStats();
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
    var shouldCelebrate = false;

    setState(() {
      if (isCorrect) {
        _score += 1;
        shouldCelebrate = true;
        _feedback =
            'Correct: $nominative -> $caseLabel = $correctAnswer (+1 point)';
      } else {
        _score -= 1;
        _feedback =
            'Incorrect: $nominative -> $caseLabel. You wrote "$userAnswerRaw", correct is "$correctAnswer" (-1 point)';
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
      _triggerFireworks();
    }

    _saveStoredStats();
    _requestAnswerFocus();
  }

  void _newQuestion() {
    setState(() {
      _feedback = '';
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentCase = _quizCases[_currentCaseIndex].label;
    final currentPronoun = listPronounsGermanNominative[_currentPronounIndex];
    final recentHistory = _answerHistory.take(5).toList();
    final topMistakes = _mistakesByCase.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(widget.title),
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
            const SizedBox(height: 16),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Quiz',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            Chip(
                              label: Text('Score $_score'),
                              avatar: const Icon(Icons.star_rounded, size: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth >= 760;
                            final panelMinHeight = isWide ? 250.0 : 150.0;

                            final questionBox = Card(
                              color: colorScheme.primaryContainer.withValues(
                                alpha: 0.45,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                                side: BorderSide(
                                  color: colorScheme.outlineVariant,
                                ),
                              ),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: panelMinHeight,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 12),
                                      Text(
                                        'Pronoun',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelLarge,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        currentPronoun,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Case',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelLarge,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        currentCase,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      if (isWide)
                                        const Spacer()
                                      else
                                        const SizedBox(height: 12),
                                      Text(
                                        'Reference',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelLarge,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        _currentReferenceSentence,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.italic,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );

                            final answerBox = Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                                side: BorderSide(
                                  color: colorScheme.outlineVariant,
                                ),
                              ),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: panelMinHeight,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Answer',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      const SizedBox(height: 12),
                                      TextField(
                                        controller: _answerController,
                                        focusNode: _answerFocusNode,
                                        autofocus: true,
                                        textInputAction: TextInputAction.done,
                                        minLines: isWide ? 2 : 1,
                                        maxLines: isWide ? 3 : 2,
                                        decoration: InputDecoration(
                                          labelText: 'Type here',
                                          hintText: 'e.g. meinen',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              18,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: colorScheme
                                              .surfaceContainerHighest
                                              .withValues(alpha: 0.35),
                                        ),
                                        onSubmitted: (_) => _submitAnswer(),
                                      ),
                                      const SizedBox(height: 14),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: FilledButton.icon(
                                              onPressed: _submitAnswer,
                                              icon: const Icon(
                                                Icons.check_rounded,
                                              ),
                                              label: const Text('Check'),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          OutlinedButton.icon(
                                            onPressed: _newQuestion,
                                            icon: const Icon(
                                              Icons.skip_next_rounded,
                                            ),
                                            label: const Text('Next'),
                                          ),
                                        ],
                                      ),
                                      if (_feedback.isNotEmpty) ...[
                                        const SizedBox(height: 16),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(14),
                                          decoration: BoxDecoration(
                                            color:
                                                _feedback.startsWith('Correct')
                                                ? colorScheme.tertiaryContainer
                                                : colorScheme.errorContainer,
                                            borderRadius: BorderRadius.circular(
                                              18,
                                            ),
                                          ),
                                          child: Text(
                                            _feedback,
                                            style: TextStyle(
                                              color:
                                                  _feedback.startsWith(
                                                    'Correct',
                                                  )
                                                  ? colorScheme
                                                        .onTertiaryContainer
                                                  : colorScheme
                                                        .onErrorContainer,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            );

                            if (isWide) {
                              return IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(child: questionBox),
                                    const SizedBox(width: 16),
                                    Expanded(child: answerBox),
                                  ],
                                ),
                              );
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                questionBox,
                                const SizedBox(height: 16),
                                answerBox,
                              ],
                            );
                          },
                        ),
                      ],
                    ),
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
                                index < listPronounsGermanNominative.length;
                                index++
                              )
                                buildFixedCell(
                                  listPronounsGermanNominative[index],
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
                                            listPronounsGermanNominative.length;
                                        index++
                                      )
                                        buildScrollableRow(
                                          _tableColumns
                                              .skip(1)
                                              .map(
                                                (column) => column.value[index],
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
            const SizedBox(height: 16),
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
                            color: ok ? colorScheme.primary : colorScheme.error,
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
            const SizedBox(height: 16),
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
                        final brightness = ThemeData.estimateBrightnessForColor(
                          bg,
                        );
                        final fg = brightness == Brightness.dark
                            ? Colors.white
                            : colorScheme.onSurface;

                        return Tooltip(
                          message: tooltip ?? text,
                          child: Container(
                            width: fixedColumnWidth,
                            height: rowHeight,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
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
                                  : (backgrounds?[idx] ?? colorScheme.surface);
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
                                  final stats = _statsForNominative(nominative);
                                  final bg = _analyticsHeatColor(
                                    stats['correct']!,
                                    stats['total']!,
                                    colorScheme,
                                  );
                                  return buildFixedCell(
                                    nominative,
                                    background: bg,
                                    tooltip:
                                        '$nominative: ${stats['correct']}/${stats['total']} correct',
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
                                            listPronounsGermanNominative.length;
                                        index++
                                      )
                                        () {
                                          final nominative =
                                              listPronounsGermanNominative[index];
                                          final values = _tableColumns
                                              .skip(1)
                                              .map(
                                                (column) => column.value[index],
                                              )
                                              .toList();
                                          final backgrounds = _tableColumns
                                              .skip(1)
                                              .map((column) {
                                                final stats = _statsForCaseCell(
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
                                                final stats = _statsForCaseCell(
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
