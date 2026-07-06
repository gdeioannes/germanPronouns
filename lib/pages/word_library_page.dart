import 'package:flutter/material.dart';

import '../data/content/asset_course_provider.dart';
import '../data/content/noun_collection.dart';
import '../data/content/verb_collection.dart';
import '../data/noun_database.dart';
import '../models/course_session.dart';
import '../models/noun_settings.dart';
import '../models/quiz_config.dart';
import '../widgets/app_drawer.dart';
import '../widgets/coin_balance_pill.dart';
import '../widgets/word_detail_panels.dart';

/// The active course's vocabulary reference, in two tabs backed by the shared
/// per-language collections (`assets/content/shared/{nouns,verbs}/<lang>.json`,
/// keyed by the learned language so multiple courses share one list):
///
///  * **Nouns** — tap any word for its meaning in the course's main (UI)
///    language (plus article/plural/example + audio); the chip toggle and the
///    bulk category/difficulty toggles pick which words the Artikel and
///    Nouns & Articles quizzes draw from.
///  * **Verbs** — tap any verb for its meaning and its language's five-plus
///    most useful conjugation tables.
class WordLibraryPage extends StatefulWidget {
  const WordLibraryPage({super.key});

  @override
  State<WordLibraryPage> createState() => _WordLibraryPageState();
}

class _WordLibraryPageState extends State<WordLibraryPage> {
  late final Future<NounCollection> _collectionFuture = _loadNouns();
  late final Future<VerbCollection> _verbsFuture = _loadVerbs();

  String get _lang =>
      CourseSession.instance.activeCourse.learnLocale.split('-').first;

  String get _uiLang => CourseSession.instance.activeCourse.uiLang.name;

  Future<NounCollection> _loadNouns() async {
    await NounSettings.instance.load();
    return courseContentProvider.nounCollection(_lang);
  }

  Future<VerbCollection> _loadVerbs() =>
      courseContentProvider.verbCollection(_lang);

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

  String _difficultyLabel(NounDifficulty d) {
    final strings = CourseSession.instance.strings;
    return switch (d) {
      NounDifficulty.beginner => strings.difficultyBeginner,
      NounDifficulty.intermediate => strings.difficultyIntermediate,
      NounDifficulty.advanced => strings.difficultyAdvanced,
    };
  }

  void _openNoun(GermanNoun noun) {
    // Rebuild on close: the panel's include-in-quizzes switch changes the
    // chips' selected state.
    showNounDetailPanel(context, noun).whenComplete(() {
      if (mounted) setState(() {});
    });
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
                              ? '${n.noun} (${n.meaningFor(_uiLang)})'
                              : n.noun,
                          style: TextStyle(
                            color: NounSettings.instance.colorForGender(n.gender),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        selected: NounSettings.instance.isEnabled(n.noun),
                        onSelected: (_) => _openNoun(n),
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
    final strings = CourseSession.instance.strings;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(strings.wordLibrary),
          actions: const [CoinBalancePill()],
          bottom: TabBar(
            tabs: [Tab(text: strings.nouns), Tab(text: strings.verbs)],
          ),
        ),
        drawer: const AppDrawer(currentPage: AppPage.wordLibrary),
        body: SafeArea(
          child: TabBarView(children: [_nounsTab(), _verbsTab()]),
        ),
      ),
    );
  }

  Widget _nounsTab() {
    final strings = CourseSession.instance.strings;
    return FutureBuilder<NounCollection>(
      future: _collectionFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final collection = snapshot.data!;
        if (collection.isEmpty) {
          return Center(child: Text(strings.noWordList));
        }
        return _nounsContent(context, collection);
      },
    );
  }

  Widget _nounsContent(BuildContext context, NounCollection collection) {
    final strings = CourseSession.instance.strings;
    final nouns = collection.nouns;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          strings.wordLibraryIntro,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 6),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(strings.showMeanings),
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
        Text(strings.difficulty, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: NounDifficulty.values.map((d) {
            final group = nouns.where((n) => n.difficulty == d);
            if (group.isEmpty) return const SizedBox.shrink();
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
        Text(strings.category, style: Theme.of(context).textTheme.labelLarge),
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

  Widget _verbsTab() {
    final strings = CourseSession.instance.strings;
    return FutureBuilder<VerbCollection>(
      future: _verbsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final collection = snapshot.data!;
        if (collection.isEmpty) {
          return Center(child: Text(strings.noVerbList));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: collection.verbs.length,
          itemBuilder: (context, index) {
            final verb = collection.verbs[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(
                  verb.verb,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(verb.meaningFor(_uiLang)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => showVerbDetailPanel(context, verb),
              ),
            );
          },
        );
      },
    );
  }
}
