import 'package:flutter/material.dart';

import 'models/noun_settings.dart';
import 'widgets/app_drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    );

    return MaterialApp(
      title: 'Germanquiz',
      debugShowCheckedModeBanner: false,
      theme: baseTheme,
      home: const _InitialPage(),
    );
  }
}

/// Reopens the app on the page the user last visited (see
/// [NounSettings.lastPage]), defaulting to the Pronoun quiz.
class _InitialPage extends StatefulWidget {
  const _InitialPage();

  @override
  State<_InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<_InitialPage> {
  AppPage? _page;

  @override
  void initState() {
    super.initState();
    NounSettings.instance.load().then((_) {
      if (!mounted) return;
      setState(() {
        _page = appPageFromName(NounSettings.instance.lastPage) ?? AppPage.pronouns;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final page = _page;
    if (page == null) {
      return const Scaffold(body: SizedBox.shrink());
    }
    return buildAppPage(page);
  }
}
