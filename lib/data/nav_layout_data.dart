import 'package:flutter/material.dart';

import '../models/quiz_content.dart';
import '../theme/app_theme.dart';

/// Curated icon set for the back-office icon picker. Keyed by a stable string
/// stored in [NavItem.iconKey]. Referencing const `Icons.*` here keeps these
/// glyphs through `--tree-shake-icons` (icons chosen dynamically by code point
/// would be stripped from the build).
const Map<String, IconData> navIconChoices = {
  'book': Icons.menu_book_rounded,
  'groups': Icons.groups_rounded,
  'article': Icons.article_rounded,
  'signpost': Icons.signpost_rounded,
  'abc': Icons.abc_rounded,
  'flag': Icons.flag_rounded,
  'star': Icons.star_rounded,
  'bolt': Icons.bolt_rounded,
  'school': Icons.school_rounded,
  'translate': Icons.translate_rounded,
  'numbers': Icons.numbers_rounded,
  'event': Icons.event_rounded,
  'schedule': Icons.schedule_rounded,
  'palette': Icons.palette_rounded,
  'people': Icons.people_rounded,
  'category': Icons.category_rounded,
  'spellcheck': Icons.spellcheck_rounded,
  'library': Icons.library_books_rounded,
  'settings': Icons.settings_rounded,
  'edit': Icons.edit_note_rounded,
};

/// Resolves an item's icon: its [iconKey] from [navIconChoices], else
/// [fallback].
IconData navIconFor(String? iconKey, IconData fallback) =>
    iconKey == null ? fallback : (navIconChoices[iconKey] ?? fallback);

/// The default tile icon for a quiz of [kind] — the single source of truth
/// shared by the drawer and the course home so both surfaces show the same
/// icon per kind: reading → book, fill-in "question" quizzes → quiz card,
/// listen-&-repeat → voice. An explicit per-item iconKey or a known grammar
/// section icon still wins over this default where those apply.
IconData quizKindIcon(QuizKind kind) => switch (kind) {
  QuizKind.speakRepeat => Icons.record_voice_over_rounded,
  QuizKind.reading => Icons.menu_book_rounded,
  QuizKind.listening => Icons.hearing_rounded,
  QuizKind.dictation => Icons.spellcheck_rounded,
  QuizKind.fillBlank => Icons.quiz_rounded,
};

/// The default badge/accent color for a quiz of [kind], paired with
/// [quizKindIcon] so the drawer and the course home tint each kind the same way:
/// reading, fill-in "question", and listen-&-repeat quizzes each get their own
/// accent. A known grammar section accent or an explicit per-item colorIndex
/// still wins over this default where those apply.
Color quizKindColor(QuizKind kind) => switch (kind) {
  QuizKind.speakRepeat => kSectionAccentColors[2],
  QuizKind.reading => kSectionAccentColors[1],
  QuizKind.listening => kSectionAccentColors[3],
  QuizKind.dictation => kSectionAccentColors[1],
  QuizKind.fillBlank => kSectionAccentColors[0],
};

/// Resolves an item's accent color from [kSectionAccentColors] by
/// [colorIndex], else [fallback].
Color navColorFor(int? colorIndex, Color fallback) => colorIndex == null
    ? fallback
    : kSectionAccentColors[colorIndex % kSectionAccentColors.length];
