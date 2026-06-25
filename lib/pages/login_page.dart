import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/app_session.dart';

/// Sign-in screen. Learners enter directly; teachers unlock the back office
/// with the local passcode.
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SvgPicture.asset(
                  'assets/icons/QuizLogo-02.svg',
                  width: 72,
                  height: 72,
                ),
                const SizedBox(height: 16),
                Text(
                  'Language Courses & Quizzes',
                  textAlign: TextAlign.center,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '❤️ Tailor-Made for You',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                if (!_teacherMode) ...[
                  FilledButton.icon(
                    onPressed: AppSession.instance.signInAsLearner,
                    icon: const Icon(Icons.school_rounded),
                    label: const Text('Continue as learner'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => setState(() => _teacherMode = true),
                    icon: const Icon(Icons.workspace_premium_rounded),
                    label: const Text('Teacher sign in'),
                  ),
                ] else ...[
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
    );
  }
}
