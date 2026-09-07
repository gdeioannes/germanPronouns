import 'dart:convert';

import 'package:flutter/services.dart' show AssetBundle, rootBundle;

import '../models/speaking_exercise.dart';

/// Where the speaking templates live. One manifest plus one template per UI
/// language; see `docs/speaking_quiz_feature.md`.
const String kSpeakingManifestAsset = 'assets/content/speaking/manifest.json';

/// One section of the static template: an optional [heading] followed by plain
/// [lines], `- ` [bullets], or the expansion of a `{placeholder}` [list].
///
/// A section with [optionalOn] set is dropped entirely — heading included —
/// when that placeholder resolves empty, so a quiz with no target vocabulary
/// simply has no vocabulary block rather than an empty one.
class SpeakingSection {
  const SpeakingSection({
    required this.id,
    this.heading,
    this.lines = const [],
    this.bullets = const [],
    this.list,
    this.optionalOn,
  });

  final String id;
  final String? heading;
  final List<String> lines;
  final List<String> bullets;
  final String? list;
  final String? optionalOn;

  factory SpeakingSection.fromJson(Map<String, dynamic> json) =>
      SpeakingSection(
        id: json['id'] as String,
        heading: json['heading'] as String?,
        lines: (json['lines'] as List?)?.cast<String>() ?? const [],
        bullets: (json['bullets'] as List?)?.cast<String>() ?? const [],
        list: json['list'] as String?,
        optionalOn: json['optional'] as String?,
      );
}

/// The static half of the prompt for one UI language, plus the shared numeric
/// defaults and trigger phrases read from the manifest.
class SpeakingTemplate {
  const SpeakingTemplate({
    required this.version,
    required this.uiLang,
    required this.languageNames,
    required this.modes,
    required this.closingLine,
    required this.sections,
    required this.defaults,
    required this.triggers,
  });

  /// Manifest `templateVersion`, stored alongside a saved score so a result can
  /// be read against the wording that produced it.
  final int version;

  /// The UI language this template is written in. May differ from the language
  /// that was asked for — see [SpeakingPromptBuilder.load]'s English fallback.
  final String uiLang;

  /// Language code → its name *in this template's language* ('es' → 'Spanisch'
  /// in the German template).
  final Map<String, String> languageNames;

  /// [SpeakingMode] name → the instruction line that describes it.
  final Map<String, String> modes;

  final String closingLine;
  final List<SpeakingSection> sections;

  /// Session/report defaults every quiz falls back to.
  final Map<String, int> defaults;

  /// Target language code → the phrase the learner says to start.
  final Map<String, String> triggers;

  int defaultFor(String key) => defaults[key] ?? 0;
}

/// Loads the speaking templates and renders one into the text the learner
/// copies to the clipboard.
///
/// The prompt is deliberately plain prose rather than a compact notation: the
/// rules that carry the feature (no corrections *during* the talk, a mandatory
/// report, the exact `SCORE=` last line) are the first to degrade on the weak
/// free-tier models this feature targets, and the learner's provider pays for
/// the tokens, not us. See `docs/speaking_quiz_feature.md` §4.
class SpeakingPromptBuilder {
  SpeakingPromptBuilder(this.template);

  final SpeakingTemplate template;

  static final Map<String, SpeakingTemplate> _cache = {};

  /// Loads the template for [uiLang], falling back to English when that
  /// language has no translation yet. [bundle] is injectable for tests.
  static Future<SpeakingTemplate> load(
    String uiLang, {
    AssetBundle? bundle,
  }) async {
    final cached = _cache[uiLang];
    if (cached != null) return cached;

    final assets = bundle ?? rootBundle;
    final manifest =
        jsonDecode(await assets.loadString(kSpeakingManifestAsset))
            as Map<String, dynamic>;
    final paths = Map<String, dynamic>.from(manifest['templates'] as Map);
    final path = (paths[uiLang] ?? paths['en']) as String;

    final json =
        jsonDecode(await assets.loadString(path)) as Map<String, dynamic>;
    final template = SpeakingTemplate(
      version: manifest['templateVersion'] as int? ?? 1,
      uiLang: json['uiLang'] as String,
      languageNames: Map<String, String>.from(json['languageNames'] as Map),
      modes: Map<String, String>.from(json['modes'] as Map),
      closingLine: json['closingLine'] as String,
      sections: [
        for (final s in json['sections'] as List)
          SpeakingSection.fromJson(Map<String, dynamic>.from(s as Map)),
      ],
      defaults: Map<String, int>.from(manifest['defaults'] as Map),
      triggers: Map<String, String>.from(manifest['triggers'] as Map),
    );
    return _cache[uiLang] = template;
  }

  /// Clears the template cache (tests that swap bundles).
  static void resetCache() => _cache.clear();

  /// The phrase the learner says out loud to start, in [learnLang].
  String triggerFor(String learnLang) =>
      template.triggers[_base(learnLang)] ??
      template.triggers['en'] ??
      "Let's go";

