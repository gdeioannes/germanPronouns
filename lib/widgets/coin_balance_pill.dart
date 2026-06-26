/// The always-visible coin balance: a small gold pill showing the global
/// [CoinWallet] total. Dropped into the [AppBar.actions] of every learner
/// screen so the wallet is on screen wherever you are; it live-updates (and
/// ticks the number up) from anywhere via the wallet's notifications.
library;

import 'package:flutter/material.dart';

import '../models/coin_wallet.dart';
import 'coin_glyph.dart';

class CoinBalancePill extends StatelessWidget {
  const CoinBalancePill({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      child: ListenableBuilder(
        listenable: CoinWallet.instance,
        builder: (context, _) {
          return Container(
            padding: const EdgeInsets.fromLTRB(7, 5, 11, 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
              border: Border.all(
                color: const Color(0xFFE3B341).withValues(alpha: 0.7),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CoinGlyph(size: 18, withShadow: false),
                const SizedBox(width: 6),
                // Tick the number up to the new balance whenever it changes.
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(
                    end: CoinWallet.instance.balance.toDouble(),
                  ),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                  builder: (context, value, _) => Text(
                    '${value.round()}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
