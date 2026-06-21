import 'package:flutter/material.dart';

import '../data/db/content_repository.dart';
import '../data/nav_layout_data.dart';
import '../data/noun_progression_data.dart';
import '../data/quest_data.dart';
import '../data/quiz_content_adapter.dart';
import '../data/quiz_stats_store.dart';
import '../models/app_session.dart';
import '../models/course.dart';
import '../models/course_session.dart';
import '../models/nav_layout.dart';
import '../models/noun_settings.dart';
import '../models/quiz_content.dart';
import '../models/quiz_stats.dart';
import '../theme/app_theme.dart';
import '../theme/brand_palette.dart';
import '../theme/help_memory_pdf.dart';
import '../widgets/app_drawer.dart';
import '../widgets/completion_ribbon.dart';
import '../widgets/noun_progression_quiz_loader.dart';
import '../widgets/quest_quiz_loader.dart';
import 'auth_gate.dart';

/// Visual kind of a home-page quiz row, driving its icon and accent color.
enum _UiKind { fillBlank, speak, reading, quest, noun, nounFinal }

/// The home-row visual kind for a Quest entry of [kind] (knowledge quizzes show
/// the Quest flag; speaking/reading show their own icon).
_UiKind _questUiKind(QuizKind kind) => switch (kind) {
  QuizKind.speakRepeat => _UiKind.speak,
  QuizKind.reading => _UiKind.reading,
  QuizKind.fillBlank => _UiKind.quest,
};

/// One quiz row on the course home: a regular/pronunciation quiz, or a Quest /
/// Noun-category chain entry. [bookletEntry] is set for quizzes that contribute
/// a section to the global reference PDF (fill-in → Help-Memory tables, reading
/// → passage + translation + questions); speak quizzes, chain entries and locked
/// rows leave it null.
class _HomeQuiz {
  _HomeQuiz({
    required this.title,
    required this.uiKind,
    required this.goalLaps,
    this.summary,
    this.stats,
    this.done = false,
    this.locked = false,
    this.lockedHint,
    this.contentRef,
    this.questEntry,
    this.nounEntry,
    this.bookletEntry,
  });

  final String title;
  final _UiKind uiKind;
  final int goalLaps;
  final String? summary;
  final QuizStats? stats;
  final bool done;
  final bool locked;

  /// Custom locked-state hint (e.g. "Complete A1.1 to unlock"); falls back to a
  /// generic message when null.
  final String? lockedHint;

  // Exactly one open target is set (unless [locked]).
  final String? contentRef;
  final QuestEntry? questEntry;
  final NounProgressionEntry? nounEntry;

  /// The section this quiz contributes to the all-quizzes reference PDF, or null
  /// if it has nothing to add (speak quizzes, chain entries, locked rows).
  final BookletEntry? bookletEntry;

  bool get isSpeak => uiKind == _UiKind.speak;
  bool get isReading => uiKind == _UiKind.reading;
  // Speak quizzes have no streak goal, but they're "finished" once played
  // through to the end, so they count toward the overview like the rest.
  bool get finishable => !locked;
  int get laps =>
      (stats?.bestStreakAbsolute ?? 0) ~/ NounSettings.streakLapSize;
}

/// A titled group of quiz rows (mirrors a navigation group).
///
/// [total]/[finished] describe the *whole* group for the overview ring — for a
/// Quest/Noun chain that means every quiz in the chain, including the ones still
/// locked (and therefore not present in [quizzes], which only lists the unlocked
/// rows plus the next locked teaser).
class _HomeSection {
  _HomeSection(
    this.title,
    this.quizzes, {
    required this.total,
    required this.finished,
    this.moreCount = 0,
  });
  final String title;
  final List<_HomeQuiz> quizzes;
  final int total;
  final int finished;

  /// How many further locked quizzes exist beyond the ones in [quizzes] — drives
  /// the "… +N more" row that caps a Quest preview window.
  final int moreCount;
}

