import '../course.dart';

/// A lightweight catalog row for one course — everything the start menu needs to
/// render a course card *without* loading the course's (heavy) content bundle.
/// This is the always-loaded half of the lazy-loading split.
class CourseCard {
  const CourseCard({
    required this.id,
    required this.name,
    required this.tagline,
    required this.speakFlag,
    required this.learnFlag,
    required this.uiLang,
    this.learnLocale = 'de-DE',
    this.version,
  });

  final String id;
  final String name;
  final String tagline;
  final String speakFlag;
  final String learnFlag;
  final UiLang uiLang;
  final String learnLocale;

  /// Content version of this course's bundle, used to invalidate a stale cache.
  final String? version;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'tagline': tagline,
    'speakFlag': speakFlag,
    'learnFlag': learnFlag,
    'uiLang': uiLang.name,
    'learnLocale': learnLocale,
    if (version != null) 'version': version,
  };

  factory CourseCard.fromJson(Map<String, dynamic> json) => CourseCard(
    id: json['id'] as String,
    name: json['name'] as String,
    tagline: json['tagline'] as String? ?? '',
    speakFlag: json['speakFlag'] as String? ?? '',
    learnFlag: json['learnFlag'] as String? ?? '',
    uiLang: _uiLangFromName(json['uiLang'] as String?),
    learnLocale: json['learnLocale'] as String? ?? 'de-DE',
    version: json['version'] as String?,
  );

  /// The card projection of a full [Course] (drops the heavy nav).
  factory CourseCard.fromCourse(Course c, {String? version}) => CourseCard(
    id: c.id,
    name: c.name,
    tagline: c.tagline,
    speakFlag: c.speakFlag,
    learnFlag: c.learnFlag,
    uiLang: c.uiLang,
    learnLocale: c.learnLocale,
    version: version,
  );
}

UiLang _uiLangFromName(String? name) {
  for (final l in UiLang.values) {
    if (l.name == name) return l;
  }
  return UiLang.en;
}

/// The course index: the small, always-loaded list of [CourseCard]s the start
/// menu renders. Heavy per-course bundles are fetched only when a course opens.
class Catalog {
  const Catalog({required this.version, this.courses = const []});

  final String version;
  final List<CourseCard> courses;

  Map<String, dynamic> toJson() => {
    'version': version,
    'courses': [for (final c in courses) c.toJson()],
  };

  factory Catalog.fromJson(Map<String, dynamic> json) => Catalog(
    version: json['version'] as String? ?? '',
    courses: [
      for (final c in (json['courses'] as List?) ?? const [])
        CourseCard.fromJson(Map<String, dynamic>.from(c as Map)),
    ],
  );
}

/// Global, non-course UI content (start menu, settings copy, …) — the second
/// always-loaded document. Kept as an open key/value map for now: the global
/// screens stay code-rendered, and only the content/config they read lives here.
class AppConfig {
  const AppConfig({required this.version, this.values = const {}});

  final String version;
  final Map<String, dynamic> values;

  Map<String, dynamic> toJson() => {'version': version, 'values': values};

  factory AppConfig.fromJson(Map<String, dynamic> json) => AppConfig(
    version: json['version'] as String? ?? '',
    values: (json['values'] as Map?)?.cast<String, dynamic>() ?? const {},
  );
}
