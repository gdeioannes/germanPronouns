import '../../models/content/help_memory.dart';
import '../../models/content/quiz.dart';
import '../../models/quiz_content.dart';

/// The quiz kinds an [AiAuthoringService] can draft (mirrors the sealed [Quiz]
/// subtypes — the generation contract).
enum AiQuizType { fillBlank, reading, listening, speakRepeat, dictation }

/// Generates a draft [Quiz] for the teacher to review and save. Because every
/// quiz kind is a typed, validated schema, "AI authoring" is just "produce JSON
/// that conforms to the [Quiz] subtype" — the same `fromJson` + the editor's
/// validation gate the output, so a malformed draft is rejected at the door.
///
/// This interface is the seam: [TemplateAiAuthoringService] is a deterministic,
/// offline stub; a Claude-backed implementation (structured output keyed to the
/// sealed schema) drops in without changing the editor or the review UI.
abstract interface class AiAuthoringService {
  /// Drafts a quiz of [type] with the given [id], titled from [topic] (and an
  /// optional CEFR [level]). The draft is a *starting point* — the teacher
  /// reviews and edits it in the normal editor form before it is saved.
  Future<Quiz> draftQuiz({
    required AiQuizType type,
    required String id,
    required String topic,
    String? level,
  });
}

/// Offline stub: returns a minimal, schema-valid quiz of the requested kind
/// (placeholder content for the teacher to fill in). Lets the AI-authoring seam
/// — draft → review in the editor form → validate → save — be built and tested
/// with no network or API key.
class TemplateAiAuthoringService implements AiAuthoringService {
  const TemplateAiAuthoringService();

  @override
  Future<Quiz> draftQuiz({
    required AiQuizType type,
    required String id,
    required String topic,
    String? level,
  }) async {
    final prefix = '${id}_';
    final help = HelpMemory(intro: 'Draft generated for "$topic". Review me.');
    switch (type) {
      case AiQuizType.fillBlank:
        return FillBlankQuiz(
          id: id,
          title: topic,
          storageKeyPrefix: prefix,
          promptLabel: 'Wort',
          subjectsLabel: topic,
          subjectColumnLabel: 'English',
          help: help,
          subjects: const [QuizSubjectData(key: 's0', display: 'example')],
          categories: const [
            QuizCategoryData(label: 'Wort', group: 'Wort', values: ['Beispiel']),
          ],
          sentences: const [
            QuizSentenceData(
              subjectKey: 's0',
              categoryLabel: 'Wort',
              sentence: 'Das ist ein ____.',
              acceptedAnswers: ['Beispiel'],
              english: 'This is an example.',
            ),
          ],
        );
      case AiQuizType.reading:
      case AiQuizType.listening:
        final question = const ReadingQuestion(
          question: 'Worum geht es im Text?',
          options: ['Um ein Beispiel', 'Um etwas anderes'],
          correctIndex: 0,
        );
        return type == AiQuizType.reading
            ? ReadingQuiz(
                id: id,
                title: topic,
                storageKeyPrefix: prefix,
                promptLabel: 'Frage',
                subjectsLabel: 'Fragen',
                subjectColumnLabel: 'Frage',
                help: help,
                category: level,
                passageTitle: topic,
                passage: 'Dies ist ein Beispieltext. Bitte bearbeiten.',
                questions: [question],
              )
            : ListeningQuiz(
                id: id,
                title: topic,
                storageKeyPrefix: prefix,
                promptLabel: 'Frage',
                subjectsLabel: 'Fragen',
                subjectColumnLabel: 'Frage',
                help: help,
                category: level,
                passageTitle: topic,
                passage: 'Dies ist ein Hörtext. Bitte bearbeiten.',
                questions: [question],
              );
      case AiQuizType.speakRepeat:
        return SpeakRepeatQuiz(
          id: id,
          title: topic,
          storageKeyPrefix: prefix,
          promptLabel: 'Phrase',
          subjectsLabel: topic,
          subjectColumnLabel: 'Phrase',
          help: help,
          phrases: const [
            SpokenLine(id: 's0', text: 'Guten Tag', translation: 'Good day'),
          ],
        );
      case AiQuizType.dictation:
        return DictationQuiz(
          id: id,
          title: topic,
          storageKeyPrefix: prefix,
          promptLabel: 'Satz',
          subjectsLabel: topic,
          subjectColumnLabel: 'Satz',
          help: help,
          items: const [
            SpokenLine(
              id: 's0',
              text: 'Das ist ein Beispiel.',
              translation: 'This is an example.',
            ),
          ],
        );
    }
  }
}
