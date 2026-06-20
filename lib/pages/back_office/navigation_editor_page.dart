import 'package:flutter/material.dart';

import '../../data/course_catalog.dart';
import '../../data/db/content_repository.dart';
import '../../data/nav_layout_data.dart';
import '../../data/quest_data.dart';
import '../../data/section_catalog.dart';
import '../../models/course.dart';
import '../../models/nav_layout.dart';
import '../../theme/app_theme.dart';

/// Back-office editor for the learner drawer's organization: reorder/rename/add/
/// delete section groups and add/remove/reorder/move quizzes between them.
/// Saves the [NavLayout] to the local database (publish via the Export button on
/// the back-office home, same as content).
class NavigationEditorPage extends StatefulWidget {
  const NavigationEditorPage({super.key, required this.repository});

  final ContentRepository repository;

  @override
  State<NavigationEditorPage> createState() => _NavigationEditorPageState();
}

class _NavigationEditorPageState extends State<NavigationEditorPage> {
  List<NavGroup>? _groups;
  Map<String, QuizSummary> _quizzes = const {};
  List<Course> _courses = const [];
  String _courseId = kDefaultCourseId;
  bool _dirty = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Course get _currentCourse =>
      _courses.firstWhere((c) => c.id == _courseId, orElse: () => _courses.first);

  List<NavGroup> _groupsForCourse(Course course) => [
    for (final g in course.nav.groups)
      g.type == NavGroupType.questChain
          ? g.copyWith(items: _mergedQuestItems(g.items))
          : g,
  ];

  Future<void> _load() async {
    final courses = await widget.repository.courses();
    final quizzes = {for (final q in await widget.repository.listQuizzes()) q.id: q};
    if (!mounted) return;
    setState(() {
      _courses = courses;
      _courseId = courses.isNotEmpty ? courses.first.id : kDefaultCourseId;
      _groups = _groupsForCourse(_currentCourse);
      _quizzes = quizzes;
    });
  }

  void _switchCourse(String id) {
    setState(() {
      _courseId = id;
      _groups = _groupsForCourse(_currentCourse);
      _dirty = false;
    });
  }

  /// The Quest chain items to edit: the saved order first (dropping any that no
  /// longer exist), then any quest quizzes not yet listed (e.g. newly added),
  /// so every quiz is shown and reorderable.
  List<NavItem> _mergedQuestItems(List<NavItem> saved) {
    final savedRefs = saved.map((e) => e.ref).toSet();
    return [
      for (final item in saved)
        if (questEntryByKey(item.ref) != null) item,
      for (final entry in questEntries)
        if (!savedRefs.contains(entry.key)) NavItem(ref: entry.key),
    ];
  }

  String _quizTitle(String contentId) =>
      _quizzes[contentId]?.title ??
      sectionForContentId(contentId)?.title ??
      contentId;

  String _linkTitle(String ref) => switch (ref) {
    kWordLibraryRef => 'Word Library',
    kSettingsRef => 'Settings',
    _ => ref,
  };

  String _itemTitle(NavItem item, NavGroupType type) {
    if (item.titleOverride != null) return item.titleOverride!;
    return type == NavGroupType.links
        ? _linkTitle(item.ref)
        : _quizTitle(item.ref);
  }

  void _edit(void Function() change) => setState(() {
    change();
    _dirty = true;
  });

  void _moveGroup(int i, int delta) {
    final j = i + delta;
    final groups = _groups!;
    if (j < 0 || j >= groups.length) return;
    _edit(() => groups.insert(j, groups.removeAt(i)));
  }

  void _moveItem(int g, int i, int delta) {
    final items = [..._groups![g].items];
    final j = i + delta;
    if (j < 0 || j >= items.length) return;
    items.insert(j, items.removeAt(i));
    _edit(() => _groups![g] = _groups![g].copyWith(items: items));
  }

  void _setItem(int g, int i, NavItem item) {
    final items = [..._groups![g].items];
    items[i] = item;
    _edit(() => _groups![g] = _groups![g].copyWith(items: items));
  }

  void _removeItem(int g, int i) {
    final items = [..._groups![g].items]..removeAt(i);
    _edit(() => _groups![g] = _groups![g].copyWith(items: items));
  }

  Future<void> _deleteGroup(int g) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete "${_groups![g].title}"?'),
        content: const Text('The group and its items are removed from the menu.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) _edit(() => _groups!.removeAt(g));
  }

