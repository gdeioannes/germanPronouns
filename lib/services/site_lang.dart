import 'dart:ui' show Locale, PlatformDispatcher;

import '../models/course.dart';

/// The site language(s) for the pre-course landing page, in preference order.
///
/// Sourced from the page URL's `lang` query parameter — a comma-separated list
/// of UI language codes (`?lang=de` or `?lang=de,en`) — so a marketing URL can
/// decide exactly which courses the landing offers and in which order. With no
/// (valid) parameter it falls back to the browser/system languages, and finally
/// to English. Unknown codes are ignored; the result is never empty.
///
/// [uri] and [locales] exist for tests; the defaults read the real page URL and
/// platform locales.
List<UiLang> siteLangs({Uri? uri, List<Locale>? locales}) {
  final fromUrl = _langsFromUri(uri ?? Uri.base);
  if (fromUrl.isNotEmpty) return fromUrl;

  final fromLocales = <UiLang>[];
  for (final locale in locales ?? PlatformDispatcher.instance.locales) {
    final lang = _uiLangFromCode(locale.languageCode);
    if (lang != null && !fromLocales.contains(lang)) fromLocales.add(lang);
  }
  return fromLocales.isEmpty ? const [UiLang.en] : fromLocales;
}

/// Reads `lang=` from [uri] — both before the `#` (`/?lang=de#/home`, the shape
/// Flutter web's hash URL strategy gives shared links) and inside the fragment
/// (`/#/home?lang=de`, the shape go_router renders).
List<UiLang> _langsFromUri(Uri uri) {
  var raw = uri.queryParameters['lang'];
  if (raw == null && uri.fragment.contains('?')) {
    raw = Uri.tryParse(uri.fragment)?.queryParameters['lang'];
  }
  if (raw == null) return const [];
  final langs = <UiLang>[];
  for (final code in raw.split(',')) {
    final lang = _uiLangFromCode(code.trim().toLowerCase());
    if (lang != null && !langs.contains(lang)) langs.add(lang);
  }
  return langs;
}

UiLang? _uiLangFromCode(String code) {
  for (final lang in UiLang.values) {
    if (lang.name == code) return lang;
  }
  return null;
}

/// The courses the landing page offers: at most [max] in total, drawn from
/// the languages in [langs] in order — so `?lang=de,en` fills the slots with
/// German courses first and tops up with English ones. A hard total keeps the
/// landing a showcase, not a scrolling catalog (the finder is one tap away).
///
/// Within one language, certification courses lead (they're the broadest offer
/// and support the placement fast path), then grammar, vocabulary, discover.
/// Falls back to the English courses when [langs] matches nothing at all.
List<Course> featuredCourses(
  List<UiLang> langs,
  List<Course> courses, {
  int max = 3,
}) {
  List<Course> pick(UiLang lang) =>
      [for (final c in courses) if (c.uiLang == lang) c]
        ..sort((a, b) => _goalRank(a.goal).compareTo(_goalRank(b.goal)));

  final featured = <Course>[];
  for (final lang in langs) {
    for (final course in pick(lang)) {
      if (featured.length >= max) return featured;
      featured.add(course);
    }
  }
  if (featured.isNotEmpty) return featured;
  return pick(UiLang.en).take(max).toList();
}

int _goalRank(String? goal) => switch (goal) {
  'certification' => 0,
  'grammar' => 1,
  'vocabulary' => 2,
  'discover' => 3,
  _ => 4,
};
