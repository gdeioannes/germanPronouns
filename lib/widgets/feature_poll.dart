/// The one-time "what should we build next?" poll.
///
/// A single question with six options and one tap to answer, shown on the
/// course home once the learner has finished enough quizzes to have an opinion.
/// The whole point is response rate, so it is deliberately *not* a form: no
/// free text, no account, no second screen. The choice is recorded as an
/// anonymous Aptabase event (see [Analytics]) — there is no database behind
/// this and no personal data is stored — and answering pays coins.
///
/// It is asked at a high point — right after a quiz is finished — and then not
/// again for [kFeaturePollCooldown], whether it was answered or dismissed. A
/// prompt that reappears the next day is a reason to leave; one that comes back
/// a week later catches people whose priorities changed and gives the learners
/// who stuck around a second say. See [NounSettings.markFeaturePollShown].
library;

import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../models/coin_wallet.dart';
import '../models/course_session.dart';
import '../models/noun_settings.dart';
import '../services/analytics.dart';

/// How long the poll stays quiet after being shown. Long enough that it never
/// feels like nagging, short enough that a returning learner gets asked again
/// and priorities can be tracked as they shift.
const Duration kFeaturePollCooldown = Duration(days: 7);

/// How long to wait after a quiz is finished before asking, so the score, the
/// ribbon and the coin payout land first and the poll reads as a reward rather
/// than an interruption.
const Duration kFeaturePollDelay = Duration(milliseconds: 1400);

/// The wait to use when finishing also fires the full-screen unlock
/// celebration (the fill-in quiz): longer than that animation's 2.8s, so the
/// poll follows the confetti instead of landing on top of it.
const Duration kFeaturePollCelebrationDelay = Duration(milliseconds: 3200);

/// The analytics event recording an answer. The chosen option travels in the
/// `choice` property as [FeaturePollChoice.id].
const String kFeaturePollEvent = 'feature_poll';

/// The analytics event recording that the poll was shown and waved away.
/// Dismissals are data too — a high dismissal rate means the question, the
/// moment or the options are wrong.
const String kFeaturePollDismissedEvent = 'feature_poll_dismissed';

/// The options offered by the poll.
///
/// [id] is what lands in analytics: treat these strings as **stable**, since
/// renaming one splits its history across two labels in the dashboard. The
/// order here is the order shown, and the two the app most wants to decide
/// between come first.
enum FeaturePollChoice {
  /// Practice mini-games attached to each module.
  games('games', Icons.sports_esports_rounded),

  /// An account, so progress is saved and follows the learner across devices.
  account('account_sync', Icons.cloud_sync_rounded),

  /// More courses and language pairs.
  courses('more_courses', Icons.library_books_rounded),

  /// Drilling the questions this learner got wrong.
  mistakes('mistake_review', Icons.replay_rounded),

  /// More speaking and pronunciation work.
  speaking('speaking', Icons.mic_rounded),

  /// Daily reminders and practice goals.
  reminders('reminders', Icons.notifications_active_rounded);

  const FeaturePollChoice(this.id, this.icon);

  /// Stable analytics value. Never rename — it is the dashboard's key.
  final String id;

  /// Leading icon shown on the option row.
  final IconData icon;

  /// This option's label in the learner's UI language.
  String label(AppStrings strings) => switch (this) {
    FeaturePollChoice.games => strings.featurePollGames,
    FeaturePollChoice.account => strings.featurePollAccount,
    FeaturePollChoice.courses => strings.featurePollCourses,
    FeaturePollChoice.mistakes => strings.featurePollMistakes,
    FeaturePollChoice.speaking => strings.featurePollSpeaking,
    FeaturePollChoice.reminders => strings.featurePollReminders,
  };
}

/// Whether the poll is due: never shown, or last shown at least
/// [kFeaturePollCooldown] ago.
///
/// [now] is injectable so tests don't have to wait a week.
bool isFeaturePollDue({DateTime? now}) {
  final last = NounSettings.instance.featurePollLastShown;
  if (last == null) return true;
  return (now ?? DateTime.now()).difference(last) >= kFeaturePollCooldown;
}

/// Asks the poll after a quiz has just been finished, if it is due.
///
/// Safe to call unconditionally from every quiz kind's completion path: it
/// gates itself, waits [delay] so the celebration lands first, and bails out if
/// the learner has already navigated away.
Future<void> maybeShowFeaturePollAfterQuiz(
  BuildContext context, {
  Duration delay = kFeaturePollDelay,
}) async {
  if (!isFeaturePollDue()) return;
  await Future<void>.delayed(delay);
  if (!context.mounted) return;
  await showFeaturePoll(context, source: kFeaturePollSourceAfterQuiz);
}