  /// Renders the full clipboard text for [exercise].
  ///
  /// [learnLang] and [uiLang] are language codes or locales ('de', 'de-DE');
  /// [cefr] is the quiz's level, shown to the AI as the learner's level.
  String render(
    SpeakingExercise exercise, {
    required String learnLang,
    required String uiLang,
    required String cefr,
  }) {
    final values = _values(
      exercise,
      learnLang: learnLang,
      uiLang: uiLang,
      cefr: cefr,
    );

    final blocks = <String>[];
    for (final section in template.sections) {
      final gate = section.optionalOn;
      // An optional section whose placeholder is empty is dropped whole, so no
      // stray heading is left over its missing body.
      if (gate != null && _fill(gate, values).trim().isEmpty) continue;

      final body = <String>[
        for (final line in section.lines) _fill(line, values),
        for (final bullet in section.bullets) '- ${_fill(bullet, values)}',
        if (section.list != null) ..._listLines(section.list!, values),
      ].where((l) => l.trim().isNotEmpty).toList();
      if (body.isEmpty) continue;

      blocks.add(
        [if (section.heading != null) section.heading!, ...body].join('\n'),
      );
    }
    return blocks.join('\n\n');
  }

  /// A `{placeholder}` holding a list renders as one `- ` bullet per entry.
  List<String> _listLines(String token, Map<String, String> values) {
    final key = token.replaceAll(RegExp(r'[{}]'), '');
    final items = _lists[key];
    if (items == null) return [_fill(token, values)];
    return [for (final i in items) '- $i'];
  }

  /// Populated by [_values]: the list-valued placeholders, kept aside so
  /// `list:` sections can expand them as bullets while inline uses stay joined.
  final Map<String, List<String>> _lists = {};

  Map<String, String> _values(
    SpeakingExercise e, {
    required String learnLang,
    required String uiLang,
    required String cefr,
  }) {
    final learn = _base(learnLang);
    final ui = _base(uiLang);
    final session = e.session;
    final report = e.report;

    _lists
      ..clear()
      ..['practisePoints'] = e.practisePoints
      ..['targetVocabulary'] = e.targetVocabulary;

    final values = {
      'targetLanguageName': template.languageNames[learn] ?? learn,
      'uiLanguageName': template.languageNames[ui] ?? ui,
      'triggerPhrase': triggerFor(learn),
      'cefr': cefr,
      'topic': e.topic,
      'material': e.material,
      // Non-empty switches the optional scaffolding section on; the value
      // itself is never rendered.
      'scaffolding': e.scaffolded ? 'yes' : '',
      'practisePoints': e.practisePoints.join(', '),
      'targetVocabulary': e.targetVocabulary.join(', '),
      'scoringCriteria': e.scoringCriteria.join(', '),
      'priorityErrors': e.priorityErrors.join(', '),
      'closingLine': template.closingLine,
      'durationMinutes':
          '${session.durationMinutes ?? template.defaultFor('durationMinutes')}',
      'minExchanges':
          '${session.minExchanges ?? template.defaultFor('minExchanges')}',
      'minQuestionsPerPoint':
          '${session.minQuestionsPerPoint ?? template.defaultFor('minQuestionsPerPoint')}',
      'reportMaxWords':
          '${report.maxWords ?? template.defaultFor('reportMaxWords')}',
      'maxCorrections':
          '${report.maxCorrections ?? template.defaultFor('maxCorrections')}',
    };
    // The mode instruction is itself template text and may carry placeholders
    // ({targetLanguageName}, {cefr}); fill it before it is spliced into a
    // section, since _fill makes a single pass over each line.
    values['modeInstruction'] = _fill(
      template.modes[e.mode.name] ?? '',
      values,
    );
    return values;
  }

  static final RegExp _placeholder = RegExp(r'\{(\w+)\}');

  String _fill(String text, Map<String, String> values) =>
      text.replaceAllMapped(
        _placeholder,
        (m) => values[m.group(1)!] ?? m.group(0)!,
      );

  /// 'de-DE' → 'de'; leaves a bare code untouched.
  static String _base(String locale) =>
      locale.split(RegExp('[-_]')).first.toLowerCase();
}

/// The session values a quiz actually runs with, after defaults are applied —
/// used by the UI (to show the expected minutes) and the gate test (to check the
/// questions-fit-in-exchanges rule) without re-deriving the fallbacks.
({
  int durationMinutes,
  int minExchanges,
  int minQuestionsPerPoint,
  int passScore,
})
resolvedSpeakingSession(SpeakingExercise e, SpeakingTemplate t) => (
  durationMinutes: e.session.durationMinutes ?? t.defaultFor('durationMinutes'),
  minExchanges: e.session.minExchanges ?? t.defaultFor('minExchanges'),
  minQuestionsPerPoint:
      e.session.minQuestionsPerPoint ?? t.defaultFor('minQuestionsPerPoint'),
  passScore: e.passScore ?? t.defaultFor('passScore'),
);
