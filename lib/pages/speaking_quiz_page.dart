import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/speaking_strings.dart';
import '../models/app_page.dart';
import '../models/coin_wallet.dart';
import '../models/course_session.dart';
import '../models/noun_settings.dart';
import '../models/quiz_content.dart';
import '../models/speaking_exercise.dart';
import '../services/ai_assistant.dart';
import '../services/analytics.dart';
import '../services/speaking_prompt.dart';
import '../theme/app_theme.dart';
import '../widgets/ai_assistant_button.dart';
import '../widgets/completion_ribbon.dart';
import '../widgets/feature_poll.dart';
import '../widgets/next_exercise.dart';
import '../widgets/quiz_scaffold.dart';
import '../widgets/speak_icon_button.dart';

/// The one-time "why does this run somewhere else?" sheet, keyed per install.
const String kSpeakingExplainerSeenKey = 'speaking_explainer_seen';

/// A speaking quiz ([QuizKind.speaking]): the app does **not** run the
/// conversation. It renders a ready-made exercise prompt the learner copies into
/// their own AI assistant, talks through there in voice mode, and comes back to
/// enter the score the AI gave them — which earns the usual medal, coins and
/// chain progression.
///
/// The trade this makes is deliberate: live conversational AI is the one thing
/// the app can't host for free, so the exercise is handed off rather than
/// paywalled. See `docs/speaking_quiz_feature.md`.
class SpeakingQuizPage extends StatefulWidget {
  const SpeakingQuizPage({
    super.key,
    required this.content,
    required this.currentPage,
    this.questProgressionKey,
  });

  final QuizContent content;
  final AppPage currentPage;

  /// When set, this quiz is a chain entry: a passing score marks this key
  /// complete, unlocking the next chain quiz.
  final String? questProgressionKey;

  @override
  State<SpeakingQuizPage> createState() => _SpeakingQuizPageState();
}

class _SpeakingQuizPageState extends State<SpeakingQuizPage> {
  final TextEditingController _scoreController = TextEditingController();

  SpeakingTemplate? _template;
  String? _prompt;
  bool _copied = false;

  /// The assistant the learner opened last time, shown first and highlighted.
  /// Null until the first hand-off, and on the first run of a fresh install.
  AiAssistant? _preferredAi;

  /// The best score saved for this quiz, or null if it was never run.
  int? _best;
  NextExercise? _nextExercise;

  /// The score just saved this session (drives the result card).
  int? _justSaved;

  SpeakingExercise get _exercise =>
      widget.content.speaking ??
      const SpeakingExercise(
        topic: '',
        practisePoints: [],
        scoringCriteria: [],
      );

  SpeakingStrings get _s => CourseSession.instance.strings.speaking;

  String get _bestKey => '${widget.content.storageKeyPrefix}speaking_best';

  int? get _typedScore => parseSpeakingScore(_scoreController.text);

  @override
  void initState() {
    super.initState();
    _load();
    final questKey = widget.questProgressionKey;
    if (questKey != null) {
      _nextExercise = questNextExercise(questKey);
    } else {
      resolveNextExerciseForContent(widget.content.id).then((next) {
        if (mounted && next != null) setState(() => _nextExercise = next);
      });
    }
  }

