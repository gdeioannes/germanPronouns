import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/settings_keys.dart';
import 'cloud_tts_provider.dart';
import 'device_tts_provider.dart';
import 'tts_provider.dart';

/// An immutable snapshot of which voice is currently in use and why, for the
/// voice status chip + panel.
class TtsStatus {
  const TtsStatus({
    required this.activeId,
    required this.activeTier,
    required this.degraded,
    required this.offlineOnly,
    required this.providers,
  });

  /// The provider that last produced (or is set to produce) audio —
  /// 'azure' / 'google' / 'device' — or null before anything has played.
  final String? activeId;
  final VoiceTier activeTier;

  /// True when a premium voice is configured and wanted but the chain fell back
  /// to the on-device voice. This is the state the chip highlights so that low
  /// quality reads as a temporary fallback, not the app's baseline.
  final bool degraded;

  /// True when the learner has deliberately forced the on-device voice.
  final bool offlineOnly;

  /// Per-provider snapshots for the panel, ordered best → worst.
  final List<TtsProviderInfo> providers;

  bool get usingPremium => activeTier == VoiceTier.premium;
}

/// Reads phrases aloud through an ordered chain of [TtsProvider]s — premium
/// cloud voices first, the on-device engine as the floor — and exposes which
/// one is live so the UI can show it (see the voice status chip).
///
/// Selection is "probe once, then stick, then self-heal": each [speak] uses the
/// best currently-healthy provider and only drops to the next on an actual
/// failure, so the voice doesn't flip mid-session on a single network blip. A
/// failed premium provider is skipped until [_retryCooldown] elapses (the
/// self-heal), or immediately again via [retryPremium].
class TtsService extends ChangeNotifier {
  TtsService._() {
    _device = DeviceTtsProvider(onSpeakingChanged: _setSpeaking);
    // On web a baked-in key would be exposed (and Azure CORS-blocks browsers),
    // so route premium through the server-side proxy that holds the keys. On
    // desktop/mobile (compiled binaries) we call the clouds directly.
    _providers = kIsWeb
        ? [ProxyTtsProvider(onSpeakingChanged: _setSpeaking), _device]
        : [
            AzureTtsProvider(onSpeakingChanged: _setSpeaking),
            GoogleTtsProvider(onSpeakingChanged: _setSpeaking),
            _device,
          ];
    _loadPreference();
  }

  static final TtsService instance = TtsService._();

  static const String _offlineOnlyKey = SettingsKeys.voiceOfflineOnly;

  /// How long a failed premium provider is skipped before the chain tries it
  /// again — the "self-heal" interval.
  static const Duration _retryCooldown = Duration(minutes: 2);

  late final DeviceTtsProvider _device;
  late final List<TtsProvider> _providers;

  /// Provider id → time of its most recent failure. Absent means healthy.
  final Map<String, DateTime> _failedAt = {};

  bool _offlineOnly = false;
  String? _activeId;

  /// True while a phrase is being read aloud, mirrored from the active
  /// provider's start/stop events. Listen to drive a "speaking" indicator.
  final ValueNotifier<bool> speaking = ValueNotifier<bool>(false);

  bool get offlineOnly => _offlineOnly;

  TtsStatus get status => TtsStatus(
    activeId: _activeId,
    activeTier: _tierOf(_activeId),
    degraded: _isDegraded,
    offlineOnly: _offlineOnly,
    providers: [
      for (final p in _providers)
        TtsProviderInfo(
          id: p.id,
          displayName: p.displayName,
          tier: p.tier,
          configured: p.isConfigured,
          healthy: _isHealthy(p),
        ),
    ],
  );

  bool get _hasConfiguredPremium =>
      _providers.any((p) => p.tier == VoiceTier.premium && p.isConfigured);

  bool get _isDegraded =>
      !_offlineOnly &&
      _hasConfiguredPremium &&
      _activeId != null &&
      _tierOf(_activeId) == VoiceTier.device;

  VoiceTier _tierOf(String? id) =>
      _providers.firstWhere((p) => p.id == id, orElse: () => _device).tier;

  bool _isHealthy(TtsProvider p) {
    final failedAt = _failedAt[p.id];
    if (failedAt == null) return true;
    return DateTime.now().difference(failedAt) >= _retryCooldown;
  }

  /// The providers to try, best → worst, honoring the offline-only preference.
  Iterable<TtsProvider> get _chain =>
      _offlineOnly ? [_device] : _providers;

  void _setSpeaking(bool value) => speaking.value = value;

  Future<void> _loadPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getBool(_offlineOnlyKey) ?? false;
      if (saved != _offlineOnly) {
        _offlineOnly = saved;
        notifyListeners();
      }
    } catch (_) {
      // Default (automatic, premium-first) stands if prefs are unavailable.
    }
  }

  /// Forces the on-device voice (true) or restores automatic premium-first
  /// selection (false). Persists across sessions.
  Future<void> setOfflineOnly(bool value) async {
    if (_offlineOnly == value) return;
    _offlineOnly = value;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_offlineOnlyKey, value);
    } catch (_) {
      // Non-fatal; the in-memory value still applies for this session.
    }
  }

  /// Clears failure state so the chain re-tries the premium voices on the next
  /// phrase. Called from the panel's "retry premium" action.
  void retryPremium() {
    if (_failedAt.isEmpty) return;
    _failedAt.clear();
    notifyListeners();
  }

  /// Prepares the best currently-usable provider for [locale], so the first
  /// phrase isn't delayed or read in the wrong language.
  Future<void> warmUp(String locale) async {
    final provider = _firstUsable();
    try {
      await provider.warmUp(locale);
    } catch (_) {
      // Warm-up is best effort.
    }
    _markActive(provider.id);
  }

  TtsProvider _firstUsable() {
    for (final p in _chain) {
      if (p.isConfigured && _isHealthy(p)) return p;
    }
    return _device;
  }

  /// Reads [text] in [locale], walking the chain until a provider succeeds.
  /// Updates [status] / [speaking] and notifies listeners when the active
  /// provider changes.
  Future<void> speak(String text, String locale) async {
    if (text.trim().isEmpty) return;
    for (final provider in _chain) {
      if (!provider.isConfigured || !_isHealthy(provider)) continue;
      try {
        final ok = await provider.speak(text, locale);
        if (ok) {
          _failedAt.remove(provider.id);
          _markActive(provider.id);
          return;
        }
        _failedAt[provider.id] = DateTime.now();
      } catch (_) {
        _failedAt[provider.id] = DateTime.now();
      }
    }
    // Nothing spoke (e.g. only the device floor, which can silently no-op on a
    // platform with no audio output). Reflect the floor as the active source.
    _markActive(_device.id);
  }

  void _markActive(String id) {
    if (_activeId == id) return;
    _activeId = id;
    notifyListeners();
  }

  /// Stops any in-progress playback across every provider.
  Future<void> stop() async {
    for (final p in _providers) {
      await p.stop();
    }
    speaking.value = false;
  }
}
