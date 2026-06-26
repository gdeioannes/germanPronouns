/// A slim, deliberately enigmatic strip docked at the bottom of every learner
/// screen: a faintly glowing closed door marked "???" that opens the apartment
/// mini-game. No plain label — it's meant to invite a curious tap.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MysteryBottomBar extends StatefulWidget {
  const MysteryBottomBar({super.key});

  @override
  State<MysteryBottomBar> createState() => _MysteryBottomBarState();
}

class _MysteryBottomBarState extends State<MysteryBottomBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        // Resolve the router only on tap, so building this needs no GoRouter in
        // the tree (keeps widget tests that render these scaffolds passing).
        onTap: () => context.push('/apartment'),
        child: Container(
          height: 52,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF241D40), Color(0xFF120E22)],
            ),
            border: Border(
              top: BorderSide(color: Color(0x33FFD54F)),
            ),
          ),
          child: SafeArea(
            top: false,
            child: AnimatedBuilder(
              animation: _pulse,
              builder: (context, _) {
                final t = Curves.easeInOut.transform(_pulse.value);
                final glow = Color.lerp(
                  const Color(0xFF8A7BC8),
                  const Color(0xFFFFD54F),
                  t,
                )!;
                return Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: glow.withValues(alpha: 0.25 + 0.45 * t),
                              blurRadius: 10 + 12 * t,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.door_front_door,
                          color: glow,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '???',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4 + 0.4 * t),
                          fontWeight: FontWeight.w800,
                          letterSpacing: 4,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
