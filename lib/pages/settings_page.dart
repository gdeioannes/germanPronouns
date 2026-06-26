import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:go_router/go_router.dart';

import '../data/data_version.dart';
import '../data/db/content_repository.dart';
import '../data/debug_unlock.dart';
import '../models/course_session.dart';
import '../models/noun_settings.dart';
import '../widgets/app_drawer.dart';
import '../widgets/coin_balance_pill.dart';
import '../widgets/mystery_bottom_bar.dart';

/// App-wide settings, reachable from the drawer on every page.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _progressionUnlockLapsController = TextEditingController();
  final _progressionUnlockLapsFocusNode = FocusNode();
  final _questUnlockLapsController = TextEditingController();
  final _questUnlockLapsFocusNode = FocusNode();

  /// Whether the hidden Debug section is revealed. Triggered by typing the word
  /// "debug" while on this page (with no text field focused).
  bool _showDebug = false;

  /// Rolling buffer of the last few letters typed on the page, used to detect
  /// the "debug" trigger word.
  String _debugBuffer = '';

  /// The content data version installed in the local database (the seed JSON's
  /// `"version"`), loaded asynchronously for the "App Content" panel. Falls back
  /// to the bundled [kDataVersion] if the database can't be read.
  String? _dataVersion;

  /// Accumulates typed letters and reveals the Debug section once "debug" is
  /// spelled out. Always returns [KeyEventResult.ignored] so it never swallows
  /// keys from the rest of the page.
  KeyEventResult _handleDebugKey(FocusNode node, KeyEvent event) {
    if (_showDebug || event is! KeyDownEvent) return KeyEventResult.ignored;
    final ch = event.character?.toLowerCase();
    if (ch == null || !RegExp(r'^[a-z]$').hasMatch(ch)) {
      return KeyEventResult.ignored;
    }
    _debugBuffer = '$_debugBuffer$ch';
    if (_debugBuffer.length > 5) {
      _debugBuffer = _debugBuffer.substring(_debugBuffer.length - 5);
    }
    if (_debugBuffer == 'debug') {
      setState(() => _showDebug = true);
    }
    return KeyEventResult.ignored;
  }


  /// Debug helper: marks every Quest quiz and noun-category as completed and
  /// every listen-&-repeat quiz as played through, so the whole app is unlocked.
  Future<void> _unlockAll() async {
    await unlockEverything();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Unlocked everything in the app.')),
    );
  }

  @override
  void initState() {
    super.initState();
    _progressionUnlockLapsFocusNode.addListener(() {
      if (!_progressionUnlockLapsFocusNode.hasFocus) {
        setState(() {
          _progressionUnlockLapsController.text = NounSettings
              .instance
              .progressionUnlockLaps
              .toString();
        });
      }
    });
    _questUnlockLapsFocusNode.addListener(() {
      if (!_questUnlockLapsFocusNode.hasFocus) {
        setState(() {
          _questUnlockLapsController.text =
              NounSettings.instance.questUnlockLaps.toString();
        });
      }
    });
    NounSettings.instance.load().then((_) {
      if (!mounted) return;
      _progressionUnlockLapsController.text = NounSettings
          .instance
          .progressionUnlockLaps
          .toString();
      _questUnlockLapsController.text =
          NounSettings.instance.questUnlockLaps.toString();
      setState(() {});
    });
    _loadDataVersion();
  }

  /// Reads the installed content data version from the local database, falling
  /// back to the bundled [kDataVersion] if the database is unavailable.
  Future<void> _loadDataVersion() async {
    String version;
    try {
      version = (await (await contentRepository()).seededDataVersion()) ??
          kDataVersion;
    } catch (_) {
      version = kDataVersion;
    }
    if (!mounted) return;
    setState(() => _dataVersion = version);
  }

  @override
  void dispose() {
    _progressionUnlockLapsController.dispose();
    _progressionUnlockLapsFocusNode.dispose();
    _questUnlockLapsController.dispose();
    _questUnlockLapsFocusNode.dispose();
    super.dispose();
  }

  /// Renders a tappable swatch showing the current highlight color for
  /// [gender] ('m'/'f'/'n') with [label], opening a color picker on tap.
  Widget _buildGenderColorSwatch(String gender, String label) {
    final color = NounSettings.instance.colorForGender(gender);
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _pickGenderColor(gender, label),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(label),
          ],
        ),
      ),
    );
  }

  /// Opens a color picker dialog for [gender] ('m'/'f'/'n', labeled
  /// [label]) and persists the chosen color via [NounSettings].
  Future<void> _pickGenderColor(String gender, String label) async {
    var picked = NounSettings.instance.colorForGender(gender);
    final result = await showDialog<Color>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Color for $label'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: picked,
              onColorChanged: (c) => picked = c,
              enableAlpha: false,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, picked),
              child: const Text('Select'),
            ),
          ],
        );
      },
    );
    if (result != null) {
      setState(() {
        NounSettings.instance.setGenderColor(gender, result);
      });
    }
  }

  /// Wraps a settings section's content in its own card panel.
  Widget _settingsPanel({required String title, required List<Widget> children}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            ...children,
          ],
        ),
      ),
    );
  }

  /// Shows a confirmation dialog, then (if confirmed) wipes all stored
  /// progress and settings and returns to the Pronoun quiz with a fresh
  /// navigation stack.
  Future<void> _confirmResetAll() async {
    final firstConfirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset everything?'),
        content: const Text(
          'This clears all quiz scores, streaks, and history, noun '
          'category progress, the word library, article colors, and the '
          'answer reveal setting. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Reset Everything'),
          ),
        ],
      ),
    );
    if (firstConfirmed != true) return;
    if (!mounted) return;

    const confirmPhrase = 'delete all';
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          final matches =
              controller.text.trim().toLowerCase() == confirmPhrase;
          return AlertDialog(
            title: const Text('Are you sure?'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Type "$confirmPhrase" to confirm.'),
                const SizedBox(height: 8),
                TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: confirmPhrase,
                  ),
                  onChanged: (_) => setDialogState(() {}),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: matches
                    ? () => Navigator.of(dialogContext).pop(true)
                    : null,
                child: const Text('Reset Everything'),
              ),
            ],
          );
        },
      ),
    );
    controller.dispose();
    if (confirmed != true) return;
    if (!mounted) return;

    await NounSettings.instance.resetAll();
    if (!mounted) return;
    // After wiping progress, drop back to the course overview (a fresh start).
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CourseSession.instance.strings.settings),
        actions: const [CoinBalancePill()],
      ),
      drawer: const AppDrawer(currentPage: AppPage.settings),
      bottomNavigationBar: const MysteryBottomBar(),
      body: SafeArea(
        child: Focus(
          autofocus: true,
          onKeyEvent: _handleDebugKey,
          child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _settingsPanel(
              title: 'Article Colors',
              children: [
                Text(
                  'Pick the highlight color used for masculine, feminine, '
                  'and neuter nouns wherever "Color nouns by article" is '
                  'turned on.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    _buildGenderColorSwatch('m', 'der (masculine)'),
                    _buildGenderColorSwatch('f', 'die (feminine)'),
                    _buildGenderColorSwatch('n', 'das (neuter)'),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        NounSettings.instance.resetGenderColors();
                      });
                    },
                    child: const Text('Reset to default colors'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _settingsPanel(
              title: 'Answer Reveal',
              children: [
                Text(
                  'When you answer incorrectly, the correct answer is '
                  'typed out in the answer field (marked with a red *) '
                  'before moving on to the next question. Choose how long '
                  'it stays on screen.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                RadioGroup<AnswerRevealMode>(
                  groupValue: NounSettings.instance.answerRevealMode,
                  onChanged: (mode) {
                    setState(() {
                      NounSettings.instance.setAnswerRevealMode(mode!);
                    });
                  },
                  child: Column(
                    children: [
                      RadioListTile<AnswerRevealMode>(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Quick'),
                        subtitle: const Text(
                          'Brief pause before moving to the next question.',
                        ),
                        value: AnswerRevealMode.quick,
                      ),
                      RadioListTile<AnswerRevealMode>(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Normal'),
                        subtitle: const Text(
                          'Moderate pause before moving to the next '
                          'question.',
                        ),
                        value: AnswerRevealMode.normal,
                      ),
                      RadioListTile<AnswerRevealMode>(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Slow'),
                        subtitle: const Text(
                          'Extended pause — good for slower readers.',
                        ),
                        value: AnswerRevealMode.slow,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _settingsPanel(
              title: 'First Letter Hint',
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Show first letter on wrong answer'),
                  subtitle: const Text(
                    'When you answer incorrectly for the first time, show the '
                    'first letter of the correct answer (marked with a red *). '
                    'You still lose your streak. If you answer the same '
                    'question incorrectly again, the full answer is shown.',
                  ),
                  value: NounSettings.instance.showFirstLetterHint,
                  onChanged: (value) {
                    setState(() {
                      NounSettings.instance.setShowFirstLetterHint(value);
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            _settingsPanel(
              title: CourseSession.instance.strings.relaxedCorrectionTitle,
              children: [
                Text(
                  CourseSession.instance.strings.relaxedCorrectionLong,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    CourseSession.instance.strings.relaxedCorrectionTitle,
                  ),
                  value: NounSettings.instance.relaxedCorrection,
                  onChanged: (value) {
                    setState(() {
                      NounSettings.instance.setRelaxedCorrection(value);
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            _settingsPanel(
              title: 'Noun Category Progression',
              children: [
                Text(
                  'How many 5-answer streaks in a row are needed in a noun '
                  'category sub-quiz to unlock the next category. Default: '
                  '${NounSettings.defaultProgressionUnlockLaps}.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _progressionUnlockLapsController,
                    focusNode: _progressionUnlockLapsFocusNode,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Streaks',
                      isDense: true,
                    ),
                    onChanged: (value) {
                      final parsed = int.tryParse(value);
                      if (parsed == null) return;
                      setState(() {
                        NounSettings.instance.setProgressionUnlockLaps(
                          parsed,
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _settingsPanel(
              title: 'Quest Progression (A1–A2)',
              children: [
                Text(
                  'How many 5-answer streaks in a row are needed in a Quest '
                  'quiz to unlock the next quiz in the A-level chain. Separate '
                  'from the noun-category goal. Default: '
                  '${NounSettings.defaultQuestUnlockLaps}.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _questUnlockLapsController,
                    focusNode: _questUnlockLapsFocusNode,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Streaks',
                      isDense: true,
                    ),
                    onChanged: (value) {
                      final parsed = int.tryParse(value);
                      if (parsed == null) return;
                      setState(() {
                        NounSettings.instance.setQuestUnlockLaps(parsed);
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _settingsPanel(
              title: 'Keyboard Shortcuts',
              children: [
                Text(
                  'Ctrl+I — open the Sentence Info panel for the current '
                  'question.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _settingsPanel(
              title: 'App Content',
              children: [
                Text(
                  'The version of the quiz content currently installed on this '
                  'device. The app refreshes its content automatically when a '
                  'newer version is published.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.dataset_rounded,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Content version: ${_dataVersion ?? '…'}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            _settingsPanel(
              title: 'Reset',
              children: [
                Text(
                  'Wipe all quiz progress, noun category unlocks, the word '
                  'library, and other settings, restoring the app to its '
                  'original state.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                    ),
                    onPressed: _confirmResetAll,
                    child: const Text('Reset Everything'),
                  ),
                ),
              ],
            ),
            if (_showDebug) ...[
              const SizedBox(height: 16),
              _settingsPanel(
                title: 'Debug',
                children: [
                  Text(
                    'Developer tools. Unlock every Quest quiz, noun category '
                    'and listen-&-repeat quiz so you can open anything in the '
                    'app.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FilledButton.icon(
                      onPressed: _unlockAll,
                      icon: const Icon(Icons.lock_open_rounded),
                      label: const Text('Unlock everything'),
                    ),
                  ),
                ],
              ),
            ],
          ],
          ),
        ),
      ),
    );
  }
}
