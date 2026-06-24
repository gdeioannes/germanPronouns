import 'package:flutter/material.dart';

import '../../data/content/asset_course_provider.dart';
import '../../data/content/content_editor.dart';
import '../../models/content/catalog.dart';
import '../../models/content/populated_course.dart';
import '../../models/content/quiz.dart';
import 'course_quiz_sentences_page.dart';

/// Teacher editor over the JSON content **collections**: pick a course, see its
/// quizzes (served from the per-course bundle), edit one, and the change is
/// persisted locally (overriding the shipped bundle) and shown to learners.
///
/// This is the collections-native back office — it writes through
/// [ContentEditor], the same seam a future remote database will implement. It
/// edits a quiz's title here; richer per-type forms (sentences, questions, help)
/// extend the same save path.
class CourseContentEditorPage extends StatefulWidget {
  const CourseContentEditorPage({super.key});

  @override
  State<CourseContentEditorPage> createState() =>
      _CourseContentEditorPageState();
}

class _CourseContentEditorPageState extends State<CourseContentEditorPage> {
  final ContentEditor _editor = ContentEditor(
    provider: courseContentProvider,
    store: const RepositoryBundleStore(),
  );

  final Future<Catalog> _catalogFuture = courseContentProvider.catalog();
  String? _courseId;
  Future<PopulatedCourse>? _courseFuture;

  void _selectCourse(String id) {
    setState(() {
      _courseId = id;
      _courseFuture = _editor.course(id);
    });
  }

  void _reload() {
    final id = _courseId;
    if (id != null) setState(() => _courseFuture = _editor.course(id));
  }

  Future<void> _editQuizTitle(Quiz quiz) async {
    final controller = TextEditingController(text: quiz.title);
    final newTitle = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit quiz title'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (newTitle == null || newTitle.isEmpty || newTitle == quiz.title) return;
    final edited = Quiz.fromJson(quiz.toJson()..['title'] = newTitle);
    await _editor.saveQuiz(_courseId!, edited);
    _reload();
  }

  Future<void> _resetCourse() async {
    final id = _courseId;
    if (id == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset course to published?'),
        content: const Text('Discards local edits for this course.'),
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
    await _editor.resetCourse(id);
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Content'),
        actions: [
          if (_courseId != null)
            IconButton(
              tooltip: 'Reset course to published',
              icon: const Icon(Icons.restart_alt_rounded),
              onPressed: _resetCourse,
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: FutureBuilder<Catalog>(
              future: _catalogFuture,
              builder: (context, snapshot) {
                final courses = snapshot.data?.courses ?? const <CourseCard>[];
                return DropdownButtonFormField<String>(
                  initialValue: _courseId,
                  decoration: const InputDecoration(
                    labelText: 'Course',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (final c in courses)
                      DropdownMenuItem(value: c.id, child: Text(c.name)),
                  ],
                  onChanged: (id) {
                    if (id != null) _selectCourse(id);
                  },
                );
              },
            ),
          ),
          Expanded(child: _quizList()),
        ],
      ),
    );
  }

  Widget _quizList() {
    final future = _courseFuture;
    if (future == null) {
      return const Center(child: Text('Pick a course to edit its quizzes.'));
    }
    return FutureBuilder<PopulatedCourse>(
      future: future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final quizzes = snapshot.data!.quizzes;
        return ListView.separated(
          itemCount: quizzes.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final quiz = quizzes[index];
            return ListTile(
              title: Text(quiz.title),
              subtitle: Text('${quiz.type} · ${quiz.storageKeyPrefix}'),
              trailing: quiz is FillBlankQuiz
                  ? IconButton(
                      tooltip: 'Edit sentences',
                      icon: const Icon(Icons.notes_rounded),
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => CourseQuizSentencesPage(
                              editor: _editor,
                              courseId: _courseId!,
                              quizId: quiz.id,
                              title: quiz.title,
                            ),
                          ),
                        );
                        _reload();
                      },
                    )
                  : const Icon(Icons.edit_rounded),
              onTap: () => _editQuizTitle(quiz),
            );
          },
        );
      },
    );
  }
}