/// The course landing page: one overview per language pair (e.g. English →
/// German). It summarizes the learner's history across every quiz in the active
/// course — the main quizzes, the listen-&-repeat pronunciation ones, and the
/// Quest / Noun-category chains — shows the share of quizzes finished, lets the
/// learner open any unlocked quiz, and exports a global reference PDF.
class CourseHomePage extends StatefulWidget {
  const CourseHomePage({super.key});

  @override
  State<CourseHomePage> createState() => _CourseHomePageState();
}

class _CourseHomePageState extends State<CourseHomePage> {
  late Future<List<_HomeSection>> _sectionsFuture;
  bool _generatingPdf = false;

  /// Reference-PDF sections for *every* quiz in the active course (regular,
  /// Quest and Noun — including still-locked ones), gathered in [_load]. Drives
  /// the always-available "Reference PDF (all quizzes)" study booklet (Help-Memory
  /// tables for fill-in quizzes, passage + translation + questions for reading).
  List<BookletEntry> _bookletEntries = const [];

  @override
  void initState() {
    super.initState();
    _sectionsFuture = _load();
  }

  Future<List<_HomeSection>> _load() async {
    await CourseSession.instance.loadCourses();
    final course = CourseSession.instance.activeCourse;
    // Order the Quest chain per this course before reading its unlock state.
    applyQuestOrderFromLayout(course.nav);

    final sections = <_HomeSection>[];
    // Every quiz's reference section for the always-on study booklet —
    // independent of lock state and of how many rows the home actually lists.
    final bookletEntries = <BookletEntry>[];
    ContentRepository? repo;
    try {
      repo = await contentRepository();
    } catch (_) {
      repo = null;
    }

    for (final group in course.nav.groups) {
      switch (group.type) {
        case NavGroupType.quizzes:
          if (repo == null) break;
          final rows = <_HomeQuiz>[];
          for (final item in group.items) {
            if (item.hidden) continue;
            final row = await _regularQuiz(repo, item.ref);
            if (row != null) {
              rows.add(row);
              final entry = row.bookletEntry;
              if (entry != null) bookletEntries.add(entry);
            }
          }
          // Regular quizzes are never locked, so the rows are the whole group.
          if (rows.isNotEmpty) {
            sections.add(_HomeSection(
              group.title,
              rows,
              total: rows.where((r) => r.finishable).length,
              finished: rows.where((r) => r.done).length,
            ));
          }
        case NavGroupType.questChain:
          final level = group.level;
          final quest = await _questRows(level: level);
          if (quest.rows.isNotEmpty) {
            final levelEntries = level == null
                ? questEntries
                : [for (final e in questEntries) if (e.levelLabel == level) e];
            // Fill-in quizzes contribute their Help-Memory tables; reading
            // quizzes contribute their passage + translation + questions;
            // speaking quizzes have nothing to put in the study booklet.
            for (final e in levelEntries) {
              switch (e.content.kind) {
                case QuizKind.fillBlank:
                  bookletEntries.add(HelpMemoryBookletEntry(e.config));
                case QuizKind.reading:
                  bookletEntries.add(ReadingBookletEntry(e.content));
                case QuizKind.speakRepeat:
                  break;
              }
            }
            sections.add(_HomeSection(
              group.title,
              quest.rows,
              total: levelEntries.length,
              finished: levelEntries
                  .where((e) =>
                      NounSettings.instance.isQuestQuizCompleted(e.key))
                  .length,
              moreCount: quest.moreCount,
            ));
          }
        case NavGroupType.nounChain:
          final rows = await _nounRows();
          if (rows.isNotEmpty) {
            bookletEntries.addAll(
              nounProgressionEntries.map((e) => HelpMemoryBookletEntry(e.config)),
            );
            sections.add(_HomeSection(
              group.title,
              rows,
              total: nounProgressionEntries.length,
              finished: nounProgressionEntries
                  .where((e) =>
                      NounSettings.instance.isNounCategoryCompleted(e.key))
                  .length,
            ));
          }
        case NavGroupType.links:
          break;
      }
    }
    _bookletEntries = bookletEntries;
    return sections;
  }

