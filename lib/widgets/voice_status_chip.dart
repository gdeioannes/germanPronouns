import 'package:flutter/material.dart';

import '../models/course.dart';
import '../models/course_session.dart';
import '../services/tts/tts_provider.dart';
import '../services/tts/tts_service.dart';
import '../theme/app_theme.dart';

/// A small, unobtrusive badge showing which voice is currently reading phrases
/// aloud — a premium cloud voice or the on-device "offline" voice. Tapping it
/// opens a panel where the learner can retry the premium voice or deliberately
/// switch to the offline one, so that low quality reads as a choice or a
/// temporary fallback rather than the app's baseline.
///
/// It only turns "warning"-colored when a premium voice was wanted but the
/// chain fell back to the device; an automatic fallback self-heals, so the chip
/// climbs back up on its own when the premium voice recovers.
class VoiceStatusChip extends StatelessWidget {
  const VoiceStatusChip({super.key});

  @override
  Widget build(BuildContext context) {
    final service = TtsService.instance;
    return AnimatedBuilder(
      animation: service,
      builder: (context, _) {
        final theme = Theme.of(context);
        final status = service.status;
        final strings = _VoiceStrings.of();
        final premium = status.usingPremium;
        final warn = status.degraded;

        final Color fg;
        final Color bg;
        if (warn) {
          fg = theme.colorScheme.onErrorContainer;
          bg = theme.colorScheme.errorContainer;
        } else if (premium) {
          fg = theme.colorScheme.onPrimaryContainer;
          bg = theme.colorScheme.primaryContainer;
        } else {
          fg = theme.colorScheme.onSurfaceVariant;
          bg = theme.colorScheme.surfaceContainerHighest;
        }

        final label = premium
            ? '${strings.hdVoice} · ${_activeName(status)}'
            : strings.offlineVoice;

        return Material(
          color: bg,
          borderRadius: BorderRadius.circular(kRadiusLarge),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _openPanel(context, service),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    warn
                        ? Icons.cloud_off_rounded
                        : premium
                        ? Icons.graphic_eq_rounded
                        : Icons.volume_down_rounded,
                    size: 15,
                    color: fg,
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: fg,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 1),
                  Icon(Icons.expand_more_rounded, size: 14, color: fg),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _activeName(TtsStatus status) {
    for (final p in status.providers) {
      if (p.id == status.activeId) return p.displayName;
    }
    return '';
  }

  void _openPanel(BuildContext context, TtsService service) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => _VoicePanel(service: service),
    );
  }
}

/// The detail sheet behind [VoiceStatusChip]: explains the current voice, lists
/// each provider's state, lets the learner force the offline voice, and offers
/// a "retry premium" action when degraded.
class _VoicePanel extends StatelessWidget {
  const _VoicePanel({required this.service});

  final TtsService service;

