import '../models/course.dart';
import '../models/quiz_content.dart';
import '../models/speaking_exercise.dart';

/// How many stored corrections the course home needs before it offers the
/// trainer — fewer makes a session too thin to be worth the hand-off.
const int kMistakeTrainerMinFixes = 3;

/// How many corrections one trainer session drills, newest first.
const int kMistakeTrainerMaxFixes = 10;

/// The "train your mistakes" exercise: a synthetic speaking quiz whose
/// material *is* the learner's own recent `FIX:` corrections (parsed from
/// pasted AI reports, see `NounSettings.speakingFixLog`). Not part of any
/// course's nav or bundles — built on demand from the course home, run through
/// the ordinary speaking machinery, and re-buildable as the log changes.
QuizContent mistakeTrainerContent(Course course, List<SpeakingFix> fixes) {
  final drilled = fixes.take(kMistakeTrainerMaxFixes).toList();
  final lines = [
    for (var i = 0; i < drilled.length; i++)
      '${i + 1}. I said: "${drilled[i].said}" -> correct: '
          '"${drilled[i].correct}"',
  ];
  final id = 'mistake_trainer_${course.id}';
  return QuizContent(
    id: id,
    title: 'Train your mistakes',
    kind: QuizKind.speaking,
    level: 'B1',
    storageKeyPrefix: '${id}_',
    promptLabel: 'Exercise',
    subjectsLabel: 'Exercise',
    subjectColumnLabel: 'Exercise',
    subjects: const [],
    categories: const [],
    sentences: const [],
    speaking: SpeakingExercise(
      topic:
          'A repair drill over my own past mistakes, listed in MATERIAL. '
          'For each item, read me my old wrong sentence exactly as written; '
          'I answer with the corrected version. After I get one right, ask '
          'me for one fresh sentence using the same pattern.',
      material:
          'My recorded mistakes (wrong -> correct):\n${lines.join('\n')}\n'
          'Drill: present my wrong sentence, never the correction; I must '
          'produce the corrected form myself.',
      practisePoints: const [
        'Each corrected form produced accurately',
        'The pattern behind the mistake applied to a fresh sentence',
      ],
      scoringCriteria: const [
        'the corrected form exactly right',
        'the old mistake not repeated',
      ],
      mode: SpeakingMode.vocabDrill,
      scaffolded: false,
      session: SpeakingSession(
        durationMinutes: 4,
        minExchanges: drilled.length.clamp(6, kMistakeTrainerMaxFixes),
      ),
      passScore: 60,
    ),
    helpMemoryIntro:
        'This exercise is built from your own recent mistakes — the FIX '
        'lines of the reports you pasted back. Beat them here and they stop '
        'following you around.',
  );
}
