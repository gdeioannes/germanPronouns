import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../models/noun_settings.dart';
import '../widgets/app_drawer.dart';

/// App-wide settings, reachable from the drawer on every page.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    NounSettings.instance.load().then((_) {
      if (mounted) setState(() {});
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      drawer: const AppDrawer(currentPage: AppPage.settings),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Article Colors',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Pick the highlight color used for masculine, feminine, and '
              'neuter nouns wherever "Color nouns by article" is turned on.',
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
            const SizedBox(height: 24),
            Text(
              'Keyboard Shortcuts',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Ctrl+I — open the Sentence Info panel for the current '
              'question.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
