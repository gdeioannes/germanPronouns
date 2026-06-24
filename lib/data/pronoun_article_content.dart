import '../models/quiz_content.dart';
import 'pronoun_article_quiz_config.dart';
import 'pronoun_article_sentences.dart';

/// The Pronouns & Articles quiz expressed as serializable [QuizContent], built
/// from the existing `PronounArticlePair` bank. The live app renders this
/// content from the course bundle (JSON, via `resolveQuizContent`);
/// `pronounArticleQuizConfig` is now only the compiled fallback + generator
/// source.
String _capitalize(String s) =>
    s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

final QuizContent pronounArticleQuizContent = QuizContent(
  id: 'pronoun_article',
  title: 'Pronouns & Articles Quiz',
  storageKeyPrefix: 'pronoun_article_',
  promptLabel: 'Pronoun',
  subjectsLabel: 'Pronouns',
  subjectColumnLabel: 'Pronoun',
  subjects: [
    for (var i = 0; i < pronounArticleSubjects.length; i++)
      QuizSubjectData(
        key: pronounArticleSubjects[i],
        display: pronounArticleSubjectDisplays[i],
        categories: pronounArticleSubjectCategories[i],
      ),
  ],
  categories: [
    for (final c in pronounArticleQuizCases)
      QuizCategoryData(label: c.label, group: c.group, values: c.values),
  ],
  sentences: [
    for (final p in pronounArticleSentences)
      QuizSentenceData(
        subjectKey: p.nominative,
        categoryLabel: _capitalize(p.case_),
        sentence: p.answerSentence,
        acceptedAnswers: [p.answer],
        prompt: p.question,
        explanationSections: [
          'Question: ${p.question}',
          'Answer: ${p.answer}',
          'Case: ${_capitalize(p.case_)}',
          'Nominative: ${p.nominative}',
          'Pattern: ${p.pattern == 'together' ? 'Pronouns together (consecutive)' : 'Pronouns separated (verb between)'}',
        ],
      ),
  ],
  helpMemoryTables: pronounArticleHelpMemoryTables,
  endingPatternTables: pronounArticleEndingPatternTables,
  helpMemorySubtitle: pronounArticleQuizConfig.helpMemorySubtitle,
  helpMemoryIntro:
      'This quiz mixes pronouns and articles: read the question and choose the '
      'correct accusative or dative form. The case depends on the verb and on '
      'what the question asks.',
  helpMemoryTips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Accusative vs. dative',
      text: 'The direct object (Wen/Was? — whom/what) takes the accusative; '
          'the indirect object (Wem? — to/for whom) takes the dative.',
    ),
    HelpMemoryTip(
      kind: 'example',
      text: 'Wen siehst du? — Ich sehe ihn. (acc)   '
          'Wem hilfst du? — Ich helfe ihm. (dat)',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Dative verbs',
      text: 'A few common verbs always take the dative: helfen, danken, '
          'gefallen, gehören, antworten.',
    ),
  ],
);
