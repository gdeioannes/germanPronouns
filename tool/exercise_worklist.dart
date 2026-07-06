// Audits every course's quiz banks against a target item count and prints the
// quizzes that fall short (the authoring worklist):
//
//   dart run tool/exercise_worklist.dart [target]
//
// Counted per quiz kind: fillBlank → its stored sentence bank (template-driven
// quizzes like articles/nouns generate combinations and are skipped);
// dictation → its sentences (subjects). Reading/listening passages, speaking
// sets, big-text cloze and draw quizzes have their own fixed shapes and are
// not bank-sized, so they're skipped too.
import 'dart:io';

import 'package:german_pronouns_articles/data/article_content.dart';
import 'package:german_pronouns_articles/data/courses/de_cs/de_cs_content.dart';
import 'package:german_pronouns_articles/data/courses/de_es/de_es_content.dart';
import 'package:german_pronouns_articles/data/courses/en_de/en_de_content.dart';
import 'package:german_pronouns_articles/data/courses/en_zh/en_zh_content.dart';
import 'package:german_pronouns_articles/data/courses/es_de/es_de_content.dart';
import 'package:german_pronouns_articles/data/courses/zh_en/zh_en_content.dart';
import 'package:german_pronouns_articles/data/preposition_content.dart';
import 'package:german_pronouns_articles/data/pronoun_article_content.dart';
import 'package:german_pronouns_articles/data/pronoun_content.dart';
import 'package:german_pronouns_articles/data/quest_data.dart';
import 'package:german_pronouns_articles/models/quiz_content.dart';

/// Mirrors tool/generate_content.dart's `_contentByCourse` for the courses with
/// authored banks (the hanzi course is generated from the character list).
Map<String, List<QuizContent>> _contentByCourse() => {
  'de_cert_a1': [...questQuizContent],
  'en_de': [
    pronounQuizContent,
    articleQuizContent,
    pronounArticleQuizContent,
    prepositionQuizContent,
    ...enDeGrammarContent,
  ],
  'es_de': [...esDeContent],
  'es_de_emotions': [...esDeEmocionesContent],
  'de_es': [...deEsContent],
  'de_cs': [...deCsContent],
  'zh_en': [...zhEnContent],
  'en_zh': [...enZhContent],
};

void main(List<String> args) {
  final target = args.isEmpty ? 15 : int.parse(args.first);
  var quizzesShort = 0;
  var itemsNeeded = 0;

  for (final entry in _contentByCourse().entries) {
    final lines = <String>[];
    for (final quiz in entry.value) {
      final int count;
      switch (quiz.kind) {
        case QuizKind.fillBlank:
          // Template-driven quizzes generate their sentences; only stored
          // banks are authorable.
          if (quiz.sentences.isEmpty) continue;
          count = quiz.sentences.length;
        case QuizKind.dictation:
          count = quiz.subjects.length;
        case QuizKind.speakRepeat:
        case QuizKind.reading:
        case QuizKind.listening:
        case QuizKind.draw:
          continue;
      }
      if (count >= target) continue;
      quizzesShort++;
      itemsNeeded += target - count;
      lines.add(
        '  ${quiz.id}  [${quiz.kind.name}]  $count -> need ${target - count}'
        '  (${quiz.title})',
      );
    }
    if (lines.isNotEmpty) {
      stdout.writeln('== ${entry.key} (${lines.length} quizzes) ==');
      lines.forEach(stdout.writeln);
    }
  }
  stdout.writeln(
    '\nTarget $target: $quizzesShort quizzes short, $itemsNeeded items needed.',
  );
}
