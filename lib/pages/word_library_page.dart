import 'package:flutter/material.dart';

import '../data/noun_database.dart';
import '../models/noun_settings.dart';
import '../models/quiz_config.dart';
import '../widgets/app_drawer.dart';

/// Lets the user enable/disable individual nouns (and bulk-toggle by
/// category or difficulty) for quizzes that draw from [germanNouns]
/// (Artikel and Nouns & Articles).
class WordLibraryPage extends StatefulWidget {
  const WordLibraryPage({super.key});

  @override
  State<WordLibraryPage> createState() => _WordLibraryPageState();
}

class _WordLibraryPageState extends State<WordLibraryPage> {
  @override
  void initState() {
    super.initState();
    NounSettings.instance.load().then((_) {
      if (mounted) setState(() {});
    });
  }

  List<String> _orderedCategoryKeys() {
    final seen = <String>{};
    final result = <String>[];
    for (final n in germanNouns) {
      for (final c in n.categories) {
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

  void _toggleNoun(String noun) {
    setState(() {
      NounSettings.instance.toggle(noun);
    });
  }

  void _toggleGroup(Iterable<GermanNoun> nouns) {
    final names = nouns.map((n) => n.noun).toList();
    final allEnabled = names.every(NounSettings.instance.isEnabled);
    setState(() {
      NounSettings.instance.setEnabled(names, !allEnabled);
    });
  }

  List<Widget> _buildCategorySections() {
    final widgets = <Widget>[];
    for (final catKey in _orderedCategoryKeys()) {
      final nouns = germanNouns
          .where((n) => n.categories.contains(catKey))
          .toList();
      final enabledCount = nouns
          .where((n) => NounSettings.instance.isEnabled(n.noun))
          .length;
      final label = nounCategoryDisplayNames[catKey] ?? catKey;
      widgets.add(
        Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ExpansionTile(
            title: Text('$label ($enabledCount/${nouns.length})'),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: nouns
                    .map(
                      (n) => FilterChip(
                        label: Text(n.noun),
                        selected: NounSettings.instance.isEnabled(n.noun),
                        onSelected: (_) => _toggleNoun(n.noun),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.inversePrimary,
        centerTitle: true,
        title: const Text(
          'Word Library',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
      ),
      drawer: const AppDrawer(currentPage: AppPage.wordLibrary),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Enable or disable words used by the Artikel and Nouns & '
              'Articles quizzes.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text('Difficulty', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: NounDifficulty.values.map((d) {
                final nouns = germanNouns.where((n) => n.difficulty == d);
                final allEnabled = nouns.every(
                  (n) => NounSettings.instance.isEnabled(n.noun),
                );
                return FilterChip(
                  label: Text(_difficultyLabel(d)),
                  selected: allEnabled,
                  onSelected: (_) => _toggleGroup(nouns),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Text('Category', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: _orderedCategoryKeys().map((catKey) {
                final nouns = germanNouns.where(
                  (n) => n.categories.contains(catKey),
                );
                final allEnabled = nouns.every(
                  (n) => NounSettings.instance.isEnabled(n.noun),
                );
                final label = nounCategoryDisplayNames[catKey] ?? catKey;
                return FilterChip(
                  label: Text(label),
                  selected: allEnabled,
                  onSelected: (_) => _toggleGroup(nouns),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            ..._buildCategorySections(),
          ],
        ),
      ),
    );
  }
}
