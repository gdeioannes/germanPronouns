import 'dart:ui' show Locale;

import 'package:flutter_test/flutter_test.dart';

import 'package:german_pronouns_articles/data/course_catalog.dart';
import 'package:german_pronouns_articles/models/course.dart';
import 'package:german_pronouns_articles/services/site_lang.dart';

void main() {
  group('siteLangs', () {
    test('reads ?lang= before the hash, keeping order', () {
      final langs = siteLangs(
        uri: Uri.parse('https://languagequiz.org/?lang=de,en#/home'),
        locales: const [Locale('es')],
      );
      expect(langs, [UiLang.de, UiLang.en]);
    });

    test('reads lang inside the hash fragment', () {
      final langs = siteLangs(
        uri: Uri.parse('https://languagequiz.org/#/home?lang=zh'),
        locales: const [Locale('en')],
      );
      expect(langs, [UiLang.zh]);
    });

    test('ignores unknown codes and falls back to browser languages', () {
      final langs = siteLangs(
        uri: Uri.parse('https://languagequiz.org/?lang=fr'),
        locales: const [Locale('es', 'MX'), Locale('en', 'US')],
      );
      expect(langs, [UiLang.es, UiLang.en]);
    });

    test('falls back to English when nothing matches', () {
      final langs = siteLangs(
        uri: Uri.parse('https://languagequiz.org/'),
        locales: const [Locale('fr')],
      );
      expect(langs, [UiLang.en]);
    });
  });

  group('featuredCourses', () {
    test('offers up to 3 per language, languages in the given order', () {
      final featured = featuredCourses(
        const [UiLang.de, UiLang.en],
        defaultCourses,
      );
      final deCount = defaultCourses
          .where((c) => c.uiLang == UiLang.de)
          .length;
      // Every German-UI course (there are fewer than 3) precedes the English.
      expect(
        featured.take(deCount).every((c) => c.uiLang == UiLang.de),
        isTrue,
      );
      expect(
        featured.skip(deCount).every((c) => c.uiLang == UiLang.en),
        isTrue,
      );
      expect(featured.skip(deCount).length, 3);
    });

    test('certification courses lead within a language', () {
      final featured = featuredCourses(const [UiLang.en], defaultCourses);
      expect(featured, hasLength(3));
      expect(featured.first.goal, 'certification');
    });

    test('falls back to English courses for a language with no courses', () {
      // Guard against a langs list that slipped through with no matches.
      final onlyEnglish = [
        for (final c in defaultCourses)
          if (c.uiLang == UiLang.en) c,
      ];
      final featured = featuredCourses(const [UiLang.zh], onlyEnglish);
      expect(featured, isNotEmpty);
      expect(featured.every((c) => c.uiLang == UiLang.en), isTrue);
    });
  });
}
