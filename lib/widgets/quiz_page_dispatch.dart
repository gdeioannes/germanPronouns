import 'package:flutter/material.dart';

import '../data/quiz_content_adapter.dart';
import '../models/app_page.dart';
import '../models/quiz_config.dart';
import '../models/quiz_content.dart';
import '../pages/dictation_quiz_page.dart';
import '../pages/inline_cloze_quiz_page.dart';
import '../pages/listening_quiz_page.dart';
import '../pages/reading_quiz_page.dart';
import '../pages/speak_repeat_quiz_page.dart';
import 'quiz_page.dart';

/// Builds the page that renders [content], chosen by its [QuizContent.kind].
///
/// This is the single kind→page mapping shared by every quiz loader: the
/// audio/reading kinds get their dedicated pages, and fill-in-the-blank is run
/// through the generic [QuizPage] engine via [buildQuizConfigFromContent]. The
/// progression arguments are threaded straight through so each loader keeps its
/// own behavior (Quest passes [questProgressionKey] + [questProgression]; the
/// grammar loader passes a [progressionKey] and an [explanationOverride]).
Widget pageForQuizContent(
  QuizContent content, {
  required AppPage currentPage,
  String? questProgressionKey,
  String? progressionKey,
  bool questProgression = false,
  ExplanationBuilder? explanationOverride,
}) {
  switch (content.kind) {
    case QuizKind.speakRepeat:
      return SpeakRepeatQuizPage(
        content: content,
        currentPage: currentPage,
        questProgressionKey: questProgressionKey,
      );
    case QuizKind.reading:
      // A reading quiz carrying inline blanks is the "big text" answered inside
      // the passage; without them it's the classic passage + multiple-choice.
      if (content.inlineBlanks.isNotEmpty) {
        return InlineClozeQuizPage(
          content: content,
          currentPage: currentPage,
          questProgressionKey: questProgressionKey,
        );
      }
      return ReadingQuizPage(
        content: content,
        currentPage: currentPage,
        questProgressionKey: questProgressionKey,
      );
    case QuizKind.listening:
      return ListeningQuizPage(
        content: content,
        currentPage: currentPage,
        questProgressionKey: questProgressionKey,
      );
    case QuizKind.dictation:
      return DictationQuizPage(
        content: content,
        currentPage: currentPage,
        questProgressionKey: questProgressionKey,
      );
    case QuizKind.fillBlank:
      return QuizPage(
        config: buildQuizConfigFromContent(
          content,
          currentPage: currentPage,
          progressionKey: progressionKey,
          questProgression: questProgression,
          explanationOverride: explanationOverride,
        ),
      );
  }
}
