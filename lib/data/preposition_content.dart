import '../models/quiz_content.dart';
import 'preposition_data.dart';

/// The Prepositions quiz expressed as serializable [QuizContent], built from
/// the existing in-memory preposition data.
///
/// This is the proof case for the database migration: every field the engine
/// needs is captured as plain data here, so the same quiz could instead be
/// loaded from a database (see `buildQuizConfigFromContent`). The live app
/// still runs on `prepositionQuizConfig`; this is the round-trippable twin.
final QuizContent prepositionQuizContent = QuizContent(
  id: 'preposition',
  title: 'German Prepositions Quiz',
  storageKeyPrefix: 'preposition_',
  promptLabel: 'Preposition',
  subjectsLabel: 'Prepositions',
  subjectColumnLabel: 'Preposition',
  subjects: [
    for (final p in prepositionInfos)
      QuizSubjectData(
        key: p.preposition,
        display: p.englishClue,
        english: p.englishMeaning,
        notes: p.usageNotes,
        categories: [p.caseGroup],
      ),
  ],
  categories: [
    QuizCategoryData(
      label: 'Präposition',
      group: 'Präposition',
      values: prepositionSubjects,
    ),
  ],
  sentences: [
    for (final s in prepositionSentenceBank)
      QuizSentenceData(
        subjectKey: s.target,
        categoryLabel: 'Präposition',
        sentence: s.sentence,
        acceptedAnswers: s.accepted.toList(),
        hint: s.hint,
        english: s.english,
      ),
  ],
  categoryDisplayNames: prepositionCaseGroupNames,
  helpMemorySubtitle:
      'All 27 prepositions grouped by case, with English meanings and '
      'usage notes — exportable as a PDF study sheet.',
  endingPatternTables: prepositionEndingPatternTables,
  helpMemoryIntro:
      'German prepositions force a specific grammatical case on the noun that '
      'follows. Learn each preposition together with the case it triggers — '
      'the article then changes to match that case.',
  helpMemoryTips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Accusative prepositions',
      text: 'durch, für, gegen, ohne, um (+ bis, entlang) always take the '
          'accusative.',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Dative prepositions',
      text: 'aus, bei, mit, nach, seit, von, zu (+ gegenüber) always take the '
          'dative.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Two-way prepositions',
      text: 'in, an, auf, über, unter, vor, hinter, neben, zwischen take the '
          'accusative for movement (wohin?) and the dative for location (wo?).',
    ),
  ],
);
