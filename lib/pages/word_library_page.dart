import 'package:flutter/material.dart';

import '../data/content/asset_course_provider.dart';
import '../data/content/noun_collection.dart';
import '../data/noun_database.dart';
import '../models/course_session.dart';
import '../models/noun_settings.dart';
import '../models/quiz_config.dart';
import '../widgets/app_drawer.dart';

/// Lets the user enable/disable individual nouns (and bulk-toggle by category or
/// difficulty) for quizzes that draw from the active course's **shared** noun
/// list — loaded from `assets/content/shared/nouns/<lang>.json` (the learned
/// language) rather than compiled in, so multiple courses for the same language
/// share one list.
class WordLibraryPage extends StatefulWidget {
  const WordLibraryPage({super.key});

  @override
  State<WordLibraryPage> createState() => _WordLibraryPageState();
}

class _WordLibraryPageState extends State<WordLibraryPage> {
  late final Future<NounCollection> _collectionFuture = _load();

  Future<NounCollection> _load() async {
    await NounSettings.instance.load();
    final lang = CourseSession.instance.activeCourse.learnLocale.split('-').first;
    return courseContentProvider.nounCollection(lang);
  }

  List<String> _orderedCategoryKeys(List<GermanNoun> nouns) {
    final seen = <String>{};
    final result = <String>[];
    for (final n in nouns) {
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
    setState(() => NounSettings.instance.toggle(noun));
  }

  void _toggleGroup(Iterable<GermanNoun> nouns) {
    final names = nouns.map((n) => n.noun).toList();
    final allEnabled = names.every(NounSettings.instance.isEnabled);
    setState(() => NounSettings.instance.setEnabled(names, !allEnabled));
  }

  List<Widget> _buildCategorySections(NounCollection collection) {
    final widgets = <Widget>[];
    for (final catKey in _orderedCategoryKeys(collection.nouns)) {
      final nouns =
          collection.nouns.where((n) => n.categories.contains(catKey)).toList();
      final enabledCount =
          nouns.where((n) => NounSettings.instance.isEnabled(n.noun)).length;
      final label = collection.categoryDisplayNames[catKey] ?? catKey;
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
                        label: Text(
                          NounSettings.instance.showEnglishFor(
                                NounSettings.wordLibraryPageKey,
                              )
                              ? '${n.noun} (${n.english})'
                              : n.noun,
                          style: TextStyle(
                            color: NounSettings.instance.colorForGender(n.gender),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
    return Scaffold(
      appBar: AppBar(title: const Text('Word Library')),
      drawer: const AppDrawer(currentPage: AppPage.wordLibrary),
      body: SafeArea(
        child: FutureBuilder<NounCollection>(
          future: _collectionFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final collection = snapshot.data!;
            if (collection.isEmpty) {
              return const Center(
                child: Text('No word list for this course.'),
              );
            }
            return _content(context, collection);
          },
        ),
      ),
    );
  }

  Widget _content(BuildContext context, NounCollection collection) {
    final nouns = collection.nouns;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Enable or disable words used by the Artikel and Nouns & '
          'Articles quizzes.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 6),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show English meanings'),
          value: NounSettings.instance.showEnglishFor(
            NounSettings.wordLibraryPageKey,
          ),
          onChanged: (value) {
            setState(() {
              NounSettings.instance.setShowEnglishFor(
                NounSettings.wordLibraryPageKey,
                value,
              );
            });
          },
        ),
        const SizedBox(height: 6),
        Text('Difficulty', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: NounDifficulty.values.map((d) {
            final group = nouns.where((n) => n.difficulty == d);
            final allEnabled =
                group.every((n) => NounSettings.instance.isEnabled(n.noun));
            return FilterChip(
              label: Text(_difficultyLabel(d)),
              selected: allEnabled,
              onSelected: (_) => _toggleGroup(group),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        Text('Category', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: _orderedCategoryKeys(nouns).map((catKey) {
            final group = nouns.where((n) => n.categories.contains(catKey));
            final allEnabled =
                group.every((n) => NounSettings.instance.isEnabled(n.noun));
            final label = collection.categoryDisplayNames[catKey] ?? catKey;
            return FilterChip(
              label: Text(label),
              selected: allEnabled,
              onSelected: (_) => _toggleGroup(group),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        ..._buildCategorySections(collection),
      ],
    );
  }
}
