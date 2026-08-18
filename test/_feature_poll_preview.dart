// Visual preview of the one-time feature poll at desktop (dialog) and phone
// (bottom sheet) sizes, written as PNGs via the golden machinery:
//
//   flutter test --update-goldens test/_feature_poll_preview.dart
//
// then open test/feature_poll_desktop.png / test/feature_poll_phone.png. Real
// Windows fonts are registered so the copy renders as glyphs instead of
// flutter_test's Ahem boxes. NOT a pass/fail golden — a developer preview,
// kept out of the suite by the leading underscore.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:german_pronouns_articles/models/noun_settings.dart';
import 'package:german_pronouns_articles/widgets/feature_poll.dart';

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
    await _load('Roboto', ['arial.ttf', 'arialbd.ttf']);
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await NounSettings.instance.load();
    await NounSettings.instance.resetAll();
  });

  Future<void> render(WidgetTester tester, Size size, String file) async {
    // tester.view — NOT binding.setSurfaceSize, which resizes the render
    // surface while MediaQuery keeps reporting 800x600, so the panel would lay
    // out for the wrong width and pick the wrong (dialog vs sheet) branch.
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF23315E)),
        fontFamily: 'Roboto',
      ),
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: TextButton(
              onPressed: () => showFeaturePoll(context),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await expectLater(find.byType(MaterialApp), matchesGoldenFile(file));
  }

  testWidgets('feature poll — desktop dialog', (tester) async {
    await render(tester, const Size(1000, 760), 'feature_poll_desktop.png');
  });

  testWidgets('feature poll — phone sheet', (tester) async {
    await render(tester, const Size(420, 820), 'feature_poll_phone.png');
  });
}