  int get _regularGoalLaps =>
      NounSettings.instance.quizGoalStreak ~/ NounSettings.streakLapSize;

  Future<_HomeQuiz?> _regularQuiz(ContentRepository repo, String ref) async {
    final content = await repo.quizContent(ref);
    if (content == null) return null;
    final stats = await quizStatsStore.load(content.storageKeyPrefix);
    if (content.kind == QuizKind.speakRepeat) {
      return _HomeQuiz(
        title: content.title,
        uiKind: _UiKind.speak,
        goalLaps: _regularGoalLaps,
        summary: content.helpMemorySubtitle ?? content.helpMemoryIntro,
        stats: stats,
        done: NounSettings.instance.isSpeakQuizCompleted(ref),
        contentRef: ref,
      );
    }
    final config = buildQuizConfigFromContent(
      content,
      currentPage: AppPage.articles,
    );
    final isReading = content.kind == QuizKind.reading;
    return _HomeQuiz(
      title: config.title,
      uiKind: isReading ? _UiKind.reading : _UiKind.fillBlank,
      goalLaps: _regularGoalLaps,
      summary: config.helpMemorySubtitle ?? config.helpMemoryIntro,
      stats: stats,
      // Reading has no streak — it's "done" once passed, like listen-&-repeat;
      // fill-in quizzes are done once their best streak reaches the goal.
      done: isReading
          ? NounSettings.instance.isReadingQuizCompleted(ref)
          : NounSettings.instance.isQuizDone(
              bestStreakAbsolute: stats.bestStreakAbsolute,
            ),
      contentRef: ref,
      bookletEntry: isReading
          ? ReadingBookletEntry(content)
          : HelpMemoryBookletEntry(config),
    );
  }

  /// Number of upcoming locked quizzes a Quest section previews before it caps
  /// the list with a "… +N more" row.
  static const int _questLockedPreview = 3;

  /// Rows for a Quest section. With [level] set, only quizzes of that CEFR
  /// sub-level are shown (the unlock frontier is still computed globally, so the
  /// chain stays continuous across levels). Shows the level's unlocked quizzes
  /// plus a short preview of the next quizzes to unlock; [moreCount] is how many
  /// further locked quizzes were left off (rendered as a "… +N more" row).
  Future<({List<_HomeQuiz> rows, int moreCount})> _questRows({
    String? level,
  }) async {
    final completed = NounSettings.instance.completedQuestQuizzes;
    final unlocked = firstLockedQuestIndex(completed);
    final goalLaps =
        NounSettings.instance.questUnlockStreak ~/ NounSettings.streakLapSize;

    // A whole sub-level (e.g. A1.2) stays locked until the previous one is
    // finished — shown as a single locked quest card rather than its quizzes.
    if (level != null && !isQuestLevelUnlocked(level, completed)) {
      final prior = questLevelBefore(level);
      return (
        rows: [
          _HomeQuiz(
            title: level,
            uiKind: _UiKind.quest,
            goalLaps: goalLaps,
            locked: true,
            lockedHint:
                prior == null ? 'Locked' : 'Complete $prior to unlock',
          ),
        ],
        moreCount: 0,
      );
    }

    final entries = questEntries;
    final rows = <_HomeQuiz>[];
    var lockedShown = 0;
    var moreCount = 0;
    for (var i = 0; i < entries.length; i++) {
      final entry = entries[i];
      if (level != null && entry.levelLabel != level) continue;
      if (i < unlocked) {
        final stats = await quizStatsStore.load(entry.config.storageKeyPrefix);
        rows.add(
          _HomeQuiz(
            title: entry.displayName,
            uiKind: _questUiKind(entry.content.kind),
            goalLaps: goalLaps,
            stats: stats,
            done: NounSettings.instance.isQuestQuizCompleted(entry.key),
            questEntry: entry,
          ),
        );
      } else if (lockedShown < _questLockedPreview) {
        // Preview the next few quizzes to unlock.
        rows.add(
          _HomeQuiz(
            title: entry.displayName,
            uiKind: _questUiKind(entry.content.kind),
            goalLaps: goalLaps,
            locked: true,
            questEntry: entry,
          ),
        );
        lockedShown++;
      } else {
        // Everything past the preview window is summarized by the "more" row.
        moreCount++;
      }
    }
    return (rows: rows, moreCount: moreCount);
  }

