import 'package:flutter/material.dart';

import '../models/app_session.dart';
import '../theme/brand_palette.dart';
import '../widgets/person_scene.dart';

/// The app's front door: a split brand poster. One pane is a navy field with
/// the wordmark and the People cast greeting in four languages; the other
/// carries a single "start learning" action. Wide screens show them side by
/// side, narrow ones stack the poster above the actions.
///
/// Learners enter directly (no account); teachers unlock the back office with
/// the local passcode behind a quiet footer link.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.startInTeacherMode = false});

  /// Opens directly in teacher-passcode mode — used when a remembered teacher
  /// returns and just needs to re-enter the passcode.
  final bool startInTeacherMode;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _passcodeController = TextEditingController();
  late bool _teacherMode = widget.startInTeacherMode;
  String? _error;

  @override
  void dispose() {
    _passcodeController.dispose();
    super.dispose();
  }

  void _submitTeacher() {
    final ok = AppSession.instance.signInAsTeacher(_passcodeController.text);
    if (!ok) {
      setState(() => _error = 'Incorrect passcode.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 840;
          if (wide) {
            return Row(
              children: [
                Expanded(flex: 5, child: _PosterPane(compact: false)),
                Expanded(flex: 6, child: _actionPane()),
              ],
            );
          }
          // Stacked: actions first so the enter button sits in easy reach,
          // the brand poster grounding the bottom of the screen.
          return Column(
            children: [
              Expanded(child: _actionPane()),
              SizedBox(
                height: (constraints.maxHeight * 0.40).clamp(240.0, 380.0),
                child: _PosterPane(compact: true),
              ),
            ],
          );
        },
      ),
    );
  }

  /// The light half: one welcome + one action (or the passcode form), with
  /// the teacher door demoted to a quiet footer link.
  Widget _actionPane() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(32, 32, 32, 56),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!_teacherMode) ...[
                      Text(
                        'Start learning today',
                        textAlign: TextAlign.center,
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Quick, focused quizzes with audio on every '
                        'sentence. Free, no account needed.',
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 28),
                      FilledButton(
                        onPressed: AppSession.instance.signInAsLearner,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          textStyle: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: const Text('Start learning'),
                      ),
                    ] else ...[
                      Text(
                        'Back office',
                        textAlign: TextAlign.center,
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _passcodeController,
                        autofocus: true,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Teacher passcode',
                          errorText: _error,
                          prefixIcon: const Icon(Icons.lock_rounded),
                        ),
                        onChanged: (_) {
                          if (_error != null) setState(() => _error = null);
                        },
                        onSubmitted: (_) => _submitTeacher(),
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: _submitTeacher,
                        child: const Text('Enter back office'),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => setState(() {
                          _teacherMode = false;
                          _error = null;
                          _passcodeController.clear();
                        }),
                        child: const Text('Back'),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Teacher access is a local gate, not secure sign-in.',
                        textAlign: TextAlign.center,
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          // The staff door: present but quiet, out of the learner's way.
          if (!_teacherMode)
            Positioned(
              right: 8,
              bottom: 4,
              child: TextButton(
                onPressed: () => setState(() => _teacherMode = true),
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.onSurfaceVariant,
                  textStyle: textTheme.labelMedium,
                ),
                child: const Text('Teacher sign in'),
              ),
            ),
        ],
      ),
    );
  }
}

/// The navy brand field: wordmark, promise line and the greeting cast.
/// [compact] tightens spacing and type for the stacked phone layout.
class _PosterPane extends StatelessWidget {
  const _PosterPane({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: const Color(kBrandNavy),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        horizontal: 28,
        vertical: compact ? 20 : 48,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Language Quiz',
            textAlign: TextAlign.center,
            style:
                (compact ? textTheme.headlineMedium : textTheme.displayMedium)
                    ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: compact ? 4 : 8),
          Text(
            'Free interactive courses · A1–C2',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: const Color(0xFFC8D2E0),
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(height: compact ? 18 : 40),
          // The cast greets in the app's four course languages. FittedBox
          // scales the scene down on narrow panes instead of clipping it.
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: PersonScene(
                PersonSceneKind.greeters,
                height: compact ? 120 : 210,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
