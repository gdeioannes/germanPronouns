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
  )..addListener(_syncRoomMounted);

  /// Height of the little door tab that pokes out at the bottom when closed.
  static const double _peek = 38;

  // The room ([ApartmentPage]) is heavy — its idle clock ticks and it repaints
  // continuously — so we keep it out of the tree entirely while the panel sits
  // fully closed. Then only the door tab lives in the shell; the room mounts the
  // instant a tap/drag begins to open it, and unmounts again once it settles
  // shut. The furniture is held in the [Apartment.instance] singleton, so the
  // room is unchanged across mount/unmount (transient view state — zoom, shop
  // split — resets, matching the existing "every visit starts at 1×" intent).
  bool _roomMounted = false;

  void _syncRoomMounted() {
    final shouldMount = _c.value > 0;
    if (shouldMount != _roomMounted) {
      setState(() => _roomMounted = shouldMount);
    }
  }

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
          // Open to just under the status bar so the room covers the screen
          // (including the page header behind it) — one header, not two.
          final openTop = MediaQuery.paddingOf(context).top;
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
            // When closed, a little door tab peeks at the bottom-right (tap to
            // open, drag to slide). When open it becomes a slim, centered grab
            // handle — a clearer "drag down to close" affordance that doesn't
            // look like a stray floating tab, and frees a little height.
            AnimatedBuilder(
              animation: _c,
              builder: (context, _) {
                final open = _c.value > 0.5;
                return SizedBox(
                  height: open ? 22 : _peek,
                  child: Align(
                    alignment: open ? Alignment.center : Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: open ? 0 : 16),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _toggle,
                        onVerticalDragUpdate: (d) =>
                            _onDrag(d.primaryDelta ?? 0, travel),
                        onVerticalDragEnd: (d) =>
                            _onDragEnd(d.primaryVelocity ?? 0),
                        child: open
                            ? const _GrabHandle()
                            : _RoomTab(color: barColor),
                      ),
                    ),
                  ),
                );
              },
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
                // Only build the room while the panel is off its closed rest
                // position; otherwise the Expanded sits off-screen and empty.
                child: _roomMounted
                    ? MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ApartmentPage(onClose: _close),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// The slim grab handle shown at the top of the panel while it's open — a clear
/// "drag down to close" affordance.
class _GrabHandle extends StatelessWidget {
  const _GrabHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 22,
      alignment: Alignment.center,
      child: Container(
        width: 44,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(3),
        ),
      ),
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
