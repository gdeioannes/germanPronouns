import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/db/content_repository.dart';
import '../../theme/app_theme.dart';
import '../auth_gate.dart';
import '../learner_home_page.dart';
import 'navigation_editor_page.dart';
import 'quiz_sentences_page.dart';

/// Teacher back office: lists every quiz and lets the teacher drill in to edit
/// its sentences. Reads/writes the local content database.
class BackOfficeHomePage extends StatefulWidget {
  const BackOfficeHomePage({super.key});

  @override
  State<BackOfficeHomePage> createState() => _BackOfficeHomePageState();
}

class _BackOfficeHomePageState extends State<BackOfficeHomePage> {
  late final Future<ContentRepository> _repoFuture = contentRepository();
  int _reloadTick = 0;

  Future<void> _resetToPublished(ContentRepository repo) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset to published content?'),
        content: const Text(
          'This discards all local edits and reloads the content shipped with '
          'the app. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final published = await loadPublishedContent();
    await repo.reseed(published.quizzes, courses: published.courses);
    if (mounted) setState(() => _reloadTick++);
  }

  Future<void> _exportJson(ContentRepository repo) async {
    final json = await repo.exportJson();
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export content'),
        content: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Copy this and save it to assets/seed/quiz_content.json, then '
                'commit it to publish your edits in the next build.',
              ),
              const SizedBox(height: 12),
              Flexible(
                child: SingleChildScrollView(
                  child: SelectableText(
                    json,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          FilledButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: json));
              if (context.mounted) Navigator.pop(context);
            },
            icon: const Icon(Icons.copy_rounded),
            label: const Text('Copy'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Back Office'),
        actions: [
          FutureBuilder<ContentRepository>(
            future: _repoFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Edit navigation / menu',
                    icon: const Icon(Icons.account_tree_rounded),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            NavigationEditorPage(repository: snapshot.data!),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Reset to published content',
                    icon: const Icon(Icons.restart_alt_rounded),
                    onPressed: () => _resetToPublished(snapshot.data!),
                  ),
                ],
              );
            },
          ),
          IconButton(
            tooltip: 'Open learner view',
            icon: const Icon(Icons.visibility_rounded),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const LearnerHomePage(),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => signOutToLogin(context),
          ),
        ],
      ),
      body: FutureBuilder<ContentRepository>(
        future: _repoFuture,
        builder: (context, repoSnapshot) {
          if (repoSnapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (repoSnapshot.hasError) {
            return Center(child: Text('Failed to open database:\n${repoSnapshot.error}'));
          }
          final repo = repoSnapshot.data!;

          return Column(
            children: [
              Container(
                width: double.infinity,
                color: colorScheme.surfaceContainerHigh,
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Edits are saved to this device only. Use Export to publish '
                  'them to everyone.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<QuizSummary>>(
                  key: ValueKey(_reloadTick),
                  future: repo.listQuizzes(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final quizzes = snapshot.data!;
                    return ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: quizzes.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 4),
                      itemBuilder: (context, index) {
                        final quiz = quizzes[index];
                        return Card(
                          margin: EdgeInsets.zero,
                          child: ListTile(
                            leading: IconBadge(
                              icon: Icons.menu_book_rounded,
                              color: kSectionAccentColors[
                                  index % kSectionAccentColors.length],
                            ),
                            title: Text(quiz.title),
                            subtitle: Text('${quiz.sentenceCount} sentences'),
                            trailing: const Icon(Icons.chevron_right_rounded),
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => QuizSentencesPage(
                                    repository: repo,
                                    quizId: quiz.id,
                                    title: quiz.title,
                                  ),
                                ),
                              );
                              if (mounted) setState(() => _reloadTick++);
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FutureBuilder<ContentRepository>(
        future: _repoFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();
          return FloatingActionButton.extended(
            onPressed: () => _exportJson(snapshot.data!),
            icon: const Icon(Icons.download_rounded),
            label: const Text('Export'),
          );
        },
      ),
    );
  }
}
