import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/data/quiz_content_library.dart';
import 'package:german_pronouns_articles/models/quiz_content.dart';
import 'package:german_pronouns_articles/services/speaking_prompt.dart';

/// Dev preview: prints the exact clipboard text of every speaking exercise, so
/// the authored brief can be read end to end without running the app.
///
///     flutter test test/_speaking_preview.dart
///
/// Not a gate — `speaking_quiz_test.dart` is. This just makes the prompt
/// visible, since the whole feature lives or dies on that text.
class _DiskBundle extends CachingAssetBundle {
  @override
  Future<String> loadString(String key, {bool cache = true}) async =>
      File(key).readAsString();

  @override
  Future<ByteData> load(String key) async {
    final bytes = await File(key).readAsBytes();
    return ByteData.view(bytes.buffer);
  }
}

void main() {
  test('print every speaking prompt', () async {
    final template = await SpeakingPromptBuilder.load(
      'en',
      bundle: _DiskBundle(),
    );
    for (final quiz in allQuizContent.where(
      (c) => c.kind == QuizKind.speaking,
    )) {
      final prompt = SpeakingPromptBuilder(template).render(
        quiz.speaking!,
        learnLang: 'de-DE',
        uiLang: 'en',
        cefr: quiz.level!,
      );
      // ignore: avoid_print
      print('\n═══ ${quiz.id} · ${quiz.title} ═══\n$prompt\n');
    }
  });
}
