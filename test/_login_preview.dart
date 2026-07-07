// Visual preview of the login poster at desktop and phone sizes, written as
// PNGs via the golden machinery:
//
//   flutter test --update-goldens test/_login_preview.dart
//
// then open test/login_desktop.png / test/login_mobile.png. Real Windows fonts
// are registered under the app's font families so type renders as glyphs
// instead of flutter_test's Ahem boxes (Arial stands in for Inter/Roboto,
// Georgia for Source Serif 4, YaHei for the CJK greeting). NOT a pass/fail
// golden — a developer preview, kept out of the suite by the underscore.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:german_pronouns_articles/pages/login_page.dart';
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
    await _load('Roboto', ['arialbd.ttf', 'msyh.ttc']);
  });

  // A GoogleFonts-free stand-in for buildAppTheme (whose text styles trigger
  // network font loads that fail a test): the same brand color scheme and
  // serif-display/sans-body pairing, resolved to the fonts loaded above.
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
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: 'Inter',
    );
    const serif = TextStyle(fontFamily: 'Source Serif 4');
    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        displayLarge: base.textTheme.displayLarge!.merge(serif),
        displayMedium: base.textTheme.displayMedium!.merge(serif),
        displaySmall: base.textTheme.displaySmall!.merge(serif),
        headlineMedium: base.textTheme.headlineMedium!.merge(serif),
        headlineSmall: base.textTheme.headlineSmall!.merge(serif),
        titleLarge: base.textTheme.titleLarge!.merge(serif),
      ),
    );
  }

  Future<void> shot(WidgetTester tester, Size size, String out) async {
    await tester.binding.setSurfaceSize(size);
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: previewTheme(),
        home: const LoginPage(),
      ),
    );
    await tester.pump();
    await expectLater(find.byType(MaterialApp), matchesGoldenFile(out));
  }

  testWidgets('login desktop', (tester) async {
    await shot(tester, const Size(1440, 900), 'login_desktop.png');
  });

  testWidgets('login mobile', (tester) async {
    await shot(tester, const Size(420, 880), 'login_mobile.png');
  });
}
