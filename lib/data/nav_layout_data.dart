import 'package:flutter/material.dart';

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

/// Resolves an item's accent color from [kSectionAccentColors] by
/// [colorIndex], else [fallback].
Color navColorFor(int? colorIndex, Color fallback) => colorIndex == null
    ? fallback
    : kSectionAccentColors[colorIndex % kSectionAccentColors.length];
