import 'dart:math';
import 'dart:ui' show PointMode;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_page.dart';
import '../models/coin_wallet.dart';
import '../models/course_session.dart';
import '../models/noun_settings.dart';
import '../models/quiz_content.dart';
import '../models/quiz_stats_keys.dart';
import '../services/drawing_score.dart';
import '../services/tts/tts_service.dart';
import '../theme/app_theme.dart';
import '../widgets/completion_ribbon.dart';
import '../widgets/feature_poll.dart';
import '../widgets/fireworks.dart';
import '../widgets/next_exercise.dart';
import '../widgets/quiz_panel.dart';
import '../widgets/quiz_scaffold.dart';
import '../widgets/voice_status_chip.dart';

/// One character to practice: the [symbol] drawn on the canvas (and read aloud
/// by TTS) and its [meaning] (pinyin · gloss) as the cue. [gender] picks the
/// voice that reads it.
class _DrawItem {
  const _DrawItem({
    required this.symbol,
    required this.meaning,
    required this.gender,
  });
  final String symbol;
  final String meaning;
  final VoiceGender gender;
}

/// One step of the play-through. Most cards are drawing cards; every few
/// drawings a [_ReadCard] flips the direction — the learner *reads* a
/// character they just drew and picks its pinyin/meaning — so writing and
/// recognition mix in one sitting.
sealed class _Card {
  const _Card(this.item);
  final _DrawItem item;
}

class _DrawCard extends _Card {
  const _DrawCard(super.item);
}

class _ReadCard extends _Card {
  const _ReadCard(super.item, this.options);

  /// The four cues offered (the item's own plus three distractors from this
  /// quiz), pre-shuffled.
  final List<_DrawItem> options;
}

/// How the current drawing card is played.
///
/// [trace]: the character shows as a faint template under the canvas — the
/// learner hears it and draws over it (the easy mode). [recall]: the template
/// is hidden — the learner draws purely from what they heard. The toggle only
/// shows/hides the template: the ink stays, so the learner can peek and
/// compare without losing the drawing.
enum _DrawMode { trace, recall }

/// A character-writing quiz ([QuizKind.draw]): TTS reads each character aloud
/// and the learner **draws** it on a practice grid — traced over a faint
/// template, or from memory. "Check my drawing" scores the ink against the
/// printed character (see [DrawingScorer]) into a tier — gold ≥ 65%, silver
/// ≥ 50%, bronze ≥ 35% — paying that card's coins on the spot with a
/// fireworks burst, like a good answer elsewhere (a mixed-in reading card
/// behaves the same). The run's ribbon is the tier *most* cards earned
/// ([majorityTier]); a run whose cards were mostly missed earns no ribbon and
/// does **not** complete the quiz — the next one stays locked until a run
/// earns at least bronze.
class DrawQuizPage extends StatefulWidget {
  const DrawQuizPage({
    super.key,
    required this.content,
    required this.currentPage,
    this.questProgressionKey,
  });

  final QuizContent content;
  final AppPage currentPage;

  /// When set, this quiz is a chain entry: playing through to the end marks
  /// this key complete, unlocking the next chain quiz.
  final String? questProgressionKey;

  @override
  State<DrawQuizPage> createState() => _DrawQuizPageState();
}

