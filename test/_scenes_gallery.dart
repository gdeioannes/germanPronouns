// Visual gallery for the PersonScene illustrations. Renders every scene onto
// a plain card background and writes a PNG via the golden machinery, so the
// drawings can be eyeballed:
//
//   flutter test --update-goldens test/_scenes_gallery.dart
//
// then open test/scenes_gallery.png. It is NOT a pass/fail golden — it is a
// developer preview, kept out of the normal suite by the leading underscore.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:german_pronouns_articles/widgets/person_scene.dart';

void main() {
  testWidgets('person scenes gallery', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1080, 700));
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Container(
          color: const Color(0xFFFFFFFF),
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final kind in PersonSceneKind.values)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E5E5)),
                      ),
                      child: PersonScene(kind, height: 190),
                    ),
                    Text(kind.name,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('scenes_gallery.png'),
    );
  });
}
