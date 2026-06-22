import 'nav_layout.dart';

/// The language the learner already speaks — drives which language the app's
/// chrome (buttons, menus, dialogs) is shown in.
enum UiLang { en, es, de }

UiLang _uiLangFromName(String? name) {
  for (final l in UiLang.values) {
    if (l.name == name) return l;
  }
  return UiLang.en;
}

/// A language-pair course ("speak X, learn Y"): its display metadata, the UI
/// language for its chrome, and its own navigation menu (which references
/// quizzes stored in the shared content database by `contentId`).
class Course {
  const Course({
    required this.id,
    required this.name,
    required this.tagline,
    required this.speakFlag,
    required this.learnFlag,
    required this.uiLang,
    required this.nav,
    this.learnLocale = 'de-DE',
  });

  /// Stable id, e.g. 'en_de', 'es_de'.
  final String id;

  /// Display name, e.g. 'Español → Alemán'.
  final String name;

  /// Short subtitle, e.g. 'Habla español, aprende alemán'.
  final String tagline;

  /// Emoji flag of the language the learner speaks.
  final String speakFlag;

  /// Emoji flag of the language being learned.
  final String learnFlag;

  /// UI/chrome language for this course.
  final UiLang uiLang;

  /// BCP-47 locale of the language being **learned** (the target the TTS speaks
  /// in listen-&-repeat / reading). Defaults to German since every original
  /// course teaches German; the `de_es` course sets it to `es-ES`.
  final String learnLocale;

  /// This course's drawer layout.
  final NavLayout nav;

  Course copyWith({String? name, String? tagline, NavLayout? nav}) => Course(
    id: id,
    name: name ?? this.name,
    tagline: tagline ?? this.tagline,
    speakFlag: speakFlag,
    learnFlag: learnFlag,
    uiLang: uiLang,
    learnLocale: learnLocale,
    nav: nav ?? this.nav,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'tagline': tagline,
    'speakFlag': speakFlag,
    'learnFlag': learnFlag,
    'uiLang': uiLang.name,
    'learnLocale': learnLocale,
    'nav': nav.toJson(),
  };

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    id: json['id'] as String,
    name: json['name'] as String,
    tagline: json['tagline'] as String? ?? '',
    speakFlag: json['speakFlag'] as String? ?? '',
    learnFlag: json['learnFlag'] as String? ?? '',
    uiLang: _uiLangFromName(json['uiLang'] as String?),
    learnLocale: json['learnLocale'] as String? ?? 'de-DE',
    nav: NavLayout.fromJson(
      Map<String, dynamic>.from(json['nav'] as Map? ?? const {}),
    ),
  );
}