class _DrawQuizPageState extends State<DrawQuizPage>
    with TickerProviderStateMixin {
  final TtsService _voice = TtsService.instance;

  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  /// The per-card celebration burst (the shared [FireworksPainter], same as a
  /// good answer in the fill-in quizzes). Empty particles = nothing showing.
  late final AnimationController _fireworks = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() => _burst = const []);
      }
    });
  List<FireworkParticle> _burst = const [];
  final Random _rng = Random();

  bool _speaking = false;
  int _speakGen = 0;

  late final List<_DrawItem> _items = [
    for (final s in widget.content.subjects)
      _DrawItem(
        symbol: s.display,
        meaning: s.english ?? '',
        // Per-line speaker if set, otherwise the quiz's default voice.
        gender: s.voiceGender ?? widget.content.voiceGender,
      ),
  ];

  late List<_Card> _cards = _buildCards();

  int _index = 0;

  /// The strokes drawn on the current card, each a polyline of canvas-local
  /// points (normalized 0..1 so the drawing survives canvas resizes).
  final List<List<Offset>> _strokes = [];

  _DrawMode _mode = _DrawMode.trace;

  /// Whether the current drawing was checked (scored). Checking in recall
  /// mode also reveals the template as the comparison overlay.
  bool _checked = false;
  bool _scoring = false;
  DrawingScore? _score;

  /// The reading-card choice, once made (null = still open).
  _DrawItem? _chosen;

  /// The tier every finished card earned this run (null = missed: a drawing
  /// below 35% or skipped unchecked, a wrong reading pick). The tier that
  /// appears most decides the run's ribbon (see [majorityTier]).
  final List<RibbonTier?> _cardTiers = [];
  int _readCorrect = 0;
  int _readTotal = 0;

  /// Coins the current card just paid (shown in its verdict pill).
  int _cardCoins = 0;

  /// Instant payout per card tier — small change next to the ribbon bands,
  /// but every good drawing (or reading pick) pays something on the spot.
  static const Map<RibbonTier, int> _coinsPerCard = {
    RibbonTier.gold: 5,
    RibbonTier.silver: 3,
    RibbonTier.bronze: 1,
  };

  bool _finished = false;
  RibbonTier? _runTier;
  int _coinsEarned = 0;
  NextExercise? _nextExercise;

  _Card get _card => _cards[_index];
  _DrawItem get _item => _card.item;

  String get _learnLocale => CourseSession.instance.activeCourse.learnLocale;

  bool get _recall => _mode == _DrawMode.recall;

  @override
  void initState() {
    super.initState();
    _voice.speaking.addListener(_onSpeakingChanged);
    final questKey = widget.questProgressionKey;
    if (questKey != null) {
      _nextExercise = questNextExercise(questKey);
    } else {
      resolveNextExerciseForContent(widget.content.id).then((next) {
        if (mounted && next != null) setState(() => _nextExercise = next);
      });
    }
    _warmUpAndPlay();
  }

  /// The run's card sequence: every character as a drawing card, and after
  /// every third drawing a recognition card that revisits one character just
  /// drawn (its distractor cues come from this quiz's other characters).
  /// Quizzes with fewer than four characters can't fill a choice set and stay
  /// drawing-only.
  List<_Card> _buildCards() {
    final rng = Random();
    final cards = <_Card>[];
    final drawn = <_DrawItem>[];
    final used = <_DrawItem>{};
    for (final (i, item) in _items.indexed) {
      cards.add(_DrawCard(item));
      drawn.add(item);
      if ((i + 1) % 3 != 0 || _items.length < 4) continue;
      final pool = [
        for (final d in drawn)
          if (!used.contains(d) && d.meaning.isNotEmpty) d,
      ];
      if (pool.isEmpty) continue;
      final target = pool[rng.nextInt(pool.length)];
      used.add(target);
      final distractors = [
        for (final it in _items)
          if (!identical(it, target) && it.meaning.isNotEmpty) it,
      ]..shuffle(rng);
      final options = [target, ...distractors.take(3)]..shuffle(rng);
      cards.add(_ReadCard(target, options));
    }
    return cards;
  }

  Future<void> _warmUpAndPlay() async {
    await _voice.warmUp(_learnLocale);
    if (!mounted) return;
    Future<void>.delayed(const Duration(milliseconds: 600), () {
      if (mounted && !_finished) _autoPlay();
    });
  }

  void _onSpeakingChanged() {
    if (!mounted) return;
    final speaking = _voice.speaking.value;
    if (_speaking == speaking) return;
    // Run the pulse clock only while audio actually plays (see the dictation
    // page for why: a repeating controller would rebuild 60×/sec for nothing).
    if (speaking) {
      _pulse.repeat(reverse: true);
    } else {
      _pulse
        ..stop()
        ..value = 0;
    }
    setState(() => _speaking = speaking);
  }

  /// Auto-plays on entering a drawing card. A reading card stays silent until
  /// answered — hearing the character would give its pinyin away.
  void _autoPlay() {
    if (_cards.isNotEmpty && _card is _DrawCard) _play();
  }

  /// Reads the current character aloud, superseding any in-flight play.
  Future<void> _play() async {
    if (_cards.isEmpty) return;
    final gen = ++_speakGen;
    try {
      await _voice.stop();
      await Future<void>.delayed(const Duration(milliseconds: 150));
      if (!mounted || gen != _speakGen) return;
      await _voice.speak(_item.symbol, _learnLocale, gender: _item.gender);
    } catch (_) {
      // Ignore playback errors.
    }
  }

  void _setMode(_DrawMode mode) {
    if (_mode == mode) return;
    // Only the template's visibility changes — the ink stays put, so the
    // learner can flip between tracing and blind drawing to compare.
    setState(() => _mode = mode);
  }

  /// A card just earned [tier]: pay its coins on the spot and celebrate with
  /// a confetti burst — the same beat a good answer gets in the other quizzes,
  /// bigger the better the tier.
  Future<void> _reward(RibbonTier tier) async {
    final coins = _coinsPerCard[tier]!;
    _cardCoins = coins;
    await CoinWallet.instance.add(coins);
    if (!mounted) return;
    final colorScheme = Theme.of(context).colorScheme;
    final palette = [
      tierColor(tier),
      colorScheme.primary,
      Colors.amber,
      Colors.white,
    ];
    final count = switch (tier) {
      RibbonTier.gold => 90,
      RibbonTier.silver => 60,
      RibbonTier.bronze => 40,
    };
    setState(() {
      _burst = List.generate(count, (_) {
        final angle = _rng.nextDouble() * 2 * pi;
        return FireworkParticle(
          origin: Offset(
            0.2 + _rng.nextDouble() * 0.6,
            0.3 + _rng.nextDouble() * 0.3,
          ),
          direction: Offset(cos(angle), sin(angle)),
          speed: 55 + _rng.nextDouble() * 55,
          size: 2.0 + _rng.nextDouble() * 2.6,
          color: palette[_rng.nextInt(palette.length)],
        );
      });
    });
    _fireworks.forward(from: 0);
  }

  /// Scores the current drawing against the printed character. In recall mode
  /// this also reveals the template (the ink is first fitted onto it, so a
  /// correct character drawn small or off-center still scores). A tier pays
  /// out immediately.
  Future<void> _check() async {
    if (_checked || _scoring || _strokes.isEmpty) return;
    setState(() => _scoring = true);
    final score = await DrawingScorer.score(
      symbol: _item.symbol,
      strokes: [for (final s in _strokes) List.of(s)],
      alignToTemplate: _recall,
    );
    if (!mounted) return;
    final tier = ribbonTierForOverlap(score.overlap);
    _cardTiers.add(tier);
    setState(() {
      _scoring = false;
      _checked = true;
      _score = score;
    });
    if (tier != null) await _reward(tier);
  }

  /// Resolves a reading card. One tap counts — a correct pick is a full-marks
  /// (gold) card and pays like one; the audio then plays as reinforcement (it
  /// no longer gives anything away).
  Future<void> _choose(_DrawItem option) async {
    if (_chosen != null) return;
    final correct = identical(option, _card.item);
    _readTotal++;
    if (correct) _readCorrect++;
    _cardTiers.add(correct ? RibbonTier.gold : null);
    setState(() => _chosen = option);
    _play();
    if (correct) await _reward(RibbonTier.gold);
  }

  Future<void> _next() async {
    // A drawing card skipped without checking counts as a missed card in the
    // run's tally.
    if (_card is _DrawCard && !_checked) _cardTiers.add(null);
    _speakGen++;
    await _voice.stop();
    if (_index >= _cards.length - 1) {
      await _finish();
      return;
    }
    setState(() {
      _index++;
      _strokes.clear();
      _checked = false;
      _score = null;
      _chosen = null;
      _cardCoins = 0;
    });
    _autoPlay();
  }

  Future<void> _finish() async {
    // The run's ribbon is the tier most cards earned. Earning one pays the
    // tier's coin band and completes the quiz (unlocking the next in a gated
    // chain); a mostly-missed run earns nothing and the quiz stays open.
    final tier = majorityTier(_cardTiers);
    var coins = 0;
    if (tier != null) {
      coins = CoinWallet.rollTierCoins(tier);
      await CoinWallet.instance.add(coins);
      await _raiseRibbon(tier);
      await NounSettings.instance.markSpeakQuizCompleted(widget.content.id);
      if (widget.questProgressionKey != null) {
        await NounSettings.instance.markQuestQuizCompleted(
          widget.questProgressionKey!,
        );
      }
    }
    setState(() {
      _finished = true;
      _runTier = tier;
      _coinsEarned = coins;
    });
    // Earning a ribbon is what counts as finishing here, so only then is the
    // feature poll asked (self-gating: at most once a week, and only when due).
    if (tier != null && mounted) await maybeShowFeaturePollAfterQuiz(context);
  }

  /// Persists [tier] as the best-streak stat every ribbon display already
  /// reads (drawer tile, course home card), as the lap count that tier maps
  /// to. Only ever raises it, so the shown ribbon is the best run's.
  Future<void> _raiseRibbon(RibbonTier tier) async {
    final prefs = await SharedPreferences.getInstance();
    final key =
        QuizStatsKeys(widget.content.storageKeyPrefix).bestStreakAbsolute;
    final streak = lapsForTier(tier) * NounSettings.streakLapSize;
    if (streak > (prefs.getInt(key) ?? 0)) await prefs.setInt(key, streak);
  }

  void _restart() {
    _speakGen++;
    _voice.stop();
    setState(() {
      _cards = _buildCards();
      _index = 0;
      _strokes.clear();
      _checked = false;
      _score = null;
      _chosen = null;
      _cardCoins = 0;
      _cardTiers.clear();
      _readCorrect = 0;
      _readTotal = 0;
      _finished = false;
      _runTier = null;
      _coinsEarned = 0;
      _burst = const [];
    });
    _autoPlay();
  }

  @override
  void dispose() {
    _pulse.dispose();
    _fireworks.dispose();
    _voice.speaking.removeListener(_onSpeakingChanged);
    _voice.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QuizScaffold(
      content: widget.content,
      currentPage: widget.currentPage,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 8),
                if (_cards.isEmpty)
                  const QuizPanel(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'No characters to draw.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else if (_finished)
                  _buildSummary(context)
                else
                  // The confetti burst plays over whichever card just paid.
                  Stack(
                    children: [
                      if (_card case final _ReadCard card)
                        _buildReadCard(context, card)
                      else
                        _buildDrawCard(context),
                      if (_burst.isNotEmpty)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: AnimatedBuilder(
                              animation: _fireworks,
                              builder: (context, _) => CustomPaint(
                                painter: FireworksPainter(
                                  progress: _fireworks.value,
                                  particles: _burst,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressRow(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: (_index + 1) / _cards.length,
            minHeight: 6,
            borderRadius: BorderRadius.circular(kRadiusSmall),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '${_index + 1} / ${_cards.length}',
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDrawCard(BuildContext context) {
    // The template shows while tracing; in recall mode once checked, as the
    // comparison overlay under the learner's ink.
    final showTemplate = !_recall || _checked;
    // The cue (pinyin · meaning) is part of the help while tracing; in recall
    // mode the learner works from sound alone until the check.
    final showCue = !_recall || _checked;
    return QuizPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Align(alignment: Alignment.centerRight, child: VoiceStatusChip()),
          const SizedBox(height: 10),
          _buildProgressRow(context),
          const SizedBox(height: 12),
          Center(
            child: SegmentedButton<_DrawMode>(
              segments: const [
                ButtonSegment(
                  value: _DrawMode.trace,
                  icon: Icon(Icons.gesture_rounded),
                  label: Text('Trace'),
                ),
                ButtonSegment(
                  value: _DrawMode.recall,
                  icon: Icon(Icons.hearing_rounded),
                  label: Text('From memory'),
                ),
              ],
              selected: {_mode},
              onSelectionChanged: (s) => _setMode(s.first),
              showSelectedIcon: false,
            ),
          ),
          const SizedBox(height: 12),
          _buildSoundRow(context),
          if (showCue) ...[
            const SizedBox(height: 12),
            _buildCue(context),
          ],
          const SizedBox(height: 12),
          Center(
            child: _DrawCanvas(
              strokes: _strokes,
              template: showTemplate ? _item.symbol : null,
              // A revealed template is the checking overlay, so draw it a bit
              // stronger than the tracing guide.
              templateOpacity: _recall && _checked ? 0.35 : 0.18,
              // The score refers to the ink as checked — freeze it.
              enabled: !_checked,
              onStrokesChanged: () => setState(() {}),
            ),
          ),
          const SizedBox(height: 10),
          _buildCanvasTools(context),
          if (_checked && _score != null) ...[
            const SizedBox(height: 4),
            _buildScoreBadge(context, _score!),
          ],
          const SizedBox(height: 12),
          _buildDrawControls(context),
        ],
      ),
    );
  }

  /// The play button with the pulsing indicator.
  Widget _buildSoundRow(BuildContext context) {
    final theme = Theme.of(context);
    final strings = CourseSession.instance.strings;
    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(kRadiusLarge),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _speaking ? null : _play,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              _buildSpeakingIndicator(context),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _speaking ? strings.playing : strings.tapToListen,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: _speaking
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// The cue for the current character — its pinyin large and prominent, the
  /// English meaning right under it — sized for reading at a glance while the
  /// hand is busy drawing. The cue travels in the line's `english` field as
  /// "pinyin · meaning"; a line without the separator shows as meaning only.
  Widget _buildCue(BuildContext context) {
    final theme = Theme.of(context);
    final cue = _item.meaning;
    if (cue.isEmpty) return const SizedBox.shrink();
    final sep = cue.indexOf(' · ');
    final pinyin = sep < 0 ? null : cue.substring(0, sep);
    final gloss = sep < 0 ? cue : cue.substring(sep + 3);
    return Column(
      children: [
        if (pinyin != null)
          Text(
            pinyin,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        const SizedBox(height: 2),
        Text(
          gloss,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildSpeakingIndicator(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) {
        final active = _speaking;
        final color = active
            ? colorScheme.primary
            : colorScheme.onSurfaceVariant.withValues(alpha: 0.6);
        return Transform.scale(
          scale: active ? 1 + 0.18 * _pulse.value : 1,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: active ? 0.16 : 0.08),
            ),
            child: Icon(
              active ? Icons.graphic_eq_rounded : Icons.volume_up_rounded,
              color: color,
              size: 24,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCanvasTools(BuildContext context) {
    final locked = _strokes.isEmpty || _checked;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton.icon(
          onPressed: locked ? null : () => setState(() => _strokes.removeLast()),
          icon: const Icon(Icons.undo_rounded, size: 18),
          label: const Text('Undo'),
        ),
        const SizedBox(width: 8),
        TextButton.icon(
          onPressed: locked ? null : () => setState(() => _strokes.clear()),
          icon: const Icon(Icons.layers_clear_rounded, size: 18),
          label: const Text('Clear'),
        ),
      ],
    );
  }

  String _tierLabel(RibbonTier tier) => switch (tier) {
        RibbonTier.gold => 'Gold',
        RibbonTier.silver => 'Silver',
        RibbonTier.bronze => 'Bronze',
      };

  /// A card's verdict pill: its tier color/name plus [text] (overlap
  /// percentage, coins just paid…). A null [tier] is the "missed" look.
  Widget _buildTierPill(BuildContext context, RibbonTier? tier, String text) {
    final theme = Theme.of(context);
    final color =
        tier == null ? theme.colorScheme.onSurfaceVariant : tierColor(tier);
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              tier == null
                  ? Icons.gesture_rounded
                  : Icons.military_tech_rounded,
              size: 18,
              color: color,
            ),
            const SizedBox(width: 6),
            Text(
              text,
              style: theme.textTheme.labelLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// The per-drawing verdict: the overlap percentage, the tier it lands in
  /// (gold ≥ 65%, silver ≥ 50%, bronze ≥ 35%, below = keep at it) and the
  /// coins that just paid.
  Widget _buildScoreBadge(BuildContext context, DrawingScore score) {
    final tier = ribbonTierForOverlap(score.overlap);
    final label = tier == null ? 'Keep practicing' : _tierLabel(tier);
    final coins = _cardCoins > 0 ? ' · +$_cardCoins coins' : '';
    return _buildTierPill(context, tier, '${score.percent}% · $label$coins');
  }

  Widget _buildDrawControls(BuildContext context) {
    final strings = CourseSession.instance.strings;
    final isLast = _index >= _cards.length - 1;
    final nextButton = FilledButton.icon(
      onPressed: _next,
      icon: Icon(isLast ? Icons.flag_rounded : Icons.arrow_forward_rounded),
      label: Text(isLast ? strings.finish : strings.next),
    );

    if (_checked || _strokes.isEmpty) return nextButton;
    // Ink on the canvas, not scored yet: checking is the main move; skipping
    // (which counts the card as a miss) stays available but plays second.
    return Row(
      children: [
        Expanded(
          child: FilledButton.tonalIcon(
            onPressed: _next,
            icon: const Icon(Icons.skip_next_rounded),
            label: const Text('Skip'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.icon(
            onPressed: _scoring ? null : _check,
            icon: const Icon(Icons.visibility_rounded),
            label: const Text('Check my drawing'),
          ),
        ),
      ],
    );
  }

  /// The reading card: the character shown big, four cue choices under it. Silent
  /// until answered (the audio would hand over the pinyin), then the verdict
  /// colors the options, the character plays, and Next appears.
  Widget _buildReadCard(BuildContext context, _ReadCard card) {
    final theme = Theme.of(context);
    final strings = CourseSession.instance.strings;
    final isLast = _index >= _cards.length - 1;
    return QuizPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Align(alignment: Alignment.centerRight, child: VoiceStatusChip()),
          const SizedBox(height: 10),
          _buildProgressRow(context),
          const SizedBox(height: 16),
          Text(
            'You drew this one — pick its reading.',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            card.item.symbol,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 96, height: 1.2),
          ),
          const SizedBox(height: 16),
          for (final option in card.options) _buildReadOption(context, card, option),
          if (_chosen != null) ...[
            const SizedBox(height: 4),
            _buildTierPill(
              context,
              identical(_chosen, card.item) ? RibbonTier.gold : null,
              identical(_chosen, card.item)
                  ? 'Correct · +$_cardCoins coins'
                  : 'Missed',
            ),
            const SizedBox(height: 12),
            _buildSoundRow(context),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _next,
              icon: Icon(
                isLast ? Icons.flag_rounded : Icons.arrow_forward_rounded,
              ),
              label: Text(isLast ? strings.finish : strings.next),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReadOption(
    BuildContext context,
    _ReadCard card,
    _DrawItem option,
  ) {
    final theme = Theme.of(context);
    final resolved = _chosen != null;
    final isCorrect = identical(option, card.item);
    final isChosen = identical(option, _chosen);
    // After the tap the right cue turns green and a wrong pick red; the other
    // options fade.
    final green = Colors.green.shade400;
    Color? accent;
    if (resolved && isCorrect) accent = green;
    if (resolved && isChosen && !isCorrect) accent = theme.colorScheme.error;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: OutlinedButton(
        onPressed: resolved ? null : () => _choose(option),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          backgroundColor: accent?.withValues(alpha: 0.12),
          disabledForegroundColor:
              accent ?? theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          side: BorderSide(
            color: accent ?? theme.colorScheme.outlineVariant,
            width: accent == null ? 1 : 1.5,
          ),
        ),
        child: Text(
          option.meaning,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// The run's card tally, e.g. "Gold ×8 · Silver ×3 · Missed ×2" — the
  /// evidence behind the majority verdict.
  String _tierTallyLine() {
    final counts = <RibbonTier?, int>{};
    for (final t in _cardTiers) {
      counts[t] = (counts[t] ?? 0) + 1;
    }
    return [
      for (final t in const [
        RibbonTier.gold,
        RibbonTier.silver,
        RibbonTier.bronze,
      ])
        if ((counts[t] ?? 0) > 0) '${_tierLabel(t)} ×${counts[t]}',
      if ((counts[null] ?? 0) > 0) 'Missed ×${counts[null]}',
    ].join(' · ');
  }

  Widget _buildSummary(BuildContext context) {
    final theme = Theme.of(context);
    final strings = CourseSession.instance.strings;
    final tier = _runTier;
    final earned = tier != null;
    final color =
        earned ? Colors.green.shade700 : theme.colorScheme.onSurfaceVariant;
    return QuizPanel(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              earned ? Icons.celebration_rounded : Icons.refresh_rounded,
              size: 56,
              color: color,
            ),
            const SizedBox(height: 12),
            Text(
              strings.finished,
              style: theme.textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${_items.length} ${widget.content.subjectsLabel.toLowerCase()}',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            // The run's verdict: the tier most cards earned is the ribbon.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (tier != null) ...[
                  BookmarkRibbon(color: tierColor(tier), width: 16),
                  const SizedBox(width: 8),
                ],
                Text(
                  tier == null
                      ? 'Mostly missed — no ribbon this time'
                      : '${_tierLabel(tier)} ribbon — your most-earned tier',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: tier == null
                        ? theme.colorScheme.onSurfaceVariant
                        : tierColor(tier),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              _tierTallyLine(),
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (_coinsEarned > 0) ...[
              const SizedBox(height: 4),
              Text(
                '+$_coinsEarned coins',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
            if (_readTotal > 0) ...[
              const SizedBox(height: 4),
              Text(
                '$_readCorrect / $_readTotal ${strings.readingCorrect}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (!earned) ...[
              const SizedBox(height: 8),
              Text(
                'Earn a ribbon (most cards bronze or better) to finish this '
                'quiz and unlock the next one.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: _restart,
                    icon: const Icon(Icons.replay_rounded),
                    label: Text(strings.repeatAgain),
                  ),
                ),
                // The way forward only opens on an earned ribbon.
                if (earned && _nextExercise != null) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _nextExercise!.open(context),
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: Text(strings.nextExercise),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Drawing canvas ────────────────────────────────────────────────────────────

/// A square practice canvas: the classic 米字格 guide grid, an optional faint
/// [template] character behind, and the learner's ink on top. Strokes are held
/// in normalized (0..1) coordinates by the parent so undo/clear/redraws are its
/// state changes. Strokes are captured by an [_EagerPanGestureRecognizer] that
/// claims the pointer on contact, so a stroke that starts on the canvas can
/// never be stolen by the surrounding scroll view.
class _DrawCanvas extends StatelessWidget {
  const _DrawCanvas({
    required this.strokes,
    required this.template,
    required this.templateOpacity,
    required this.enabled,
    required this.onStrokesChanged,
  });

  final List<List<Offset>> strokes;
  final String? template;
  final double templateOpacity;

  /// While false (the drawing has been checked) new ink is ignored, so the
  /// shown score always matches the ink on the canvas.
  final bool enabled;
  final VoidCallback onStrokesChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final side = constraints.maxWidth.clamp(0.0, 340.0);
        Offset norm(Offset local) =>
            Offset(local.dx / side, local.dy / side);
        bool inside(Offset local) =>
            local.dx >= 0 && local.dy >= 0 && local.dx <= side && local.dy <= side;
        return SizedBox(
          width: side,
          height: side,
          child: RawGestureDetector(
            gestures: <Type, GestureRecognizerFactory>{
              _EagerPanGestureRecognizer: GestureRecognizerFactoryWithHandlers<
                  _EagerPanGestureRecognizer>(
                _EagerPanGestureRecognizer.new,
                (recognizer) => recognizer
                  ..dragStartBehavior = DragStartBehavior.down
                  ..onStart = (d) {
                    if (!enabled || !inside(d.localPosition)) return;
                    strokes.add([norm(d.localPosition)]);
                    onStrokesChanged();
                  }
                  ..onUpdate = (d) {
                    if (!enabled || strokes.isEmpty || !inside(d.localPosition)) {
                      return;
                    }
                    strokes.last.add(norm(d.localPosition));
                    onStrokesChanged();
                  },
              ),
            },
            child: CustomPaint(
              painter: _DrawPainter(
                strokes: strokes,
                template: template,
                templateColor:
                    colorScheme.onSurface.withValues(alpha: templateOpacity),
                gridColor: colorScheme.outlineVariant,
                inkColor: colorScheme.primary,
                backgroundColor: colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A pan recognizer that claims the pointer the moment it lands on the canvas.
/// Without this the ancestor [ListView]'s drag recognizer wins the gesture
/// arena for vertical movement and scrolls the page mid-stroke, making the
/// character impossible to draw.
class _EagerPanGestureRecognizer extends PanGestureRecognizer {
  @override
  void addAllowedPointer(PointerDownEvent event) {
    super.addAllowedPointer(event);
    resolve(GestureDisposition.accepted);
  }
}

class _DrawPainter extends CustomPainter {
  const _DrawPainter({
    required this.strokes,
    required this.template,
    required this.templateColor,
    required this.gridColor,
    required this.inkColor,
    required this.backgroundColor,
  });

  final List<List<Offset>> strokes;
  final String? template;
  final Color templateColor;
  final Color gridColor;
  final Color inkColor;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
    canvas.drawRRect(rrect, Paint()..color = backgroundColor);
    canvas.save();
    canvas.clipRRect(rrect);

    // The 米字格 guides: center cross + diagonals, dashed.
    final guide = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    void dashedLine(Offset a, Offset b) {
      const dash = 6.0, gap = 6.0;
      final total = (b - a).distance;
      final dir = (b - a) / total;
      var d = 0.0;
      while (d < total) {
        final end = (d + dash).clamp(0.0, total);
        canvas.drawLine(a + dir * d, a + dir * end, guide);
        d += dash + gap;
      }
    }

    dashedLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height));
    dashedLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2));
    dashedLine(Offset.zero, Offset(size.width, size.height));
    dashedLine(Offset(size.width, 0), Offset(0, size.height));

    // The faint template character (the tracing guide / checking overlay).
    // Laid out by the same helper the scorer rasterizes with, so what the
    // learner traces is exactly what the overlap is measured against.
    final t = template;
    if (t != null && t.isNotEmpty) {
      final painter = templateGlyphPainter(t, size.height, templateColor);
      painter.paint(
        canvas,
        Offset(
          (size.width - painter.width) / 2,
          (size.height - painter.height) / 2,
        ),
      );
    }

    // The learner's ink.
    final ink = Paint()
      ..color = inkColor
      ..strokeWidth = size.width * 0.03
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    for (final stroke in strokes) {
      if (stroke.isEmpty) continue;
      if (stroke.length == 1) {
        final p = Offset(stroke.first.dx * size.width, stroke.first.dy * size.height);
        canvas.drawPoints(PointMode.points, [p], ink..strokeCap = StrokeCap.round);
        continue;
      }
      final path = Path()
        ..moveTo(stroke.first.dx * size.width, stroke.first.dy * size.height);
      for (final p in stroke.skip(1)) {
        path.lineTo(p.dx * size.width, p.dy * size.height);
      }
      canvas.drawPath(path, ink);
    }
    canvas.restore();

    // The outer frame, drawn last so ink can't paint over it.
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = gridColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(covariant _DrawPainter old) => true;
}
