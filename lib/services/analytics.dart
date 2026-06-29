import 'dart:async';

import 'package:aptabase_flutter/aptabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

/// Privacy-first, cookieless usage analytics (Aptabase).
///
/// Why this needs no cookie / consent banner: Aptabase sets no cookies, stores
/// no persistent user identifier (session ids are generated in memory and
/// expire after inactivity — they are never written to disk), and collects no
/// personal data. The server derives only a coarse country from the request IP
/// and then discards it. The only thing kept on-device is a short-lived outbox
/// of not-yet-sent events (IndexedDB on web), which is deleted once delivered.
///
/// The project's own Aptabase (EU) ingestion key is baked in as the default, so
/// analytics works on every platform (web + mobile + desktop) with no per-build
/// flags. App keys are public client-side write keys — they ship inside the web
/// bundle and app binary regardless — so this is not a secret. Aptabase tags
/// debug-build events (`isDebug`) and the dashboard keeps Debug and Release data
/// separate, so local dev runs never pollute production stats.
///
/// Override or disable per build:
///   --dart-define=APTABASE_APP_KEY=A-EU-0000000000   (use a different key)
///   --dart-define=APTABASE_APP_KEY=                   (empty == analytics off)
/// For a self-hosted instance the key's region part is `SH`; also pass:
///   --dart-define=APTABASE_HOST=https://analytics.example.com
/// When the key is empty/garbled, every method here is a no-op: nothing is
/// collected, no plugin is initialised, and no network call is made.
class Analytics {
  const Analytics._();

  static const String _appKey = String.fromEnvironment(
    'APTABASE_APP_KEY',
    defaultValue: 'A-EU-2341128762',
  );
  static const String _host = String.fromEnvironment('APTABASE_HOST');

  /// A key is usable only if it has the `A-REG-0000000000` shape that
  /// [Aptabase.init] asserts on. We pre-check it so a missing/garbled key
  /// leaves analytics cleanly disabled instead of crashing startup in debug.
  static bool get _hasKey => _appKey.split('-').length == 3;

  /// Set once [init] has actually started the SDK; gates every send so we never
  /// touch Aptabase's `late` fields before it was initialised.
  static bool _started = false;

  /// Last route reported, used to drop the duplicate notifications go_router
  /// emits for a single navigation.
  static String? _lastRoute;

  /// Starts the SDK when a key is configured; otherwise a no-op.
  static Future<void> init() async {
    if (!_hasKey) return;
    try {
      await Aptabase.init(
        _appKey,
        _host.isEmpty ? const InitOptions() : InitOptions(host: _host),
      );
      _started = true;
    } catch (e) {
      // Analytics must never be able to break app startup.
      debugPrint('Analytics init failed: $e');
    }
  }

  /// Fire-and-forget custom event. Safe to call whether or not analytics ran.
  static void track(String event, [Map<String, dynamic>? props]) {
    if (!_started) return;
    // Not awaited: trackEvent only queues locally and flushes in the
    // background, so callers never wait on the network.
    unawaited(Aptabase.instance.trackEvent(event, props));
  }

  /// Subscribes to [router] so each navigation records a `screen_view`. No-op
  /// when analytics is disabled, so the listener isn't even attached then.
  static void attachRouter(GoRouter router) {
    if (!_started) return;
    void report() {
      try {
        _reportRoute(router.routerDelegate.currentConfiguration.uri.path);
      } catch (_) {
        // The first route may not be resolved yet; the listener below will
        // pick it up on the initial notification.
      }
    }

    router.routerDelegate.addListener(report);
    report();
  }

  static void _reportRoute(String path) {
    if (path.isEmpty || path == _lastRoute) return;
    _lastRoute = path;
    track('screen_view', {'route': path});
  }
}
