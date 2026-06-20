import 'package:flutter/material.dart';

import '../data/db/content_repository.dart';
import '../data/noun_progression_data.dart';
import '../data/quest_data.dart';
import '../data/quiz_content_adapter.dart';
import '../data/quiz_stats_store.dart';
import '../models/app_session.dart';
import '../models/course.dart';
import '../models/course_session.dart';
import '../models/nav_layout.dart';
import '../models/noun_settings.dart';
import '../models/quiz_config.dart';
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
enum _UiKind { fillBlank, speak, quest, noun, nounFinal }

/// One quiz row on the course home: a regular/pronunciation quiz, or a Quest /
/// Noun-category chain entry. [config] is set only for fill-in quizzes that have
/// reference tables (so they go into the global PDF); chain entries and locked
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
    this.contentRef,
    this.questEntry,
    this.nounEntry,
    this.config,
  });

  final String title;
  final _UiKind uiKind;
  final int goalLaps;
  final String? summary;
  final QuizStats? stats;
  final bool done;
  final bool locked;

  // Exactly one open target is set (unless [locked]).
  final String? contentRef;
  final QuestEntry? questEntry;
  final NounProgressionEntry? nounEntry;

  final QuizConfig? config;

  bool get isSpeak => uiKind == _UiKind.speak;
  // Speak quizzes have no streak goal, but they're "finished" once played
  // through to the end, so they count toward the overview like the rest.
  bool get finishable => !locked;
  int get laps =>
      (stats?.bestStreakAbsolute ?? 0) ~/ NounSettings.streakLapSize;
}

/// A titled group of quiz rows (mirrors a navigation group).
class _HomeSection {
  _HomeSection(this.title, this.quizzes);
  final String title;
  final List<_HomeQuiz> quizzes;
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
            if (row != null) rows.add(row);
          }
          if (rows.isNotEmpty) sections.add(_HomeSection(group.title, rows));
        case NavGroupType.questChain:
          final rows = await _questRows();
          if (rows.isNotEmpty) sections.add(_HomeSection(group.title, rows));
        case NavGroupType.nounChain:
          final rows = await _nounRows();
          if (rows.isNotEmpty) sections.add(_HomeSection(group.title, rows));
        case NavGroupType.links:
          break;
      }
    }
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
    return _HomeQuiz(
      title: config.title,
      uiKind: _UiKind.fillBlank,
      goalLaps: _regularGoalLaps,
      summary: config.helpMemorySubtitle ?? config.helpMemoryIntro,
      stats: stats,
      done: NounSettings.instance.isQuizDone(
        bestStreakAbsolute: stats.bestStreakAbsolute,
      ),
      contentRef: ref,
      config: config,
    );
  }

  Future<List<_HomeQuiz>> _questRows() async {
    final completed = NounSettings.instance.completedQuestQuizzes;
    final unlocked = firstLockedQuestIndex(completed);
    final goalLaps =
        NounSettings.instance.questUnlockStreak ~/ NounSettings.streakLapSize;
    final rows = <_HomeQuiz>[];
    for (var i = 0; i < unlocked; i++) {
      final entry = questEntries[i];
      final stats = await quizStatsStore.load(entry.config.storageKeyPrefix);
      rows.add(
        _HomeQuiz(
          title: entry.displayName,
          uiKind: _UiKind.quest,
          goalLaps: goalLaps,
          stats: stats,
          done: NounSettings.instance.isQuestQuizCompleted(entry.key),
          questEntry: entry,
        ),
      );
    }
    if (unlocked < questEntries.length) {
      final entry = questEntries[unlocked];
      rows.add(
        _HomeQuiz(
          title: entry.displayName,
          uiKind: _UiKind.quest,
          goalLaps: goalLaps,
          locked: true,
          questEntry: entry,
        ),
      );
    }
    return rows;
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

  Future<void> _generateBooklet(List<_HomeQuiz> all) async {
    final configs = [
      for (final q in all)
        if (q.config != null) q.config!,
    ];
    if (configs.isEmpty) return;
    setState(() => _generatingPdf = true);
    try {
      await exportQuizzesBookletPdf(configs);
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
        title: Text(strings.home),
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
            final sections = snapshot.data ?? const [];
            final all = [for (final s in sections) ...s.quizzes];
            final hasPdf = all.any((q) => q.config != null);
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _courseHeaderCard(context, course),
                    const SizedBox(height: 12),
                    _overviewCard(context, all),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: (!hasPdf || _generatingPdf)
                            ? null
                            : () => _generateBooklet(all),
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

  Widget _overviewCard(BuildContext context, List<_HomeQuiz> all) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final strings = CourseSession.instance.strings;

    final finishable = all.where((q) => q.finishable).toList();
    final total = finishable.length;
    final finished = finishable.where((q) => q.done).length;
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
      _UiKind.fillBlank => (
        icon: Icons.menu_book_rounded,
        color: kSectionAccentColors[0],
      ),
      _UiKind.speak => (
        icon: Icons.record_voice_over_rounded,
        color: kSectionAccentColors[2],
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
        'Locked — keep going to unlock',
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