  Future<void> _addGroup() async {
    var title = 'New Section';
    var type = NavGroupType.quizzes;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setLocal) => AlertDialog(
          title: const Text('Add group'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: title,
                decoration: const InputDecoration(labelText: 'Heading'),
                onChanged: (v) => title = v,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<NavGroupType>(
                initialValue: type,
                decoration: const InputDecoration(labelText: 'Type'),
                items: const [
                  DropdownMenuItem(
                    value: NavGroupType.quizzes,
                    child: Text('Quizzes'),
                  ),
                  DropdownMenuItem(
                    value: NavGroupType.links,
                    child: Text('Links'),
                  ),
                ],
                onChanged: (v) => setLocal(() => type = v ?? type),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
    if (ok != true) return;
    _edit(
      () => _groups!.add(
        NavGroup(
          id: 'g${DateTime.now().millisecondsSinceEpoch}',
          title: title.trim().isEmpty ? 'Section' : title.trim(),
          type: type,
        ),
      ),
    );
  }

  Future<void> _addQuiz(int g) async {
    final present = _groups![g].items.map((e) => e.ref).toSet();
    final available = _quizzes.values.where((q) => !present.contains(q.id)).toList()
      ..sort((a, b) => a.title.compareTo(b.title));
    if (available.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All quizzes are already in this group.')),
      );
      return;
    }
    final picked = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Add quiz'),
        children: [
          for (final q in available)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, q.id),
              child: Text(q.title),
            ),
        ],
      ),
    );
    if (picked == null) return;
    _edit(
      () => _groups![g] = _groups![g].copyWith(
        items: [..._groups![g].items, NavItem(ref: picked)],
      ),
    );
  }

  /// Opens the per-item editor (title override, icon, color, move to group).
  Future<void> _editItem(int g, int i) async {
    final original = _groups![g].items[i];
    var titleOverride = original.titleOverride;
    var iconKey = original.iconKey;
    var colorIndex = original.colorIndex;
    var targetGroup = g;
    final quizGroupChoices = [
      for (var k = 0; k < _groups!.length; k++)
        if (_groups![k].type == _groups![g].type) k,
    ];

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setLocal) => AlertDialog(
          title: Text(_itemTitle(original, _groups![g].type)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: titleOverride ?? '',
                  decoration: const InputDecoration(
                    labelText: 'Title (blank = default)',
                  ),
                  onChanged: (v) =>
                      titleOverride = v.trim().isEmpty ? null : v.trim(),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  initialValue: iconKey,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Icon'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Default')),
                    for (final entry in navIconChoices.entries)
                      DropdownMenuItem(
                        value: entry.key,
                        child: Row(
                          children: [
                            Icon(entry.value, size: 18),
                            const SizedBox(width: 8),
                            Text(entry.key),
                          ],
                        ),
                      ),
                  ],
                  onChanged: (v) => setLocal(() => iconKey = v),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int?>(
                  initialValue: colorIndex,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Color'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Default')),
                    for (var c = 0; c < kSectionAccentColors.length; c++)
                      DropdownMenuItem(
                        value: c,
                        child: Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: kSectionAccentColors[c],
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('Color ${c + 1}'),
                          ],
                        ),
                      ),
                  ],
                  onChanged: (v) => setLocal(() => colorIndex = v),
                ),
                if (quizGroupChoices.length > 1) ...[
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    initialValue: targetGroup,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'In group'),
                    items: [
                      for (final k in quizGroupChoices)
                        DropdownMenuItem(value: k, child: Text(_groups![k].title)),
                    ],
                    onChanged: (v) => setLocal(() => targetGroup = v ?? g),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
    if (ok != true) return;
    final updated = NavItem(
      ref: original.ref,
      titleOverride: titleOverride,
      iconKey: iconKey,
      colorIndex: colorIndex,
      hidden: original.hidden,
    );
    if (targetGroup == g) {
      _setItem(g, i, updated);
    } else {
      _edit(() {
        _groups![g] = _groups![g].copyWith(
          items: [..._groups![g].items]..removeAt(i),
        );
        _groups![targetGroup] = _groups![targetGroup].copyWith(
          items: [..._groups![targetGroup].items, updated],
        );
      });
    }
  }

  Future<void> _save() async {
    await widget.repository.saveNavLayout(_courseId, NavLayout(groups: _groups!));
    if (!mounted) return;
    setState(() => _dirty = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigation saved. Use Export to publish.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groups = _groups;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation'),
        actions: [
          TextButton.icon(
            onPressed: (groups != null && _dirty) ? _save : null,
            icon: const Icon(Icons.save_rounded),
            label: const Text('Save'),
          ),
        ],
      ),
      floatingActionButton: groups == null
          ? null
          : FloatingActionButton.extended(
              onPressed: _addGroup,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add group'),
            ),
      body: groups == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(12),
              children: [
                if (_courses.length > 1)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: DropdownButtonFormField<String>(
                      initialValue: _courseId,
                      decoration: const InputDecoration(
                        labelText: 'Course / menu',
                        isDense: true,
                      ),
                      items: [
                        for (final c in _courses)
                          DropdownMenuItem(value: c.id, child: Text(c.name)),
                      ],
                      onChanged: (id) {
                        if (id != null && id != _courseId) _switchCourse(id);
                      },
                    ),
                  ),
                for (var g = 0; g < groups.length; g++)
                  _groupCard(context, g, groups[g]),
              ],
            ),
    );
  }

  Widget _groupCard(BuildContext context, int g, NavGroup group) {
    final colorScheme = Theme.of(context).colorScheme;
    final editable =
        group.type == NavGroupType.quizzes || group.type == NavGroupType.links;
    final isQuest = group.type == NavGroupType.questChain;
    final special = group.type == NavGroupType.nounChain;

    return Card(
      key: ValueKey(group.id),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    key: ValueKey('title_${group.id}'),
                    initialValue: group.title,
                    decoration: const InputDecoration(
                      labelText: 'Heading',
                      isDense: true,
                    ),
                    onChanged: (v) =>
                        _edit(() => _groups![g] = _groups![g].copyWith(title: v)),
                  ),
                ),
                IconButton(
                  tooltip: 'Move up',
                  onPressed: g > 0 ? () => _moveGroup(g, -1) : null,
                  icon: const Icon(Icons.arrow_upward_rounded),
                ),
                IconButton(
                  tooltip: 'Move down',
                  onPressed: g < _groups!.length - 1
                      ? () => _moveGroup(g, 1)
                      : null,
                  icon: const Icon(Icons.arrow_downward_rounded),
                ),
                IconButton(
                  tooltip: editable
                      ? 'Delete group'
                      : 'Built-in section (cannot delete)',
                  onPressed: editable ? () => _deleteGroup(g) : null,
                  icon: const Icon(Icons.delete_outline_rounded),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2, bottom: 4),
              child: Text(
                switch (group.type) {
                  NavGroupType.quizzes => 'Quizzes',
                  NavGroupType.links => 'Links',
                  NavGroupType.questChain =>
                    'Quest chain — reorder to change the unlock order',
                  NavGroupType.nounChain => 'Noun categories (managed in code)',
                },
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            if (special)
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 4),
                child: Text(
                  'This section is generated automatically; only its heading '
                  'and position can change.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            if (editable || isQuest) ...[
              for (var i = 0; i < group.items.length; i++)
                _itemRow(context, g, i, group),
              if (group.type == NavGroupType.quizzes)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => _addQuiz(g),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Add quiz'),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _itemRow(BuildContext context, int g, int i, NavGroup group) {
    final item = group.items[i];
    final isQuest = group.type == NavGroupType.questChain;
    final questEntry = isQuest ? questEntryByKey(item.ref) : null;
    final section = sectionForContentId(item.ref);
    final icon = navIconFor(
      item.iconKey,
      isQuest
          ? Icons.flag_rounded
          : group.type == NavGroupType.links
          ? Icons.link_rounded
          : (section?.icon ?? Icons.menu_book_rounded),
    );
    final color = navColorFor(
      item.colorIndex,
      section?.accent ?? kSectionAccentColors[0],
    );
    final title = isQuest
        ? (questEntry == null
              ? item.ref
              : '${questEntry.levelLabel} · ${questEntry.displayName}')
        : _itemTitle(item, group.type);
    return Row(
      children: [
        IconBadge(icon: icon, color: color, size: 30),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: item.hidden
                ? TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    decoration: TextDecoration.lineThrough,
                  )
                : null,
          ),
        ),
        if (!isQuest)
          IconButton(
            tooltip: item.hidden ? 'Show' : 'Hide',
            onPressed: () => _setItem(g, i, item.copyWith(hidden: !item.hidden)),
            icon: Icon(
              item.hidden
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
            ),
          ),
        IconButton(
          tooltip: 'Move up',
          onPressed: i > 0 ? () => _moveItem(g, i, -1) : null,
          icon: const Icon(Icons.arrow_upward_rounded),
        ),
        IconButton(
          tooltip: 'Move down',
          onPressed: i < group.items.length - 1
              ? () => _moveItem(g, i, 1)
              : null,
          icon: const Icon(Icons.arrow_downward_rounded),
        ),
        if (group.type == NavGroupType.quizzes)
          IconButton(
            tooltip: 'Edit',
            onPressed: () => _editItem(g, i),
            icon: const Icon(Icons.tune_rounded),
          ),
        if (!isQuest)
          IconButton(
            tooltip: 'Remove',
            onPressed: () => _removeItem(g, i),
            icon: const Icon(Icons.close_rounded),
          ),
      ],
    );
  }
}
