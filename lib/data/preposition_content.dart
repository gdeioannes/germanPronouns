import '../models/quiz_content.dart';
import 'preposition_data.dart';

/// Short case label per [PrepositionInfo.caseGroup], shown in the Help Memory
/// "Case" info column.
const Map<String, String> _caseShort = {
  'accusative': 'Akkusativ',
  'dative': 'Dativ',
  'genitive': 'Genitiv',
  'two-way': 'Akk. / Dativ',
};

/// The Prepositions quiz expressed as serializable [QuizContent], built from
/// the existing in-memory preposition data.
///
/// This is the proof case for the database migration: every field the engine
/// needs is captured as plain data here, so the same quiz could instead be
/// loaded from a database (see `buildQuizConfigFromContent`). The live app
/// renders this content from the course bundle (JSON, via `resolveQuizContent`);
/// `prepositionQuizConfig` is now only the compiled fallback + generator source.
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
  helpMemoryInfoColumns: [
    HelpMemoryInfoColumn(
      label: 'Case',
      values: [
        for (final p in prepositionInfos)
          _caseShort[p.caseGroup] ?? p.caseGroup,
      ],
    ),
  ],
  helpMemorySubtitle:
      'All 27 prepositions grouped by case, with English meanings and '
      'usage notes — exportable as a PDF study sheet.',
  endingPatternTables: prepositionEndingPatternTables,
  helpMemoryIntro:
      'German prepositions force a specific case on the noun that follows, and '
      'the article then changes to match. Three groups to know: accusative '
      '(durch, für, gegen, ohne, um), dative (aus, bei, mit, nach, seit, von, '
      'zu), and two-way (in, an, auf … — accusative for movement, dative for '
      'location). The "Case" column below shows each preposition\'s case.',
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