  @override
  Widget build(BuildContext context) {
    final strings = _VoiceStrings.of();
    return AnimatedBuilder(
      animation: service,
      builder: (context, _) {
        final theme = Theme.of(context);
        final status = service.status;
        final explainer = status.degraded
            ? strings.degradedExplainer
            : status.usingPremium
            ? strings.premiumExplainer
            : strings.offlineExplainer;

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(strings.panelTitle, style: theme.textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(
                explainer,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              for (final p in status.providers)
                _providerRow(context, status, p, strings),
              const Divider(height: 28),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: status.offlineOnly,
                onChanged: service.setOfflineOnly,
                title: Text(strings.useOffline),
                subtitle: Text(strings.useOfflineSubtitle),
              ),
              if (status.degraded) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.tonalIcon(
                    onPressed: service.retryPremium,
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(strings.retryPremium),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _providerRow(
    BuildContext context,
    TtsStatus status,
    TtsProviderInfo provider,
    _VoiceStrings strings,
  ) {
    final theme = Theme.of(context);
    final active = provider.id == status.activeId;

    final IconData icon;
    final Color color;
    final String stateLabel;
    if (!provider.configured) {
      icon = Icons.remove_circle_outline_rounded;
      color = theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5);
      stateLabel = strings.notConfigured;
    } else if (!provider.healthy) {
      icon = Icons.error_outline_rounded;
      color = theme.colorScheme.error;
      stateLabel = strings.unavailable;
    } else if (active) {
      icon = Icons.check_circle_rounded;
      color = theme.colorScheme.primary;
      stateLabel = strings.active;
    } else {
      icon = Icons.circle_outlined;
      color = theme.colorScheme.onSurfaceVariant;
      stateLabel = strings.ready;
    }

    final name = provider.tier == VoiceTier.premium
        ? '${provider.displayName} · HD'
        : provider.displayName;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(child: Text(name, style: theme.textTheme.bodyMedium)),
          Text(
            stateLabel,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Localized chrome for the voice status UI. Kept self-contained (rather than in
/// the shared AppStrings) so this feature stays a drop-in; the active set is
/// chosen from the course's UI language, mirroring the quiz page.
class _VoiceStrings {
  const _VoiceStrings({
    required this.hdVoice,
    required this.offlineVoice,
    required this.panelTitle,
    required this.premiumExplainer,
    required this.degradedExplainer,
    required this.offlineExplainer,
    required this.useOffline,
    required this.useOfflineSubtitle,
    required this.retryPremium,
    required this.notConfigured,
    required this.unavailable,
    required this.active,
    required this.ready,
  });

  final String hdVoice;
  final String offlineVoice;
  final String panelTitle;
  final String premiumExplainer;
  final String degradedExplainer;
  final String offlineExplainer;
  final String useOffline;
  final String useOfflineSubtitle;
  final String retryPremium;
  final String notConfigured;
  final String unavailable;
  final String active;
  final String ready;

  static _VoiceStrings of() => switch (CourseSession.instance.activeCourse.uiLang) {
    UiLang.es => _es,
    UiLang.en => _en,
    UiLang.de => _de,
  };

  static const _VoiceStrings _de = _VoiceStrings(
    hdVoice: 'HD-Stimme',
    offlineVoice: 'Offline-Stimme',
    panelTitle: 'Sprachqualität',
    premiumExplainer:
        'Die Sätze werden mit einer hochwertigen Online-Stimme vorgelesen.',
    degradedExplainer:
        'Die Premium-Stimme ist gerade nicht verfügbar, daher wird die '
        'Offline-Stimme verwendet. Sie wechselt automatisch zurück, sobald die '
        'Premium-Stimme wieder da ist.',
    offlineExplainer:
        'Die Sätze werden mit der eingebauten Offline-Stimme vorgelesen — '
        'geringere Qualität, funktioniert aber ohne Internet.',
    useOffline: 'Immer die Offline-Stimme verwenden',
    useOfflineSubtitle: 'Geringere Qualität, privat, funktioniert ohne Internet.',
    retryPremium: 'Premium-Stimme erneut versuchen',
    notConfigured: 'Nicht eingerichtet',
    unavailable: 'Nicht verfügbar',
    active: 'In Verwendung',
    ready: 'Bereit',
  );

  static const _VoiceStrings _en = _VoiceStrings(
    hdVoice: 'HD voice',
    offlineVoice: 'Offline voice',
    panelTitle: 'Voice quality',
    premiumExplainer: 'Phrases are read with a high-quality online voice.',
    degradedExplainer:
        'The premium voice is unavailable right now, so the offline voice is '
        'being used. It will switch back automatically when the premium voice '
        'returns.',
    offlineExplainer:
        'Phrases are read with the built-in offline voice — lower quality, but '
        'it works without an internet connection.',
    useOffline: 'Always use the offline voice',
    useOfflineSubtitle: 'Lower quality, private, works without internet.',
    retryPremium: 'Retry premium voice',
    notConfigured: 'Not set up',
    unavailable: 'Unavailable',
    active: 'In use',
    ready: 'Ready',
  );

  static const _VoiceStrings _es = _VoiceStrings(
    hdVoice: 'Voz HD',
    offlineVoice: 'Voz sin conexión',
    panelTitle: 'Calidad de voz',
    premiumExplainer: 'Las frases se leen con una voz online de alta calidad.',
    degradedExplainer:
        'La voz premium no está disponible ahora, así que se usa la voz sin '
        'conexión. Volverá a cambiar automáticamente cuando la voz premium se '
        'restablezca.',
    offlineExplainer:
        'Las frases se leen con la voz integrada sin conexión: menor calidad, '
        'pero funciona sin internet.',
    useOffline: 'Usar siempre la voz sin conexión',
    useOfflineSubtitle: 'Menor calidad, privada, funciona sin internet.',
    retryPremium: 'Reintentar voz premium',
    notConfigured: 'No configurada',
    unavailable: 'No disponible',
    active: 'En uso',
    ready: 'Lista',
  );
}
