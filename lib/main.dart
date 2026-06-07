import 'dart:math';

import 'package:flutter/material.dart';

var listPronounsGermanNominative = [
  'ich',
  'du',
  'er',
  'sie',
  'es',
  'wir',
  'ihr',
  'sie',
  'Sie',
];

var listPronounsGermanAkusative = [
  'mich',
  'dich',
  'ihn',
  'sie',
  'es',
  'uns',
  'euch',
  'sie',
  'Sie',
];

var listPronounsGermanDative = [
  'mir',
  'dir',
  'ihm',
  'ihr',
  'ihm',
  'uns',
  'euch',
  'ihnen',
  'Ihnen',
];

var listPronounsGermanGenitive = [
  'meiner',
  'deiner',
  'seiner',
  'ihrer',
  'seiner',
  'unser',
  'euer',
  'ihrer',
  'Ihrer',
];

var listPronounsGermanReflexive = [
  'mir',
  'dir',
  'sich',
  'sich',
  'sich',
  'uns',
  'euch',
  'sich',
  'sich',
];

var listPronounsGermanPossessiveMasculine = [
  'mein',
  'dein',
  'sein',
  'ihr',
  'sein',
  'unser',
  'euer',
  'ihr',
  'Ihr',
];

var listPronounsGermanPossessiveMasculineAccusative = [
  'meinen',
  'deinen',
  'seinen',
  'ihren',
  'seinen',
  'unseren',
  'euren',
  'ihren',
  'Ihren',
];

var listPronounsGermanPossessiveMasculineDative = [
  'meinem',
  'deinem',
  'seinem',
  'ihrem',
  'seinem',
  'unserem',
  'eurem',
  'ihrem',
  'Ihrem',
];

var listPronounsGermanPossessiveMasculineGenitive = [
  'meines',
  'deines',
  'seines',
  'ihres',
  'seines',
  'unseres',
  'eures',
  'ihres',
  'Ihres',
];

var listPronounsGermanPossessiveFeminine = [
  'meine',
  'deine',
  'seine',
  'ihre',
  'seine',
  'unsere',
  'eure',
  'ihre',
  'Ihre',
];

var listPronounsGermanPossessiveFeminineAccusative = [
  'meine',
  'deine',
  'seine',
  'ihre',
  'seine',
  'unsere',
  'eure',
  'ihre',
  'Ihre',
];

var listPronounsGermanPossessiveFeminineDative = [
  'meiner',
  'deiner',
  'seiner',
  'ihrer',
  'seiner',
  'unserer',
  'eurer',
  'ihrer',
  'Ihrer',
];

var listPronounsGermanPossessiveFeminineGenitive = [
  'meiner',
  'deiner',
  'seiner',
  'ihrer',
  'seiner',
  'unserer',
  'eurer',
  'ihrer',
  'Ihrer',
];

var listPronounsGermanPossessiveNeuter = [
  'mein',
  'dein',
  'sein',
  'ihr',
  'sein',
  'unser',
  'euer',
  'ihr',
  'Ihr',
];

var listPronounsGermanPossessiveNeuterAccusative = [
  'mein',
  'dein',
  'sein',
  'ihr',
  'sein',
  'unser',
  'euer',
  'ihr',
  'Ihr',
];

var listPronounsGermanPossessiveNeuterDative = [
  'meinem',
  'deinem',
  'seinem',
  'ihrem',
  'seinem',
  'unserem',
  'eurem',
  'ihrem',
  'Ihrem',
];

var listPronounsGermanPossessiveNeuterGenitive = [
  'meines',
  'deines',
  'seines',
  'ihres',
  'seines',
  'unseres',
  'eures',
  'ihres',
  'Ihres',
];

var listPronounsGermanPossessivePlural = [
  'meine',
  'deine',
  'seine',
  'ihre',
  'seine',
  'unsere',
  'eure',
  'ihre',
  'Ihre',
];

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

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _answerController = TextEditingController();
  final ScrollController _tableScrollController = ScrollController();
  final Random _random = Random();

  int _score = 0;
  int _currentPronounIndex = 0;
  int _currentCaseIndex = 0;
  String _feedback = '';

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

  final List<MapEntry<String, List<String>>> _quizCases = [
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

  @override
  void initState() {
    super.initState();
    _nextQuestion();
  }

  @override
  void dispose() {
    _answerController.dispose();
    _tableScrollController.dispose();
    super.dispose();
  }

  void _nextQuestion() {
    _currentPronounIndex = _random.nextInt(listPronounsGermanNominative.length);
    _currentCaseIndex = _random.nextInt(_quizCases.length);
  }

  void _submitAnswer() {
    final userAnswer = _answerController.text.trim().toLowerCase();
    final correctAnswer =
        _quizCases[_currentCaseIndex].value[_currentPronounIndex];

    setState(() {
      if (userAnswer == correctAnswer.toLowerCase()) {
        _score += 1;
        _feedback = 'Correct! +1 point';
      } else {
        _score -= 1;
        _feedback = 'Incorrect. Correct answer: $correctAnswer (-1 point)';
      }
      _answerController.clear();
      _nextQuestion();
    });
  }

  void _newQuestion() {
    setState(() {
      _feedback = '';
      _answerController.clear();
      _nextQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentCase = _quizCases[_currentCaseIndex].key;
    final currentPronoun = listPronounsGermanNominative[_currentPronounIndex];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              elevation: 0,
              color: colorScheme.primaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'German pronouns and articles',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Quiz first, reference table second.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              clipBehavior: Clip.antiAlias,
              child: Padding(
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

                        final questionBox = Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer.withOpacity(
                              0.45,
                            ),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: colorScheme.outlineVariant,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pronoun',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                currentPronoun,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Case',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                currentCase,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        );

                        final answerBox = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your answer',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _answerController,
                              textInputAction: TextInputAction.done,
                              minLines: 3,
                              maxLines: 5,
                              decoration: InputDecoration(
                                labelText: 'Type here',
                                hintText: 'e.g. meinen',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                filled: true,
                                fillColor: colorScheme.surfaceContainerHighest
                                    .withOpacity(0.35),
                              ),
                              onSubmitted: (_) => _submitAnswer(),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: FilledButton.icon(
                                    onPressed: _submitAnswer,
                                    icon: const Icon(Icons.check_rounded),
                                    label: const Text('Check'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                OutlinedButton.icon(
                                  onPressed: _newQuestion,
                                  icon: const Icon(Icons.skip_next_rounded),
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
                                  color: _feedback.startsWith('Correct')
                                      ? colorScheme.tertiaryContainer
                                      : colorScheme.errorContainer,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Text(
                                  _feedback,
                                  style: TextStyle(
                                    color: _feedback.startsWith('Correct')
                                        ? colorScheme.onTertiaryContainer
                                        : colorScheme.onErrorContainer,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        );

                        if (isWide) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 2, child: questionBox),
                              const SizedBox(width: 16),
                              Expanded(flex: 3, child: answerBox),
                            ],
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
                  'Help memory',
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
                                            .withOpacity(0.35),
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
                                                    .withOpacity(0.35),
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
          ],
        ),
      ),
    );
  }
}
