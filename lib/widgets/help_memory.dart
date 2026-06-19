import 'package:flutter/material.dart';

import '../models/noun_settings.dart';
import '../models/quiz_config.dart';
import '../theme/app_theme.dart';

/// Reusable visual building blocks for the quizzes' "Help Memory" section: a
/// gender color legend, rule/mnemonic callout cards, an intro paragraph, and a
/// per-gender cell-tint helper. Centralized here so the look is changed in one
/// place (see also `theme/pdf_theme.dart` for the PDF equivalents).

/// Soft background + readable foreground tint for a value cell of the given
/// grammatical [gender] ('m'/'f'/'n'), using the app-wide gender colors
/// (der=blue, die=red, das=green). Returns null when there's no gender.
({Color background, Color foreground})? genderTint(String? gender) {
  if (gender == null || gender.isEmpty) return null;
  final color = NounSettings.instance.colorForGender(gender);
  return (background: color.withValues(alpha: 0.13), foreground: color);
}

/// Visual identity (icon + accent color) for a [HelpMemoryTip.kind].
({IconData icon, Color color}) tipVisual(String kind) {
  switch (kind) {
    case 'rule':
      return (icon: Icons.rule_rounded, color: kSectionAccentColors[2]);
    case 'warning':
      return (
        icon: Icons.warning_amber_rounded,
        color: kSectionAccentColors[1],
      );
    case 'example':
      return (
        icon: Icons.chat_bubble_outline_rounded,
        color: kSectionAccentColors[3],
      );
    case 'mnemonic':
      return (icon: Icons.psychology_rounded, color: kSectionAccentColors[0]);
    case 'tip':
    default:
      return (
        icon: Icons.lightbulb_outline_rounded,
        color: kSectionAccentColors[0],
      );
  }
}

/// A row of colored der/die/das pills explaining the gender color system.
class GenderLegend extends StatelessWidget {
  const GenderLegend({super.key});

  static const _entries = [
    ('der', 'm', 'masculine'),
    ('die', 'f', 'feminine'),
    ('das', 'n', 'neuter'),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final (article, gender, name) in _entries)
          Builder(
            builder: (context) {
              final color = NounSettings.instance.colorForGender(gender);
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(kRadiusSmall),
                  border: Border.all(color: color.withValues(alpha: 0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      article,
                      style: textTheme.labelLarge?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '· $name',
                      style: textTheme.labelSmall?.copyWith(color: muted),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}

/// A short, accent-bordered callout (rule / mnemonic / example / warning / tip)
/// shown in the Help Memory section.
class HelpTipCard extends StatelessWidget {
  const HelpTipCard({super.key, required this.tip});

  final HelpMemoryTip tip;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final visual = tipVisual(tip.kind);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: visual.color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(kRadiusSmall),
        border: Border(left: BorderSide(color: visual.color, width: 4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(visual.icon, color: visual.color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (tip.title != null) ...[
                  Text(
                    tip.title!,
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: visual.color,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                Text(tip.text, style: textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The Help Memory intro paragraph.
class HelpMemoryIntro extends StatelessWidget {
  const HelpMemoryIntro({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          height: 1.35,
        ),
      ),
    );
  }
}
