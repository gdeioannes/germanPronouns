import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_router.dart';
import 'data/debug_unlock.dart';
import 'models/apartment.dart';
import 'models/app_session.dart';
import 'models/coin_wallet.dart';
import 'models/course_session.dart';
import 'models/noun_settings.dart';
import 'services/analytics.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // The router's redirect reads the session + chosen course, and a deep link
  // can open a quiz on first frame, so load the persisted state before runApp.
  // (Each load() is guarded, so the later in-page calls stay no-ops.)
  await Future.wait([
    AppSession.instance.load(),
    CourseSession.instance.load(),
    NounSettings.instance.load(),
    CoinWallet.instance.load(),
    Apartment.instance.load(),
  ]);
  // Cookieless, privacy-first usage analytics. init() is a no-op when no key is
  // configured; attachRouter records a pageview per navigation. Both must run
  // before runApp so the very first screen is counted. See services/analytics.dart.
  await Analytics.init();
  Analytics.attachRouter(appRouter);
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
  /// to detect the hidden text triggers ("debugdebug" to unlock everything,
  /// "coincoin" for debug coins). Capped at the longest trigger so it never
  /// grows unbounded.
  String _typedBuffer = '';

  static final int _maxTriggerLen = [
    debugUnlockTrigger.length,
    debugCoinTrigger.length,
    debugRevealAllTrigger.length,
  ].reduce((a, b) => a > b ? a : b);

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

  /// Accumulates typed letters and fires the hidden triggers: "debugdebug"
  /// unlocks the whole app, "coincoin" grants debug coins. Always returns false
  /// so it never swallows a key from the focused widget (e.g. a quiz answer
  /// field).
  bool _handleGlobalKey(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    final ch = event.character?.toLowerCase();
    if (ch == null || !RegExp(r'^[a-z]$').hasMatch(ch)) return false;
    _typedBuffer = '$_typedBuffer$ch';
    if (_typedBuffer.length > _maxTriggerLen) {
      _typedBuffer = _typedBuffer.substring(
        _typedBuffer.length - _maxTriggerLen,
      );
    }
    if (_typedBuffer.endsWith(debugUnlockTrigger)) {
      _typedBuffer = '';
      _triggerUnlock();
    } else if (_typedBuffer.endsWith(debugCoinTrigger)) {
      _typedBuffer = '';
      _triggerCoinCheat();
    } else if (_typedBuffer.endsWith(debugRevealAllTrigger)) {
      _typedBuffer = '';
      _triggerRevealAll();
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

  Future<void> _triggerCoinCheat() async {
    await CoinWallet.instance.add(debugCoinAmount);
    _messengerKey.currentState
      ?..clearSnackBars()
      ..showSnackBar(
        const SnackBar(content: Text('+$debugCoinAmount coins (debug).')),
      );
  }

  Future<void> _triggerRevealAll() async {
    await Apartment.instance.revealAll();
    _messengerKey.currentState
      ?..clearSnackBars()
      ..showSnackBar(
        const SnackBar(content: Text('Revealed all shop elements (debug).')),
      );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'languagequiz',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: _messengerKey,
      theme: buildAppTheme(),
      routerConfig: appRouter,
    );
  }
}
