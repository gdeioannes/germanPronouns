import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/app_strings.dart';
import '../models/app_session.dart';
import '../models/course_session.dart';
import '../widgets/app_drawer.dart';
import '../widgets/coin_balance_pill.dart';
import '../widgets/person_scene.dart';

// The contact address, kept out of the source (and out of the shipped
// JS/asset bundle) as one literal string: harvesters grep compiled web builds
// for anything shaped like an address, and this never appears in that shape.
// The
// address is only assembled — and only rendered — once a human taps "Show
// email address", so a crawler that renders the page still sees nothing.
const String _emailUser = 'gdeioannes';
const String _emailDomain = 'gmail';
const String _emailTld = 'com';

/// The address learners can reach the author on, assembled at runtime. Same in
/// every UI language, so it lives here rather than in [AppStrings].
String contactEmail() =>
    '$_emailUser${String.fromCharCode(64)}$_emailDomain.$_emailTld';

/// A short, personal "why this app exists" page: who makes it, how the content
/// is produced (AI-drafted, human-corrected), and how to get in touch.
///
/// Reached from the About & Legal panel in Settings.
class AboutMePage extends StatelessWidget {
  const AboutMePage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = CourseSession.instance.strings;
    final theme = Theme.of(context);
    // Also reachable from the login screen, where there is no learner session:
    // the drawer and the coin balance only make sense once there is one.
    final inSession =
        AppSession.instance.isSignedIn && CourseSession.instance.hasChosenCourse;

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.aboutMeTitle),
        actions: [if (inSession) const CoinBalancePill()],
      ),
      drawer: inSession
          ? const AppDrawer(currentPage: AppPage.settings)
          : null,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Center(
                  child: PersonScene(PersonSceneKind.chat, height: 140),
                ),
                const SizedBox(height: 16),
                _paragraph(theme, strings.aboutMeWhy, lead: true),
                const SizedBox(height: 16),
                _paragraph(theme, strings.aboutMeContent),
                const SizedBox(height: 16),
                _paragraph(theme, strings.aboutMeFeedback),
                const SizedBox(height: 24),
                _ContactCard(strings: strings),
                const SizedBox(height: 24),
                Text(
                  strings.trademarkDisclaimer,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// One body paragraph; the opening one is set slightly larger so the page
  /// reads as a letter rather than a wall of settings text.
  Widget _paragraph(ThemeData theme, String text, {bool lead = false}) {
    final style = lead ? theme.textTheme.titleMedium : theme.textTheme.bodyLarge;
    return Text(text, style: style?.copyWith(height: 1.5));
  }
}

/// One "are you a robot?" challenge: a small sum, and four answers to pick
/// from. Deliberately arithmetic rather than a word puzzle so it reads the same
/// in every UI language.
class _HumanCheck {
  _HumanCheck(this.a, this.b, this.options);

  final int a;
  final int b;

  /// The correct answer plus three near misses, shuffled.
  final List<int> options;

  int get answer => a + b;

  static final Random _random = Random();

  factory _HumanCheck.next() {
    // Single digits: solvable at a glance, and the near-miss distractors stay
    // close enough that a random pick is a coin flip at best.
    final a = _random.nextInt(8) + 2;
    final b = _random.nextInt(8) + 2;
    final answer = a + b;
    final options = <int>{answer};
    while (options.length < 4) {
      final delta = _random.nextInt(7) - 3;
      if (delta != 0) options.add(answer + delta);
    }
    return _HumanCheck(a, b, options.toList()..shuffle(_random));
  }
}

/// The contact block. The address stays hidden behind a small human check: a
/// scraper that loads (or even renders, or even clicks through) the page finds
/// nothing, while a reader answers one sum and gets the address.
class _ContactCard extends StatefulWidget {
  const _ContactCard({required this.strings});

  final AppStrings strings;

  @override
  State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard> {
  /// Null until the check is passed — the address is not built before then.
  String? _email;

  /// The pending challenge, or null while the card is still just an invitation
  /// to start one. Regenerated after every wrong answer, so a bot cannot brute
  /// force one fixed sum.
  _HumanCheck? _check;

  /// Set after a wrong answer, cleared when the next one is offered.
  bool _wrong = false;

  void _startCheck() => setState(() {
        _check = _HumanCheck.next();
        _wrong = false;
      });

  void _answer(int value) => setState(() {
        if (value == _check!.answer) {
          _email = contactEmail();
        } else {
          // A fresh sum, so guessing means starting over each time.
          _check = _HumanCheck.next();
          _wrong = true;
        }
      });

  @override
  Widget build(BuildContext context) {
    final strings = widget.strings;
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(strings.aboutMeContact, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(strings.aboutMeWriteMe, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 4),
            if (_email == null && _check == null)
              Align(
                alignment: Alignment.centerLeft,
                child: FilledButton.tonalIcon(
                  onPressed: _startCheck,
                  icon: const Icon(Icons.alternate_email_rounded, size: 18),
                  label: Text(strings.aboutMeShowEmail),
                ),
              )
            else if (_email == null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.aboutMeRobotCheck,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_check!.a} + ${_check!.b} = ?',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final option in _check!.options)
                        OutlinedButton(
                          onPressed: () => _answer(option),
                          child: Text('$option'),
                        ),
                    ],
                  ),
                  if (_wrong) ...[
                    const SizedBox(height: 8),
                    Text(
                      strings.aboutMeRobotWrong,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ],
                ],
              )
            else
              Row(
                children: [
                  Flexible(
                    // Selectable so the address can be copied by hand too — the
                    // app has no url_launcher, so there is no mailto: link.
                    child: SelectableText(
                      _email!,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: MaterialLocalizations.of(context).copyButtonLabel,
                    icon: const Icon(Icons.copy_outlined, size: 18),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _email!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${_email!} '
                            '${MaterialLocalizations.of(context).copyButtonLabel.toLowerCase()}',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
