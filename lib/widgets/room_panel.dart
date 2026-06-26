import 'package:flutter/material.dart';

import '../models/apartment.dart';
import '../pages/apartment_page.dart';

/// The room ("My Room") as a panel docked at the bottom of every learner screen,
/// instead of a separate full-screen route — so it feels part of the app.
///
/// It peeks at the bottom (showing the room's header bar) and slides up to ~90%
/// of the screen on tap or drag, always leaving the top [_topGap] of the app
/// visible behind it, and slides back down to hide. The panel (and the room's
/// state) lives in the learner shell, so it persists as the learner navigates.
class RoomPanel extends StatefulWidget {
  const RoomPanel({super.key});

  @override
  State<RoomPanel> createState() => _RoomPanelState();
}

class _RoomPanelState extends State<RoomPanel>
    with SingleTickerProviderStateMixin {
  // 0 = hidden (only the header peeks), 1 = open (covers ~90%).
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
    value: 0,
  );

  /// Height of the little door tab that pokes out at the bottom when closed.
  static const double _peek = 38;

  /// Fraction of the screen left showing the app behind when the panel is open.
  static const double _topGap = 0.05;

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  bool get _isOpen => _c.value > 0.5;
  void _open() => _c.animateTo(1, curve: Curves.easeOutCubic);
  void _close() => _c.animateTo(0, curve: Curves.easeInCubic);
  void _toggle() => _isOpen ? _close() : _open();

  void _onDrag(double delta, double travel) =>
      _c.value = (_c.value - delta / travel).clamp(0.0, 1.0);

  void _onDragEnd(double velocity) {
    if (velocity < -250) {
      _open();
    } else if (velocity > 250) {
      _close();
    } else {
      _isOpen ? _open() : _close();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fill the shell's Stack, then position the panel within our own Stack — a
    // Positioned must be a *direct* child of a Stack, so the LayoutBuilder
    // (which we need for the height) can't sit between them.
    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, c) {
          final h = c.maxHeight;
          final openTop = h * _topGap;
          final closedTop = h - _peek;
          final travel = closedTop - openTop;
          return AnimatedBuilder(
            animation: _c,
            child: _content(context, travel),
            builder: (context, child) {
              final t = _c.value;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  // While the panel is up, dim the app behind and swallow taps
                  // on it; tapping the dimmed area closes the panel. Absent when
                  // closed, so the app stays fully interactive.
                  if (t > 0.001)
                    Positioned.fill(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _close,
                        child: ColoredBox(
                          color: Colors.black.withValues(alpha: 0.5 * t),
                        ),
                      ),
                    ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: closedTop - t * travel,
                    height: h - openTop,
                    child: child!,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _content(BuildContext context, double travel) {
    // Rebuild the tab + sheet chrome when night mode flips, so the panel matches
    // the room's dark mode (which is itself persisted via Apartment.isNight).
    return ListenableBuilder(
      listenable: Apartment.instance,
      builder: (context, _) {
        final barColor = Apartment.instance.isNight
            ? const Color(0xFF26212F)
            : const Color(0xFF6F5544);
        return Column(
          children: [
            // The little door tab: tap to open/close, drag to slide. It's the
            // only thing showing when the panel is closed.
            SizedBox(
              height: _peek,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _toggle,
                    onVerticalDragUpdate: (d) =>
                        _onDrag(d.primaryDelta ?? 0, travel),
                    onVerticalDragEnd: (d) =>
                        _onDragEnd(d.primaryVelocity ?? 0),
                    child: _RoomTab(color: barColor),
                  ),
                ),
              ),
            ),
            // The room sheet fills the rest. Drop the top padding so its app bar
            // sits flush under the tab wherever the panel is.
            Expanded(
              child: Material(
                elevation: 18,
                color: barColor,
                clipBehavior: Clip.antiAlias,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: const ApartmentPage(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// The small door tab that pokes out at the bottom of the screen; tapping it
/// raises/lowers the room panel.
class _RoomTab extends StatelessWidget {
  const _RoomTab({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: _RoomPanelState._peek,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 8,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.door_front_door,
        color: Color(0xFFFFD98A),
        size: 22,
      ),
    );
  }
}
