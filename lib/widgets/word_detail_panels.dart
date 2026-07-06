import 'package:flutter/material.dart';

import '../data/content/verb_collection.dart';
import '../data/noun_database.dart';
import '../models/course_session.dart';
import '../models/noun_settings.dart';
import 'speak_icon_button.dart';

/// Word reference panels (Word Library taps + word taps in quizzes): tap
/// a noun to see its meaning in the course's main language (plus
/// article/gender, plural and an example), tap a verb to see its meaning and
/// conjugation tables. The word and its meaning are **pinned** above the
/// scrolling body, so the translation stays visible however far the tables
/// are scrolled. Phone-width screens get a modal bottom sheet; wider windows
/// get a centered dialog (see [_showPanel]).

/// The definite article shown before a noun, for the languages that have one.
/// Czech/English/Chinese return null (Czech shows a gender label instead).
String? _articleFor(String lang, String gender) => switch (lang) {
  'de' => const {'m': 'der', 'f': 'die', 'n': 'das'}[gender],
  'es' => const {'m': 'el', 'f': 'la'}[gender],
  _ => null,
};

/// Fills the article-blank of a shared-list example sentence (e.g.
/// "____ Hund ist hier.") with the noun's article, capitalized when the blank
/// opens the sentence. Sentences without a blank pass through unchanged.
String _filledSentence(String sentence, String? article) {
  if (article == null || !sentence.contains('____')) return sentence;
  final atStart = sentence.startsWith('____');
  final a = atStart
      ? article[0].toUpperCase() + article.substring(1)
      : article;
  return sentence.replaceFirst('____', a);
}

/// Panel scaffold shared by both panels: [header] stays pinned on top;
/// [children] scroll beneath it.
///
/// On phone-width screens this is a modal bottom sheet (whose scroll also
/// drags the sheet taller, via the DraggableScrollableSheet controller). On
/// wider windows a bottom sheet strands the tables half off-screen with the
/// tail unreadable, so the same content opens as a centered dialog that sizes
/// to its content and scrolls inside.
Future<void> _showPanel(
  BuildContext context, {
  required List<Widget> Function(BuildContext) header,
  required List<Widget> Function(BuildContext) children,
}) {
  final screen = MediaQuery.sizeOf(context);
  if (screen.width >= 600) {
    return showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 520,
            maxHeight: screen.height * 0.85,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: header(context),
                ),
              ),
              const Divider(height: 20),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  children: children(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    // The learner shell stacks the room door tab over the *shell* navigator,
    // so the sheet must ride the root navigator to render above the tab
    // (which otherwise floats over the sheet's last rows and steals their
    // taps).
    useRootNavigator: true,
    useSafeArea: true,
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (context, controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: header(context),
            ),
          ),
          const Divider(height: 20),
          Expanded(
            child: ListView(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              children: children(context),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _labeledRow(BuildContext context, String label, Widget value) => Padding(
  padding: const EdgeInsets.only(top: 12),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: Theme.of(context).textTheme.labelMedium),
      const SizedBox(height: 2),
      value,
    ],
  ),
);

/// The pinned word headline: the word (optionally colored) with its speak
/// icon, followed by the meaning in the course's main (UI) language.
List<Widget> _wordHeader(
  BuildContext context, {
  required String headline,
  required String meaning,
  Color? color,
  String? subLabel,
}) {
  final theme = Theme.of(context);
  final strings = CourseSession.instance.strings;
  return [
    Row(
      children: [
        Expanded(
          child: Text(
            headline,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SpeakIconButton(text: headline, size: 26),
      ],
    ),
    if (subLabel != null)
      Text(subLabel, style: theme.textTheme.labelMedium),
    _labeledRow(
      context,
      strings.meaning,
      Text(meaning, style: theme.textTheme.titleMedium),
    ),
    const SizedBox(height: 4),
  ];
}

/// Opens the tap-a-noun reference panel: the word with its article (colored by
/// gender) and the meaning in the course's **main** (UI) language pinned on
/// top; plural, example and the include-in-quizzes switch below. Resolves when
/// the sheet closes, so the caller can refresh chips.
Future<void> showNounDetailPanel(BuildContext context, GermanNoun noun) {
  final session = CourseSession.instance;
  final strings = session.strings;
  final course = session.activeCourse;
  final lang = course.learnLocale.split('-').first;
  final uiLang = course.uiLang.name;
  final article = _articleFor(lang, noun.gender);
  final headline = article == null ? noun.noun : '$article ${noun.noun}';
  final genderLabel = article != null
      ? null
      : switch (noun.gender) {
          'm' => strings.masculine,
          'f' => strings.feminine,
          'n' => strings.neuter,
          _ => null,
        };
  return _showPanel(
    context,
    header: (context) => _wordHeader(
      context,
      headline: headline,
      meaning: noun.meaningFor(uiLang),
      color: noun.gender == '-'
          ? null
          : NounSettings.instance.colorForGender(noun.gender),
      subLabel: genderLabel,
    ),
    children: (context) {
      final theme = Theme.of(context);
      return [
        if (noun.plural != null)
          _labeledRow(
            context,
            strings.pluralLabel,
            Row(
              children: [
                Expanded(
                  child: Text(noun.plural!, style: theme.textTheme.titleMedium),
                ),
                SpeakIconButton(text: noun.plural!),
              ],
            ),
          ),
        if (noun.sentence != null)
          _labeledRow(
            context,
            strings.exampleLabel,
            Row(
              children: [
                Expanded(
                  child: Text(
                    _filledSentence(noun.sentence!, article),
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
                SpeakIconButton(text: _filledSentence(noun.sentence!, article)),
              ],
            ),
          ),
        const SizedBox(height: 8),
        StatefulBuilder(
          builder: (context, setSheetState) => SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(strings.includeInQuizzes),
            value: NounSettings.instance.isEnabled(noun.noun),
            onChanged: (_) => setSheetState(
              () => NounSettings.instance.toggle(noun.noun),
            ),
          ),
        ),
      ];
    },
  );
}

/// Opens the tap-a-verb reference panel: the verb with audio and its meaning
/// in the course's main (UI) language pinned on top; below, one table per
/// conjugation set (the language's five-plus most useful tenses/patterns),
/// each row speakable.
Future<void> showVerbDetailPanel(BuildContext context, VerbEntry verb) {
  final session = CourseSession.instance;
  final uiLang = session.activeCourse.uiLang.name;
  return _showPanel(
    context,
    header: (context) => _wordHeader(
      context,
      headline: verb.verb,
      meaning: verb.meaningFor(uiLang),
    ),
    children: (context) {
      final theme = Theme.of(context);
      final personStyle = theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      );
      final formStyle = theme.textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w600,
      );
      return [
        for (final set in verb.sets) ...[
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 4),
            child: Text(
              set.label,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          for (final form in set.forms)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  SizedBox(
                    width: 96,
                    child: Text(form.person, style: personStyle),
                  ),
                  Expanded(child: Text(form.form, style: formStyle)),
                  SpeakIconButton(text: form.form, size: 16),
                ],
              ),
            ),
        ],
      ];
    },
  );
}