  Future<List<_HomeQuiz>> _nounRows() async {
    final completed = NounSettings.instance.completedNounCategories;
    final unlocked = firstLockedNounProgressionIndex(completed);
    final goalLaps = NounSettings.instance.progressionUnlockStreak ~/
        NounSettings.streakLapSize;

    _UiKind kindFor(NounProgressionEntry e) =>
        e.key == kAllNounsProgressionKey ? _UiKind.nounFinal : _UiKind.noun;

    final rows = <_HomeQuiz>[];
    for (var i = 0; i < unlocked; i++) {
      final entry = nounProgressionEntries[i];
      final stats = await quizStatsStore.load(entry.config.storageKeyPrefix);
      rows.add(
        _HomeQuiz(
          title: entry.displayName,
          uiKind: kindFor(entry),
          goalLaps: goalLaps,
          stats: stats,
          done: NounSettings.instance.isNounCategoryCompleted(entry.key),
          nounEntry: entry,
        ),
      );
    }
    if (unlocked < nounProgressionEntries.length) {
      final entry = nounProgressionEntries[unlocked];
      rows.add(
        _HomeQuiz(
          title: entry.displayName,
          uiKind: kindFor(entry),
          goalLaps: goalLaps,
          locked: true,
          nounEntry: entry,
        ),
      );
    }
    return rows;
  }

