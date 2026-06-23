import '../quiz_config.dart'
    show
        EndingPatternTable,
        HelpMemoryInfoColumn,
        HelpMemoryTable,
        HelpMemoryTip;
import '../quiz_content.dart';

/// The Help Memory reference material attached to a quiz, gathered from the flat
/// `helpMemory*` fields of the legacy [QuizContent] into one value object that
/// the sealed [Quiz] base carries. Pure data; serializable; reuses the existing
/// help table/tip/column types so nothing about the rendered Help Memory
/// changes.
class HelpMemory {
  const HelpMemory({
    this.subtitle,
    this.intro,
    this.tips = const [],
    this.tables = const [],
    this.endingPatternTables = const [],
    this.infoColumns = const [],
    this.colorByGender = false,
  });

  final String? subtitle;
  final String? intro;
  final List<HelpMemoryTip> tips;
  final List<HelpMemoryTable> tables;
  final List<EndingPatternTable> endingPatternTables;
  final List<HelpMemoryInfoColumn> infoColumns;
  final bool colorByGender;

  bool get isEmpty =>
      subtitle == null &&
      intro == null &&
      tips.isEmpty &&
      tables.isEmpty &&
      endingPatternTables.isEmpty &&
      infoColumns.isEmpty &&
      !colorByGender;

  Map<String, dynamic> toJson() => {
    if (subtitle != null) 'subtitle': subtitle,
    if (intro != null) 'intro': intro,
    if (tips.isNotEmpty) 'tips': [for (final t in tips) t.toJson()],
    if (tables.isNotEmpty) 'tables': [for (final t in tables) t.toJson()],
    if (endingPatternTables.isNotEmpty)
      'endingPatternTables': [for (final t in endingPatternTables) t.toJson()],
    if (infoColumns.isNotEmpty)
      'infoColumns': [for (final c in infoColumns) c.toJson()],
    if (colorByGender) 'colorByGender': true,
  };

  factory HelpMemory.fromJson(Map<String, dynamic> json) => HelpMemory(
    subtitle: json['subtitle'] as String?,
    intro: json['intro'] as String?,
    tips: [
      for (final t in (json['tips'] as List?) ?? const [])
        HelpMemoryTip.fromJson(Map<String, dynamic>.from(t as Map)),
    ],
    tables: [
      for (final t in (json['tables'] as List?) ?? const [])
        HelpMemoryTable.fromJson(Map<String, dynamic>.from(t as Map)),
    ],
    endingPatternTables: [
      for (final t in (json['endingPatternTables'] as List?) ?? const [])
        EndingPatternTable.fromJson(Map<String, dynamic>.from(t as Map)),
    ],
    infoColumns: [
      for (final c in (json['infoColumns'] as List?) ?? const [])
        HelpMemoryInfoColumn.fromJson(Map<String, dynamic>.from(c as Map)),
    ],
    colorByGender: json['colorByGender'] as bool? ?? false,
  );

  /// Pulls the help material out of a legacy [QuizContent].
  factory HelpMemory.fromContent(QuizContent c) => HelpMemory(
    subtitle: c.helpMemorySubtitle,
    intro: c.helpMemoryIntro,
    tips: c.helpMemoryTips,
    tables: c.helpMemoryTables,
    endingPatternTables: c.endingPatternTables,
    infoColumns: c.helpMemoryInfoColumns,
    colorByGender: c.helpMemoryColorByGender,
  );
}
