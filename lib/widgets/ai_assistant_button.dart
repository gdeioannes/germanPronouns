import 'package:flutter/material.dart';

import '../services/ai_assistant.dart';

/// "Open ChatGPT" / "Open Gemini" — the hand-off buttons under the copy button
/// on a speaking exercise.
///
/// The marks are drawn in code and are **generic** (a speech bubble, a spark),
/// not the products' logos. Naming an assistant you interoperate with is
/// ordinary nominative use; shipping its trademarked logo would mean carrying
/// third-party brand assets under their brand guidelines, which sits badly with
/// the rest of this app's deliberately conservative IP posture (see
/// docs/ip_copyright_review.md). Learners recognize the word, not the swirl.
class AiAssistantButton extends StatelessWidget {
  const AiAssistantButton({
    super.key,
    required this.assistant,
    required this.label,
    required this.onPressed,
    this.highlighted = false,
  });

  final AiAssistant assistant;

  /// The full button label, e.g. "Open ChatGPT" — built by the caller so the
  /// verb comes from [AppStrings] and the brand name doesn't get translated.
  final String label;

  final VoidCallback onPressed;

  /// Set on the assistant the learner used last time, so the returning learner
  /// sees their choice first without losing the other one.
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = highlighted
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        side: BorderSide(
          color: highlighted
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant,
          width: highlighted ? 1.5 : 1,
        ),
      ),
      icon: SizedBox.square(
        dimension: 18,
        child: CustomPaint(painter: _AiGlyph(assistant, color)),
      ),
      label: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.labelLarge,
      ),
    );
  }
}

/// The two generic marks, drawn to fit any square box.
class _AiGlyph extends CustomPainter {
  const _AiGlyph(this.assistant, this.color);

  final AiAssistant assistant;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final u = size.shortestSide;
    switch (assistant) {
      // A speech bubble: this assistant is a conversation.
      case AiAssistant.chatGpt:
        final stroke = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = u * 0.11
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round;
        final body = RRect.fromRectAndRadius(
          Rect.fromLTWH(u * 0.08, u * 0.12, u * 0.84, u * 0.6),
          Radius.circular(u * 0.2),
        );
        canvas.drawRRect(body, stroke);
        // The tail, hanging off the lower left.
        canvas.drawPath(
          Path()
            ..moveTo(u * 0.3, u * 0.72)
            ..lineTo(u * 0.28, u * 0.94)
            ..lineTo(u * 0.52, u * 0.72),
          stroke,
        );

      // A four-pointed spark: the shorthand the whole industry now uses for
      // "generative AI", and distinctive of no one.
      case AiAssistant.gemini:
        final fill = Paint()
          ..color = color
          ..style = PaintingStyle.fill;
        // A diamond whose sides bow in to the center, pinching the four tips
        // into arms. Every control point is the center, which is what makes the
        // waist deep enough to read as a spark rather than a rhombus.
        final c = Offset(u * 0.5, u * 0.5);
        canvas.drawPath(
          Path()
            ..moveTo(u * 0.5, 0)
            ..quadraticBezierTo(c.dx, c.dy, u, u * 0.5)
            ..quadraticBezierTo(c.dx, c.dy, u * 0.5, u)
            ..quadraticBezierTo(c.dx, c.dy, 0, u * 0.5)
            ..quadraticBezierTo(c.dx, c.dy, u * 0.5, 0)
            ..close(),
          fill,
        );
    }
  }

  @override
  bool shouldRepaint(_AiGlyph old) =>
      old.assistant != assistant || old.color != color;
}
