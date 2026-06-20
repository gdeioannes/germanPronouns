import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data/debug_unlock.dart';
import 'pages/auth_gate.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// Lets the global debug handler surface a confirmation SnackBar regardless
  /// of which page is on screen.
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();

  /// Rolling buffer of the most recent letters typed anywhere in the app, used
  /// to detect the "debug" + "debug" unlock trigger. Capped at the trigger
  /// length so it never grows unbounded.
  String _typedBuffer = '';

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleGlobalKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleGlobalKey);
    super.dispose();
  }

  /// Accumulates typed letters and unlocks the whole app once "debug" has been
  /// spelled out twice in a row. Always returns false so it never swallows a
  /// key from the focused widget (e.g. a quiz answer field).
  bool _handleGlobalKey(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    final ch = event.character?.toLowerCase();
    if (ch == null || !RegExp(r'^[a-z]$').hasMatch(ch)) return false;
    _typedBuffer = '$_typedBuffer$ch';
    if (_typedBuffer.length > debugUnlockTrigger.length) {
      _typedBuffer = _typedBuffer.substring(
        _typedBuffer.length - debugUnlockTrigger.length,
      );
    }
    if (_typedBuffer == debugUnlockTrigger) {
      _typedBuffer = '';
      _triggerUnlock();
    }
    return false;
  }

  Future<void> _triggerUnlock() async {
    await unlockEverything();
    _messengerKey.currentState
      ?..clearSnackBars()
      ..showSnackBar(
        const SnackBar(content: Text('Unlocked everything in the app.')),
      );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Germanquiz',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: _messengerKey,
      theme: buildAppTheme(),
      home: const AuthGate(),
    );
  }
}
