import 'dart:ui' show PointMode;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../models/app_page.dart';
import '../models/coin_wallet.dart';
import '../models/course_session.dart';
import '../models/noun_settings.dart';
import '../models/quiz_content.dart';
import '../services/tts/tts_service.dart';
import '../theme/app_theme.dart';
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

/// How the current card is played.
///
/// [trace]: the character shows as a faint template under the canvas — the
/// learner hears it and draws over it (the easy mode). [recall]: the template
/// is hidden — the learner draws purely from what they heard, then reveals the
/// character to self-check (the hard mode).
enum _DrawMode { trace, recall }

/// A character-writing quiz ([QuizKind.draw]): TTS reads each character aloud
/// and the learner **draws** it on a practice grid — traced over a faint
/// template, or from memory with a reveal-to-check. There is no handwriting
/// recognition: checking is visual self-assessment against the revealed
/// template, so (like listen-&-repeat) the quiz completes on play-through and
/// never blocks progression.
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
    with SingleTickerProviderStateMixin {
  final TtsService _voice = TtsService.instance;

  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

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

  int _index = 0;

  /// The strokes drawn on the current card, each a polyline of canvas-local
  /// points (normalized 0..1 so the drawing survives canvas resizes).
  final List<List<Offset>> _strokes = [];

  _DrawMode _mode = _DrawMode.trace;

  /// In recall mode: true once the learner revealed the template to compare
  /// their drawing against it (enables the self-assessment step).
  bool _revealed = false;

  /// Recall-mode self-assessment tally, shown on the summary.
  int _gotIt = 0;
  int _attempted = 0;

  bool _finished = false;
  NextExercise? _nextExercise;

  _DrawItem get _item => _items[_index];

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

  Future<void> _warmUpAndPlay() async {
    await _voice.warmUp(_learnLocale);
    if (!mounted) return;
    Future<void>.delayed(const Duration(milliseconds: 600), () {
      if (mounted && !_finished) _play();
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

  /// Reads the current character aloud, superseding any in-flight play.
  Future<void> _play() async {
    if (_items.isEmpty) return;
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
    setState(() {
      _mode = mode;
      _strokes.clear();
      _revealed = false;
    });
    _play();
  }

  void _reveal() {
    if (_revealed) return;
    setState(() => _revealed = true);
  }

  /// Advances after a recall-mode self-check; [gotIt] is the learner's own
  /// verdict against the revealed template.
  Future<void> _assess(bool gotIt) async {
    _attempted++;
    if (gotIt) _gotIt++;
    await _next();
  }

  Future<void> _next() async {
    _speakGen++;
    await _voice.stop();
    if (_index >= _items.length - 1) {
      await _finish();
      return;
    }
    setState(() {
      _index++;
      _strokes.clear();
      _revealed = false;
    });
    _play();
  }

  Future<void> _finish() async {
    setState(() => _finished = true);
    // Play-through completion, sharing the speak set (a drawing quiz, like
    // listen-&-repeat, never blocks on being "right" — the check is visual).
    final newlyDone =
        !NounSettings.instance.isSpeakQuizCompleted(widget.content.id);
    await NounSettings.instance.markSpeakQuizCompleted(widget.content.id);
    if (newlyDone) {
      await CoinWallet.instance.add(CoinWallet.rollRibbonCoins(1));
    }
    if (widget.questProgressionKey != null) {
      await NounSettings.instance.markQuestQuizCompleted(
        widget.questProgressionKey!,
      );
    }
  }

  void _restart() {
    _speakGen++;
    _voice.stop();
    setState(() {
      _index = 0;
      _strokes.clear();
      _revealed = false;
      _gotIt = 0;
      _attempted = 0;
      _finished = false;
    });
    _play();
  }

  @override
  void dispose() {
    _pulse.dispose();
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
                if (_items.isEmpty)
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
                  _buildCard(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    final theme = Theme.of(context);
    // The template shows while tracing, and in recall mode only once revealed.
    final showTemplate = !_recall || _revealed;
    // The cue (pinyin · meaning) is part of the help while tracing; in recall
    // mode the learner works from sound alone until the reveal.
    final showCue = !_recall || _revealed;
    return QuizPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Align(alignment: Alignment.centerRight, child: VoiceStatusChip()),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: (_index + 1) / _items.length,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(kRadiusSmall),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${_index + 1} / ${_items.length}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
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
              templateOpacity: _recall && _revealed ? 0.35 : 0.18,
              onStrokesChanged: () => setState(() {}),
            ),
          ),
          const SizedBox(height: 10),
          _buildCanvasTools(context),
          const SizedBox(height: 12),
          _buildControls(context),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton.icon(
          onPressed: _strokes.isEmpty
              ? null
              : () => setState(() => _strokes.removeLast()),
          icon: const Icon(Icons.undo_rounded, size: 18),
          label: const Text('Undo'),
        ),
        const SizedBox(width: 8),
        TextButton.icon(
          onPressed: _strokes.isEmpty
              ? null
              : () => setState(() => _strokes.clear()),
          icon: const Icon(Icons.layers_clear_rounded, size: 18),
          label: const Text('Clear'),
        ),
      ],
    );
  }

  Widget _buildControls(BuildContext context) {
    final strings = CourseSession.instance.strings;
    final isLast = _index >= _items.length - 1;

    if (_recall && !_revealed) {
      // Draw from what you heard, then reveal the character to check.
      return FilledButton.icon(
        onPressed: _reveal,
        icon: const Icon(Icons.visibility_rounded),
        label: const Text('Check my drawing'),
      );
    }
    if (_recall && _revealed) {
      // Self-assessment against the revealed template.
      return Row(
        children: [
          Expanded(
            child: FilledButton.tonalIcon(
              onPressed: () => _assess(false),
              icon: const Icon(Icons.replay_rounded),
              label: const Text('Missed it'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton.icon(
              onPressed: () => _assess(true),
              icon: const Icon(Icons.check_rounded),
              label: const Text('Got it'),
            ),
          ),
        ],
      );
    }
    return FilledButton.icon(
      onPressed: _next,
      icon: Icon(isLast ? Icons.flag_rounded : Icons.arrow_forward_rounded),
      label: Text(isLast ? strings.finish : strings.next),
    );
  }

  Widget _buildSummary(BuildContext context) {
    final theme = Theme.of(context);
    final strings = CourseSession.instance.strings;
    final color = Colors.green.shade700;
    return QuizPanel(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.celebration_rounded, size: 56, color: color),
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
            if (_attempted > 0)
              Text(
                '$_gotIt / $_attempted ${strings.readingCorrect}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
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
                if (_nextExercise != null) ...[
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
    required this.onStrokesChanged,
  });

  final List<List<Offset>> strokes;
  final String? template;
  final double templateOpacity;
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
                    if (!inside(d.localPosition)) return;
                    strokes.add([norm(d.localPosition)]);
                    onStrokesChanged();
                  }
                  ..onUpdate = (d) {
                    if (strokes.isEmpty || !inside(d.localPosition)) return;
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
    final t = template;
    if (t != null && t.isNotEmpty) {
      final painter = TextPainter(
        text: TextSpan(
          text: t,
          style: TextStyle(
            fontSize: size.height * 0.72 / t.characters.length.clamp(1, 3),
            color: templateColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
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
