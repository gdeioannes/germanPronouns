// Visual preview of the redesigned "How it works" page for three courses
// (Spanish-target, English-target, German-target), written as PNGs via the
// golden machinery:
//
//   $env:UPDATE_GOLDEN=1; flutter test --update-goldens test/_intro_preview.dart
//
// then open test/intro_en_es.png / intro_es_en.png / intro_de_cert.png.
// Real Windows fonts stand in for the app families so type renders as glyphs.
// NOT a pass/fail golden — a developer preview, kept out of the suite by the
// underscore.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:german_pronouns_articles/models/course_session.dart';
import 'package:german_pronouns_articles/pages/course_intro_page.dart';
import 'package:german_pronouns_articles/theme/brand_palette.dart';

Future<void> _load(String family, List<String> files) async {
  final loader = FontLoader(family);
  for (final f in files) {
    final bytes = File('C:\\Windows\\Fonts\\$f').readAsBytesSync();
    loader.addFont(Future.value(ByteData.view(bytes.buffer)));
  }
  await loader.load();
}

void main() {
  setUpAll(() async {
    await _load('Inter', ['arial.ttf', 'arialbd.ttf']);
    await _load('Source Serif 4', ['georgia.ttf', 'georgiab.ttf']);
    await _load('Roboto', ['arial.ttf', 'msyh.ttc']);
  });

  ThemeData previewTheme() {
    final colorScheme =
        ColorScheme.fromSeed(seedColor: const Color(kBrandNavy)).copyWith(
      primary: const Color(kBrandNavy),
      onPrimary: Colors.white,
      secondary: const Color(kBrandTerracotta),
      surface: const Color(kBrandPaper),
      onSurface: const Color(kBrandInkText),
      onSurfaceVariant: const Color(kBrandInkMuted),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: 'Inter',
    );
  }

  Future<void> shoot(WidgetTester tester, String courseId, String file) async {
    SharedPreferences.setMockInitialValues({});
    await CourseSession.instance.load();
    await CourseSession.instance.setActiveCourse(courseId);
    tester.view.physicalSize = const Size(430 * 2, 1400 * 2);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(theme: previewTheme(), home: const CourseIntroPage()),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(CourseIntroPage),
      matchesGoldenFile(file),
    );
  }

  testWidgets('en_es intro', (tester) async {
    await shoot(tester, 'en_es', 'intro_en_es.png');
  });
  testWidgets('es_en intro', (tester) async {
    await shoot(tester, 'es_en', 'intro_es_en.png');
  });
  testWidgets('de_cert intro', (tester) async {
    await shoot(tester, 'de_cert_a1', 'intro_de_cert.png');
  });
}