/// Where a showing was opened from, recorded as the event's `source` so the
/// prompted answers can be told apart from the volunteered ones.
const String kFeaturePollSourceAfterQuiz = 'after_quiz';
const String kFeaturePollSourceSettings = 'settings';
const String kFeaturePollSourceHome = 'home';
const String kFeaturePollSourceLogin = 'login';

/// Shows the poll and records the outcome.
///
/// Adaptive like the app's other panels: a dialog on wide screens, a bottom
/// sheet on phones. The sheet rides the root navigator because the learner
/// shell stacks the room door tab over the shell navigator.
///
/// Always shows — the due check lives in [maybeShowFeaturePollAfterQuiz], so
/// the Settings and course-home buttons can open it whenever the learner asks.
/// Either outcome restarts the cooldown. Coins are only paid when the poll was
/// actually due, so the manual entry points can't be farmed for currency.
Future<void> showFeaturePoll(
  BuildContext context, {
  String source = kFeaturePollSourceAfterQuiz,
}) async {
  // The poll can be opened before the learner shell has booted — the login
  // page offers it — so load the state it reads and writes first. Both loads
  // are idempotent and cheap. This is not optional for the wallet: `add()`
  // increments from its in-memory balance, so adding to an unloaded wallet
  // would start from a stale zero and persist that, wiping the learner's coins.
  await NounSettings.instance.load();
  await CoinWallet.instance.load();
  if (!context.mounted) return;

  final rewarded = isFeaturePollDue();
  final screen = MediaQuery.sizeOf(context);
  final choice = screen.width >= 600
      ? await showDialog<FeaturePollChoice>(
          context: context,
          builder: (context) => Dialog(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 460,
                maxHeight: screen.height * 0.85,
              ),
              child: const SingleChildScrollView(child: _FeaturePollBody()),
            ),
          ),
        )
      : await showModalBottomSheet<FeaturePollChoice>(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          useRootNavigator: true,
          useSafeArea: true,
          // Six options wrap to two lines on a narrow phone, so the body is
          // taller than the sheet: it has to be a DraggableScrollableSheet
          // (the app's panel convention) or the last option and the dismiss
          // button fall off the bottom of the screen, unreachable.
          builder: (context) => DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.85,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (context, scrollController) => SingleChildScrollView(
              controller: scrollController,
              child: const _FeaturePollBody(),
            ),
          ),
        );

  // Starts the cooldown whatever the answer — including a tap outside to
  // dismiss — so nobody is asked twice in the same week.
  await NounSettings.instance.markFeaturePollShown();

  final courseId = CourseSession.instance.activeCourse.id;
  if (choice == null) {
    Analytics.track(kFeaturePollDismissedEvent, {
      'course': courseId,
      'source': source,
    });
    return;
  }
  Analytics.track(kFeaturePollEvent, {
    'choice': choice.id,
    'course': courseId,
    'source': source,
  });
  if (rewarded) await CoinWallet.instance.add(CoinWallet.featurePollBonus);

  if (!context.mounted) return;
  final strings = CourseSession.instance.strings;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      // Only promise coins when coins were actually paid.
      content: Text(
        rewarded
            ? strings.featurePollThanks
                .replaceAll('{coins}', '${CoinWallet.featurePollBonus}')
            : strings.featurePollThanksAgain,
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

/// The question, the six options and the dismiss button. Pops the enclosing
/// route with the chosen option, or null when waved away.
class _FeaturePollBody extends StatelessWidget {
  const _FeaturePollBody();

  @override
  Widget build(BuildContext context) {
    final strings = CourseSession.instance.strings;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline_rounded, color: colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  strings.featurePollTitle,
                  style: theme.textTheme.titleLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            strings.featurePollBody,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          for (final choice in FeaturePollChoice.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _OptionTile(choice: choice, label: choice.label(strings)),
            ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(strings.featurePollNotNow),
            ),
          ),
        ],
      ),
    );
  }
}

/// One tappable option. The whole row is the target — answering must never
/// cost more than a single tap.
class _OptionTile extends StatelessWidget {
  const _OptionTile({required this.choice, required this.label});

  final FeaturePollChoice choice;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).pop(choice),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(choice.icon, size: 22, color: colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(label, style: const TextStyle(fontSize: 15)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