  Future<void> _load() async {
    final course = CourseSession.instance.activeCourse;
    final template = await SpeakingPromptBuilder.load(course.uiLang.name);
    final prompt = SpeakingPromptBuilder(template).render(
      _exercise,
      learnLang: course.learnLocale,
      uiLang: course.uiLang.name,
      cefr: widget.content.level ?? 'A1',
    );

    int? best;
    var explainerSeen = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      best = prefs.getInt(_bestKey);
      explainerSeen = prefs.getBool(kSpeakingExplainerSeenKey) ?? false;
    } catch (_) {
      // Best-effort: a storage failure must not block the exercise.
    }
    final preferredAi = await AiAssistant.lastUsed();
    if (!mounted) return;
    setState(() {
      _template = template;
      _prompt = prompt;
      _best = best;
      _preferredAi = preferredAi;
    });
    if (!explainerSeen && mounted) _showExplainer(markSeen: true);
  }

  @override
  void dispose() {
    _scoreController.dispose();
    super.dispose();
  }

  Future<void> _copy() async {
    final prompt = _prompt;
    if (prompt == null) return;
    await Clipboard.setData(ClipboardData(text: prompt));
    Analytics.track('speaking_copy', {'quiz': widget.content.id});
    if (!mounted) return;
    setState(() => _copied = true);
  }

  /// Hand off to the learner's assistant. Only reachable after [_copy], so the
  /// prompt is always on the clipboard by the time we get here — which is what
  /// makes an assistant with no prompt parameter (Gemini) usable at all.
  Future<void> _openAi(AiAssistant assistant) async {
    final prompt = _prompt;
    if (prompt == null) return;
    Analytics.track('speaking_open_ai', {
      'quiz': widget.content.id,
      'ai': assistant.name,
      'prefilled': assistant.prefills(prompt),
    });
    await assistant.remember();
    if (mounted) setState(() => _preferredAi = assistant);
    await assistant.open(prompt);
  }

  /// The ribbon tier a speaking medal pays out as — the seam between the
  /// Flutter-free scoring model and the shared ribbon/coin tiers.
  static RibbonTier _tier(SpeakingMedal medal) => switch (medal) {
    SpeakingMedal.gold => RibbonTier.gold,
    SpeakingMedal.silver => RibbonTier.silver,
    SpeakingMedal.bronze => RibbonTier.bronze,
  };

  Future<void> _save() async {
    final score = _typedScore;
    final template = _template;
    if (score == null || template == null) return;

    final session = resolvedSpeakingSession(_exercise, template);
    final passed = score >= session.passScore;
    final medal = speakingMedal(score);

    if (_best == null || score > _best!) {
      _best = score;
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(_bestKey, score);
      } catch (_) {
        // Best-effort.
      }
    }
    Analytics.track('speaking_score_saved', {
      'quiz': widget.content.id,
      'score': score,
      'grade': speakingGrade(score),
      'template': template.version,
    });

    if (passed) {
      final newlyDone = !NounSettings.instance.isSpeakQuizCompleted(
        widget.content.id,
      );
      await NounSettings.instance.markSpeakQuizCompleted(widget.content.id);
      // Coins pay once, on the first completion, in the medal's band — the same
      // ribbon tiers every other quiz pays out on.
      if (newlyDone && medal != null) {
        await CoinWallet.instance.add(CoinWallet.rollTierCoins(_tier(medal)));
      }
      if (widget.questProgressionKey != null) {
        await NounSettings.instance.markQuestQuizCompleted(
          widget.questProgressionKey!,
        );
      }
    }
    if (!mounted) return;
    setState(() {
      _justSaved = score;
      _scoreController.clear();
    });
    // Finishing a quiz is where the feature poll is asked (self-gating: at most
    // once a week, and only when due).
    if (passed && mounted) await maybeShowFeaturePollAfterQuiz(context);
  }

  void _runAgain() => setState(() {
    _justSaved = null;
    _copied = false;
  });

  Future<void> _showExplainer({bool markSeen = false}) async {
    if (markSeen) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(kSpeakingExplainerSeenKey, true);
      } catch (_) {
        // Best-effort — worst case the sheet shows once more.
      }
    }
    if (!mounted) return;
    final strings = CourseSession.instance.strings;
    await showModalBottomSheet<void>(
      context: context,
      // The learner shell's RoomPanel door tab covers non-root sheets.
      useRootNavigator: true,
      isScrollControlled: true,
      showDragHandle: true,
      // Sized to its content, capped at 90% of the viewport and scrolling only
      // past that. A DraggableScrollableSheet would pin the panel to a fixed
      // fraction of the screen, leaving a band of empty sheet under the button
      // on any window taller than the text.
      builder: (context) => ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.9,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(_s.whyTitle, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Text(_s.whyBody, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 28),
              Text(
                _s.qualityTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Text(
                _s.qualityBody,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(strings.gotIt),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prompt = _prompt;
    return QuizScaffold(
      content: widget.content,
      currentPage: widget.currentPage,
      body: prompt == null
          ? const Center(child: CircularProgressIndicator())
          // Same reading column as the other quiz pages, so a wide window
          // doesn't stretch the cards edge to edge.
          : SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      16,
                      16,
                      40 + MediaQuery.viewInsetsOf(context).bottom,
                    ),
                    children: [
                      _stepsCard(context),
                      const SizedBox(height: 20),
                      _copyCard(context),
                      const SizedBox(height: 20),
                      if (_justSaved != null)
                        _resultCard(context, _justSaved!)
                      else
                        _scoreCard(context),
                      if (_justSaved != null && _nextExercise != null) ...[
                        const SizedBox(height: 20),
                        FilledButton.icon(
                          onPressed: () => _nextExercise!.open(context),
                          icon: const Icon(Icons.arrow_forward_rounded),
                          label: Text(
                            CourseSession.instance.strings.nextExercise,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // -------------------------------------------------------------------------

  /// The four steps. Always on screen, not only on first run: learners forget
  /// the sequence between sessions, and the first-run sheet is read once.
  Widget _stepsCard(BuildContext context) {
    final steps = [_s.step1, _s.step2, _s.step3, _s.step4];
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _s.howItWorksTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                tooltip: _s.whyTitle,
                icon: const Icon(Icons.info_outline_rounded, size: 20),
                onPressed: _showExplainer,
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < steps.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StepNumber(i + 1),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      steps[i],
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _copyCard(BuildContext context) {
    final theme = Theme.of(context);
    final course = CourseSession.instance.activeCourse;
    final template = _template!;
    final session = resolvedSpeakingSession(_exercise, template);
    final trigger = SpeakingPromptBuilder(
      template,
    ).triggerFor(course.learnLocale);

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                _s.duration.replaceAll('{n}', '${session.durationMinutes}'),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _copy,
              icon: Icon(
                _copied ? Icons.check_rounded : Icons.copy_all_rounded,
              ),
              label: Text(_copied ? _s.copied : _s.copyExercise),
            ),
          ),
          // The hand-off appears only once the exercise is on the clipboard:
          // opening the assistant first would land the learner in an empty
          // chat with nothing to paste.
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: _copied
                ? _openAiSection(context)
                : const SizedBox(width: double.infinity),
          ),
          const SizedBox(height: 16),
          Text(
            _s.sayOutLoud,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Flexible(
                child: Text(
                  '"$trigger"',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              SpeakIconButton(text: trigger, locale: course.learnLocale),
            ],
          ),
          const SizedBox(height: 16),
          // The disclaimer that actually gets seen — persistent, never
          // dismissible, because the first-run sheet is read once and forgotten.
          Text(
            _s.disclaimerShort,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// The hand-off: one button per assistant, the last-used one first.
  ///
  /// Neither button can carry the exercise — it renders to ~3,000 characters,
  /// far past what any URL will hold — so both are "open the app, paste what
  /// you just copied". They exist to save the learner hunting for the app, not
  /// to save the paste.
  Widget _openAiSection(BuildContext context) {
    final theme = Theme.of(context);
    final assistants = [
      ?_preferredAi,
      ...AiAssistant.values.where((a) => a != _preferredAi),
    ];
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _s.openTitle,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (final assistant in assistants) ...[
                if (assistant != assistants.first) const SizedBox(width: 8),
                Expanded(
                  child: AiAssistantButton(
                    assistant: assistant,
                    label: _s.openAssistant.replaceAll('{ai}', assistant.label),
                    highlighted: assistant == _preferredAi,
                    onPressed: () => _openAi(assistant),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _s.openPasteHint,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _scoreCard(BuildContext context) {
    final theme = Theme.of(context);
    final valid = _typedScore != null;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_s.scoreSectionTitle, style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            _s.scoreHint,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _scoreController,
            maxLines: 3,
            minLines: 1,
            decoration: InputDecoration(
              labelText: _s.scoreField,
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => valid ? _save() : null,
          ),
          const SizedBox(height: 12),
          if (_best != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                '${_s.bestScore}: ${_best!} / 100',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: valid ? _save : null,
              child: Text(_s.saveScore),
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultCard(BuildContext context, int score) {
    final theme = Theme.of(context);
    final medal = speakingMedal(score);
    final grade = speakingGrade(score);
    final label = switch (medal) {
      SpeakingMedal.gold => _s.gold,
      SpeakingMedal.silver => _s.silver,
      SpeakingMedal.bronze => _s.bronze,
      null => null,
    };
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (medal != null) ...[
                BookmarkRibbon(color: tierColor(_tier(medal)), width: 26),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label ?? _s.savedTitle,
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      '$score / 100  ·  $grade/10',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            medal == null ? _s.tryAgain : _s.readFeedback,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _runAgain,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(_s.runAgain),
          ),
        ],
      ),
    );
  }
}

/// The page's shared surface: one rounded panel per block.
class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(kRadiusLarge),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: child,
    );
  }
}

class _StepNumber extends StatelessWidget {
  const _StepNumber(this.n);

  final int n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Text(
        '$n',
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