  void _open(_HomeQuiz quiz) {
    if (quiz.locked) return;
    if (quiz.questEntry != null) {
      NounSettings.instance.setLastQuestQuizKey(quiz.questEntry!.key);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => QuestQuizLoader(entry: quiz.questEntry!),
        ),
      );
    } else if (quiz.nounEntry != null) {
      NounSettings.instance.setLastPage(AppPage.nounsArticles.name);
      NounSettings.instance.setLastNounProgressionKey(quiz.nounEntry!.key);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => NounProgressionQuizLoader(entry: quiz.nounEntry!),
        ),
      );
    } else if (quiz.contentRef != null) {
      NounSettings.instance.setLastContentId(quiz.contentRef!);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => buildQuizPageForContent(quiz.contentRef!),
        ),
      );
    }
  }

  Future<void> _generateBooklet(List<BookletEntry> entries) async {
    if (entries.isEmpty) return;
    setState(() => _generatingPdf = true);
    try {
      await exportQuizzesBookletPdf(entries);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not generate PDF: $e')));
    } finally {
      if (mounted) setState(() => _generatingPdf = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final course = CourseSession.instance.activeCourse;
    final strings = CourseSession.instance.strings;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(strings.home),
            Text(
              course.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          if (AppSession.instance.role == UserRole.learner)
            IconButton(
              tooltip: strings.logOut,
              onPressed: () => signOutToLogin(context),
              icon: const Icon(Icons.logout_rounded),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHigh,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.outline.withValues(alpha: 0.4),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: const AppDrawer(currentPage: AppPage.articles),
      body: SafeArea(
        child: FutureBuilder<List<_HomeSection>>(
          future: _sectionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            final sections = snapshot.data ?? const <_HomeSection>[];
            final all = [for (final s in sections) ...s.quizzes];
            final finished =
                sections.fold<int>(0, (s, sec) => s + sec.finished);
            final total = sections.fold<int>(0, (s, sec) => s + sec.total);
            final hasPdf = _bookletEntries.isNotEmpty;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _courseHeaderCard(context, course),
                    const SizedBox(height: 12),
                    _overviewCard(
                      context,
                      all,
                      finished: finished,
                      total: total,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: (!hasPdf || _generatingPdf)
                            ? null
                            : () => _generateBooklet(_bookletEntries),
                        icon: _generatingPdf
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.picture_as_pdf_rounded),
                        label: Text(strings.generateAllPdf),
                      ),
                    ),
                    const SizedBox(height: 8),
                    for (final section in sections) ...[
                      _sectionLabel(context, section.title),
                      for (final quiz in section.quizzes) ...[
                        _quizRow(context, quiz),
                        const SizedBox(height: 8),
                      ],
                      if (section.moreCount > 0) ...[
                        _moreRow(context, section.moreCount),
                        const SizedBox(height: 8),
                      ],
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 6),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  /// Caps a Quest preview window: a compact, non-tappable "… +N more locked"
  /// row standing in for the quizzes past the preview.
  Widget _moreRow(BuildContext context, int count) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.more_horiz_rounded,
            size: 18,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Text(
            '+$count more locked',
            style: textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ── Course header ─────────────────────────────────────────────────────────

  Widget _courseHeaderCard(BuildContext context, Course course) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Text(
              '${course.speakFlag} → ${course.learnFlag}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    course.name,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    course.tagline,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Overview (history + % finished) ───────────────────────────────────────

  Widget _overviewCard(
    BuildContext context,
    List<_HomeQuiz> all, {
    required int finished,
    required int total,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final strings = CourseSession.instance.strings;

    final pct = total == 0 ? 0.0 : finished / total;

    final totalScore =
        all.fold<int>(0, (s, q) => s + (q.stats?.score ?? 0));
    final answered =
        all.fold<int>(0, (s, q) => s + (q.stats?.answerHistory.length ?? 0));
    final correct = all.fold<int>(
      0,
      (s, q) =>
          s +
          (q.stats?.answerHistory.where((h) => h['correct'] == true).length ??
              0),
    );
    final accuracyPct = answered == 0 ? null : (correct * 100 / answered).round();

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            _percentRing(context, pct),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$finished / $total ${strings.quizzesFinished}',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 14,
                    runSpacing: 6,
                    children: [
                      _miniStat(context, Icons.star_rounded, '$totalScore', 'pts'),
                      _miniStat(
                        context,
                        Icons.percent_rounded,
                        accuracyPct == null ? '—' : '$accuracyPct%',
                        'acc.',
                      ),
                      _miniStat(
                        context,
                        Icons.fact_check_rounded,
                        '$answered',
                        'answered',
                      ),
                    ],
                  ),
                  if (total == 0) ...[
                    const SizedBox(height: 6),
                    Text(
                      'No streak quizzes in this course.',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _percentRing(BuildContext context, double pct) {
    final colorScheme = Theme.of(context).colorScheme;
    final done = pct >= 1.0;
    return SizedBox(
      width: 72,
      height: 72,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: CircularProgressIndicator(
              value: pct,
              strokeWidth: 7,
              backgroundColor: colorScheme.surfaceContainerHighest,
              color: done ? const Color(kBrandForest) : colorScheme.primary,
            ),
          ),
          Text(
            '${(pct * 100).round()}%',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Widget _miniStat(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          value,
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(width: 3),
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  // ── Quiz row ──────────────────────────────────────────────────────────────

  ({IconData icon, Color color}) _visual(
    BuildContext context,
    _HomeQuiz quiz,
  ) {
    if (quiz.locked) {
      return (
        icon: Icons.lock_rounded,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );
    }
    return switch (quiz.uiKind) {
      // Reading / question / speak icons and colors come from the shared
      // [quizKindIcon]/[quizKindColor] maps so the home rows match the drawer
      // tiles for the same quizzes.
      _UiKind.fillBlank => (
        icon: quizKindIcon(QuizKind.fillBlank),
        color: quizKindColor(QuizKind.fillBlank),
      ),
      _UiKind.speak => (
        icon: quizKindIcon(QuizKind.speakRepeat),
        color: quizKindColor(QuizKind.speakRepeat),
      ),
      _UiKind.reading => (
        icon: quizKindIcon(QuizKind.reading),
        color: quizKindColor(QuizKind.reading),
      ),
      _UiKind.quest => (icon: Icons.flag_rounded, color: kSectionAccentColors[0]),
      _UiKind.noun => (icon: Icons.abc_rounded, color: kSectionAccentColors[2]),
      _UiKind.nounFinal => (
        icon: Icons.workspace_premium_rounded,
        color: kSectionAccentColors[3],
      ),
    };
  }

  Widget _quizRow(BuildContext context, _HomeQuiz quiz) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final visual = _visual(context, quiz);
    final titleColor =
        quiz.locked ? colorScheme.onSurfaceVariant : colorScheme.onSurface;

    final card = Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(kRadiusLarge),
        border: Border.all(
          color: quiz.done
              ? const Color(kBrandForest).withValues(alpha: 0.6)
              : colorScheme.outlineVariant,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(kRadiusLarge),
          onTap: quiz.locked ? null : () => _open(quiz),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Row(
              children: [
                IconBadge(icon: visual.icon, color: visual.color, size: 34),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        quiz.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: titleColor,
                        ),
                      ),
                      if (quiz.summary != null && !quiz.locked) ...[
                        const SizedBox(height: 1),
                        Text(
                          quiz.summary!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                      const SizedBox(height: 5),
                      _metaLine(context, quiz),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Completed cards surrender this corner to the award rosette
                // overlay, so the chevron is dropped (its width is kept so the
                // title doesn't reflow).
                if (quiz.done)
                  const SizedBox(width: 20)
                else
                  Icon(
                    quiz.locked
                        ? Icons.lock_outline_rounded
                        : Icons.chevron_right_rounded,
                    size: 20,
                    color: colorScheme.onSurfaceVariant,
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    if (!quiz.done) return card;
    // A finished quiz gets a simple bookmark ribbon tucked into its top-right
    // edge — clear of the left-aligned text. Its color marks the streak tier.
    return Stack(
      clipBehavior: Clip.none,
      children: [
        card,
        Positioned(
          top: -2,
          right: 14,
          child: BookmarkRibbon(color: tierColorForLaps(quiz.laps)),
        ),
      ],
    );
  }

  /// The small stat line under a quiz title: a locked hint, a pronunciation
  /// label, or score + streak-toward-goal for streak quizzes.
  Widget _metaLine(BuildContext context, _HomeQuiz quiz) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final muted = colorScheme.onSurfaceVariant;

    if (quiz.locked) {
      return Text(
        quiz.lockedHint ?? 'Locked — keep going to unlock',
        style: textTheme.labelSmall?.copyWith(color: muted),
      );
    }

    if (quiz.isSpeak) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.headphones_rounded, size: 14, color: muted),
          const SizedBox(width: 4),
          Text(
            'Listen & repeat',
            style: textTheme.labelSmall?.copyWith(color: muted),
          ),
        ],
      );
    }

    if (quiz.isReading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.menu_book_rounded, size: 14, color: muted),
          const SizedBox(width: 4),
          Text(
            'Read & answer',
            style: textTheme.labelSmall?.copyWith(color: muted),
          ),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, size: 14, color: muted),
        const SizedBox(width: 3),
        Text('${quiz.stats?.score ?? 0}', style: textTheme.labelSmall),
        const SizedBox(width: 12),
        Icon(Icons.bolt_rounded, size: 14, color: muted),
        const SizedBox(width: 3),
        Text(
          '×${quiz.laps}/${quiz.goalLaps}',
          style: textTheme.labelSmall?.copyWith(
            color: quiz.done ? const Color(kBrandForest) : null,
            fontWeight: quiz.done ? FontWeight.w700 : null,
          ),
        ),
      ],
    );
  }
}
